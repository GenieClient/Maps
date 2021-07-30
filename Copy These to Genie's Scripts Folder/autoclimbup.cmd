action send 1 climb up when ^\.\.\.wait|^Sorry
action send 1 climb up when ^You work your way about
action send 1 climb up when ^You slip but catch yourself.
action send 1 climb up when ^You work your way around
action instant goto doneClimbing when ^You climb over the top

send climb up
waitforre ^Obvious

doneClimbing:
put #parse MOVE SUCCESSFUL