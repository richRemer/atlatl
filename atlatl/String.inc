%ifndef STRING_INC
%define STRING_INC

%include "Array.inc"
%define String Array
%define String.pdata Array.pdata
%define String.length Array.length
%define String.size Array.size
%define String.create Array.createb
%define String.slice Array.sliceb
%define String.lfind Array.lfindb
%define String.rfind Array.rfindb
%define String.split Array.splitb
%define String.before Array.beforeb
%define String.after Array.afterb

%endif
