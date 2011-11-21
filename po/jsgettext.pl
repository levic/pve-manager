#!/usr/bin/perl

use strict;
use Time::Local;
use PVE::Tools;
use Locale::PO;

my $dir = shift;


die "no such directory\n" if ! -d $dir;

my $sources = [];

my $findcmd = ['find', $dir, '-name', '*.js'];
PVE::Tools::run_command($findcmd, outfunc => sub {
    my $line = shift;
    next if $line =~ m|/pvemanagerlib.js$|;
    push @$sources, $line;
});

my $filename = "messages.pot";

my $header = <<__EOD;
SOME DESCRIPTIVE TITLE.
Copyright (C) 20011 Proxmox Server Solutions GmbH
This file is distributed under the same license as the pve-manager package.
Proxmox Support Team <support\@proxmox.com>, 2011.
__EOD

my $ctime = scalar localtime;

my $href = {};
my $po = new Locale::PO(-msgid=> '',
			-comment=> $header,
			-fuzzy=> 1,
			-msgstr=>
			"Project-Id-Version: pve-manager 2.0\\n" .
			"Report-Msgid-Bugs-To: <support\@proxmox.com>\\n" .
			"POT-Creation-Date: $ctime\\n" .
			"PO-Revision-Date: YEAR-MO-DA HO:MI +ZONE\\n" .
			"Last-Translator: FULL NAME <EMAIL\@ADDRESS>\\n" .
			"Language-Team: LANGUAGE <support\@proxmox.com>\\n" .
			"MIME-Version: 1.0\\n" .
			"Content-Type: text/plain; charset=CHARSET\\n" .
			"Content-Transfer-Encoding: 8bit\\n");

$href->{''} = $po;

sub extract_msg {
    my ($filename, $linenr, $line) = @_;

    my $text;
    if ($line =~ m/\Wgettext\s*\("((?:[^"\\]++|\\.)*+)"\)/) {
	$text = $1;
    } elsif ($line =~ m/\Wgettext\s*\('((?:[^'\\]++|\\.)*+)'\)/) {
	$text = $1;
    } else {
	die "can't extract gettext message in '$filename' line $linenr\n";
    }

    my $ref = "$filename:$linenr";

    if (my $po = $href->{$text}) {
	$po->reference($po->reference() . " $ref");
	return;
    }

    my $po = new Locale::PO(-msgid=> $text, -reference=> $ref, -msgstr=> '');
    $href->{$text} = $po;
}


foreach my $s (@$sources) {
    open(SRC, $s) || die "unable to open file '$s' - $!\n";
    while(defined(my $line = <SRC>)) {
	if ($line =~ m/gettext/) {
	    extract_msg($s, $., $line);
	}
    }
    close(SRC);
}

Locale::PO->save_file_fromhash($filename, $href);

