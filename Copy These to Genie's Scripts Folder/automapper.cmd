# automapper.cmd
var autoversion 9.2024-11-1
# use '.automapper help' from the command line for variables and more
# debug 5 is for outlander; genie debuglevel 10
# debuglevel 10
# debug 5

#2024-10-27
# Hanryu
#   version 9 now
#   mapperINC.cmd is a big enough chang to bump the rev number
#   also removed redundant check on ice road if you have skates
#   guild-circle checks

#2024-10-10
# Hanryu
#   check if you're even in the right room on ggbypass
#   adding messages for "travel rooms" to move_wait

#2024-10-07
# Hanryu
#   recovering lost mistwoodShift changes
#   will delay long enough to shift out `script` if there's a collision in when the actions get processed

#2024-10-03
# Hanryu
#   changed the way search - go works to better handle errors
#   will just _go_ first in case the path is open (faster this way)

#2024-09-29
# Hanryu
#   torch on wall and stone basin for ggbypass

#2024-08-17
# Hanryu
#   there's an intermittent bug with outlander, I'm trying to code around it while Joe works on a fix
#   also Jon helped me get all the LABELS, goto/gosub/matchre LABEL fixed to the correct caps

#2024-08-01
# Hanryu
#   new variable controlled waiteval timeout
#   so you don't get hung up forever waiting for wave to collapse

#2024-6-25
# Shroom
# Robustified Light Source/Dark Room checks

#2023-12-17
# Hanryu
#   no more punching, bob instead to build balance on retreat, if you still fail, graceful abort
#   END: use this for graceful exits that turn on classes
#   standardize parse by always reporting "AUTOMAPPER: message"
#   fixing echos that are not using GOSUB ECHO
#   fixing micropauses, let's not do that shit anymore please
#   robustify MOVE_RT

#2023-12-15
# Hanryu
#   added message anchors for the slow crawl room to access shard west gate favor area

#2024-04-27
#   Robustified Light Source checks
#
#2024-04-02
# Hanryu
#   added a check for that edge case for those time when someone closes the wall before your slow internet lets the command through

#2023-12-15
# Hanryu
#   added handling to ACTION_MAPPER_ON for running a script in each room
#   essentially removes the fall-thru matchwait timeout if $automapper.UserWalkAction contains a . or a #

#2023-12-3
# Shroom - Fixed bug in Bag Check

#2023-10-6
# Shroom
# Removed RETURN: label and changed usage for it to Move.Done
# Fixed bug in Dark Room Checks / Light Usage

#2023-09-10
# Shroom
#   added missing match for Moving while invisible
#   robustified dropping INVIS logic

#2023-07-25
# Hanryu
#   added variable automapper.seekhealing, will stop at vela'thor plants and fully heal

#2023-07-03
# Hanryu
#   added match for entering shard at night with a warrant

#2023-06-17
# Jon
#   changed confirmation wait variable to typeahead 0

#2023-04-15
# Hanryu
#   goal was to address hangups on map 123; nextroom was used in ice rooms
#   Swapped "nextroom" for depth decay because of a genie inconsistancy that Jon found
#   "checked" var to "skatechecked" for clarity
#    finding instances of negated vars that might not be booleans and changing them

#2023-04-11
# Hanryu
#   change to mistwood forest handling, if you end up in room 9 will move you to room 8 since that's where mapper wants to put you

#2023-03-12
# Shroom
# Added preliminary LIGHT SOURCE / DARKVISION checks - when in Dark Room should auto check for and try to activate a light source
# MUCH testing was done to make sure it activates & properly continues on the path - but rarely stalls after activating (can't figure out how)
# UNCommented Parses after 3 Move Fails (some scripts rely on that to restart Automapper)
# Added new SUBSCRIPT for escaping from Oshu Manor Embalming Chamber Automatically
# Fixed Subscript going into Misenseor Abbey

#2023-03-06
# Nazaruss
#   Added cyclic variable to toggle turning off cyclics before moving

#2023-02-24
# Hanryu
#   working to address Shard gate error messages that go to the whole rooom
#   adding $citizenship global based on title affiliation list

#2023-02-19
# Shroom
#   Added better logic for Handling the Theren Keep tunnels
#   Added SUBSCRIPT for getting in and out of Dragon's Spine ( Fixed clunky ass movements )
#   Added Thires Broom mechanic for traversing Ice road
#   Fixed clunky climb movement on creeper to/from Beisswurms
#   Added more matches for MOVE_WAIT which was causing hangups in some instances

#2023-02-18
# Shroom
#   Fixed a bug with STOW_FEET not properly rolling prayer mats causing it to go in infinite loop

#2023-02-03
# Hanryu
#   A better way to retry
#   swap out . for " for Outlander crap in action/match

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
#   Fixed MOVE_RETRY issue that could cause infinite hang if starting in RT
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
#   changed send to put in MOVE_TORCH
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
#   Jon's got a new MOVE_RT for us and I like it

#2022-11-30
# Hanryu
#   separated out MOVE_WAIT:

#2022-11-16
# Hanryu
#   dealing with an outlander bug where 2 "when"s in an action line mess it up
#   searching xala path
#   >= 1750 for exp checks, yea I am undoing something I messed up

#2022-11-04
# Shroom
# - Added additional FAIL catches to ACTION sub
# - Added a hard STOW FEET at end of STOW_FEET sub
# - To fix a endless loop in rare cases where false positives on a "cloth/rug" at feet that CANNOT be rolled
# - Should not really effect anything in normal stow feet logic other than firing the command twice
#
#2022-11-03
# Hanryu
#   issue with shard a night... yet again! New subscript
#   fall-thru message for PP walk if you're playing zills
#   added a timeout to MOVE_RT waiteval depth drops based on VTCifer's code

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
# NEW - Added a STOW_ALT module as a backup to regular STOWING
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
# working on afordances for different system speeds on RT generating moves (MOVE_RT label)
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
# fixed a run condition between being inviso at the shard gate (STOP_INVIS) and (MOVE_INVIS)

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
# Removed unused MOVE_POWER routine.
# Removed unused MOVE_PAUSE routine and action.
# Adjusted tab spacing throughout the whole script.
# Set all labels to caps for half-blind people like me to tell them apart. Also added spacing between labels.
# Compressed single-line code blocks { } where it seemed safe to do so.
# Made MOVE_RETRY_GO's stunned check return to MOVE_RETRY_GO instead of MOVE_RETRY
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

