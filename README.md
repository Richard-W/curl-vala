vala-curl
=========

This shared library provides an object-oriented interface to libcurl for vala and gobject.

Installation
------------

It is recommended to build this library in a seperate directory.

> mkdir build
> 
> cd build
> 
> ../configure
> 
> make
> 
> make install

This builds and installs the library and some metadata files so you can compile and link your
programs with the following command

> valac myprog.vala --pkg vala-curl
