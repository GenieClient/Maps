#ggbypas.cmd
# For use with automapper.cmd to deal with
# the shenanigas around the secret passgage
# near Raven's Point/Gear Gate.
# This script was stolen from BlacfireEnthusiast
# and modified, adapted, and commited
# by Hanryu (so blame the mac user)
#debug 5

#### LOAD VARIABLES ####
var status 0
if matchre("$roomobjs", "a gouged stone wall") then var status 1

#### LOAD ACTIONS ####
action var status 1 when ^As you pull down on the (?:torch|stone basin) you hear a click and a gouged stone wall opens up
action var status 0 when ^A gouged stone wall slowly closes

MAINLOOP:
     if (%status = 0) then 
          {
               if matchre("$roomdesc", "^Rising steeply from a rough-hewn opening") then gosub TURN torch on wall
               if matchre("$roomdesc", "^The interior of the small cavern") then gosub TURN basin on wall
          }
gosub MOVE
pause 0.1
goto DONE

DONE:
  put #parse MOVE SUCCESSFUL
  exit

#### GOSUBS ####
#### MOVE ####
MOVEP:
  pause .1
MOVE:
  var direction $0
  match MOVEP ...wait
  match MOVEP Sorry,
  match MOVEP still stunned
  match MOVEP You don't seem to be able to move
  match MOVEP while entangled in a web
  match MOVEP still recovering from your recent attack
  match MOVEP You need to rest a bit before you continue
  match MOVE_STAND You can't do that while
  match MOVE_STAND You must be standing to do that
  match MOVE_RETREAT You realize that would be next to impossible while in combat
  match MOVE_RETREAT You are engaged
  match MOVE_RETREAT You can't do that while engaged
  match RETURN Obvious
  send go wall
  matchwait 5
  var status 0
  goto MAINLOOP

MOVE_RETREAT:
  gosub RETREAT
goto MOVEP

MOVE_STAND:
  if (!$standing) then send stand
  pause 0.1
  if (!$standing) then goto MOVE_STAND
goto MOVEP
####

#### TURN ####
TURNP:
  pause 0.1
  goto TURN_RE
TURN:
  var turntarget $0
TURN_RE:
  match TURNP ...wait
  match TURNP Sorry,
  match TURNP still stunned
  match TURNP You don't seem to be able to move
  match TURN_RE You push
  match RETURN As you pull
  send turn %turntarget
  matchwait 5
  return
####

#### RETREAT ####
RETREATP:
  pause 0.1
RETREAT:
  match RETREATP ...wait
  match RETREATP Sorry,
  match RETREAT You retreat back
  match RETURN You retreat from combat
  match RETURN You are already as far away as you can get!
  send retreat
  matchwait
####

#### RETURN ####
RETURN:
  return
####