include mapperINC
# checks for outlander v. genie, outlander does not suppor the `mono` flag
if matchre("$client", "Genie") then var helpecho #33CC99 mono
if matchre("$client", "Outlander") then var helpecho #33CC99
if matchre("%1", "help|HELP|Help|^$") then {
  put #echo %helpecho <~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~>
  put #echo %helpecho {  Welcome to automapper Setup!   (version %autoversion)           }
  put #echo %helpecho {  Use the command line to set the following preferences:          }
  put #echo %helpecho {    Typeahead                                                     }
  put #echo %helpecho {      Standard Account = 1, Premium Account = 2, LTB Premium = 3  }
  put #echo %helpecho {      0: wait for correct confirmation of sent commands           }
  put #echo %helpecho {      #var automapper.typeahead 1                                 }
  put #echo %helpecho {    Pause                                                         }
  put #echo %helpecho {      Time to pause before sending a "put x" command              }
  put #echo %helpecho {      #var automapper.pause 0.01                                  }
  put #echo %helpecho {    Infinite Loop Protection                                      }
  put #echo %helpecho {      Increase if you get infinite loop errors                     }
  put #echo %helpecho {      #var automapper.loop 0.001                                  }
  put #echo %helpecho {    Waiteval Time Out                                             }
  put #echo %helpecho {      prevents waiting forever for wave to collapse               }
  put #echo %helpecho {      #var automapper.wavetimeout 15                              }
  put #echo %helpecho {    Echoes                                                        }
  put #echo %helpecho {      how verbose do you want automapper to be?                   }
  put #echo %helpecho {      #var automapper.verbose 1                                   }
  put #echo %helpecho {    Ice Road Behavior                                             }
  put #echo %helpecho {      1: collect rocks on the ice road when lacking skates        }
  put #echo %helpecho {      0: just wait 15 seconds with no RT instead                  }
  put #echo %helpecho {      #var automapper.iceroadcollect 1                            }
  put #echo %helpecho {    Cyclic Spells                                                 }
  put #echo %helpecho {      1: Turn off cyclic spells before moving                     }
  put #echo %helpecho {      0: Leave cyclic spells running while moving                 }
  put #echo %helpecho {      #var automapper.cyclic 1                                    }
  put #echo %helpecho {    Color                                                         }
  put #echo %helpecho {      What should the default automapper echo color be?           }
  put #echo %helpecho {      #var automapper.color #33CC99                               }
  put #echo %helpecho {    Class                                                         }
  put #echo %helpecho {      Which classes should automapper turn on and off?            }
  put #echo %helpecho {      #var automapper.class -arrive -combat -joust -racial -rp    }
  put #echo %helpecho {    Brooms, Carpets, and Clouds, OH MY!                           }
  put #echo %helpecho {      Do you have a special movement item you want to use?        }
  put #echo %helpecho {      #var automapper.broom_carpet                                }
  put #echo %helpecho {    Cyclic handling                                               }
  put #echo %helpecho {      Release cyclics so you don't get arrseted?                  }
  put #echo %helpecho {      #var automapper.ReleaseCyclics True                         }
  put #echo %helpecho {  Now save! (#save vars for Genie | cmd-s for Outlander)          }
  put #echo %helpecho {                                                                  }
  put #echo %helpecho {  try `.automapper walk` for help with the various walk types     }
  put #echo %helpecho <~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~>
  exit
}
if matchre("%1", "^walk$") then {
  put #echo %helpecho <~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~>
  put #echo %helpecho {  Welcome to automapper walk help!                          }
  put #echo %helpecho {    Caravan Walking                                         }
  put #echo %helpecho {      wait for your caravan                                 }
  put #echo %helpecho {      #var caravan 0/1                                      }
  put #echo %helpecho {    Drag                                                    }
  put #echo %helpecho {      drag a target around                                  }
  put #echo %helpecho {      #var drag 0/1                                         }
  put #echo %helpecho {      #var drag.target name/item                            }
  put #echo %helpecho {    Map Walking                                             }
  put #echo %helpecho {      study a map for treasure                              }
  put #echo %helpecho {      #var mapwalk 0/1                                      }
  put #echo %helpecho {    Power Walking                                           }
  put #echo %helpecho {      percieve the mana until locked                        }
  put #echo %helpecho {      #var powerwalk 0/1                                    }
  put #echo %helpecho {    Sigil Walking                                           }
  put #echo %helpecho {      find both sigils in each room                         }
  put #echo %helpecho {      trains: Scholarship, Arcana, Outdoorsmanship          }
  put #echo %helpecho {      #var automapper.sigilwalk 0/1                         }
  put #echo %helpecho {    Search Walking                                          }
  put #echo %helpecho {      search in every room                                  }
  put #echo %helpecho {      #var searchwalk 0/1                                   }
  put #echo %helpecho {    USER Walking                                            }
  put #echo %helpecho {      this can do whatever you'd like!                      }
  put #echo %helpecho {        you MUST define globals automapper.UserWalkAction   }
  put #echo %helpecho {        you MUST define globals automapper.UserWalkSuccess  }
  put #echo %helpecho {        you MAY define globals automapper.UserWalkRetry     }
  put #echo %helpecho {      #var automapper.userwalk 0/1                          }
  put #echo %helpecho {    Stop and heal at vela'thor plants                       }
  put #echo %helpecho {      #var automapper.seekhealing 1                         }
  put #echo %helpecho {                                                            }
  put #echo %helpecho {  Please search automapper.cmd for "Related macros"         }
  put #echo %helpecho <~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~>
  exit
}

ABSOLUTE_TOP:
# ---------------
#USER VARS:
# Type ahead declaration
# The following will use a global to set it by character.  This helps when you have both premium and standard accounts.
# Standard Account = 1, Premium Account = 2, LTB Premium = 3
# 0: wait for correct confirmation of sent commands
# automapper.typeahead FIX - Some users had a rogue variable set for automapper.typeahead
# This sets automapper.typeahead to 1 if the variable is NOT present at all
# This will auto reset it back to 1 IF the automapper.typeahead is ~NOT~ set to a number
  if ((!def(automapper.typeahead)) || (!matchre("$automapper.typeahead", "^\d$"))) then put #var automapper.typeahead 1
  var typeahead.max $automapper.typeahead
  # Time to pause before sending a "put x" command
  if !def(automapper.pause) then var command_pause 0.01
  else var command_pause $automapper.pause
# echo next move? 1 = YES, 0 = NO
  if !def(automapper.verbose) then var verbose 1
  else var verbose $automapper.verbose
# what color do you want for echos?
  if !def(automapper.color) then var color #33CC99
  else var color $automapper.color
  if matchre("$client", "Genie") then var color %color mono
# Decrease at your own risk, increase if you get infinite loop errors
#default is 0.1 for Outlander, 0.001 for Genie
  var infiniteLoopProtection 0.1
  if def(client) then {
    if matchre("$client", "Genie|None") then var infiniteLoopProtection 0.001
    if matchre("$client", "Outlander") then var infiniteLoopProtection 0.1
  }
  if def(automapper.loop) then var infiniteLoopProtection $automapper.loop
  if def(automapper.wavetimeout) then var waitevalTimeOut $automapper.wavetimeout
  else var waitevalTimeOut 300
# 1: collect rocks on the ice road when lacking skates; 0; just wait 15 seconds with no RT instead
  if !def(automapper.iceroadcollect) then var ice_collect 0
  else var ice_collect $automapper.iceroadcollect
  if !def(automapper.cyclic) then var cyclic 0
  else var cyclic $automapper.cyclic
  if !def(broom_carpet) then put #tvar broom_carpet 0
  if !def(caravan) then put #tvar caravan 0
  if !def(drag) then put #tvar drag 0
  if !def(mapwalk) then put #tvar mapwalk 0
  if !def(powerwalk) then put #tvar powerwalk 0
  if !def(automapper.sigilwalk) then put #tvar automapper.sigilwalk 0
  if !def(searchwalk) then put #tvar searchwalk 0
  if !def(automapper.userwalk) then put #tvar automapper.userwalk 0
  if !def(automapper.seekhealing) then put #tvar automapper.seekhealing 0
  if !def(citizenship) then gosub CITIZENSHIP
  if (!def(guild) || !def(circle)) then {
    action (guildcircle) on
    gosub INFO_CHECK
  }
  if !def(subscription) then gosub SUBSCRIPTION_CHECK
  if !def(citizenship) then gosub CITIZENSHIP
# release cyclics if defined
  if (($automapper.ReleaseCyclics) && def($automapper.ReleaseCyclics)) then gosub PUT release cyclic
# turn off classes to speed movment
  if def(automapper.class) then put #class $automapper.class
