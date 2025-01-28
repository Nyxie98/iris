# Experimental!
I ~ "../lib.ua"

# This is an example of a Flappy Bird game.
# It demonstrates how to create multiple game screens, handle user input, render textures.

# The main idea for different screens is to use a state value with the properties of that state.
# The state is then pattern matched to determine which handler to use.
# - The main menu state does not have any properties, it just waits for the user to press space and transitions to the game state.
# - The game state has properties for the bird, pipes, and score.
# - The game over state has a property for the score.

# The handler state takes the current state and returns the next state.
# In the main menu and game over states, the handler just draws the corresponding screen and waits for the user to press space.
# to transition to the next state - the game state. The game state then handles the main game logic:
# - Checking if the bird is colliding with anything
# - Updating applying gravity to the bird
# - Moving the pipes
# - Scoring points
# - Drawing the screen
# - Handling user input

BirdX             ← 100
Gravity           ← 0.5
JumpSpeed         ← ¯10
PipeSpawnPosition ← 640
PipeGap           ← 90
PipeMovementSpeed ← 4
GapsBetweenPipes  ← 300

WindowWidth  ← 640
WindowHeight ← 480

I~Open WindowWidth_WindowHeight "Rayua Flappy Bird"
I~Screen!°FPS 60

┌─╴Bird
  ~[Y ← ÷2WindowHeight|YSpeed ← 0]

  Size   ← ⊟.48
  Center ← ÷2Size
  # Assumes sprite-centered origin
  RenderRect ← ⊂[BirdX Y]⟜Size
  HitboxRect ← ⊟-◡⋅÷₂ ⊃(⊟BirdX +2 Y|⊟.35)
└─╴

┌─╴Pipe
  ~[X Top Bottom Scored Id]
  TopRect    ← [⊃(⊟X⊙0|⊟64 Top)]
  BottomRect ← [⊃(⊟⊃X Bottom|⊟64 -⊙WindowHeight Bottom)]
  Spawn      ← New ⊙(⊃-+ PipeGap +140×⚂-280WindowHeight 0 ⌊×1000⚂)
└─╴

┌─╴State
  |Menu {HighScore}
  |Game {Bird Pipes Score HighScore}
  |GameOver {Bird Pipes Score HighScore DeathTime}
└─╴

File ← $".____" Sep ThisFileDir Sep

CreateGameState ← State~Game ⊃(
  Bird!(°⊸YSpeed JumpSpeed New)
| ≡Pipe~Spawn +50+WindowWidth×GapsBetweenPipes⇡4
| 0)

# ? AnimateSpeed Bird
DrawBird ← I~Draw~Texture~Map ⊓⊃(
  ⊓[⊟⊙0×16◿4⌊×8×I~Time ⊙16_16] Bird~RenderRect # From To ?
| Bird~Center ×4÷WindowHeight Bird~YSpeed ◌    # Origin Angle ?
)(get "bird" °◌)

HandleMenuState ← |1 (
  DrawBird 0.5 Bird
  I~Draw!⬚Centered Text Black 60 [÷2WindowWidth 180] "Uiua Bird"

  ⨬⋅"Press space to start" $"High score: _" ⊸±⊸State~Menu~HighScore
  I~Draw!⬚Centered Text Black 40 [÷2WindowWidth 280]

  # When space is pressed - create a new game state
  I~Key~Pressed‼@\s(CreateGameState State~Menu~HighScore)
)

# ? Pipe
DrawTopPipe ← I~Draw~Texture~Map ⊓Pipe!⊃(
  ⊟⊃[⊃[×32◿4Id ⊙48] 32_32] [⊃[×32◿4Id ⊙24] 32_32] # From ?
| ⊟⊃[⊃[⊃(X|-64Top)] 64_64] [⊃[⊃X 0] [64 -64Top]]  #  To ?
)(0_0 0 get "pipes" °◌)

# ? Pipe
DrawBottomPipe ← I~Draw~Texture~Map ⊓Pipe!⊃(
  ⊟⊃[⊃[×32◿4Id ⊙0] 32_32] [⊃[×32◿4Id ⊙24] 32_32]                          # From ?
| ⊟⊃[⊃[⊃(X|Bottom)] 64_64] [⊃[⊃(X|+64Bottom)] [64 -⊙WindowHeight Bottom]] #  To ?
)(0_0 0 get "pipes" °◌)

