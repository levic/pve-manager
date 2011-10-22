include ../../defines.mk

EXTJSDIR=ext-4.0.7-gpl
EXTJSSRC=${EXTJSDIR}.zip

EXTDATA = 					\
	extjs/ext-all.js 			\
	extjs/ext-all-debug.js 			\
	extjs/bootstrap.js

${EXTDATA}: ${EXTJSSRC}
	rm -rf ${EXTJSDIR} extjs
	unzip -x ${EXTJSSRC}
	mv ${EXTJSDIR} extjs

all: ${EXTDATA}

.PHONY: install 
install: ${EXTDATA}
	install -d ${WWWEXT4DIR}
	install -m 0644 ${EXTDATA} ${WWWEXT4DIR}
	install -d ${WWWEXT4DIR}/resources/css
	install -m 0644 extjs/resources/css/ext-all.css ${WWWEXT4DIR}/resources/css
	install -d ${WWWEXT4DIR}/resources/themes/images
	cp -a extjs/resources/themes/images/default ${WWWEXT4DIR}/resources/themes/images
	chown -R www-data:www-data ${WWWEXT4DIR}
	find ${WWWEXT4DIR} -type f -exec chmod -R 0644 '{}' ';'

.PHONY: distclean
distclean: clean

.PHONY: clean
clean:
	rm -rf *~ ${EXTJSDIR} extjs