# ---------------
  if ($mapwalk) then {
    if !matchre("$righthand|$lefthand", "\bmap\b") then gosub GET_MAP
  }
  var skatechecked 0
  var slow_on_ice 0
  var wearing_skates 0
  var skate.container 0
  var footwear 0
  var action_retry ^0$
  var cloak_off 0
  var cloak_worn 0
  var cloaknouns cloak|shroud|scarf|aldamdin mask|0
  var closed 0
  var darkroom 0
  var darkchecked 0
  var startingStam $stamina
  var failcounter 0
  var depth 0
  var movewait 0
  var TryGoInsteadOfClimb 0
  var move_OK ^Obvious (?:paths|exits)|^It's pitch dark|The shop appears to be closed, but you catch the attention of a night attendant inside,|^You move effortlessly through the|^Your? stare into the shadows and see\.\.\.$
  var move_FAIL ^You can't swim in that direction\.$|^You can't go there\.$|^A powerful blast of wind blows you to the|^What were you referring to\?|^I could not find what you were referring to\.|^You can't sneak in that direction|^You can't ride your.+(broom|carpet) in that direction|^You can't ride that way\.$
  var move_RETRY ^\.\.\.wait|^Sorry, |^The weight of all|^You quickly step around the exposed roots, but you lose your balance during the effort|^You are still stunned|^You're still recovering from your recent|^The mud gives way beneath your feet as you attempt to climb higher, sending you sliding back down the slope instead\!|^You're not sure you can
  var move_RETREAT ^You are engaged to|^You try to move, but you're engaged|^While in combat|^You can't do that while engaged|^You can't do that\!  You're in combat\!
  var move_WEB ^You can't do that while entangled in a web|^As you start to move, you find yourself snared
  var move_WAIT ^As you approach the patch of rough dirt, the ground gives way, you lose your balance, and go tumbling wildly down the ravine!$|^You try, but in the cramped confines of the tunnel, there's just no room to do that\.$|^Wriggling on your stomach, you crawl into a low opening\.$|^You continue climbing|^You begin climbing|^You really should concentrate on your journey|^You step onto a massive stairway|^You step onto some stairs, beginning your ascent\.$|^You start the slow journey across the bridge\.$|^Wriggling on your stomach, you crawl into a low opening\.$|^After climbing up the rope ladder for several long moments|^You scamper up and over the rock face\.$
  var move_END_DELAY ^You reach|you reach\.\.\.$|^Finally the bridge comes to an end|^After a seemingly interminible length of time, you crawl out of the passage into
  var move_STAND ^You must be standing to do that|^You can't do that while (lying down|kneeling|sitting)|You try to quickly step from root to root, but slip and drop to your knees|you trip over an exposed root|^Stand up first\.|^You must stand first\.|^You'll need to stand up|^A few exposed roots wrench free from the ground after catching on your feet as you pass, a particularly sturdy one finally brings you to your knees\.$|You try to roll through the fall but end up on your back\.$|^Perhaps you might accomplish that if you were standing\.$|^You can't do that while lying down\.$
  var move_NO_SNEAK ^You can't do that here|^In which direction are you trying to sneak|^Sneaking is an inherently stealthy|^You can't sneak that way|^You can't sneak in that direction
  var move_GO ^Please rephrase that command
  var move_MUCK ^You fall into the .+ with a loud \*SPLUT\*|^You slip in .+ and fall flat on your back\!|^The .+ holds you tightly, preventing you from making much headway\.|^You make no progress in the mud|^You struggle forward, managing a few steps before ultimately falling short of your goal\.|^You find yourself stuck in the mud
  var climb_FAIL ^Trying to judge the climb, you peer over the edge\.  A wave of dizziness hits you, and you back away from .+\.|^You start down .+, but you find it hard going\.  Rather than risking a fall, you make your way back up\.|^You attempt to climb down .+, but you can't seem to find purchase\.|^You pick your way up .+, but reach a point where your footing is questionable\.  Reluctantly, you climb back down\.|^You make your way up .+\.  Partway up, you make the mistake of looking down\.  Struck by vertigo, you cling to .+ for a few moments, then slowly climb back down\.|^You approach .+, but the steepness is intimidating\.|^The ground approaches you at an alarming rate|^You start up .+, but slip after a few feet and fall to the ground\!  You are unharmed but feel foolish\.|^You almost make it to the top|^You start the climb and slip|^You start to climb .+, but then stop to reconsider\.
  var move_CLOSED ^The door is locked up tightly for the night|^You stop as you realize that the|^(?:\w+ )+I'm sorry, but you need to be a citizen|^BONK\! You smash your nose|^Bonk\! You smash your nose|^(?:\w+ )+I'm sorry, I can only allow citizens in at night|^(?:\w+ )+shop is closed for the night|^A guard appears and says, .I'm sorry,|The shop appears to be closed, but you catch the attention of a night attendant inside, and he says, .I'm sorry, I can only allow citizens in at night\..?
  var swim_FAIL ^You struggle (?!to maintain)|^You work(?! your way (?:up|down) the cliff)|^You slap|^You flounder
  var move_DRAWBRIDGE ^The guard yells, .Lower the bridge|^The guard says, .You'll have to wait|^A guard yells, .Hey|^The guard yells, .Hey
  var move_ROPE_BRIDGE is already on the rope\.|You'll have to wait
  var move_STOW ^You need to empty your hands|^You should empty your hands first\!|^You can't possibly manage to cross|^You'll need to free up your hands|^Not while carrying something in your hands|^You must first free up your hands\.|^The going gets quite difficult and highlights the need to free up your hands|^You must have your hands free
  var move_FATIGUE ^You're too tired to try climbing|^You need to rest
  var move_BOAT ^The galley has just left|^You look around in vain for the galley
  var move_INVIS ^The .* can't see you\!|^But no one can see you\!|^How can you .* can't even see you\?|^You can't move in that direction while unseen\.
  var climb_mount_FAIL climb what?
