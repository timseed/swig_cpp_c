# SWIG in Python3 using C++ and C


I was looking to build a python interface into a fairly large C++ codeset, that has a small amount of C included, and I was struggling to accomplish this. So I simplified this as much as I could, as I am only a beginner in using SWIG.

## C++ Class

A very simple class, which looks like this.


```C++

extern "C" int c_sum(int a, int b);


SS::SS() = default;

int SS::Sum(int a, int b) {

    return a+b;
}

int SS::Sum_from_c(int a, int b) {

    return c_sum(a,b);
}
```

Please note I deliberatly made the Constructor in C++14 format (more on why a little later).

You can see if references a C function.


### Why worry about the C++14  

You can compile everything, and clang (default compiler on my mac) is smart enough to work out how to compile the files if your setup.py look like this


```python

example_module = Extension("_ex6", sources=["ex6_wrap.cpp", "SS.cpp","c_code.c"],)

```

However in the "real" envirnment I have some C++14 Extensions that I can not just ignore, (constexpr int ND = 58;)

So I really want to pass the compiler options of *-std c++14*  I can ... if the setup.py looks like this

```python
example_module = Extension("_ex6", sources=["ex6_wrap.cpp", "SS.cpp"],
                           extra_compile_args=['-std=c++14'],
                           ])
```

But - compiling a C file with "-std=C++14" causes an error....


### Seperate compile C and include in build

If I build/compile - but do not link the C, I can then add these modules in like this


```python

example_module = Extension("_ex6", sources=["ex6_wrap.cpp", "SS.cpp"],
                           extra_compile_args=['-std=c++14'],
                           extra_objects=["c_code.o"])
```

I make sure that there is a specific rule in the Makefile, so the c_code.o will be present.


# Files 

These are the files - so you can test this yourself.


### Layout
```text
  /test.py
  /setup.py
  /ex6.i
  /c_code.h
  /c_code.c
  /SS.h
  /SS.cpp
  /Makefile
```


### Makefile
```
#
# C++ Swig Python Makefile
# Mac OS Python 3.8
# Please note. This will clean, rebuild and test by default. This is the intended operation.



# My C++ Code here
obj = ex6_wrap.cpp _ex6.so SS.cpp c_code.o

# My Python Env here
VENV_NAME?=pe38
VENV_ACTIVATE=. ~/$(VENV_NAME)/bin/activate
PYTHON= ~/${VENV_NAME}/bin/python3
PIP = pip3
SWIG = /usr/local/bin/swig
# Execute a command and get the output.... THis is very Version specific
# Not needed but useful to know
#
PYTHONINCLUDE=$(shell /usr/local/Cellar/python@3.8/3.8.1/bin/python3.8-config --include)

DEFAULT_GOAL := fullcheck

fullcheck:
	$(MAKE) clean 
	$(MAKE) build
	$(MAKE) test

.PHONY: build
build : $(obj)

clean:
	rm -f ex6.py
	rm -f ex6.cpp
	rm -f *.o
	rm -f *.so
	rm -f *wrap*.c*
	rm -Rf build
	rm -Rf __pycache__/


c_code.o :  c_code.c
	cc -c c_code.c -o c_code.o

ex6_wrap.cpp : ex6.i
	$(SWIG) -c++  -python -o ex6_wrap.cpp ex6.i

_ex6.so: ex6.i
	$(PYTHON) setup.py build_ext --inplace

ex6.i :  c_code.o

.PHONY: test
test:
	$(PYTHON) -m pytest -v test.py

````




### SS.h

A Very basic header.

```python
//
// Created by TS on 4/22/20.
//

#ifndef EX5_SS_H
#define EX5_SS_H
class SS{
public:
    SS();
    int Sum(int a, int b);
    int Sum_from_c(int a, int b);
};
#endif //EX5_SS_H

```


### SS.cpp

The implementation of the C++ code. As simple as I could make it.

```python
//
// Created by TS on 4/22/20.
//

#include "SS.h"
extern "C" int c_sum(int a, int b);


SS::SS() = default;

int SS::Sum(int a, int b) {

    return a+b;
}

int SS::Sum_from_c(int a, int b) {

    return c_sum(a,b);
}

```



### c_code.h

The c-code, which some some reason can not be ported to C++.

```python
int c_sum(int a, int b);

```

### test.py

Automated tests - saves typing. 

```python
from unittest import TestCase

import ex6


class Swigtest(TestCase):
    def test_is_class(self):
        s = ex6
        assert True

    def test_is_SS(self):
        s = ex6.SS()
        self.assertIsInstance(s, ex6.SS)

    def test_Sum_Method(self):
        s = ex6.SS()
        self.assertEqual(s.Sum(1, 2), 3)
        self.assertEqual(s.Sum(5, 5), 10)

        # These should not work
        # C++ Expects an int - not float
        self.assertRaises(TypeError, s.Sum, **{"a": 5.9, "b": 5.9})
        self.assertRaises(TypeError, s.Sum, **{"a": 5, "b": 5.9})
        self.assertRaises(TypeError, s.Sum, **{"a": 5.9, "b": 5})


    def test_Sum_from_c_Method(self):
        s = ex6.SS()
        self.assertEqual(s.Sum_from_c(1, 2), 3)
        self.assertEqual(s.Sum_from_c(5, 5), 10)
        # These should not work
        # C++ Expects an int - not float
        self.assertRaises(TypeError, s.Sum_from_c, **{"a": 5.9, "b": 5.9})
        self.assertRaises(TypeError, s.Sum_from_c, **{"a": 5, "b": 5.9})
        self.assertRaises(TypeError, s.Sum_from_c, **{"a": 5.9, "b": 5})


```

### setup.py

This is the python extension building wrapper. It is much easier to use this, than to try and compile manually. 


```python
"""
setup.py file for SWIG example
This expects swig on the interface file to have been run previously.
"""

from distutils.core import setup, Extension


example_module = Extension("_ex6", sources=["ex6_wrap.cpp", "SS.cpp"],
                           extra_compile_args=['-std=c++14'],
                           extra_objects=["c_code.o"])


setup(
    name="ex6",
    version="0.1",
    author="Tim Seed",
    description="""Testing C++ and C being called via Swig.""",
    ext_modules=[example_module],
    swig_opts=['-c++', '-py3'],
    extra_compile_args=['-std=c++14'],          # Tell C++ compiler to use c++14std
    py_modules=["ex6"],   # This is the module name we will import in Python
)

```

### ex6.i
```python
/* File: ex6.i */
%module ex6
%{
#include "SS.h"
%}
%include SS.h

```

### c_code.c
```python
#include "c_code.h"
#include <stdio.h>

int c_sum(int a, int b)
{
	printf("in C module\n");    // Just to 100% confirm we are triggering this code
	return a+b;
}

```


# Building 

You will probably need to adjust the Makefile, as I am using a Virtual-Env called pe38 ... 

Once that is done ... 

    make
    
    
Assuming it finishes compiling, pytests will be triggered. and you see the output

***4 passed in 1.89s***

