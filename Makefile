# $FreeBSD$

PORTNAME=		puppetdb
PORTVERSION=	1.5.2
CATEGORIES=		databases java
MASTER_SITES=	http://downloads.puppetlabs.com/puppetdb/

MAINTAINER=		xaque208@gmail.com
COMMENT=		The PuppetDB storeconfigs backend

RUN_DEPENDS=	rubygem-facter>=0:${PORTSDIR}/sysutils/rubygem-facter \
				rubygem-rake>=0:${PORTSDIR}/devel/rubygem-rake

USE_RC_SUBR=	puppetdb

#LICENSE=		Apache-2.0

USE_JAVA=		yes
USE_RUBY=		yes
USE_RAKE=		yes
NO_BUILD=		yes
JAVA_VERSION=	1.6+

PUPPETDB_USER?=		puppet
PUPPETDB_GROUP?=	puppet
PUPPETDB_LOG_FILE?=	/var/log/puppetdb/puppetdb.log

.if ${PUPPETDB_USER} == "puppet"
USERS=	"puppet"
.endif
.if ${PUPPETDB_GROUP} == "puppet"
GROUPS=	"puppet"
.endif

SUB_LIST+=		JAVA_HOME=${JAVA_HOME} PUPPETDB_USER=${PUPPETDB_USER} PUPPETDB_GROUP=${PUPPETDB_GROUP} PUPPETDB_LOG_FILE=${PUPPETDB_LOG_FILE}

.include <bsd.port.pre.mk>

do-install:
		@cd ${WRKSRC} && ${SETENV} DESTDIR=${STAGEDIR} rake install

.include <bsd.port.post.mk>
