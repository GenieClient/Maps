# automapper.cmd
var autoversion 8.2023-01-08
# use '.automapper help' from the command line for variables and more
# debug 5 is for outlander; genie debuglevel 10
#debuglevel 10
#debug 5

#2023-01-08
# Hanryu
#   Outlander has $client now, so adjusting for that

#2023-01-05
# Hanryu
#   Sigil walking *would* keep plowing on for the 2nd sigil even if you're locked, now fixt

#2022-12-31 
# Shroom
#   Added SUBSCRIPTS for movement into / out of Gate of Souls
#   Default movement was VERY clunky and didn't work properly, now MUCH better - Should not hang up or error
#   Fixed MOVE.RETRY issue that could cause infinite hang if starting in RT 
#   waitfor_action updated
#   Added counter to Action sub as failsafe   

#2022-12-18 
# Shroom
#   Fix in startup for rogue automapper.typeahead var being set - (will auto-set to 1 if NOT set a NUMBER)
#   Merged Hanryu changes 
#   Athletics check for Thieves Khri for climbing - Will skip khri at higher Athletics

#2022-12-15
# Hanryu
#   Sigil walking
#   walk help
#   belly crawl room for shard wgate favors
#   changed send to put in MOVE.TORCH
#   commented out race condition with ggbypass
#   added a pause at the end of "script" execution
#   moved move.invis out of the middle of fatigue block (boy that's a mess)

#2022-12-10
# Hanryu
#   unixtime instead of gametime, checks for genie version
#   delay iff !first depth, also check for RT so the loop is not going nuts while RT is ticking down
#   added drag by current handling for low swimming ranks
#   leaving some notes on USERWALK
#   USERWALK implimentation
#   adding feature hiding mask
#   removed s from rocks
#   ^\s*[\[\(]?[rR]oundtime\s*\:? for all RT matches
#   retry now zero's everything out and heads back to wave.do
#   Jon's got a new MOVE.RT for us and I like it

#2022-11-30
# Hanryu
#   separated out MOVE.WAIT:

#2022-11-16
# Hanryu
#   dealing with an outlander bug where 2 "when"s in an action line mess it up
#   searching xala path
#   >= 1750 for exp checks, yea I am undoing something I messed up

#2022-11-04
# Shroom
# - Added additional FAIL catches to ACTION sub
# - Added a hard STOW FEET at end of STOW.FEET sub
# - To fix a endless loop in rare cases where false positives on a "cloth/rug" at feet that CANNOT be rolled
# - Should not really effect anything in normal stow feet logic other than firing the command twice
#
#2022-11-03
# Hanryu
#   issue with shard a night... yet again! New subscript
#   fall-thru message for PP walk if you're playing zills
#   added a timeout to MOVE.RT evalwait depth drops based on VTCifer's code

#2022-11-02
# Hanryu
#   addressing issue 33 and 32, mono echo and missing fancy characters
#   working toward a better retry

#2022-10-30 to 11-01
# Shroom - Fixing several bugs
# Fixed several no gosubs to return to errors
# Re-commented rope bridge as still in use in TF for now 
# Even though Travel detects whether bridge or rope is up - Automapper still used as a backup method 
# Added more fail messages to ACTION
# NEW - Added a STOW.ALT module as a backup to regular STOWING
# IF "STOW" fails and does not empty hands - will check inv for others bags and try putting in those bags
# Will attempt up to 4 containers - Auto-Scans inventory for the most common containers
# Anchored JAILED triggers 
# Hanryu - cleaned up echos to use new echo tech
# Added check for "are you in RT when you start"
# Added bridge in adanf as a place to wait
# deleted move_DIVE since it was undefined, commented out the action for move.dive
# ^\s*[\[\(]?Roundtime\s*\:? for all RT matches

#2022-10-22 thru 27
# Hanryu, with a strong assist from TenderVittles
# working on afordances for different system speeds on RT generating moves (MOVE.RT label)
# added a wait in retry if waitfor_action = 1
# Added inviso drop message on "get skates"
# add verbose flag to toggle next move echo
# still fighting run conditions at the shard gates at night when powerwalking
# changed echo and added globals to make updates preserve prefs
# commenting out the rope bridge, sorry TF
# unify move.retry: and move.retry.go:

#2022-10-14
# Shroom - Increased default genie pause slightly
# Added additional match for move_OK to fix hangup at Crystalline Gorge (You move effortlessly through the shard/wall!)
# Cleaned up some bad regex (unnecessary \')
# Slightly increased matchwait timeout for Action to fix issues with skates 

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

