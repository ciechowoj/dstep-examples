/* zconf.h -- configuration of the zlib compression library
 * Copyright (C) 1995-2013 Jean-loup Gailly.
 * For conditions of distribution and use, see copyright notice in zlib.h
 */

module zlib.zconf;

import core.stdc.config;

extern (C):

/* @(#) $Id$ */

/*
 * If you *really* need a unique prefix for all types and library functions,
 * compile with -DZ_PREFIX. The "standard" zlib should be compiled without it.
 * Even better than compiling with -DZ_PREFIX would be to use configure to set
 * this permanently in zconf.h using "./configure --zprefix".
 */
/* may be set to #if 1 by ./configure */

/* all linked symbols */

/* all zlib typedefs in zlib.h and zconf.h */

/* all zlib structs in zlib.h and zconf.h */

/*
 * Compile with -DMAXSEG_64K if the alloc function cannot allocate more
 * than 64k bytes at a time (needed on systems with 16-bit int).
 */ /* iSeries (formerly AS/400). */
/* cannot use !defined(STDC) && !defined(const) on Mac */
/* note: need a more gentle solution here */

/* Some Mac compilers merge all .h files incorrectly: */

/* Maximum value for memLevel in deflateInit2 */

enum MAX_MEM_LEVEL = 9;

/* Maximum value for windowBits in deflateInit2 and inflateInit2.
 * WARNING: reducing MAX_WBITS makes minigzip unable to extract .gz files
 * created by gzip. (Files created by minigzip can still be extracted by
 * gzip.)
 */

enum MAX_WBITS = 15; /* 32K LZ77 window */

/* The memory requirements for deflate are (in bytes):
            (1 << (windowBits+2)) +  (1 << (memLevel+9))
 that is: 128K for windowBits=15  +  128K for memLevel = 8  (default values)
 plus a few kilobytes for small objects. For example, if you want to reduce
 the default memory requirements from 256K to 128K, compile with
     make CFLAGS="-O -DMAX_WBITS=14 -DMAX_MEM_LEVEL=7"
 Of course this will generally degrade compression (there's no free lunch).

   The memory requirements for inflate are (in bytes) 1 << windowBits
 that is, 32K for windowBits=15 (default value) plus a few kilobytes
 for small objects.
*/

/* Type declarations */

/* function prototypes */
extern (D) auto OF(T)(auto ref T args)
{
    return args;
}

/* function prototypes for stdarg */
extern (D) auto Z_ARG(T)(auto ref T args)
{
    return args;
}

/* The following definitions for FAR are needed only for MSDOS mixed
 * model programming (small or medium model with some far allocations).
 * This was tested only with MSC; for other MSDOS compilers you may have
 * to define NO_MEMCPY in zutil.h.  If you don't need the mixed model,
 * just define FAR to be empty.
 */

/* MSC small or medium model */

/* Turbo C small or medium model */

/* If building or using zlib as a DLL, define ZLIB_DLL.
 * This is not mandatory, but it offers a little performance increase.
 */

/* ZLIB_DLL */
/* If building or using zlib with the WINAPI/WINAPIV calling convention,
 * define ZLIB_WINAPI.
 * Caution: the standard ZLIB1.DLL is NOT compiled using ZLIB_WINAPI.
 */

/* No need for _export, use ZLIB.DEF instead. */
/* For complete Windows compatibility, use WINAPI, not __stdcall. */

alias ubyte Byte; /* 8 bits */

alias uint uInt; /* 16 bits or more */
alias c_ulong uLong; /* 32 bits or more */

/* Borland C/C++ and some old MSC versions ignore FAR inside typedef */
alias ubyte Bytef;
alias char charf;
alias int intf;
alias uint uIntf;
alias c_ulong uLongf;
alias const(void)* voidpc;
alias void* voidpf;
alias void* voidp;
alias uint z_crc_t;

/* may be set to #if 1 by ./configure */

/* may be set to #if 1 by ./configure */ /* for off_t */ /* for va_list */

/* for wchar_t */

/* a little trick to accommodate both "#define _LARGEFILE64_SOURCE" and
 * "#define _LARGEFILE64_SOURCE 1" as requesting 64-bit operations, (even
 * though the former does not conform to the LFS document), but considering
 * both "#undef _LARGEFILE64_SOURCE" and "#define _LARGEFILE64_SOURCE 0" as
 * equivalently requesting no 64-bit operations
 */

/* for SEEK_*, off_t, and _LFS64_LARGEFILE */

/* for off_t */

enum SEEK_SET = 0; /* Seek from beginning of file.  */
enum SEEK_CUR = 1; /* Seek from current position.  */
enum SEEK_END = 2; /* Set file pointer to EOF plus "offset" */

enum z_off64_t = z_off_t;

/* MVS linker does not support external names larger than 8 bytes */

/* ZCONF_H */
