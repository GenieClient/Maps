SteelDoor:
	action var steeldoor 0 when ^Chedik Bridge, Engineer's Tower
	action var steeldoor 1 when ^You can't do that.

	send go steel door
	waitforre You can't|Engineer's Tower
	if "%steeldoor" = "1" then send go other steel door
	pause
	send #parse MOVE SUCCESSFUL