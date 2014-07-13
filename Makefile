# $FreeBSD$

PORTNAME=		puppetdb
PORTVERSION=		2.1.0
CATEGORIES=		databases java
MASTER_SITES=		http://downloads.puppetlabs.com/puppetdb/

MAINTAINER=		xaque208@gmail.com
COMMENT=		The PuppetDB storeconfigs backend

RUN_DEPENDS=		bash>=0:${PORTSDIR}/shells/bash
BUILD_DEPENDS=		rubygem-facter>=0:${PORTSDIR}/sysutils/rubygem-facter \
			rubygem-rake>=0:${PORTSDIR}/devel/rubygem-rake

USE_RC_SUBR=		puppetdb

#LICENSE=		Apache-2.0

USE_JAVA=		yes
USE_RUBY=		yes
USE_RAKE=		yes
NO_BUILD=		yes
JAVA_VERSION=		1.7+

PUPPETDB_USER?=		puppet
PUPPETDB_GROUP?=	puppet
PUPPETDB_LOG_FILE?=	/var/log/puppetdb/puppetdb.log

.if ${PUPPETDB_USER} == "puppet"
USERS=	"puppet"
.endif
.if ${PUPPETDB_GROUP} == "puppet"
GROUPS=	"puppet"
.endif

SUB_LIST+=		JAVA_HOME=${JAVA_HOME} \
			PUPPETDB_USER=${PUPPETDB_USER} \
			PUPPETDB_GROUP=${PUPPETDB_GROUP} \
			PUPPETDB_LOG_FILE=${PUPPETDB_LOG_FILE}

PLIST_SUB+=		PUPPETDB_USER=${PUPPETDB_USER} \
			PUPPETDB_GROUP=${PUPPETDB_GROUP}

.include <bsd.port.pre.mk>

post-patch:
.for file in ext/files/puppetdb ext/files/puppetdb-anonymize ext/files/puppetdb-export \
	ext/files/puppetdb-foreground ext/files/puppetdb-import ext/files/puppetdb-legacy \
	ext/files/puppetdb-ssl-setup ext/files/config.ini ext/files/database.ini Rakefile

	@${REINPLACE_CMD} -e 's|/bin/bash|${PREFIX}/bin/bash|' \
		-e 's|/usr/bin/java|${JAVA}|g' \
		-e 's|su puppetdb|su ${PUPPETDB_USER}|' \
		-e 's|user=puppetdb|user=${PUPPETDB_USER}|' \
		-e 's|/usr/libexec/puppetdb|${PREFIX}/libexec/puppetdb|' \
		-e 's|/usr/share/puppetdb|${DATADIR}|' \
		-e 's|/etc/puppetdb|${ETCDIR}|' \
		-e 's|/etc/puppetlabs/puppetdb|${PREFIX}/etc/puppetlabs/puppetdb|' \
		-e 's|/var/lib/puppetdb|/var/puppetdb|' \
		-e 's|/usr/sbin|${PREFIX}/sbin|' \
		${WRKSRC}/${file}
.endfor

do-install:
	@cd ${WRKSRC} && ${SETENV} DESTDIR=${STAGEDIR} rake install

.include <bsd.port.post.mk>
