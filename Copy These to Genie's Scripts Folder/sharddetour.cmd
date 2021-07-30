#### DETOUR SCRIPT FOR NAVIGATING SHARD WHEN YOU CAN'T GO THROUGH THE GATE AT NIGHT (Non-Citizens)

locationcheck:
put #script pause all except %scriptname
if $zoneid = 67 then goto insideshard
else goto outsideshard

insideshard:
if $roomid = 1 then var dest ngate
if $roomid = 43 then var dest wgate
if $roomid = 199 then var dest sgate

if "%dest" = "ngate" then gosub automove e gate
if "%dest" = "wgate" then gosub automove e gate|w gate
if "%dest" = "sgate" then gosub automove e gate|s gate
put #script resume all
pause 0.2
     put #parse YOU HAVE ARRIVED!
     put #class arrive off
exit

outsideshard:
if $zoneid = 69 then gosub automove north
if $zoneid = 68 then gosub automove e gate
if $zoneid = 67 then gosub automove n gate
if $zoneid = 66 then gosub automove e gate
put #script resume all
pause 0.2
     put #parse YOU HAVE ARRIVED!
     put #class arrive off
exit

automove:
var movement $0
eval mcount count("%movement", "|")
var ccount 0
#if contains("Cleric|Warrior Mage|Moon Mage|Bard|Empath|Paladin", "$Guild") then put #var powerwalk 1

automove_1:
pause 1
if matchre("%movement(%ccount)", "travel") then goto travelmove
match automove_1 YOU HAVE FAILED
match automove_1 You can't go there
match automove_1 MOVE FAILED
match autoreturn YOU HAVE ARRIVED
else put #goto %movement(%ccount)
matchwait

travelmove:
put %movement(%ccount)
waitfor REACHED YOUR DESTINATION
goto autoreturn

autoreturn:
if %ccount = %mcount then return
math ccount add 1
goto automove_1