# ? Pipes
DrawPipes ← ≡⊃(DrawTopPipe+1)DrawBottomPipe

# ? Score
DrawScore ← I~Draw~Text Black 20 20_20 $"Score: _"

ShouldBeScored ← ×Pipe!⊃(< BirdX +64X|¬Scored)

IsOutOfBounds ← ↥⊃<₀(>WindowHeight) Bird~Y State~Game~Bird

IsCollidingWithPipes ← (
  ⟜(⊂≡Pipe!⊃TopRect BottomRect State~Game~Pipes)
  /↥ I~Collide~Rects Bird~HitboxRect State~Game~Bird
)
IsBirdDead ← ↥⊃IsOutOfBounds IsCollidingWithPipes

HandleGameState ← (
  ¬⊸IsBirdDead
  ⨬( # The bird collided with something, go to game over state and log the time of death
    State!(GameOver °Game) ⊙I~Time
  | # The bird is still alive, update the game state

    # Add speed to bird position
    ⍜State~Game~Bird Bird!(⍜Y+⟜YSpeed)

    # Increment vertical bird speed
    ⍜(Bird~YSpeed State~Game~Bird|+Gravity)

    # Move the pipes
    ⍜(≡Pipe~X State~Game~Pipes|-PipeMovementSpeed)

    # Find the number of unscored pipes that are past the screen
    # (Should normally be at most 1 at a time)
    ⟜(/+≡ShouldBeScored State~Game~Pipes)

    # Increment the score for each of them
    ⍜State~Game~Score+

    # Mark the pipes past the bird as scored
    ⍜(▽⌅⊸≡ShouldBeScored State~Game~Pipes|≡°⊸Pipe~Scored 1)

    # Remove pipes off screen
    ⍜State~Game~Pipes(▽⊸≡(>¯64Pipe~X))

    # Spawn new pipes when there aren't enough
    <4⧻⊸State~Game~Pipes
    ⍥⍜State~Game~Pipes(⊂Pipe~Spawn +240 ×3GapsBetweenPipes)

    # Draw screen
    ⟜(DrawPipes State~Game~Pipes)
    ⟜(DrawBird 1 State~Game~Bird)
    ⟜(DrawScore State~Game~Score)

    # When space is pressed - jump
    I~Key~Pressed‼@\s(°⊸(Bird~YSpeed State~Game~Bird) JumpSpeed)
  )
)

HandleGameOverState ← (
  # Add speed to bird position
  ⍜State~GameOver~Bird Bird!(
    ⍜Y+⟜YSpeed
    # If the bird goes below the screen, clamp position and
    # set speed so that the rotation is straight down
    ⤚>-⊢Center WindowHeight⊸Y
    ⨬⋅∘(°⊸YSpeed 30 ⍜⊙Y⊙◌)
  )

  # Increment vertical bird speed
  ⍜(Bird~YSpeed State~GameOver~Bird|+Gravity)

  # Draw screen
  ⟜(DrawPipes State~GameOver~Pipes)
  ⟜(DrawBird 0 State~GameOver~Bird)
  ⟜(DrawScore State~GameOver~Score)

  ⊸{"Game over" $"Your score: _" State~GameOver~Score ⊙"Press space to restart"}
  I~Draw!⬚Centered Text Black 40_40_20 ⍉⊟÷₂WindowWidth +180×70⇡3

  # Draw white flash with opacity based on the time elapsed since game over
  ↥0+1-I~Time ⊸State~GameOver~DeathTime
  I~Draw~Rect ⊂White⊙(WindowWidth_WindowHeight 0_0)

  # When space is pressed - create a new game state
  ⍥(State~Menu ↥State~GameOver!⊃Score HighScore) I~Key~Pressed @\s
)

State~Menu 0

map⟜≡(I~Texture~Load File $"_.png") {"bird" "pipes"}

⬚∘I~Loop!(
  I~Draw~Background 0.4_0.7_1
  # Note the usage of ⍩ - it allows errors to happen in that branch.
  # Without it, if the pattern matching passes and something
  # goes wrong in the handler - it will try the next state branch,
  # which is not what we want.

  ⍣(⍩HandleMenuState ⍜°State~Menu∘
  | ⍩HandleGameState ⍜°State~Game∘
  | ⍩HandleGameOverState ⍜°State~GameOver∘
  | ⍤$"Invalid state: _":0
  )
)
