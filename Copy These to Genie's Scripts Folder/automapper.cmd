# automapper.cmd version 8.2022-10-10
# last changed: October 10, 2022
# debug 5 is for outlander; genie debuglevel 10
#debuglevel 10
#debug 5

# put #class arrive off
# put #class combat off
# put #class joust off
# put #class racial off
# put #class rp off

#USER VARS:
# Time to pause before sending a "put x" command
var command_pause 0.02
# 1: wait for correct confirmation of sent commands; 0: don't wait
var waitfor_action 0
# 1: collect rocks on the ice road when lacking skates; 0; just wait 15 seconds with no RT instead
var ice_collect 0
# Decrease at your own risk, increase if you get infinte loop errors
#default is 0.1 for Outlander, 0.01 for Genie
if def(version) then var var infiniteLoopProtection 0.01
else var infiniteLoopProtection 0.1

#2022-10-10
# Hanryu - integrating Jon's WAVE
# it's a pretty big refactor that is all @Jon#0664 fault
# the wave loop is a lot more readable and more compact
# also a fix for searches that create RT
# fixed "matchre (" and "replacere ("
# fixed trailing white space
# unified indent to "  " (two spaces)
# added paren's to lots of if statements
# infiniteLoopProtection variable based on FE
# fixed a run condition between being inviso at the shard gate (STOP.INVIS) and (MOVE.INVIS)
# replaced eval element() since that function is not Outlander supported

#2022-09-22
# Hanryu - powerwalk smoother/ranger blend
# - if you're powerwalking, set typeahead to 0, once you're done powerwalking, set it back to $automapper.typeahead global
# - added release blend for rangers
# - added ...wait checkes to a few matches that were missing them
# - fixed trigger for dropping your feature hiding cloak
# - moved a bunch of the pauses to >pause %command_pause

# June 25, 2022 - TenderVittle's Touches:
# Added variable action gosub to handle doing commands you really want to make sure are done right. This is a toggle.
# Added a toggle for collecting rocks on the ice road vs. just waiting.
# Redid skate/footwear logic from scratch. Tested a lot. Does not take skates off if you stop at room 45 (going north) or only move one room (so don't do that.)
# Removed broom/carpet messaging from retry action, and removed double from fail action. Now its only a fail action. Not sure if that breaks things for broom/carpet users, sorry.
# Removed unused MOVE.POWER routine.
# Removed unused MOVE.PAUSE routine and action.
# Adjusted tab spacing throughout the whole script.
# Set all labels to caps for half-blind people like me to tell them apart. Also added spacing between labels.
# Compressed single-line code blocks { } where it seemed safe to do so.
# Made MOVE.RETRY.GO's stunned check return to MOVE.RETRY.GO instead of MOVE.RETRY
# Moved some labels around for flow.
# Added Steps of Vuan to Moon Mage spell release for invisibility movement
# Redid feature-hiding cloak logic for Shard gates. Now supports multiple nouns and will attempt to re-hide your face and such after passing through/before detouring.
# Added echo to short pause movements like the root in the southwest of Leth Deriel's map, to indicate the script/Genie is not freezing there.
# Re-wrote and absorbed many helper scripts. Not all thoroughly tested, however. "sharddetour", "peerchurch", "infusionentry" and "crossingtrainerfix" are still required in your scripts folder.
# Added logic for Misenseor Abbey's secret hatchway. Needs more testing, and the map updated to replace "go secret hatchway" with "script abbeyhatch".
#
# - Updated Stow Foot logic trigger - Removed Old Obsolete Regex Trigger since stow foot logic now in game
# - Added missing match for MOVE_RETRY (for climbing in Abandoned Mine)
# - Updated stow foot logic to handle prayer mats
# - Added move_PAUSE routine for better handling of walking through areas with long RT causing automapper to trip up on itself
# - Added support for getting ice skates from portal bag as a secondary check
# Shroom - Updated matches for closed shops in Shard
# 1 - to work with shops in Shard that let you in at night when you ARE a citizen (was exiting out before instead of continuing)
# 2 - to properly exit out when you get the message and are NOT a citizen
# Added standing checks before quitting automapper
# Increased wait time on Ice as was going too fast in some cases
# Added Special Support for the Stone Wall in Cragstone Vale
# Fixed a bug in the Retry Logic

# July 17 2022 - Shroom
# Fixed bug in Move_Stow
# Added standing checks before moving wall in gear gate bypass

# VTCifer -  Changed default debug level at the top to be more useful
# Fixed whitespace
# Added match for powerwalk
# Added missing script label
# Fixed wait time for ice
#
# 2019-09-25 - Shroom - Robustified Shard gate logic - should take detour if rejected by guard (requires .sharddetour script)
# Cleaned up the ice skate logic
# 2019-08-6 Shroom - Added several missing matches
# Dasffion - Added in a waiteval for depth on climbing to allow the script to catch up on type aheads.

# 2019-07-06 - VTCifer - Reverted most "send" commands to "put", to prevent out of order commands
# 2019-06-19 - VTCifer - Updated foot slot routine from Dasffion
# Changed default typeahead to 1 (standard for accounts) and cleaned up documentation of setting

# 2019-4-20 - Shroom - Cleaned up retry logic - added micro pauses to reduce errors
# Added trigger logic for being invisible and unable to enter certain areas - should drop invis and retry

# 2018-7-21 - Shroom - Fixed stowfootitem routine, fixed powerwalking routine
# Cleaned up some matchres, spacing, optimized some code with help of Pelic
# 2018-7-28 - Added missing match for closed shop. Cleaned up some RegEx thanks to Ataeleos

# 2017-11-13 - Shroom - Synced changes and updates from TF and Prime versions -  To make compatible across both instances
# Added ICE SKATE support for Ice Road - Checks for ice skates and wears them during ice road, also checks your footwear and puts it back on after
# Added support for Stowing foot item when you have an item stuck at your feet
# Added missing web catch - Noobs were getting stuck on the web to Leth
# Modified handling of dropping invisibility depending on guild
# Added catches for getting thrown in Jail to properly abort automapper

# 2016-12-01 - Shroom - Added updates and optimizations
# Added more catches for stunned or tripping over roots
# Added additional catches for closed shops
# Added support for knocking on a town gate (Shard) during Night to get in. (Need to add checks for Non-Citizens, may cause problems with non-citizens)
# Added catches for trying to go through gate while invisible or with a cloak concealing face.
# Added support for climbing with ropes
# Added matches for Theren tunnels so script does not get stuck in infinite loop trying to stand
# Added catch for Shard citizens now being able to enter closed shops at night
# Added stamina support for Aesry stairs - Will cast fatigue recovery buffs if possible and pause to wait for stamina

