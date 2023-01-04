#speedtest.cmd
# .speedtest LogID
#   start it on a map with at least 200 rooms
#   enter the (LogID) that will be written out
#
# written by Hanryu
# Please report any bugs to Hanryu#0052 (Discord) or sauva@play.net
# This script may be reused in whole or in part as long as credit is given
# This script is designed to use Oulander, http://outlanderapp.com
# Thanks to @Dantia for helping me Genie-fy this
# 2022-10-11
#   initial release
# 2022-10-24
#   added a commented section to jump between 2 rooms
#debug 5
#debug 10

## use me for if you need an input
if matchre("%0", "help|HELP|Help|^$") then {
  echo ****************************************************
  echo **  .speedtest LogID                              **
  echo **    start it on a map with at least 200 rooms   **
  echo **    enter the (LogID) that will be written out  **
  echo ****************************************************
  goto end
  }

# put #class -analyze -app -combat -family -focus -guild -harvesting -health -highlights -janitor -mana -myitems -names -ranger -subs -trail -traps -treasure
var c 10
top:
if (%c < 0) then goto done

# if ($roomid = 234) then var destination 244
# else var destination 234
 
 if ($roomid < 200) then {
  evalmath destination ($roomid + 200)
  }
  else {
  evalmath destination ($roomid - 200)
  if (%destination < 1) then var destination 2
  }
pause 0.5
if def(version) then var time @unixtime@
else var time $unixtime
put #goto %destination
waitfor YOU HAVE ARRIVED
if def(version) then evalmath time @unixtime@ - %time
else evalmath time $unixtime - %time
put #echo >talk Test %c took %time
put #log >automappertest.csv %time,%0
math c subtract 1
goto top

end:
done:
  put #parse **  SPEEDTEST DONE  **
  exit