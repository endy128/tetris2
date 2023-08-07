# Learning GDScript in Godot by making a clone of Tetris

I chose to represent the board in a 2d array and then render the game by the `_draw` function.

## TODO:
- Fix shape rotating over other pieces - done
- Shapes to 'bump' left or right if at the edge of play area and rotation will push them out of bounds - not done, tetris doesn't do this
- Add some rows above the viewable board for  shapes to spawn into, donn't display - done
- Add the `coming next` shape box, score and button areas - done
- Score board
- Start, play and end states
- Touch buttons
- Add a `cheat code` for special state
