action setvariable aspect.light dolphin when the image of a deer drinking from a flowing stream
action setvariable aspect.light panther when the image of a cluster of twinkling stars
action setvariable aspect.light cat when the image of a grimacing woman in the throes of childbirth
action setvariable aspect.light ram when the image of a flourishing rose garden
action setvariable aspect.light cobra when the image of a shattered egg
action setvariable aspect.light wolf when the image of a charred black stave
action setvariable aspect.light boar when the image of a longbow
action setvariable aspect.light raven when the image of a bowl of striped peppermint
action setvariable aspect.light lion when the image of a pack of well-groomed battle hounds
action setvariable aspect.light wren when the image of a plump opera singer
action setvariable aspect.dark dolphin when the image of a great tidal wave
action setvariable aspect.dark panther when the image of a child shivering fearfully in the throes of a nightmare
action setvariable aspect.dark cat when image of a pair of twin crossed swords with jagged blades
action setvariable aspect.dark ram when the image of a jagged crystalline blade
action setvariable aspect.dark cobra when the image of an erupting volcano
action setvariable aspect.dark wolf when the image of a long flowing skirt
action setvariable aspect.dark boar when the image of a berserking barbarian
action setvariable aspect.dark raven when the image of a shattered caravan wheel
action setvariable aspect.dark lion when the image of a bloodstained stiletto
action setvariable aspect.dark wren when the image of a cracked mirror
action setvariable aspect $1 when (dolphin|panther|cat|ram|cobra|wolf|boar|raven|lion|wren)
action setvariable coffin.ready $1 when bier bearing the image .* (dolphin|panther|cat|ram|cobra|wolf|boar|raven|lion|wren)
action setvariable coffin.ready no when A steel-reinforced ebony coffin hangs in the air 
action setvariable coffin.ready no when  A steel-reinforced ebony coffin lies on the floor near the biers
action (moving) var Moving 1 when Obvious (path|exits)|Roundtime
var Moving 0
if ($roomid != 404) then gosub automove 404
infusion:
pause 0.2
#action (aspect) activate
put look sun
pause 0.5
put look star
pause 0.5
action remove (dolphin|panther|cat|ram|cobra|wolf|boar|raven|lion|wren)
pause 0.5
put look bier
pause 1
if %aspect = %coffin.ready then goto coffinready
pause 0.5
put turn crank
pause 0.5
pause 0.5
move s
move go white tap
gosub aspect.light.look
move se
move go black tap
gosub aspect.dark.look
move sw
move n
put pull lev
pause 0.5
pause 0.5
put look bier
if %aspect = %coffin.ready then goto coffinready
goto infusion

aspect.light.look:
	put look wheel
	pause 1
	if %aspect = %aspect.light then goto return
	gosub pull.rope 
	goto aspect.light.look

aspect.dark.look:
	put look wheel
	pause 1
	if %aspect = %aspect.dark then goto return
	gosub pull.rope
	goto aspect.dark.look

pull.rope:
	put pull rope
	match return grinding
	match return wheel turns
	match return heave the wheel
	match pull.rope You'll have to get a better grip 
	matchwait 

coffinready:
pause 0.1
pause 0.1
put open coffin
pause 0.4
pause 0.3
put go coffin
pause 0.1
pause 0.1
put close coffin
waitforre You suddenly feel the presence of cold stone beneath you
stunwait:
if $stunned then 
	{
	pause 5
	goto stunwait
	}
if $prone then put stand
put #parse MOVE SUCCESSFUL
pause 0.5
exit

return:
return

#### AUTOMOVE
AUTOMOVE:
     delay 0.0001
     action (moving) on
     var Moving 0
     var randomloop 0
     var Destination $0
     var automovefailCounter 0
     if (!$standing) then gosub AUTOMOVE_STAND
     if (!$roomid = 0) then gosub moveRandomDirection
     if ("$roomid" = "%Destination") then return
AUTOMOVE_GO:
     pause 0.0001
     matchre AUTOMOVE_FAILED ^(?:AUTOMAPPER )?MOVE(?:MENT)? FAILED
     matchre AUTOMOVE_RETURN ^YOU HAVE ARRIVED(?:\!)?
     matchre AUTOMOVE_RETURN ^SHOP CLOSED(?:\!)?
     matchre AUTOMOVE_FAIL_BAIL ^DESTINATION NOT FOUND
     put #goto %Destination
     matchwait 4
     if (%Moving = 0) then goto AUTOMOVE_FAILED
     matchre AUTOMOVE_FAILED ^(?:AUTOMAPPER )?MOVE(?:MENT)? FAILED
     matchre AUTOMOVE_RETURN ^YOU HAVE ARRIVED(?:\!)?
     matchre AUTOMOVE_RETURN ^SHOP CLOSED(?:\!)?
     matchre AUTOMOVE_FAIL_BAIL ^DESTINATION NOT FOUND
     matchwait 45
     goto AUTOMOVE_FAILED
AUTOMOVE_STAND:
     pause 0.1
     matchre AUTOMOVE_STAND ^\.\.\.wait|^Sorry\,|^Please wait\.
     matchre AUTOMOVE_STAND ^Roundtime\:?|^\[Roundtime\:?|^\(Roundtime\:?|^\[Roundtime|^Roundtime
     matchre AUTOMOVE_STAND ^The weight of all your possessions prevents you from standing\.
     matchre AUTOMOVE_STAND ^You are still stunned\.
     matchre AUTOMOVE_RETURN ^You stand(?:\s*back)? up\.
     matchre AUTOMOVE_RETURN ^You are already standing\.
     send stand
     matchwait
AUTOMOVE_FAILED:
     pause 0.1
     # put #script abort automapper
     pause 0.2
     math automovefailCounter add 1
     if (%automovefailCounter > 3) then goto AUTOMOVE_FAIL_BAIL
     send #mapper reset
     pause 0.1
     put look
     pause 0.5
     pause 0.2
     if (!$roomid = 0) || (%automovefailCounter > 2) then gosub moveRandomDirection
     goto AUTOMOVE_GO
AUTOMOVE_FAIL_BAIL:
     action (moving) off
     put #echo
     put #echo >Log Crimson *** AUTOMOVE FAILED. ***
     put #echo >Log Destination: %Destination
     put #echo Crimson *** AUTOMOVE FAILED.  ***
     put #echo Crimson Destination: %Destination
     put #echo
     return
AUTOMOVE_RETURN:
     action (moving) off
     pause 0.1
     pause 0.2
     return