## use me for if you need an input
# checks for outlander v. genie, outlander does not suppor the `mono` flag
if matchre("$client", "Genie") then var helpecho #33CC99 mono
if matchre("$client", "Outlander") then var helpecho #33CC99
if matchre("%1", "help|HELP|Help|^$") then {
  put #echo %helpecho <~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~>
  put #echo %helpecho <<  Welcome to automapper Setup!   (version %autoversion)           >>
  put #echo %helpecho <<  Use the command line to set the following preferences:          >>
  put #echo %helpecho <<    Typeahead                                                     >>
  put #echo %helpecho <<      Standard Account = 1, Premium Account = 2, LTB Premium = 3  >>
  put #echo %helpecho <<      #var automapper.typeahead 1                                 >>
  put #echo %helpecho <<    Pause                                                         >>
  put #echo %helpecho <<      Time to pause before sending a "put x" command              >>
  put #echo %helpecho <<      #var automapper.pause 0.01                                  >>
  put #echo %helpecho <<    Confirmation                                                  >>
  put #echo %helpecho <<      1: wait for correct confirmation of sent commands           >>
  put #echo %helpecho <<      0: don't wait                                               >>
  put #echo %helpecho <<      #var automapper.confirmation 1                              >>
  put #echo %helpecho <<    Infinite Loop Protection                                      >>
  put #echo %helpecho <<      Increase if you get infinte loop errors                     >>
  put #echo %helpecho <<      #var automapper.loop 0.001                                  >>
  put #echo %helpecho <<    Echoes                                                        >>
  put #echo %helpecho <<      how verbose do you want automapper to be?                   >>
  put #echo %helpecho <<      #var automapper.verbose 1                                   >>
  put #echo %helpecho <<    Ice Road Behavior                                             >>
  put #echo %helpecho <<      1: collect rocks on the ice road when lacking skates        >>
  put #echo %helpecho <<      0: just wait 15 seconds with no RT instead                  >>
  put #echo %helpecho <<      #var automapper.iceroadcollect 1                            >>
  put #echo %helpecho <<    Color                                                         >>
  put #echo %helpecho <<      What should the default automapper echo color be?           >>
  put #echo %helpecho <<      #var automapper.color #33CC99                               >>
  put #echo %helpecho <<    Class                                                         >>
  put #echo %helpecho <<      Which classes should automapper turn on and off?            >>
  put #echo %helpecho <<      #var automapper.class -arrive -combat -joust -racial -rp    >>
  put #echo %helpecho <<  Now save! (#save vars for Genie | cmd-s for Outlander)          >>
  put #echo %helpecho <<                                                                  >>
  put #echo %helpecho <<  try `.automapper walk` for help with the various walk types     >>
  put #echo %helpecho <~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~>
  exit
}
if matchre("%1", "^walk$") then {
  put #echo %helpecho <~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~>
  put #echo %helpecho <<  Welcome to automapper walk help!                          >>
  put #echo %helpecho <<    Caravan Walking                                         >>
  put #echo %helpecho <<      wait for your caravan                                 >>
  put #echo %helpecho <<      #var caravan 0/1                                      >>
  put #echo %helpecho <<    Drag                                                    >>
  put #echo %helpecho <<      drag a target around                                  >>
  put #echo %helpecho <<      #var drag 0/1                                         >>
  put #echo %helpecho <<      #var drag.target name/item                            >>
  put #echo %helpecho <<    Map Walking                                             >>
  put #echo %helpecho <<      study a map for treasure                              >>
  put #echo %helpecho <<      #var mapwalk 0/1                                      >>
  put #echo %helpecho <<    Power Walking                                           >>
  put #echo %helpecho <<      percieve the mana until locked                        >>
  put #echo %helpecho <<      #var powerwalk 0/1                                    >>
  put #echo %helpecho <<    Sigil Walking                                           >>
  put #echo %helpecho <<      find both sigils in each room                         >>
  put #echo %helpecho <<      trains: Scholarship, Arcana, Outdoorsmanship          >>
  put #echo %helpecho <<      #var automapper.sigilwalk 0/1                         >>
  put #echo %helpecho <<    Search Walking                                          >>
  put #echo %helpecho <<      search in every room                                  >>
  put #echo %helpecho <<      #var searchwalk 0/1                                   >>
  put #echo %helpecho <<    USER Walking                                            >>
  put #echo %helpecho <<      this can do whatever you'd like!                      >>
  put #echo %helpecho <<        you MUST define globals automapper.UserWalkAction   >>
  put #echo %helpecho <<        you MUST define globals automapper.UserWalkSuccess  >>
  put #echo %helpecho <<        you MAY define globals automapper.UserWalkRetry     >>
  put #echo %helpecho <<      #var automapper.userwalk 0/1                          >>
  put #echo %helpecho <<                                                            >>
  put #echo %helpecho <<  Please search automapper.cmd for "Related macros"         >>
  put #echo %helpecho <~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~>
  exit
}

ABSOLUTE.TOP:
# ---------------
#USER VARS:
# Type ahead declaration
# The following will use a global to set it by character.  This helps when you have both premium and standard accounts.
# Standard Account = 1, Premium Account = 2, LTB Premium = 3
# automapper.typeahead FIX - Some users had a rogue variable set for automapper.typeahead 
# This sets automapper.typeahead to 1 if the variable is NOT present at all
# This will auto reset it back to 1 IF the automapper.typeahead is ~NOT~ set to a number
  if ((!def(automapper.typeahead)) || (!matchre("$automapper.typeahead", "^[1-5]$"))) then put #var automapper.typeahead 1
  var typeahead.max $automapper.typeahead
# Time to pause before sending a "put x" command
  if !def(automapper.pause) then var command_pause 0.01
  else var command_pause $automapper.pause
# 1: wait for correct confirmation of sent commands; 0: don't wait
  if !def(automapper.confirmation) then var waitfor_action 1
  else var waitfor_action $automapper.confirmation
# echo next move? 1 = YES, 0 = NO
  if !def(automapper.verbose) then var verbose 1
  else var verbose $automapper.verbose
# what color do you want for echos?
  if !def(automapper.color) then var color #33CC99
  else var color $automapper.color
# Decrease at your own risk, increase if you get infinte loop errors
#default is 0.1 for Outlander, 0.001 for Genie
  if !def(automapper.loop) then
    {
    if matchre("$client", "Genie") then var infiniteLoopProtection 0.001
    if matchre("$client", "Outlander") then var infiniteLoopProtection 0.1
    }
  else var infiniteLoopProtection $automapper.loop
# 1: collect rocks on the ice road when lacking skates; 0; just wait 15 seconds with no RT instead
  if !def(automapper.iceroadcollect) then var ice_collect 0
  else var ice_collect $automapper.iceroadcollect
  if !def(caravan) then put #tvar caravan 0
  if !def(drag) then put #tvar drag 0
  if !def(mapwalk) then put #tvar mapwalk 0
  if !def(powerwalk) then put #tvar powerwalk 0
  if !def(automapper.sigilwalk) then put #tvar automapper.sigilwalk 0
  if !def(searchwalk) then put #tvar searchwalk 0
  if !def(automapper.userwalk) then put #tvar automapper.userwalk 0
# turn off classes to speed movment
  if def(automapper.class) then put #class $automapper.class
