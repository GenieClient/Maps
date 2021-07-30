# For use with automapper.cmd to move around
# Hollow Eve map in the room with a vine
# that you tap to return down to another part
# of the area. There is no roundtime but a
# discernable wait before you make it to the next room.
# This script is inspired by mistwoodcliff.cmd.

#---------------------------------------
# VARIABLES
#---------------------------------------
var NextRoom ^(Just as you were about to hit, the vine snakes around your waist and sets you gently on the ground)

#---------------------------------------
# SCRIPT START
#---------------------------------------
put tap vine
waitforre %NextRoom
pause 0.5
put #parse MOVE SUCCESSFUL
