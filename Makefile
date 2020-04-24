VENV_NAME?=pe38
VENV_ACTIVATE=. ~/$(VENV_NAME)/bin/activate
PYTHON=~/${VENV_NAME}/bin/python3
PIP = pip3
obj = ex6_wrap.cpp _example.so SS.cpp
SWIG = /usr/local/bin/swig
# Execute a command and get the output.... THis is very Version specific
PYTHONINCLUDE=$(shell /usr/local/Cellar/python@3.8/3.8.1/bin/python3.8-config --include)
LINK="-L/usr/local/lib -L/usr/local/opt/openssl@1.1/lib -L/usr/local/opt/sqlite/lib -L/Applications/Xcode.app/Contents/Developer/Platforms/MacOSX.platform/Developer/SDKs/MacOSX10.15.sdk"
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

ex6_wrap.cpp : ex6.i
	$(SWIG) -c++  -python -o ex6_wrap.cpp ex6.i

_example.so: ex6.i
	$(PYTHON) setup.py build_ext --inplace

.PHONY: manual
manual:
	$(MAKE) clean
	@echo $(PYTHONINCLUDE) 
	@echo $(LINK) 
	@echo $(LINK2) 
	@echo "Hi tim"
	$(SWIG) -c++  -python ex6.i
	g++ -fpic -c  $(PYTHONINCLUDE) -o SS.o SS.cpp
	g++ -fpic -c  $(PYTHONINCLUDE) -o ex6.o ex6_wrap.cpp
	g++ SS.o ex6.o $(LINK) -o _ex6.so




.PHONY: ex6.i

.PHONY: test
test:
	$(PYTHON) -m pytest test.py


