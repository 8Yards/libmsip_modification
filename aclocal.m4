# generated automatically by aclocal 1.11.1 -*- Autoconf -*-

# Copyright (C) 1996, 1997, 1998, 1999, 2000, 2001, 2002, 2003, 2004,
# 2005, 2006, 2007, 2008, 2009  Free Software Foundation, Inc.
# This file is free software; the Free Software Foundation
# gives unlimited permission to copy and/or distribute it,
# with or without modifications, as long as this notice is preserved.

# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY, to the extent permitted by law; without
# even the implied warranty of MERCHANTABILITY or FITNESS FOR A
# PARTICULAR PURPOSE.

m4_ifndef([AC_AUTOCONF_VERSION],
  [m4_copy([m4_PACKAGE_VERSION], [AC_AUTOCONF_VERSION])])dnl
m4_if(m4_defn([AC_AUTOCONF_VERSION]), [2.65],,
[m4_warning([this file was generated for autoconf 2.65.
You have another version of autoconf.  It may work, but is not guaranteed to.
If you have problems, you may need to regenerate the build system entirely.
To do so, use the procedure documented by the package, typically `autoreconf'.])])

# AM_LIBMCRYPTO_ENABLE_FAST_AES()
# -------------------------------
AC_DEFUN([AM_LIBMCRYPTO_ENABLE_FAST_AES], [
AC_ARG_ENABLE(fast-aes,
	AS_HELP_STRING([--enable-fast-aes],
		[enables built-in Rijndael/AES algorithm. (default disabled)]), 
	[], [])
])
# End of AM_LIBMCRYPTO_ENABLE_FAST_AES
#

# AM_LIBMCRYPTO_CHECK_OPENSSL([ACTION-IF-FOUND [, ACTION-IF-NOT-FOUND]])
# -----------------------------
AC_DEFUN([AM_LIBMCRYPTO_CHECK_OPENSSL], [
dnl OpenSSL libcrypto
dnl library check
PKG_CHECK_MODULES(OPENSSL, [openssl])
mcrypto_save_LIBS="${LIBS}"
LIBS="${OPENSSL_LIBS} ${LIBS}"
mcrypto_save_CPPFLAGS="${CPPFLAGS}"
CPPFLAGS="${CPPFLAGS} ${OPENSSL_CFLAGS}"
AC_SEARCH_LIBS([SSLeay], [], [
		HAVE_OPENSSL=1
	],[
		AC_MSG_ERROR([Could not find libcrypto. Please install the corresponding package (provided by the openssl project).])
	])


dnl header check
AC_CHECK_HEADER([openssl/crypto.h],[], [
		AC_MSG_ERROR([Could not the development files for the libcrypto library. Please install the corresponding package (provided by the openssl project).])
	])

# disable OpenSSL AES if user did not ask to use our built-in algorithm
if test x$enable_fast_aes != xyes; then
	AC_CHECK_HEADER([openssl/aes.h],[AC_DEFINE([HAVE_OPENSSL_AES_H], 1, 
		[Define to 1 if you have the <openssl/aes.h> header file.])])
fi

dnl AC_CHECK_FUNC([EVP_sha256], [have_sha256=yes], [])
dnl AM_CONDITIONAL(HAVE_EVP_SHA256, test x${have_sha256} = xyes)

dnl OpenSSL libssl
dnl RedHat fix
AC_DEFINE(OPENSSL_NO_KRB5, [], [No Kerberos in OpenSSL])
AC_SEARCH_LIBS([SSL_library_init], [],
       [
       ],[
               AC_MSG_ERROR([Could not find libssl. Please install the correspo
nding package.])
       ])
AC_CHECK_HEADER([openssl/ssl.h], [],
       [
               AC_MSG_ERROR([Could not find libssl header files. Please install
 the corresponding development package.])
       ])

if test "x${HAVE_OPENSSL}" = "x1"; then
	AC_DEFINE([HAVE_OPENSSL], 1, [Define to 1 if you have OpenSSL.])
	ifelse([$1], , :, [$1])
else
	ifelse([$2], , :, [$2])
fi

dnl AM_CONDITIONAL(HAVE_OPENSSL, test "x${HAVE_OPENSSL}" = "x1")

LIBS="${mcrypto_save_LIBS}"
CPPFLAGS="${mcrypto_save_CPPFLAGS}"

])
# End of AM_LIBMCRYPTO_CHECK_OPENSSL
#

# AM_LIBMCRYPTO_CHECK_OPENSSL_DTLS([ACTION-IF-FOUND [, ACTION-IF-NOT-FOUND]])
# -----------------------------
AC_DEFUN([AM_LIBMCRYPTO_CHECK_OPENSSL_DTLS], [
dnl OpenSSL DTLS

mcrypto_save_LIBS="${LIBS}"
LIBS="${OPENSSL_LIBS} ${LIBS}"
mcrypto_save_CPPFLAGS="${CPPFLAGS}"
CPPFLAGS="${CPPFLAGS} ${OPENSSL_CFLAGS}"

dnl Check for DTLS, requires OpenSSL 0.9.8f or later.
have_dtls=yes
AC_CHECK_HEADER([openssl/dtls1.h], , [have_dtls=no], [
#include <openssl/ssl.h>
])

dnl Check DTLS version magic
AC_MSG_CHECKING([for DTLS version 1.0])
AC_COMPILE_IFELSE([
#include<openssl/ssl.h>
#include<openssl/dtls1.h>

#ifdef DTLS1_VERSION
# if DTLS1_VERSION != 0xFEFF
#  error Bad DTLS1 version
# endif
#else
# error  No DTLS1 version
#endif

int main()
{
    return 0;
}
], [dtls1=yes],[have_dtls=no;dtls1=no])
AC_MSG_RESULT([$dtls1])

 AC_CHECK_FUNC([DTLSv1_method], , [have_dtls=no])
 if test x$have_dtls = xyes; then
 	AC_DEFINE(USE_DTLS, "1", [Define to 1 if you have OpenSSL 0.9.8f or later])dnl
 	ifelse([$1], , :, [$1])
 else
 	ifelse([$2], , :, [$2])
 fi

dnl AM_CONDITIONAL(HAVE_OPENSSL, test "x${HAVE_OPENSSL}" = "x1")

LIBS="${mcrypto_save_LIBS}"
CPPFLAGS="${mcrypto_save_CPPFLAGS}"
])
# End of AM_LIBMCRYPTO_CHECK_OPENSSL_DTLS
#

AC_DEFUN([AM_LIBMCRYPTO_CHECK_SCSIM], [
PKG_CHECK_MODULES([SCSIM], [libpcsclite])

mcrypto_save_LIBS="${LIBS}"
LIBS="${SCSIM_LIBS} ${LIBS}"
AC_CHECK_FUNCS([SCardTransmit],,[AC_MSG_ERROR([PCSC lite not found])])
LIBS="${mcrypto_save_LIBS}"
])

# AM_LIBMCRYPTO_CHECK_GNUTLS([ACTION-IF-FOUND [, ACTION-IF-NOT-FOUND]])
# ----------------------------
AC_DEFUN([AM_LIBMCRYPTO_CHECK_GNUTLS], [
AC_CHECK_LIB([gcrypt], [main],[
		GNUTLS_LIBS="-lgcrypt"
	],[])
AC_CHECK_LIB([gnutls], [main],[
		AC_CHECK_HEADER(gnutls/x509.h)
		GNUTLS_LIBS="-lgnutls"
		AC_DEFINE([HAVE_GNUTLS], 1, [Define to 1 if you have gnutls.])
		HAVE_GNUTLS=yes
	],[])
if test "x${HAVE_GNUTLS}" = "xyes"; then
	ifelse([$1], , :, [$1])
else
	ifelse([$2], , :, [$2])
fi

dnl AM_CONDITIONAL(HAVE_GNUTLS, test "x${HAVE_GNUTLS}" = "xyes")
AC_SUBST(GNUTLS_LIBS)
])
# End of AM_LIBMCRYPTO_CHECK_GNUTLS
#

# AM_MINISIP_CHECK_LIBMCRYPTO(VERSION [,ACTION-IF-FOUND [,ACTION-IF-NOT-FOUND]]))
# ------------------------------------
AC_DEFUN([AM_MINISIP_CHECK_LIBMCRYPTO],[ 
	AC_REQUIRE([AM_MINISIP_CHECK_LIBMNETUTIL]) dnl
	mcrypto_found=yes
dnl	AC_REQUIRE([AM_MINISIP_CHECK_OPENSSL]) dnl
	AC_MINISIP_WITH_ARG(MCRYPTO, mcrypto, libmcrypto, $1, ifelse([$3], , [REQUIRED], [OPTIONAL]), [dnl
dnl if HAVE_OPENSSL
dnl			-lssl -lcrypto dnl
dnl endif
dnl if HAVE_GNUTLS
dnl			-lgnutls
dnl endif
		], ,[mcrypto_found=no])
	if test ! "${mcrypto_found}" = "no"; then
		AC_MINISIP_CHECK_LIBRARY(MCRYPTO, libmcrypto, config.h, mcrypto)
	fi
	if test "${mcrypto_found}" = "yes"; then
		ifelse([$2], , :, [$2])
	else
		ifelse([$3], , [AC_MINISIP_REQUIRED_LIB(MCRYPTO, libmcrypto)], [$3])
	fi
  ])
# End of AM_MINISIP_CHECK_LIBMCRYPTO
#

# AM_MINISIP_CHECK_LIBMCRYPTO_DTLS([ACTION-IF-FOUND [,ACTION-IF-NOT-FOUND]]))
# ------------------------------------
AC_DEFUN([AM_MINISIP_CHECK_LIBMCRYPTO_DTLS],[ 
	AC_REQUIRE([AM_MINISIP_CHECK_LIBMCRYPTO]) dnl
	mcrypto_dtls_found=yes

dnl Checks for DTLS support in libmcrypto
	mcrypto_save_LIBS="$LIBS"
	mcrypto_save_LDFLAGS="$LDFLAGS"
	mcrypto_save_CPPFLAGS="$CPPFLAGS"
	LDFLAGS="$LDFLAGS $LIBMCRYPTO_LDFLAGS"
	LIBS="$MINISIP_LIBS $LIBS"
	CPPFLAGS="$CPPFLAGS $MINISIP_CFLAGS"
	AM_MINISIP_CHECK_WINFUNC(["DTLSSocket::create(0,0,0)"],[mcrypto_dtls_found=yes], [mcrypto_dtls_found=no],[ #include<libmcrypto/DtlsSocket.h> ])
	LIBS="$mcrypto_save_LIBS"
	LDFLAGS="$mcrypto_save_LDFLAGS"
	CPPFLAGS="$mcrypto_save_CPPFLAGS"

	if test "${mcrypto_dtls_found}" = "yes"; then
		AC_DEFINE([HAVE_DTLS], 1, [Define to 1 if you have libmcrypto with DTLS support])
		ifelse([$1], , :, [$1])
	else
		ifelse([$2], , :, [$2])
	fi
  ])
# End of AM_MINISIP_CHECK_LIBMCRYPTO_DTLS
#

# AM_MINISIP_CHECK_LDAP
#-----------------------
AC_DEFUN([AM_MINISIP_CHECK_LDAP], [
	# PKG_CHECK_MODULES([LDAP], [libldap], [liblber])

	mnetutil_save_LIBS="${LIBS}"
	LDAP_LIBS="-lldap -llber"
	LIBS="${LDAP_LIBS} ${LIBS}"
	AC_CHECK_FUNCS([ldap_init],,[AC_MSG_ERROR([OpenLDAP not found])])
	LIBS="${mnetutil_save_LIBS}"
])


# AM_MINISIP_ENABLE_IPV6(VERSION)
# -------------------------------
AC_DEFUN([AM_MINISIP_ENABLE_IPV6],[ 
AC_ARG_ENABLE([ipv6],
    AS_HELP_STRING([--disable-ipv6],
        [disables debug output (default enabled)]), [], [enable_ipv6=yes])
  ])
# End of AM_MINISIP_ENABLE_IPV6
#

# AM_MINISIP_CHECK_IPV6(VERSION)
# ------------------------------
AC_DEFUN([AM_MINISIP_CHECK_IPV6],[ 
if test "${enable_ipv6}" = "yes"
then
	AC_CHECK_TYPES([struct sockaddr_in6],[HAVE_IPV6=yes],,[
#ifdef HAVE_NETINET_IN_H
# include <netinet/in.h>
#endif
#ifdef HAVE_WS2TCPIP_H
# include <ws2tcpip.h>
#endif
])
fi
if test "${HAVE_IPV6}" = "yes"
then
	AC_DEFINE(HAVE_IPV6, [1], [Define to 1 to enable IPv6 support ])
fi
AM_CONDITIONAL(HAVE_IPV6, test "x${HAVE_IPV6}" = "xyes")
  ])
# End of AM_MINISIP_CHECK_IPV6
#

# AM_MINISIP_CHECK_LIBMNETUTIL(VERSION [,ACTION-IF-FOUND [,ACTION-IF-NOT-FOUND]])
# -------------------------------------
AC_DEFUN([AM_MINISIP_CHECK_LIBMNETUTIL],[ 
	AC_REQUIRE([AM_MINISIP_CHECK_LIBMUTIL]) dnl
	mnetutil_found=yes
	AC_MINISIP_WITH_ARG(MNETUTIL, mnetutil, libmnetutil, $1, ifelse([$3], , [REQUIRED], [OPTIONAL]), , ,[mnetutil_found=no])
	if test ! "${mnetutil_found}" = "no"; then
		AC_MINISIP_CHECK_LIBRARY(MNETUTIL, libmnetutil, libmnetutil_config.h, mnetutil, ,[mnetutil_found=no])
	fi

	if test "${mnetutil_found}" = "yes"; then
		ifelse([$2], , :, [$2])
	else
		ifelse([$3], , [AC_MINISIP_REQUIRED_LIB(MNETUTIL, libnetmutil)], [$3])
	fi
  ])
# End of AM_MINISIP_CHECK_LIBMNETUTIL
#

# AM_MINISIP_CHECK_LIBMNETUTIL_SCTP([ACTION-IF-FOUND [,ACTION-IF-NOT-FOUND]])
# ------------------------------------
AC_DEFUN([AM_MINISIP_CHECK_LIBMNETUTIL_SCTP],[ 
	AC_REQUIRE([AM_MINISIP_CHECK_LIBMNETUTIL]) dnl
	mnetutil_sctp_found=yes

dnl Checks for SCTP support in libmnetutil
	mnetutil_save_LIBS="$LIBS"
	mnetutil_save_LDFLAGS="$LDFLAGS"
	mnetutil_save_CPPFLAGS="$CPPFLAGS"
	LDFLAGS="$LDFLAGS $LIBMNETUTIL_LDFLAGS"
	LIBS="$MINISIP_LIBS $LIBS"
	CPPFLAGS="$CPPFLAGS $MINISIP_CFLAGS"
	AM_MINISIP_CHECK_WINFUNC(["adsfasdfasdf()"],,[mnetutil_sctp_found=no],[dnl
#include<libmnetutil/SctpSocket.h>
])
	LIBS="$mnetutil_save_LIBS"
	LDFLAGS="$mnetutil_save_LDFLAGS"
	CPPFLAGS="$mnetutil_save_CPPFLAGS"

	if test "${mnetutil_sctp_found}" = "yes"; then
		AC_DEFINE([HAVE_SCTP], 1, [Define to 1 if you have libmnetutil with SCTP support])
		ifelse([$1], , :, [$1])
	else
		ifelse([$2], , :, [$2])
	fi
  ])
# End of AM_MINISIP_CHECK_LIBMNETUTIL_SCTP
#

dnl  =================================================================
dnl                minisip configure initialization macros

# m4_MINISIP_PACKAGE_VERSION(NAME, PREFIX, MAJOR, MINOR, MICRO)
# -------------------------------------------------------------
m4_define([m4_MINISIP_PACKAGE_VERSION],[
		m4_define([$2_major_version], [$3])
		m4_define([$2_minor_version], [$4])
		m4_define([$2_micro_version], [$5])
		m4_define([$2_version],
			  [$2_major_version.$2_minor_version.$2_micro_version])
		m4_define([MINISIP_PACKAGE_NAME],[$1])
		m4_define([MINISIP_PACKAGE_PREFIX],[$2])
		m4_define([MINISIP_PACKAGE_MACRO],m4_translit([$2],[a-z],[A-Z]))
		m4_define([MINISIP_PACKAGE_VERSION],[$2_version])
	])
# End of m4_MINISIP_PACKAGE_VERSION
#

# m4_MINISIP_PACKAGE_CONTACT(NAME, EMAIL)
# ---------------------------------------
m4_define([m4_MINISIP_PACKAGE_CONTACT],[
		m4_define([MINISIP_PACKAGE_CONTACT],[$1 <$2>])
	])
# End of m4_MINISIP_PACKAGE_CONTACT
#

# m4_MINISIP_LIBRARY_VERSION(CURRENT, REVISION, AGE)
# --------------------------------------------------
m4_define([m4_MINISIP_LIBRARY_VERSION],[
		m4_define([lt_current], [$1])
		m4_define([lt_revision], [$2])
		m4_define([lt_age], [$3])
		m4_define([lt_minus_age], m4_eval(lt_current - lt_age))
	])
# End of m4_MINISIP_LIBRARY_VESRION
#

# AM_MINISIP_VERSION_GEN()
# ------------------------
AC_DEFUN([AM_MINISIP_VERSION_GEN],[
if test -e .version; then
  version=`cat .version`
elif test -e ${srcdir}/.version; then
  version=`cat ${srcdir}/.version`
else
  if test -e ${srcdir}/.svnrevision; then
    svnrevision=`cat ${srcdir}/.svnrevision`
  else
    svnrevision=`LANG=C svnversion -c ${srcdir} | cut -d: -f2`
  fi

  version="MINISIP_PACKAGE_VERSION+r${svnrevision}"
fi

  version_old=

  if test -e version; then
     version_old=`cat version`
  fi

  if test "$version" != "$version_old"; then
     cat > "include/version.h" <<EOF
#define PACKAGE_VERSION_FULL "$version"
#define PACKAGE_STRING_FULL "${PACKAGE_NAME} $version"
EOF

     cat > "version" <<EOF
$version
EOF
  else
     echo "config.status: include/version.h is unchanged"
  fi

  VERSION_FULL=$version
])
# End of AM_MINISIP_VERSION_GEN

# AM_MINISIP_VERSION_INIT()
# ---------------------------------
AC_DEFUN([AM_MINISIP_VERSION_INIT], [

test -d "include" || mkdir "include"

AC_CONFIG_COMMANDS([include/version.h], [
  AM_MINISIP_VERSION_GEN
],[
  PACKAGE_NAME=$PACKAGE_NAME
])

AC_DEFINE([HAVE_VERSION_H], [1], [Define to 1 if you have `include/version.h'])
AC_DEFINE([VERSION], [PACKAGE_VERSION_FULL], [Version number of package])
AC_DEFINE([PACKAGE_VERSION], [PACKAGE_VERSION_FULL], [Define to the version of this package.])
AC_DEFINE([PACKAGE_STRING], [PACKAGE_STRING_FULL], [Define to the full name and version of this package.])
AM_MINISIP_VERSION_GEN

VERSION=$VERSION_FULL
PACKAGE_VERSION=$VERSION_FULL
PACKAGE_STRING="${PACKAGE_NAME} ${VERSION_FULL}"
])
# End of AM_MINISIP_VERSION_INIT

# AM_MINISIP_PACKAGE_INIT()
# -------------------------
AC_DEFUN([AM_MINISIP_PACKAGE_INIT],[
AM_INIT_AUTOMAKE
AM_MAINTAINER_MODE
AC_CANONICAL_BUILD
AC_CANONICAL_HOST
case $host_os in
     *mingw* )
	     os_win=yes
	     ;;
esac
AM_CONDITIONAL(OS_WIN, test x$os_win = xyes)

dnl Checks for programs.
AC_C_BIGENDIAN
AC_PROG_CXX
AC_PROG_CC
AC_PROG_CPP
AC_PROG_LN_S
AC_PROG_MAKE_SET

if test x$os_win = xyes; then
    AC_CHECK_TOOL(WINDRES, [windres])
    if test x$WINDRES = x; then
        AC_MSG_ERROR([Could not find windres in your PATH.])
    fi
fi
AC_LANG(C++)
dnl For now, STL is made mandatory
dnl AC_ARG_ENABLE(stl,
dnl	AS_HELP_STRING([--enable-stl],
dnl		[enables the use of C++ STL (default enabled)]),
dnl		[ 
dnl		if test "${enable_stl}" = "yes"; then
AC_DEFINE(USE_STL, [], [STL enabled])
dnl		fi ])
PKG_PROG_PKG_CONFIG
AM_MINISIP_VERSION_INIT
dnl AM_MINISIP_CHECK_TIME
])
# End of AM_MINISIP_PACKAGE_INIT
#

dnl  =================================================================
dnl               minisip configure check helper macros

# AC_MINISIP_CHECK_LIBTOOL()
# --------------------------
AC_DEFUN([AC_MINISIP_CHECK_LIBTOOL],[
  # check for libtool >= 1.5.7
  minisip_ltvers="`libtoolize --version 2>&1 | \
	perl -e '$x = scalar(<STDIN>); $x =~ /1\.5\.(\d+)/ && print $[]1'`"
  minisip_ltvers_patched="`libtoolize --version 2>&1| \
	perl -e '$y = scalar(<STDIN>); $y =~ /1\.5\.6\.(\d+)/ && print $[]1'`"

  #AC_MSG_WARN([  DEBUG!!!! minisip_ltvers=$minisip_ltvers ])
  #AC_MSG_WARN([  DEBUG!!!! minisip_ltvers_patched=$minisip_ltvers_patched ])
  
  #if >= 1.5.7, or a 1.5.6.1 version (patched), then we won't have problems ...
  if test "${minisip_ltvers}" && test ${minisip_ltvers} -gt 6; then
    minisip_has_lt157=yes
  else
	if test "${minisip_ltvers_patched}" && test ${minisip_ltvers_patched} -gt 0; then
		AC_MSG_WARN([ Detected patched libtool/ltmain.sh (1.5.6.1) ])
		minisip_has_lt156_patched=yes
  	fi
  fi
])
# End of AC_MINISIP_CHECK_LIBTOOL
#

# AM_MINISIP_LIBTOOL_EXTRAS()
# ---------------------------
AC_DEFUN([AM_MINISIP_LIBTOOL_EXTRAS],[
AC_LIBTOOL_DLOPEN
AC_LIBTOOL_WIN32_DLL
AC_MINISIP_CHECK_LIBTOOL
])
# End of AM_MINISIP_LIBTOOL_EXTRAS
#

# AM_MINISIP_ENABLE_DEBUG()
# -------------------------
AC_DEFUN([AM_MINISIP_ENABLE_DEBUG],[
AC_ARG_ENABLE(debug,
	AS_HELP_STRING([--enable-debug],
		[enables debug output. (default disabled)]), [ 
if test "${enable_debug}" = "yes"
then
	AC_DEFINE(DEBUG_OUTPUT, [], [Debug output])
else
	AC_DEFINE(NDEBUG, [], [No debug output])
fi 
		])
AM_CONDITIONAL(DEBUG, test "${enable_debug}" = "yes")
	])
# End of AM_MINISIP_ENABLE_DEBUG
#

# AM_MINISIP_ENABLE_TEST_SUITE()
# ------------------------------
AC_DEFUN([AM_MINISIP_ENABLE_TEST_SUITE],[
AC_ARG_ENABLE(test-suite,
	AS_HELP_STRING([--enable-test-suite],
		[enables extended test suite. (default disabled)]))
if test x${enable_test_suite} = xyes; then
	AC_DEFINE(TEST_SUITE, [], [Build and run extended test suite])
fi 
AM_CONDITIONAL(TEST_SUITE, test x${enable_test_suite} = xyes)
	])
# End of AM_MINISIP_ENABLE_TEST_SUITE
#

# AM_MINISIP_CHECK_TIME
# ----------------------------------
AC_DEFUN([AM_MINISIP_CHECK_TIME],[
	AC_HEADER_TIME
	AC_CHECK_TYPE([struct timezone],[
		EXTERNAL_CFLAGS="$EXTERNAL_CFLAGS -DHAVE_STRUCT_TIMEZONE"
	],,[dnl
#if TIME_WITH_SYS_TIME
# include <sys/time.h>
# include <time.h>
#else
# if HAVE_SYS_TIME_H
#  include <sys/time.h>
# else
#  include <time.h>
# endif
#endif
	])

	AC_CHECK_FUNC([gettimeofday],[
		EXTERNAL_CFLAGS="$EXTERNAL_CFLAGS -DHAVE_GETTIMEOFDAY"
	])

	AC_SUBST(EXTERNAL_CFLAGS)
])
# End of AM_MINISIP_CHECK_TIME
#

dnl  =================================================================
dnl               minisip `configure --with-m*` argument macros

# AC_MINISIP_CHECK_WITH_ARG(MACRO, NAME, LIBS [, ACTION-IF-NOT-FOUND])
# --------------------------------------------
AC_DEFUN([AC_MINISIP_CHECK_WITH_ARG],[
		#AC_MSG_WARN([  withval = ${withval} ])
		if test "x${withval}" = "xyes"; then
			# proceed with default installation
			$1_NEEDS_PKG_CHECK=yes
		else
			# work around for pre-1.5.7 libtool bug:
			#  1.5.6 adds .libs by mistake, so only add that
			#  portion of the path if we have 1.5.7 or later
			#  After this, we also have to fix the library check.
			if test -n "${minisip_has_lt157}"; then
				#AC_MSG_WARN([  minisip_has_lt157 ])
				minisip_lthack='/.libs'
			fi
			if test -n "${minisip_has_lt156_patched}"; then
				#AC_MSG_WARN([  minisip_has_lt156_patched ])
				minisip_lthack='/.libs'
			fi
			if test -d "${withval}/lib"; then
				# specific installation
				$1_LDFLAGS="-L${withval}/lib"
			elif test -d "${withval}/.libs"; then
				# in-tree development
				$1_LDFLAGS="-L${withval}${minisip_lthack}"
			elif test -d "../$2/.libs"; then
				# out-of-tree development
				$1_LDFLAGS="-L`pwd`/../$2${minisip_lthack}"
			else
				ifelse([$4], ,[
				AC_MSG_ERROR([dnl
Unable to find the required libraries in any of the following locations:
	${withval}/lib
	${withval}/.libs
	../$2/.libs

Maybe you forgot to compile $2 first?
])], [$4])
			fi
dnl 			AC_MSG_WARN([  DEBUG_INFO: param1=$1, param2=$2, param3=$3; $1_LDFLAGS=${$1_LDFLAGS} ])
			$1_CFLAGS="-I${withval}/include"
			$1_LIBS="${$1_LDFLAGS} $3"
			AC_SUBST($1_CFLAGS)
			AC_SUBST($1_LIBS)
		fi
	])
# End of AC_MINISIP_CHECK_WITH_ARG
#

# AC_MINISIP_MAYBE_WITH_ARG(MACRO, WITHARG, NAME, TYPE, LIBS [, ACTION-IF-NOT-FOUND]])
# -----------------------------------------------------------
AC_DEFUN([AC_MINISIP_MAYBE_WITH_ARG],[
		if test "x${withval}" = "no"; then
			ifelse([$6], , [AC_MINISIP_$4_LIB($1, $3)], [$6])
		else
			AC_MINISIP_CHECK_WITH_ARG($1, $3, [-l$2 $5], $6)
		fi
	])
# End of AC_MINISIP_MAYBE_WITH_ARG
#

# AC_MINISIP_WITH_ARG(MACRO, WITHARG, NAME, VERSION, TYPE, LIBS [, ACTION-IF-FOUND [, ACTION-IF-NOT-FOUND]])
# --------------------------------------------------------------
AC_DEFUN([AC_MINISIP_WITH_ARG],[
		AC_BEFORE([AM_MINISIP_CHECK_]m4_translit($3, 'a-z', 'A-Z'),
			[AM_MINISIP_CHECK_COMPLETE]) dnl
		AC_PROVIDE([AC_MINISIP_CHECK_PERFORMED]) dnl
		AC_ARG_WITH($2,
			AS_HELP_STRING([--with-$2=PATH], [location of $3]),
			[ AC_MINISIP_MAYBE_WITH_ARG($1, $2, $3, $5, $6, $8) ],
			[ $1_NEEDS_PKG_CHECK=yes ])
		if test "x${$1_NEEDS_PKG_CHECK}" = "xyes"; then
			ifelse([$8], , [dnl
				echo "Check $1 module"
				PKG_CHECK_MODULES($1, [$3 >= $4])
				ifelse([$7], , :, [$7])], [dnl
				PKG_CHECK_EXISTS([$3 >= $4], [dnl
					PKG_CHECK_MODULES($1, [$3 >= $4])
					$7],
					[$8])])
		fi
		MINISIP_CFLAGS="${$1_CFLAGS} ${MINISIP_CFLAGS}"
		MINISIP_LIBS="${$1_LIBS} ${MINISIP_LIBS}"
	])
# End of AC_MINISIP_WITH_ARG
#

# AC_MINISIP_OPTIONAL_LIB(MACRO, NAME)
# ------------------------------------
AC_DEFUN([AC_MINISIP_OPTIONAL_LIB], [ dnl
		AC_MSG_NOTICE([$1 is not present or disabled.]) ])
# End of AC_MINISIP_OPTIONAL_LIB
#

# AC_MINISIP_REQUIRED_LIB(MACRO, NAME)
# ------------------------------------
AC_DEFUN([AC_MINISIP_REQUIRED_LIB], [ dnl 
		AC_MSG_ERROR([$1 is required.]) ])
# End of AC_MINISIP_REQUIRED_LIB
#

# AC_MINISIP_CHECK_LIBRARY(MACRO, NAME, HEADER, LIB [,ACTION-IF-NOT-FOUND])
# --------------------------------------------------
AC_DEFUN([AC_MINISIP_CHECK_LIBRARY], [
		save_CPPFLAGS="${CPPFLAGS}"
		save_LIBS="${LIBS}"
		CPPFLAGS="${$1_CFLAGS} ${CPPFLAGS}"
		LIBS="${$1_LIBS} ${LIBS}"
		AC_CHECK_HEADER([$2/$3],[],[
			AC_MSG_ERROR([You need the $2 headers/library.
Try installing the $2-devel package for your distribution."])])

		# fix library check for pre-1.5.7 libtool:
		#  add the correct path, since the double .libs bug doesn't
		#  seem to affect us here.
		if test -n "${minisip_lthack}"; then
			LIBS="${$1_LDFLAGS}/.libs ${LIBS}"
		fi
		AC_CHECK_LIB([$4], [main], [], [ dnl
				AC_MSG_ERROR([Could not find $2. dnl
Please install the corresponding package.]) dnl
			])
				
		CPPFLAGS="${save_CPPFLAGS}"
		LIBS="${save_LIBS}"
	])
# End of AC_MINISIP_CHECK_LIBRARY
#

dnl  =================================================================
dnl                   minisip configure completion macros

# AC_MINISIP_VERSION_SUBST(MACRO, PREFIX)
# ---------------------------------------
AC_DEFUN([AC_MINISIP_VERSION_SUBST], [
		$1_MAJOR_VERSION=$2_major_version
		$1_MINOR_VERSION=$2_minor_version
		$1_MICRO_VERSION=$2_micro_version
		AC_SUBST($1_MAJOR_VERSION) dnl
		AC_SUBST($1_MINOR_VERSION) dnl
		AC_SUBST($1_MICRO_VERSION) dnl
	])
# End of AM_MINISIP_VERSION_SUBST
#

# AC_MINISIP_CHECK_PERFORMED()
# ------------------------------------
AC_DEFUN([AC_MINISIP_CHECK_PERFORMED], [ dnl
		AC_MSG_ERROR([MINISIP_CHECK_COMPLETE called before any MINISIP_CHECK_* calls]) ])
# End of AC_MINISIP_CHECK_PERFORMED
#

# AM_MINISIP_CHECK_NOTHING()
# --------------------------
AC_DEFUN([AM_MINISIP_CHECK_NOTHING], [ dnl
		AC_PROVIDE([AC_MINISIP_CHECK_PERFORMED]) ])
# End of AM_MINISIP_CHECK_NOTHING
#


# AC_MINISIP_CHECK_COMPLETE()
# ---------------------------
AC_DEFUN([AM_MINISIP_CHECK_COMPLETE],[ 
		AC_REQUIRE([AC_MINISIP_CHECK_PERFORMED])
		MINISIP_CFLAGS="-I\$(top_srcdir)/include ${MINISIP_CFLAGS}"
		AC_SUBST(MINISIP_CFLAGS)
		AC_SUBST(MINISIP_LIBS)
		dnl process AM_MINISIP_PACKAGE_VERSION
		AC_MINISIP_VERSION_SUBST( 
			MINISIP_PACKAGE_MACRO,
			MINISIP_PACKAGE_PREFIX) dnl
		dnl process AM_MINISIP_LIBRARY_VERSION if it was invoked
		if test x"lt_current" != "xlt_current"; then
			LT_VERSION_INFO="lt_current:lt_revision:lt_age"
			LT_CURRENT_MINUS_AGE="lt_minus_age"
			AC_SUBST(LT_VERSION_INFO) dnl
			AC_SUBST(LT_CURRENT_MINUS_AGE) dnl
			m_no_undef="-Wl,--no-undefined -no-undefined"
			m_lt_version="-version-info ${LT_VERSION_INFO}"
			MINISIP_LIBRARY_LDFLAGS="${m_no_undef} ${m_lt_version}"
			AC_SUBST(MINISIP_LIBRARY_LDFLAGS) dnl
		fi
		AC_SUBST(ACLOCAL_FLAGS)
	])
# End of AC_MINISIP_CHECK_COMPLETE
#


dnl  =================================================================
dnl                          libmutil macros

# AM_MINISIP_CHECK_LIBMUTIL(VERSION [, ACTION-IF-FOUND [, ACTION-IF-NOT-FOUND]])
# ----------------------------------
AC_DEFUN([AM_MINISIP_CHECK_LIBMUTIL],[
	mutil_found=yes 
	AC_MINISIP_WITH_ARG(MUTIL, mutil, libmutil, $1, ifelse([$3], , [REQUIRED], [OPTIONAL]), ,[mutil_found=yes], [mutil_found=no])
	if test ! "${mutil_found}" = "no"; then
		AC_MINISIP_CHECK_LIBRARY(MUTIL, libmutil, libmutil_config.h, mutil,, mutil_found=no)
	fi
		
	if test "${mutil_found}" = "yes"; then
		ifelse([$2], , :, [$2])
	else
		ifelse([$3], , [AC_MINISIP_REQUIRED_LIB(MUTIL, libmutil)], [$3])
	fi
  ])
# End of AM_MINISIP_CHECK_LIBMUTIL
#

# Checking for stdcall Windows functions.
# Copyright (C) 2006 Mikael Magnusson
#
# Based on functions.m4 in autoconf 2.69a
#
# Copyright (C) 2000, 2001, 2002, 2003 Free Software Foundation, Inc.
#
# This program is free software; you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation; either version 2, or (at your option)
# any later version.
#
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License
# along with this program; if not, write to the Free Software
# Foundation, Inc., 51 Franklin St, Fifth Floor, Boston MA
# 02110-1301, USA.
#
# As a special exception, the Free Software Foundation gives unlimited
# permission to copy, distribute and modify the configure scripts that
# are the output of Autoconf.  You need not follow the terms of the GNU
# General Public License when using or distributing such scripts, even
# though portions of the text of Autoconf appear in them.  The GNU
# General Public License (GPL) does govern all other use of the material
# that constitutes the Autoconf program.
#
# Certain portions of the Autoconf source text are designed to be copied
# (in certain cases, depending on the input) into the output of
# Autoconf.  We call these the "data" portions.  The rest of the Autoconf
# source text consists of comments plus executable code that decides which
# of the data portions to output in any given case.  We call these
# comments and executable code the "non-data" portions.  Autoconf never
# copies any of the non-data portions into its output.
#
# This special exception to the GPL applies to versions of Autoconf
# released by the Free Software Foundation.  When you make and
# distribute a modified version of Autoconf, you may extend this special
# exception to the GPL to apply to your modified version as well, *unless*
# your modified version has the potential to copy into its output some
# of the text that was the non-data portion of the version that you started
# with.  (In other words, unless your change moves or copies text from
# the non-data portions to the data portions.)  If your modification has
# such potential, you must delete any notice of this special exception
# to the GPL from your modified version.
#
# Written by David MacKenzie, with help from
# Franc,ois Pinard, Karl Berry, Richard Pixley, Ian Lance Taylor,
# Roland McGrath, Noah Friedman, david d zuhn, and many others.

#
# AM_MINISIP_CHECK_WINFUNC(FUNCTION, [ACTION-IF-FOUND], [ACTION-IF-NOT-FOUND],  [INCLUDES])
# -----------------------------------------------------------------
AC_DEFUN([AM_MINISIP_CHECK_WINFUNC],
[ac_func_name=`echo $1|sed -e 's/^\(.*\)(.*)$/\1/'`
AS_VAR_PUSHDEF([ac_var], [ac_cv_func_${ac_func_name}])dnl
AC_CACHE_CHECK([for ${ac_func_name}], ac_var,
[AC_LINK_IFELSE([
AC_INCLUDES_DEFAULT([$4])

int main(){
    $1;
    return 0;
}
],
                [AS_VAR_SET(ac_var, yes)],
                [AS_VAR_SET(ac_var, no)])])
AS_IF([test AS_VAR_GET(ac_var) = yes], [$2], [$3])dnl
AS_VAR_POPDEF([ac_var])dnl
])# AM_MINISIP_CHECK_WINFUNC

# AM_MINISIP_CHECK_WINFUNCS(FUNCTION..., [ACTION-IF-FOUND], [ACTION-IF-NOT-FOUND],[INCLUDES])
# ---------------------------------------------------------------------
AC_DEFUN([AM_MINISIP_CHECK_WINFUNCS],
[AC_FOREACH([AC_Func], [$1],
 [m4_pushdef([AC_Func_Name],m4_bpatsubst(m4_bpatsubst(AC_Func, ["], []),
					 [(.*)],
					 []))dnl
  AH_TEMPLATE([AS_TR_CPP(HAVE_[]AC_Func_Name)],
               [Define to 1 if you have the `]AC_Func_Name[' function.])dnl
  m4_popdef([AC_Func_Name])])dnl
for ac_func in $1
do
ac_func_name=`echo $ac_func|sed -e 's/^\(.*\)(.*)$/\1/'`
AM_MINISIP_CHECK_WINFUNC($ac_func,
              [AC_DEFINE_UNQUOTED([AS_TR_CPP([HAVE_$ac_func_name])]) $2],
              [$3], [$4])dnl
done
])

# pkg.m4 - Macros to locate and utilise pkg-config.            -*- Autoconf -*-
# 
# Copyright © 2004 Scott James Remnant <scott@netsplit.com>.
#
# This program is free software; you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation; either version 2 of the License, or
# (at your option) any later version.
#
# This program is distributed in the hope that it will be useful, but
# WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
# General Public License for more details.
#
# You should have received a copy of the GNU General Public License
# along with this program; if not, write to the Free Software
# Foundation, Inc., 59 Temple Place - Suite 330, Boston, MA 02111-1307, USA.
#
# As a special exception to the GNU General Public License, if you
# distribute this file as part of a program that contains a
# configuration script generated by Autoconf, you may include it under
# the same distribution terms that you use for the rest of that program.

# PKG_PROG_PKG_CONFIG([MIN-VERSION])
# ----------------------------------
AC_DEFUN([PKG_PROG_PKG_CONFIG],
[m4_pattern_forbid([^_?PKG_[A-Z_]+$])
m4_pattern_allow([^PKG_CONFIG(_PATH)?$])
AC_ARG_VAR([PKG_CONFIG], [path to pkg-config utility])dnl
if test "x$ac_cv_env_PKG_CONFIG_set" != "xset"; then
	AC_PATH_TOOL([PKG_CONFIG], [pkg-config])
fi
if test -n "$PKG_CONFIG"; then
	_pkg_min_version=m4_default([$1], [0.9.0])
	AC_MSG_CHECKING([pkg-config is at least version $_pkg_min_version])
	if $PKG_CONFIG --atleast-pkgconfig-version $_pkg_min_version; then
		AC_MSG_RESULT([yes])
	else
		AC_MSG_RESULT([no])
		PKG_CONFIG=""
	fi
		
fi[]dnl
])# PKG_PROG_PKG_CONFIG

# PKG_CHECK_EXISTS(MODULES, [ACTION-IF-FOUND], [ACTION-IF-NOT-FOUND])
#
# Check to see whether a particular set of modules exists.  Similar
# to PKG_CHECK_MODULES(), but does not set variables or print errors.
#
#
# Similar to PKG_CHECK_MODULES, make sure that the first instance of
# this or PKG_CHECK_MODULES is called, or make sure to call
# PKG_CHECK_EXISTS manually
# --------------------------------------------------------------
AC_DEFUN([PKG_CHECK_EXISTS],
[AC_REQUIRE([PKG_PROG_PKG_CONFIG])dnl
if test -n "$PKG_CONFIG" && \
    AC_RUN_LOG([$PKG_CONFIG --exists --print-errors "$1"]); then
  m4_ifval([$2], [$2], [:])
m4_ifvaln([$3], [else
  $3])dnl
fi])


# _PKG_CONFIG([VARIABLE], [COMMAND], [MODULES])
# ---------------------------------------------
m4_define([_PKG_CONFIG],
[if test -n "$PKG_CONFIG"; then
    if test -n "$$1"; then
        pkg_cv_[]$1="$$1"
    else
        PKG_CHECK_EXISTS([$3],
                         [pkg_cv_[]$1=`$PKG_CONFIG --[]$2 "$3" 2>/dev/null`],
			 [pkg_failed=yes])
    fi
else
	pkg_failed=untried
fi[]dnl
])# _PKG_CONFIG

# _PKG_SHORT_ERRORS_SUPPORTED
# -----------------------------
AC_DEFUN([_PKG_SHORT_ERRORS_SUPPORTED],
[AC_REQUIRE([PKG_PROG_PKG_CONFIG])
if $PKG_CONFIG --atleast-pkgconfig-version 0.20; then
        _pkg_short_errors_supported=yes
else
        _pkg_short_errors_supported=no
fi[]dnl
])# _PKG_SHORT_ERRORS_SUPPORTED


# PKG_CHECK_MODULES(VARIABLE-PREFIX, MODULES, [ACTION-IF-FOUND],
# [ACTION-IF-NOT-FOUND])
#
#
# Note that if there is a possibility the first call to
# PKG_CHECK_MODULES might not happen, you should be sure to include an
# explicit call to PKG_PROG_PKG_CONFIG in your configure.ac
#
#
# --------------------------------------------------------------
AC_DEFUN([PKG_CHECK_MODULES],
[AC_REQUIRE([PKG_PROG_PKG_CONFIG])dnl
AC_ARG_VAR([$1][_CFLAGS], [C compiler flags for $1, overriding pkg-config])dnl
AC_ARG_VAR([$1][_LIBS], [linker flags for $1, overriding pkg-config])dnl

pkg_failed=no
AC_MSG_CHECKING([for $1])

_PKG_CONFIG([$1][_CFLAGS], [cflags], [$2])
_PKG_CONFIG([$1][_LIBS], [libs], [$2])

m4_define([_PKG_TEXT], [Alternatively, you may set the environment variables $1[]_CFLAGS
and $1[]_LIBS to avoid the need to call pkg-config.
See the pkg-config man page for more details.])

if test $pkg_failed = yes; then
        _PKG_SHORT_ERRORS_SUPPORTED
        if test $_pkg_short_errors_supported = yes; then
	        $1[]_PKG_ERRORS=`$PKG_CONFIG --short-errors --errors-to-stdout --print-errors "$2"`
        else 
	        $1[]_PKG_ERRORS=`$PKG_CONFIG --errors-to-stdout --print-errors "$2"`
        fi
	# Put the nasty error message in config.log where it belongs
	echo "$$1[]_PKG_ERRORS" >&AS_MESSAGE_LOG_FD

	ifelse([$4], , [AC_MSG_ERROR(dnl
[Package requirements ($2) were not met:

$$1_PKG_ERRORS

Consider adjusting the PKG_CONFIG_PATH environment variable if you
installed software in a non-standard prefix.

_PKG_TEXT
])],
		[AC_MSG_RESULT([no])
                $4])
elif test $pkg_failed = untried; then
	ifelse([$4], , [AC_MSG_FAILURE(dnl
[The pkg-config script could not be found or is too old.  Make sure it
is in your PATH or set the PKG_CONFIG environment variable to the full
path to pkg-config.

_PKG_TEXT

To get pkg-config, see <http://pkg-config.freedesktop.org/>.])],
		[$4])
else
	$1[]_CFLAGS=$pkg_cv_[]$1[]_CFLAGS
	$1[]_LIBS=$pkg_cv_[]$1[]_LIBS
        AC_MSG_RESULT([yes])
	ifelse([$3], , :, [$3])
fi[]dnl
])# PKG_CHECK_MODULES

# Copyright (C) 2002, 2003, 2005, 2006, 2007, 2008  Free Software Foundation, Inc.
#
# This file is free software; the Free Software Foundation
# gives unlimited permission to copy and/or distribute it,
# with or without modifications, as long as this notice is preserved.

# AM_AUTOMAKE_VERSION(VERSION)
# ----------------------------
# Automake X.Y traces this macro to ensure aclocal.m4 has been
# generated from the m4 files accompanying Automake X.Y.
# (This private macro should not be called outside this file.)
AC_DEFUN([AM_AUTOMAKE_VERSION],
[am__api_version='1.11'
dnl Some users find AM_AUTOMAKE_VERSION and mistake it for a way to
dnl require some minimum version.  Point them to the right macro.
m4_if([$1], [1.11.1], [],
      [AC_FATAL([Do not call $0, use AM_INIT_AUTOMAKE([$1]).])])dnl
])

# _AM_AUTOCONF_VERSION(VERSION)
# -----------------------------
# aclocal traces this macro to find the Autoconf version.
# This is a private macro too.  Using m4_define simplifies
# the logic in aclocal, which can simply ignore this definition.
m4_define([_AM_AUTOCONF_VERSION], [])

# AM_SET_CURRENT_AUTOMAKE_VERSION
# -------------------------------
# Call AM_AUTOMAKE_VERSION and AM_AUTOMAKE_VERSION so they can be traced.
# This function is AC_REQUIREd by AM_INIT_AUTOMAKE.
AC_DEFUN([AM_SET_CURRENT_AUTOMAKE_VERSION],
[AM_AUTOMAKE_VERSION([1.11.1])dnl
m4_ifndef([AC_AUTOCONF_VERSION],
  [m4_copy([m4_PACKAGE_VERSION], [AC_AUTOCONF_VERSION])])dnl
_AM_AUTOCONF_VERSION(m4_defn([AC_AUTOCONF_VERSION]))])

# AM_AUX_DIR_EXPAND                                         -*- Autoconf -*-

# Copyright (C) 2001, 2003, 2005  Free Software Foundation, Inc.
#
# This file is free software; the Free Software Foundation
# gives unlimited permission to copy and/or distribute it,
# with or without modifications, as long as this notice is preserved.

# For projects using AC_CONFIG_AUX_DIR([foo]), Autoconf sets
# $ac_aux_dir to `$srcdir/foo'.  In other projects, it is set to
# `$srcdir', `$srcdir/..', or `$srcdir/../..'.
#
# Of course, Automake must honor this variable whenever it calls a
# tool from the auxiliary directory.  The problem is that $srcdir (and
# therefore $ac_aux_dir as well) can be either absolute or relative,
# depending on how configure is run.  This is pretty annoying, since
# it makes $ac_aux_dir quite unusable in subdirectories: in the top
# source directory, any form will work fine, but in subdirectories a
# relative path needs to be adjusted first.
#
# $ac_aux_dir/missing
#    fails when called from a subdirectory if $ac_aux_dir is relative
# $top_srcdir/$ac_aux_dir/missing
#    fails if $ac_aux_dir is absolute,
#    fails when called from a subdirectory in a VPATH build with
#          a relative $ac_aux_dir
#
# The reason of the latter failure is that $top_srcdir and $ac_aux_dir
# are both prefixed by $srcdir.  In an in-source build this is usually
# harmless because $srcdir is `.', but things will broke when you
# start a VPATH build or use an absolute $srcdir.
#
# So we could use something similar to $top_srcdir/$ac_aux_dir/missing,
# iff we strip the leading $srcdir from $ac_aux_dir.  That would be:
#   am_aux_dir='\$(top_srcdir)/'`expr "$ac_aux_dir" : "$srcdir//*\(.*\)"`
# and then we would define $MISSING as
#   MISSING="\${SHELL} $am_aux_dir/missing"
# This will work as long as MISSING is not called from configure, because
# unfortunately $(top_srcdir) has no meaning in configure.
# However there are other variables, like CC, which are often used in
# configure, and could therefore not use this "fixed" $ac_aux_dir.
#
# Another solution, used here, is to always expand $ac_aux_dir to an
# absolute PATH.  The drawback is that using absolute paths prevent a
# configured tree to be moved without reconfiguration.

AC_DEFUN([AM_AUX_DIR_EXPAND],
[dnl Rely on autoconf to set up CDPATH properly.
AC_PREREQ([2.50])dnl
# expand $ac_aux_dir to an absolute path
am_aux_dir=`cd $ac_aux_dir && pwd`
])

# AM_CONDITIONAL                                            -*- Autoconf -*-

# Copyright (C) 1997, 2000, 2001, 2003, 2004, 2005, 2006, 2008
# Free Software Foundation, Inc.
#
# This file is free software; the Free Software Foundation
# gives unlimited permission to copy and/or distribute it,
# with or without modifications, as long as this notice is preserved.

# serial 9

# AM_CONDITIONAL(NAME, SHELL-CONDITION)
# -------------------------------------
# Define a conditional.
AC_DEFUN([AM_CONDITIONAL],
[AC_PREREQ(2.52)dnl
 ifelse([$1], [TRUE],  [AC_FATAL([$0: invalid condition: $1])],
	[$1], [FALSE], [AC_FATAL([$0: invalid condition: $1])])dnl
AC_SUBST([$1_TRUE])dnl
AC_SUBST([$1_FALSE])dnl
_AM_SUBST_NOTMAKE([$1_TRUE])dnl
_AM_SUBST_NOTMAKE([$1_FALSE])dnl
m4_define([_AM_COND_VALUE_$1], [$2])dnl
if $2; then
  $1_TRUE=
  $1_FALSE='#'
else
  $1_TRUE='#'
  $1_FALSE=
fi
AC_CONFIG_COMMANDS_PRE(
[if test -z "${$1_TRUE}" && test -z "${$1_FALSE}"; then
  AC_MSG_ERROR([[conditional "$1" was never defined.
Usually this means the macro was only invoked conditionally.]])
fi])])

# Copyright (C) 1999, 2000, 2001, 2002, 2003, 2004, 2005, 2006, 2009
# Free Software Foundation, Inc.
#
# This file is free software; the Free Software Foundation
# gives unlimited permission to copy and/or distribute it,
# with or without modifications, as long as this notice is preserved.

# serial 10

# There are a few dirty hacks below to avoid letting `AC_PROG_CC' be
# written in clear, in which case automake, when reading aclocal.m4,
# will think it sees a *use*, and therefore will trigger all it's
# C support machinery.  Also note that it means that autoscan, seeing
# CC etc. in the Makefile, will ask for an AC_PROG_CC use...


# _AM_DEPENDENCIES(NAME)
# ----------------------
# See how the compiler implements dependency checking.
# NAME is "CC", "CXX", "GCJ", or "OBJC".
# We try a few techniques and use that to set a single cache variable.
#
# We don't AC_REQUIRE the corresponding AC_PROG_CC since the latter was
# modified to invoke _AM_DEPENDENCIES(CC); we would have a circular
# dependency, and given that the user is not expected to run this macro,
# just rely on AC_PROG_CC.
AC_DEFUN([_AM_DEPENDENCIES],
[AC_REQUIRE([AM_SET_DEPDIR])dnl
AC_REQUIRE([AM_OUTPUT_DEPENDENCY_COMMANDS])dnl
AC_REQUIRE([AM_MAKE_INCLUDE])dnl
AC_REQUIRE([AM_DEP_TRACK])dnl

ifelse([$1], CC,   [depcc="$CC"   am_compiler_list=],
       [$1], CXX,  [depcc="$CXX"  am_compiler_list=],
       [$1], OBJC, [depcc="$OBJC" am_compiler_list='gcc3 gcc'],
       [$1], UPC,  [depcc="$UPC"  am_compiler_list=],
       [$1], GCJ,  [depcc="$GCJ"  am_compiler_list='gcc3 gcc'],
                   [depcc="$$1"   am_compiler_list=])

AC_CACHE_CHECK([dependency style of $depcc],
               [am_cv_$1_dependencies_compiler_type],
[if test -z "$AMDEP_TRUE" && test -f "$am_depcomp"; then
  # We make a subdir and do the tests there.  Otherwise we can end up
  # making bogus files that we don't know about and never remove.  For
  # instance it was reported that on HP-UX the gcc test will end up
  # making a dummy file named `D' -- because `-MD' means `put the output
  # in D'.
  mkdir conftest.dir
  # Copy depcomp to subdir because otherwise we won't find it if we're
  # using a relative directory.
  cp "$am_depcomp" conftest.dir
  cd conftest.dir
  # We will build objects and dependencies in a subdirectory because
  # it helps to detect inapplicable dependency modes.  For instance
  # both Tru64's cc and ICC support -MD to output dependencies as a
  # side effect of compilation, but ICC will put the dependencies in
  # the current directory while Tru64 will put them in the object
  # directory.
  mkdir sub

  am_cv_$1_dependencies_compiler_type=none
  if test "$am_compiler_list" = ""; then
     am_compiler_list=`sed -n ['s/^#*\([a-zA-Z0-9]*\))$/\1/p'] < ./depcomp`
  fi
  am__universal=false
  m4_case([$1], [CC],
    [case " $depcc " in #(
     *\ -arch\ *\ -arch\ *) am__universal=true ;;
     esac],
    [CXX],
    [case " $depcc " in #(
     *\ -arch\ *\ -arch\ *) am__universal=true ;;
     esac])

  for depmode in $am_compiler_list; do
    # Setup a source with many dependencies, because some compilers
    # like to wrap large dependency lists on column 80 (with \), and
    # we should not choose a depcomp mode which is confused by this.
    #
    # We need to recreate these files for each test, as the compiler may
    # overwrite some of them when testing with obscure command lines.
    # This happens at least with the AIX C compiler.
    : > sub/conftest.c
    for i in 1 2 3 4 5 6; do
      echo '#include "conftst'$i'.h"' >> sub/conftest.c
      # Using `: > sub/conftst$i.h' creates only sub/conftst1.h with
      # Solaris 8's {/usr,}/bin/sh.
      touch sub/conftst$i.h
    done
    echo "${am__include} ${am__quote}sub/conftest.Po${am__quote}" > confmf

    # We check with `-c' and `-o' for the sake of the "dashmstdout"
    # mode.  It turns out that the SunPro C++ compiler does not properly
    # handle `-M -o', and we need to detect this.  Also, some Intel
    # versions had trouble with output in subdirs
    am__obj=sub/conftest.${OBJEXT-o}
    am__minus_obj="-o $am__obj"
    case $depmode in
    gcc)
      # This depmode causes a compiler race in universal mode.
      test "$am__universal" = false || continue
      ;;
    nosideeffect)
      # after this tag, mechanisms are not by side-effect, so they'll
      # only be used when explicitly requested
      if test "x$enable_dependency_tracking" = xyes; then
	continue
      else
	break
      fi
      ;;
    msvisualcpp | msvcmsys)
      # This compiler won't grok `-c -o', but also, the minuso test has
      # not run yet.  These depmodes are late enough in the game, and
      # so weak that their functioning should not be impacted.
      am__obj=conftest.${OBJEXT-o}
      am__minus_obj=
      ;;
    none) break ;;
    esac
    if depmode=$depmode \
       source=sub/conftest.c object=$am__obj \
       depfile=sub/conftest.Po tmpdepfile=sub/conftest.TPo \
       $SHELL ./depcomp $depcc -c $am__minus_obj sub/conftest.c \
         >/dev/null 2>conftest.err &&
       grep sub/conftst1.h sub/conftest.Po > /dev/null 2>&1 &&
       grep sub/conftst6.h sub/conftest.Po > /dev/null 2>&1 &&
       grep $am__obj sub/conftest.Po > /dev/null 2>&1 &&
       ${MAKE-make} -s -f confmf > /dev/null 2>&1; then
      # icc doesn't choke on unknown options, it will just issue warnings
      # or remarks (even with -Werror).  So we grep stderr for any message
      # that says an option was ignored or not supported.
      # When given -MP, icc 7.0 and 7.1 complain thusly:
      #   icc: Command line warning: ignoring option '-M'; no argument required
      # The diagnosis changed in icc 8.0:
      #   icc: Command line remark: option '-MP' not supported
      if (grep 'ignoring option' conftest.err ||
          grep 'not supported' conftest.err) >/dev/null 2>&1; then :; else
        am_cv_$1_dependencies_compiler_type=$depmode
        break
      fi
    fi
  done

  cd ..
  rm -rf conftest.dir
else
  am_cv_$1_dependencies_compiler_type=none
fi
])
AC_SUBST([$1DEPMODE], [depmode=$am_cv_$1_dependencies_compiler_type])
AM_CONDITIONAL([am__fastdep$1], [
  test "x$enable_dependency_tracking" != xno \
  && test "$am_cv_$1_dependencies_compiler_type" = gcc3])
])


# AM_SET_DEPDIR
# -------------
# Choose a directory name for dependency files.
# This macro is AC_REQUIREd in _AM_DEPENDENCIES
AC_DEFUN([AM_SET_DEPDIR],
[AC_REQUIRE([AM_SET_LEADING_DOT])dnl
AC_SUBST([DEPDIR], ["${am__leading_dot}deps"])dnl
])


# AM_DEP_TRACK
# ------------
AC_DEFUN([AM_DEP_TRACK],
[AC_ARG_ENABLE(dependency-tracking,
[  --disable-dependency-tracking  speeds up one-time build
  --enable-dependency-tracking   do not reject slow dependency extractors])
if test "x$enable_dependency_tracking" != xno; then
  am_depcomp="$ac_aux_dir/depcomp"
  AMDEPBACKSLASH='\'
fi
AM_CONDITIONAL([AMDEP], [test "x$enable_dependency_tracking" != xno])
AC_SUBST([AMDEPBACKSLASH])dnl
_AM_SUBST_NOTMAKE([AMDEPBACKSLASH])dnl
])

# Generate code to set up dependency tracking.              -*- Autoconf -*-

# Copyright (C) 1999, 2000, 2001, 2002, 2003, 2004, 2005, 2008
# Free Software Foundation, Inc.
#
# This file is free software; the Free Software Foundation
# gives unlimited permission to copy and/or distribute it,
# with or without modifications, as long as this notice is preserved.

#serial 5

# _AM_OUTPUT_DEPENDENCY_COMMANDS
# ------------------------------
AC_DEFUN([_AM_OUTPUT_DEPENDENCY_COMMANDS],
[{
  # Autoconf 2.62 quotes --file arguments for eval, but not when files
  # are listed without --file.  Let's play safe and only enable the eval
  # if we detect the quoting.
  case $CONFIG_FILES in
  *\'*) eval set x "$CONFIG_FILES" ;;
  *)   set x $CONFIG_FILES ;;
  esac
  shift
  for mf
  do
    # Strip MF so we end up with the name of the file.
    mf=`echo "$mf" | sed -e 's/:.*$//'`
    # Check whether this is an Automake generated Makefile or not.
    # We used to match only the files named `Makefile.in', but
    # some people rename them; so instead we look at the file content.
    # Grep'ing the first line is not enough: some people post-process
    # each Makefile.in and add a new line on top of each file to say so.
    # Grep'ing the whole file is not good either: AIX grep has a line
    # limit of 2048, but all sed's we know have understand at least 4000.
    if sed -n 's,^#.*generated by automake.*,X,p' "$mf" | grep X >/dev/null 2>&1; then
      dirpart=`AS_DIRNAME("$mf")`
    else
      continue
    fi
    # Extract the definition of DEPDIR, am__include, and am__quote
    # from the Makefile without running `make'.
    DEPDIR=`sed -n 's/^DEPDIR = //p' < "$mf"`
    test -z "$DEPDIR" && continue
    am__include=`sed -n 's/^am__include = //p' < "$mf"`
    test -z "am__include" && continue
    am__quote=`sed -n 's/^am__quote = //p' < "$mf"`
    # When using ansi2knr, U may be empty or an underscore; expand it
    U=`sed -n 's/^U = //p' < "$mf"`
    # Find all dependency output files, they are included files with
    # $(DEPDIR) in their names.  We invoke sed twice because it is the
    # simplest approach to changing $(DEPDIR) to its actual value in the
    # expansion.
    for file in `sed -n "
      s/^$am__include $am__quote\(.*(DEPDIR).*\)$am__quote"'$/\1/p' <"$mf" | \
	 sed -e 's/\$(DEPDIR)/'"$DEPDIR"'/g' -e 's/\$U/'"$U"'/g'`; do
      # Make sure the directory exists.
      test -f "$dirpart/$file" && continue
      fdir=`AS_DIRNAME(["$file"])`
      AS_MKDIR_P([$dirpart/$fdir])
      # echo "creating $dirpart/$file"
      echo '# dummy' > "$dirpart/$file"
    done
  done
}
])# _AM_OUTPUT_DEPENDENCY_COMMANDS


# AM_OUTPUT_DEPENDENCY_COMMANDS
# -----------------------------
# This macro should only be invoked once -- use via AC_REQUIRE.
#
# This code is only required when automatic dependency tracking
# is enabled.  FIXME.  This creates each `.P' file that we will
# need in order to bootstrap the dependency handling code.
AC_DEFUN([AM_OUTPUT_DEPENDENCY_COMMANDS],
[AC_CONFIG_COMMANDS([depfiles],
     [test x"$AMDEP_TRUE" != x"" || _AM_OUTPUT_DEPENDENCY_COMMANDS],
     [AMDEP_TRUE="$AMDEP_TRUE" ac_aux_dir="$ac_aux_dir"])
])

# Copyright (C) 1996, 1997, 2000, 2001, 2003, 2005
# Free Software Foundation, Inc.
#
# This file is free software; the Free Software Foundation
# gives unlimited permission to copy and/or distribute it,
# with or without modifications, as long as this notice is preserved.

# serial 8

# AM_CONFIG_HEADER is obsolete.  It has been replaced by AC_CONFIG_HEADERS.
AU_DEFUN([AM_CONFIG_HEADER], [AC_CONFIG_HEADERS($@)])

# Do all the work for Automake.                             -*- Autoconf -*-

# Copyright (C) 1996, 1997, 1998, 1999, 2000, 2001, 2002, 2003, 2004,
# 2005, 2006, 2008, 2009 Free Software Foundation, Inc.
#
# This file is free software; the Free Software Foundation
# gives unlimited permission to copy and/or distribute it,
# with or without modifications, as long as this notice is preserved.

# serial 16

# This macro actually does too much.  Some checks are only needed if
# your package does certain things.  But this isn't really a big deal.

# AM_INIT_AUTOMAKE(PACKAGE, VERSION, [NO-DEFINE])
# AM_INIT_AUTOMAKE([OPTIONS])
# -----------------------------------------------
# The call with PACKAGE and VERSION arguments is the old style
# call (pre autoconf-2.50), which is being phased out.  PACKAGE
# and VERSION should now be passed to AC_INIT and removed from
# the call to AM_INIT_AUTOMAKE.
# We support both call styles for the transition.  After
# the next Automake release, Autoconf can make the AC_INIT
# arguments mandatory, and then we can depend on a new Autoconf
# release and drop the old call support.
AC_DEFUN([AM_INIT_AUTOMAKE],
[AC_PREREQ([2.62])dnl
dnl Autoconf wants to disallow AM_ names.  We explicitly allow
dnl the ones we care about.
m4_pattern_allow([^AM_[A-Z]+FLAGS$])dnl
AC_REQUIRE([AM_SET_CURRENT_AUTOMAKE_VERSION])dnl
AC_REQUIRE([AC_PROG_INSTALL])dnl
if test "`cd $srcdir && pwd`" != "`pwd`"; then
  # Use -I$(srcdir) only when $(srcdir) != ., so that make's output
  # is not polluted with repeated "-I."
  AC_SUBST([am__isrc], [' -I$(srcdir)'])_AM_SUBST_NOTMAKE([am__isrc])dnl
  # test to see if srcdir already configured
  if test -f $srcdir/config.status; then
    AC_MSG_ERROR([source directory already configured; run "make distclean" there first])
  fi
fi

# test whether we have cygpath
if test -z "$CYGPATH_W"; then
  if (cygpath --version) >/dev/null 2>/dev/null; then
    CYGPATH_W='cygpath -w'
  else
    CYGPATH_W=echo
  fi
fi
AC_SUBST([CYGPATH_W])

# Define the identity of the package.
dnl Distinguish between old-style and new-style calls.
m4_ifval([$2],
[m4_ifval([$3], [_AM_SET_OPTION([no-define])])dnl
 AC_SUBST([PACKAGE], [$1])dnl
 AC_SUBST([VERSION], [$2])],
[_AM_SET_OPTIONS([$1])dnl
dnl Diagnose old-style AC_INIT with new-style AM_AUTOMAKE_INIT.
m4_if(m4_ifdef([AC_PACKAGE_NAME], 1)m4_ifdef([AC_PACKAGE_VERSION], 1), 11,,
  [m4_fatal([AC_INIT should be called with package and version arguments])])dnl
 AC_SUBST([PACKAGE], ['AC_PACKAGE_TARNAME'])dnl
 AC_SUBST([VERSION], ['AC_PACKAGE_VERSION'])])dnl

_AM_IF_OPTION([no-define],,
[AC_DEFINE_UNQUOTED(PACKAGE, "$PACKAGE", [Name of package])
 AC_DEFINE_UNQUOTED(VERSION, "$VERSION", [Version number of package])])dnl

# Some tools Automake needs.
AC_REQUIRE([AM_SANITY_CHECK])dnl
AC_REQUIRE([AC_ARG_PROGRAM])dnl
AM_MISSING_PROG(ACLOCAL, aclocal-${am__api_version})
AM_MISSING_PROG(AUTOCONF, autoconf)
AM_MISSING_PROG(AUTOMAKE, automake-${am__api_version})
AM_MISSING_PROG(AUTOHEADER, autoheader)
AM_MISSING_PROG(MAKEINFO, makeinfo)
AC_REQUIRE([AM_PROG_INSTALL_SH])dnl
AC_REQUIRE([AM_PROG_INSTALL_STRIP])dnl
AC_REQUIRE([AM_PROG_MKDIR_P])dnl
# We need awk for the "check" target.  The system "awk" is bad on
# some platforms.
AC_REQUIRE([AC_PROG_AWK])dnl
AC_REQUIRE([AC_PROG_MAKE_SET])dnl
AC_REQUIRE([AM_SET_LEADING_DOT])dnl
_AM_IF_OPTION([tar-ustar], [_AM_PROG_TAR([ustar])],
	      [_AM_IF_OPTION([tar-pax], [_AM_PROG_TAR([pax])],
			     [_AM_PROG_TAR([v7])])])
_AM_IF_OPTION([no-dependencies],,
[AC_PROVIDE_IFELSE([AC_PROG_CC],
		  [_AM_DEPENDENCIES(CC)],
		  [define([AC_PROG_CC],
			  defn([AC_PROG_CC])[_AM_DEPENDENCIES(CC)])])dnl
AC_PROVIDE_IFELSE([AC_PROG_CXX],
		  [_AM_DEPENDENCIES(CXX)],
		  [define([AC_PROG_CXX],
			  defn([AC_PROG_CXX])[_AM_DEPENDENCIES(CXX)])])dnl
AC_PROVIDE_IFELSE([AC_PROG_OBJC],
		  [_AM_DEPENDENCIES(OBJC)],
		  [define([AC_PROG_OBJC],
			  defn([AC_PROG_OBJC])[_AM_DEPENDENCIES(OBJC)])])dnl
])
_AM_IF_OPTION([silent-rules], [AC_REQUIRE([AM_SILENT_RULES])])dnl
dnl The `parallel-tests' driver may need to know about EXEEXT, so add the
dnl `am__EXEEXT' conditional if _AM_COMPILER_EXEEXT was seen.  This macro
dnl is hooked onto _AC_COMPILER_EXEEXT early, see below.
AC_CONFIG_COMMANDS_PRE(dnl
[m4_provide_if([_AM_COMPILER_EXEEXT],
  [AM_CONDITIONAL([am__EXEEXT], [test -n "$EXEEXT"])])])dnl
])

dnl Hook into `_AC_COMPILER_EXEEXT' early to learn its expansion.  Do not
dnl add the conditional right here, as _AC_COMPILER_EXEEXT may be further
dnl mangled by Autoconf and run in a shell conditional statement.
m4_define([_AC_COMPILER_EXEEXT],
m4_defn([_AC_COMPILER_EXEEXT])[m4_provide([_AM_COMPILER_EXEEXT])])


# When config.status generates a header, we must update the stamp-h file.
# This file resides in the same directory as the config header
# that is generated.  The stamp files are numbered to have different names.

# Autoconf calls _AC_AM_CONFIG_HEADER_HOOK (when defined) in the
# loop where config.status creates the headers, so we can generate
# our stamp files there.
AC_DEFUN([_AC_AM_CONFIG_HEADER_HOOK],
[# Compute $1's index in $config_headers.
_am_arg=$1
_am_stamp_count=1
for _am_header in $config_headers :; do
  case $_am_header in
    $_am_arg | $_am_arg:* )
      break ;;
    * )
      _am_stamp_count=`expr $_am_stamp_count + 1` ;;
  esac
done
echo "timestamp for $_am_arg" >`AS_DIRNAME(["$_am_arg"])`/stamp-h[]$_am_stamp_count])

# Copyright (C) 2001, 2003, 2005, 2008  Free Software Foundation, Inc.
#
# This file is free software; the Free Software Foundation
# gives unlimited permission to copy and/or distribute it,
# with or without modifications, as long as this notice is preserved.

# AM_PROG_INSTALL_SH
# ------------------
# Define $install_sh.
AC_DEFUN([AM_PROG_INSTALL_SH],
[AC_REQUIRE([AM_AUX_DIR_EXPAND])dnl
if test x"${install_sh}" != xset; then
  case $am_aux_dir in
  *\ * | *\	*)
    install_sh="\${SHELL} '$am_aux_dir/install-sh'" ;;
  *)
    install_sh="\${SHELL} $am_aux_dir/install-sh"
  esac
fi
AC_SUBST(install_sh)])

# Copyright (C) 2003, 2005  Free Software Foundation, Inc.
#
# This file is free software; the Free Software Foundation
# gives unlimited permission to copy and/or distribute it,
# with or without modifications, as long as this notice is preserved.

# serial 2

# Check whether the underlying file-system supports filenames
# with a leading dot.  For instance MS-DOS doesn't.
AC_DEFUN([AM_SET_LEADING_DOT],
[rm -rf .tst 2>/dev/null
mkdir .tst 2>/dev/null
if test -d .tst; then
  am__leading_dot=.
else
  am__leading_dot=_
fi
rmdir .tst 2>/dev/null
AC_SUBST([am__leading_dot])])

# Add --enable-maintainer-mode option to configure.         -*- Autoconf -*-
# From Jim Meyering

# Copyright (C) 1996, 1998, 2000, 2001, 2002, 2003, 2004, 2005, 2008
# Free Software Foundation, Inc.
#
# This file is free software; the Free Software Foundation
# gives unlimited permission to copy and/or distribute it,
# with or without modifications, as long as this notice is preserved.

# serial 5

# AM_MAINTAINER_MODE([DEFAULT-MODE])
# ----------------------------------
# Control maintainer-specific portions of Makefiles.
# Default is to disable them, unless `enable' is passed literally.
# For symmetry, `disable' may be passed as well.  Anyway, the user
# can override the default with the --enable/--disable switch.
AC_DEFUN([AM_MAINTAINER_MODE],
[m4_case(m4_default([$1], [disable]),
       [enable], [m4_define([am_maintainer_other], [disable])],
       [disable], [m4_define([am_maintainer_other], [enable])],
       [m4_define([am_maintainer_other], [enable])
        m4_warn([syntax], [unexpected argument to AM@&t@_MAINTAINER_MODE: $1])])
AC_MSG_CHECKING([whether to am_maintainer_other maintainer-specific portions of Makefiles])
  dnl maintainer-mode's default is 'disable' unless 'enable' is passed
  AC_ARG_ENABLE([maintainer-mode],
[  --][am_maintainer_other][-maintainer-mode  am_maintainer_other make rules and dependencies not useful
			  (and sometimes confusing) to the casual installer],
      [USE_MAINTAINER_MODE=$enableval],
      [USE_MAINTAINER_MODE=]m4_if(am_maintainer_other, [enable], [no], [yes]))
  AC_MSG_RESULT([$USE_MAINTAINER_MODE])
  AM_CONDITIONAL([MAINTAINER_MODE], [test $USE_MAINTAINER_MODE = yes])
  MAINT=$MAINTAINER_MODE_TRUE
  AC_SUBST([MAINT])dnl
]
)

AU_DEFUN([jm_MAINTAINER_MODE], [AM_MAINTAINER_MODE])

# Check to see how 'make' treats includes.	            -*- Autoconf -*-

# Copyright (C) 2001, 2002, 2003, 2005, 2009  Free Software Foundation, Inc.
#
# This file is free software; the Free Software Foundation
# gives unlimited permission to copy and/or distribute it,
# with or without modifications, as long as this notice is preserved.

# serial 4

# AM_MAKE_INCLUDE()
# -----------------
# Check to see how make treats includes.
AC_DEFUN([AM_MAKE_INCLUDE],
[am_make=${MAKE-make}
cat > confinc << 'END'
am__doit:
	@echo this is the am__doit target
.PHONY: am__doit
END
# If we don't find an include directive, just comment out the code.
AC_MSG_CHECKING([for style of include used by $am_make])
am__include="#"
am__quote=
_am_result=none
# First try GNU make style include.
echo "include confinc" > confmf
# Ignore all kinds of additional output from `make'.
case `$am_make -s -f confmf 2> /dev/null` in #(
*the\ am__doit\ target*)
  am__include=include
  am__quote=
  _am_result=GNU
  ;;
esac
# Now try BSD make style include.
if test "$am__include" = "#"; then
   echo '.include "confinc"' > confmf
   case `$am_make -s -f confmf 2> /dev/null` in #(
   *the\ am__doit\ target*)
     am__include=.include
     am__quote="\""
     _am_result=BSD
     ;;
   esac
fi
AC_SUBST([am__include])
AC_SUBST([am__quote])
AC_MSG_RESULT([$_am_result])
rm -f confinc confmf
])

# Fake the existence of programs that GNU maintainers use.  -*- Autoconf -*-

# Copyright (C) 1997, 1999, 2000, 2001, 2003, 2004, 2005, 2008
# Free Software Foundation, Inc.
#
# This file is free software; the Free Software Foundation
# gives unlimited permission to copy and/or distribute it,
# with or without modifications, as long as this notice is preserved.

# serial 6

# AM_MISSING_PROG(NAME, PROGRAM)
# ------------------------------
AC_DEFUN([AM_MISSING_PROG],
[AC_REQUIRE([AM_MISSING_HAS_RUN])
$1=${$1-"${am_missing_run}$2"}
AC_SUBST($1)])


# AM_MISSING_HAS_RUN
# ------------------
# Define MISSING if not defined so far and test if it supports --run.
# If it does, set am_missing_run to use it, otherwise, to nothing.
AC_DEFUN([AM_MISSING_HAS_RUN],
[AC_REQUIRE([AM_AUX_DIR_EXPAND])dnl
AC_REQUIRE_AUX_FILE([missing])dnl
if test x"${MISSING+set}" != xset; then
  case $am_aux_dir in
  *\ * | *\	*)
    MISSING="\${SHELL} \"$am_aux_dir/missing\"" ;;
  *)
    MISSING="\${SHELL} $am_aux_dir/missing" ;;
  esac
fi
# Use eval to expand $SHELL
if eval "$MISSING --run true"; then
  am_missing_run="$MISSING --run "
else
  am_missing_run=
  AC_MSG_WARN([`missing' script is too old or missing])
fi
])

# Copyright (C) 2003, 2004, 2005, 2006  Free Software Foundation, Inc.
#
# This file is free software; the Free Software Foundation
# gives unlimited permission to copy and/or distribute it,
# with or without modifications, as long as this notice is preserved.

# AM_PROG_MKDIR_P
# ---------------
# Check for `mkdir -p'.
AC_DEFUN([AM_PROG_MKDIR_P],
[AC_PREREQ([2.60])dnl
AC_REQUIRE([AC_PROG_MKDIR_P])dnl
dnl Automake 1.8 to 1.9.6 used to define mkdir_p.  We now use MKDIR_P,
dnl while keeping a definition of mkdir_p for backward compatibility.
dnl @MKDIR_P@ is magic: AC_OUTPUT adjusts its value for each Makefile.
dnl However we cannot define mkdir_p as $(MKDIR_P) for the sake of
dnl Makefile.ins that do not define MKDIR_P, so we do our own
dnl adjustment using top_builddir (which is defined more often than
dnl MKDIR_P).
AC_SUBST([mkdir_p], ["$MKDIR_P"])dnl
case $mkdir_p in
  [[\\/$]]* | ?:[[\\/]]*) ;;
  */*) mkdir_p="\$(top_builddir)/$mkdir_p" ;;
esac
])

# Helper functions for option handling.                     -*- Autoconf -*-

# Copyright (C) 2001, 2002, 2003, 2005, 2008  Free Software Foundation, Inc.
#
# This file is free software; the Free Software Foundation
# gives unlimited permission to copy and/or distribute it,
# with or without modifications, as long as this notice is preserved.

# serial 4

# _AM_MANGLE_OPTION(NAME)
# -----------------------
AC_DEFUN([_AM_MANGLE_OPTION],
[[_AM_OPTION_]m4_bpatsubst($1, [[^a-zA-Z0-9_]], [_])])

# _AM_SET_OPTION(NAME)
# ------------------------------
# Set option NAME.  Presently that only means defining a flag for this option.
AC_DEFUN([_AM_SET_OPTION],
[m4_define(_AM_MANGLE_OPTION([$1]), 1)])

# _AM_SET_OPTIONS(OPTIONS)
# ----------------------------------
# OPTIONS is a space-separated list of Automake options.
AC_DEFUN([_AM_SET_OPTIONS],
[m4_foreach_w([_AM_Option], [$1], [_AM_SET_OPTION(_AM_Option)])])

# _AM_IF_OPTION(OPTION, IF-SET, [IF-NOT-SET])
# -------------------------------------------
# Execute IF-SET if OPTION is set, IF-NOT-SET otherwise.
AC_DEFUN([_AM_IF_OPTION],
[m4_ifset(_AM_MANGLE_OPTION([$1]), [$2], [$3])])

# Check to make sure that the build environment is sane.    -*- Autoconf -*-

# Copyright (C) 1996, 1997, 2000, 2001, 2003, 2005, 2008
# Free Software Foundation, Inc.
#
# This file is free software; the Free Software Foundation
# gives unlimited permission to copy and/or distribute it,
# with or without modifications, as long as this notice is preserved.

# serial 5

# AM_SANITY_CHECK
# ---------------
AC_DEFUN([AM_SANITY_CHECK],
[AC_MSG_CHECKING([whether build environment is sane])
# Just in case
sleep 1
echo timestamp > conftest.file
# Reject unsafe characters in $srcdir or the absolute working directory
# name.  Accept space and tab only in the latter.
am_lf='
'
case `pwd` in
  *[[\\\"\#\$\&\'\`$am_lf]]*)
    AC_MSG_ERROR([unsafe absolute working directory name]);;
esac
case $srcdir in
  *[[\\\"\#\$\&\'\`$am_lf\ \	]]*)
    AC_MSG_ERROR([unsafe srcdir value: `$srcdir']);;
esac

# Do `set' in a subshell so we don't clobber the current shell's
# arguments.  Must try -L first in case configure is actually a
# symlink; some systems play weird games with the mod time of symlinks
# (eg FreeBSD returns the mod time of the symlink's containing
# directory).
if (
   set X `ls -Lt "$srcdir/configure" conftest.file 2> /dev/null`
   if test "$[*]" = "X"; then
      # -L didn't work.
      set X `ls -t "$srcdir/configure" conftest.file`
   fi
   rm -f conftest.file
   if test "$[*]" != "X $srcdir/configure conftest.file" \
      && test "$[*]" != "X conftest.file $srcdir/configure"; then

      # If neither matched, then we have a broken ls.  This can happen
      # if, for instance, CONFIG_SHELL is bash and it inherits a
      # broken ls alias from the environment.  This has actually
      # happened.  Such a system could not be considered "sane".
      AC_MSG_ERROR([ls -t appears to fail.  Make sure there is not a broken
alias in your environment])
   fi

   test "$[2]" = conftest.file
   )
then
   # Ok.
   :
else
   AC_MSG_ERROR([newly created file is older than distributed files!
Check your system clock])
fi
AC_MSG_RESULT(yes)])

# Copyright (C) 2001, 2003, 2005  Free Software Foundation, Inc.
#
# This file is free software; the Free Software Foundation
# gives unlimited permission to copy and/or distribute it,
# with or without modifications, as long as this notice is preserved.

# AM_PROG_INSTALL_STRIP
# ---------------------
# One issue with vendor `install' (even GNU) is that you can't
# specify the program used to strip binaries.  This is especially
# annoying in cross-compiling environments, where the build's strip
# is unlikely to handle the host's binaries.
# Fortunately install-sh will honor a STRIPPROG variable, so we
# always use install-sh in `make install-strip', and initialize
# STRIPPROG with the value of the STRIP variable (set by the user).
AC_DEFUN([AM_PROG_INSTALL_STRIP],
[AC_REQUIRE([AM_PROG_INSTALL_SH])dnl
# Installed binaries are usually stripped using `strip' when the user
# run `make install-strip'.  However `strip' might not be the right
# tool to use in cross-compilation environments, therefore Automake
# will honor the `STRIP' environment variable to overrule this program.
dnl Don't test for $cross_compiling = yes, because it might be `maybe'.
if test "$cross_compiling" != no; then
  AC_CHECK_TOOL([STRIP], [strip], :)
fi
INSTALL_STRIP_PROGRAM="\$(install_sh) -c -s"
AC_SUBST([INSTALL_STRIP_PROGRAM])])

# Copyright (C) 2006, 2008  Free Software Foundation, Inc.
#
# This file is free software; the Free Software Foundation
# gives unlimited permission to copy and/or distribute it,
# with or without modifications, as long as this notice is preserved.

# serial 2

# _AM_SUBST_NOTMAKE(VARIABLE)
# ---------------------------
# Prevent Automake from outputting VARIABLE = @VARIABLE@ in Makefile.in.
# This macro is traced by Automake.
AC_DEFUN([_AM_SUBST_NOTMAKE])

# AM_SUBST_NOTMAKE(VARIABLE)
# ---------------------------
# Public sister of _AM_SUBST_NOTMAKE.
AC_DEFUN([AM_SUBST_NOTMAKE], [_AM_SUBST_NOTMAKE($@)])

# Check how to create a tarball.                            -*- Autoconf -*-

# Copyright (C) 2004, 2005  Free Software Foundation, Inc.
#
# This file is free software; the Free Software Foundation
# gives unlimited permission to copy and/or distribute it,
# with or without modifications, as long as this notice is preserved.

# serial 2

# _AM_PROG_TAR(FORMAT)
# --------------------
# Check how to create a tarball in format FORMAT.
# FORMAT should be one of `v7', `ustar', or `pax'.
#
# Substitute a variable $(am__tar) that is a command
# writing to stdout a FORMAT-tarball containing the directory
# $tardir.
#     tardir=directory && $(am__tar) > result.tar
#
# Substitute a variable $(am__untar) that extract such
# a tarball read from stdin.
#     $(am__untar) < result.tar
AC_DEFUN([_AM_PROG_TAR],
[# Always define AMTAR for backward compatibility.
AM_MISSING_PROG([AMTAR], [tar])
m4_if([$1], [v7],
     [am__tar='${AMTAR} chof - "$$tardir"'; am__untar='${AMTAR} xf -'],
     [m4_case([$1], [ustar],, [pax],,
              [m4_fatal([Unknown tar format])])
AC_MSG_CHECKING([how to create a $1 tar archive])
# Loop over all known methods to create a tar archive until one works.
_am_tools='gnutar m4_if([$1], [ustar], [plaintar]) pax cpio none'
_am_tools=${am_cv_prog_tar_$1-$_am_tools}
# Do not fold the above two line into one, because Tru64 sh and
# Solaris sh will not grok spaces in the rhs of `-'.
for _am_tool in $_am_tools
do
  case $_am_tool in
  gnutar)
    for _am_tar in tar gnutar gtar;
    do
      AM_RUN_LOG([$_am_tar --version]) && break
    done
    am__tar="$_am_tar --format=m4_if([$1], [pax], [posix], [$1]) -chf - "'"$$tardir"'
    am__tar_="$_am_tar --format=m4_if([$1], [pax], [posix], [$1]) -chf - "'"$tardir"'
    am__untar="$_am_tar -xf -"
    ;;
  plaintar)
    # Must skip GNU tar: if it does not support --format= it doesn't create
    # ustar tarball either.
    (tar --version) >/dev/null 2>&1 && continue
    am__tar='tar chf - "$$tardir"'
    am__tar_='tar chf - "$tardir"'
    am__untar='tar xf -'
    ;;
  pax)
    am__tar='pax -L -x $1 -w "$$tardir"'
    am__tar_='pax -L -x $1 -w "$tardir"'
    am__untar='pax -r'
    ;;
  cpio)
    am__tar='find "$$tardir" -print | cpio -o -H $1 -L'
    am__tar_='find "$tardir" -print | cpio -o -H $1 -L'
    am__untar='cpio -i -H $1 -d'
    ;;
  none)
    am__tar=false
    am__tar_=false
    am__untar=false
    ;;
  esac

  # If the value was cached, stop now.  We just wanted to have am__tar
  # and am__untar set.
  test -n "${am_cv_prog_tar_$1}" && break

  # tar/untar a dummy directory, and stop if the command works
  rm -rf conftest.dir
  mkdir conftest.dir
  echo GrepMe > conftest.dir/file
  AM_RUN_LOG([tardir=conftest.dir && eval $am__tar_ >conftest.tar])
  rm -rf conftest.dir
  if test -s conftest.tar; then
    AM_RUN_LOG([$am__untar <conftest.tar])
    grep GrepMe conftest.dir/file >/dev/null 2>&1 && break
  fi
done
rm -rf conftest.dir

AC_CACHE_VAL([am_cv_prog_tar_$1], [am_cv_prog_tar_$1=$_am_tool])
AC_MSG_RESULT([$am_cv_prog_tar_$1])])
AC_SUBST([am__tar])
AC_SUBST([am__untar])
]) # _AM_PROG_TAR

m4_include([m4/libtool.m4])
m4_include([m4/ltoptions.m4])
m4_include([m4/ltsugar.m4])
m4_include([m4/ltversion.m4])
m4_include([m4/lt~obsolete.m4])
