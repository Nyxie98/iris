# Experimental!
I ~ "git: github.com/Marcos-cat/iris"

Size ← 1024
~ {Zoom Center Iters}
Radius ← ˜ⁿ2¯Zoom
Start  ← New ¯0.5 ¯0.6r 16
Render ← ⍉ <2⌵ ⍥(+°√) Iters⟜(. +Center|˙⊞ℂ ×Radius|-⊸¬÷⟜⇡ ÷4Size)
I~Open Size "Mandelbrot Zoom"
Fractal ← I~Texture~LoadImage Render Start
Start $ShowInfo 1
I~Loop!(
  I~Key~Pressed‼@H⊙¬
  ⟜(
    I~Mouse!Drag‼Left(⍜⊙⊙Center(- ×÷÷₂Size) ◡⋅Radius)
    I~Mouse~Scroll!⍜⊙Zoom(+÷4)
    ⍜⊙Iters(↥₁+) /-I~Key~Down"jk"
    I~Key~Pressed‼@r ⋅Start
  )
  ⍥⊸(◌°⊸I~Texture~Image⊙Fractal Render)⊸(¬≍)
  I~Texture~DrawScreen Fractal
  ⍥(
    ⊸{⊃($"FPS: _" I~Screen~FPS
      | $"Center: _" $"_ + _i" °˜ℂ Center
      | $"Width: _" ×₂Radius
      | $"Iters: _" Iters
      | "[J/K] to change iters"
      | "[H] to hide this info"
      | "[R] to reset")}
    I~Draw~Text Red 30 10_10 /$"_\n_"
  )⤙⊙∘
)