# 2013-07-24 - Funk -  - Merged back in previous changes + updates
# Waiting for the galley to show up - var move_BOAT ^The galley has just left|^You look around in vain for the galley
# added "^You'll need to stand up first" to move_STAND var
# added "^You almost make it to the top" to climb_FAIL
# added "^You find yourself stuck in the mud" to move_MUCK var
# added support for stowing to climb - var move_STOW ^You'll need to free up your hands first|^Not while carrying something in your hands

# Added handler for attempting to enter closed shops from Shroomism
# Added web retry support from Dasffion
# Added caravan support from Jailwatch
# Added swimming retry from Jailwatch
# Added search and objsearch handling from BakedMage
# Added enhanced climbing and muck support from BakedMage
# VTCifer - Added "room" type movement - used for loong command strings that need to be done in one room
# VTCifer - Added "ice" type movement  - will collect rocks when needs to slow down
# VTCifer - Added more matches for muck (black apes)
# Fixed timings
# Added "treasure map" mode from Isharon
# Replaced "tattered map" with "map" (because the adjective varies)
# VTCifer - Added additional catches for roots
# VTCifer - Added additional catch for Reaver mine -> Non-standard stand up message.  Fixed minor issue with RT and roots.
#
#
# Related macros
# ---------------
# Add the following macro for toggling powerwalking:
# #macro {P, Control} {#if {$powerwalk = 1}{#tvar powerwalk 0;#echo *** Powerwalking off}{#tvar powerwalk 1;#echo *** Powerwalking on}}
#
# Add the following macro for toggling Caravans:
# #macro {C, Control} {#if {$caravan = 1}{#tvar caravan 0;#echo *** Caravan Following off}{#tvar caravan 1;#echo *** Caravan Following on}}
#
# Related aliases
# ---------------
# Add the following aliases for toggling dragging:
# #alias {drag0} {#tvar drag 0;#unvar drag.target}
# #alias {drag1} {#tvar drag 1;#tvar drag.target $0}
# Add the following aliases for toggling treasure map mode:
# #alias {map0} {#tvar mapwalk 0}
# #alias {map1} {#tvar mapwalk 1}
#

ABSOLUTE.TOP:
# Type ahead declaration
# ---------------
# The following will use a global to set it by character.  This helps when you have both premium and standard accounts.
# Standard Account = 1, Premium Account = 2, LTB Premium = 3
  if !def(automapper.typeahead) then var typeahead.max 1
  else var typeahead.max $automapper.typeahead
  if !def(caravan) then put #tvar caravan 0
  if !def(mapwalk) then put #tvar mapwalk 0
  if !def(powerwalk) then put #tvar powerwalk 0
  if !def(searchwalk) then put #tvar searchwalk 0
  if !def(drag) then put #tvar drag 0
     put #var drag 0
# ---------------
  action var current_path %0 when ^You go
  if ($mapwalk) then
    {
    if !matchre("$righthand|$lefthand", "\bmap\b") then gosub GET.MAP
    }
  var checked 0
  var slow_on_ice 0
  var wearing_skates 0
  var skate.container 0
  var footwear 0
  var action_retry ^0$
  var cloak_off 0
  var cloaknouns cloak|shroud|scarf|0
  var closed 0
  var movewait 0
  var startingStam $stamina
  var failcounter 0
  var depth 0
  var movewait 0
  var move_TORCH You push up on the (stone basin|torch)\, and the stone wall closes\.
  var move_OK ^Obvious (paths|exits)|^It's pitch dark|The shop appears to be closed\, but you catch the attention of a night attendant inside\,
  var move_FAIL ^You can't swim in that direction|You can't go there|^A powerful blast of wind blows you to the|^What were you referring to|^I could not find what you were referring to\.|^You can't sneak in that direction|^You can't ride your.+(broom|carpet) in that direction|^You can't ride that way\.$
  var move_RETRY_GO ^You can't climb that\.$
  var move_RETRY ^\.\.\.wait|^Sorry, you may only|^Sorry, system is slow|^The weight of all|lose your balance during the effort|^You are still stunned|^You're still recovering from your recent|^The mud gives way beneath your feet as you attempt to climb higher, sending you sliding back down the slope instead\!|You're not sure you can
  var move_RETREAT ^You are engaged to|^You try to move, but you're engaged|^While in combat|^You can't do that while engaged|^You can't do that\!  You\'re in combat\!
  var move_WEB ^You can't do that while entangled in a web|As you start to move, you find yourself snared
  var move_WAIT ^You continue climbing|^You begin climbing|^You really should concentrate on your journey|^You step onto a massive stairway
  var move_END_DELAY ^You reach|you reach\.\.\.$
  var move_STAND ^You must be standing to do that|^You can't do that while (lying down|kneeling|sitting)|You try to quickly step from root to root, but slip and drop to your knees|you trip over an exposed root|^Stand up first\.|^You must stand first\.|^You'll need to stand up|a particularly sturdy one finally brings you to your knees\.$|You try to roll through the fall but end up on your back\.$|^Perhaps you might accomplish that if you were standing\.$
  var move_NO_SNEAK ^You can't do that here|^In which direction are you trying to sneak|^Sneaking is an inherently stealthy|^You can't sneak that way|^You can't sneak in that direction
  var move_GO ^Please rephrase that command
  var move_MUCK ^You fall into the .+ with a loud \*SPLUT\*|^You slip in .+ and fall flat on your back\!|^The .+ holds you tightly, preventing you from making much headway\.|^You make no progress in the mud|^You struggle forward, managing a few steps before ultimately falling short of your goal\.|^You find yourself stuck in the mud
  var climb_FAIL ^Trying to judge the climb, you peer over the edge\.  A wave of dizziness hits you, and you back away from .+\.|^You start down .+, but you find it hard going\.  Rather than risking a fall, you make your way back up\.|^You attempt to climb down .+, but you can't seem to find purchase\.|^You pick your way up .+, but reach a point where your footing is questionable\.  Reluctantly, you climb back down\.|^You make your way up .+\.  Partway up, you make the mistake of looking down\.  Struck by vertigo, you cling to .+ for a few moments, then slowly climb back down\.|^You approach .+, but the steepness is intimidating\.|^The ground approaches you at an alarming rate|^You start up .+, but slip after a few feet and fall to the ground\!  You are unharmed but feel foolish\.|^You almost make it to the top|^You start the climb and slip|^You start to climb .+, but then stop to reconsider\.
  var move_CLOSED ^The door is locked up tightly for the night|^You stop as you realize that the|^(?:\w+ )+I'm sorry\, but you need to be a citizen|^BONK\! You smash your nose|^Bonk\! You smash your nose|^(?:\w+ )+I'm sorry\, I can only allow citizens in at night|^(?:\w+ )+shop is closed for the night|^A guard appears and says\, \"I'm sorry\,|The shop appears to be closed\, but you catch the attention of a night attendant inside\, and he says\, \"I'm sorry\, I can only allow citizens in at night\.\""?
  var swim_FAIL ^You struggle (?!to maintain)|^You work(?! your way (?:up|down) the cliff)|^You slap|^You flounder
  var move_DRAWBRIDGE ^The guard yells, "Lower the bridge|^The guard says, "You'll have to wait|^A guard yells, "Hey|^The guard yells, "Hey
  var move_ROPE.BRIDGE is already on the rope\.|You'll have to wait
  var move_STOW ^You need to empty your hands|^You should empty your hands first\!|^You can't possibly manage to cross|^You'll need to free up your hands|^Not while carrying something in your hands|^You must first free up your hands\.|^The going gets quite difficult and highlights the need to free up your hands|^You must have your hands free
  var move_FATIGUE ^You're too tired to try climbing|^You need to rest
  var move_BOAT ^The galley has just left|^You look around in vain for the galley
  var move_INVIS ^The .* can\'t see you\!|^But no one can see you\!|^How can you .* can\'t even see you\?
  var climb_mount_FAIL climb what?
