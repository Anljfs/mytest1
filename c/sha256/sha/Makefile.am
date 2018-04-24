AUTOMAKE_OPTIONS = foreign
bin_PROGRAMS = sha
noinst_PROGRAMS = shatest
sha_SOURCES = sha.c sha1.c sha256.c sha384.c sha512.c \
	sha1.h sha256.h sha384.h sha512.h version.h
shatest_SOURCES = shatest.c sha1.c sha256.c sha384.c sha512.c \
	sha1.h sha256.h sha384.h sha512.h
man_MANS = sha.1
EXTRA_DIST = $(man_MANS) README.SHA