# ---------------
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
  var cloaknouns cloak|shroud|scarf|aldamdin mask|0
  var closed 0
  var startingStam $stamina
  var failcounter 0
  var depth 0
  var movewait 0
  var TryGoInsteadOfClimb 0
  var move_OK ^Obvious (paths|exits)|^It's pitch dark|The shop appears to be closed, but you catch the attention of a night attendant inside,|^You move effortlessly through the
  var move_FAIL ^You can't swim in that direction|You can't go there|^A powerful blast of wind blows you to the|^What were you referring to|^I could not find what you were referring to\.|^You can't sneak in that direction|^You can't ride your.+(broom|carpet) in that direction|^You can't ride that way\.$
  var move_RETRY ^\.\.\.wait|^Sorry, you may only|^Sorry, system is slow|^The weight of all|lose your balance during the effort|^You are still stunned|^You're still recovering from your recent|^The mud gives way beneath your feet as you attempt to climb higher, sending you sliding back down the slope instead\!|You're not sure you can
  var move_RETREAT ^You are engaged to|^You try to move, but you're engaged|^While in combat|^You can't do that while engaged|^You can't do that\!  You're in combat\!
  var move_WEB ^You can't do that while entangled in a web|As you start to move, you find yourself snared
  var move_WAIT ^You continue climbing|^You begin climbing|^You really should concentrate on your journey|^You step onto a massive stairway|^You start the slow journey across the bridge\.$|^Wriggling on your stomach, you crawl into a low opening\.$
  var move_END_DELAY ^You reach|you reach\.\.\.$|^Finally the bridge comes to an end|^After a seemingly interminible length of time, you crawl out of the passage into
  var move_STAND ^You must be standing to do that|^You can't do that while (lying down|kneeling|sitting)|You try to quickly step from root to root, but slip and drop to your knees|you trip over an exposed root|^Stand up first\.|^You must stand first\.|^You'll need to stand up|a particularly sturdy one finally brings you to your knees\.$|You try to roll through the fall but end up on your back\.$|^Perhaps you might accomplish that if you were standing\.$
  var move_NO_SNEAK ^You can't do that here|^In which direction are you trying to sneak|^Sneaking is an inherently stealthy|^You can't sneak that way|^You can't sneak in that direction
  var move_GO ^Please rephrase that command
  var move_MUCK ^You fall into the .+ with a loud \*SPLUT\*|^You slip in .+ and fall flat on your back\!|^The .+ holds you tightly, preventing you from making much headway\.|^You make no progress in the mud|^You struggle forward, managing a few steps before ultimately falling short of your goal\.|^You find yourself stuck in the mud
  var climb_FAIL ^Trying to judge the climb, you peer over the edge\.  A wave of dizziness hits you, and you back away from .+\.|^You start down .+, but you find it hard going\.  Rather than risking a fall, you make your way back up\.|^You attempt to climb down .+, but you can't seem to find purchase\.|^You pick your way up .+, but reach a point where your footing is questionable\.  Reluctantly, you climb back down\.|^You make your way up .+\.  Partway up, you make the mistake of looking down\.  Struck by vertigo, you cling to .+ for a few moments, then slowly climb back down\.|^You approach .+, but the steepness is intimidating\.|^The ground approaches you at an alarming rate|^You start up .+, but slip after a few feet and fall to the ground\!  You are unharmed but feel foolish\.|^You almost make it to the top|^You start the climb and slip|^You start to climb .+, but then stop to reconsider\.
  var move_CLOSED ^The door is locked up tightly for the night|^You stop as you realize that the|^(?:\w+ )+I'm sorry, but you need to be a citizen|^BONK\! You smash your nose|^Bonk\! You smash your nose|^(?:\w+ )+I'm sorry, I can only allow citizens in at night|^(?:\w+ )+shop is closed for the night|^A guard appears and says, \"I'm sorry,|The shop appears to be closed, but you catch the attention of a night attendant inside, and he says, \"I'm sorry, I can only allow citizens in at night\.\""?
  var swim_FAIL ^You struggle (?!to maintain)|^You work(?! your way (?:up|down) the cliff)|^You slap|^You flounder
  var move_DRAWBRIDGE ^The guard yells, "Lower the bridge|^The guard says, "You'll have to wait|^A guard yells, "Hey|^The guard yells, "Hey
  var move_ROPE.BRIDGE is already on the rope\.|You'll have to wait
  var move_STOW ^You need to empty your hands|^You should empty your hands first\!|^You can't possibly manage to cross|^You'll need to free up your hands|^Not while carrying something in your hands|^You must first free up your hands\.|^The going gets quite difficult and highlights the need to free up your hands|^You must have your hands free
  var move_FATIGUE ^You're too tired to try climbing|^You need to rest
  var move_BOAT ^The galley has just left|^You look around in vain for the galley
  var move_INVIS ^The .* can't see you\!|^But no one can see you\!|^How can you .* can't even see you\?
  var climb_mount_FAIL climb what?
ACTIONS:
  action (mapper) action (mapper) off;goto DRAGGED when ^The current drags you
  action (mapper) if (%movewait = 0) then shift;if (%movewait = 0) then math depth subtract 1;if ((%verbose) && (len("%2") > 0)) then put #echo %color Next move: %2 when %move_OK
  action (mapper) goto MOVE.FAILED when %move_FAIL
  action (mapper) var TryGoInsteadOfClimb 1 when ^You can't climb that\.$
  action (mapper) goto MOVE.RETRY when %move_RETRY|%move_WEB|^You can't climb that\.$
  action (mapper) goto MOVE.STAND when %move_STAND
  action (mapper) var movewait 1;goto MOVE.WAIT when %move_WAIT
  action (mapper) goto MOVE.RETREAT when %move_RETREAT
  action (mapper) var movewait 0 when %move_END_DELAY
  action (mapper) var closed 1;goto MOVE.CLOSED when %move_CLOSED
  action (mapper) goto MOVE.NOSNEAK when %move_NO_SNEAK
  action (mapper) goto MOVE.GO when %move_GO
  action (mapper) goto MOVE.INVIS when %move_INVIS
  action (mapper) goto MOVE.MUCK when %move_MUCK
  action (mapper) goto MOVE.STOW when %move_STOW
  action (mapper) goto MOVE.BOAT when %move_BOAT
  action (mapper) put #echo %color Will re-attempt climb in 5 seconds...;send 5 $lastcommand when ^All this climbing back and forth is getting a bit tiresome\.  You need to rest a bit before you continue\.$
  action (mapper) goto MOVE.RETRY when %swim_FAIL
  action (mapper) goto MOVE.DRAWBRIDGE when %move_DRAWBRIDGE
  action (mapper) goto MOVE.KNOCK when The gate is closed\.  Try KNOCKing instead
  action (mapper) goto MOVE.ROPE.BRIDGE when %move_ROPE.BRIDGE
  action (mapper) goto MOVE.FATIGUE when %move_FATIGUE
  action (mapper) goto MOVE.CLIMB.MOUNT.FAIL when %climb_mount_FAIL
  action (mapper) goto MOVE.KNEEL when maybe if you knelt down first\?
  action (mapper) goto MOVE.LIE when ^The passage is too small to walk that way\.  You'll have to get down and crawl\.|^There's just barely enough room here to squeeze through, and no more|^You look down at the low opening, furrowing your brow dubiously
  action (mapper) var footitem $1;goto STOW.FOOT.ITEM when ^You notice (?:an |a )?(.+) at your feet, and do not wish to leave it behind\.
  action (skates) var wearing_skates 1 when ^You slide your ice skates on your feet and tightly tie the laces\.|^Your ice skates help you traverse the frozen terrain\.|^Your movement is hindered .* by your ice skates\.|^You tap some.*\bskates\b.*that you are wearing
  action (skates) var wearing_skates 0 when ^You untie your skates and slip them off of your feet\.
  action var slow_on_ice 1;if (%verbose) then put #echo %color Ice detected! when ^You had better slow down\! The ice is|^At the speed you are traveling
  action goto JAILED when ^You slowly wake up again to find that all your belongings have been stripped and you are in a jail cell wearing a set of heavy manacles\.|^The \w+ brings you to the jail, where several companions aid to hold you down and strip you of all your possessions\.|^The town guard, with the help of several others, wrestle you to the ground, bind you in chains, and drag you off to jail\.|^\w+ you awake some time later, your possessions have been stripped from you, and you lay in a musty pile of straw\.|^The door slams shut, a sound not unlike that of a tomb closing\.
  action goto DEAD.DONE when ^You are a ghost\!

