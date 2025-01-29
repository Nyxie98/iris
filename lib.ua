# Experimental!
R ~ "git: github.com/uiua-lang/rayua"

ToRayColor ↚ ⌅(⍜°⍉⬚255↙₄⁅) ×255
BoxStrings ↚ ⌅(⍥∵₁□=1⊸type|∵°□)

# Transformations
┌─╴Transform
  Up    ← ℂ0 ¯1
  Down  ← ¯Up
  Left  ← ℂ¯1 0
  Right ← ¯Left
  
  CImpl ↚ ⍉⊟°ℂ
  # Convert an array from complex coordinates to vector cooridinates
  # Coordinates ? Complex
  Coords ← ⌅(⍥CImpl=3⊸type|⍥°CImpl=0⊸type)
└─╴
T ← Transform

┌─╴Collide
  # Check if two rectangles collide
  Rects ← /×/⊂> ⇌ ∩(⊟∵⊙∘) ⊙: ∩°⊟ ∩(\+°⍉₂T~Coords)
  
  # Check if two circles collide
  # ? Radius₁ Center₁ Radius₂ Center₂
  Circles ← <⊓(+|⌵-∩°T~Coords)⊙:
  
  # Check if a rectangle and a circle collide
  # ? Rect Radius Center
  RectCircle ← > ⌵- ⊸(↥⊙↧) °⊟\+°⍉°T~Coords ⊙:
└─╴

