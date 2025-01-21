# Experimental!
R ~ "git: github.com/uiua-lang/rayua"

Rgb        ↚ ⌅(⁅|∘)×255
ToRayColor ↚ ⌅(⍜°⍉(⊂⊙255)|⍜°⍉↙₃) Rgb
CImpl      ↚ ⍉⊟°ℂ

# Transformations
┌─╴Transform
  Up    ← ℂ0 ¯1
  Down  ← ¯Up
  Left  ← ℂ¯1 0
  Right ← ¯Left
  
  # Convert an array from complex coordinates to vector cooridinates
  # Coordinates ? Complex
  Coords ← ⌅(⍥CImpl=3⊸type|⍥°CImpl=0⊸type)
└─╴
T ← Transform

┌─╴Draw
  # Fill the whole screen with a color
  # ? Color
  Background ← R~ClearBackground ToRayColor
  
  Circle ← ∵₁(R~DrawCircle ⊙°¤) ⊙∵¤ ⤚⋅: ToRayColor
  # Draw a circle on the screen
  # ? Color Radius Center
  Circle ← ∵◇R~DrawCircle ⍜⊙◌∩∵₁□ ⤚⋅: ⊓(ToRayColor|∘|T~Coords)
  
  # Print text to the screen
  # ? Color Size Position Text
  Text ← R~DrawText ⤚⋅⤚⋅: ⊓(ToRayColor|∘|T~Coords|$"_")
  
  Rect ← ∵₁R~DrawRectangle ⤚⋅: ToRayColor
  # Draw a rectangle on the screen
  # ? Color Size Position
  Rect ← ∵◇R~DrawRectangle ∩₃∵₁□ ⤚⋅: ⊓(ToRayColor|∩T~Coords)
  
  # Draw a square on the screen
  # ? Color Size Position
  Square ← Rect⊙∵(↯2) ⊓(∘|∘|T~Coords)
└─╴

┌─╴Key
  # Boolean for if the key was pressed once
  # ? Key
  Pressed ← ∵◇R~IsKeyPressed
  Down    ← ∵◇R~IsKeyDown
  
  # Returns array of direction constants for WASD keys pressed
  # Takes a boolean to choose between keypress and keydown
  # Direction ? Pressed
  WASD ← ▽⊙Transform![Up Left Down Right]⨬(Down|Pressed)⊙"wasd"
└─╴

┌─╴Mouse
  Pressed ← R~IsMouseButtonPressed
  Down    ← R~IsMouseButtonDown
  Pos     ← (°T~Coords ⌅(R~GetMousePosition|R~SetMousePosition))
  Change  ← (⌅(R~GetMouseDelta|⍜Pos+°T~Coords))
  
  Left    ← R~MouseButton~Left
  Right   ← R~MouseButton~Right
  Middle  ← R~MouseButton~Middle
  Side    ← R~MouseButton~Side
  Extra   ← R~MouseButton~Extra
  Forward ← R~MouseButton~Forward
  Back    ← R~MouseButton~Back
└─╴

# Open a new window with title
# ? WindowSize WindowTitle
Open ← R~InitWindow °⊟ T~Coords

# Set the target FPS for the window
# Inverse will retrieve the current FPS
# ? FPS
FPS ← ⌅(R~SetTargetFPS|R~GetFPS)

# Number of seconds since the window opened
# Seconds ? 
Time ← (R~GetTime)

Loop! ← (
  ⍢(R~BeginDrawing
    ^0
    R~EndDrawing
  | ¬ R~WindowShouldClose
  )
  R~CloseWindow
)
