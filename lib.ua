# Experimental!
R ~ "git: github.com/uiua-lang/rayua"

Rgb        ↚ ⌅(⁅|∘)×255
ToRayColor ↚ ⌅(⍜°⍉(⊂⊙255)|⍜°⍉↙₃) Rgb
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

# Draw different shapes onto the screen
┌─╴Draw
  # Used as a fill to center some shape
  Centered ← ∞
  
  # Fill the whole screen with a color
  # ? Color
  Background ← R~ClearBackground ToRayColor

  # Draw a circle on the screen
  # ? Color Radius Center
  Circle ← ∵◇R~DrawCircle ⤚⋅: ⊓(∵₁□ToRayColor|∘|∵₁□T~Coords)
  
  # Print text to the screen
  # Fill with `Centered` to center the text
  # ? Color Size Position Text
  Text ← (
    ⤚⋅⤚⋅: ⊓(∵₁□ToRayColor|∘|∵₁□T~Coords|∵⍚$"_"BoxStrings)
    ⨬(∵◇R~DrawText|∵◇R~DrawTextCentered) ⍣(≍Centered°◌|0)
  )
  
  # Draw a rectangle on the screen
  # ? Color Size Position
  Rect ← ∵◇R~DrawRectangle ⤚⋅: ⊓(∵₁□ToRayColor|∩(∵₁□T~Coords))
  
  # Draw a square on the screen
  # ? Color Size Position
  Square ← Rect ⊙∵(↯2)
└─╴

┌─╴Key
  # Check if a key was pressed once
  # ? Key
  Pressed ← ∵◇R~IsKeyPressed
  # Check if a key is down
  # ? Key
  Down ← ∵◇R~IsKeyDown
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
  
  Left    ← R~MouseButton~Left
  Right   ← R~MouseButton~Right
  Middle  ← R~MouseButton~Middle
  Side    ← R~MouseButton~Side
  Extra   ← R~MouseButton~Extra
  Forward ← R~MouseButton~Forward
  Back    ← R~MouseButton~Back
└─╴

# Open a new window with title
# ? Size Title
Open ← R~InitWindow °⊟ ⍥(↯2)≍[]⊸△ T~Coords

# Set the target FPS for the window
# Inverse will retrieve the current FPS
# ? FPS
FPS ← ⌅(R~SetTargetFPS|R~GetFPS)

# Number of seconds since the window opened
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