┌─╴Color
  # A color with an opacity of zero
  Clear ← [0 0 0 0]
  
  # Convert an rgb color to a Uiua color
  Rgb ← ÷255
  
  # Convert a hexadecimal string into a color
  Hex ← Rgb +×16∩⍉⧈°⊟¤¤2 ⊗⊙HexDigits ⬚@f∵◇(↘=@#⊸⊢) BoxStrings ¯⌵
└─╴

# Draw different shapes onto the screen
┌─╴Draw
  IsColor ↚ ⊃(⍤.∊3_4⊣△|°0type)
  
  # Fill the whole screen with a color
  # ? Color
  Background ← R~ClearBackground ToRayColor
  
  # Draw a line on the screen
  # Use a fill to set the thickness
  # ? Color A B
  Line ← (
    ⊓(∵₁□ToRayColor|∩(∵₁□T~Coords))
    ⍣(∵◇R~DrawLineEx⊙⊙(°0⊸type°◌)|∵◇R~DrawLine) ⤚⋅⊙∘
  )
  
  # Draw a circle on the screen
  # ? Color Radius Center
  Circle ← ∵◇R~DrawCircle ⤚⋅: ⊓(∵₁□ToRayColor|∘|∵₁□T~Coords)
  
  # Draw a sector of a circle on the screen
  # The two angles (Start and Angle) are given in rotations 0-1
  # 0 is the top of the screen
  # ? Color Radius Start Angle Center 
  Sector ← (
    ⊓(∵₁□ToRayColor|∘|∩(-90×360) ⟜+ ⊙⟜(×32)|∵₁□T~Coords)
    ∵◇R~DrawCircleSector ⤚⋅⤙⊙⊙⊙⊙◌
  )
  
  # Used as a fill to center text
  Centered ← ∞
  
  # Print text to the screen
  # Fill with `Centered` to center the text
  # ? Color Size Position Text
  Text ← (
    ⊓(∵₁□ToRayColor|∘|∵₁□T~Coords|∵⍚$"_"BoxStrings)
    ⨬(∵◇R~DrawText|∵◇R~DrawTextCentered) ⍣(≍Centered°◌|0) ⤚⋅⤚⋅:
  )
  
  # Draw a rectangle on the screen
  # ? Color Size Position
  Rect ← ∵◇R~DrawRectangle ⤚⋅: ⊓(∵₁□ToRayColor|∩(∵₁□T~Coords))
  
  # Draw a square on the screen
  # ? Color Size Position
  Square ← Rect ⊙∵(↯2)
  
  ┌─╴Texture
    # Load a texture from a filepath
    # Texture ? Path
    Load ← (R~LoadTexture)
    
    # Unload a texture, freeing it's memory
    Unload ← (R~UnloadTexture)
    
    # Get the dimensions of a texture
    Size ← ℂ∵₁R~Texture!⊃Width Height
    
    FillColor ↚ (∵₁□ ToRayColor ⍣(⊸IsColor °◌|White))
    
    # Draw a loaded texture onto the screen
    # Provide a fill to draw with a color
    # ? Position Texture
    Draw ← ∵◇R~DrawTexture : ⊓(∵₁□T~Coords|∵₁□|FillColor)
    Call ← Draw
    
    # Draw a portion of a texture onto the screen
    # 
    # This function takes two rectangles. The first is the section of the texture to draw, and the second is where to draw it.
    # The next parameters are to rotate the To rectangle at some Angle, centered around an Origin.
    # Provide a fill to draw with a color
    # ? From To Origin Angle Texture
    Map ← (
      ⊓(∩(∵₂(□♭)T~Coords)|∵₁□T~Coords|×360|∵₁□|FillColor)
      ∵◇R~DrawTexturePro ⤙⊙⊙⊙⊙◌
    )
  └─╴
└─╴

Texture ← Draw~Texture

┌─╴Key
  # Check if a key was pressed once
  # ? Key
  Pressed ← ∵◇R~IsKeyPressed
  
  # Check if a key is down
  # ? Key
  Down ← ∵◇R~IsKeyDown
  
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
  
  # Get an arrow key for a specific direction
  # ^: Up, v: Down, <: Left, >: Right
  # Key ? Character
  Arrow ← get⊙(map "^v<>" R~Key![Up Down Left Right])
  
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
  # Check if a mouse button was pressed once
  # ? Button
  Pressed ← ∵R~IsMouseButtonPressed
  
  # Check if a mouse button is down
  # ? Button
  Down ← ∵R~IsMouseButtonDown
  
  # The current position of the mouse
  Pos ← (°T~Coords R~GetMousePosition)
  
  # How many pixels the mouse has moved since the last frame
  Change ← (°T~Coords R~GetMouseDelta)
  
  # Hide the mouse from the user
  Hide ← ⌅(R~HideCursor|R~ShowCursor)
  
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
  OnScreen ← (R~IsCursorOnScreen)
  
  Left    ← R~MouseButton~Left
  Right   ← R~MouseButton~Right
  Middle  ← R~MouseButton~Middle
  Side    ← R~MouseButton~Side
  Extra   ← R~MouseButton~Extra
  Forward ← R~MouseButton~Forward
  Back    ← R~MouseButton~Back
└─╴

┌─╴Screen
  # Check if the screen is fullscreen
  # Inverse will set the screen state
  Full ← ⌅(R~IsWindowFullscreen|⍥R~ToggleFullscreen≠R~IsWindowFullscreen)
  
  # Get the size of the screen
  # Inverse will set the size
  Size ← °T~Coords⊟ ⌅(R~GetRenderWidth R~GetRenderHeight|R~SetWindowSize °Full 1)
  
  # Get the current FPS
  # Inverse will set the target FPS for the screen
  FPS ← ⌅(R~GetFPS|R~SetTargetFPS)
└─╴

# Open a new screen with title
# ? Size Title
Open ← R~InitWindow ⊓(°⊟ ⍥(↯2)≍[]⊸△ T~Coords|$"_")

# Number of seconds since the screen opened
# Seconds ? 
Time ← (R~GetTime)

# Delta-time since last frame in seconds
Dt ← (R~GetFrameTime)

Loop! ← (
  ⍢(R~BeginDrawing
    ^0
    R~EndDrawing
  | ¬ R~WindowShouldClose
  )
  R~CloseWindow
)
