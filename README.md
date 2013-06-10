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

Issues
------

Currently the library does not work as intended as it is under heavy development. Sending files
does not work at the moment but fetching website works just fine.
