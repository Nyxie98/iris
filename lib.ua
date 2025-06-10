# Experimental!
Rayua ≁ "git: github.com/uiua-lang/rayua"

ToRayColor ↚ ⌅(⍥(⍜°⍉⬚255↙₄)⊸(=3⊣△) ⁅) ×255
BoxStrings ↚ ⌅(⍥≡₁□=1⊸type|≡₀°□)
Os‼        ↚^ ▽≍os°□₂

# Transformations
┌─╴Transform
  Up    ← ℂ0 ¯1
  Down  ← ¯Up
  Left  ← ℂ¯1 0
  Right ← ¯Left

  CImpl ↚ ⍉⊟°ℂ

  # Convert an array from complex coordinates to vector cooridinates
  # 
  # Returns an array with the shape of the orignal, and and an additional 2-long trailing axis.
  # The first component is the `X`, and the second is the `Y`.
  # The imaginary part of a complex number corresponds to `X` and the real part to `Y`.
  # `°Coords` takes vector coordinates and gives the complex equivalent.
  # Coordinates ? Complex
  Coords ← ⌅(⍥CImpl=3⊸type|⍥°CImpl=0⊸type)

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

  # Track caller!
  # Get the alpha channel (transparency) of an image
  # 
  # If `Alpha` is called on an image without an alpha channel, a fully opaque one will be added.
  # `⍜Alpha` edits the alpha channel, and `°⊸Alpha` can be used to set it.
  # For either inverse if a scalar is provided the entire alpha channel will be set to it.
  # `0` is fully transparent and `1` is fully opaque.
  Alpha ← ⊣°⍉ ⌅(⨬(⍉˜⊂1|⍜°⍉⬚1↙₄|∘|∘)⊸ColorFormat)
└─╴

┌─╴Screen
  # Check if the screen is fullscreen
  # Inverse will set the screen state
  Full ← ⌅(Rayua~IsWindowFullscreen|⍥Rayua~ToggleFullscreen≠Rayua~IsWindowFullscreen)

  # Get the size of the screen
  # Inverse will set the size
  Size ← °T~Coords ⌅(Os‼macos÷₂ ⊟Rayua~GetRenderWidth Rayua~GetRenderHeight|Rayua~SetWindowSize °⊟ ⍥(↯2)≍[]⊸△ °Full 1)

  # Get the size of the screen when it is fullscreen
  FullSize ← °T~Coords⊟ Rayua!⊃GetMonitorWidth GetMonitorHeight (Rayua~GetCurrentMonitor)

  # Get the current FPS
  # Inverse will set the target FPS for the screen
  FPS ← ⌅(Rayua~GetFPS|Rayua~SetTargetFPS)
└─╴

IsColor ↚ ⊃(⍤.∊3_4⊣△|°0type)

┌─╴Texture
  ≁Data {Buffer ColorFormat}

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

  # Track caller!
  # Get the image in a texture without unloading the texture
  # 
  # `Image` remembers the color format of the image you made the texture with. If you provided a grayscale, you will get back a grayscale.
  # `°⊸Image` edits the image in a texture. It takes the new image as the first argument and the texture as the second argument.
  # `⍜Image` gets the image, allows you to change it, and then puts the new image back in the texture.
  # If any of the properties of the image are altered, like the shape or the color format, this function will error.
  # Image ? Texture
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

  FillColor ↚ (≡₁□ ToRayColor ⍣(⊸IsColor °◌|White))

  # Draw a loaded texture onto the screen
  # Provide a fill to draw with a color
  # ? Texture Size Position
  Draw ← (
    ⊓(≡₁⊃□(□⊂0_0 T~Coords Size)|˜≡₀⍚⊂ ∩(≡₁□T~Coords)) ⊙(⍥(↯2)≍[]⊸△)
    ≡₀◇(Rayua~DrawTexturePro Data~Buffer)⊙⊙⊙(□0_0 0 FillColor)
  )

  # Like `Draw`, but the size is relative to the texture file
  # ? Texture Scale Position
  DrawScaled ← Draw ⟜(≡₀°□ × ≡₁(□Size))

  # Draw a texture covering the whole screen.
  # 
  # The texture will be stretched/scaled to properly fit the size of the screen.
  # ? Texture
  DrawScreen ← Draw⊙(Screen~Size 0_0)

  # Draw a portion of a texture onto the screen
  # 
  # This function takes two rectangles. The first is the section of the texture to draw, and the second is where to draw it.
  # The next parameters are to rotate the To rectangle at some Angle, centered around an Origin.
  # Provide a fill to draw with a color
  # ? Texture From To Origin Angle
  Map ← (
    ⊓(≡₁□|∩(≡₂(□♭)T~Coords)|≡₁□T~Coords|×360|FillColor)
    ≡₀◇(Rayua~DrawTexturePro Data~Buffer)
  )
