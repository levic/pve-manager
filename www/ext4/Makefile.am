include $(top_builddir)/common.mk

EXTJSDIR=ext-4.0.2a
EXTJSSRC=${EXTJSDIR}-gpl.zip

extjs/ext-all.js: ${EXTJSSRC}
	rm -rf ${EXTJSDIR} extjs
	unzip -x ${EXTJSSRC}
	mv ${EXTJSDIR} extjs

ext_DATA = 					\
	extjs/ext-all.js 			\
	extjs/ext-all-debug.js 			\
	extjs/bootstrap.js

extdir = ${WWW_EXTDIR}

extcssdir = ${WWW_EXTDIR}/resources/css
extcss_DATA = 					\
	extjs/resources/css/ext-all.css

install-data-hook:
	mkdir -p ${DESTDIR}/${WWW_EXTDIR}/resources/themes/images
	cp -a extjs/resources/themes/images/default ${DESTDIR}/${WWW_EXTDIR}/resources/themes/images
	chown -R www-data:www-data ${DESTDIR}/${extdir}
	find ${DESTDIR}/${WWW_EXTDIR} -type f -exec chmod -R 0644 '{}' ';'

clean-local:
	-rm -rf *~ ${EXTJSDIR} extjs


