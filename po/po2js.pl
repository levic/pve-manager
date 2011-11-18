#!/usr/bin/perl -w

use strict;
use Locale::PO;
use JSON;

# current limits:
# - we do not support plural. forms
# - no message content support

my $filename = shift || die "no po file specified\n";

# like FNV32a, but we only return 31 bits (positive numbers)
sub fnv31a {
    my ($string) = @_;

    my $hval = 0x811c9dc5;

    foreach my $c (unpack('C*', $string)) {
	$hval ^= $c;
	$hval += (
	    (($hval << 1) ) +
	    (($hval << 4) ) +
	    (($hval << 7) ) +
	    (($hval << 8) ) +
	    (($hval << 24) ) );
	$hval = $hval & 0xffffffff;
    }
    return $hval & 0x7fffffff;
}

my $aref = Locale::PO->load_file_asarray($filename);

my $catalog;

foreach my $po (@$aref) {
    my $qmsgid = $po->msgid;
    my $msgid = $po->dequote($qmsgid);

    next if !length($msgid); # skip header

    my $qmsgstr = $po->msgstr;
    my $msgstr = $po->dequote($qmsgstr);
    my $digest = fnv31a($msgid);

    die "duplicate digest" if $catalog->{$digest};

    $catalog->{$digest} = [ $msgstr ];
    # later, we can add plural forms to the array
}

my $json = encode_json($catalog);

print <<__EOD
// gettext catalog "$filename"

PVE = { i18n_msgcat: $json }

function fnv31a(text) {
    var len = text.length;
    var hval = 0x811c9dc5;
    for (var i = 0; i < len; i++) {
	var c = text.charCodeAt(i);
	hval ^= c;
	hval += (hval << 1) + (hval << 4) + (hval << 7) + (hval << 8) + (hval << 24);
    }
    hval &= 0x7fffffff;
    return hval;
}

function gettext(buf) {
    var digest = fnv31a(buf);
    var data = PVE.i18n_msgcat[digest];
    if (!data) {
	return buf;
    }
    return data[0];
}

__EOD