ACTIONS:
  action (mapper) if (%movewait = 0) then shift;if (%movewait = 0) then math depth subtract 1;if (len("%2") > 0) then echo Next move: %2 when %move_OK
  action (mapper) goto MOVE.TORCH when %move_TORCH
  action (mapper) goto MOVE.FAILED when %move_FAIL
  action (mapper) goto MOVE.RETRY.GO when %move_RETRY_GO
  action (mapper) goto MOVE.RETRY when %move_RETRY|%move_WEB
  action (mapper) goto MOVE.STAND when %move_STAND
  action (mapper) var movewait 1;goto MOVE.WAIT when %move_WAIT
  action (mapper) goto MOVE.RETREAT when %move_RETREAT
  action (mapper) var movewait 0 when %move_END_DELAY
  action (mapper) var closed 1;goto MOVE.CLOSED when %move_CLOSED
  action (mapper) goto MOVE.NOSNEAK when %move_NO_SNEAK
  action (mapper) goto MOVE.GO when %move_GO
  action (mapper) goto MOVE.INVIS when %move_INVIS
  action (mapper) goto MOVE.DIVE when %move_DIVE
  action (mapper) goto MOVE.MUCK when %move_MUCK
  action (mapper) goto MOVE.STOW when %move_STOW
  action (mapper) goto MOVE.BOAT when %move_BOAT
  action (mapper) echo Will re-attempt climb in 5 seconds...;send 5 $lastcommand when ^All this climbing back and forth is getting a bit tiresome\.  You need to rest a bit before you continue\.$
  action (mapper) goto MOVE.RETRY when %swim_FAIL
  action (mapper) goto MOVE.DRAWBRIDGE when %move_DRAWBRIDGE
  action (mapper) goto MOVE.KNOCK when The gate is closed\.  Try KNOCKing instead
  action (mapper) goto MOVE.ROPE.BRIDGE when %move_ROPE.BRIDGE
  action (mapper) goto MOVE.FATIGUE when %move_FATIGUE
  action (mapper) goto MOVE.CLIMB.MOUNT.FAIL when %climb_mount_FAIL
  action (mapper) goto MOVE.KNEEL when maybe if you knelt down first\?
  action (mapper) goto MOVE.LIE when ^The passage is too small to walk that way\.  You'll have to get down and crawl\.|There's just barely enough room here to squeeze through, and no more.
  action (mapper) var footitem $1;goto STOW.FOOT.ITEM when ^You notice (?:an |a )?(.+) at your feet, and do not wish to leave it behind\.
  action (mapper) goto CLOAK.LOGIC when ^You turn away, disappointed\.
  action (skates) var wearing_skates 1 when ^You slide your ice skates on your feet and tightly tie the laces\.|^Your ice skates help you traverse the frozen terrain\.|^Your movement is hindered .* by your ice skates\.|^You tap some.*\bskates\b.*that you are wearing
  action (skates) var wearing_skates 0 when ^You untie your skates and slip them off of your feet\.
  action var slow_on_ice 1;echo Ice detected! when ^You had better slow down\! The ice is|^At the speed you are traveling
  action goto JAILED when a sound not unlike that of a tomb|binds you in chains|firmly off to jail|drag you off to jail|brings you to the jail|the last thing you see before you black out|your possessions have been stripped|You are a wanted criminal, $charactername
  action goto JAILED when your belongings have been stripped|in a jail cell wearing a set of heavy manacles|strip you of all your possessions|binds your hands behind your back|Your silence shall be taken as an indication of your guilt|The eyes of the court are upon you|Your silence can only be taken as evidence of your guilt
  action goto DEAD.DONE when ^You are a ghost\!

MAIN.LOOP.CLEAR:
  gosub clear

#### JON's MAIN LOOP ####
MAIN.LOOP:
  delay %infiniteLoopProtection
  if_1 goto WAVE_DO
  goto DONE

WAVE_DO:
  evalmath MDepth (%depth + 1)
  if ((%typeahead.max >= %depth) && ("%%MDepth" != "")) then gosub MOVE %%MDepth
  if ((%typeahead.max <= %depth) || ("%%MDepth" = "")) then goto MAIN.LOOP
  else goto WAVE_DO

DONE:
  if (!$standing) then gosub STAND

DEAD.DONE:
  put #parse YOU HAVE ARRIVED!
  put #class arrive off
  exit

