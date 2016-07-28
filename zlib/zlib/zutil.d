/* zutil.h -- internal interface and configuration of the compression library
 * Copyright (C) 1995-2013 Jean-loup Gailly.
 * For conditions of distribution and use, see copyright notice in zlib.h
 */

module zlib.zutil;

import core.stdc.config;

import zlib.zconf;

extern (C):

/* WARNING: this file should *not* be used by applications. It is
   part of the implementation of the compression library and is
   subject to change. Applications should only use zlib.h.
 */

/* @(#) $Id$ */

/* guess -- will be caught if guess is wrong */

/* compile with -Dlocal if your debugger can't find static symbols */

alias ubyte uch;
alias ubyte uchf;
alias ushort ush;
alias ushort ushf;
alias c_ulong ulg;
extern __gshared char*[10] z_errmsg; /* indexed by 2-zlib_error */
/* (size given to avoid silly warnings with Visual C++) */

extern (D) auto ERR_MSG(T)(auto ref T err)
{
    return z_errmsg[Z_NEED_DICT - err];
}

/* To be used only when the state is known to be valid */

/* common constants */

enum DEF_WBITS = MAX_WBITS;

/* default windowBits for decompression. MAX_WBITS is for compression only */
enum DEF_MEM_LEVEL = 8;

/* default memLevel */

enum STORED_BLOCK = 0;
enum STATIC_TREES = 1;
enum DYN_TREES = 2;
/* The three kinds of block type */

enum MIN_MATCH = 3;
enum MAX_MATCH = 258;
/* The minimum and maximum match lengths */

enum PRESET_DICT = 0x20; /* preset dictionary flag in zlib header */

/* target dependencies */

/* Allow compilation with ANSI keywords only enabled */

/* MSC or DJGPP */

/* for fdopen */

/* No fdopen() */

/* Cygwin is Unix, not Win32 */

/* Prime/PRIMOS */

/* No fdopen() */

/* No fdopen() */

/* provide prototypes for these when building zlib without LFS */
uLong adler32_combine64 (uLong, uLong, c_long);
uLong crc32_combine64 (uLong, uLong, c_long);

/* common defaults */

enum OS_CODE = 0x03; /* assume Unix */

alias F_OPEN = fopen;

/* functions */

/* Use our own functions for small and medium model with MSC <= 5.0.
 * You may have to use the same strategy for Borland C (untested).
 * The __SC__ check is for Symantec.
 */
/* MSDOS small or medium model */

enum zmemcpy = memcpy;
enum zmemcmp = memcmp;

extern (D) auto zmemzero(T0, T1)(auto ref T0 dest, auto ref T1 len)
{
    return memset(dest, 0, len);
}

/* Diagnostic functions */

voidpf zcalloc (voidpf opaque, uint items, uint size);
void zcfree (voidpf opaque, voidpf ptr);

extern (D) auto ZALLOC(T0, T1, T2)(auto ref T0 strm, auto ref T1 items, auto ref T2 size)
{
    return (*(strm.zalloc))(strm.opaque, items, size);
}

extern (D) auto ZFREE(T0, T1)(auto ref T0 strm, auto ref T1 addr)
{
    return (*(strm.zfree))(strm.opaque, cast(voidpf) addr);
}

/* Reverse the bytes in a 32-bit value */
extern (D) auto ZSWAP32(T)(auto ref T q)
{
    return ((q >> 24) & 0xff) + ((q >> 8) & 0xff00) + ((q & 0xff00) << 8) + ((q & 0xff) << 24);
}

/* ZUTIL_H */
