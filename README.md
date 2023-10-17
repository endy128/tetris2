# Learning GDScript in Godot by making a clone of Tetris

I chose to represent the board in a 2d array and then render the game by the `_draw` function.

## TODO:
- [x] Fix shape rotating over other pieces - done
- [ ] ~~Shapes to 'bump' left or right if at the edge of play area and rotation will push them out of bounds~~ - not done, tetris doesn't do this
- [x] Add some rows above the viewable board for  shapes to spawn into, donn't display - done
- [x] Add the `coming next` shape box, score and button areas - done
- [x] Score board
- [ ] Start, play and end states
- [x] Touch buttons
- [ ] Add a `cheat code` for special state
- [ ] Add colours to the board
- [ ] Holding L/R buttons continued to move the pieces

## Notes:

`_input` only tells you if when a button is pressed. Use this to set a `var` to show moving, in `_process` check for `var` and move accordingly. Need to watch out for speed.