MOVE:
  math depth add 1
  var movement $0
  var type real
  if ($drag) then
    {
    var type drag
    if matchre("%movement", "(swim|climb|web|muck|rt|wait|stairs|slow|go|script|room) ([\S ]+)") then
      {
      var movement drag $drag.target $2
      }
    else
      {
      var movement drag $drag.target %movement
      }
    if matchre("%movement", "^(swim|climb|web|muck|rt|wait|slow|drag|script|room|dive) ") then
      {
      var type $1
      eval movement replacere("%movement", "^(swim|web|muck|rt|wait|slow|script|room|dive) ", "")
      }
    }
  else
    {
    if ($hidden) then
      {
      var type sneak
      if !matchre("%movement", "climb|go gate") then
        {
        if matchre("%movement", "go ([\S ]+)") then var movement sneak $1
        else var movement sneak %movement
        }
      }
    else
      {
      if ("%type" = "real") then
        {
        if matchre("%movement", "^(search|swim|climb|web|muck|rt|wait|slow|drag|script|room|ice|dive) ") then
          {
          var type $1
          eval movement replacere("%movement", "^(search|swim|web|muck|rt|wait|slow|script|room|ice|dive) ", "")
          }
        if matchre("%movement", "^(objsearch) (\S+) (.+)") then
          {
          var type objsearch
          var searchObj $2
          var movement $3
          }
        }
      }
    }
  eval type toupper(%type)
  goto MOVE.%type

MOVE.REAL:
  if (%wearing_skates) then gosub REMOVE.SKATES
  if (("$zoneid" = "62") && ("$game" = "DRF")) then
    {
    if (("$roomid" = "41") && ("%movement" = "southwest")) then
      {
      pause %command_pause
      move southwest
      move south
      math depth subtract 2
      goto RETURN
      }
    }
DO.MOVE:
  put %movement
  goto RETURN

MOVE.ROOM:
  if (%depth > 1) then waiteval (1 = %depth)
  put %movement
  nextroom
  goto MOVE.DONE

MOVE.STOW:
  if !matchre("Empty", "$lefthand") then gosub STOW.LEFT
  if !matchre("Empty", "$righthand") then goto STOW.RIGHT
  if matchre("$righthand", "khuj|staff|atapwi") then put wear $righthandnoun
  pause %command_pause
  put %movement
  pause %command_pause
  goto MOVE.DONE

MOVE.BOAT:
  matchre MOVE.BOAT.ARRIVED ^The galley (\w*) glides into the dock
  matchwait 60
  put look
  goto MOVE.BOAT

MOVE.BOAT.ARRIVED:
  put %movement
  pause %command_pause
  goto MOVE.DONE

MOVE.ICE:
  action (skates) on
  if (%depth > 1) then waiteval (1 = %depth)
  if (!%checked) then gosub FIND.SKATES
  if (%slow_on_ice) then gosub ICE.COLLECT
  put %movement
  nextroom
  goto MOVE.DONE

SKATE.NO:
  var slow_on_ice 1
  var wearing_skates 0
  put #echo yellow *** Could not find ice skates! ***
  if (%ice_collect) then echo *** Collecting rocks in every room like the other peasants ***
SKATE.YES:
  return

ICE.COLLECT:
  if (!%ice_collect) then goto ICE.PAUSE
  var action collect rocks
  var success ^You manage to collect a pile
  gosub ACTION
  var action kick rocks
  var success ^Now what did the|^You take a step back and run up to the pile|^I could not find
  gosub ACTION
  var slow_on_ice 0
  pause %command_pause
  return

ICE.PAUSE:
  action (mapper) off
  pause %command_pause
  echo *** Pausing 15 seconds to regain footing on slippery ice. ***
  pause 15
  var slow_on_ice 0
  pause %command_pause
  action (mapper) on
  return

MOVE.KNOCK:
  if ($roundtime > 0) then pause %command_pause
  if (%depth > 1) then waiteval (1 = %depth)
  var movement knock gate
  matchre MOVE.KNOCK ^\.\.\.wait|^Sorry,|^You are still stun|^You can't do that while entangled
  matchre SHARD.FAILED Sorry\, you\'re not a citizen
  matchre MOVE.DONE %move_OK|All right, welcome back|opens the door just enough to let you slip through|wanted criminal
  matchre CLOAK.LOGIC ^You turn away, disappointed\.
# trigger will handle dropping inviso and send `put %movement`
#  matchre STOP.INVIS ^The gate guard can't see you
  put %movement
  matchwait 10

SHARD.FAILED:
  if ((%cloak_off) && matchre("$lefthand|$righthand", "%cloaknouns")) then gosub WEAR.CLOAK
  if ((!%cloak_off) && ("%cloak_worn" = "1")) then gosub RAISE.CLOAK
  if !matchre("$zoneid", "(66|67|68|69)") then goto MOVE.FAILED
  matchre MOVE.DONE YOU HAVE ARRIVED\!
  put .sharddetour
  matchwait 45
  goto MOVE.DONE

CLOAK.LOGIC:
  gosub FIND.CLOAK
  goto MOVE.KNOCK

MOVE.DRAG:
MOVE.SNEAK:
MOVE.SWIM:
MOVE.RT:
####added this to stop trainer
  pause %command_pause
  if (%depth > 1) then waiteval (1 = %depth)
  eval movement replacere("%movement", "script crossingtrainerfix ", "")
  put %movement
  pause %command_pause
  goto MOVE.DONE

MOVE.TORCH:
  action (mapper) off
  pause %command_pause
  echo *** RESETTING STONE WALL
  pause %command_pause
  if ($roomid = 264) then send turn torch on wall
  if ($roomid = 263) then send turn basin on wall
  action (mapper) on
  pause %command_pause
  put go wall
  goto MOVE.DONE

MOVE.WEB:
  if ($webbed) then waiteval (!$webbed)
  pause %command_pause
  put %movement
  pause %command_pause
  goto MOVE.DONE

MOVE.MUCK:
  action (mapper) off
  pause %command_pause
  if (!$standing) then put stand
  matchre MOVE.MUCK ^\.\.\.wait|^Sorry,|^You are still stun|^You can't do that while entangled|^You struggle to dig|^Maybe you can reach better that way, but you'll need to stand up for that to really do you any good\.
  matchre RETURN.CLEAR ^You manage to dig|^You will have to kneel closer|^You stand back up.|^You fruitlessly dig
  put dig
  matchwait

MOVE.SLOW:
  put #echo #F8D79A Slow and steady here to avoid mishaps...
  pause 3
  goto MOVE.REAL

MOVE.CLIMB:
  matchre MOVE.DONE %move_OK
  matchre MOVE.CLIMB.MOUNT.FAIL climb what\?
  matchre MOVE.CLIMB.WITH.ROPE %climb_FAIL
  if ($broom_carpet = 1) then eval movement replacere("%movement", "climb ", "go ")
  put %movement
  matchwait

MOVE.CLIMB.MOUNT.FAIL:
  matchre move.done %move_OK
  if ($broom_carpet = 1) then eval movement replacere("%movement", "climb ", "go ")
  put %movement
  matchwait

