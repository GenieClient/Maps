#### DETOUR SCRIPT FOR NAVIGATING SHARD WHEN YOU CAN'T GO THROUGH THE GATE AT NIGHT (Non-Citizens)
### Added Athletics Check to climb over West Gate wall from Map 69 

locationcheck:

debug 5

put #script pause all except %scriptname

if ($zoneid != 67) then goto outsideshard
####
insideshard:
  if ($Athletics.Ranks > 250) then goto $roomidClimbOUT
  if ($roomid = 1) then gosub automove e gate
  if ($roomid = 43) then gosub automove e gate|w gate
  if ($roomid = 199) then gosub automove e gate|s gate
  goto done
199ClimbOUT:
  move climb stairway
  move east
  move climb embrasure
  goto done
1ClimbOUT:
  move climb ladder
  move west
  move climb embrasure
  goto done
43ClimbOUT:
  move climb ladder
  move south
  move climb embrasure
  goto done
####

####
outsideshard:
  if ($Athletics.Ranks > 250) then goto $zoneidClimbIN
  if ($zoneid = 69) then gosub automove north shard
  if ($zoneid = 68) then gosub automove e gate|e gate
  if ($zoneid = 66) then gosub automove e gate
  goto done
69ClimbIN:
  move climb wall
  move north
  move climb ladder
  goto done
66ClimbIN:
  move climb wall
  move east
  move climb ladder
  goto done
68ClimbIN:
  move climb wall
  move west
  move climb stairway
  goto done
####

####
end:
done:
  put #script resume all
  pause 0.2
  put #parse YOU HAVE ARRIVED!
  put #class arrive off
  exit

automove:
  var movement $0
  eval mcount count("%movement", "|")
  var c 0

automove_1:
  match automove_1 YOU HAVE FAILED
  match automove_1 You can't go there
  match automove_1 MOVE FAILED
  match autoreturn YOU HAVE ARRIVED
  put #goto %movement(%c)
  matchwait

autoreturn:
  if (%c = %mcount) then return
  math c add 1
  goto automove_1
