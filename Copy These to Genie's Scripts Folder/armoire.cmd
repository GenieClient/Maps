
send open armoire
pause 0.5
send search armoire
pause 0.5
pause 0.5
movearmoire:
matchre movearmoire \.\.\.wait
match retreat You are engaged
match done Obvious
send go armoire
matchwait

RETREAT:
     var LOCATION Retreat
     matchre WAIT ^\.\.\.wait|^Sorry\,
     match movearmoire You are already as far
     match RETREAT You retreat
     match RETREAT You stop advancing
     match RETREAT You sneak back out of combat.
	match RETREAT You can't do that while
     match RETREAT You retreat from combat
     match RETREAT Roundtime
     match RETREAT pole range
     put retreat
     matchwait

done:
pause 0.5
pause 0.5
put #parse MOVE SUCCESSFUL