# Experimental!
Rayua ~ "git: github.com/uiua-lang/rayua"

ToRayColor ↚ ⌅(⍥(⍜°⍉⬚255↙₄)⊸(=3⊣△) ⁅) ×255
BoxStrings ↚ ⌅(⍥≡₁□=1⊸type|≡₀°□)
F          ↚ ⍥(⊂@\n)>1⊃⧻/$"_\n_"pretty
Os‼        ↚^ ▽≍os°□₂
S!         ↚^ $"⊃(_)"/$"_|_"˜⍚⊂@∘˜⍚↯@⋅-@a°□₁

# Transformations
┌─╴Transform
  Up    ← ℂ0 ¯1
  Down  ← ¯Up
  Left  ← ℂ¯1 0
  Right ← ¯Left

  CImpl ↚ ⍉⊟°ℂ

  CoordError ↚ ⨬(
    ⨬◌(˜⍤0$"Expected number array with X and Y components, but got shape _")≠2⊸⬚2⊣◌
  | ◌◌
  | ˜⍤0$"Expeced number or complex array, but got a _ array" ⨬"character""box"=1 ⊙◌
  )⊸˜⊗0_3 ⊃type△

  # Convert an array from complex coordinates to vector cooridinates
  #
  # Returns an array with the shape of the orignal, and and an additional 2-long trailing axis.
  # The first component is the `X`, and the second is the `Y`.
  # The imaginary part of a complex number corresponds to `X` and the real part to `Y`.
  # `°Coords` takes vector coordinates and gives the complex equivalent.
  # Coordinates ? Complex
  # Track caller!
  Coords ← ⌅(⍥CImpl=3⊸type ⊸CoordError|⍥°CImpl=0⊸type ⊸CoordError)

  Grid ← ˜ℂ⊢₂°⍉°⊡
└─╴
T ← Transform

┌─╴Collide
  # Check if two rectangles collide
  # ? Size₁ Position₁ Size₂ Position₂
  Rects ← /×/⊂> ⇌ ˜∩(⊟≡₀⊙∘) ∩˜(⟜+∩°⍉∩T~Coords)

  # Check if two circles collide
  # ? Radius₁ Center₁ Radius₂ Center₂
  Circles ← <⊓(+|⌵-∩°T~Coords)⊙:

  # Check if a point is inside a circle
  # ? Radius Center Point
  CirclePoint ← ≤⊙(⌵-∩°T~Coords)

  # Check if a point is inside a rectangle
  # ? Rect Point
  RectPoint ← ×××∩°ℂ⊓⌟≥≤ °⊟\+°⍉ ∩°T~Coords

  # Check if a rectangle and a circle collide
  # ? Rect Radius Center
  RectCircle ← > ⌵- ⊸(↥⊙↧) °⊟\+°⍉°T~Coords ⊙:
└─╴

# 0 = Black and white, 1 = Color, 2 = Black and white alpha, 3 = Color alpha
# ? Image
ColorFormat ↚ ⍤"Image does not have a possible color format"⊸≠4 ˜⊗{[][3][2][4]} □↘₂△
FormatName  ↚ ⍥$"_ with alpha"≥2⟜(⨬("grayscale"|"color")◿₂)

