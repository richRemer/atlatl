Memory Allocation
=================
 * initialized with break set to end of BSS
 * first allocation allocates space for the stride index
 * Stride Index
   * contains a stride entry for each chunk size (powers of 2)
 * Stride Entry
   * contains chunk mask capacity
     * number of bits in mask
     * number of entries if mask is fully allocated
   * contains address of allocation mask
   * 

   * contains mask capacity
   * contains all allocations for a particular fixed length
   * chunk index capacity


Empty allocation counter
 * first empty allocation gets address 1, etc.
 * second empty allocation gets address 2, etc.

Scan Break
 * one for each stride entry
 * scan break initialized to 0
 * scanning for free space begins at the scan break
 * scanning past allocated chunks moves scan break forward
 * free'ing chunk moves scan break backward
 * PROBLEM:
   * large stride mask
   * empty chunks in initial and terminal positions
   * loop executes {new A(); new B(); delete a; delete b;}
   * new A(), allocates initial chunk, sets scan break to initial
   * new B(), scans entire mask, then allocate terminal chunk
   * delete a, sets scan break to initial
   * delete b, frees terminal chunk
   * on loop, the new B() has to scan the entire mask each time    
   * possible solutions
     * jitter, periodically adjust the scan break to shake out
       * randomize break
         * sometimes break will be set to end
         * next allocation will trigger new chunk, allocated initial
         * first of many allocations is likely to leak
         * possible solutions
           * scan first X (biased by capacity) mask bits before new chunk
       * inc scan break
         * new A() in terminal
         * new B() triggers new chunk, and allocates initial position
         * delete a breaks to previous terminal, near end of mask
         * on loop, allocation performance will be good
         * initial position will leak
     * extend on long scan
       * limit scan to X entries
       * extend allocation if necessary, but preserve scan break
       * loop on scan end
       * PROBLEM
         * very little reserve space
         * scan break at beginning
         * many allocations
         * each allocation extends until scan break catches up
         * solutions
           * limit extensions
             * limit to X consecutive extensions
             * on limit, set extension break to first extension
             * switch to extension break when scan goes over
             * extend on overscan of extension break
               * extension break already points at new extension
         

Goals
 * functional parity with malloc/realloc/free
 * un-terrible performance characteristics for
   * small programs
   * large programs
   * small allocations
   * large allocations
   * allocation re-use
 * leak-free
   * freeing array of small chunks should be reusable as large chunk
   * freeing large chunk should be reusable as array of small chunks
   * no lost partial chunks (identified partial chunks are OK)



buf = []
empties = 0
scanLimit = 64
extendLimit = 64

function malloc(size) {
    if size == 0:
        return ++empties

    index = log2(chunkSize)
    strides = strideTable()
    entry = strideEntry(strides, index)
    chunk = emptyChunk(entry)    
    return chunk
}

function log2(chunkSize) {
    log = -1
    while (chunkSize > 0):
        log++
        chunkSize >>= 1
    return log
}

function strideTable() {
    if buf.length == 0:
        buf.extend(512, 0)
    return buf
}

function strideEntry(table, index) {
    return table + sizeof(entry) * index
}

function emptyChunk(entry) {
    mask = entry.mask
    maskLen = entry.maskLength
    chunk = scan(entry) || extend(entry) || scanExtension(entry) || grow(entry)
    return chunk
}

function scan(entry) {
    scans = 0
    maskPos = &entry.scanBreak
    maskLimit = &entry.maskLen
    mask = entry.mask
    index = entry.index     -- chunk index (ptrs to chunk arrays)

    while (scans < scanLimit & maskPos < maskLimit & mask[maskPos] == -1):
        maskPos++
        scans++
    
    if maskPos = maskLimit:
        maskPos = 0
        entry.extensions = 0
        entry.extensionBreak = 0

    // this approach assumes scanLimit is less than mask size (64-bit)
    while (scans < scanLimit & mask[maskPos] == -1):
        maskPos++
        scans++

    if mask[maskPos] !== -1:
        bit = findBit(mask[maskPos])
        setBit(mask[maskPos], bit)
        return index[masPos * 8 + bit]
}

function extend(entry) {
    if entry.extensions++ = extendLimit:
        return 0

    return grow(entry)
}

function scanExtension(entry) {
    saveBreak = entry.scanBreak
    entry.scanBreak = entry.extensionBreak
    chunk = scan(entry)
    extensionBreak = entry.scanBreak
    entry.scanBreak = saveBreak

}
