"""
setup.py file for SWIG example
"""

from distutils.core import setup, Extension


example_module = Extension("_ex6", sources=["ex6_wrap.cpp", "SS.cpp"],)

setup(
    name="ex6",
    version="0.1",
    author="SWIG Docs",
    description="""Simple swig example from docs""",
    ext_modules=[example_module],
    py_modules=["ex6"],
)