MOVE.CLIMB.WITH.ROPE:
  action (mapper) off
  if !matchre("$righthand|$lefthand", "braided heavy rope") then
    {
    pause %command_pause
    put get my braided rope
    pause %command_pause
    }
  if !matchre("$righthand|$lefthand", "heavy rope") then
    {
    pause %command_pause
    put get my heavy rope
    pause %command_pause
    }
  action (mapper) on
  if (("$guild" = "Thief") && ($concentration > 50)) then
    {
    pause %command_pause
    send khri flight focus
    }
    pause %command_pause
  if matchre("$righthand|$lefthand", "heavy rope") then goto MOVE.CLIMB.WITH.APP.AND.ROPE
  pause %command_pause
  matchre STOW.ROPE %move_OK
  matchre MOVE.CLIMB.WITH.APP.AND.ROPE %climb_FAIL
  put %movement with my rope
  matchwait

MOVE.CLIMB.WITH.APP.AND.ROPE:
  eval climbobject replacere("%movement", "climb ", "")
  put appraise %climbobject quick
  waitforre ^Roundtime:|^You cannot appraise that when you are in combat
  if (("$guild" = "Thief") && ($concentration > 50)) then
    {
    pause %command_pause
    send khri flight focus
    pause %command_pause
    }
  matchre STOW.ROPE %move_OK
  matchre MOVE.CLIMB.WITH.APP.AND.ROPE %climb_FAIL
  put %movement with my rope
  matchwait

STOW.ROPE:
  if matchre("$righthandnoun|$lefthandnoun", "rope") then
    {
    pause %command_pause
    send stow my rope
    pause %command_pause
    }
  goto MOVE.DONE

MOVE.SEARCH:
  if (%depth > 1) then waiteval (1 = %depth)
  put search
  waitfor You
  pause $roundtime
  put %movement
  pause %command_pause
  goto MOVE.DONE

MOVE.OBJSEARCH:
  put search %searchObj
  pause %command_pause
  if ($broom_carpet = 1) then eval movement replacere("%movement", "climb ", "go ")
  put %movement
  pause %command_pause
  goto MOVE.DONE

MOVE.SCRIPT:
  var subscript 1
  if (%depth > 1) then waiteval (1 = %depth)
  action (mapper) off
  if ("%movement" = "abbeyhatch") then goto ABBEY.HATCH
  if ("%movement" = "ggbypass") then goto GEAR.GATE.BYPASS
  if ("%movement" = "autoclimbup") then goto AUTOCLIMB.UP
  if ("%movement" = "autoclimbdown") then goto AUTOCLIMB.DOWN
  if ("%movement" = "armoire") then goto ARMOIRE
  if ("%movement" = "mistwoodcliff") then goto MISTWOOD.CLIFF
  if ("%movement" = "sandspit") then goto SANDSPIT.TAVERN
  if ("%movement" = "hibintelligence") then goto HIB.INTELLIGENCE
  if ("%movement" = "automoveenterdobeks") then goto ENTER.DOBEKS
  matchre MOVE.SCRIPT.DONE ^MOVE SUCCESSFUL
  matchre MOVE.FAILED ^MOVE FAILED
  put .%movement
  matchwait

MOVE.SCRIPT.DONE:
  var subscript 0
  shift
  math depth subtract 1
  if (len("%2") > 0) then echo Next move: %2
  action (mapper) on
  goto MOVE.DONE

MOVE.FATIGUE:
  echo *** TOO FATIGUED TO CLIMB! ***

FATIGUE.CHECK:
  pause 0.5
  if ("$guild" = "Barbarian") then
    {
    put berserk avalanche
    pause 2
    }
  if ("$guild" = "Bard") then
    {
    put prep hodi 20
    pause 18
    put -cast;-2 gesture
    pause
    }
  if ("$guild" = "Empath") then
    {
    put prep refresh 20
    pause 18
    put -cast;-2 gesture
    pause
    }
  if ("$guild" = "Warrior Mage") then
    {
    put prep zephyr 20
    pause 18
    put -cast;-2 gesture
    pause
    }
  if ("$guild" = "Cleric") then
    {
    put prep EF 20
    pause 18
    put -cast;-2 gesture
    pause
    }
  pause

MOVE.INVIS:
  if (%depth > 1) then waiteval (1 = %depth)
  if ("$guild" = "Thief") then send khri stop silence vanish
  if ("$guild" = "Necromancer") then send release eotb
  if ("$guild" = "Moon Mage") then
    {
    send release rf
    send release sov
    }
  if ("$guild" = "Ranger") then send release blend
  if ($hidden) then send unhide
  pause %command_pause
  put %movement
  pause %command_pause
  goto MOVE.DONE

FATIGUE.WAIT:
  if ($stamina > 55) then
    {
    put %movement
    pause %command_pause
    goto move.done
    }
  echo *** Pausing to recover stamina
  pause 10
  goto FATIGUE.WAIT

MOVE.STAIRS:
MOVE.WAIT:
  pause %command_pause
  if (%movewait) then
    {
    matchre MOVE.DONE ^You reach|you reach|^Just when it seems
    matchwait
    }
  goto MOVE.DONE

MOVE.STAND:
  gosub STAND
  goto RETURN.CLEAR

MOVE.RETREAT:
  action (mapper) off
  if (!$standing) then gosub STAND
  if ($hidden) then gosub UNHIDE
  pause %command_pause
  matchre MOVE.RETREAT %move_RETRY|^Roundtime|^You retreat back
  matchre RETURN.CLEAR ^You retreat from combat|^You sneak back out of combat|^You are already as far away as you can get
  put retreat
  matchwait

MOVE.DIVE:
  if ($broom_carpet = 1) then
    {
    eval movement replacere("%movement", "dive ", "")
    put go %movement
    }
  else put dive %movement
  goto MOVE.DONE

MOVE.GO:
  put go %movement
  goto MOVE.DONE

MOVE.KNEEL:
  var action kneel
  var success ^You rise to a kneeling|^You kneel|^You're already kneeling|^Subservient type
  gosub ACTION
  put %movement
  goto MOVE.DONE

MOVE.LIE:
  var action lie
  var success ^You lie down|^You are already lying down
  gosub ACTION
  put %movement
  goto MOVE.DONE

MOVE.NOSNEAK:
  if (%closed) then goto MOVE.CLOSED
  eval movement replacere("%movement", "sneak ", "")
  put %movement
  goto MOVE.DONE

MOVE.DRAWBRIDGE:
  waitforre ^Loose chains clank as the drawbridge settles on the ground with a solid thud\.
  put %movement
  goto MOVE.DONE

