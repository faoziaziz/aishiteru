## run autogen.sh to create Makefile.in from this file
ACLOCAL_AMFLAGS = -I m4

if ENABLE_TRAINING
TRAINING_SUBDIR = src/training
training: all
	@$(MAKE) -C src/training
training-install: training
	@$(MAKE) -C src/training install
training-uninstall:
	@$(MAKE) -C src/training uninstall
clean-local:
	@$(MAKE) -C src/training clean


.PHONY:


EXTRA_DIST = README.md LICENSE
EXTRA_DIST += aclocal.m4 config configure.ac autogen.sh
EXTRA_DIST += aishiteru.pc.in 
EXTRA_DIST += CMakeLists.txt aishiteru.pc.cmake cmake VERSION src/vs2010

DIST_SUBDIRS = $(SUBDIRS) $(TRAINING_SUBDIR)


pkgconfigdir = $(libdir)/pkgconfig
pkgconfig_DATA = tesseract.pc

pkginclude_HEADERS = $(top_builddir)/include/aishiteru/version.h
pkginclude_HEADERS += include/aishiteru/apitypes.h
pkginclude_HEADERS += include/aishiteru/baseapi.h
pkginclude_HEADERS += include/aishiteru/capi.h
pkginclude_HEADERS += include/aishiteru/genericvector.h

# Rules for all subdirectories.

noinst_HEADERS =
noinst_LTLIBRARIES =

AM_CPPFLAGS += -I$(top_srcdir)/include
AM_CPPFLAGS += -I$(top_builddir)/include


# Rules for src/api.

libaishiteru_la_CPPFLAGS = $(AM_CPPFLAGS)
libaishiteru_la_CPPFLAGS += -I$(top_srcdir)/src/arch


lib_LTLIBRARIES = libaishiteru.la
libaishiteru_la_LDFLAGS += -version-info $(GENERIC_LIBRARY_VERSION)

libaishiteru_la_SOURCES = src/api/baseapi.cpp

libaishiteru_la_LIBADD += libtesseract_opencl.la

# Rules for src/arch.

noinst_HEADERS += src/arch/dotproduct.h
noinst_HEADERS += src/arch/intsimdmatrix.h
noinst_HEADERS += src/arch/simddetect.h

noinst_LTLIBRARIES += libtesseract_native.la

# Rules for src/dict.

noinst_HEADERS += src/dict/dawg.h

libtesseract_la_SOURCES += src/dict/trie.cpp

# Rules for tesseract executable.

bin_PROGRAMS = aishiteru
aishiteru_SOURCES = src/api/aishiterumain.cpp
aishiteru_CPPFLAGS =
aishiteru_CPPFLAGS += -I$(top_srcdir)/src/arch
aishiteru_CPPFLAGS += -I$(top_srcdir)/src/dict