# Are you starting the script while in RT?
  if ($roundtime > 0) then pause $roundtime
  if (!$standing) then gosub STAND
MAIN.LOOP.CLEAR:
  gosub clear

#### JON's MAIN LOOP ####
MAIN.LOOP:
  if_1 goto WAVE_DO
  goto DONE
WAVE_DO:
  if (%depth > 0) then {
    delay %infiniteLoopProtection
    if ($roundtime > 0) then pause $roundtime
  }
  evalmath MDepth (%depth + 1)
  if ((%typeahead.max >= %depth) && ("%%MDepth" != "")) then gosub MOVE %%MDepth
  if ((%typeahead.max <= %depth) || ("%%MDepth" = "")) then goto MAIN.LOOP
  else goto WAVE_DO

DONE:
  if (!$standing) then gosub STAND

DEAD.DONE:
  put #parse YOU HAVE ARRIVED!
  if def(automapper.class) then
    {
    eval classON replacere("$automapper.class", "-", "+")
    put #class %classON
  }
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
# I think we should bug "some rocks" movements in game instead of trying to handle it this way
#  if matchre("%movement", "rock") && matchre("$roomobjs", "a pile of rocks") then {
#    var action kick pile
#    var success ^Now what did the|^You take a step back and run up to the pile|^I could not find
#    gosub ACTION
#  }
#
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
  if !matchre("Empty", "$righthand") then gosub STOW.RIGHT
  if matchre("$righthand", "khuj|staff|atapwi") then put wear $righthandnoun
  if (!matchre("Empty", "$lefthand") || !matchre("Empty", "$righthand")) then gosub STOW.ALT
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
  if (%verbose) then gosub echo Could not find ice skates!
  if ((%ice_collect) && (%verbose)) then gosub echo Collecting rocks in every room like the other peasants
SKATE.YES:
  return

ICE.COLLECT:
  if (!%ice_collect) then goto ICE.PAUSE
  var action collect rock
  var success ^You manage to collect a pile
  gosub ACTION
  var action kick rock
  var success ^Now what did the|^You take a step back and run up to the pile|^I could not find
  gosub ACTION
  var slow_on_ice 0
  pause %command_pause
  return

ICE.PAUSE:
  action (mapper) off
  pause %command_pause
  if (%verbose) then gosub echo Pausing 15 seconds to regain footing on slippery ice.
  pause 15
  var slow_on_ice 0
  pause %command_pause
  action (mapper) on
  return

MOVE.KNOCK:
  action (mapper) off
  if ($roundtime > 0) then pause %command_pause
  if (%depth > 1) then waiteval (1 = %depth)
  var movement knock gate
  matchre MOVE.KNOCK ^\.\.\.wait|^Sorry,|^You are still stun|^You can't do that while entangled
  matchre SHARD.FAILED Sorry, you're not a citizen
  matchre KNOCK.DONE %move_OK|All right, welcome back|opens the door just enough to let you slip through|wanted criminal
  matchre CLOAK.LOGIC ^You turn away, disappointed\.
  matchre KNOCK.INVIS ^The gate guard can't see you
  put %movement
  matchwait
# this garbage is here for Outlander inconsistant matchwait bug
  debug 5
  pause
  put #echo >talk #ffff00,#ff0000 MOVE.KNOCK failure
  pause
  goto KNOCK.DONE
#### end outlander bug handling

SHARD.FAILED:
  if ((%cloak_off) && matchre("$lefthand $righthand", "%cloaknouns")) then gosub WEAR.CLOAK
  if ((!%cloak_off) && (%cloak_worn)) then gosub RAISE.CLOAK
  if !matchre("$zoneid", "(66|67|68|69)") then goto MOVE.FAILED
  matchre KNOCK.DONE YOU HAVE ARRIVED\!
  put .sharddetour
  matchwait 45
  goto MOVE.DONE

KNOCK.INVIS:
  action (mapper) on
  goto MOVE.INVIS

KNOCK.DONE:
  action (mapper) on
  shift
  math depth subtract 1
  goto MOVE.DONE

CLOAK.LOGIC:
  gosub FIND.CLOAK
  goto MOVE.KNOCK

MOVE.DRAG:
MOVE.SNEAK:
MOVE.SWIM:
MOVE.RT:
####added this to stop trainer
  eval movement replacere("%movement", "script crossingtrainerfix ", "")
  if (%depth > 1) then waiteval (1 = %depth)
  put %movement
  waitforre ^(?:Obvious|Ship) (?:paths|exits):|^\.\.\.wait|^Sorry, you may only type
  if ($roundtime > 0) then pause %command_pause
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
  if (%verbose) then gosub echo Slow and steady here to avoid mishaps...
  pause 3
  goto MOVE.REAL

