#
# C++ Swig Python Makefile
# Mac OS Python 3.8



# My C++ Code here
obj = ex6_wrap.cpp _ex6.so SS.cpp

# My Python Env here
VENV_NAME?=pe38
VENV_ACTIVATE=. ~/$(VENV_NAME)/bin/activate
PYTHON=~/${VENV_NAME}/bin/python3
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
	rm -f *.o
	rm -f *.so
	rm -f *wrap*.c*
	rm -Rf build
	rm -Rf __pycache__/

ex6_wrap.cpp : ex6.i
	$(SWIG) -c++  -python -o ex6_wrap.cpp ex6.i

_ex6.so: ex6.i
	$(PYTHON) setup.py build_ext --inplace

.PHONY: ex6.i

.PHONY: test
test:
	$(PYTHON) -m pytest -v test.py


