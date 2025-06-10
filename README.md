# Iris

*A simple game library around [Rayua](https://github.com/uiua-lang/rayua)*

```uiua
# Experimental!
I ~ "git: github.com/Marcos-cat/iris"
```

*All further examples on this page will assume that this import is at the top*

## Features

This is a list of the core improvements over Rayua that drove me to write this.

1. **Shorter names**. I want more code than words in my code. Rayua uses the
   names of the C functions from Raylib, which are quite verbose.
2. **Pervasive functions**. Iris adds logic so that drawing many shapes only
   takes one function call. The basic Rayua functions are direct wrappers of the
   C functions, which of course aren't pervasive, and require heavy use of
   `≡ rows`.
3. **Complex coordinates**. All functions that accept a pair of pixel values (a
   width and height, or a position) also accept complex scalars. This can make
   manipulating many coordinates much easier, as they are scalars. It also
   influences the user to use complex numbers, which can make 2d calculations
   much easier.
4. **Inverses**. Many Iris functions that act as getters are also setters as
   inverses. This removes the need for many similar functions, such as
   `SetTargetFPS` and `GetFPS`.
5. **Normal colors**. Iris exclusively uses Uiua-native colors (RGB \[0, 1\])
   instead of \[0, 255\]. This makes manipulating colors much easier - functions
   like `⁅`, `¬`, or `√` now work. It also means that you can use the
   [built-in color constants](https://www.uiua.org/docs/constants).

[Function Docs](https://marcos-cat.github.io/iris/)

[Examples](https://github.com/Marcos-cat/iris-examples)

## Projects in Iris

- [Wordle](https://github.com/Marcos-cat/wordle-uiua)
- [Fractal Zoom](https://github.com/ronondex2009/Uiua-Interactive-Fractal-Zoomer)
- [Minesweeper](https://github.com/Marcos-cat/minesweeper-uiua)
- [Bejeweled](https://github.com/donstenzel/bejeweled-uiua)

## Basic example

```uiua
I~Open 500_500 "The Title"

I~Loop!(
  I~Draw~Background Blue
)
```

This example opens a window that is 500 pixels tall by 500 pixels wide, with a
title of "The Title". Then, the background is drawn in blue in a loop until the
user closes the window.

This introduces the two main top-level bindings from Iris: `Open` and `Loop!`.
`Open` must be called before `Loop!` is.

## Game Loop

`Loop!` is the where all the logic of your game will go. The code passed to it
will be run once every frame. A typical game will involve drawing the background
at the start of the loop, computing the game-state from user-input, and then
drawing shapes on the screen based on the game-state.

## Modules

Iris has a few modules to control different parts of an OS window. The most
common are:

- `Draw` - draw different shapes on the screen
- `Mouse` - access the user's mouse
- `Key` - access the user's keyboard
- `Screen` - access the OS window