MOVE.CLIMB:
  matchre MOVE.DONE %move_OK
  matchre MOVE.CLIMB.MOUNT.FAIL climb what\?
  matchre MOVE.CLIMB.WITH.ROPE %climb_FAIL
  if ($broom_carpet) then eval movement replacere("%movement", "climb ", "go ")
  put %movement
  matchwait

MOVE.CLIMB.MOUNT.FAIL:
  matchre move.done %move_OK
  if ($broom_carpet) then eval movement replacere("%movement", "climb ", "go ")
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
  if (("$guild" = "Thief") && ($concentration > 50) && ($Athletics.Ranks < 600)) then
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
  waitforre ^\s*[\[\(]?Roundtime\s*\:?|^You cannot appraise that when you are in combat
  if (("$guild" = "Thief") && ($concentration > 50) && ($Athletics.Ranks < 600)) then
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
  waitforre ^You|^After
  if ($roundtime > 0) then pause %command_pause
  put %movement
  goto MOVE.DONE

MOVE.OBJSEARCH:
  put search %searchObj
  pause %command_pause
  if ($broom_carpet) then eval movement replacere("%movement", "climb ", "go ")
  put %movement
  pause %command_pause
  goto MOVE.DONE

MOVE.SCRIPT:
  var subscript 1
  if (%depth > 1) then waiteval (1 = %depth)
  action (mapper) off
  if ("%movement" = "abbeyhatch") then goto ABBEY.HATCH
  if ("%movement" = "gateofsouls") then goto GATE.OF.SOULS
  if ("%movement" = "gateleave") then goto GATE.OF.SOULS.LEAVE
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
# lets room load before turning on triggers for genie
  if matchre("$client", "Genie") then delay 0.25
  var subscript 0
  shift
  math depth subtract 1
  if ((len("%2") > 0) && (%verbose)) then put #echo %color Next move: %2
  action (mapper) on
  goto MOVE.DONE

MOVE.FATIGUE:
  if (%verbose) then gosub echo TOO FATIGUED TO CLIMB!
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
FATIGUE.WAIT:
  if ($stamina > 55) then
    {
    put %movement
    pause %command_pause
    goto MOVE.DONE
    }
  if (%verbose) then gosub echo Pausing to recover stamina
  pause 10
  goto FATIGUE.WAIT

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

MOVE.WAIT:
  action (mapper) off
  shift
  if (%movewait) then waitforre ^You reach|you reach|^Just when it seems|^Finally the bridge comes to an end
  var depth 0
  var movewait 0
  pause %command_pause
  action (mapper) on
  goto MOVE.DONE

MOVE.STAIRS:
  pause %command_pause
  if (%movewait) then
    {
    matchre MOVE.DONE ^You reach|you reach|^Just when it seems|^Finally the bridge comes to an end
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
  matchre MOVE.RETREAT %move_RETRY|^\s*[\[\(]?[rR]oundtime\s*\:?|^You retreat back
  matchre RETURN.CLEAR ^You retreat from combat|^You sneak back out of combat|^You are already as far away as you can get|^You stop
  matchre RETURN.CLEAR ^You begin to get up and \*\*SMACK\!\*\*
  put retreat
  matchwait
# this garbage is here for Outlander inconsistant matchwait bug
  goto MOVE.RETREAT

MOVE.DIVE:
  if ($broom_carpet) then
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
  gosub echo Retry movement
  if (%TryGoInsteadOfClimb) then eval movement replacere("%movement", "climb ", "go ")
  if ($webbed) then
    {
    if (%verbose) then gosub echo WEBBED - pausing
    pause
    if ($webbed) then pause 0.5
    if ($webbed) then waiteval (!$webbed)
    goto MOVE.RETRY
    }
  if ($stunned) then
    {
    if (%verbose) then gosub echo STUNNED - pausing
    pause
    if ($stunned) then pause 0.5
    if ($stunned) then waiteval (!$stunned)
    goto MOVE.RETRY
    }
  if (%waitfor_action) then
    {
    pause 0.001
    put fatigue
    pause 0.001
    }
  delay %infiniteLoopProtection
  pause %command_pause
  pause
  if ($roundtime > 0) then pause $roundtime
  var depth 0
  var movewait 0
  goto MOVE.DONE

MOVE.CLOSED:
  gosub echo SHOP IS CLOSED FOR THE NIGHT!
  put #parse SHOP IS CLOSED
  put #parse SHOP CLOSED
  exit

JAILED:
  gosub echo GOT THROWN IN JAIL!
  put #parse JAILED
  put #parse NAILED AND JAILED!
  put #parse THROWN IN JAIL
  exit

MOVE.FAILED:
  var subscript 0
  evalmath failcounter %failcounter + 1
  if (%failcounter > 3) then
    {
    put #parse MOVE FAILED
    put #parse AUTOMAPPER MOVEMENT FAILED!
    put #flash
    exit
    }
  put #echo %color <~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~>
  put #echo %color <<  MOVE FAILED - Type: %type | Movement: %movement | Depth: %depth
  put #echo %color <<   Remaining Moves: %argcount
  put #echo %color <~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~>
  pause
  gosub echo RETRYING Movement...%failcounter / 3 Tries.

RETURN.CLEAR:
  action (mapper) on
  var depth 0
  goto MAIN.LOOP.CLEAR

#### The various types of walking actions
CARAVAN:
  waitforre ^Your .*, following you\.
  goto MAIN.LOOP.CLEAR

MAPWALK:
  var typeahead.max 0
  var success ^The map has a large 'X' marked in the middle of it
  var action study my map
  goto ACTION.WALK

POWERWALK:
  if (($Attunement.LearningRate > 33) || ($Attunement.Ranks >= 1750)) then {
    put #var powerwalk 0
    var typeahead.max $automapper.typeahead
    return
    }
  var typeahead.max 0
  var success ^\s*[\[\(]?[rR]oundtime\s*\:?|^Something in the area is interfering|^You are a bit too busy performing
  var action perceive
  goto ACTION.WALK

SIGILWALK:
  if ((($Scholarship.LearningRate > 33) || ($Scholarship.Ranks >= 1750)) && (($Arcana.LearningRate > 33) || ($Arcana.Ranks >= 1750)) && (($Outdoorsmanship.LearningRate > 33) || ($Outdoorsmanship.Ranks >= 1750))) then {
    put #var automapper.sigilwalk 0
    var typeahead.max $automapper.typeahead
    return
    }
  var typeahead.max 0
  var action_retry ^Roundtime: \d+ sec\.
  var success (?:antipode|ascension|clarification|decay|evolution|integration|metamorphosis|nurture|paradox|unity) sigil(?: has revealed itself| before you)?\.$|^Having recently been searched,|^You recall having already identified|^Something in the area is interfering|^You are too distracted
  var action perceive sigil
  gosub ACTION.MAPPER.ON
  var action_retry ^0$
  goto MAIN.LOOP.CLEAR

SEARCHWALK:
  var typeahead.max 0
  var success ^You search around|^After a careful search|^You notice|^\s*[\[\(]?[rR]oundtime\s*\:?|^You push through bushes|^You scan|^There seems to be|^You walk around the perimeter|^Just under the Bridge
  var action search
  goto ACTION.WALK

USERWALK:
  #requested by djordje - 2022-12-06
  #So I could set up a script to use automapper and have it step into a room, script does its thing then parses the trigger for automapper to take the next step, kinda like the powerwalk/wait for caravan stuff but customizable
  var typeahead.max 0
  if def(automapper.UserWalkRetry) then var action_retry $automapper.UserWalkRetry
  var success $automapper.UserWalkSuccess
  var action $automapper.UserWalkAction
  gosub ACTION.MAPPER.ON
  var action_retry ^0$
  goto MAIN.LOOP.CLEAR

MOVE.DONE:
  if (!$standing) then gosub STAND
  if ((%cloak_off) && matchre("$lefthand $righthand", "%cloaknouns")) then gosub WEAR.CLOAK
  if ($caravan) then goto CARAVAN
  if ($mapwalk) then goto MAPWALK
  if ($powerwalk) then goto POWERWALK
  if ($automapper.sigilwalk) then goto SIGILWALK
  if ($searchwalk) then goto SEARCHWALK
  if ($automapper.userwalk) then goto USERWALK
  gosub clear
  goto MAIN.LOOP

RETURN:
  if (!$standing) then gosub STAND
  if ($caravan) then goto CARAVAN
  if ($mapwalk) then goto MAPWALK
  if ($powerwalk) then goto POWERWALK
  if ($automapper.sigilwalk) then goto SIGILWALK
  if ($searchwalk) then goto SEARCHWALK
  if ($automapper.userwalk) then goto USERWALK
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

#conflicting code for gear gate bypass
#MOVE.TORCH:
#  action (mapper) goto MOVE.TORCH when You push up on the (stone basin|torch), and the stone wall closes\.
#  action (mapper) off
#  pause %command_pause
#  if (%verbose) then gosub echo RESETTING STONE WALL
#  pause %command_pause
#  if ($roomid = 264) then put turn torch on wall
#  if ($roomid = 263) then put turn basin on wall
#  action (mapper) on
#  pause %command_pause
#  put go wall
#  goto MOVE.DONE

GATE.OF.SOULS:
  action (souls) on
  action (souls) var pushing 0 when ^You stop pushing\.
  action (souls) var boulder 0 when ^The ground trembles slightly, causing a massive granite boulder to rock back and forth
  action (souls) var boulder 1 when ^At the bottom of the hollow, a low tunnel is revealed\!
  action (souls) var pushing 1 when ^You lean against the boulder|^You're already pushing 
  var boulder 0
  var pushing 0
GATE.OF.SOULS.1:
  pause 0.001
  if (!$standing) then gosub STAND
  if matchre("$roomobjs", "low tunnel") then goto GATE.OF.SOULS.GO
  if (%boulder = 1) then goto GATE.OF.SOULS.GO
  if (%pushing = 0) then
    {
     gosub RETREAT
     put push boulder
     pause 0.7
    }
  goto GATE.OF.SOULS.1
GATE.OF.SOULS.GO:
  gosub RETREAT
  if ($standing) then send lie
  pause 0.001
  matchre GATE.OF.SOULS.1 ^What were you
  matchre GATE.OF.SOULS.GO ^Sorry|^You are engaged|^It's a pretty tight fit
  matchre GATE.OF.SOULS.WAIT ^Wriggling on your stomach, you crawl into a low tunnel
  put go tunnel
  matchwait 5
  goto GATE.OF.SOULS.1
GATE.OF.SOULS.WAIT:
  matchre GATE.OF.SOULS.DONE Coarse black grit blows in swirling eddies|^After a seemingly interminable length of time
  matchwait
GATE.OF.SOULS.DONE:
  if (!$standing) then gosub STAND
  pause %command_pause
  action (souls) off
  goto MOVE.SCRIPT.DONE
  
GATE.OF.SOULS.LEAVE:
  if ($standing) then send lie
  pause 0.001
  pause 0.001
  matchre GATE.OF.SOULS.LEAVE.DONE ^Rising in a snubbed tower|^After a seemingly interminable length of time
  put go tunnel
  matchwait 75
  goto GATE.OF.SOULS.LEAVE
GATE.OF.SOULS.LEAVE.DONE:
  if (!$standing) then gosub STAND
  pause %command_pause
  action (souls) off
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
  if (%verbose) then gosub echo PAUSING FOR STUN
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
  put peer path
  waitforre ^Peering closely at a faint path, you realize you would need to head (\w+)\.
  var Dir $1
  put down
  waitforre %move_OK
  put %Dir
  waitforre %move_OK
  if matchre("$roomexits", "\b(?:northwest)\b") then put nw
  else put n
  waitforre %move_OK
  goto MOVE.SCRIPT.DONE

SANDSPIT.TAVERN:
  action (sandspit) on
  action (sandspit) var barrel 0 when ^You duck quietly into an old barrel.
  action (sandspit) var barrel 1 when ^You can't do that.
  var action go barrel
  var success ^You can't|^You duck
  gosub ACTION
  if (%barrel) then
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
  if (%steeldoor) then
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
  if (%verbose) then gosub echo Checking for ice skates!
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
    if (%verbose) then gosub echo ERROR: Unknown noun for your footwear!
    goto SKATE.NO
    }
  if (%verbose) then gosub echo Ice skates found!
  if ((!%footwear) && ("%skate.container" = "held")) then goto WEAR.SKATES
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
  var success ^You get|^You fade in for a moment as you get
  gosub ACTION

WEAR.SKATES:
  var action wear my skates
  var success ^You slide your ice skates on your feet and tightly tie the laces|^You (are already|aren't|attach|can't|carefully|climb|deftly|detach|drape|fade|fall|get|hang|kneel|lie|loosen|need|place|pull|put|quickly|remove|rise|set|shift|silently|sit|slide|sling|slip|stand|step|strap|take|tie|toss|untie|work|wrap|yank)
  goto ACTION

REMOVE.SKATES:
  if (%verbose) then gosub echo Removing ice skates!
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
  if (%verbose) then gosub echo Putting your %footwear back on!
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
  action (cloak) var cloak_worn 2 when ^You attempt to turn|^You adjust the fit
  var cloakloop 0
  var cloak_worn 0

TAP.CLOAK:
  eval cloak_noun element ("%cloaknouns", "%cloakloop")
  if (!%cloak_noun) then return
  var action tap my %cloak_noun
  var success ^You tap|^I could not find
  gosub ACTION
  math cloakloop add 1
  if (!%cloak_worn) then goto TAP.CLOAK

LOWER.CLOAK:
  var action_retry ^You pull your %cloak_noun
  var action turn my %cloak_noun
  var success ^You (adjust the fit|attempt to turn|pull down your|wind|unwind)
  gosub ACTION
  var action_retry ^0$
  if (%cloak_worn = 2) then goto REMOVE.CLOAK
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
  var success ^You (are already|attach|can't|carefully|climb|deftly|drape|fade|fall|get|hang|kneel|lie|loosen|place|pull|put|quickly|rise|set|shift|silently|sit|slide|sling|slip|stand|step|strap|take|tie|toss|untie|wear|work|wrap|yank)
  gosub ACTION
  var cloak_off 0
  return

LOOK.PORTAL:
  var action look in my watery portal
  var success ^In the.*you see|^I could not find
  gosub ACTION
  return

STOW.FOOT.ITEM:
  gosub STOW.FEET
  gosub STOW.HANDS
  goto ABSOLUTE.TOP

STOW.FEET:
  var action stow feet
  eval footitem replacere("%footitem", "([\w'-]+\s){0,5}", "")
  if matchre("%footitem", "(mat|rug|cloth|tapestry)") then var action roll %footitem
  var success ^You pick up .* lying at your feet|^You carefully gather up the delicate folds|^You start at one end of your|^Stow what\?
  gosub ACTION
## THIS LINE WAS ADDED TO FIX A RARE CONDITION WHERE THE FOOTITEM IS A "CLOTH/RUG" BUT ~CANNOT~ BE ROLLED THUS GOES INTO AN INFINITE LOOP OF FAILING TO ROLL
## It should not really effect a normal stow feet other than firing "stow feet" twice which is inconsequential 
  send stow feet
  pause 0.4
  return

STOW.HANDS:
  if !matchre("Empty", "$lefthand") then gosub STOW.LEFT
  if !matchre("Empty", "$righthand") then gosub STOW.RIGHT
  if (!matchre("Empty", "$lefthand") || !matchre("Empty", "$righthand")) then gosub STOW.ALT
  return

STOW.LEFT:
  var action stow my $lefthandnoun
  var success ^You put|^Stow what\?
  gosub ACTION
  return

STOW.RIGHT:
  var action stow my $righthandnoun
  var success ^You put|^Stow what\?
  gosub ACTION
  return

### BACKUP STOW METHOD IF REGULAR "STOW" FAILS 
### Will check for other worn containers and attempt stowing item in alternate containers 
STOW.ALT:
  var StowLoop 0
  gosub BAG.CHECK
  STOW.ALT.1:
  delay %infiniteLoopProtection
  math StowLoop add 1
  if (matchre("Empty", "$lefthand") && matchre("Empty", "$righthand")) then return
  if (%StowLoop > 3) then
    {
    gosub echo STOW ERROR - CANNOT FIND A PLACE TO STORE %item
    return
    }
  if !matchre("Empty", "$righthand") then var item $righthandnoun
  if !matchre("Empty", "$lefthand") then var item $lefthandnoun
  if !matchre("%MAIN.BAG", "NULL") then
    {
    var action put my %item in my %MAIN.BAG
    var success ^You (put|slip)|^What were you|^Stow what\?
    gosub ACTION
    }
  if (matchre("Empty", "$lefthand") && matchre("Empty", "$righthand")) then return
  if !matchre("%BACKUP.BAG", "NULL") then
    {
    var action put my %item in my %BACKUP.BAG
    var success ^You (put|slip)|^What were you|^Stow what\?
    gosub ACTION
    }
  if (matchre("Empty", "$lefthand") && matchre("Empty", "$righthand")) then return
  if !matchre("%THIRD.BAG", "NULL") then
    {
    var action put my %item in my %THIRD.BAG
    var success ^You (put|slip)|^What were you|^Stow what\?
    gosub ACTION
    }
  if (matchre("Empty", "$lefthand") && matchre("Empty", "$righthand")) then return
  if !matchre("%FOURTH.BAG", "NULL") then
    {
    var action put my %item in my %FOURTH.BAG
    var success ^You (put|slip)|^What were you|^Stow what\?
    gosub ACTION
    }
  goto STOW.ALT.1

# Standalone Retreat
RETREAT:
  action (mapper) off
  if (!$standing) then gosub STAND
  if ($hidden) then gosub UNHIDE
  pause %command_pause
  matchre RETREAT %move_RETRY|^\s*[\[\(]?[rR]oundtime\s*\:?|^You retreat back
  matchre RETURN ^You retreat from combat|^You sneak back out of combat|^You are already as far away as you can get|^You stop
  put retreat
  matchwait 3
  return

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
  var success ^\s*[\[\(]?[rR]oundtime\s*\:?|^You unload
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
  #matchre ACTION_WAIT ^\s*[\[\(]?[rR]oundtime\s*\:?
  # depending on the action, this could be a retry or a success...
  action (mapper) off
  var actionloop 0

ACTION.MAPPER.ON:
  if ($automapper.sigilwalk) then {
    if ((($Scholarship.LearningRate > 33) || ($Scholarship.Ranks >= 1750)) && (($Arcana.LearningRate > 33) || ($Arcana.Ranks >= 1750)) && (($Outdoorsmanship.LearningRate > 33) || ($Outdoorsmanship.Ranks >= 1750))) then {
      put #var automapper.sigilwalk 0
      var typeahead.max $automapper.typeahead
      goto ACTION.RETURN
      }
  }
  math actionloop add 1
  pause %command_pause
  matchre ACTION ^\.\.\.wait|^Sorry,|^Please wait\.|^The weight of all your possessions|^You are overburdened and cannot|^You are so unbalanced|%action_retry
  matchre TAP.CLOAK ^Something else is already hiding your features
  matchre ACTION.RETURN %success
  matchre ACTION.STOW.HANDS ^You must have at least one hand free to do that|^You need a free hand
  matchre ACTION.WAIT ^You're unconscious|^You are still stunned|^You can't do that while|^You don't seem to be able to
  matchre ACTION.FAIL ^(That's|The .*) too (heavy|thick|long|wide)|^There's no room|^Weirdly\,|^As you attempt|^That doesn't belong in there\!
  matchre ACTION.FAIL ^There isn't any more room|^You just can't get the .+ to fit|^Where are you|^What were you|^You can't
  matchre ACTION.STOW.UNLOAD ^You should unload
  put %action
  matchwait 2
  if (%actionloop > 2) then goto ACTION.FAIL
  if (%waitfor_action) then goto ACTION.MAPPER.ON
  else goto ACTION.RETURN

ACTION.FAIL:
  gosub echo Unable to perform action: %action

ACTION.RETURN:
  if ($roundtime > 0) then pause %command_pause
  if (%subscript) then return
  action (mapper) on
  return

echo:
  var echoVar $0
  eval border replacere("%echoVar", ".", "~")
  put #echo %color <~~~%border~~~>
  put #echo %color <<  %echoVar  >>
  put #echo %color <~~~%border~~~>
  return
  
#### THIS AUTO SETS MAIN.BAG / BACKUP.BAG / THIRD.BAG VARIABLES
#### FOR STOWING ROUTINE ONLY - BACKUP CONTAINERS IN CASE DEFAULT "STOW" FAILS - THIS WILL CATCH ANY COMMON LARGE CONTAINERS
#### ~ THIS SHOULD ONLY FIRE IF THE MOVE.STOW ROUTINE TRIGGERS AND DEFAULT STOW DOES NOT FULLY CLEAR HANDS ~
#### THIS WAS MADE AS HAPPY MEDIUM - IS MUCH BETTER THAN USING HARDCODED VARIABLES 
#### SETTING THE CONTAINERS AUTOMATICALLY MAKES IT EASY WITHOUT HAVING TO WORRY ABOUT USER VARIABLES / MULTI-CHARACTERS ETC..
#### THIS SHOULD CATCH THE ~MAIN~ BAGS MOST PEOPLE HAVE AT LEAST ONE OR TWO OF
BAG.CHECK:
  var MAIN.BAG NULL
  var BACKUP.BAG NULL
  var THIRD.BAG NULL
  var FOURTH.BAG NULL
  var Backpack 0
  var Haversack 0
  var Pack 0
  var Carryall 0
  var Rucksack 0
  var DuffelBag 0
  var Vortex 0
  var Eddy 0
  var Shadows 0
  var HipPouch 0
  var ToolBelt 0
  var cloak_worn 0
  action var ToolBelt 1 when archeologist's toolbelt
  action var Hip.Pouch 1 when light spidersilk hip pouch
  action var Backpack 1 when backpack
  action var Haversack 1 when haversack
  action var Pack 1 when \bpack
  action var Carryall 1 when carryall
  action var Rucksack 1 when rucksack
  action var Duffel.Bag 1 when duffel bag
  action var Vortex 1 when (hollow vortex of water|corrupted vortex of swirling)
  action var Eddy 1 when swirling eddy of incandescent
  action var Shadows 1 when encompassing shadows
  action var Brambles 1 when dense entangling brambles
  delay %infiniteLoopProtection
  gosub echo Checking Containers...
  matchre BAG.PARSE INVENTORY
  put inv container
  matchwait 3
BAG.PARSE:
  var Bags Toolbelt|Hip.Pouch|Backpack|Haversack|Pack|Carryall|Rucksack|Duffel.Bag|Vortex|Eddy|Shadows|Brambles
  eval TotalBags count("%Bags", "|")
  var BagLoop 0
  delay %infiniteLoopProtection
BAG.LOOP:
  delay %infiniteLoopProtection
  var BAG %Bags[%BagLoop]
  if (%BagLoop > %TotalBags) then
    {
    put #echo %color <~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
    put #echo %color <<  Auto-setting container variables
    put #echo %color <<  Main: %MAIN.BAG
    put #echo %color <<  Backup: %BACKUP.BAG
    put #echo %color <<  Third: %THIRD.BAG
    put #echo %color <<  Fourth: %FOURTH.BAG
    put #echo %color <~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
    return
    }
    if ("%%BAG" = 1) then
      {
      if matchre("%MAIN.BAG", "NULL") then
        {
        var MAIN.BAG %BAG
        goto BAG.NEXT
        }
      if matchre("%BACKUP.BAG", "NULL") then
        {
        var BACKUP.BAG %BAG
        goto BAG.NEXT
        }
      if matchre("%THIRD.BAG", "NULL") then
        {
        var THIRD.BAG %BAG
        goto BAG.NEXT
        }
      if matchre("%FOURTH.BAG", "NULL") then
        {
        var FOURTH.BAG %BAG
        goto BAG.NEXT
        }
      }
BAG.NEXT:
  math BagLoop add 1
  goto BAG.LOOP

#### Handle current pushing you around ####
DRAGGED:
  delay %infiniteLoopProtection
  if ($roundtime > 0) then pause $roundtime
  action (mapper) on
  var depth 0
  goto MOVE.DONE
####
