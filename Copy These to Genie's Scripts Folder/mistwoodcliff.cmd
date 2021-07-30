#debug 10
#---------------------------------------
# INCLUDES
#---------------------------------------
goto SubSkip
#---------------------------------------
# Local Subroutines
#---------------------------------------

SubSkip:

#---------------------------------------
# CONSTANT VARIABLES
#---------------------------------------

#---------------------------------------
# VARIABLES
#---------------------------------------
	var NextRoom ^(?:Obvious (?:paths|exits)|It's pitch dark|You can't go there|You can't sneak in that direction)

#---------------------------------------
# ACTIONS
#---------------------------------------
	action var Dir $1 when ^Peering closely at a faint path, you realize you would need to head (\w+)\.
#---------------------------------------
# SCRIPT START
#---------------------------------------
	put peer path
	waitforre Peering closely at
	put down
	waitforre %NextRoom
	put %Dir
	waitforre %NextRoom
	put nw
	waitforre %NextRoom
	put #parse MOVE SUCCESSFUL
	