MOVE.ROPE.BRIDGE:
  action instant put retreat;put retreat when melee range|pole weapon range
  waitforre finally arriving|finally reaching
  action remove melee range|pole weapon range
  put %movement
  goto MOVE.DONE

MOVE.RETRY:
  echo
  echo *** Retry movement
  echo
  if ($webbed) then waiteval (!$webbed)
  if ($stunned) then
    {
    pause
    goto MOVE.RETRY
    }
  pause %command_pause
  goto RETURN.CLEAR

MOVE.RETRY.GO:
  echo
  echo *** Retry movement
  echo
  eval movement replacere("%movement", "climb ", "go ")
  if ($webbed) then waiteval (!$webbed)
  if ($stunned) then
    {
    pause
    goto MOVE.RETRY.GO
    }
  pause %command_pause
  goto MOVE.RT

MOVE.CLOSED:
  echo
  echo *************************************
  echo **  SHOP IS CLOSED FOR THE NIGHT!  **
  echo *************************************
  echo
  put #parse SHOP IS CLOSED
  put #parse SHOP CLOSED
  exit

JAILED:
  echo
  echo ***************************
  echo **  GOT THROWN IN JAIL!  **
  echo **  ABORTING AUTOMAPPER  **
  echo ***************************
  echo
  put #parse JAILED
  put #parse NAILED AND JAILED!
  put #parse THROWN IN JAIL
  exit

MOVE.FAILED:
#  if (("$zonename" = "Misenseor Abbey") && ("$roomid" = "6")) then goto ABBEY.HATCH
  var subscript 0
  evalmath failcounter %failcounter + 1
  if (%failcounter > 4) then
    {
    put #parse MOVE FAILED
    put #parse AUTOMAPPER MOVEMENT FAILED!
    put #flash
    exit
    }
  echo
  echo ********************************
  echo MOVE FAILED - Type: %type | Movement: %movement | Depth: %depth
  echo Remaining Path: %0
  var remaining_path %0
  eval remaining_path replacere("%0", " ", "|")
  echo %remaining_path[1]
  echo %remaining_path[2]
  pause %command_pause
  ### ADDED EXIT HERE ON FAILURE TO LET AUTOMOVE ROUTINES TAKE OVER AND RETRY
  ### AS THE AUTO-RETRY FEATURE IN HERE NO ONE CAN SEEM TO GET TO WORK RIGHT
  put #parse MOVE FAILED
  put #parse AUTOMAPPER MOVEMENT FAILED!
  exit
  echo RETRYING Movement...%failcounter / 3 Tries.
  echo ********************************
  if (%failcounter > 3) then
    {
    echo [Trying: go %remaining_path(2) due to possible movement overload]
    put go %remaining_path(2)
    }
  if ("%type" = "search") then put %type
  pause
  echo [Moving: %movement]
  put %movement
  matchwait 5

END.RETRY:
  pause

RETURN.CLEAR:
  action (mapper) on
  var depth 0
  goto MAIN.LOOP.CLEAR

CARAVAN:
  waitforre ^Your .*\, following you\.
  goto MAIN.LOOP.CLEAR

