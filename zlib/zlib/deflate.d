/* deflate.h -- internal compression state
 * Copyright (C) 1995-2012 Jean-loup Gailly
 * For conditions of distribution and use, see copyright notice in zlib.h
 */

module zlib.deflate;

import core.stdc.config;

import zlib.zconf;
import zlib.zlib;
import zlib.zutil;

extern (C):

/* WARNING: this file should *not* be used by applications. It is
   part of the implementation of the compression library and is
   subject to change. Applications should only use zlib.h.
 */

/* @(#) $Id$ */

/* define NO_GZIP when compiling if you want to disable gzip header and
   trailer creation by deflate().  NO_GZIP would be used to avoid linking in
   the crc code when it is not needed.  For shared libraries, gzip encoding
   should be left enabled. */

/* ===========================================================================
 * Internal compression state.
 */

enum LENGTH_CODES = 29;
/* number of length codes, not counting the special END_BLOCK code */

enum LITERALS = 256;
/* number of literal bytes 0..255 */

enum L_CODES = LITERALS + 1 + LENGTH_CODES;
/* number of Literal or Length codes, including the END_BLOCK code */

enum D_CODES = 30;
/* number of distance codes */

enum BL_CODES = 19;
/* number of codes used to transfer the bit lengths */

enum HEAP_SIZE = 2 * L_CODES + 1;
/* maximum heap size */

enum MAX_BITS = 15;
/* All codes must not exceed MAX_BITS bits */

enum Buf_size = 16;
/* size of bit buffer in bi_buf */

enum INIT_STATE = 42;
enum EXTRA_STATE = 69;
enum NAME_STATE = 73;
enum COMMENT_STATE = 91;
enum HCRC_STATE = 103;
enum BUSY_STATE = 113;
enum FINISH_STATE = 666;
/* Stream status */

/* Data structure describing a single value and its code string. */
struct ct_data_s
{
    /* frequency count */
    /* bit string */
    union _Anonymous_0
    {
        ush freq; /* frequency count */
        ush code; /* bit string */
    }

    _Anonymous_0 fc;

    /* father node in Huffman tree */
    /* length of bit string */
    union _Anonymous_1
    {
        ush dad; /* father node in Huffman tree */
        ush len; /* length of bit string */
    }

    _Anonymous_1 dl;
}

alias ct_data_s ct_data;

enum Freq = fc.freq;
enum Code = fc.code;
enum Dad = dl.dad;
enum Len = dl.len;

struct static_tree_desc_s;
alias static_tree_desc_s static_tree_desc;

struct tree_desc_s
{
    ct_data* dyn_tree; /* the dynamic tree */
    int max_code; /* largest code with non zero frequency */
    static_tree_desc* stat_desc; /* the corresponding static tree */
}

alias tree_desc_s tree_desc;

alias ushort Pos;
alias ushort Posf;
alias uint IPos;

/* A Pos is an index in the character window. We use short instead of int to
 * save space in the various tables. IPos is used only for parameter passing.
 */

struct internal_state
{
    z_streamp strm; /* pointer back to this zlib stream */
    int status; /* as the name implies */
    Bytef* pending_buf; /* output still pending */
    ulg pending_buf_size; /* size of pending_buf */
    Bytef* pending_out; /* next pending byte to output to the stream */
    uInt pending; /* nb of bytes in the pending buffer */
    int wrap; /* bit 0 true for zlib, bit 1 true for gzip */
    gz_headerp gzhead; /* gzip header information to write */
    uInt gzindex; /* where in extra, name, or comment */
    Byte method; /* can only be DEFLATED */
    int last_flush; /* value of flush param for previous deflate call */

    /* used by deflate.c: */

    uInt w_size; /* LZ77 window size (32K by default) */
    uInt w_bits; /* log2(w_size)  (8..16) */
    uInt w_mask; /* w_size - 1 */

    Bytef* window;
    /* Sliding window. Input bytes are read into the second half of the window,
     * and move to the first half later to keep a dictionary of at least wSize
     * bytes. With this organization, matches are limited to a distance of
     * wSize-MAX_MATCH bytes, but this ensures that IO is always
     * performed with a length multiple of the block size. Also, it limits
     * the window size to 64K, which is quite useful on MSDOS.
     * To do: use the user input buffer as sliding window.
     */

    ulg window_size;
    /* Actual size of window: 2*wSize, except when the user input buffer
     * is directly used as sliding window.
     */

    Posf* prev;
    /* Link to older string with same hash index. To limit the size of this
     * array to 64K, this link is maintained only for the last 32K strings.
     * An index in this array is thus a window index modulo 32K.
     */

    Posf* head; /* Heads of the hash chains or NIL. */