ACTIONS:
  action (mapper) action (mapper) off;goto DRAGGED when ^The current drags you
  action (mapper) if (%movewait == 0) then shift;if (%movewait == 0) then math depth subtract 1;if ((%verbose) && (len("%2") > 0)) then put #echo %color Next move: %2 when %move_OK
  action (mapper) goto MOVE_FAILED when %move_FAIL
  action (mapper) var TryGoInsteadOfClimb 1 when ^You can't climb that\.$
  action (mapper) goto MOVE_RETRY when %move_RETRY|%move_WEB|^You can't climb that\.$
  action (mapper) goto MOVE_STAND when %move_STAND
  action (mapper) var movewait 1;goto MOVE_WAIT when %move_WAIT
  action (mapper) var retreat.count 0;goto MOVE_RETREAT when %move_RETREAT
  action (mapper) var movewait 0 when %move_END_DELAY
  action (mapper) var closed 1;goto MOVE_CLOSED when %move_CLOSED
  action (mapper) goto MOVE_NOSNEAK when %move_NO_SNEAK
  action (mapper) goto MOVE_GO when %move_GO
  action (mapper) goto MOVE_INVIS when %move_INVIS
  action (mapper) goto MOVE_MUCK when %move_MUCK
  action (mapper) goto MOVE_STOW when %move_STOW
  action (mapper) goto MOVE_BOAT when %move_BOAT
  action (mapper) put #echo %color Will re-attempt climb in 5 seconds...;send 5 $lastcommand when ^All this climbing back and forth is getting a bit tiresome\.  You need to rest a bit before you continue\.$
  action (mapper) goto MOVE_RETRY when %swim_FAIL
  action (mapper) goto MOVE_DRAWBRIDGE when %move_DRAWBRIDGE
  action (mapper) goto MOVE_KNOCK when The gate is closed\.  Try KNOCKing instead
  action (mapper) goto MOVE_ROPE_BRIDGE when %move_ROPE_BRIDGE
  action (mapper) goto MOVE_FATIGUE when %move_FATIGUE
  action (mapper) goto MOVE_CLIMB_MOUNT_FAIL when %climb_mount_FAIL
  action (mapper) goto MOVE_KNEEL when maybe if you knelt down first\?
  action (mapper) goto MOVE_LIE when ^The passage is too small to walk that way\.  You'll have to get down and crawl\.|^There's just barely enough room here to squeeze through, and no more|^You look down at the low opening, furrowing your brow dubiously
  action (mapper) var footitem $1;goto STOW_FOOT_ITEM when ^You notice (?:an |a )?(.+) at your feet, and do not wish to leave it behind\.
  action (skates) var wearing_skates 1 when ^You slide your ice skates on your feet and tightly tie the laces\.|^Your ice skates help you traverse the frozen terrain\.|^Your movement is hindered .* by your ice skates\.|^You tap some.*\bskates\b.*that you are wearing
  action (skates) var wearing_skates 0 when ^You untie your skates and slip them off of your feet\.
  action (healing) var plant $1;goto HEALING when (vela'tohr (?:briar|bush|plant|shrub|thicket|thornbush))
  action (healing) off
#  if (($automapper.seekhealing == 1) && ($guild != Necromancer)) then action (healing) on
  if ($automapper.seekhealing == 1) then action (healing) on
  action var darkroom 1 when ^It's pitch dark and you can't see a thing\!
  action var slow_on_ice 1;if (%verbose) then put #echo %color Ice detected! when ^You had better slow down\! The ice is|^At the speed you are traveling
  action goto JAILED when ^You slowly wake up again to find that all your belongings have been stripped and you are in a jail cell wearing a set of heavy manacles\.|^The \w+ brings you to the jail, where several companions aid to hold you down and strip you of all your possessions\.|^The town guard, with the help of several others, wrestle you to the ground, bind you in chains, and drag you off to jail\.|^\w+ you awake some time later, your possessions have been stripped from you, and you lay in a musty pile of straw\.|^The door slams shut, a sound not unlike that of a tomb closing\.
  action goto DEAD_DONE when ^You are a ghost\!

# Are you starting the script while in RT?
  if ($roundtime > 0) then pause $roundtime
  if (!$standing) then gosub STAND
MAIN_LOOP_CLEAR:
  gosub clear

#### JON's MAIN LOOP ####
MAIN_LOOP:
  if_1 goto WAVE_DO
  goto DONE
WAVE_DO:
  if (%depth > 0) then {
    delay %infiniteLoopProtection
    if ($roundtime > 0) then pause $roundtime
  }
  evalmath MDepth (%depth + 1)
  if ((%typeahead.max >= %depth) && ("%%MDepth" != "")) then gosub MOVE %%MDepth
  if ((%typeahead.max <= %depth) || ("%%MDepth" == "")) then goto MAIN_LOOP
  else goto WAVE_DO

DONE:
  if (!$standing) then gosub STAND

DEAD_DONE:
  put #parse YOU HAVE ARRIVED!
  put #parse AUTOMAPPER: YOU HAVE ARRIVED!
#use END for graceful exit that turns on classes again
#use this after your parse
END:
  if def(automapper.class) then {
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
      if ("%type" == "real") then
        {
        if matchre("%movement", "^(search|swim|climb|web|muck|rt|wait|slow|drag|script|room|ice|dive) ") then
          {
          var type $1
          eval movement replacere("%movement", "^(search|swim|web|muck|rt|wait|slow|script|room|ice|dive) ", "")
          }
        if matchre("%movement", "^(objsearch) (\S+) (.+)") then
          {
          var type $1
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
  goto MOVE_%type

MOVE_REAL:
  if (%wearing_skates) then gosub REMOVE_SKATES
  if (("$zoneid" == "62") && ("$game" == "DRF")) then {
    if (("$roomid" == "41") && ("%movement" == "southwest")) then {
      pause %command_pause
      move southwest
      move south
      math depth subtract 2
      goto MOVE_DONE
    }
  }
DO_MOVE:
  put %movement
  goto MOVE_DONE

MOVE_ROOM:
  eval depthtimeout $unixtime + %waitevalTimeOut
  if (%depth > 1) then waiteval ((1 <= %depth) || ($unixtime >= %depthtimeout))
  put %movement
  eval depthtimeout $unixtime + %waitevalTimeOut
  if (%depth > 0) then waiteval ((0 == %depth) || ($unixtime >= %depthtimeout))
  goto MOVE_DONE

MOVE_STOW:
  if !matchre("Empty", "$lefthand") then gosub STOW_LEFT
  if !matchre("Empty", "$righthand") then gosub STOW_RIGHT
  if matchre("$righthand", "khuj|staff|atapwi") then put wear $righthandnoun
  if (!matchre("Empty", "$lefthand") || !matchre("Empty", "$righthand")) then gosub STOW_ALT
  pause %command_pause
  put %movement
  pause %command_pause
  goto MOVE_DONE

MOVE_BOAT:
  matchre MOVE_BOAT_ARRIVED ^The galley (\w*) glides into the dock
  matchwait 60
  put look
  goto MOVE_BOAT

MOVE_BOAT_ARRIVED:
  put %movement
  pause %command_pause
  goto MOVE_DONE

MOVE_ICE:
  if (!$broom_carpet) then {
    action (skates) on
    eval depthtimeout $unixtime + %waitevalTimeOut
    if (%depth > 1) then waiteval ((1 <= %depth) || ($unixtime >= %depthtimeout))
    if (!%skatechecked) then gosub FIND_SKATES
    if (%slow_on_ice) then gosub ICE_COLLECT
  }
  put %movement
  goto MOVE_DONE

SKATE_NO:
  var slow_on_ice 1
  var wearing_skates 0
  if (%verbose) then gosub ECHO Could not find ice skates!
  if ((%ice_collect) && (%verbose)) then gosub ECHO Collecting rocks in every room like the other peasants
SKATE_YES:
  return

ICE_COLLECT:
  if (!%ice_collect) then goto ICE_PAUSE
  var action collect rock
  var success ^You manage to collect a pile
  gosub ACTION
  var action kick rock
  var success ^Now what did the|^You take a step back and run up to the pile|^I could not find
  gosub ACTION
  var slow_on_ice 0
  pause %command_pause
  return

ICE_PAUSE:
  action (mapper) off
  pause %command_pause
  if (%verbose) then gosub ECHO Pausing 15 seconds to regain footing on slippery ice.
  pause 15
  var slow_on_ice 0
  pause %command_pause
  action (mapper) on
  return

MOVE_KNOCK:
  action (mapper) off
  if ($roundtime > 0) then pause %command_pause
  eval depthtimeout $unixtime + %waitevalTimeOut
  if (%depth > 1) then waiteval ((1 <= %depth) || ($unixtime >= %depthtimeout))
  if !matchre("$citizenship", "Ilithi|Fayrin's Rest|Shard|Steelclaw Clan|Zaldi Taipa") then goto SHARD_FAILED
  var movement knock gate
  matchre MOVE_KNOCK ^\.\.\.wait|^Sorry,|^You are still stun|^You can't do that while entangled
  matchre KNOCK_DONE %move_OK
  matchre SHARD_FAILED Hey, you're $charactername, a wanted criminal
#  matchre SHARD_FAILED Sorry, you're not a citizen
#^ this message goes to everyone in the room and screws things up
  matchre CLOAK_LOGIC ^You turn away, disappointed\.
#^ this message is the same for non-citizen error as well as feature hidden error, so need to branch at CLOAK_LOGIC
  matchre KNOCK_INVIS ^The gate guard can't see you
  put %movement
  matchwait
#this is here to account for an outlander bug
  goto KNOCK_DONE

SHARD_FAILED:
  if ((%cloak_off) && matchre("$lefthand $righthand", "%cloaknouns")) then gosub WEAR_CLOAK
  if ((!%cloak_off) && (%cloak_worn)) then gosub RAISE_CLOAK
  if !matchre("$zoneid", "(66|67|68|69)") then goto MOVE_FAILED
  matchre KNOCK_DONE YOU HAVE ARRIVED\!
  put .sharddetour
  matchwait 45
  goto MOVE_DONE

KNOCK_INVIS:
  action (mapper) on
  goto MOVE_INVIS

KNOCK_DONE:
  action (mapper) on
  shift
  math depth subtract 1
  goto MOVE_DONE

CLOAK_LOGIC:
  if (((%cloak_off) && matchre("$lefthand $righthand", "%cloaknouns")) || ((!%cloak_off) && (%cloak_worn))) then goto SHARD_FAILED
  gosub FIND_CLOAK
  goto MOVE_KNOCK

MOVE_DRAG:
MOVE_SNEAK:
MOVE_SWIM:
MOVE_RT:
####added this to stop trainer
  eval depthtimeout $unixtime + %waitevalTimeOut
  if (%depth > 1) then waiteval ((1 <= %depth) || ($unixtime >= %depthtimeout))
  matchre MOVE_RT_SUCCESS ^(?:Obvious|Ship) (?:paths|exits):
  put %movement
  matchwait 15
  goto MOVE_RT
MOVE_RT_SUCCESS:
  pause %command_pause
  if ($roundtime > 0) then pause %command_pause
  goto MOVE_DONE

MOVE_WEB:
  if ($webbed) then waiteval (!$webbed)
  pause %command_pause
  put %movement
  pause %command_pause
  goto MOVE_DONE

MOVE_MUCK:
  action (mapper) off
  pause %command_pause
  if (!$standing) then put stand
  matchre MOVE_MUCK ^\.\.\.wait|^Sorry,|^You are still stun|^You can't do that while entangled|^You struggle to dig|^Maybe you can reach better that way, but you'll need to stand up for that to really do you any good\.
  matchre RETURN_CLEAR ^You manage to dig|^You will have to kneel closer|^You stand back up.|^You fruitlessly dig
  put dig
  matchwait

MOVE_SLOW:
  if (%verbose) then gosub ECHO Slow and steady here to avoid mishaps...
  pause 3
  goto MOVE_REAL

MOVE_CLIMB:
  matchre MOVE_CLIMB %move_RETRY
  matchre MOVE_DONE %move_OK
  matchre MOVE_CLIMB_MOUNT_FAIL climb what\?
  matchre MOVE_CLIMB_WITH_ROPE %climb_FAIL
  if ($broom_carpet) then eval movement replacere("%movement", "climb ", "go ")
  put %movement
  matchwait

MOVE_CLIMB_MOUNT_FAIL:
  matchre MOVE_CLIMB_MOUNT_FAIL %move_RETRY
  matchre MOVE_DONE %move_OK
  if ($broom_carpet) then eval movement replacere("%movement", "climb ", "go ")
  put %movement
  matchwait

MOVE_CLIMB_WITH_ROPE:
  action (mapper) off
  if !matchre("$righthand $lefthand", "\brope\b") then gosub PUT get my braided rope
  if !matchre("$righthand $lefthand", "\brope\b") then gosub PUT get my heavy rope
  action (mapper) on
  if (("$guild" == "Thief") && ($concentration > 50) && ($Athletics.Ranks < 600)) then gosub PUT khri flight focus
  if matchre("$righthand $lefthand", "\brope\b") then goto MOVE_CLIMB_WITH_APP_AND_ROPE
  matchre MOVE_CLIMB_WITH_ROPE %move_RETRY
  matchre STOW_ROPE %move_OK
  matchre MOVE_CLIMB_WITH_APP_AND_ROPE %climb_FAIL
  put %movement with my rope
  matchwait

MOVE_CLIMB_WITH_APP_AND_ROPE:
  eval climbobject replacere("%movement", "climb ", "")
  put appraise %climbobject quick
  waitforre ^\s*[\[\(]?Roundtime\s*\:?|^You cannot appraise that when you are in combat
  if (("$guild" == "Thief") && ($concentration > 50) && ($Athletics.Ranks < 600)) then gosub PUT khri flight focus
  matchre MOVE_CLIMB_WITH_APP_AND_ROPE %move_RETRY
  matchre STOW_ROPE %move_OK
  matchre MOVE_CLIMB_WITH_APP_AND_ROPE %climb_FAIL
  put %movement with my rope
  matchwait

STOW_ROPE:
  if matchre("$righthand $lefthand", "\brope\b") then gosub PUT stow my rope
  goto MOVE_DONE

MOVE_SEARCH:
#maybe the path is already open, let's try that first, then waste time searching
  if ($broom_carpet) then eval movement replacere("%movement", "climb ", "go ")
  eval depthtimeout $unixtime + %waitevalTimeOut
  if (%depth > 1) then waiteval ((1 <= %depth) || ($unixtime >= %depthtimeout))
  action (mapper) off
  matchre MOVE_SEARCH2 %move_FAIL
  matchre MOVE_SEARCH_PATHOPEN %move_OK
  put %movement
  matchwait
MOVE_SEARCH_PATHOPEN:
  shift
  math depth subtract 1
  if ((%verbose) && (len("%2") > 0)) then put #echo %color Next move: %2
  action (mapper) on
  goto MOVE_DONE
MOVE_SEARCH2:
# so here's some bullshit, if some paths are already open you "fail" to find them
#>sear
#There seems to be some sort of path leading to the east.
#>sear
#You search around for a moment.
#Roundtime: 2 sec.
#You don't find anything of interest here.
  var action_retry ^You find some interesting signs something is here\.$
  var success ^You (?:find|notice|push|scan|walk) .+? (?:alcove|crevice|door|gap|log|opening|path|spot|tracks|trail|trapdoor|wall)|^After a careful search of the area|^As you search, the air shimmers|^Just under the Bridge of Sparrows|^There seems to be some
  #4-408 After a careful search of the area, you discover a trampled path!
  #4a-11 You find a very faint trail through the grass.
  #7-373 You notice a path hidden in the brush that leads under the stone bridge.
  #7-395 There seems to be some sort of path leading to the east.
  #7-737 You scan the cave's shadows and find a small alcove!
  #7-741 You walk around the perimeter of the cave and discover a hidden alcove!
  #9b-25 I NEVER GOT THIS TO BE HIDDEN.
  #11-1 You find faint traces of an animal trail and a faint path.
  #11-3 You find very faint traces of an animal trail.
  #11-4 You find a faint animal trail.
  #11-5 You find that the faint animal tracks are right where you found them before.|You find some faint animal tracks.|You find a bare spot that leads southeast into the deep wilderness and some faint animal tracks.|You find a bare spot that leads southeast into the deep wilderness and the faint animal tracks are right where you found them before.
  #11-36 You find some animal tracks.|You find that the animal tracks are right where you found them before.
  #11-67 You find a narrow gap.
  #11-68 You find a narrow gap.
  #11-69 You find a narrow crevice.
  #11-70 You find a narrow crevice.
  #11-103 You find a faint trail.|You find that the faint trail is right where you found it before.
  #11-105 You find a faint trail.
  #11-119 You find a faint trail.|You find that the faint trail is right where you found it before.
  #30-391 THIEF WILL HAVE TO FIX THIS ONE.
  #40-136 You push through bushes and around shrubbery and discover a faint forest trail!
  #48-2 I'M NOT BOTHERING TO DO THIS ONE.
  #66-199 You find a dirt path!
  #66-319 As you search, the air shimmers and a dark onyx arch appears!
  #67-29 Just under the Bridge of Sparrows you notice a partially concealed channel bank.
  #69-6 You find a narrow path.
  #90-798 You find an open wall panel between two support beams.
  #92-92 You find a narrow gap.|You find that the narrow gap is right where you found it before.
  #92-201 You find a trapdoor.
  #98-33 You find a dark opening in the fissure.
  #98-167 You find a fallen log.
  #98-313 You find a hidden door.|You find that the hidden door is right where you found it before.
  #106-5 I'M NOT BOTHERING TO DO THIS ONE.
  #108-354 You find some footholds leading up the rock wall.

  var action search
  gosub ACTION_MAPPER_ON
  var action_retry ^0$
  if ($roundtime > 0) then pause %command_pause
  goto DO_MOVE

MOVE_OBJSEARCH:
  put search %searchObj
  pause %command_pause
  if ($roundtime > 0) then pause %command_pause
  if ($broom_carpet) then eval movement replacere("%movement", "climb ", "go ")
  goto DO_MOVE

MOVE_SCRIPT:
  var subscript 1
  eval depthtimeout $unixtime + %waitevalTimeOut
  if (%depth > 1) then waiteval ((1 <= %depth) || ($unixtime >= %depthtimeout))
  action (mapper) off
  if ("%movement" == "abbeyhatch") then goto ABBEY_HATCH
  if ("%movement" == "armoire") then goto ARMOIRE
  if ("%movement" == "autoclimbdown") then goto AUTOCLIMB_DOWN
  if ("%movement" == "autoclimbup") then goto AUTOCLIMB_UP
  if ("%movement" == "automoveenterdobeks") then goto ENTER_DOBEKS
  if ("%movement" == "dragonspine") then goto DRAGONSPINE
  if ("%movement" == "gateleave") then goto GATE_OF_SOULS_LEAVE
  if ("%movement" == "gateofsouls") then goto GATE_OF_SOULS
  if ("%movement" == "ggbypass") then goto GEAR_GATE_BYPASS
  if ("%movement" == "hibintelligence") then goto HIB_INTELLIGENCE
  if ("%movement" == "mistwoodcliff") then goto MISTWOOD_CLIFF
  if ("%movement" == "oshumanor") then goto OSHUMANOR
  if ("%movement" == "sandspit") then goto SANDSPIT_TAVERN
  matchre MOVE_SCRIPT_DONE ^MOVE SUCCESSFUL
  matchre MOVE_FAILED ^MOVE FAILED
  put .%movement
  matchwait

MOVE_SCRIPT_DONE:
# lets room load before turning on triggers for genie
  if matchre("$client", "Genie") then delay 0.25
  var subscript 0
#shift away script if room load trigger got turned off before it loaded
  if matchre("%1", "script") then shift
  var depth 0
  if ((%verbose) && (len("%2") > 0)) then put #echo %color Next move: %2
  action (mapper) on
  goto MOVE_DONE

MOVE_FATIGUE:
  if (%verbose) then gosub ECHO TOO FATIGUED TO CLIMB!
  pause 0.5
  if ("$guild" == "Barbarian") then {
    gosub PUT berserk avalanche
    pause 2
  }
  if ("$guild" == "Bard") then {
    gosub PUT prep hodi 20
    pause 18
    gosub PUT cast
    pause
  }
  if ("$guild" == "Empath") then {
    gosub PUT prep refresh 20
    pause 18
    gosub PUT cast
    pause
  }
  if ("$guild" == "Warrior Mage") then {
    gosub PUT prep zephyr 20
    pause 18
    gosub PUT cast
    pause
  }
  if ("$guild" == "Cleric") then {
    gosub PUT prep EF 20
    pause 18
    gosub PUT cast
    pause
  }
  pause
FATIGUE_WAIT:
  if ($stamina > 55) then {
    pause %command_pause
    put %movement
    goto MOVE_DONE
  }
  if (%verbose) then gosub ECHO Pausing to recover stamina
  pause 10
  goto FATIGUE_WAIT

MOVE_INVIS:
  eval depthtimeout $unixtime + %waitevalTimeOut
  if (%depth > 1) then waiteval ((1 <= %depth) || ($unixtime >= %depthtimeout))
  if ("$guild" == "Necromancer") then {
    gosub PUT release EOTB
    pause %command_pause
  }
  if ("$guild" == "Thief") then {
    gosub PUT khri stop silence vanish
    pause %command_pause
  }
  if ("$guild" == "Ranger") then {
    gosub PUT release BLEND
    pause %command_pause
  }
  if matchre("$guild", "(Moon Mage|Moon)") then {
    gosub PUT release RF
    pause %command_pause
    gosub PUT release SOV
    pause %command_pause
  }
  pause %command_pause
  if ($invisible == 1) then {
    if ($SpellTimer.RefractiveField.active == 1) then gosub PUT release RF
    if ($SpellTimer.StepsofVuan.active == 1) then gosub PUT release SOV
    if ($SpellTimer.EyesoftheBlind.active == 1) then gosub PUT release EOTB
    if ($SpellTimer.Blend.active == 1) then gosub PUT release BLEND
    if ($SpellTimer.KhriSilence.active == 1) then gosub PUT khri stop silence
    if ($SpellTimer.KhriVanish.active == 1) then gosub PUT khri stop vanish
    pause %command_pause
  }
  if ($hidden) then send unhide
  pause %command_pause
  put %movement
  goto MOVE_DONE

MOVE_WAIT:
  action (mapper) off
  shift
  if (%movewait) then waitforre ^After a seemingly interminible length of time|^You reach|you reach|^Just when it seems|^Finally the bridge comes to an end|^Obvious|^You also see
  var depth 0
  var movewait 0
  pause %command_pause
  action (mapper) on
  goto MOVE_DONE

MOVE_STAIRS:
  pause %command_pause
  if (%movewait) then {
    matchre MOVE_DONE ^You reach|you reach|^Just when it seems|^Finally the bridge comes to an end
    matchwait
  }
  goto MOVE_DONE

MOVE_STAND:
  var StandCount 0
  gosub STAND
  goto RETURN_CLEAR

ATTACK_RETREAT:
  if (%retreat.count > 2) then {
    gosub ECHO Unable to retreat, script exiting.
    put #flash
    put #parse unable to retreat script exiting
    goto END
  }
  var action bob
  var success ^There is nothing else to face!|^What are you trying to attack\?|^Roundtime:
  gosub ACTION
  if ($monstercount == 0) then goto RETURN_CLEAR
  math retreat.count add 1
MOVE_RETREAT:
  action (mapper) off
  if (!$standing) then gosub STAND
  if ($hidden) then gosub UNHIDE
  pause %command_pause
  matchre ATTACK_RETREAT ^Retreat to where\?\s+There's no place to retreat to\!
  matchre MOVE_RETREAT %move_RETRY|^\s*[\[\(]?[rR]oundtime\s*\:?|^You retreat back
  matchre RETURN_CLEAR ^You retreat from combat|^You sneak back out of combat|^You are already as far away as you can get|^You stop
  matchre RETURN_CLEAR ^You begin to get up and \*\*SMACK\!\*\*
  put retreat
  matchwait
  goto MOVE_RETREAT

MOVE_DIVE:
  if ($broom_carpet) then {
    eval movement replacere("%movement", "dive ", "")
    put go %movement
  }
  else put dive %movement
  goto MOVE_DONE

MOVE_GO:
  put go %movement
  goto MOVE_DONE

MOVE_KNEEL:
  var action kneel
  var success ^You rise to a kneeling|^You kneel|^You're already kneeling|^Subservient type
  gosub ACTION
  put %movement
  goto MOVE_DONE

MOVE_LIE:
  var action lie
  var success ^You lie down|^You are already lying down
  gosub ACTION
  put %movement
  goto MOVE_DONE

MOVE_NOSNEAK:
  if (%closed) then goto MOVE_CLOSED
  eval movement replacere("%movement", "sneak ", "")
  put %movement
  goto MOVE_DONE

MOVE_DRAWBRIDGE:
  waitforre ^Loose chains clank as the drawbridge settles on the ground with a solid thud\.
  put %movement
  goto MOVE_DONE

MOVE_ROPE_BRIDGE:
  action instant put retreat;put retreat when melee range|pole weapon range
  waitforre finally arriving|finally reaching
  action remove melee range|pole weapon range
  put %movement
  goto MOVE_DONE

MOVE_FAILED:
  action (mapper) off
  var subscript 0
  evalmath failcounter %failcounter + 1
# maybe it's off by one so retry once then shift thru what's left
  if (%failcounter > 1) then shift
  if (%failcounter > 3) then {
    put #parse MOVE FAILED
    put #parse AUTOMAPPER: MOVEMENT FAILED!
    # Do not comment out above parses as some scripts use this to restart Automapper
    pause
    put #mapper reset
    pause
    put #goto $destination
    goto END
  }
  put #echo %color <~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~>
  put #echo %color {   MOVE FAILED - Type: %type | Movement: %movement | Depth: %depth
  put #echo %color {    Remaining Moves: %argcount
  put #echo %color <~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~>
  pause
  gosub ECHO RETRYING Movement...%failcounter / 3 Tries.
MOVE_RETRY:
  gosub ECHO Retry movement %1
  if (%TryGoInsteadOfClimb) then eval movement replacere("%movement", "climb ", "go ")
  # SHROOM - LIGHT SOURCE CHECK - (MAY Need fine tuning) - CHECKS FOR DARK VISION/ LIGHT ITEM WHEN IN ROOMID = 0 AND DARK ROOM
  if ((($roomid == 0) && matchre("$roomobjs $roomdesc","(pitch black|pitch dark)") && (%darkchecked == 0)) || ((%darkroom == 1) && (%darkchecked == 0))) then gosub LIGHT_SOURCE
  if ($webbed) then {
    if (%verbose) then gosub ECHO WEBBED - pausing
    pause
    if ($webbed) then pause 0.5
    if ($webbed) then waiteval (!$webbed)
    goto MOVE_RETRY
  }
  if ($stunned) then {
    if (%verbose) then gosub ECHO STUNNED - pausing
    pause
    if ($stunned) then pause 0.5
    if ($stunned) then waiteval (!$stunned)
    goto MOVE_RETRY
  }
  if (%typeahead.max == 0) then {
    pause %command_pause
    put fatigue
  }
  delay %infiniteLoopProtection
  pause %command_pause
  if ($roundtime > 0) then pause $roundtime

RETURN_CLEAR:
  action (mapper) on
  var depth 0
  var movewait 0
  goto MOVE_DONE

MOVE_CLOSED:
  gosub ECHO SHOP IS CLOSED FOR THE NIGHT!
  put #parse SHOP CLOSED
  put #parse SHOP IS CLOSED
  put #parse AUTOMAPPER: SHOP IS CLOSED
  goto END

JAILED:
  gosub ECHO GOT THROWN IN JAIL!
  put #parse JAILED
  put #parse THROWN IN JAIL
  put #parse NAILED AND JAILED!
  put #parse AUTOMAPPER: JAILED
  goto END

#### The various types of walking actions
CARAVAN:
  waitforre ^Your .*, following you\.
  goto MAIN_LOOP_CLEAR

MAPWALK:
  var typeahead.max 0
  var success ^The map has a large 'X' marked in the middle of it
  var action study my map
  goto ACTION_WALK

POWERWALK:
  if (($Attunement.LearningRate > 33) || ($Attunement.Ranks >= 1750)) then {
    put #var powerwalk 0
    var typeahead.max $automapper.typeahead
    return
    }
  var typeahead.max 0
  var success ^\s*[\[\(]?[rR]oundtime\s*\:?|^Something in the area is interfering|^You are a bit too busy performing
  var action perceive
  goto ACTION_WALK

SIGILWALK:
  if ((($Scholarship.LearningRate > 33) || ($Scholarship.Ranks >= 1750)) && (($Arcana.LearningRate > 33) || ($Arcana.Ranks >= 1750)) && (($Outdoorsmanship.LearningRate > 33) || ($Outdoorsmanship.Ranks >= 1750))) then {
    put #var automapper.sigilwalk 0
    var typeahead.max $automapper.typeahead
    return
    }
  var typeahead.max 0
  var action_retry ^Roundtime: \d+ (?:sec|Irenos).
  var success (?:antipode|ascension|clarification|decay|evolution|integration|metamorphosis|nurture|paradox|unity) sigil(?: has revealed itself| before you)?\.$|^Having recently been searched,|^You recall having already identified|^Something in the area is interfering|^You are too distracted
  var action perceive sigil
  gosub ACTION_MAPPER_ON
  var action_retry ^0$
  goto MAIN_LOOP_CLEAR

SEARCHWALK:
  var typeahead.max 0
  var success ^You search around|^After a careful search|^You notice|^\s*[\[\(]?[rR]oundtime\s*\:?|^You push through bushes|^You scan|^There seems to be|^You walk around the perimeter|^Just under the Bridge
  var action search
  goto ACTION_WALK

USERWALK:
  #requested by djordje - 2022-12-06
  #So I could set up a script to use automapper and have it step into a room, script does its thing then parses the trigger for automapper to take the next step, kinda like the powerwalk/wait for caravan stuff but customizable
  var typeahead.max 0
  if def(automapper.UserWalkRetry) then var action_retry $automapper.UserWalkRetry
  var success $automapper.UserWalkSuccess
  var action $automapper.UserWalkAction
  gosub ACTION_MAPPER_ON
  var action_retry ^0$
  goto MAIN_LOOP_CLEAR

MOVE_DONE:
  if (!$standing) then gosub STAND
  if ((%cloak_off) && matchre("$lefthand $righthand", "%cloaknouns")) then gosub WEAR_CLOAK
  if ($caravan) then goto CARAVAN
  if ($mapwalk) then goto MAPWALK
  if ($powerwalk) then goto POWERWALK
  if ($automapper.sigilwalk) then goto SIGILWALK
  if ($searchwalk) then goto SEARCHWALK
  if ($automapper.userwalk) then goto USERWALK
  gosub clear
  var movewait 0
  goto MAIN_LOOP

ABBEY_HATCH:
  action (abbey) on
  action (abbey) var abbey_sconce 1 when ^What were you referring to?
  var abbey_sconce 0
  var action go secret hatchway
  var success ^What were you referring to?|^A narrow, winding staircase has been chiseled
  gosub ACTION
  if (!%abbey_sconce) then goto ABBEY_HATCH_SUCCESS
  move go ironbound door
  var action turn sconce
  var success ^The torch sconce has been turned as far as it will go|^You hear a faint click
  gosub ACTION
  move go ironbound door
  move go secret hatchway
ABBEY_HATCH_SUCCESS:
  action (abbey) off
  goto MOVE_SCRIPT_DONE

GATE_OF_SOULS:
  action (souls) on
  action (souls) var pushing 0 when ^You stop pushing\.
  action (souls) var boulder 0 when ^The ground trembles slightly, causing a massive granite boulder to rock back and forth
  action (souls) var boulder 1 when ^At the bottom of the hollow, a low tunnel is revealed\!
  action (souls) var pushing 1 when ^You lean against the boulder|^You're already pushing
  var boulder 0
  var pushing 0
GATE_OF_SOULS.1:
  pause %command_pause
  if (!$standing) then gosub STAND
  if matchre("$roomobjs", "low tunnel") then goto GATE_OF_SOULS_GO
  if (%boulder == 1) then goto GATE_OF_SOULS_GO
  if (%pushing == 0) then {
    gosub RETREAT
    put push boulder
    if ($roundtime > 0) then pause $roundtime
    pause %command_pause
  }
  goto GATE_OF_SOULS.1
GATE_OF_SOULS_GO:
  gosub RETREAT
  if ($standing) then send lie
  pause %command_pause
  matchre GATE_OF_SOULS.1 ^What were you
  matchre GATE_OF_SOULS_GO ^Sorry|^You are engaged|^It's a pretty tight fit
  matchre GATE_OF_SOULS_WAIT ^Wriggling on your stomach, you crawl into a low tunnel
  put go tunnel
  matchwait 5
  goto GATE_OF_SOULS.1
GATE_OF_SOULS_WAIT:
  matchre GATE_OF_SOULS_DONE Coarse black grit blows in swirling eddies|^After a seemingly interminable length of time
  matchwait
GATE_OF_SOULS_DONE:
  if (!$standing) then gosub STAND
  pause %command_pause
  action (souls) off
  goto MOVE_SCRIPT_DONE

GATE_OF_SOULS_LEAVE:
  if ($standing) then send lie
  pause %command_pause
  matchre GATE_OF_SOULS_LEAVE_DONE ^Rising in a snubbed tower|^After a seemingly interminable length of time
  put go tunnel
  matchwait 75
  goto GATE_OF_SOULS_LEAVE
GATE_OF_SOULS_LEAVE_DONE:
  if (!$standing) then gosub STAND
  pause %command_pause
  action (souls) off
  goto MOVE_SCRIPT_DONE

GEAR_GATE_BYPASS:
  var wall 0
  var wall_trigger torch
  action (ggbypass) var wall 0 when ^The stone wall slowly closes|stone wall closes\.$
  action (ggbypass) var wall 1 when ^A gouged stone wall slowly opens up|and a gouged stone wall opens up\.$
  action (ggbypass) goto GEAR_GATE_BYPASS when ^I could not find what you were referring to\.$
  action (ggbypass) on
GEAR_GATE_BYPASS_CHECK:
  if (!$standing) then gosub STAND
  if matchre("$roomobjs", "a gouged stone wall") then var wall 1
  if ("$roomid" == "263") then var wall_trigger stone basin
  if ("$roomid" == "264") then var wall_trigger torch on wall
  if (("$roomid" != "264") && ("$roomid" != "263")) then goto MOVE_FAILED
  if (!%wall) then {
    var action turn %wall_trigger
    var success ^As you pull down on
    var action_retry ^You push up on the
    gosub ACTION
    var action_retry ^0$
  }
  if (%wall) then {
    if (!$standing) then gosub STAND
    move go wall
    action (ggbypass) off
    var subscript 0
# Not sure which one to use! My testing worked with MOVE_DONE. If MOVE_SCRIPT_DONE is better, then remove "action (mapper) on" in this block.
#    action (mapper) on
#    goto MOVE_DONE
    goto MOVE_SCRIPT_DONE
  }
  goto GEAR_GATE_BYPASS_CHECK

ENTER_DOBEKS:
  pause %command_pause
  put kiss scorpion
  pause
  if (%verbose) then gosub ECHO PAUSING FOR STUN
  pause 13
  if ($stunned) then waiteval (!$stunned)
  if (!$standing) then gosub STAND
  goto MOVE_SCRIPT_DONE

OSHUMANOR:
  pause %command_pause
  if (%verbose) then gosub ECHO EXITING OSHU MANOR CHAMBER
  put east
  waitforre %move_OK
  pause %command_pause
  send turn sconce
  pause %command_pause
  if ($roundtime > 0) then pause $roundtime
  put west
  waitforre %move_OK
  put go door
  pause %command_pause
  if ($roomid == 113) then goto OSHUMANOR
  goto MOVE_SCRIPT_DONE

DRAGONSPINE:
  pause %command_pause
  if (%verbose) then gosub ECHO DRAGON'S SPINE ENTRY/EXIT
  matchre DRAGONSPINE2 ^A Mountain Elf ranger steps from behind a tree and beckons for you to follow\.
  put recite Neath the depths of darkness i go\;to 'scape the prying eyes of light\;under dragon's spine i crawl\;to crawl out from under the dragon's shadow
  matchwait 45
  goto DRAGONSPINE
DRAGONSPINE2:
  action (mapper) on
  var subscript 0
  goto MOVE_DONE

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
  goto MOVE_REAL

MISTWOOD_CLIFF:
#shift away if room load trigger got turned off before it loaded
  if matchre("%1", "objsearch rocky.ledge climb shrub") then shift
  eval depthtimeout $unixtime + %waitevalTimeOut
  if (%depth > 1) then waiteval ((1 <= %depth) || ($unixtime >= %depthtimeout))
  put peer path
  waitforre ^Peering closely at a faint path, you realize you would need to head (\w+)\.
  var Dir $1
  put down
  waitforre %move_OK
  put %Dir
  waitforre %move_OK
  pause %command_pause
  if matchre("$roomexits", "\bnorthwest\b") then {
    put northwest
    waitforre %move_OK
  }
  goto MOVE_SCRIPT_DONE

SANDSPIT_TAVERN:
  action (sandspit) on
  action (sandspit) var barrel 0 when ^You duck quietly into an old barrel.
  action (sandspit) var barrel 1 when ^You can't do that.
  var action go barrel
  var success ^You can't|^You duck
  gosub ACTION
  if (%barrel) then {
    var action go other barrel
    gosub ACTION
  }
  pause %command_pause
  action (sandspit) off
  goto MOVE_SCRIPT_DONE

HIB_INTELLIGENCE:
  action (hibintel) on
  action (hibintel) var steeldoor 0 when Chedik Bridge, Engineer's Tower
  action (hibintel) var steeldoor 1 when ^You can't do that.
  var action go steel door
  var success ^You can't|Chedik Bridge, Engineer's Tower
  gosub ACTION
  if (%steeldoor) then {
    var action go other steel door
    gosub ACTION
  }
  pause %command_pause
  action (hibintel) off
  goto MOVE_SCRIPT_DONE

AUTOCLIMB_DOWN:
  var autoclimb down
  goto AUTOCLIMB

AUTOCLIMB_UP:
  var autoclimb up

AUTOCLIMB:
  var action climb %autoclimb
  var action_retry ^You work your way|^You slip but catch yourself
  var success ^You climb over the top|^Obvious
  gosub ACTION
  var action_retry ^0$
  goto MOVE_SCRIPT_DONE

ANDRESHLEW_VINE:
  var action tap vine
  var success ^As you attempt to (touch|tap) the vine
  gosub ACTION
  waitforre ^Just as you were about to hit, the vine snakes around your waist and sets you gently on the ground
  pause %command_pause
  goto MOVE_SCRIPT_DONE

GET_MAP:
  var action get my map
  var success ^You get|^You are already holding
  goto ACTION

FIND_SKATES:
  var skatechecked 1
  if (%verbose) then gosub ECHO Checking for ice skates!
  action (skates) var skate.container $1 when ^You tap .*\bskates\b.*inside your (.*)\.$
  action (skates) var skate.container portal when ^In the .* eddy you see.* \bskates\b
  action (skates) var skate.container held when ^You are holding some.*\bskates\b
  if matchre("$righthand|$lefthand", "skates") then goto CHECK_FOOTWEAR
  var action tap my skates
  var success ^You tap|^I could not|^What were you
  gosub ACTION
  if (%wearing_skates) then return
  if (%skate.container != 0) then goto CHECK_FOOTWEAR

FIND_SKATES_PORTAL:
  gosub LOOK_PORTAL

CHECK_FOOTWEAR:
#waiting for a fix for outlander then we can re-anchor this and remove the action off
  action (skates2) var footwear $1 when (skates|boots?|shoes?|moccasins?|sandals?|slippers?|mules|workboots?|footwraps?|footwear|spats?|chopines?|nauda|booties|clogs|buskins?|cothurnes?|galoshes|half-boots?|ankle-boots?|gutalles?|hessians?|brogans?|toe\s?-?rings?|toe\s?-?bells?|loafers?|pumps?)
  action (skates) var footwear 0 when ^You aren't wearing anything like that
  var footwear unknown
  var action inv feet
  var success ^You aren't wearing anything like that|^All of your items worn on the feet
  gosub ACTION
  action (skates2) off
  if ("%footwear" == "skates") then return
  if (%skate.container == 0) then goto SKATE_NO
  if ("%footwear" == "unknown") then {
    if (%verbose) then gosub ECHO ERROR: Unknown noun for your footwear!
    goto SKATE_NO
  }
  if (%verbose) then gosub ECHO Ice skates found!
  if ((%footwear == 0) && ("%skate.container" == "held")) then goto WEAR_SKATES
  if (%footwear == 0) then goto GET_SKATES

REMOVE_FOOTWEAR:
  var action remove my %footwear
  var success ^You (aren't|can't|carefully|climb|deftly|detach|drape|fade|fall|get|hang|kneel|lie|loosen|place|pull|quickly|remove|rise|set|shift|silently|sit|slide|sling|slip|stand|step|unstrap|take|toss|untie|work|wrap|yank)
  gosub ACTION

STOW_FOOTWEAR:
  action (skates) var footwear.container $1 when ^You put your .* in your (.*)\.$
  var action stow my %footwear
  var success ^You put
  gosub ACTION

GET_SKATES:
  var action get my skates in my %skate.container
  var success ^You get|^You fade in for a moment as you get
  gosub ACTION

WEAR_SKATES:
  var action wear my skates
  var success ^You slide your ice skates on your feet and tightly tie the laces|^You (are already|aren't|attach|can't|carefully|climb|deftly|detach|drape|fade|fall|get|hang|kneel|lie|loosen|need|place|pull|put|quickly|remove|rise|set|shift|silently|sit|slide|sling|slip|stand|step|strap|take|tie|toss|untie|work|wrap|yank)
  goto ACTION

REMOVE_SKATES:
  var depth 0
  if (%verbose) then gosub ECHO Removing ice skates!
  var action remove my skates
  var success ^You untie your skates and slip them off of your feet
  gosub ACTION

STOW_SKATES:
  if (%skate.container == 0) then var action stow my skates
  else var action put my skates in my %skate.container
  var success ^You put
  gosub ACTION

GET_FOOTWEAR:
  if (%footwear == 0) then return
  if (%verbose) then gosub ECHO Putting your %footwear back on!
  var action get my %footwear in my %footwear.container
  var success ^You get
  gosub ACTION

WEAR_FOOTWEAR:
  var depth 0
  var action wear my %footwear
  var success ^You (are already|attach|can't|carefully|climb|deftly|drape|fade|fall|get|hang|kneel|lie|loosen|place|pull|put|quickly|rise|set|shift|silently|sit|slide|sling|slip|stand|step|strap|take|tie|toss|untie|work|wrap|yank)
  goto ACTION

FIND_CLOAK:
  action (cloak) on
  action (cloak) var cloak_worn 1 when ^You tap.*(%cloaknouns).*that you are wearing\.$
  action (cloak) var cloak_worn 2 when ^You attempt to turn|^You adjust the fit
  var cloakloop 0
  var cloak_worn 0

TAP_CLOAK:
  eval cloak_noun element("%cloaknouns", "%cloakloop")
  if (%cloak_noun == 0) then return
  var action tap my %cloak_noun
  var success ^You tap|^I could not find
  gosub ACTION
  math cloakloop add 1
  if (!%cloak_worn) then goto TAP_CLOAK

LOWER_CLOAK:
  var action_retry ^You pull your %cloak_noun
  var action turn my %cloak_noun
  var success ^You (adjust the fit|attempt to turn|pull down your|wind|unwind)
  gosub ACTION
  var action_retry ^0$
  if (%cloak_worn == 2) then goto REMOVE_CLOAK
  return

RAISE_CLOAK:
  var action_retry ^You pull down your
  var action turn my %cloak_noun
  var success ^You (attempt to turn|pull your %cloak_noun|wind|unwind)
  gosub ACTION
  var action_retry ^0$
  return

REMOVE_CLOAK:
  var action remove my %cloak_noun
  var success ^You (are already|aren't|attach|can't|carefully|climb|deftly|detach|drape|fade|fall|get|hang|kneel|lie|loosen|need|place|pull|put|quickly|remove|rise|set|shift|silently|sit|slide|sling|slip|stand|step|strap|take|tie|toss|untie|work|wrap|yank)|slips away from your face
  gosub ACTION
  var cloak_off 1
  return

WEAR_CLOAK:
  if matchre("$lefthand", "(%cloaknouns)") then var action wear my $lefthandnoun
  if matchre("$righthand", "(%cloaknouns)") then var action wear my $righthandnoun
  var success ^You (are already|attach|can't|carefully|climb|deftly|drape|fade|fall|get|hang|kneel|lie|loosen|place|pull|put|quickly|rise|set|shift|silently|sit|slide|sling|slip|stand|step|strap|take|tie|toss|untie|wear|work|wrap|yank)
  gosub ACTION
  var cloak_off 0
  return

LOOK_PORTAL:
  var action look in my watery portal
  var success ^In the.*you see|^I could not find
  gosub ACTION
  return


#### Handle current pushing you around ####
DRAGGED:
  delay %infiniteLoopProtection
  if ($roundtime > 0) then pause $roundtime
  action (mapper) on
  var depth 0
  goto MOVE_DONE
####

#### Stop and get healed
HEALING:
  delay %infiniteLoopProtection
  if ($roundtime > 0) then pause $roundtime
  eval depthtimeout $unixtime + %waitevalTimeOut
  if (%depth > 1) then waiteval ((1 <= %depth) || ($unixtime >= %depthtimeout))
  var action touch %plant
  var success ^The last of your wounds knit shut|^The vela'tohr plant recoils from you|^You reach out to touch an ethereal vela'tohr plant, but it shudders its leaves rustling angrily and bristling with sharp edges and thorns|^You feel a brief flare of warmth where your skin previously
  gosub ACTION
  action (healing) off
  put #var automapper.seekhealing 0
  goto MOVE_DONE
HEALTHCHECK:
  var wounded 0
  matchre WOUNDED ^You have (?:an?|some)
  matchre RETURN ^You have no
  put health
  matchwait
WOUNDED:
  var wounded 1
  return
####
