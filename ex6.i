/* File: example.i */
%module ex6
%include <std_vector.i>
%include <std_map.i>
%{
#define SWIG_FILE_WITH_INIT
#include <stdlib.h>
#include "SS.h"
%}
%include SS.h
