%ifndef FS_INC
%define FS_INC

struc Stat
    .dev_id:    resq    1
    .inode:     resq    1
    .nlinks:    resq    1
    .mode:      resd    1
    .uid:       resd    1
    .gid:       resd    1
                resd    1
    .rdev_id:   resq    1
    .blksize:   resq    1
    .blocks:    resq    1
    .atime:     resq    1
    .mtime:     resq    1
    .ctime:     resq    1
    .size:
endstruc

%endif
