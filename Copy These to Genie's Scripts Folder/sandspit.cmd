Barrel:
	action var barrel 0 when ^You duck quietly into an old barrel.
	action var barrel 1 when ^You can't do that.

	send go barrel
	waitforre You can't|You duck
	if "%barrel" = "1" then send go other barrel
	pause
	send #parse MOVE SUCCESSFUL