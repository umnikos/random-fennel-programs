# Random fennel programs

This repo holds a bunch of stuff written in fennel (mostly macros).
Everything here is made to be compiled or ran with [my fork of fennel](https://github.com/umnikos/fennel).

## Why fennel?

Lua is a beautifully simple language, but eventually after writing a lot of it it becomes apparent that there's a lot of boilerplate involved.
While one can easily make abstractions that eliminate some of that boilerplate, these abstractions always come at a runtime cost that is difficult to quantify and difficult to get rid of.
There are many languages that compile to Lua, but of those Fennel is the only one I found that has basically zero runtime overhead *and* is infinitely extendable through macros.

## Why does this repo exist?

Fennel inherits the Lua philosophy of giving you the bare minimum, but the whole reason I want to use Fennel is to have more than the bare minimum.
While some things need to be patched into the compiler to become possible, most things can be done with a big pile of macros.

The eventual goal with this repo is to simply create a big pile of code written in Fennel to serve as a standard library for other people to use and as a proof that Fennel is a good choice for writing code that compiles to Lua.
