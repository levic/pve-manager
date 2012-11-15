include ../defines.mk

LINGUAS=de it fr ja es sv ru tr zh_CN da ca pl sl nb nn

all: $(patsubst %, pve-lang-%.js, $(LINGUAS))

.PHONY: update-po
update-po:
	./jsgettext.pl ../www/manager
	for i in $(LINGUAS); do echo -n "$$i: ";msgmerge -s -v $$i.po messages.pot >$$i.po.tmp; mv $$i.po.tmp $$i.po; done

# try to generate po files when someone add a new language
.SECONDARY: # do not delete generated intermediate file
%.po:
	msginit -i messages.pot -l $*

pve-lang-%.js: %.po
	./po2js.pl $< >$@.tmp
	mv $@.tmp $@

.PHONY: install 
install: $(patsubst %, pve-lang-%.js, $(LINGUAS))
	install -m 0644 -o www-data -g www-data $^ ${WWWROOTDIR}

clean:
	rm -rf *~ *.po.tmp *.js.tmp pve-lang-*.js