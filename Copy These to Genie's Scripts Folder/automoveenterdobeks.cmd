TOP:
pause 0.001
put kiss scorpion
pause
echo *** PAUSING FOR STUN
pause 13
PAUSE:
pause
if ($stunned) then goto PAUSE
STAND:
put stand
pause 0.5
if (!$standing) then goto STAND
pause 0.2
send #parse MOVE SUCCESSFUL
exit