┌─╴Color
  # A color with an opacity of zero
  Clear ← [0 0 0 0]

  # Convert a color from 8-bit rgb to Uiua colors
  #
  # Uiua color channels are represented by values `0-1`, while standard graphics uses integers from `0-255`.
  # Colors are rounded to four decimal places so that they display nicely (this will not affect their 8-bit value.)
  # `°Rgb` converts a Uiua color back to an 8-bit color.
  # Both `Rgb` and `°Rgb` clamp the values to be within the correct ranges.
  # UiuaColor ? RgbColor
  Rgb ← ⌅(↥0↧1⁅₄) ÷255 °⌅(↥0↧255⁅)

  FillOpacity ↚ (⌅(^0|^0))!⬚1≡₀°□
  HexImpl     ↚ Rgb ⌝⊥16°⌅≡⬚0↙₂ ≡⇌ ⌅(↯∞_2|♭) ˜⊗HexDigits ⌅(⍣⌝⊂◌@#|⊂@#)

  # Convert a hexadecimal string into a color
  #
  # Expects a string in the form `#RRGGBB` where all the letters are hexadecimal digits corresponding to color channels.
  # The leading `#` can be omitted, and and alpha channel can also be specified at the end.
  # This function is pervasive, and will convert an array of strings, or an array of box strings into an array of colors.
  # The output will always be non-box, so if a single string has an alpha channel, all of the output will.
  # `°Hex` converts a color back into a hexidecimal string, always including the `#`.
  # Color ? HexString
  Hex ← FillOpacity (⌅(≡₀^0|≡₁°^0))!⍜°□HexImpl BoxStrings ⌅(¯⌵)

  # Get the alpha channel (transparency) of an image
  #
  # If `Alpha` is called on an image without an alpha channel, a fully opaque one will be added.
  # `⍜Alpha` edits the alpha channel, and `°⊸Alpha` can be used to set it.
  # For either inverse if a scalar is provided the entire alpha channel will be set to it.
  # `0` is fully transparent and `1` is fully opaque.
  # Track caller!
  Alpha ← ⊣°⍉ ⌅(⨬(⍉˜⊂1|⍜°⍉⬚1↙₄|∘|∘)⊸ColorFormat)
└─╴

┌─╴Window
  # Check if the window is fullscreen
  #
  # `Full` returns a boolean to tell if the window is in fullscreen mode.
  # `°Full` can be passed a boolean to set the state of fullscreen mode.
  # A common pattern to toggle fullscreen is `⍜Full¬`.
  # Track caller!
  Full ← ⌅(
    Rayua~IsWindowFullscreen
  | ⍥⊸(˜⍤$"Fullscreen state must be a boolean, but it is _"F)¬≍1⊸∊0_1
    ⍥Rayua~ToggleFullscreen≠Rayua~IsWindowFullscreen)

  # The size of the window
  #
  # The dimensions returned are in pixels.
  # `°Size` sets the size of the window.
  # If the window is in fullscreen mode when `°Size` is called, fullscreen mode with be turned off.
  # Neither dimension of the window can be zero.
  # If a single number is given as the dimensions, it will be used as both the width and the height.
  # Track caller!
  Size ← (°T~Coords ⌅(
      Os‼macos÷₂ ⊟Rayua~GetRenderWidth Rayua~GetRenderHeight
    | ⍥⊸(˜⍤0$"Window size must be greater than zero, but it is _"F) ¬×⊸⊃(≍1/×>0|≍[2]△) ⌈ ⍥(↯2)≍[]⊸△ °Full 0
      Rayua~SetWindowSize °⊟))

  # Get the size of the window when it is fullscreen
  FullSize ← (°T~Coords⊟ Rayua!⊃GetMonitorWidth GetMonitorHeight Rayua~GetCurrentMonitor)

  # The active FPS (framerate)
  #
  # `FPS` returns the actual framerate, which varies based on how long your device takes to run a frame.
  # `°FPS` sets the maximum FPS. By default, the FPS is unbounded, and frames will be run as fast as possible.
  # `FPS` can take `∞` to have the fastest possible framerate (the default behavior.)
  # Track caller!
  FPS ← ⌅(
    Rayua~GetFPS
  | ⍥⊸(˜⍤0$"FPS must be greater than zero, but it is _"F)¬×⊸⊃(>0|≍[]△) ⌈
    Rayua~SetTargetFPS)
└─╴

# Deprecated!
Screen ← Window

┌─╴Sound
  ≁Data {Buffer Clone}

  # Unload a sound, freeing it's memory
  Unload ← ≡₁(Rayua~UnloadSound ⍤"Cannot free an active sound, only a source sound." Data!⊃Clone Buffer)

  # ActiveSound ? SourceSound
  Play ← Data⊙1 ⊸Rayua~PlaySound Rayua~LoadSoundAlias Data~Buffer

  Start ← ⍜Data~Buffer⊸Rayua~PlaySound
└─╴

ColorArg ↚ ≡₁□ ToRayColor
SizeArg  ↚ ≡₁□ ⍥˙⊟=0⧻⊸△ T~Coords
PosArg   ↚ ≡₁□ T~Coords

IsTexture ↚ ≍□"texture"⬚∞⊣

┌─╴Texture
  ≁Data {Buffer ColorFormat Type ← "texture"}

  # Unload a texture, freeing it's memory
  #
  # Once a texture is unloaded, attempting to draw it will result in an all-black texture.
  # Calling this function multiple times on a texture will not doing anything.
  # ? Texture
  Unload ← Rayua~UnloadTexture Data~Buffer

  # Get the dimensions of a texture
  # Size ? Texture
  Size ← ℂ≡₁(Rayua~Texture!⊃Width Height Data~Buffer)

  # Load a texture from a filepath
  #
  # The file must contain an image, and have the proper extension for the image format.
  # The color format of a texture created this way is always color with an alpha channel.
  # `⍜LoadFile` will load the texture, and then free the memory when the function is over.
  # [NOTE] You cannot load a texture before `Open` is called, it will cause a segfault.
  # Texture ? Path
  LoadFile ← (⌅(^0|.^0|^1))!(Data ⊙3 Rayua~LoadTexture|Unload)

  # ? Image
  ToFullColor ↚ ⨬(⍉˜⊂1↯3|⍜°⍉⬚1↙₄|⍜°⍉(▽3_1)|∘) ⊸ColorFormat

  # ? Data Image
  ToFormat ↚ |2 ⨬(⊢°⍉|⍜°⍉↙₃|⍜°⍉(⊏0_3)|∘) Data~ColorFormat

  # Reads the literal bytes from the buffer with no processing, only shaping
  ReadImageData ↚ ↯⤙(&memcpy"unsigned char"⊙/×) Rayua~Image!(Data⟜[⊃Height Width⊙4]) Data~Buffer

  ToRayImage ↚ ⌅(
    Data ⊃(Rayua~Image ⊃(♭ ToRayColor ToFullColor|°⊟⇌△₂|1 7)|ColorFormat)
  | Rayua~UnloadImage Data~Buffer⟜(ToFormat|°ToRayColor ReadImageData))

  ImageAndTextureData ↚ ⊓(⊃(⇌△₂) ColorFormat|⊃(⊟°ℂSize) Data~ColorFormat)
  ImageError ↚ ⨬(
    ∩($"_ _"⊓/$"_x_"FormatName) ImageAndTextureData
    ˜⍤0 $"A _ image was provided, but the texture is a _ image."
  )⋅◌ ◡(×˜∩≍ ImageAndTextureData)

  # Get the image in a texture without unloading the texture
  #
  # `Image` remembers the color format of the image you made the texture with. If you provided a grayscale, you will get back a grayscale.
  # `°⊸Image` edits the image in a texture. It takes the new image as the first argument and the texture as the second argument.
  # `⍜Image` gets the image, allows you to change it, and then puts the new image back in the texture.
  # If any of the properties of the image are altered, like the shape or the color format, this function will error.
  # Image ? Texture
  # Track caller!
  Image ← (⌅(^0|⟜^0|^1))!(
    °ToRayImage ⍜Data~Buffer Rayua~LoadImageFromTexture
  | ⟜(Rayua~UpdateTexture Data~Buffer)⊙(♭ ToRayColor ToFullColor) ◡˜ImageError)

  # Load a texture from a Uiua image array
  #
  # The provided image can be in any color format a Uiua image can be in, except for complex domain coloring.
  # The formats are defined [in the Uiua tutorial.](https://www.uiua.org/tutorial/images)
  # The format you use to create the texture is the only one that may be used by the texture.
  # Calling `Image` will result in an image of the same format.
  # [NOTE] You cannot load a texture before `Open` is called, it will cause a segfault.
  # Texture ? Image
  LoadImage ← (⌅(^0|^1|.^0|^2))‼(
    ⍜Data~Buffer Rayua~LoadTextureFromImage ToRayImage
  | Unload⟜Image
  | Unload)

  # Draw a texture on the window
  #
  # `Color` tints a texture a particular color.
  # `Angle` is given in rotations `[0,1]`, clockwise.
  # Optional args: Color Angle Centered
  # ? Texture Size Pos
  ~Draw {Color ← White|Angle ← 0|Centered ← 0} (
    ⊃(Color|Angle|⋅∘|Centered)
    ⊓(ColorArg | ×360◿1 | ≡₁⊃(□Data~Buffer|□⊂0_0⊟°ℂSize)
    | ⊃(≡₀⍚⊂ ⍥(+◡⋅÷₂)¬|⋅⋅÷₂) ⊙˜⊓PosArg SizeArg)
    ≡₀◇Rayua~DrawTexturePro S!cdefba
  )

  # Deprecated!
  # **This function is DEPRECATED use** `Draw~Background` **instead**
  #
  # Draw a texture covering the whole window.
  #
  # The texture will be stretched/scaled to properly fit the size of the window.
  # `DrawScreen` also supports a `Color` arg, like `Draw`
  # Optional args: Color
  # ? Texture
  ~DrawScreen [Color ← White] Draw ⊙(Window~Size 0_0) Color:Color
└─╴

# Draw different shapes onto the window
┌─╴Draw
  # Fill the whole window with a color or texture
  #
  # When given a color, `Background` covers the whole window with that color.
  # When given a texture `Background` scales the texture to fit over the whole window.
  # ? Background
  Background ← (
    ⊸IsTexture
    ⨬(Rayua~ClearBackground ⍤"Background only takes a single color or a texture"≍[4]⊸△ ColorArg
    | Texture~Draw⊙(Window~Size 0_0))
  )

  # Draw a line on the window
  #
  # A line will draw from point A to point B, even if either are outside the window.
  # A thickness of zero will cause the line not to draw at all.
  # ? Color Thickness A B
  Line ← ≡₀◇Rayua~DrawLineEx S!cdba ⊓(ColorArg|↥₀⌈|∩PosArg)

  # Draw a circle on the window
  #
  # An angle and a starting position can be supplied to draw a sector of the circle.
  # `Angle` can have the range `[-1,1]` where positive is clockwise.
  # `Start` can have the range `[0,1]` where `0` is upward also moving clockwise.
  # Optional args: Angle Start
  # ? Color Radius Center
  ~Circle {Angle ← 1|Start ← 0} (
    ⊃Angle Start
    ≍1⟜(⌈×32|∩(-90×360) ⊸+) ⊓(⍜⌵↧₁|◿₁|ColorArg|↥₀⌈|PosArg) # B Segments End Start Color Radius Center ?
    ⨬(≡₀◇Rayua~DrawCircleSector S!fecbad|≡₀◇Rayua~DrawCircle S!fed)
  )

  # ? Font Size
  LoadFont ↚ ⨬(memo(Rayua~LoadFontEx⊙⊙[])|Rayua~GetFontDefault)⊸≍∞ ⊙(↥₅ ⍥⁅₋₁ ⊸>₁₀₀)

  # Print text to the window
  #
  # `Font` is a filepath pointing to a font file. If not specified, the Raylib font is used.
  # `Spacing` changes how far apart characters are placed from eachother. By default it is 10% of the fontsize.
  # `Centered` centers the text both horizontally and vertically.
  # Optional args: Font Spacing Centered
  # ? Color Size Position Text
  ~Text {Centered ← 0|Font ← ∞|Spacing ← 0} (
    ⊃(Centered|Font|Spacing)
    ⊙(⊓(□|∘|ColorArg|↥₀|PosArg|≡₀⍚$"_"BoxStrings)
      S!afedbc ≡₀⍚LoadFont⊙⤙⊙⊙∘ ⟜(⍥⋅◡⋅÷₁₀◇≍∞)
    ) # Centered Font Text Pos Size Spacing Color ?
    ≡₀◇(Rayua~DrawTextEx⍥(⍜⊙⋅⋅∘- ◡(÷₂Rayua~MeasureTextEx⊙⊙⋅⊙∘)))
  )

  # Draw a rectangle on the window
  #
  # Optional args: Centered
  # ? Color Size Position
  ~Rect [Centered ← 0] ≡₀◇Rayua~DrawRectangle S!bca ⊓(ColorArg|⍥(≡₀⍚-◡⋅÷₂) ⊙˜⊓PosArg SizeArg) ⊃⋅∘Centered # TODO: Change back once pervasion is fixed

  # Draw a square on the window
  #
  # Exactly like `Rect`, except that the size is a scalar instead of a vector
  # Optional args: Centered
  # ? Color Size Position
  ~Square [Centered ← 0] Rect ⊙(⍉↯2) Centered:Centered

  Texture ← Texture~Draw
└─╴

┌─╴Key
  (⍚˙$"_ ← ∘Rayua~Key~_  # The keycode for the _ key\n"
  )^!(Backspace|Tab|Enter|Delete|Home|End|Insert|PageUp|PageDown|Escape|Pause|LeftControl|RightControl|LeftShift|RightShift)
  Space ← @\s

  Fix ↚ ⍥⋅Tab⊸=@\t ⍥⋅Enter⊸=@\n

  # Check if a key was pressed once
  # ? Key
  Pressed ← ≡₀◇(Rayua~IsKeyPressed Fix)

  # Check if a key is down
  # ? Key
  Down ← ≡₀◇(Rayua~IsKeyDown Fix)

  # Call a function when a key is pressed
  # 
  # The first function is the key to run the function on (or identity to take from the stack)
  # The second function will be called when the key is pressed
  # ? Key Function
  Pressed‼ ← ⍥(^1)Pressed ^0

  # Call a function when a key is down
  # 
  # The first function is the key to run the function on (or identity to take from the stack)
  # The second function will be called when the key is down
  # ? Key Function
  Down‼ ← ⍥(^1)Down ^0

  # Get the characters that the user has typed
  # 
  # This function returns a string of queued characters
  # If the user has not typed since the function was called, the string will be empty
  Typed ← (⍥(⊂:▽⊸≠@\0Rayua~GetCharPressed)∞ "")

  # Get the key codes that the user has typed
  # 
  # This function returns an array of queued key codes
  # If the user has not typed since the function was called, the array will be empty
  TypedCodes ← (⍥(⊂:▽⊸≠0Rayua~GetKeyPressed)∞ [])

  # Emulate a text input on a string
  # 
  # This function edits a string based on the user's keyboard inputs
  # Typing alphanumerics will append to the string, as well as non-printing characters like newline, space, and tab
  # The string will also respect backspace and the Delete key to clear the string
  Input ← (
    ⊸˜∊Delete TypedCodes ⊂:Typed
    ⨬(⍥(⍜↻↘₂-₁⊸⊗@\0) ⧻⊚⊸=@\0 ⊂: ˜⊏"\0\n\t"▽⊸≠∞⬚∞˜⊗[Backspace Enter Tab]
    | ⋅⋅"")
  )

  # Get an arrow key for a specific direction
  # ^: Up, v: Down, <: Left, >: Right
  # Key ? Character
  Arrow ← get⊙(map "^v<>" Rayua~Key![Up Down Left Right])

  # Get a particular function key
  # Key ? Number
  F ← get⊙(map⍜¯⇡12 +290⇡12)

  Impl ↚ ▽⊙Transform![Up Left Down Right]⨬(Down|Pressed)

  # Returns array of direction constants for WASD keys pressed
  # Takes a boolean to choose between keypress and keydown
  # Direction ? Pressed
  WASD ← Impl⊙"wasd"

  # Returns array of direction constants for arrow keys pressed
  # Takes a boolean to choose between keypress and keydown
  # Direction ? Pressed
  ULDR ← Impl⊙(Arrow "^<v>")
└─╴

┌─╴Mouse
  (⍚˙$"_ ← ∘Rayua~MouseButton~_  # The code for the _ mouse button\n"
  )^!(Left|Right|Middle|Side|Extra|Forward|Back)

  # Check if a mouse button was pressed once
  # ? Button
  Pressed ← ≡₀Rayua~IsMouseButtonPressed

  # Check if a mouse button is down
  # ? Button
  Down ← ≡₀Rayua~IsMouseButtonDown

  # The current position of the mouse
  Pos ← (°T~Coords Rayua~GetMousePosition)

  # How many pixels the mouse has moved since the last frame
  Change ← (°T~Coords Rayua~GetMouseDelta)

  # Hide the mouse from the user
  # 
  # `°Hide` will make the mouse reappear.
  # The user can still use the mouse while it it hidden. The affect is purely visual.
  Hide ← ⌅(Rayua~HideCursor|Rayua~ShowCursor)

  # The direction the mouse is scrolling
  # 
  # Returns `0` if the mouse has not scrolled, and `1` or `¯1` depending on the direction scrolled.
  # The sign may not nicely correspond to 'up' or 'down' since the direction of scrolling depends on the user's device.
  Scroll ← (⊣Rayua~GetMouseWheelMoveV)

  # Call a function on the scroll direction when the wheel is scrolled
  # 
  # The function will be called on a value of either `1` or `¯1`, but never `0`
  Scroll! ← ⨬◌(^0) ⊸≠0 Scroll

  # Call a function when the user drags the mouse
  # 
  # The first function is the mouse button that must be down while dragging. 
  # If it is monadic it will pull from the stack.
  # The second function is called when a drag occurs and is supplied the distance dragged.
  # If the mouse does not move, this will not trigger, thus the distance cannot be zero.
  # ? Button Function
  Drag‼ ← ⨬◌(^1) ×Down ⊙(⊸≠0 Change) ^0

  # Call a function on the mouse position when a button is pressed
  # 
  # The first function is the button to run the function on (or identity to take from the stack)
  # The second function will be called with the mouse position as its first argument
  # ? Button Function
  Pressed‼ ← ⍥(^1 Pos)Pressed ^0

  # Call a function on the mouse position when a button is down
  # 
  # The first function is the button to run the function on (or identity to take from the stack)
  # The second function will be called with the mouse position as its first argument
  # ? Button Function
  Down‼ ← ⍥(^1 Pos)Down ^0

  # Check if the mouse is on the window
  OnWindow ← (Rayua~IsCursorOnScreen)

  # Deprecated!
  OnScreen ← (OnWindow)
└─╴

# Open a new window with a title
# ? Size Title
Open ← Rayua~InitWindow ⊓(°⊟ ⍥(↯2)≍[]⊸△ T~Coords|$"_") Rayua~SetTraceLogLevel Rayua~TraceLogLevel~Warning

# Sets the trace log to `DEBUG`, printing extra information about what Raylib is doing
Debug ← Rayua~SetTraceLogLevel Rayua~TraceLogLevel~Debug

# Delta-time since last frame in seconds
Dt ← (Rayua~GetFrameTime)

# ? Conditional Body
Loop‼ ← Rayua~CloseWindow ⍢(
  Rayua~EndDrawing ^1 Rayua~BeginDrawing
| ×¬Rayua~WindowShouldClose ^0)

# ? Body
Loop! ← Loop‼1^0
