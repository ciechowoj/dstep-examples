/* gzguts.h -- zlib internal header definitions for gz* operations
 * Copyright (C) 2004, 2005, 2010, 2011, 2012, 2013 Mark Adler
 * For conditions of distribution and use, see copyright notice in zlib.h
 */

module zlib.gzguts;

import core.stdc.config;

import zlib.zlib;

extern (C):

/* for compatibility with old definition */

/* vsnprintf may exist on some MS-DOS compilers (DJGPP?),
   but for now we just assume it doesn't. */

/* In Win32, vsnprintf is available as the "non-ANSI" _vsnprintf. */

/* unlike snprintf (which is required in C99, yet still not supported by
   Microsoft more than a decade later!), _snprintf does not guarantee null
   termination of the result -- however this is only used in gzlib.c where
   the result is assured to fit in the space provided */

/* compile with -Dlocal if your debugger can't find static symbols */

/* gz* functions always use library allocation functions */

/* get errno and strerror definition */
extern (D) auto zstrerror()
{
    return strerror(errno);
}

/* provide prototypes for these when building zlib without LFS */
gzFile gzopen64 (const(char)*, const(char)*);
c_long gzseek64 (gzFile, c_long, int);
c_long gztell64 (gzFile);
c_long gzoffset64 (gzFile);

/* default memLevel */
enum DEF_MEM_LEVEL = 8;

/* default i/o buffer size -- double this for output when reading (this and
   twice this must be able to fit in an unsigned type) */
enum GZBUFSIZE = 8192;

/* gzip modes, also provide a little integrity check on the passed structure */
enum GZ_NONE = 0;
enum GZ_READ = 7247;
enum GZ_WRITE = 31153;
enum GZ_APPEND = 1; /* mode set to GZ_WRITE after the file is opened */

/* values for gz_state how */
enum LOOK = 0; /* look for a gzip header */
enum COPY = 1; /* copy input directly */
enum GZIP = 2; /* decompress a gzip stream */

/* internal gzip file state data structure */
struct gz_state
{
    /* exposed contents for gzgetc() macro */ /* "x" for exposed */
    /* x.have: number of bytes available at x.next */
    /* x.next: next output data to deliver or write */
    /* x.pos: current position in uncompressed data */
    /* used for both reading and writing */
    /* see gzip modes above */
    /* file descriptor */
    /* path or fd for error messages */
    /* buffer size, zero if not allocated yet */
    /* requested buffer size, default is GZBUFSIZE */
    /* input buffer */
    /* output buffer (double-sized when reading) */
    /* 0 if processing gzip, 1 if transparent */
    /* just for reading */
    /* 0: get header, 1: copy, 2: decompress */
    /* where the gzip data started, for rewinding */
    /* true if end of input file reached */
    /* true if read requested past end */
    /* just for writing */
    /* compression level */
    /* compression strategy */
    /* seek request */
    /* amount to skip (already rewound if backwards) */
    /* true if seek request pending */
    /* error information */
    /* error code */
    /* error message */
    /* zlib inflate or deflate stream */
    /* stream structure in-place (not a pointer) */

    /* shared functions */

    /* GT_OFF(x), where x is an unsigned value, is true if x > maximum z_off64_t
       value -- needed when comparing unsigned to z_off64_t, which is signed
       (possible z_off64_t types off_t, off64_t, and long are all signed) */

    struct gzFile_s
    {
        uint have;
        ubyte* next;
        c_long pos;
    }

    gzFile_s x;
    int mode; /* see gzip modes above */
    int fd; /* file descriptor */
    char* path; /* path or fd for error messages */
    uint size; /* buffer size, zero if not allocated yet */
    uint want; /* requested buffer size, default is GZBUFSIZE */
    ubyte* in_; /* input buffer */
    ubyte* out_; /* output buffer (double-sized when reading) */
    int direct; /* 0 if processing gzip, 1 if transparent */
    /* just for reading */
    int how; /* 0: get header, 1: copy, 2: decompress */
    c_long start; /* where the gzip data started, for rewinding */
    int eof; /* true if end of input file reached */
    int past; /* true if read requested past end */
    /* just for writing */
    int level; /* compression level */
    int strategy; /* compression strategy */
    /* seek request */
    c_long skip; /* amount to skip (already rewound if backwards) */
    int seek; /* true if seek request pending */
    /* error information */
    int err; /* error code */
    char* msg; /* error message */
    /* zlib inflate or deflate stream */
    z_stream strm; /* stream structure in-place (not a pointer) */
} /* where the gzip data started, for rewinding */
/* true if end of input file reached */
/* true if read requested past end */
/* just for writing */
/* compression level */
/* compression strategy */
/* seek request */ /* amount to skip (already rewound if backwards) */
/* true if seek request pending */
/* error information */
/* error code */
/* error message */
/* zlib inflate or deflate stream */
/* stream structure in-place (not a pointer) */
alias * gz_statep;

/* shared functions */
void gz_error (gz_statep, int, const(char)*);

/* GT_OFF(x), where x is an unsigned value, is true if x > maximum z_off64_t
   value -- needed when comparing unsigned to z_off64_t, which is signed
   (possible z_off64_t types off_t, off64_t, and long are all signed) */
extern (D) auto GT_OFF(T)(auto ref T x)
{
    return int.sizeof == z_off64_t.sizeof && x > INT_MAX;
}
