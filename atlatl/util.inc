%ifndef UTIL_INC
%define UTIL_INC

%macro prsv 1
    push    %1
%endmacro

%macro prsv 2
    push    %1
    push    %2
%endmacro

%macro prsv 3
    push    %1
    push    %2
    push    %3
%endmacro

%macro prsv 4
    push    %1
    push    %2
    push    %3
    push    %4
%endmacro

%macro prsv 5
    push    %1
    push    %2
    push    %3
    push    %4
    push    %5
%endmacro

%macro prsv 6
    push    %1
    push    %2
    push    %3
    push    %4
    push    %5
    push    %6
%endmacro

%macro rstr 1
    pop     %1
%endmacro

%macro rstr 2
    pop     %2
    pop     %1
%endmacro

%macro rstr 3
    pop     %3
    pop     %2
    pop     %1
%endmacro

%macro rstr 4
    pop     %4
    pop     %3
    pop     %2
    pop     %1
%endmacro

%macro rstr 5
    pop     %5
    pop     %4
    pop     %3
    pop     %2
    pop     %1
%endmacro

%macro rstr 6
    pop     %6
    pop     %5
    pop     %4
    pop     %3
    pop     %2
    pop     %1
%endmacro

%endif
