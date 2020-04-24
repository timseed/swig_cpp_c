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