    uInt ins_h; /* hash index of string to be inserted */
    uInt hash_size; /* number of elements in hash table */
    uInt hash_bits; /* log2(hash_size) */
    uInt hash_mask; /* hash_size-1 */

    uInt hash_shift;
    /* Number of bits by which ins_h must be shifted at each input
     * step. It must be such that after MIN_MATCH steps, the oldest
     * byte no longer takes part in the hash key, that is:
     *   hash_shift * MIN_MATCH >= hash_bits
     */

    c_long block_start;
    /* Window position at the beginning of the current output block. Gets
     * negative when the window is moved backwards.
     */

    uInt match_length; /* length of best match */
    IPos prev_match; /* previous match */
    int match_available; /* set if previous match exists */
    uInt strstart; /* start of string to insert */
    uInt match_start; /* start of matching string */
    uInt lookahead; /* number of valid bytes ahead in window */

    uInt prev_length;
    /* Length of the best match at previous step. Matches not greater than this
     * are discarded. This is used in the lazy match evaluation.
     */

    uInt max_chain_length;
    /* To speed up deflation, hash chains are never searched beyond this
     * length.  A higher limit improves compression ratio but degrades the
     * speed.
     */

    uInt max_lazy_match;
    /* Attempt to find a better match only when the current match is strictly
     * smaller than this value. This mechanism is used only for compression
     * levels >= 4.
     */

    /* Insert new strings in the hash table only if the match length is not
     * greater than this length. This saves time but degrades compression.
     * max_insert_length is used only for compression levels <= 3.
     */

    int level; /* compression level (1..9) */
    int strategy; /* favor or force Huffman coding*/

    uInt good_match;
    /* Use a faster search when the previous match is longer than this */

    int nice_match; /* Stop searching when current match exceeds this */

    /* used by trees.c: */
    /* Didn't use ct_data typedef below to suppress compiler warning */
    ct_data_s[573] dyn_ltree; /* literal and length tree */
    ct_data_s[61] dyn_dtree; /* distance tree */
    ct_data_s[39] bl_tree; /* Huffman tree for bit lengths */

    tree_desc_s l_desc; /* desc. for literal tree */
    tree_desc_s d_desc; /* desc. for distance tree */
    tree_desc_s bl_desc; /* desc. for bit length tree */

    ush[16] bl_count;
    /* number of codes at each bit length for an optimal tree */

    int[573] heap; /* heap used to build the Huffman trees */
    int heap_len; /* number of elements in the heap */
    int heap_max; /* element of largest frequency */
    /* The sons of heap[n] are heap[2*n] and heap[2*n+1]. heap[0] is not used.
     * The same heap array is used to build all trees.
     */

    uch[573] depth;
    /* Depth of each subtree used as tie breaker for trees of equal frequency
     */

    uchf* l_buf; /* buffer for literals or lengths */

    uInt lit_bufsize;
    /* Size of match buffer for literals/lengths.  There are 4 reasons for
     * limiting lit_bufsize to 64K:
     *   - frequencies can be kept in 16 bit counters
     *   - if compression is not successful for the first block, all input
     *     data is still in the window so we can still emit a stored block even
     *     when input comes from standard input.  (This can also be done for
     *     all blocks if lit_bufsize is not greater than 32K.)
     *   - if compression is not successful for a file smaller than 64K, we can
     *     even emit a stored file instead of a stored block (saving 5 bytes).
     *     This is applicable only for zip (not gzip or zlib).
     *   - creating new Huffman trees less frequently may not provide fast
     *     adaptation to changes in the input data statistics. (Take for
     *     example a binary file with poorly compressible code followed by
     *     a highly compressible string table.) Smaller buffer sizes give
     *     fast adaptation but have of course the overhead of transmitting
     *     trees more frequently.
     *   - I can't count above 4
     */

    uInt last_lit; /* running index in l_buf */

    ushf* d_buf;
    /* Buffer for distances. To simplify the code, d_buf and l_buf have
     * the same number of elements. To use different lengths, an extra flag
     * array would be necessary.
     */

    ulg opt_len; /* bit length of current block with optimal trees */
    ulg static_len; /* bit length of current block with static trees */
    uInt matches; /* number of string matches in current block */
    uInt insert; /* bytes at end of window left to insert */

    /* total bit length of compressed file mod 2^32 */
    /* bit length of compressed data sent mod 2^32 */

    ush bi_buf;
    /* Output buffer. bits are inserted starting at the bottom (least
     * significant bits).
     */
    int bi_valid;
    /* Number of valid bits in bi_buf.  All bits above the last valid bit
     * are always zero.
     */