POWERWALK:
  if (($Attunement.LearningRate > 33) || ($Attunement.Ranks > 1749)) then {
    put #var powerwalk 0
    var typeahead.max $automapper.typeahead
    return
    }
  var action perceive
  var typeahead.max 0
  var success ^\s*Roundtime\s*\:?|^\s*\[Roundtime\s*\:?|^\s*\(Roundtime\s*\:?|^Something in the area is interfering
  goto ACTION.WALK

SEARCHWALK:
  var action search
  var typeahead.max 0
  var success ^You search around|^After a careful search|^You notice|^Roundtime\:|^You push through bushes|^You scan|^There seems to be|^You walk around the perimeter|^Just under the Bridge
  goto ACTION.WALK

FORAGEWALK:
  var action forage $forage
  var typeahead.max 0
  var success ^Roundtime|^Something in the area is interfering
  goto ACTION.WALK

MAPWALK:
  var action study my map
  var typeahead.max 0
  var success ^The map has a large 'X' marked in the middle of it
  goto ACTION.WALK

MOVE.DONE:
  if (!$standing) then gosub STAND
  if ((%cloak_off) && matchre("$lefthand $righthand", "%cloaknouns")) then gosub WEAR.CLOAK
  if ($caravan) then goto CARAVAN
  if ($powerwalk) then goto POWERWALK
  if ($searchwalk) then goto SEARCHWALK
  if ($mapwalk) then goto MAPWALK
  gosub clear
  goto MAIN.LOOP

RETURN:
  if (!$standing) then gosub STAND
  if ($caravan) then goto CARAVAN
  if ($powerwalk) then goto POWERWALK
  if ($searchwalk) then goto SEARCHWALK
  if ($mapwalk) then goto MAPWALK
  var movewait 0
  return

ABBEY.HATCH:
  action (abbey) on
  action (abbey) var abbey_sconce 1 when ^What were you referring to?
  var abbey_sconce 0
  var action go secret hatchway
  var success ^What were you referring to?|^A narrow, winding staircase has been chiseled
  gosub ACTION
  if (!%abbey_sconce) then goto ABBEY.HATCH.SUCCESS
  move go ironbound door
  var action turn sconce
  var success ^The torch sconce has been turned as far as it will go|^You hear a faint click
  gosub ACTION
  move go ironbound door
  move go secret hatchway
ABBEY.HATCH.SUCCESS:
  action (abbey) off
  goto MOVE.SCRIPT.DONE

GEAR.GATE.BYPASS:
  var wall 0
  var wall_trigger torch
  action (ggbypass) var wall 0 when ^The stone wall slowly closes|stone wall closes\.$
  action (ggbypass) var wall 1 when ^A gouged stone wall slowly opens up|and a gouged stone wall opens up\.$
  action (ggbypass) on

GEAR.GATE.BYPASS.CHECK:
  if (!$standing) then gosub STAND
  if matchre("$roomobjs", "a gouged stone wall") then var wall 1
  if ("$roomid" = "263") then var wall_trigger basin
  if ("$roomid" = "264") then var wall_trigger torch
  if (!%wall) then
    {
    var action turn %wall_trigger
    var success ^As you pull down on
    var action_retry ^You push up on the
    gosub ACTION
    var action_retry ^0$
    }
  if (%wall) then
    {
    if (!$standing) then gosub STAND
    move go wall
    action (ggbypass) off
    var subscript 0
# Not sure which one to use! My testing worked with MOVE.DONE. If MOVE.SCRIPT.DONE is better, then remove "action (mapper) on" in this block.
#    action (mapper) on
#    goto MOVE.DONE
    goto MOVE.SCRIPT.DONE
    }
  goto GEAR.GATE.BYPASS.CHECK

ENTER.DOBEKS:
  pause %command_pause
  put kiss scorpion
  pause
  echo *** PAUSING FOR STUN
  pause 13
  if ($stunned) then waiteval (!$stunned)
  if (!$standing) then gosub STAND
  pause %command_pause
  goto MOVE.SCRIPT.DONE

ARMOIRE:
  action (armoire) on
  action (armoire) goto ARMOIRE when ^The armoire's double doors suddenly swing shut of their own accord
  var action open armoire
  var success ^You open the double mahogany doors of the armoire|^The armoire is already open
  gosub ACTION
  var action search armoire
  var success ^Your hand touches on a small wooden peg|^You begin to search through the armoire, but notice a gaping hole
  gosub ACTION
  var movement go armoire
  action (armoire) off
  action (mapper) on
  var subscript 0
  goto MOVE.REAL

MISTWOOD.CLIFF:
  var NextRoom ^(?:Obvious (?:paths|exits)|It's pitch dark|You can't go there|You can't sneak in that direction)
  action var Dir $1 when ^Peering closely at a faint path, you realize you would need to head (\w+)\.
  put peer path
  waitforre Peering closely at
  put down
  waitforre %NextRoom
  put %Dir
  waitforre %NextRoom
  put nw
  waitforre %NextRoom
  goto MOVE.SCRIPT.DONE

SANDSPIT.TAVERN:
  action (sandspit) on
  action (sandspit) var barrel 0 when ^You duck quietly into an old barrel.
  action (sandspit) var barrel 1 when ^You can't do that.
  var action go barrel
  var success ^You can't|^You duck
  gosub ACTION
  if ("%barrel" = "1") then
    {
    var action go other barrel
    gosub ACTION
    }
  pause %command_pause
  action (sandspit) off
  goto MOVE.SCRIPT.DONE

HIB.INTELLIGENCE:
  action (hibintel) on
  action (hibintel) var steeldoor 0 when Chedik Bridge, Engineer's Tower
  action (hibintel) var steeldoor 1 when ^You can't do that.
  var action go steel door
  var success ^You can't|Chedik Bridge, Engineer's Tower
  gosub ACTION
  if ("%steeldoor" = "1") then
    {
    var action go other steel door
    gosub ACTION
    }
  pause %command_pause
  action (hibintel) off
  goto MOVE.SCRIPT.DONE

AUTOCLIMB.DOWN:
  var autoclimb down
  goto AUTOCLIMB

AUTOCLIMB.UP:
  var autoclimb up

AUTOCLIMB:
  var action climb %autoclimb
  var action_retry ^You work your way|^You slip but catch yourself
  var success ^You climb over the top|^Obvious
  gosub ACTION
  var action_retry ^0$
  goto MOVE.SCRIPT.DONE

ANDRESHLEW.VINE:
  var action tap vine
  var success ^As you attempt to (touch|tap) the vine
  gosub ACTION
  waitforre ^Just as you were about to hit, the vine snakes around your waist and sets you gently on the ground
  pause %command_pause
  goto MOVE.SCRIPT.DONE

GET.MAP:
  var action get my map
  var success ^You get|^You are already holding
  goto ACTION

FIND.SKATES:
  var checked 1
  echo *** Checking for ice skates! ***
  action (skates) var skate.container $1 when ^You tap .*\bskates\b.*inside your (.*)\.$
  action (skates) var skate.container portal when ^In the .* eddy you see.* \bskates\b
  action (skates) var skate.container held when ^You are holding some.*\bskates\b
  if matchre("$righthand|$lefthand", "skates") then goto CHECK.FOOTWEAR
  var action tap my skates
  var success ^You tap|^I could not|^What were you
  gosub ACTION
  if (%wearing_skates) then return
  if ("%skate.container" != "0") then goto CHECK.FOOTWEAR

FIND.SKATES.PORTAL:
  gosub LOOK.PORTAL

CHECK.FOOTWEAR:
  action (skates) var footwear $1 when ^\s\s.*(skates|boots?|shoes?|moccasins?|sandals?|slippers?|mules|workboots?|footwraps?|footwear|spats?|chopines?|nauda|booties|clogs|buskins?|cothurnes?|galoshes|half-boots?|ankle-boots?|gutalles?|hessians?|brogans?|toe\s?-?rings?|toe\s?-?bells?|loafers?|pumps?)
  action (skates) var footwear 0 when ^You aren't wearing anything like that
  var footwear unknown
  var action inv feet
  var success ^You aren't wearing anything like that|^All of your items worn on the feet
  gosub ACTION
  if ("%footwear" = "skates") then return
  if (!%skate.container) then goto SKATE.NO
  if ("%footwear" = "unknown") then
    {
    put #echo yellow *** ERROR: Unknown noun for your footwear! ***
    goto SKATE.NO
    }
  echo *** Ice skates found! ***
  if ((!%footwear) && ("%skate.container" = "held") then goto WEAR.SKATES
  if (!%footwear) then goto GET.SKATES

REMOVE.FOOTWEAR:
  var action remove my %footwear
  var success ^You (aren't|can't|carefully|climb|deftly|detach|drape|fade|fall|get|hang|kneel|lie|loosen|place|pull|quickly|remove|rise|set|shift|silently|sit|slide|sling|slip|stand|step|unstrap|take|toss|untie|work|wrap|yank)
  gosub ACTION

STOW.FOOTWEAR:
  action (skates) var footwear.container $1 when ^You put your .* in your (.*)\.$
  var action stow my %footwear
  var success ^You put
  gosub ACTION

GET.SKATES:
  var action get my skates in my %skate.container
  var success ^You get
  gosub ACTION

WEAR.SKATES:
  var action wear my skates
  var success ^You slide your ice skates on your feet and tightly tie the laces|^You (are already|aren't|attach|can't|carefully|climb|deftly|detach|drape|fade|fall|get|hang|kneel|lie|loosen|need|place|pull|put|quickly|remove|rise|set|shift|silently|sit|slide|sling|slip|stand|step|strap|take|tie|toss|untie|work|wrap|yank)
  goto ACTION

REMOVE.SKATES:
  echo *** Removing ice skates! ***
  var action remove my skates
  var success ^You untie your skates and slip them off of your feet
  gosub ACTION

STOW.SKATES:
  if (!"%skate.container") then var action stow my skates
  else var action put my skates in my %skate.container
  var success ^You put
  gosub ACTION

GET.FOOTWEAR:
  if (%footwear = 0) then return
  echo *** Putting your %footwear back on! ***
  var action get my %footwear in my %footwear.container
  var success ^You get
  gosub ACTION

WEAR.FOOTWEAR:
  var action wear my %footwear
  var success ^You (are already|attach|can't|carefully|climb|deftly|drape|fade|fall|get|hang|kneel|lie|loosen|place|pull|put|quickly|rise|set|shift|silently|sit|slide|sling|slip|stand|step|strap|take|tie|toss|untie|work|wrap|yank)
  goto ACTION


FIND.CLOAK:
  action (cloak) on
  action (cloak) var cloak_worn 1 when ^You tap.*(%cloaknouns).*that you are wearing\.$
  action (cloak) var cloak_worn 2 when ^You attempt to turn
  var cloakloop 0
  var cloak_worn 0

TAP.CLOAK:
  var cloak_noun %cloaknouns[%cloakloop]
  if (%cloak_noun = 0) then return
  var action tap my %cloak_noun
  var success ^You tap|^I could not find
  gosub ACTION
  math cloakloop add 1
  if (!%cloak_worn) then goto TAP.CLOAK

LOWER.CLOAK:
  var action_retry ^You pull your %cloak_noun
  var action turn my %cloak_noun
  var success ^You (attempt to turn|pull down your|wind|unwind)
  gosub ACTION
  var action_retry ^0$
  if ("%cloak_worn" = "2") then goto REMOVE.CLOAK
  return

RAISE.CLOAK:
  var action_retry ^You pull down your
  var action turn my %cloak_noun
  var success ^You (attempt to turn|pull your %cloak_noun|wind|unwind)
  gosub ACTION
  var action_retry ^0$
  return

REMOVE.CLOAK:
  var action remove my %cloak_noun
  var success ^You (are already|aren't|attach|can't|carefully|climb|deftly|detach|drape|fade|fall|get|hang|kneel|lie|loosen|need|place|pull|put|quickly|remove|rise|set|shift|silently|sit|slide|sling|slip|stand|step|strap|take|tie|toss|untie|work|wrap|yank)|slips away from your face
  gosub ACTION
  var cloak_off 1
  return

WEAR.CLOAK:
  if matchre("$lefthand", "(%cloaknouns)") then var action wear my $lefthandnoun
  if matchre("$righthand", "(%cloaknouns)") then var action wear my $righthandnoun
  var success ^You (are already|attach|can't|carefully|climb|deftly|drape|fade|fall|get|hang|kneel|lie|loosen|place|pull|put|quickly|rise|set|shift|silently|sit|slide|sling|slip|stand|step|strap|take|tie|toss|untie|work|wrap|yank)
  gosub ACTION
  var cloak_off 0
  return

LOOK.PORTAL:
  var action look in my watery portal
  var success ^In the.*you see|^I could not find
  goto ACTION

STOW.FOOT.ITEM:
  gosub STOW.FEET
  gosub STOW.HANDS
  goto ABSOLUTE.TOP

STOW.FEET:
  var action stow feet
  eval footitem replacere("%footitem", "([\w'-]+\s){0,5}", "")
  if matchre("%footitem", "(mat|rug|cloth|tapestry)") then var action roll %footitem
  var success ^You pick up .* lying at your feet|^You carefully gather up the delicate folds|^You start at one end of your|^Stow what\?
  goto ACTION

STOW.HANDS:
  if !matchre("Empty", "$lefthand") then gosub STOW.LEFT
  if !matchre("Empty", "$righthand") then gosub STOW.RIGHT
  return

STOW.LEFT:
  var action stow my $lefthandnoun
  var success ^You put|^Stow what\?
  goto ACTION

STOW.RIGHT:
  var action stow my $righthandnoun
  var success ^You put|^Stow what\?
  goto ACTION

UNHIDE:
  var action unhide
  var success ^But you are not hidden|^You come out of hiding
  goto ACTION

ACTION.STOW.HANDS:
  var actionbackup %action
  var successbackup %success
  gosub STOW.HANDS
  var action %actionbackup
  var success %successbackup
  goto ACTION

ACTION.STOW.UNLOAD:
  var unloadables crossbow|sling|bow|blowgun|arbalest|arbalist|chunenguti|hrr'ibu|jiranoci|jranoki|mahil|taisgwelduan|uku'uanstaho
  var actionbackup %action
  var successbackup %success
  if matchre("$righthand", "%unloadables") then var action unload my $righthandnoun
  if matchre("$lefthand", "%unloadables") then var action unload my $lefthandnoun
  var success ^Roundtime\:|^You unload
  gosub ACTION
  gosub STOW.HANDS
  var action %actionbackup
  var success %successbackup
  goto ACTION

STAND:
  var action stand
  var success ^You stand up|^You stand back up|^You are already standing|^As you stand
  goto ACTION.MAPPER.ON

ACTION.WALK:
  gosub ACTION.MAPPER.ON
  goto MAIN.LOOP.CLEAR

ACTION.WAIT:
  pause 3
  if ($stunned) then waiteval (!$stunned)
  if ($webbed) then waiteval (!$webbed)

ACTION:
  #matchre ACTION_WAIT ^Roundtime\:?|^\[Roundtime\:?|^\(Roundtime\:?|^\[Roundtime|^Roundtime
  # depending on the action, this could be a retry or a success...
  action (mapper) off

ACTION.MAPPER.ON:
  pause %command_pause
  matchre ACTION ^\.\.\.wait|^Sorry,|^Please wait\.|^The weight of all your possessions|^You are overburdened and cannot|^You are so unbalanced|%action_retry
  matchre TAP.CLOAK ^Something else is already hiding your features
  matchre ACTION.RETURN %success
  matchre ACTION.STOW.HANDS ^You must have at least one hand free to do that|^You need a free hand
  matchre ACTION.WAIT ^You're unconscious|^You are still stunned|^You can't do that while|^You don't seem to be able to
  matchre ACTION.FAIL ^There isn\'t any more room|^You just can't get the .* to fit
  matchre ACTION.STOW.UNLOAD ^You should unload
  put %action
  matchwait 0.5
  if (%waitfor_action = 1) then goto ACTION
  goto ACTION.RETURN

ACTION.FAIL:
  put #echo
  put #echo yellow *** Unable to perform action: %action ***
  put #echo

ACTION.RETURN:
  if ($roundtime > 0) then pause %command_pause
  if (%subscript) then return
  action (mapper) on
  return