└─╴

# Draw different shapes onto the screen
┌─╴Draw
  # Fill the whole screen with a color
  # ? Color
  Background ← Rayua~ClearBackground ToRayColor

  # Draw a line on the screen
  # Use a fill to set the thickness
  # ? Color A B
  Line ← (
    ⊓(≡₁□ToRayColor|∩(≡₁□T~Coords))
    ⍣(≡₀◇Rayua~DrawLineEx⊙⊙(°0⊸type°◌)|≡₀◇Rayua~DrawLine) ⤚⋅⊙∘
  )

  # Draw a circle on the screen
  # ? Color Radius Center
  Circle ← ≡₀◇Rayua~DrawCircle ⤚⋅: ⊓(≡₁□ToRayColor|∘|≡₁□T~Coords)

  # Draw a sector of a circle on the screen
  # The two angles (Start and Angle) are given in rotations 0-1
  # 0 is the top of the screen
  # ? Color Radius Start Angle Center 
  Sector ← (
    ⊓(≡₁□ToRayColor|∘|∩(-90×360) ⟜+ ⊙⟜(×32)|≡₁□T~Coords)
    ≡₀◇Rayua~DrawCircleSector ⤚⋅⤙⊙⊙⊙⊙◌
  )

  Text! ↚ ≡₀◇^0 ⤚⋅⤚⋅: ⊓(≡₁□ToRayColor|∘|≡₁□T~Coords|≡₀⍚$"_"BoxStrings)

  # Print text to the screen
  # ? Color Size Position Text
  Text ← Text!Rayua~DrawText

  # Draw a rectangle on the screen
  # ? Color Size Position
  Rect ← ≡₀◇Rayua~DrawRectangle ⤚⋅: ⊓(≡₁□ToRayColor|∩(≡₁□T~Coords))

  # Draw a square on the screen
  # ? Color Size Position
  Square ← Rect ⊙≡₀(↯2)

  Texture ← Texture~Draw

  ┌─╴Centered
    # Print horizontally centered text to the screen
    # ? Color Size Position Text
    Text ← Text!Rayua~DrawTextCentered

    # Draw a centered rectangle on the screen
    # ? Color Size Position
    Rect ← Draw~Rect⊙⟜(-÷₂∩°T~Coords)

    # Draw a centered square on the screen
    # ? Color Size Position
    Square ← Rect ⊙(ℂ.)

    Circle ← Draw~Circle
  └─╴
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
  UDLR ← Impl⊙(Arrow "^v<>")
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

  # Check if the mouse is on the screen
  OnScreen ← (Rayua~IsCursorOnScreen)
└─╴

# Open a new screen with a title
# ? Size Title
Open ← Rayua~InitWindow ⊓(°⊟ ⍥(↯2)≍[]⊸△ T~Coords|$"_") Rayua~SetTraceLogLevel Rayua~TraceLogLevel~Warning

# Sets the trace log to `DEBUG`, printing extra information about what Raylib is doing
Debug ← Rayua~SetTraceLogLevel Rayua~TraceLogLevel~Debug

# Number of seconds since the screen opened
# Seconds ? 
Time ← (Rayua~GetTime)

# Delta-time since last frame in seconds
Dt ← (Rayua~GetFrameTime)

Loop! ← Rayua~CloseWindow ⍢(Rayua~EndDrawing ^0 Rayua~BeginDrawing|¬Rayua~WindowShouldClose)