    ulg high_water;
    /* High water mark offset in window for initialized bytes -- bytes above
     * this are set to zero in order to avoid memory check warnings when
     * longest match routines access bytes past the input.  This is then
     * updated to the new high water mark.
     */
}

enum max_insert_length = max_lazy_match;
/* Insert new strings in the hash table only if the match length is not
 * greater than this length. This saves time but degrades compression.
 * max_insert_length is used only for compression levels <= 3.
 */

/* compression level (1..9) */
/* favor or force Huffman coding*/

/* Use a faster search when the previous match is longer than this */

/* Stop searching when current match exceeds this */

/* used by trees.c: */
/* Didn't use ct_data typedef below to suppress compiler warning */ /* literal and length tree */ /* distance tree */ /* Huffman tree for bit lengths */

/* desc. for literal tree */
/* desc. for distance tree */
/* desc. for bit length tree */
/* number of codes at each bit length for an optimal tree */ /* heap used to build the Huffman trees */
/* number of elements in the heap */
/* element of largest frequency */
/* The sons of heap[n] are heap[2*n] and heap[2*n+1]. heap[0] is not used.
 * The same heap array is used to build all trees.
 */
/* Depth of each subtree used as tie breaker for trees of equal frequency
 */

/* buffer for literals or lengths */

/* Size of match buffer for literals/lengths.  There are 4 reasons for
 * limiting lit_bufsize to 64K:
 *   - frequencies can be kept in 16 bit counters
 *   - if compression is not successful for the first block, all input
 *     data is still in the window so we can still emit a stored block even
 *     when input comes from standard input.  (This can also be done for
 *     all blocks if lit_bufsize is not greater than 32K.)
 *   - if compression is not successful for a file smaller than 64K, we can
 *     even emit a stored file instead of a stored block (saving 5 bytes).
 *     This is applicable only for zip (not gzip or zlib).
 *   - creating new Huffman trees less frequently may not provide fast
 *     adaptation to changes in the input data statistics. (Take for
 *     example a binary file with poorly compressible code followed by
 *     a highly compressible string table.) Smaller buffer sizes give
 *     fast adaptation but have of course the overhead of transmitting
 *     trees more frequently.
 *   - I can't count above 4
 */

/* running index in l_buf */

/* Buffer for distances. To simplify the code, d_buf and l_buf have
 * the same number of elements. To use different lengths, an extra flag
 * array would be necessary.
 */

/* bit length of current block with optimal trees */
/* bit length of current block with static trees */
/* number of string matches in current block */
/* bytes at end of window left to insert */

/* total bit length of compressed file mod 2^32 */
/* bit length of compressed data sent mod 2^32 */

/* Output buffer. bits are inserted starting at the bottom (least
 * significant bits).
 */

/* Number of valid bits in bi_buf.  All bits above the last valid bit
 * are always zero.
 */

/* High water mark offset in window for initialized bytes -- bytes above
 * this are set to zero in order to avoid memory check warnings when
 * longest match routines access bytes past the input.  This is then
 * updated to the new high water mark.
 */
alias internal_state deflate_state;

/* Output a byte on the stream.
 * IN assertion: there is enough room in pending_buf.
 */

enum MIN_LOOKAHEAD = MAX_MATCH + MIN_MATCH + 1;
/* Minimum amount of lookahead, except at the end of the input file.
 * See deflate.c for comments about the MIN_MATCH+1.
 */

extern (D) auto MAX_DIST(T)(auto ref T s)
{
    return s.w_size - MIN_LOOKAHEAD;
}

/* In order to simplify the code, particularly on 16 bit machines, match
 * distances are limited to MAX_DIST instead of WSIZE.
 */

enum WIN_INIT = MAX_MATCH;
/* Number of bytes after end of data in window to initialize in order to avoid
   memory checker errors from longest match routines */

/* in trees.c */
void _tr_init (deflate_state* s);
int _tr_tally (deflate_state* s, uint dist, uint lc);
void _tr_flush_block (deflate_state* s, charf* buf, ulg stored_len, int last);
void _tr_flush_bits (deflate_state* s);
void _tr_align (deflate_state* s);
void _tr_stored_block (deflate_state* s, charf* buf, ulg stored_len, int last);

extern (D) auto d_code(T)(auto ref T dist)
{
    return dist < 256 ? _dist_code[dist] : _dist_code[256 + (dist >> 7)];
}

/* Mapping from a distance to a distance code. dist is the distance - 1 and
 * must not have side effects. _dist_code[256] and _dist_code[257] are never
 * used.
 */

/* Inline versions of _tr_tally for speed: */
extern __gshared const uch[] _length_code;
extern __gshared const uch[] _dist_code;

/* DEFLATE_H */
