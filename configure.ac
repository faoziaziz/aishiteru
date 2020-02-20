# -*-Shell-script-*-
#
# Copyright (c) Luc Vincent

# ----------------------------------------
# Initialization
# ----------------------------------------
AC_PREREQ([2.63])
AC_INIT([aishiteru],
        [m4_esyscmd_s([test -d .git && git describe --abbrev=4 || cat VERSION])],
        [https://github.com/faoziaziz/aishiteru/issues],,
        [https://github.com/faoziazizr/aishiteru/])

# Store command like options for CXXFLAGS
OLD_CXXFLAGS=$CXXFLAGS
AC_PROG_CXX([g++ clang++])
# reset compiler flags to initial flags
AC_LANG([C++])
AC_LANG_COMPILER_REQUIRE
CXXFLAGS=${CXXFLAGS:-""}
AC_CONFIG_MACRO_DIR([m4])
AC_CONFIG_AUX_DIR([config])
AC_CONFIG_SRCDIR([src/api/aishiterumain.cpp])
AC_PREFIX_DEFAULT([/usr/local])

# Automake configuration. Do not require README file (we use README.md).
AM_INIT_AUTOMAKE([foreign subdir-objects])

# Define date of package, etc. Could be useful in auto-generated
# documentation.
PACKAGE_YEAR=2018
PACKAGE_DATE="10/29"

abs_top_srcdir=`AS_DIRNAME([$0])`

AC_DEFINE_UNQUOTED([PACKAGE_NAME], ["${PACKAGE_NAME}"], [Name of package])
AC_DEFINE_UNQUOTED([PACKAGE_VERSION], ["${PACKAGE_VERSION}"], [Version number])
AC_DEFINE_UNQUOTED([PACKAGE_YEAR], ["$PACKAGE_YEAR"], [Official year for this release])
AC_DEFINE_UNQUOTED([PACKAGE_DATE], ["$PACKAGE_DATE"], [Official date of release])

AC_SUBST([PACKAGE_NAME])
AC_SUBST([PACKAGE_VERSION])
AC_SUBST([PACKAGE_YEAR])
AC_SUBST([PACKAGE_DATE])

GENERIC_LIBRARY_NAME=aishiteru

# Release versioning. Get versions from PACKAGE_VERSION.
AX_SPLIT_VERSION
GENERIC_MAJOR_VERSION=$(echo "$AX_MAJOR_VERSION" | $SED 's/^[[^0-9]]*//')
GENERIC_MINOR_VERSION=$AX_MINOR_VERSION
GENERIC_MICRO_VERSION=`echo "$AX_POINT_VERSION" | $SED 's/^\([[0-9]][[0-9]]*\).*/\1/'`

# API version (often = GENERIC_MAJOR_VERSION.GENERIC_MINOR_VERSION)
GENERIC_API_VERSION=$GENERIC_MAJOR_VERSION.$GENERIC_MINOR_VERSION
GENERIC_LIBRARY_VERSION=$GENERIC_MAJOR_VERSION:$GENERIC_MINOR_VERSION
AC_SUBST([GENERIC_API_VERSION])
AC_SUBST([GENERIC_MAJOR_VERSION])
AC_SUBST([GENERIC_MINOR_VERSION])


AC_SUBST([GENERIC_LIBRARY_VERSION])
PACKAGE=$GENERIC_LIBRARY_NAME
AC_SUBST([GENERIC_LIBRARY_NAME])

GENERIC_VERSION=$GENERIC_MAJOR_VERSION.$GENERIC_MINOR_VERSION.$GENERIC_MICRO_VERSION
GENERIC_RELEASE=$GENERIC_MAJOR_VERSION.$GENERIC_MINOR_VERSION
AC_SUBST([GENERIC_RELEASE])
AC_SUBST([GENERIC_VERSION])

AC_CONFIG_HEADERS([config_auto.h:config/config.h.in])

# default conditional
AM_CONDITIONAL([T_WIN], false)
AM_CONDITIONAL([OSX], false)
AM_CONDITIONAL([GRAPHICS_DISABLED], false)
AC_SUBST([AM_CPPFLAGS])

#############################
#
# Platform specific setup
#
#############################
# The test code used by AX_CHECK_COMPILE_FLAG uses an empty statement
# and unused macros which must not raise a compiler error, but it must
# be an error if flags like -avx are ignored on ARM and other
# architectures because they are unsupported.
AX_CHECK_COMPILE_FLAG([-Werror=unused-command-line-argument], [WERROR=-Werror=unused-command-line-argument])

## Checks for supported compiler options.



AC_ARG_WITH([extra-includes],
            [AS_HELP_STRING([--with-extra-includes=DIR],
                       [Define an additional directory for include files])],
            [if test -d "$withval" ; then
               CFLAGS="$CFLAGS -I$withval"
             else
               AC_MSG_ERROR([Cannot stat directory $withval])
             fi])

AC_ARG_WITH([extra-libraries],
            [AS_HELP_STRING([--with-extra-libraries=DIR],
                       [Define an additional directory for library files])],
            [if test -d "$withval" ; then
              LDFLAGS="$LDFLAGS -L$withval"
             else
               AC_MSG_ERROR([Cannot stat directory $withval])
             fi])


AC_MSG_CHECKING([--enable-legacy argument])
AC_ARG_ENABLE([legacy],
  AS_HELP_STRING([--disable-legacy], [disable the legacy aishiteru]))
AC_MSG_RESULT([$enable_legacy])
AM_CONDITIONAL([DISABLED_LEGACY_ENGINE], test "$enable_legacy" = "no")
if test "$enable_legacy" = "no"; then
  AC_DEFINE([DISABLED_LEGACY_ENGINE], [1], [Disable legacy aishiteru engine])
fi

# Detect Clang compiler
AC_MSG_CHECKING([if compiling with clang])
AC_COMPILE_IFELSE(
[AC_LANG_PROGRAM([], [[
#ifndef __clang__
       not clang
#endif
]])],
[CLANG=yes], [CLANG=no])
AC_MSG_RESULT([$CLANG])
# Check whether to enable debugging
AC_MSG_CHECKING([whether to enable debugging])
AC_ARG_ENABLE([debug],
  AS_HELP_STRING([--enable-debug], [turn on debugging [default=no]]))
AC_MSG_RESULT([$enable_debug])
if test x"$enable_debug" = x"yes"; then
    CXXFLAGS=${CXXFLAGS:-"-O2"}
    AM_CPPFLAGS="$AM_CPPFLAGS -g -Wall -DDEBUG -pedantic"
    AM_CXXFLAGS="$AM_CXXFLAGS -g -Wall -DDEBUG -pedantic"
    if test "x$CLANG" = "xyes"; then
        # https://clang.llvm.org/docs/CommandGuide/clang.html
        # clang treats -Og as -O1
        AM_CPPFLAGS="$AM_CPPFLAGS -O0"
        AM_CXXFLAGS="$AM_CXXFLAGS -O0"
    else
        AM_CPPFLAGS="$AM_CPPFLAGS -Og"
        AM_CXXFLAGS="$AM_CXXFLAGS -Og"
    fi
else
    AM_CXXFLAGS="$AM_CXXFLAGS -O2 -DNDEBUG"
    AM_CPPFLAGS="$AM_CPPFLAGS -O2 -DNDEBUG"
fi
# Always look into a "gnu" directory.
curwd=`pwd`
if test -d $curwd/gnu/include ; then
   CPPFLAGS="$CPPFLAGS -I$curwd/gnu/include"
fi
if test -d $curwd/gnu/lib ; then
   LDFLAGS="$LDFLAGS -L$curwd/gnu/lib"
fi
# ----------------------------------------
# Additional checking of compiler characteristics
# ----------------------------------------
# Check Endianness. If Big Endian, this will define WORDS_BIGENDIAN
AC_C_BIGENDIAN
# ----------------------------------------
# Init libtool
# ----------------------------------------
LT_INIT
# ----------------------------------------
# C++ related options
# ----------------------------------------
dnl **********************
dnl Turn on C++11 or newer
dnl **********************
CPLUSPLUS=
AX_CHECK_COMPILE_FLAG([-std=c++11], [CPLUSPLUS=11], [], [$WERROR])
AX_CHECK_COMPILE_FLAG([-std=c++14], [CPLUSPLUS=14], [], [$WERROR])
AX_CHECK_COMPILE_FLAG([-std=c++17], [CPLUSPLUS=17], [], [$WERROR])
#AX_CHECK_COMPILE_FLAG([-std=c++20], [CPLUSPLUS=20], [], [$WERROR])
if test -z "$CPLUSPLUS"; then
  AC_MSG_ERROR([Your compiler does not have the necessary C++11 support! Cannot proceed.])
fi


# Output files
AC_CONFIG_FILES([include/aishiteru/version.h])
AC_CONFIG_FILES([Makefile aishiteru.pc])

AC_OUTPUT
# Final message
echo ""
echo "Configuration is done."
echo "You can now build and install $PACKAGE_NAME by running:"
echo ""
echo "$ make"
echo "$ sudo make install"
echo "$ sudo ldconfig"
echo ""
# echo "$ sudo make install LANGS=\"eng ara deu\""
# echo "  Or:"
# echo "$ sudo make install-langs"
echo ""
# ----------------------------------------
# CONFIG Template
# ----------------------------------------
# Fence added in configuration file
AH_TOP([
#ifndef CONFIG_AUTO_H
#define CONFIG_AUTO_H
/* config_auto.h: begin */
])
# Stuff added at bottom of file
AH_BOTTOM([
/* Miscellaneous defines */
#define AUTOCONF 1
/* Not used yet
#ifndef NO_GETTEXT
#define USING_GETTEXT
#endif
*/
/* config_auto.h: end */
#endif
])
