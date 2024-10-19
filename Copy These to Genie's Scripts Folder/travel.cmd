#travel.cmd
var version 6.2024-10-17
# debug 5 is for outlander; genie debuglevel 10
# debuglevel 10
# debug 5

# use '.travel help' from the command line for variables and more
# POWER TRAVEL SCRIPT FOR GENIE 4 ~ TRAVELS TO/FROM ALMOST ~ANYWHERE~ IN DRAGONREALMS
# CAN START SCRIPT FROM ANYWHERE IN THE GAME

# REQUIRES EXPTRACKER PLUGIN! MANDATORY!

# Inspired by the OG Wizard Travel Script - But made 1000x better w/ the power of GENIE
# Originally written by Achilles - Revitalized and Robustified by Shroom
#
# USES PLAT PORTALS TO TRAVEL BETWEEN CITIES IF PLATINUM
# KNOWS HOW TO NAVIGATE OUT OF ANY MAZE / PUZZLE AREAS / FERRIES ETC
# IT TAKES CERTAIN SHORTCUTS IF YOU HAVE THE NECESSARY RANKS (Athletics)
# HANDLES DARK ROOMS WITH GUILD DARKVISION / CHECKS FOR GATHZENS ITEMS ETC
#
# USAGE:
# .travel <location>
# OR
# .travel <location> <room number>
#
# EXAMPLES:
# .travel shard - Travel to Shard
# .travel stone - Travel to Stone Clan
#
# ADVANCED:
# .travel shard 40 - Travel to SHARD - THEN move to ROOM 40 in Shard
# .travel boar 25 - Travel to BOAR CLAN - THEN move to ROOM 25 in Boar Clan
#
# TO MOVE TO AN EXACT ROOM NUMBER/LABEL IN A CERTAIN MAP
# YOU MUST KNOW THE "DESTINATION" MAP LOCATION THEN CHOOSE A ROOM NUMBER/LABEL IN THAT EXACT MAP
# OR SIMPLY CHOOSE A FINAL CITY / DESTINATION AND SCRIPT WILL TAKE YOU THERE
#
# VALID DESTINATIONS YOU CAN CHOOSE ARE:
#
# Crossing | Arthe Dale | West Gate | Tiger Clan | Wolf Clan | Dokt | Knife Clan | Kaerna
# Stone Clan | Caravansary | Dirge | Ushnish | Sorrow's | Beisswurms | Misenseor | Leucros
# Vipers | Malodorous Buccas | Alfren's Ferry | Leth Deriel  | Ilaya Taipa | Acenemacra
# Riverhaven | Rossmans | Langenfirth | El'Bains | Therenborough | Rakash | Fornsted
# Zaulfung |  Throne City | Hvaral | Haizen | Oasis | Yeehar | Muspar'i
# Shard | Horse Clan | Fayrin's Rest | Steelclaw Clan | Spire | Corik's Wall
# Ylono | Granite Gargoyles | Gondola | Bone Wolves | Germishdin | Fang Cove | Wyvern Mountain
# Raven's Point | Ain Ghazal| Outer Hib | Inner Hib | Hibarnhvidar | Boar Clan
# Aesry Surlaenis'a | Ratha | M'riss | Mer'Kresh | Hara'jaal | Taisgath
#
# THIS SCRIPT PARSES " YOU ARRIVED! " (Without the quotes) when it's done
# If calling this script via another, you can match off of:
# ^YOU ARRIVED\!
# ie;
#
#  put .travel cross
#  waitforre ^YOU ARRIVED\!
#
##########################################
#       ADJUSTABLE VARIABLES             #
##########################################
##  ADJUST THE ATHLETICS RANKS VIA GLOBAL TO USE CERTAIN SHORTCUTS
##  THESE ARE PRE-SET TO CONSERVATIVE NUMBERS TO BE ON THE SAFER SIDE
##   TO ACCOUNT FOR BURDEN/STRENGTH
## TELLS THE SCRIPT WHAT SHORTCUTS
## YOU CAN TAKE AT CERTAIN ATHLETICS
##  IF you are joined in a ~GROUP~,
##  You WILL take public transportation
##########################################
##########################################
## RANKS TO USE ROSSMAN'S SHORTCUT      ##
## TO SWIM THE JANTSPYRE RIVER          ##
## NORTH IS ~SAFE~ AROUND 200           ##
## NORTH IS POSSIBLE ~175 W/ NO ARMOR   ##
## SOUTH IS MUCH EASIER, SAFE AT ~90    ##
if !def(travel.rossmanNorth) then var rossmanNorth 200
else var rossmanNorth $travel.rossmanNorth
if !def(travel.rossmanSouth) then var rossmanSouth 90
else var rossmanSouth $travel.rossmanSouth
###########################################
##  RANKS TO SWIM THE FALDESU RIVER      ##
##  HAVEN TO NTR OR VICA VERSA           ##
##  SAFE ~ 190 - 200                     ##
##  POSSIBLE= ~160+ w/ NO BURDEN/BUFFS   ##
## RANKS TO USE ROSSMAN'S SHORTCUT      ##
## TO SWIM THE JANTSPYRE RIVER          ##
## NORTH IS ~SAFE~ AROUND 200           ##
## NORTH IS POSSIBLE ~175 W/ NO ARMOR   ##
## SOUTH IS MUCH EASIER, SAFE AT ~90    ##
if !def(travel.faldesu) then var faldesu 190
else var faldesu $travel.faldesu
############################################
##  RANKS TO SWIM THE SEGOLTHA RIVER     ##
##  TIGER CLAN TO STR OR VICA VERSA      ##
##  VERY TOUGH ONE! CAREFUL LOWERING!    ##
##  MAY GET STUCK IF YOU SET TOO LOW!    ##
##  SAFE= 550+ | BUFFED & STRONG= ~530   ##
if !def(travel.segoltha) then var segoltha 550
else var segoltha $travel.segoltha
##########################################
## RANKS TO CLIMB underGondola SHORTCUT ##
## SOME CAN DO ~480 W/ BUFFS & ROPE     ##
## ~510 - 530 IS GENERALLY SAFE         ##
if !def(travel.underGondola) then var underGondola 515
else var underGondola $travel.underGondola
##########################################
##########################################
## RANKS TO USE UNDER-SEGOLTHA (THIEF)  ##
## 35 MIN w/ NO BURDEN - 50 is "SAFE"   ##
if !def(travel.underSegoltha) then var underSegoltha 50
else var underSegoltha $travel.underSegoltha
##########################################
#######################################################
## RANKS FOR VELAKA DESERT SHORTCUT TO MUSPARI       ##
## THIS IS THE HARDEST SHORTCUT IN THE GAME          ##
## 760 ~BARE MIN~ for this one! - 780-800 IS 'SAFE'  ##
## ITS ALSO POSSIBLE IT MAY GET LOST -NOT FOOLPROOF! ## 
## SET TO 2000 TO SKIP TAKING SHORTCUT AND USE FERRY ##
if !def(travel.muspari) then var muspari 2000
else var muspari $travel.muspari
#################################################
#### END OF VARIABLES!!!
#### DONT TOUCH ANYTHING BELOW THIS LINE
###########################################
include mapperINC
# checks for outlander v. genie, outlander does not suppor the `mono` flag
if matchre("$client", "Genie") then var helpecho #33CC99 mono
if matchre("$client", "Outlander") then var helpecho #33CC99
if matchre("%1", "help|HELP|Help|^$") then {
  put #echo %helpecho <~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~>
  put #echo %helpecho {  Welcome to travel Setup!   (version %version)           }
  put #echo %helpecho {  Use the command line to set the following preferences:          }
  put #echo %helpecho {    Pause                                                         }
  put #echo %helpecho {      Time to pause before sending a "put x" command              }
  put #echo %helpecho {      #var automapper.pause 0.01                                  }
  put #echo %helpecho {    Infinite Loop Protection                                      }
  put #echo %helpecho {      Increase if you get infinte loop errors                     }
  put #echo %helpecho {      #var automapper.loop 0.001                                  }
  put #echo %helpecho {    Waiteval Time Out                                             }
  put #echo %helpecho {      prevents waiting forever for wave to collapse               }
  put #echo %helpecho {      #var automapper.wavetimeout 15                              }
  put #echo %helpecho {    Echoes                                                        }
  put #echo %helpecho {      how verbose do you want automapper to be?                   }
  put #echo %helpecho {      #var automapper.verbose 1                                   }
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
  put #echo %helpecho {                  }
  put #echo %helpecho {  Now save! (#save vars for Genie | cmd-s for Outlander)          }
  put #echo %helpecho {                                                                  }
  put #echo %helpecho {  try `.automapper help` for help with automapper variables      }
  put #echo %helpecho {    there is commonality-these variables will affect how travel works  }
  put #echo %helpecho {      as it manages automapper      }
  put #echo %helpecho <~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~>
  exit
}



HELP:
echo ## RANKS TO USE ROSSMAN'S SHORTCUT      ##
echo ## TO SWIM THE JANTSPYRE RIVER          ##
echo ## NORTH IS ~SAFE~ AROUND 200           ##
echo ## NORTH IS POSSIBLE ~175 W/ NO ARMOR   ##
echo ## SOUTH IS MUCH EASIER, SAFE AT ~90    ##
echo if !def(travel.rossmannorth) then var rossmannorth 200
echo else var rossmannorth $travel.rossmannorth
echo if !def(travel.rossmansouth) then var rossmansouth 90
echo else var rossmansouth $travel.rossmansouth
###########################################
##  RANKS TO SWIM THE FALDESU RIVER      ##
##  HAVEN TO NTR OR VICA VERSA           ##
##  SAFE ~ 190 - 200                     ##
##  POSSIBLE= ~160+ w/ NO BURDEN/BUFFS   ##
## RANKS TO USE ROSSMAN'S SHORTCUT      ##
## TO SWIM THE JANTSPYRE RIVER          ##
## NORTH IS ~SAFE~ AROUND 200           ##
## NORTH IS POSSIBLE ~175 W/ NO ARMOR   ##
## SOUTH IS MUCH EASIER, SAFE AT ~90    ##
if !def(travel.faldesu) then var faldesu 190
else var faldesu $travel.faldesu
############################################
##  RANKS TO SWIM THE SEGOLTHA RIVER     ##
##  TIGER CLAN TO STR OR VICA VERSA      ##
##  VERY TOUGH ONE! CAREFUL LOWERING!    ##
##  MAY GET STUCK IF YOU SET TOO LOW!    ##
##  SAFE= 550+ | BUFFED & STRONG= ~530   ##
if !def(travel.segoltha) then var segoltha 550
else var segoltha $travel.segoltha
##########################################
## RANKS TO CLIMB UNDERGONDOLA SHORTCUT ##
## SOME CAN DO ~480 W/ BUFFS & ROPE     ##
## ~510 - 530 IS GENERALLY SAFE         ##
if !def(travel.undergondola) then var undergondola 515
else var undergondola $travel.undergondola
##########################################
##########################################
## RANKS TO USE UNDER-SEGOLTHA (THIEF)  ##
## 35 MIN w/ NO BURDEN - 50 is "SAFE"   ##
if !def(travel.undersegoltha) then var undersegoltha 50
else var undersegoltha $travel.undersegoltha
##########################################
#######################################################
## RANKS FOR VELAKA DESERT SHORTCUT TO MUSPARI       ##
## THIS IS THE HARDEST SHORTCUT IN THE GAME          ##
## 760 ~BARE MIN~ for this one! - 780-800 IS 'SAFE'  ##
## ITS ALSO POSSIBLE IT MAY GET LOST -NOT FOOLPROOF! ## 
## SET TO 2000 TO SKIP TAKING SHORTCUT AND USE FERRY ##
if !def(travel.muspari) then var muspari 2000
else var muspari $travel.muspari
#################################################

travel.GroupShortCutsAnyway True
travel.verbose







###########################################
# CHANGELOG

#2024-10-17
# Hanryu
#   Big rewrite, pulled out commons subs to an INC
#   unified look and feel with automapper.cmd

# - Robustified FERRY travel FROM Ratha TO MAINLAND for NON-PREMIUM PRIME users
# - FIRST - Will check for MAMMOTHS - IF MAMMOTHS ARE UP WILL TAKE MAMMOTHS - FC - ACENAMACRA 
# - IF NO MAMMOTHS FOUND - WILL RUN TO DOCK AND CHECK FOR SKIRR'LOLASU
# - IF NO SKIRR'LOLASU - WILL PAUSE THEN CHECK FOR MAMMOTH AGAIN 
# - WILL RUN BACK FORTH BETWEEN DOCKS - AND TAKE THE FIRST TRANSPORT THAT ARRIVES
#
# - Heavily Robustified Ferry (NPC Transportation) Travel
# - SHOULD now support starting Travel when ~already on a ferry~
# - Should work whether Auto-Disembark is ON or OFF
# - When traveling on a ferry, which now Echo the name of the Transport you are on
#
# - Robustified PLAT PORTAL usage
# - Streamlined and further robustified Light Source checks
#
# - Fixed bug in Light Source checks - Some subs were still using OLD random movement routine which didn't account for dark rooms
# - Robustified Gaezthen Checks - Should now check for multiple different gaezthen types when searching for a Light Source
#
# - Fixed bug in starting script from 'Zaulfung, Crooked Treetop' causing infinite loop
# - Robustified Travel INTO Zaulfung
# - Added feature for TRAVEL DRAGON at end to show where script was started from
#
# - Fixed intermittent bug in travel when moving from Map 69 to 123
# - Should now micro pause and mapper reset to fix issues with sometimes showing Map == 0
#
# - Added Escape from Shard Favor Area detection (if script is started in there)
# - Added Burden check to beginning info check (sets your current Burden level 0 - 11)
# - Added Burden check for FALDESU RIVER
# - If BURDEN IS TOO HIGH at lower ranks (<200) - will auto TAKE FERRY (Even if you set the Faldesu var low)
# - Will probably expand on this in future updates - mainly for SEGOLTHA RIVER
#
# - Added micro pauses to AUTOMOVE_RETURN - In attempt to fix intermittent problematic issue
# - In some cases, AUTOMOVE would return TOO FAST after moving into a NEW MAP and automapper would still be registering the OLD zone id
# - The script would think it was still on the OLD map and try firing a roomid for the old map, then automove would get confused by an invalid roomid
# - So far this fix seems to be working well. But maybe a #mapper reset could be used in some instances
#
# - Robustified Travel to Rossman / Swimming Faldesu River
#
# - Added check for Athletics.Ranks at start of script
#   - If not present should attempt to reset it and throw a message
# - HEAVILY Robustified Random Movement Engine
# - Added item checks for dark vision Sub (items that produce light)
# - Speedups across many subs - Script should run a bit faster overall
#
# - Fixed travel issue from Shard to Stone Clan
#
# - Fixed issue in taking Thief tunnels into Shard
# - Speedups in different parts of script
# - Fixed several different bugs
#
# - Robustified Random Movement engine so script can recognize/escape from more obscure exits when first starting script in an unknown room
# - Fixed bug when starting Travel from inside the Raven's Court
#
# - Fixed several issues with PLAT PORTAL travel
# - Specifically when travelling to Rossman and Mriss - that could cause an infinite portal loop
# - Cleaned up echoes in several areas
# - Fixed bugs in Random Movement engine
#
# - Cleaned up STOP_INVIS label - Added several more checks and removed unnecessary labelsS
# - Speedups in several areas
#
# - FIXED SHORTCUT TO MUSPARI THROUGH THE DESERT
#
# - ADDED LOGIC FOR ROSSMAN'S ROPE / BRIDGE
# - WILL NOW AUTO-DETECT WHETHER THE BRIDGE OR ROPE IS UP AND TAKE EITHER ONE
# ( SINCE THERE ARE STILL MAP DIFFERENCES BETWEEN TF / PRIME )
#
# - Overall Speedups to Script
# - Better auto recovery from automapper fuckups
#
# - AUTO-SETTING CONTAINER VARIABLES
# - Removed hardcoded container variables in script for stowing (Stow Backpack etc)
# - Script will now do a quick 'inv container' at startup to see what containers you have
# - Will Auto-Set up to 3 main containers variables it sees
# - Will recognize any common 'big container' like backpack, duffel, rucksack, carryall, et
# - This removes the need for users having to worry about setting container variables or use for different characters etc.
#
# - Fixed bug in setting Guild
#
# - Fixed a bug causing a lockup/genie crash when taking public transport
#
# - Will Climb walls to enter Shard from the West/South/North if you have 350+ Athletics
# - Robustified Travel from Muspari/Fornsted area
#
# - Script should now run faster overall
# - Streamlined Travel from Map 68 (South of Shard) - Should Climb Walls into Shard if enough Athletics
# - Fixed a couple various bugs
# - Tweaked Log Echo
#
# - Fixed bug in Travel back from Aesry
# - Added new Destinations - Oasis / Haizen
# - Added Shortcut to/from Muspari if you have enough Athletics
# - Fixed several bugs in the Info Check for coins for taking ferry
# - Fixed bug with Travel to Throne City
#
# - Removed Info check at very beginning, will only check if needing to know guild or traveling on ferry to check coins
# - Fixed bug with Travel from Shard to Cross from recent map update
#
# - Added Destination: Ushnish (Temple of Ushnish past Gate of Souls maze)
# - Added Destination: West/WestGate (west gate of Crossing)
#
# - MAJOR UPDATE - ADDED SUPPORT FOR STARTING SCRIPT FROM PRETTY MUCH ANYWHERE IN ELANTHIA
# - SHOULD NOW AUTOMATICALLY ESCAPE FROM MAZE AREAS / PUZZLE AREAS AND OTHER HARD TO ESCAPE FROM PLACES!
# - Includes Gate of Souls/Fangs of Ushnish - Maelshyve's Fortress - Abyssal Descent - Muspari Maze and more
# - Meaning you can start the script while completely lost even in a maze or puzzle area and it should still get where you need to go
#
# - ADDED PORTAL TRAVEL FOR PLAT - AUTO CHECKS if you have enough time for portals and if so should take portals to travel between major cities
# - Heavy robustification to Segoltha and Faldesu River travel - both North and South
# - MAJOR update to Random Movement Logic - And complete overhaul of Movement routines
# - Added support to check for Passport and go get a passport if you don't have one, when travelling to Muspar'i
# - Added Support for Starting inside the Gondola
# - Robustified all matches for towns and cleaned up a bunch of code
# - Added checking current coin you have on you and only going to bank if needed for ferries
# - Should now check for/withdraw double the amount needed for ferries (to account for return trips/thieves)
# - Added remove invisible checks when visiting the teller
# - Added support for Necros to check and keep up EOTB/ROC when using ferries
# - Fixed travel from Shard to Alfren
# - Merged all changes from recent updates
# - Added Khri Harrier for Thieves when climbing
# - Added travel to/from Boar Clan and Muspari via the wizard
# - Added option for %2 to move a roomid or name when arriving at the location
# - Added travel to and from Muspar'i via new Airship in Crossing area
# - Smashed bug involving travel between M'riss, Mer'Kresh, Hara'Jaal
# - Added travel to and from Islands! - Aesry, Ratha, M'riss, Mer'Kresh, Hara'Jaal, Fang Cove
# - Added Destination Wyvern Mountain
# - Fixed random hangups after withdrawing coins.  Other robustifications.
# - Added Destinations: Throne City, Beisswurms, Caravansary, Hvaral, Alfren's Ferry, Gondola
# - Added ASCII Art :)
# - Robustified underGondola check - Added buffs for thieves/rangers
# - Updated help log and updated labels for more matches
# - Fixed logic issue when starting from Map 50
# - Fixed issue travelling between Fornsted area and Theren
# - Changed all single movements to gosubs to avoid stalls
# - Added currency conversion before checking for coin
# - Will now attempt to exchange coin for ferry before withdrawing
# - Fixed problem traveling to P5
# - Fixed several bad nodes
# - Added multi-character support for shardCitizen variable
# - Added travel  to and from Muspari
# - Added Passport check / Sand Barge to Muspari
##########################################
INIT:
action goto NOPASSPORT when No one proceeds through this checkpoint without a passport
action goto NOCOIN when You haven't got enough (.+) to pay for your trip\.|You reach your funds, but realize you're short\.|\"Hey,\"\s+he says,\s+\"You haven't got enough Lirums to pay for your trip\.
action (moving) var Moving 1 when Obvious (path|exits)|Roundtime
action var OffTransport platform when a barge platform
action var OffTransport pier when the Riverhaven pier
action var OffTransport beach when You also see the beach|mammoth and the beach
action var OffTransport ladder when You also see a ladder|mammoth and a ladder
action var OffTransport wharf when the Langenfirth wharf
action var OffTransport dock when \[\"Her Opulence\"\]|\[\"Hodierna's Grace\"\]|\[\"Kertigen's Honor\"\]|\[\"His Daring Exploit\"\]|\[The Evening Star\]|\[The Damaris' Kiss\]|\[A Birch Skiff\]|\[A Highly Polished Skiff\]|\[\"Imperial Glory\"\]|\[\"The Riverhawk\"\]|Baso Docks|a dry dock|the salt yard dock|covered stone dock|\[The Galley Sanegazat\]|\[The Galley Cercorim\]|\[Aboard the Warship, Gondola\]|\[The Halasa Selhin, Main Deck\]
action send fatigue when ^You can see a ferry approaching on the left side\.|^The ferry|^A kingfisher|^A burst of|^The Elven|^The skiff|^The polemen|^Small waves|^The sturdy stone|^You are about a fourth of the way across\.|^The ferry moves away, nearly out of view\.|ferry passing you on the left\.|^You are nearing the docks\.|^A swarm of eels passes beneath the keel, probably on their way to the river's fresh water to spawn\.|followed by the clatter of wood on wood\.|^A family of dolphins leaps from the water beside the galley\.|^Some geese in a perfect V fly north high overhead\.|^Some small blue sharks slide past through the water\.|^A sailor walks by with a coil of rope\.|^A green turtle as large as a tower shield swims past
action send fatigue when ^You are nearing the docks\.|A drumbeat sounds through the ship\.|^You are about a fourth of the way across\.|^A galley comes into sight, its oars beating rhythmically\.|^The galley moves away, the beat of its drum slowly fading\.|^For a few minutes, the drumbeat from below is echoed across the water by the beat from the galley passing on the left\.|^The door swings shut of its own accord, and the gondola pushes off\.|^The platform vanishes against the ridgeline\.|^The gondola arrives at the center of the chasm, and keeps heading (north|south)\.|^The cab trundles on along as the ropes overhead creak and moan\.|^The ropes creak as the gondola continues (north|south)\.|^The gondola creaks as a wind pushes it back and forth\.|^You hear a bell ring out three times|^The barge|^Several oars pull|^All that is visible|^The opposite bank|^A few of the other passengers|^The shore disappears
action send fatigue when ^A desert oasis|^The oasis|^The endless expanse of the desert|^The dock disappears from view quickly|sand-bearing winds buffet|^Several skilled yeehar-handlers|^The Sand Elf|^The harsh winds|^The Gemfire Mountains|^The extreme heat causes|^The sand barge|^The large yeehars|^The murderous shriek|dark-skinned elf|Dark-skinned Elves|^As the barge is pulled|^As the dirigible continues|^The thick canopy of|^The dirigible|^The sinuous Southern Trade Route|^The Reshal Sea|^The peculiar sight|^A long moment of breathless suspense
action send fatigue when ^A Gnomish mechanic|^As the dirigible|^A breathtaking panorama|^The Gnomish operators|^The river quickly gives|^A massive peak|^A large flock|^Far below, you see|^The Greater Fist|^A clangorous commotion|^Passing over land|^A human who had been|^A cowled passenger peers|^The balloon|^A few scattered islands|^The mammoth's fur|^The sea mammoth|^The air cools|^Scarcely visible in|^Another sea mammoth|^Steadily climbing,|^As the airship leaves the mountain range|^With a swift turn of the|^With another yank on the|^The pilot adjusts his controls|^Turning his wheel, the pilot points the airship|^With a confident spin of the|^Coming down from the mountain|^A whoosh of steam escapes|^The warship (rumbles|continues)|^The tropical island|(crewmen|crewman) (works|rush|swabs)|^Sputtering loudly, the cast-iron stove|^Gnomish (crew|pilot|crewman)|warship (proceeds|continues)
action send look when ^Your destination
action put #tvar spellEOTB 0 when ^Your corruptive mutation fades, revealing you to the world once more\.
action put #tvar spellEOTB 1 when ^You feel a rippling sensation throughout your body as your corruptive mutation alters you and your equipment into blind spots invisible to the world\.
action put #tvar spellEOTB 1 when ^Your spell subtly alters the corruptive mutation upon you, creating a blind spot once more\.
action put #tvar spellEOTB 1 when ^You sense the Eyes of the Blind spell upon you, which will last .*\.
action put #tvar spellROC 0 when ^The Rite of Contrition matrix loses cohesion, leaving your aura naked\.
action put #tvar spellROC 0 when eval ($SpellTimer.RiteofContrition.active == 0)
action put #tvar spellROC 1 when ^You weave a field of sublime corruption, concealing the scars in your aura under a layer of magical pretense\.
action put #tvar spellROC 1 when ^You sense the Rite of Contrition spell upon you, which will last .*\.
action put #tvar spellROG 1 when ^You project your self-image outward on a gust of psychic miasma
action put #tvar spellROG 1 when eval ($SpellTimer.RiteofGrace.active == 1)
action put #tvar spellROG 0 when eval ($SpellTimer.RiteofGrace.active == 0)
put #tvar spellROG 0
put #tvar spellROC 0
put #tvar spellEOTB 0

action var burden 0 when ^\s*Encumbrance\s*\:\s*None
action var burden 1 when ^\s*Encumbrance\s*\:\s*Light Burden
action var burden 2 when ^\s*Encumbrance\s*\:\s*Somewhat Burdened
action var burden 3 when ^\s*Encumbrance\s*\:\s*Burdened
action var burden 4 when ^\s*Encumbrance\s*\:\s*Heavy Burden
action var burden 5 when ^\s*Encumbrance\s*\:\s*Very Heavy Burden
action var burden 6 when ^\s*Encumbrance\s*\:\s*Overburdened
action var burden 7 when ^\s*Encumbrance\s*\:\s*Very Overburdened
action var burden 8 when ^\s*Encumbrance\s*\:\s*Extremely Overburdened
action var burden 9 when ^\s*Encumbrance\s*\:\s*Tottering Under Burden
action var burden 10 when ^\s*Encumbrance\s*\:\s*Are you even able to move\?
action var burden 11 when ^\s*Encumbrance\s*\:\s*It's amazing you aren't squashed\!

var destination %1
if ("%destination" == "") then goto NODESTINATION
var burden 0
var passport 0
if !def(premium) then gosub PREMIUM_CHECK
var kronars 0
var dokoras 0
var lirums 0
var portal 0
var moved 0
var randomloop 0
var ported 0
var lastmoved NULL
var detour NULL
var TherenCoin 300
var BoarNeeded 300
var ToRatha 0
var SkirrChecked 0
var starting MAP:$zoneid | ROOM:$roomid
if !def(citizenship) then gosub CITIZENSHIP
var shardCitizen False
if matchre("$citizenship", "Shard") then var shardCitizen True
TOP:
put #echo >Log #b3ff66 * TRAVEL START: $zonename (Map:$zoneid | Room:$roomid)
put #echo %color <~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~>
put #echo %color <<  Travel Script v%version
put #echo %color <<  Start: $zonename (%starting)
put #echo %color <<  Destination: %destination
put #echo %color <~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~>
if !def(Athletics.Ranks) then {
  gosub ECHO Athletics.Ranks not set! Attempting to Auto-Fix...
  gosub ECHO Do you have the EXPTracker Plugin installed??
  pause %command_pause
  put #tvar Athletics.Ranks 0
  put exp 0
  waitforre EXP HELP|Overall state
  pause %command_pause
}
if (!def(Athletics.Ranks) || ($Athletics.Ranks == 0)) then {
  gosub ECHO Still not registering Athletics.Ranks!!! Make sure you have the EXPTracker Plugin!!
  gosub ECHO Going for it anyway - But this will cause you to skip Athletics Shortcuts!
}
gosub INFO_CHECK
gosub BAG_CHECK
if ($hidden) then gosub UNHIDE
timer clear
timer start
if ($joined == 1) ($travel.GroupShortCutsAnyway == False) then {
  var rossmanNorth 2000
  var rossmanSouth 2000
  var faldesu 2000
  var segoltha 2000
  var underGondola 2000
  var underSegoltha 2000
  var shardCitizen False
  gosub ECHO You are in a group!  You will NOT be taking the gravy short cuts today!
}
START:
action (moving) on
echo
echo
echo ** TRAVEL DRAGON~!
echo
echo                 \||/
echo                 |  @___oo ------------ Pew Pew Pew
echo       /\  /\   / (__,,,,|
echo      ) /^\) ^\/ _)
echo      )   /^\/   _)
echo      )   _ /  / _)
echo  /\  )/\/ ||  | )_)
echo <  >      |(,,) )__)
echo  ||      /    \)___)\
echo  | \____(      )___) )___
echo   \______(_______;;; __;;;
echo
echo *** LET'S GO!!
echo
echo ~~~~~~~~~~~~~~~~~~~~~~~~~
echo * STARTING AREA: 
echo * $roomname
echo * MAP: $zoneid | ROOM: $roomid
echo
echo * DESTINATION: %destination
echo ~~~~~~~~~~~~~~~~~~~~~~~~~
echo
eval destination tolower("%destination")
## DESTINATION
## SPECIAL ESCAPE SECTION FOR MAZES/HARD TO ESCAPE AREAS BY SHROOM
## THIS CHECKS IF WE ARE STARTING FROM A KNOWN MAZE / MESSED UP AREA THAT AUTOMAPPER GETS LOST IN
## THEN USES SPECIAL ESCAPE LOGIC TO GET TO A KNOWN LOCATION THAT AUTOMAPPER CAN USE BEFORE STARTING SCRIPT
if matchre("$roomname","The Raven's Court") then gosub AUTOMOVE 74
if (("$zoneid" == "47") && ($Athletics.Ranks >= %muspari.shortcut) && !matchre("%destination", "\b(musp?a?r?i?)")) then gosub VELAKA_SHORTCUT
if matchre("$roomname", "(Velaka, Slot Canyon|Yeehar's Graveyard|Heru Taipa)") then gosub AUTOMOVE 66
if matchre("$roomname", "(Wyvern Mountain, Cavern|Wyvern Mountain, Dragon Shrine|Wyvern Mountain, Raised Dais)") then gosub SHARD_FAVOR_ESCAPE
if matchre("$roomname", "(Cavern of Glass|Aldauth's Lair)") then gosub ALDAUTH_ESCAPE
if matchre("$roomname", "Ehhrsk Highway") then gosub EHHRSK_ESCAPE
if (matchre("$roomname", "Zaulfung, Swamp") && matchre("$roomdesc", "Rancid mire")) then gosub ZAULFUNG_ESCAPE
if matchre("$roomname", "Zaulfung, Trackless Swamp") then gosub ZAULFUNG_ESCAPE_2
if matchre("$roomname", "Velaka Desert") then gosub VELAKA_ESCAPE
if matchre("$roomname", "Undershard") then gosub WARRENS_ESCAPE
if matchre("$roomname", "The Marsh, In The Water") then gosub CROC_ESCAPE
if matchre("$roomname", "Maelshyve's Ascent") then gosub MAELSHYVE_ASCENT_ESCAPE
if matchre("$roomname", "(Abyssal Descent|Abyssal Seed)") then gosub ABYSSAL_ESCAPE
if matchre("$roomname", "Deadman's Confide, Beach") then gosub DEADMAN_ESCAPE
if matchre("$roomname", "Adder's Nest") then gosub ADDERNEST_ESCAPE
if matchre("$roomname", "Temple of the North Wind, Catacombs") then gosub NORTHWIND_ESCAPE
if matchre("$roomname", "Temple of the North Wind, High Priestess' Sanctum") then gosub ASKETI_ESCAPE
if matchre("$roomname", "Temple of the North Wind, Dark Sanctuary") then gosub ASKETI_ESCAPE
if matchre("$roomname", "Temple of the North Wind, Last Sacrifice") then gosub ASKETI_ESCAPE
if matchre("$roomname", "Asketi's Mount") then gosub ASKETI_ESCAPE
if matchre("$roomname", "The Fangs of Ushnish") then gosub USHNISH_ESCAPE
if matchre("$roomname", "Temple of Ushnish") then gosub USHNISH_ESCAPE_2
if matchre("$roomname", "Beyond the Gate of Souls") then gosub USHNISH_ESCAPE_3
if matchre("$roomname", "Clover Fields") then gosub BROCKET_ESCAPE
if matchre("$roomname", "Maelshyve's Fortress, Inner Sanctum") then gosub MAELSHYVE_FORTRESS_ESCAPE
if matchre("$roomname", "(Maelshyve's Fortress, Hall of Malice|Glutton's Rest|Fallen Altar|Great Dais|Inner Sanctum)") then gosub MAELSHYVE_FORTRESS_ESCAPE
if matchre("$roomname", "(Charred Caverns|Beneath the Zaulfung|Maelshyve's Threshold)") then gosub BENEATH_ZAULFUNG_ESCAPE
if matchre("$roomname", "(Zaulfung, Dense Swamp|Kweld Gelvdael|Zaulfung, Urrem'tier's Spire|Zaulfung, Crooked Treetop)") then gosub ZAULFUNG_ESCAPE_0
if matchre("$roomname", "Zaulfung, Swamp") && matchre("$roomdesc", "Rancid mire") then gosub ZAULFUNG_ESCAPE
if matchre("$roomname", "Zaulfung, Trackless Swamp") then gosub ZAULFUNG_ESCAPE_2
if matchre("$roomname", "Velaka, Dunes") then gosub VELAKADUNES_ESCAPE
## CHECK TO SEE IF SCRIPT IS STARTED ON BOARD CERTAIN FERRIES - IF SO INITIATE FERRY LOGIC
if matchre("$roomname", "Aboard the Mammoth|Gondola|\[\"Her Opulence\"\]|\[\"Hodierna's Grace\"\]|\[\"Kertigen's Honor\"\]|\[\"His Daring Exploit\"\]|\[\"Northern Pride\", Main Deck\]|\[\"Theren's Star\", Deck\]|\[The Evening Star\]|\[The Damaris' Kiss\]|\[A Birch Skiff\]|\[A Highly Polished Skiff\]|\[\"The Desert Wind\"\]|\[\"The Suncatcher\"\]|\[\"The Riverhawk\"\]|\[\"Imperial Glory\"\]\"Hodierna's Grace\"|\"Her Opulence\"\]|\[The Galley Cercorim\]|\[The Jolas, Fore Deck\]|\[Aboard the Warship, Gondola\]|\[The Halasa Selhin, Main Deck\]|\[Aboard the Mammoth, Platform\]") then gosub FERRYLOGIC
## IF SCRIPT IS STARTED IN A ROOMID == 0 - DOUBLE CHECK TO SEE IF WE ARE ON ANY FERRY
## IF NOT ON A FERRY - MOVE IN RANDOM DIRECTIONS AND ATTEMPT TO GET AUTOMAPPER TO REGISTER THE ROOM NUMBER
if (("$zoneid" == "0") || ("$roomid" == "0")) then {
  gosub FERRY_CHECK
  gosub ECHO Unknown map or room id - Attempting to move in random direction to recover
  gosub RANDOMMOVE
}
## SECOND ATTEMPT - IF AUTOMAPPER IS IN ROOMID=0 CONTINUE TO MOVE IN RANDOM DIRECTIONS AND ATTEMPT TO FIND ROOM NUMBER
if (("$zoneid" == "0") || ("$roomid" == "0")) then gosub RANDOMMOVE
## IF ROOMID IS STILL 0 THEN ABORT SCRIPT
if ("$roomid" == "0") then {
  gosub ECHO You are in a spot not recognized by Genie, please start somewhere else!
  gosub ECHO ROOMID = 0 ! THIS MEANS THE MAP DOESN'T KNOW WHERE YOU ARE!
  gosub ECHO TRY MOVING IN RANDOM DIRECTIONS UNTIL THE MAP REGISTERS LOCATIONS
  exit
}
## CHECK COMMON 'SUB' MAP AREAS WE MIGHT GET STUCK IN AND MOVE TO THE MAIN MAP
if ("$zoneid" == "2d") then gosub AUTOMOVE temple
if ("$zoneid" == "1j") then gosub AUTOMOVE cross
if ("$zoneid" == "1l") then gosub AUTOMOVE cross
if ("$zoneid" == "2a") then gosub AUTOMOVE cross
## IF IN FOREST GRYPHONS - TAKE THE EASIEST PATH OUT (Avoid Automapper getting stuck on a hard climb)
if (("$zoneid" == "34") && ($roomid > 89) && ($roomid < 116)) then {
  gosub AUTOMOVE 90
  gosub AUTOMOVE 49
}
## TO RATHA / HARAJAAL / TAISGATH LOGIC - PLAT/PREMIUM/TF ONLY
RATHA_CHECK:
if (matchre("%destination", "\b(ratha|hara?j?a?a?l?|tais?g?a?t?h?)") && matchre("$zoneid", "\b(1|30|42|47|61|66|67|90|99|107|108|116)\b")) then
     {
## PLAT USERS - IF PORTALS ACTIVE - TAKE PLAT PORTALS
          if (matchre("$game", "(?i)DRX") && (%portal == 1)) then
          {
               if (matchre("$zoneid", "\b(1|30|40|47|67|90|99|107|116)\b") && (%ported == 0)) then gosub PORTAL_TIME
          }
## TF / PREMIUM ONLY - TAKE FC FOR RATHA/TAISGATH
     if (matchre("$game", "(?i)DRF") && matchre("%destination", "\b(rath?a?|tais?g?a?t?h?)") || (%premium == 1) && matchre("%destination", "\b(rath?a?|tais?g?a?t?h?)")) then
               {
                    echo
                    echo * GOING TO FC FOR RATHA/TAISGATH TRAVEL 
                    echo
                    pause 0.8
                    gosub TO_SEACAVE
                    gosub AUTOMOVE 2
                    var ToRatha 1
                    gosub JOINLOGIC
                    gosub AUTOMOVE 252
                    if matchre("%destination", "\bratha") then goto ARRIVED
               }
## TF ONLY - TRAVEL TO HARAJAAL VIA FC
      if (matchre("$game", "(?i)DRF") && matchre("%destination", "\b(haraj?a?a?l?)")) then
          {
               echo
               echo * GOING TO FC FOR HARAJAAL TRAVEL
               echo
               pause 0.8
               gosub TO_SEACAVE
               gosub AUTOMOVE 3
               gosub JOINLOGIC
               goto ARRIVED
          }
    }
## BACK TO MAINLAND AREA (DESTINATION: SOUTH OF HAVEN)
## IF IN RATHA AND IN PLAT TAKE PLAT PORTALS
## OTHERWISE TAKE MAMMOTHS TO FC - THEN BACK TO MAINLAND
RATHA_CHECK2:
if (("$zoneid" == "90") && !matchre("%destination", "\b(rath?a?|aesr?y?|hara|taisg?a?t?h?|ross?m?a?n?s?|rive?r?h?a?v?e?n?|have?n?|ther?e?n?b?o?r?o?u?g?h?|lang?e?n?f?i?r?t?h?|musp?a?r?i?|forn?s?t?e?d?|hvar?a?l?|oasi?s?|haize?n?|yeehar?|zaul?f?u?n?g?)")) then
    {
          if (matchre("$game", "(?i)DRX") && (%portal == 1)) then
               {
                    if (matchre("$zoneid", "\b(1|30|40|47|67|90|99|107|116)\b") && (%ported == 0)) then gosub PORTAL_TIME
               }
## PRIMARY METHOD FOR NON-PREMIUM USERS - TAKE MAMMOTHS FROM RATHA TO FC - THEN TALL MAMMOTHS BACK TO MAINLAND (ACENAMACRA)
        var ToRatha 0
        gosub AUTOMOVE 24
        pause 0.5
        put go rocks
        pause
        put look
        pause 0.2
        pause 0.5
        if (!matchre("$roomobjs", "mammoth") && (%SkirrChecked == 0)) then
          {
               echo
               echo * NO MAMMOTH FOUND!
               echo * CHECKING FOR SKIRR'LOLASU
               echo
               pause
               pause 0.5
               send go beach
               pause 0.8
               goto RATHA_CHECK3
          }
        gosub JOINLOGIC
        pause
        gosub JOINLOGIC
        gosub AUTOMOVE 2
    }
RATHA_CHECK3:
## IF IN RATHA AND GOING TO RIVERHAVEN/THEREN AREA - TAKE THE KREE'LA
     if (("$zoneid" == "90") && !matchre("%destination", "\b(rath?a?|aesr?y?|hara|taisg?a?t?h?)")) then
          {
               if matchre("%destination", "\b(ross?m?a?n?s?|rive?r?h?a?v?e?n?|have?n?|ther?e?n?b?o?r?o?u?g?h?|lang?e?n?f?i?r?t?h?|musp?a?r?i?|forn?s?t?e?d?|hvar?a?l?|oasi?s?|haize?n?|yeehar?|zaul?f?u?n?g?)\b") then
                    {
                         gosub AUTOMOVE 1
                         gosub FERRYLOGIC
                    }
          }
## BACKUP METHOD TO CROSS - TAKE SKIRR'LOLASU
     if (("$zoneid" == "90") && !matchre("%destination", "\b(rath?a?|aesr?y?|hara|taisg?a?t?h?|ross?m?a?n?s?|rive?r?h?a?v?e?n?|have?n?|ther?e?n?b?o?r?o?u?g?h?|lang?e?n?f?i?r?t?h?|musp?a?r?i?|forn?s?t?e?d?|hvar?a?l?|oasi?s?|haize?n?|yeehar?|zaul?f?u?n?g?)\b") then
          {
               var ToRatha 0
               gosub AUTOMOVE 2
               pause 0.5
               send look
               pause 0.5
               if !matchre("$roomobjs", "the Skirr'lolasu") then
                    {
                         echo
                         echo * NO FERRIES BACK TO MAINLAND FOUND!
                         echo * PAUSING - THEN CHECKING AGAIN
                         echo
                         var SkirrChecked 1
                         pause 10
                         goto RATHA_CHECK
                    }
               gosub FERRYLOGIC
          }
## RATHA TO TAISGATH
if (("$zoneid" == "90") && matchre("%destination", "\btais?g?a?t?h?")) then
    {
        gosub AUTOMOVE 398
        pause 0.5
        put go moongate
        pause
        goto ARRIVED
    }
## IF IN FC FOR SOME REASON AS NON-PREMIUM - TAKE MAMMOTHS OUT
if (("$zoneid" == "150") && (%premium == 0)) then
     {
         gosub AUTOMOVE 2
         pause 0.3
         gosub JOINLOGIC
         pause 0.5
         pause 0.2
     }
## IF STARTING IN FC AND ARE PREMIUM - AND DESTINATION IS ~NOT~ RATHA/LETH - TAKE EXIT PORTAL OUT
if (("$zoneid" == "150") && !matchre("%destination", "\b(rath?a?|acen?e?m?a?c?r?a?|leth)")) then
     {
         gosub AUTOMOVE 85
         pause 0.3
         send go exit portal
         pause 0.5
         pause 0.2
         send look
         pause 0.5
     }
## IF ~STILL~ IN FC (EXIT PORTAL DIDN'T WORK) - TAKE MAMMOTHS OUT 
if ("$zoneid" == "150") then
     {
         gosub AUTOMOVE 2
         pause 0.3
         gosub JOINLOGIC
         pause 0.5
         pause 0.2
     }
if matchre("$zonename", "Aesry") then gosub AESRYBACK
cheatstart:
if matchre("%destination", "\b(cros?s?i?n?g?s?|xing?)") then goto CROSSING
if matchre("%destination", "\b(wolfc?l?a?n?)") then
     {
          var detour wolf
          goto CROSSING
     }
if matchre("%destination", "\b(west?g?a?t?e?)") then
     {
          var detour knife
          goto CROSSING
     }
if matchre("%destination", "\b(ushni?s?h?)") then
     {
          var detour dirge
          goto CROSSING
     }
if matchre("%destination", "\b(knif?e?c?l?a?n?)") then
     {
          var detour knife
          goto CROSSING
     }
if matchre("%destination", "\b(tige?r?c?l?a?n?)") then
     {
          var detour tiger
          goto CROSSING
     }
if matchre("%destination", "\b(dirg?e?)") then
     {
          var detour dirge
          goto CROSSING
     }
if matchre("%destination", "\b(arth?e?d?a?l?e?)") then
     {
          var detour arthe
          goto CROSSING
     }
if matchre("%destination", "\b(kaer?n?a?)") then
     {
          var detour kaerna
          goto CROSSING
     }
if matchre("%destination", "\b(ilay?a?t?a?i?p?|illa?y?a?t?a?i?p?a?|taipa)") then
     {
          var detour taipa
          goto CROSSING
     }
if matchre("%destination", "\b(leth?d?e?r?i?e?l?)") then
     {
          var detour leth
          goto CROSSING
     }
if matchre("%destination", "\b(acen?a?m?a?c?r?a?)") then
     {
          var detour acen
          goto CROSSING
     }
if matchre("%destination", "\b(vipe?r?s?|guar?d?i?a?n?s?|leuc?r?o?s?)") then
     {
          var detour viper
          goto CROSSING
     }
if matchre("%destination", "\b(malod?o?r?o?u?s?|bucc?a?)") then
     {
          var detour bucca
          goto CROSSING
     }
if matchre("%destination", "\b(dokt?)") then
     {
          var detour dokt
          goto CROSSING
     }
if matchre("%destination", "\bsorr?o?w?s?") then
     {
          var detour sorrow
          goto CROSSING
     }
if matchre("%destination", "\bmisens?e?o?r?") then
     {
          var detour misen
          goto CROSSING
     }
if matchre("%destination", "\bbeis?s?w?u?r?m?s?") then
     {
          var detour beisswurms
          goto CROSSING
     }
if matchre("%destination", "\bston?e?c?l?a?n?") then
     {
          var detour stone
          goto CROSSING
     }
if matchre("%destination", "\bshar?d?") then goto ILITHI
if matchre("%destination", "\b(yolo?|ye{2,}t)") then
     {
          var detour yeet
          goto ILITHI
     }
if matchre("%destination", "\b(bone?w?o?l?f?|germ?i?s?h?d?i?n?)") then
     {
          var detour bone
          goto ILITHI
     }
if matchre("%destination", "\balfr?e?n?s?") then
     {
          var detour alfren
          goto ILITHI
     }
if matchre("%destination", "\b(gond?o?l?a?)") then
     {
          var detour gondola
          goto ILITHI
     }
if matchre("%destination", "\b(grani?t?e?|garg?o?y?l?e?)") then
     {
          var detour garg
          goto ILITHI
     }
if matchre("%destination", "\b(spir?e?)") then
     {
          var detour spire
          goto ILITHI
     }
if matchre("%destination", "\b(horse?c?l?a?n?)") then
     {
          var detour horse
          goto ILITHI
     }
if matchre("%destination", "\b(fayr?i?n?s?)") then
     {
          var detour fayrin
          goto ILITHI
     }
if matchre("%destination", "\b(steel?c?l?a?w?)") then
     {
          var detour steel
          goto ILITHI
     }
if matchre("%destination", "\b(cori?k?s?)") then
     {
          var detour corik
          goto ILITHI
     }
if matchre("%destination", "\b(ada?n?f?)") then
     {
          var detour adan'f
          goto ILITHI
     }
if matchre("%destination", "\b(ylo?n?o?)") then
     {
          var detour ylono
          goto ILITHI
     }
if matchre("%destination", "\b(wyve?r?n?)") then
     {
          var detour wyvern
          goto ILITHI
     }
if matchre("%destination", "\b(cara?v?a?n?s?a?r?y?)") then
     {
          var detour caravansary
          goto THERENGIA
     }
if matchre("%destination", "\b(rive?r?h?a?v?e?n?|have?n?)") then
     {
          var detour haven
          goto THERENGIA
     }
if matchre("%destination", "\b(ross?m?a?n?s?)") then
     {
          var detour rossman
          goto THERENGIA
     }
if matchre("%destination", "\b(ther?e?n?b?o?r?o?u?g?h?)") then
     {
          var detour theren
          goto THERENGIA
     }
if matchre("%destination", "\b(lang?e?n?f?i?r?t?h?)") then
     {
          var detour lang
          goto THERENGIA
     }
if matchre("%destination", "\b(el'?b?a?i?n?s?|elb?a?i?n?s?)") then
     {
	      var detour el'bain
		  goto THERENGIA
	 }
if matchre("%destination", "\b(raka?s?h?)") then
     {
          var detour rakash
          goto THERENGIA
     }
if matchre("%destination", "\bthro?n?e?") then
     {
          var detour throne
          goto THERENGIA
     }
if matchre("%destination", "\b(musp?a?r?i?)") then
     {
          var detour muspari
          goto THERENGIA
     }
if matchre("%destination", "\b(forn?s?t?e?d?)") then
     {
          var detour fornsted
          goto THERENGIA
     }
if matchre("%destination", "\b(hvar?a?l?)") then
     {
          var detour hvaral
          goto THERENGIA
     }
if matchre("%destination", "\b(oasi?s?|haize?n?|yeehar?)") then
     {
          var detour oasis
          goto THERENGIA
     }
if matchre("%destination", "\b(zaul?f?u?n?g?)") then
     {
          var detour zaulfung
          goto THERENGIA
     }
if matchre("%destination", "\b(aing?h?a?z?a?l?)") then
     {
          var detour ain
          goto FORD
     }
if matchre("%destination", "\b(rave?n?s?)") then
     {
          var detour raven
          goto FORD
     }
if matchre("%destination", "\b(hib?a?r?n?h?v?i?d?a?r?|out?e?r?)") then
     {
          var detour outer
          goto FORD
     }
if matchre("%destination", "\b(inne?r?)") then
     {
          var detour inner
          goto FORD
     }
if matchre("%destination", "\b(boar?c?l?a?n?)") then goto FORD
if matchre("%destination", "\b(aes?r?y?|sur?l?a?e?n?i?s?)") then
    {
            var detour aesry
            goto ILITHI
    }
if matchre("%destination", "\b(mri?s?s?)") then
    {
            var detour mriss
            goto THERENGIA
    }
if matchre("%destination", "\b(merk?r?e?s?h?|kre?s?h?)") then
    {
            var detour merk
            goto THERENGIA
    }
if matchre("%destination", "\b(tais?g?a?t?h?)") then
    {
            var detour ratha
            if ("$zoneid" == "150") then
                {
                    gosub AUTOMOVE 2
                    var ToRatha 1
                    gosub JOINLOGIC
                    gosub AUTOMOVE 398
                    goto ARRIVED
                }
    }
if matchre("%destination", "\b(har?a?j?a?a?l?)") then
    {
            var detour hara
            goto THERENGIA
    }
if matchre("%destination", "\b(rath?a?)") then
    {
            var detour ratha
            if ("$zoneid" == "150") then
                {
                    gosub AUTOMOVE 2
                    var ToRatha 1
                    gosub JOINLOGIC
                    gosub AUTOMOVE 252
                    goto ARRIVED
                }
            goto CROSSING
    }
if (("$zoneid" == "150") && ("$game" != "DRF") && ("%detour" != "ratha")) then
    {
            gosub AUTOMOVE 2
            var ToRatha 0
            gosub JOINLOGIC
            gosub AUTOMOVE 2
            goto cheatstart
    }
if matchre("%destination", "\b(fan?g?|cov?e?)") then
    {
            var detour fang
            goto CROSSING
    }
goto NODESTINATION

AESRY_LONG:
echo
echo ** NO SHORTCUT TO AESRY IN TF - TAKING LONG ROUTE
echo
if ("$zoneid" == "90") then goto AESRY_LONG_2
var detour aesry
gosub INFO_CHECK
if %lirums < 300 then goto NOCOIN
if ("$zoneid" == "67") then gosub AUTOMOVE east
gosub AUTOMOVE portal
pause 0.2
put go meeting portal
pause 0.5
pause 0.3
gosub AUTOMOVE 2
var ToRatha 1
gosub JOINLOGIC
AESRY_LONG_2:
pause 0.1
gosub AUTOMOVE 234
gosub FERRYLOGIC
goto ARRIVED

# TRAVEL
CROSSING:
var label CROSSING
if (matchre("$game", "(?i)DRX") && (%portal == 1)) then
     {
          if (matchre("$zoneid", "\b(30|40|47|67|99|107|116)\b") && (%ported == 0)) then gosub PORTAL_TIME
     }
## IF IN RATHA - HEAD BACK TO MAINLAND
if (("$zoneid" == "90") && !matchre("%destination", "\b(rath?a?|aesr?y?|hara|taisg?a?t?h?|ross?m?a?n?s?|rive?r?h?a?v?e?n?|have?n?|ther?e?n?b?o?r?o?u?g?h?|lang?e?n?f?i?r?t?h?|musp?a?r?i?|forn?s?t?e?d?|hvar?a?l?|oasi?s?|haize?n?|yeehar?|zaul?f?u?n?g?)")) then
    {
          if (matchre("$game", "(?i)DRX") && (%portal == 1)) then
               {
                    if (matchre("$zoneid", "\b(1|30|40|47|67|90|99|107|116)\b") && (%ported == 0)) then gosub PORTAL_TIME
               }
## TAKE MAMMOTHS FROM RATHA - TO FC - THEN BACK TO MAINLAIND (ACENAMACRA)
        var ToRatha 0
        gosub AUTOMOVE 24
        pause 0.5
        put go rocks
        pause
        gosub JOINLOGIC
        pause
        gosub JOINLOGIC
        gosub AUTOMOVE 2
    }
## IF IN RATHA AND GOING TO RIVERHAVEN/THEREN AREA - TAKE THE KREE'LA
     if (("$zoneid" == "90") && !matchre("%destination", "\b(rath?a?|aesr?y?|hara|taisg?a?t?h?)")) then
          {
               if matchre("%destination", "\b(ross?m?a?n?s?|rive?r?h?a?v?e?n?|have?n?|ther?e?n?b?o?r?o?u?g?h?|lang?e?n?f?i?r?t?h?|musp?a?r?i?|forn?s?t?e?d?|hvar?a?l?|oasi?s?|haize?n?|yeehar?|zaul?f?u?n?g?)\b") then
                    {
                         gosub AUTOMOVE 1
                         gosub FERRYLOGIC
                    }
               gosub AUTOMOVE 2
               gosub FERRYLOGIC
          }
if ("$zoneid" == "48") then
     {
          gosub AUTOMOVE 1
          gosub FERRYLOGIC
          pause
     }
if matchre("$zonename", "(Hara'jaal|Mer'Kresh|M'Riss)") then
     {
          var backuplabel CROSSING
          var backupdetour %detour
          var detour mriss
          var tomainland 1
          goto QITRAVEL
     }
if (("$zoneid" == "150") && !matchre("%destination", "\b(rath?a?|acen?e?m?a?c?r?a?|haraj?a?a?l?)")) then
     {
         gosub AUTOMOVE 85
         pause 0.1
         send go exit portal
         pause 0.5
         pause 0.2
     }
if ("$zoneid" == "35") then
     {
          gosub INFO_CHECK
          if (%lirums < 240) then goto NOCOIN
          gosub AUTOMOVE 166
          gosub FERRYLOGIC
          pause
     }
if ("$zoneid" == "7a") then gosub AUTOMOVE NTR
if ("$zoneid" == "2") then gosub AUTOMOVE cross
if ("$zoneid" == "1a") then gosub AUTOMOVE cross
if ("$zoneid" == "2a") then gosub AUTOMOVE cross
if (("$zoneid" == "47") && (matchre("$game", "(?i)DRX") && (%portal == 1) && (%ported == 0))) then gosub PORTAL_TIME
if (("$zoneid" == "47") && ($Athletics.Ranks >= %muspari.shortcut)) then gosub VELAKA_SHORTCUT
if ("$zoneid" == "47") then
     {
          gosub AUTOMOVE 117
          gosub FERRYLOGIC
          pause
     }
if ("$zoneid" == "41") then
     {
          gosub AUTOMOVE 53
          pause 0.5
          put east
          waitforre ^Just when it seems
          pause
          # put #mapper reset
     }
if ("$zoneid" == "42") then gosub AUTOMOVE 2
if ("$zoneid" == "59") then gosub AUTOMOVE 12
if ("$zoneid" == "114") then
     {
          gosub INFO_CHECK
          if (%dokoras < 120) then goto NOCOIN
          gosub AUTOMOVE 1
          gosub FERRYLOGIC
          send go oak doors
          pause
     }
if (("$zoneid" == "113") && ("$roomid" == "1")) then gosub AUTOMOVE 5
if ("$zoneid" == "40a") then gosub AUTOMOVE 125
if (matchre("$game", "(?i)DRX") && (%portal == 1)) then
     {
          if (matchre("$zoneid", "\b(1|30|40|47|67|90|99|107|116)\b") && (%ported == 0)) then gosub PORTAL_TIME
     }
if (("$zoneid" == "40") && ($Athletics.Ranks >= %rossmanSouth)) then gosub AUTOMOVE 213
if (("$zoneid" == "40") && ($Athletics.Ranks < %rossmanSouth)) then
     {
          echo ** Athletics NOT high enough for Jantspyre - Taking Ferry!
          gosub INFO_CHECK
          if (%lirums < 140) then goto NOCOIN
          gosub AUTOMOVE 36
          gosub FERRYLOGIC
     }
if ("$zoneid" == "34a") then gosub AUTOMOVE 134
if ("$zoneid" == "34") then
     {
          if (($roomid > 120) && ($roomid < 153)) then
               {
                    gosub AUTOMOVE 121
                    if matchre("$roomdesc", "pair of ropes tied to trees") then
                         {
                              gosub STOWING
                              send climb rope
                              pause 0.5
                              gosub SHUFFLE_SOUTH
                         }
               }
          gosub AUTOMOVE 15
     }
if ("$zoneid" == "33a") then gosub AUTOMOVE 46
if ("$zoneid" == "33") then gosub AUTOMOVE 1
if ("$zoneid" == "32") then gosub AUTOMOVE 1
if ("$zoneid" == "31") then gosub AUTOMOVE 1
if (matchre("$game", "(?i)DRX") && (%portal == 1)) then
     {
          if (matchre("$zoneid", "\b(1|30|40|47|67|90|99|107|116)\b") && (%ported == 0)) then gosub PORTAL_TIME
     }
if ("$zoneid" == "30") then
     {
          ### CHECK HERE TO MAKE SURE BURDEN IS NOT TOO HIGH AT LOWER RANKS
          if ((($Athletics.Ranks < 170) && (%burden > 2)) || (($Athletics.Ranks < 190) && (%burden > 3))) then
               {
                    echo * BURDEN TOO HIGH FOR FALDESU RIVER @ CURRENT RANKS!
                    goto FALDESU_FERRY
               }
          if ($Athletics.Ranks >= %faldesu) then goto CROSSING_1
     }
if ("$zoneid" != "30") then goto CROSSING_1
if ($Athletics.Ranks >= %faldesu) then goto CROSSING_1
FALDESU_FERRY:
     {
          if ("$zoneid" != "30") then goto CROSSING_1
          echo
          echo ** Athletics (+burden) NOT high enough for Faldesu River - Taking Ferry!
          echo
          gosub INFO_CHECK
          if (%lirums < 140) then goto NOCOIN
          gosub AUTOMOVE 103
          pause
          gosub FERRYLOGIC
     }
CROSSING_1:
if (("$zoneid" == "30") && ($Athletics.Ranks >= %faldesu)) then
     {
          echo ** Athletics high enough for Faldesu - Taking River!
          gosub AUTOMOVE 203
          gosub AUTOMOVE 79
     }
if ("$zoneid" == "14c") then gosub FALDESU_SOUTH
if ("$zoneid" == "14c") then gosub FALDESU_SOUTH
if ("$zoneid" == "14c") then gosub FALDESU_SOUTH
if ("$zoneid" == "127") then gosub AUTOMOVE 510
if ("$zoneid" == "126") then gosub AUTOMOVE 49
if ("$zoneid" == "116") then gosub AUTOMOVE 3
if ("$zoneid" == "123") then gosub AUTOMOVE 175
if ("$zoneid" == "67a") then gosub AUTOMOVE shard
if ("$zoneid" == "69") then gosub AUTOMOVE 1
if ("$zoneid" == "68a") then gosub AUTOMOVE 29
if ("$zoneid" == "68b") then gosub AUTOMOVE 44
if ("$zoneid" == "68") then
     {
     if (matchre("$roomname", "(Blackthorn Canyon|Corik's Wall|Stormfells|Shadow's Reach|Reach Forge|Darkling Wood, Trader Outpost)") || (($roomid > 67) && ($roomid < 75))) then
          {
               gosub AUTOMOVE 68
               gosub AUTOMOVE 65
               gosub AUTOMOVE 62
               pause 0.1
          }
     if ($Athletics.Ranks > 250) then
          {
               gosub AUTOMOVE 2
               pause 0.2
               put climb wall
               wait
               pause 0.4
          }
     }
if (("$zoneid" == "68") && matchre("%shardCitizen", "(?i)yes")) then
     {
          gosub AUTOMOVE 1
          gosub AUTOMOVE 135
     }
if (("$zoneid" == "68") && matchre("%shardCitizen", "(?i)no")) then gosub AUTOMOVE 15
if (matchre("$game", "(?i)DRX") && (%portal == 1)) then
     {
          if (matchre("$zoneid", "\b(1|30|40|47|67|90|99|107|116)\b") && (%ported == 0)) then gosub PORTAL_TIME
     }
if (("$zoneid" == "67") && ("$guild" == "Thief")) then
     {
          gosub AUTOMOVE 566
          gosub AUTOMOVE 23
     }
if ("$zoneid" == "67") then gosub AUTOMOVE 132
if (("$zoneid" == "66") && ("$guild" == "Thief") && ($Athletics.Ranks >= %underGondola) && ($Athletics.Ranks < 600)) then
     {
          put khri flight harrier
          pause
     }
if (("$zoneid" == "66") && ("$guild" == "Ranger") && ($Athletics.Ranks >= %underGondola)) then
     {
          put prep athletic 12
          pause 8
          put cast
          pause 0.2
     }
if (("$zoneid" == "66") && ($Athletics.Ranks >= %underGondola)) then gosub AUTOMOVE 317
if (("$zoneid" == "66") && ($Athletics.Ranks < %underGondola)) then
     {
          echo ** Athletics NOT high enough for underSegoltha - Taking Gondola!
          gosub AUTOMOVE 156
          pause
          gosub FERRYLOGIC
     }
if ("$zoneid" == "1a") then gosub AUTOMOVE cross
if ("$zoneid" == "63") then gosub AUTOMOVE 112
if ("$zoneid" == "65") then gosub AUTOMOVE 44
if ("$zoneid" == "62") then gosub AUTOMOVE 100
if ("$zoneid" == "112") then gosub AUTOMOVE 112
if ("$zoneid" == "58") then gosub AUTOMOVE leth
if (("$zoneid" == "60") && matchre("%detour", "(leth|acen|taipa|LETH|ACEN|ratha|fang)")) then gosub AUTOMOVE 57
if (("$zoneid" == "61") && matchre("%detour", "(leth|acen|taipa|LETH|ACEN|ratha|fang)")) then
     {
          if ("%detour" == "acen") then
               {
                    gosub AUTOMOVE 178
                    gosub AUTOMOVE 47
               }
          if ("%detour" == "taipa") then
               {
                    gosub AUTOMOVE 126
                    gosub AUTOMOVE 27
               }
## PRIME USER (NON-PREMIUM) TO RATHA: TRAVEL TO ACENAMACRA/MAMMOTH TO FC/MAMMOTH TO RATHA
          if ("%detour" == "ratha") then
               {
                    gosub AUTOMOVE 178
                    gosub AUTOMOVE 47
                    var ToRatha 1
                    gosub JOINLOGIC
                    pause
                    gosub JOINLOGIC
                    gosub AUTOMOVE 252
                    goto ARRIVED
               }
          if ("%detour" == "leth") then gosub AUTOMOVE 18
          goto ARRIVED
     }
if ("$zoneid" == "61") then gosub AUTOMOVE 115
if ("$zoneid" == "50") && matchre("%destination", "\b(haizen|yeehar|oasis|hvaral|forns?t?e?d?|elbain|el'bain|alfren|rossm?a?n?|viper|leucro?|misens|beiss|sorrow|ushnish|caravan?s?a?r?y?|dokt|west|stone|knife|wolf|tiger|dirge|arthe|kaerna?|river|haven|riverhaven|theren|lang|throne|zaulfu?n?|rakash|muspar?i?|zaulfung|cross?|crossing)") && ($Athletics.Ranks > %segoltha) then gosub SEGOLTHA_NORTH
if ("$zoneid" == "50") then gosub SEGOLTHA_SOUTH
if (("$zoneid" == "60") && ("%detour" == "alfren")) then
          {
          gosub AUTOMOVE 42
          goto ARRIVED
          }
if (("$zoneid" == "60") && matchre("%detour", "(leth|acen|taipa|LETH|ACEN|ratha|fang|ain|raven|outer|inner|adan'f|corik|steel|ylono|fayrin|horse|spire)")) then gosub AUTOMOVE leth
if (("$zoneid" == "60") && ("$guild" == "Thief")) then
          {
              if ($Athletics.Ranks >= %underSegoltha) then
                  {
                      gosub AUTOMOVE 107
                      if ("$zoneid" == "120") then gosub AUTOMOVE 107
                      pause 0.3
                      gosub AUTOMOVE cross
                      pause 0.1
                      if ("$zoneid" == "1a") then gosub AUTOMOVE cross
                  }
          }
if (("$zoneid" == "60") && ($Athletics.Ranks >= %segoltha)) then gosub AUTOMOVE 108
# Crossing | Arthe Dale | West Gate | Tiger Clan | Wolf Clan | Dokt | Knife Clan | Kaerna
# Stone Clan | Caravansary | Dirge | Ushnish | Sorrow's | Beisswurms | Misenseor |Leucros
# Vipers | Malodorous Buccas | Alfren's Ferry | Leth Deriel  | Ilaya Taipa | Acenemacra
# Riverhaven | Rossmans | Langenfirth | El'Bains | Zaulfun | Therenborough
if ("$zoneid" == "50") && matchre("%destination", "\b(haizen|yeehar|oasis|hvaral|forns?t?e?d?|elbain|el'bain|alfren|rossm?a?n?|viper|leucro?|misens|beiss|sorrow|ushnish|caravan?s?a?r?y?|dokt|west|stone|knife|wolf|tiger|dirge|arthe|kaerna?|river|haven|riverhaven|theren|lang|throne|zaulfu?n?|rakash|muspar?i?|zaulfung|cross?|crossing)") && ($Athletics.Ranks > %segoltha) then gosub SEGOLTHA_NORTH
if ("$zoneid" == "50") then gosub SEGOLTHA_SOUTH
if (("$zoneid" == "60") && ($Athletics.Ranks < %segoltha)) then
          {
              echo ** Athletics NOT high enough for Segoltha - Taking Ferry!
              gosub INFO_CHECK
              if (%kronars < 40) then goto NOCOIN
              gosub AUTOMOVE 42
              if ("$roomid" != "42") then gosub AUTOMOVE 42
              if ("$roomid" != "42") then gosub AUTOMOVE 42
              pause
              gosub FERRYLOGIC
          }
if "$zoneid" == "6"  then gosub AUTOMOVE cross
if ("$zoneid" == "4a") then gosub AUTOMOVE 15
if ("$zoneid" == "4b") then gosub AUTOMOVE 1
if (("$zoneid" == "4") && (("%detour" == "dokt"))) then
          {
              gosub AUTOMOVE dok
              goto ARRIVED
          }
if (("$zoneid" == "4") && matchre("%destination", "\bwest")) then
          {
               gosub AUTOMOVE 16
               goto ARRIVED
          }
if "$zoneid" == "4"  then gosub AUTOMOVE 14
if ("$zoneid" == "13") then gosub AUTOMOVE 71
if ("$zoneid" == "12a") then gosub AUTOMOVE 60
if ("$zoneid" == "10") then gosub AUTOMOVE 116
if ("$zoneid" == "9b") then gosub AUTOMOVE 9
if ("$zoneid" == "14b") then gosub AUTOMOVE 217
if ("$zoneid" == "11") then gosub AUTOMOVE 2
if (("$zoneid" == "1") && matchre("%detour", "(arthe|dirge|kaerna|stone|misen|sorrow|fist|beisswurms|bucca|viper)")) then
     {
          if ($invisible == 1) then
               {
                    gosub AUTOMOVE N gate
                    gosub AUTOMOVE NTR
                    goto CROSSING_2
               }
          gosub AUTOMOVE 171
     }
CROSSING_2:
if (("$zoneid" == "7") && matchre("%detour", "(arthe|dirge|kaerna|stone|misen|sorrow|fist|beisswurms|bucca|viper)")) then
     {
         if matchre("%destination", "(?i)ushnish") then
             {
               gosub AUTOMOVE 188
               gosub GATE_OF_SOULS
               goto ARRIVED
             }
         if ("%detour" == "dirge") then
             {
                 gosub AUTOMOVE 147
                 if ("$zoneid" == "7") then gosub AUTOMOVE 147
                 if ("$zoneid" == "13") then gosub AUTOMOVE 11
             }
         if ("%detour" == "arthe") then gosub AUTOMOVE 535
         if ("%detour" == "kaerna") then gosub AUTOMOVE 352
         if (("%detour" == "stone") && ("$zoneid" == "7")) then gosub AUTOMOVE 396
         if (("%detour" == "stone") && ("$zoneid" == "7")) then gosub AUTOMOVE 396
         if (("%detour" == "beisswurms") && ("$zoneid" == "7")) then gosub AUTOMOVE 396
         if (("%detour" == "beisswurms") && ("$zoneid" == "7")) then gosub AUTOMOVE 396
         if ("%detour" == "fist") then gosub AUTOMOVE 253
         if ("%detour" == "misen") then gosub AUTOMOVE 437
         if ("%detour" == "viper") then
             {
                 gosub AUTOMOVE 394
                 if ($Perception.Ranks > 150) then gosub AUTOMOVE 5
             }
         if matchre("(sorrow|bucca)", "%detour") then
             {
                 gosub AUTOMOVE 397
                 if ("%detour" == "sorrow") then
                       {
                            gosub AUTOMOVE 77
                            goto ARRIVED
                       }
                 if ("%detour" == "bucca") then
                       {
                            gosub AUTOMOVE 124
                            goto ARRIVED
                       }
             }
        if ("%detour" == "beisswurms") then gosub AUTOMOVE 31
         goto ARRIVED
     }
if ("$zoneid" == "7") then gosub AUTOMOVE 349
if ("$zoneid" == "7") then gosub AUTOMOVE 349
if ("$zoneid" == "8") then gosub AUTOMOVE 43
if (("$zoneid" == "1") && matchre("%detour", "(wolf|knife|tiger)")) then
     {
         gosub AUTOMOVE 172
         if matchre("%destination", "\bwest") then
               {
                    gosub AUTOMOVE 16
                    goto ARRIVED
               }
         if ("%detour" == "wolf") then gosub AUTOMOVE 126
         if ("%detour" == "knife") then gosub AUTOMOVE 459
         if ("%detour" == "tiger") then gosub AUTOMOVE 87
         goto ARRIVED
     }
if (("$zoneid" == "1") && matchre("%detour", "(leth|acen|taipa|ratha)")) then
     {
         if ("$guild" == "Thief") then
             {
                 if ($Athletics.Ranks >= %underSegoltha) then
                     {
                         gosub AUTOMOVE 650
                         gosub AUTOMOVE 23
                     }
             }
         if (($Athletics.Ranks >= %segoltha) && ("$zoneid" == "1")) then
             {
                echo ** Athletics high enough for Segoltha - Taking River!
                 gosub AUTOMOVE 476
                 gosub SEGOLTHA_SOUTH
             }
         if ("$zoneid" == "1") then
             {
                echo ** Athletics NOT high enough for Segoltha - Taking Ferry!
                 gosub INFO_CHECK
                 if %kronars < 100 then goto NOCOIN
                 gosub AUTOMOVE 236
                 gosub FERRYLOGIC
             }
         pause
         put south
         wait
         put #mapper reset
         gosub AUTOMOVE 57
         if ("%detour" == "acen") then
             {
                 gosub AUTOMOVE 178
                 gosub AUTOMOVE 47
             }
         if ("%detour" == "taipa") then
             {
                 gosub AUTOMOVE 126
                 gosub AUTOMOVE 27
             }
## PRIME USER (NON-PREMIUM) TO RATHA: TRAVEL TO ACENAMACRA/MAMMOTH TO FC/MAMMOTH TO RATHA
         if ("%detour" == "ratha") then
             {
                 gosub AUTOMOVE 178
                 gosub AUTOMOVE 47
                 var ToRatha 1
                 gosub JOINLOGIC
                 pause
                 gosub JOINLOGIC
                 send go beach
                 pause 0.5
                 gosub AUTOMOVE 252
                 goto ARRIVED
             }
         if ("%detour" == "leth") then gosub AUTOMOVE 18
     }
if ("$zoneid" == "1") then gosub AUTOMOVE 42
goto ARRIVED

ILITHI:
var label ILITHI
if (matchre("$game", "(?i)DRX") && (%portal == 1)) then
     {
          if (("$zoneid" == "1") && matchre("%detour", "(alfren|leth|bone)")) then goto ILLITHI_2
          if (matchre("$zoneid", "\b(1|30|40|47|67|90|99|107|116)\b") && (%ported == 0)) then gosub PORTAL_TIME
     }
## IF IN RATHA - HEAD BACK TO MAINLAND
if (("$zoneid" == "90") && !matchre("%destination", "\b(rath?a?|aesr?y?|hara|taisg?a?t?h?|ross?m?a?n?s?|rive?r?h?a?v?e?n?|have?n?|ther?e?n?b?o?r?o?u?g?h?|lang?e?n?f?i?r?t?h?|musp?a?r?i?|forn?s?t?e?d?|hvar?a?l?|oasi?s?|haize?n?|yeehar?|zaul?f?u?n?g?)")) then
    {
          if (matchre("$game", "(?i)DRX") && (%portal == 1)) then
               {
                    if (matchre("$zoneid", "\b(1|30|40|47|67|90|99|107|116)\b") && (%ported == 0)) then gosub PORTAL_TIME
               }
## TAKE MAMMOTHS FROM RATHA - TO FC - THEN BACK TO MAINLAIND (ACENAMACRA)
        var ToRatha 0
        gosub AUTOMOVE 24
        pause 0.5
        put go rocks
        pause
        gosub JOINLOGIC
        pause
        gosub JOINLOGIC
        gosub AUTOMOVE 2
    }
## IF IN RATHA AND GOING TO RIVERHAVEN/THEREN AREA - TAKE THE KREE'LA
     if (("$zoneid" == "90") && !matchre("%destination", "\b(rath?a?|aesr?y?|hara|taisg?a?t?h?)")) then
          {
               if matchre("%destination", "\b(ross?m?a?n?s?|rive?r?h?a?v?e?n?|have?n?|ther?e?n?b?o?r?o?u?g?h?|lang?e?n?f?i?r?t?h?|musp?a?r?i?|forn?s?t?e?d?|hvar?a?l?|oasi?s?|haize?n?|yeehar?|zaul?f?u?n?g?)\b") then
                    {
                         gosub AUTOMOVE 1
                         gosub FERRYLOGIC
                    }
               gosub AUTOMOVE 2
               gosub FERRYLOGIC
          }
ILITHI_1:
if ("$zoneid" == "127") then gosub AUTOMOVE south
if "$zoneid" == "6"  then gosub AUTOMOVE cross
if ("$zoneid" == "7a") then gosub AUTOMOVE NTR
if ("$zoneid" == "1a") then gosub AUTOMOVE cross
if ("$zoneid" == "2") then gosub AUTOMOVE cross
if ("$zoneid" == "2a") then gosub AUTOMOVE cross
if ("$zoneid" == "67a") then gosub AUTOMOVE shard
if matchre("$zonename", "(Hara'jaal|Mer'Kresh|M'Riss)") then
     {
         var backuplabel ILITHI
         var backupdetour %detour
         var detour mriss
         var tomainland 1
         goto QITRAVEL
     }
if ("$zoneid" == "48") then
     {
          if ($Athletics.Ranks >= %muspari.shortcut) then gosub VELAKA_SHORTCUT
          echo ** Athletics NOT high enough for Velaka Desert - Taking Ferry!
          gosub AUTOMOVE 1
          gosub FERRYLOGIC
          pause
     }
if ("$zoneid" == "35") then
     {
         gosub INFO_CHECK
         if %lirums < 120 then goto NOCOIN
         gosub AUTOMOVE 166
         gosub FERRYLOGIC
     }
if (("$zoneid" == "47") && (matchre("$game", "(?i)DRX") && (%portal == 1) && (%ported == 0))) then gosub PORTAL_TIME
if (("$zoneid" == "47") && ($Athletics.Ranks >= %muspari.shortcut)) then gosub VELAKA_SHORTCUT
delay 0.0001
if ("$zoneid" == "47") then
     {
         gosub AUTOMOVE 117
         gosub FERRYLOGIC
         pause 0.5
     }
if ("$zoneid" == "41") then
     {
         gosub AUTOMOVE 2
         pause 0.5
         put east
         waitforre ^Just when it seems
         pause
         put #mapper reset
     }
if ("$zoneid" == "127") then gosub AUTOMOVE south
if ("$zoneid" == "40a") then gosub AUTOMOVE 125
if (matchre("$game", "(?i)DRX") && (%portal == 1)) then
     {
          if (("$zoneid" == "1") && matchre("%detour", "(alfren|leth|bone)")) then goto ILLITHI_2
          if (matchre("$zoneid", "\b(1|30|40|47|67|90|99|107|116)\b") && (%ported == 0)) then gosub PORTAL_TIME
     }
if (("$zoneid" == "40") && ($Athletics.Ranks >= %rossmanSouth)) then gosub AUTOMOVE 213
if (("$zoneid" == "40") && ($Athletics.Ranks < %rossmanSouth)) then
     {
        echo ** Athletics NOT high enough for Jantspyre - Taking Ferry!
        gosub INFO_CHECK
        evalmath BoarNeeded ($circle * 20)
        if (%lirums < %BoarNeeded) then goto NOCOIN
        gosub AUTOMOVE 263
     }
if ("$zoneid" == "40a") then
	{
     gosub INFO_CHECK
	evalmath BoarNeeded ($circle * 20)
	if (%lirums < %BoarNeeded) then
		{
		gosub AUTOMOVE 125
		goto NOCOIN
		}
	gosub AUTOMOVE 68
	gosub JOINLOGIC
	}
if ("$zoneid" == "126") then gosub AUTOMOVE 49
if ("$zoneid" == "127") then gosub AUTOMOVE south
if ("$zoneid" == "126") then gosub AUTOMOVE 49
if (matchre("$game", "(?i)DRX") && (%portal == 1)) then
     {
          if (("$zoneid" == "1") && matchre("%detour", "(alfren|leth|bone)")) then goto ILLITHI_2
          if (matchre("$zoneid", "\b(1|30|40|47|67|90|99|107|116)\b") && (%ported == 0)) then gosub PORTAL_TIME
     }
if ("$zoneid" == "116") then gosub AUTOMOVE 3
if ("$zoneid" == "114") then
          {
              gosub INFO_CHECK
              if (%dokoras < 120) then goto NOCOIN
              gosub AUTOMOVE 4
              gosub FERRYLOGIC
              send west
              wait
          }
if ("$zoneid" == "112") then gosub AUTOMOVE 112
if ("$zoneid" == "123") then gosub AUTOMOVE 175
if ("$zoneid" == "42") then gosub AUTOMOVE 2
if ("$zoneid" == "59") then gosub AUTOMOVE 12
if ("$zoneid" == "114") then
          {
              gosub INFO_CHECK
              if (%dokoras < 120) then goto NOCOIN
              gosub AUTOMOVE 1
              gosub FERRYLOGIC
              send go oak doors
          }
if ("$zoneid" == "40a") then gosub AUTOMOVE 125
if (matchre("$game", "(?i)DRX") && (%portal == 1)) then
     {
          if (("$zoneid" == "1") && matchre("%detour", "(alfren|leth|bone)")) then goto ILLITHI_2
          if (matchre("$zoneid", "\b(1|30|40|47|67|90|99|107|116)\b") && (%ported == 0)) then gosub PORTAL_TIME
     }
if (("$zoneid" == "40") && ($Athletics.Ranks >= %rossmanSouth)) then
     {
          echo ** Athletics high enough for Jantspyre - Taking shortcut!
          gosub AUTOMOVE 213
     }
if (("$zoneid" == "40") && ($Athletics.Ranks < %rossmanSouth)) then
          {
              echo ** Athletics NOT high enough for Jantspyre - Taking Ferry!
              gosub INFO_CHECK
              if (%lirums < 140) then goto NOCOIN
              gosub AUTOMOVE 36
              gosub FERRYLOGIC
          }
if ("$zoneid" == "34a") then gosub AUTOMOVE 134
if ("$zoneid" == "34") then
     {
          if (($roomid > 120) && ($roomid < 153)) then
               {
                    gosub AUTOMOVE 121
                    if matchre("$roomdesc", "pair of ropes tied to trees") then
                         {
                              gosub STOWING
                              send climb rope
                              pause 0.5
                              gosub SHUFFLE_SOUTH
                         }
               }
          gosub AUTOMOVE 15
     }
if ("$zoneid" == "33a") then gosub AUTOMOVE 46
if ("$zoneid" == "33") then gosub AUTOMOVE 1
if ("$zoneid" == "32") then gosub AUTOMOVE 1
if ("$zoneid" == "31") then gosub AUTOMOVE 1
if (matchre("$game", "(?i)DRX") && (%portal == 1)) then
     {
          if (("$zoneid" == "1") && matchre("%detour", "(alfren|leth|bone)")) then goto ILLITHI_2
          if (matchre("$zoneid", "\b(1|30|40|47|67|90|99|107|116)\b") && (%ported == 0)) then gosub PORTAL_TIME
     }
if ("$zoneid" == "30") then
     {
          ### CHECK HERE TO MAKE SURE BURDEN IS NOT TOO HIGH AT LOWER RANKS
          if ((($Athletics.Ranks < 170) && (%burden > 2)) || (($Athletics.Ranks < 190) && (%burden > 3))) then
               {
                    echo * BURDEN TOO HIGH FOR FALDESU RIVER @ CURRENT RANKS!
                    goto ILLITHI_FERRY
               }
          if ($Athletics.Ranks >= %faldesu) then goto ILLITHI_11
     }
if ("$zoneid" != "30") then goto ILLITHI_11
if ($Athletics.Ranks >= %faldesu) then goto ILLITHI_11
ILLITHI_FERRY:
if ("$zoneid" == "30") then
          {
              echo ** Athletics NOT high enough for Faldesu - Taking Ferry!
              gosub INFO_CHECK
              if (%lirums < 140) then goto NOCOIN
              gosub AUTOMOVE 103
              pause
              gosub FERRYLOGIC
          }
ILLITHI_11:
if (("$zoneid" == "30") && ($Athletics.Ranks >= %faldesu)) then
          {
              echo ** Athletics high enough for Faldesu - Taking River!
              gosub AUTOMOVE 203
              gosub AUTOMOVE 79
          }
if ("$zoneid" == "14c") then gosub FALDESU_SOUTH
if ("$zoneid" == "14c") then gosub FALDESU_SOUTH
if ("$zoneid" == "14c") then gosub FALDESU_SOUTH
if ("$zoneid" == "13") then gosub AUTOMOVE 71
if ("$zoneid" == "12a") then gosub AUTOMOVE 60
if ("$zoneid" == "4a") then gosub AUTOMOVE 15
if ("$zoneid" == "4") then gosub AUTOMOVE 14
if ("$zoneid" == "8") then gosub AUTOMOVE 43
if ("$zoneid" == "10") then gosub AUTOMOVE 116
if ("$zoneid" == "9b") then gosub AUTOMOVE 9
if ("$zoneid" == "14b") then gosub AUTOMOVE 217
if ("$zoneid" == "11") then gosub AUTOMOVE 2
if ("$zoneid" == "7") then gosub AUTOMOVE 349
if ("$zoneid" == "7") then gosub AUTOMOVE 349
if ("$zoneid" == "7") then gosub AUTOMOVE 349
if ("$zoneid" == "112") then gosub AUTOMOVE 112
if (matchre("$game", "(?i)DRX") && (%portal == 1)) then
     {
          if (("$zoneid" == "1") && matchre("%detour", "(alfren|leth|bone)")) then goto ILLITHI_2
          if (matchre("$zoneid", "\b(1|30|40|47|67|90|99|107|116)\b") && (%ported == 0)) then gosub PORTAL_TIME
     }
ILLITHI_2:
if ("$zoneid" == "1") then
          {
              if ("$guild" == "Thief") then
                  {
                      if ($Athletics.Ranks >= %underSegoltha) then
                          {
                              gosub AUTOMOVE 650
                              gosub AUTOMOVE 23
                          }
                  }
              if (($Athletics.Ranks >= %segoltha) && ("$zoneid" == "1")) then
                  {
                      echo ** Athletics High enough for Segoltha! Taking shortcut!
                      gosub AUTOMOVE 476
                      gosub SEGOLTHA_SOUTH
                  }
              if ("$zoneid" == "1") then
                  {
                      echo ** Athletics not high enough for Segoltha - Taking ferry!
                      gosub INFO_CHECK
                      if %kronars < 100 then goto NOCOIN
                      gosub AUTOMOVE 236
                      gosub FERRYLOGIC
                  }
              pause
              put south
              wait
              put #mapper reset
          }
if ("$zoneid" == "50") && matchre("(haizen|yeehar|oasis|hvaral|forns?t?e?d?|elbain|el'bain|alfren|rossm?a?n?|viper|leucro?|misens|beiss|sorrow|ushnish|caravan?s?a?r?y?|dokt|west|stone|knife|wolf|tiger|dirge|arthe|kaerna?|river|haven|riverhaven|theren|lang|throne|zaulfu?n?|rakash|muspar?i?|zaulfung|cross?|crossing)", "%destination") && ($Athletics.Ranks > %segoltha) then gosub SEGOLTHA_NORTH
if ("$zoneid" == "50") then gosub SEGOLTHA_SOUTH
if ("$zoneid" == "1a") then gosub AUTOMOVE 23
if (("$zoneid" == "67") && matchre("alfren", "%detour")) then
          {
              goto CROSSING
          }
if (("$zoneid" == "62") && matchre("alfren", "%detour")) then
          {
              gosub AUTOMOVE leth
          }
if (("$zoneid" == "61") && matchre("alfren", "%detour")) then
          {
              gosub AUTOMOVE cross
              pause 0.2
          }
if (("$zoneid" == "60") && matchre("alfren", "%detour")) then
          {
              gosub AUTOMOVE 42
              goto ARRIVED
          }
if ("$zoneid" == "60") then gosub AUTOMOVE 57
if ("$zoneid" == "112") then gosub AUTOMOVE 112
if ("$zoneid" == "59") then gosub AUTOMOVE 12
if ("$zoneid" == "58") then gosub AUTOMOVE 2
if ("$zoneid" == "61") then gosub AUTOMOVE 130
if ("$zoneid" == "63") then gosub AUTOMOVE 112
if (("$zoneid" == "62") && matchre("gondola", "%detour")) then
          {
              gosub AUTOMOVE 2
              goto ARRIVED
          }
if (("$zoneid" == "62") && matchre("(bone|germ)", "%detour")) then
          {
              gosub AUTOMOVE 101
              goto ARRIVED
          }
if (("$zoneid" == "62") && ("$guild" == "Thief") && ($Athletics.Ranks >= %underGondola) && ($Athletics.Ranks < 600)) then
          {
               put khri flight harrier
               pause
          }
if (("$zoneid" == "62") && ("$guild" == "Ranger") && ($Athletics.Ranks >= %underGondola)) then
          {
               put prep athlet 10
               pause 10
               put cast
          }
if (("$zoneid" == "62") && ($Athletics.Ranks >= %underGondola)) then
          {
             echo ** Athletics high enough for underGondola! Taking shortcut!
             gosub AUTOMOVE 41
             pause
             if matchre("$game", "(?i)DRF") then
                   {
                        gosub MOVE sw
                        gosub MOVE sw
                        gosub MOVE s
                        gosub AUTOMOVE 153
                        goto ILITHI_3
                   }
             if matchre("$game", "(?i)DR") then
                   {
                        gosub MOVE sw
                        gosub MOVE sw
                        pause 0.2
                        put go blockade
                        pause 0.8
                        pause 0.1
                        gosub AUTOMOVE 153
                   }
          }
if (("$zoneid" == "62") && ("$game"= "DRF")) then
          {
              gosub AUTOMOVE 41
              gosub MOVE sw
              gosub MOVE sw
              gosub MOVE s
              pause 0.5
              gosub AUTOMOVE 2
              gosub FERRYLOGIC
              goto ILITHI_3
          }
if (("$zoneid" == "62") && matchre("$game", "(?i)DR")) then
          {
              gosub AUTOMOVE 41
              gosub MOVE sw
              gosub MOVE sw
              pause 0.1
              put go blockade
              pause 0.8
              pause 0.1
              gosub AUTOMOVE 2
              gosub FERRYLOGIC
              goto ILITHI_3
          }
ILITHI_3:
if (("$zoneid" == "69") && matchre("%detour", "ye{2,}t")) then
          {
              echo
              echo ############################
              echo *** CONGRATULATIONS!!!!
              echo *** SECRET YOLO OPTION SELECTED!
              echo *** SPECIAL SURPRISE AHEAD!!!!!!
              echo ############################
              echo
              pause 0.9
              pause 0.3
              gosub AUTOMOVE 530
              echo
              echo #############
              echo *** YEEEEEEEEEET!!!!!
              echo #############
              echo
              goto ARRIVED
          }
if (("$zoneid" == "69") && matchre("(horse|spire|wyvern)", "%detour")) then
          {
              if ("%detour" == "horse") then gosub AUTOMOVE 199
              if ("%detour" == "spire") then gosub AUTOMOVE 334
              if ("%detour" == "wyvern") then gosub AUTOMOVE 15
              goto ARRIVED
          }
if ("$zoneid" == "65") then gosub AUTOMOVE 1
if (("$zoneid" == "66") && ("%detour" == "garg")) then
          {
              gosub AUTOMOVE 167
              goto ARRIVED
          }
#if (("$zoneid" == "69") && ("%shardCitizen" == "yes")) then gosub AUTOMOVE 31
if ("$zoneid" == "69") then
     {
          if ($Athletics.Ranks > 350) then
               {
                    echo ** Athletics high enough for Shard Walls! Climbing Wall
                    gosub AUTOMOVE 10
                    pause 0.01
                    send climb wall
                    pause 0.5
                    pause 0.3
                    gosub MOVE north
                    gosub MOVE climb ladder
                    pause 0.001
               }
     }
if ("$zoneid" == "69") then gosub AUTOMOVE 1
if ("$zoneid" == "68a") then gosub AUTOMOVE 29
if (("$zoneid" == "68") && matchre("(adan'f|corik)", "%detour")) then
          {
              if ("%detour" == "corik") then gosub AUTOMOVE 114
              if ("%detour" == "adan'f") then gosub AUTOMOVE 29
              goto ARRIVED
          }
if ("$zoneid" == "68") then
     {
          if ($Athletics.Ranks > 350) then
               {
                    echo ** Athletics high enough for Shard Walls! Climbing Wall
                    gosub AUTOMOVE 2
                    pause 0.01
                    send climb wall
                    pause 0.5
                    pause 0.3
               }
     }
if (("$zoneid" == "68") && ("$guild" == "Thief")) then gosub AUTOMOVE 225
if ("$zoneid" == "67a") then gosub AUTOMOVE shard
if (("$zoneid" == "68") && matchre("%shardCitizen", "(?i)yes")) then gosub AUTOMOVE 1
if (("$zoneid" == "68") && matchre("%shardCitizen", "(?i)no")) then gosub AUTOMOVE 15
if (("$zoneid" == "67") && matchre("alfren", "%detour")) then
          {
              goto CROSSING
          }
if (("$zoneid" == "67") && ("$guild" == "Thief") && matchre("%detour", "(steel|ylono|fayrin|horse|spire|wyvern)")) then
          {
              gosub AUTOMOVE 566
              gosub AUTOMOVE 23
          }
if (("$zoneid" == "67") && ("$guild" == "Thief") && matchre("(adan'f|corik)", "%detour")) then
          {
              gosub AUTOMOVE 228
              pause
              send climb embrasure
              wait
              if ("%detour" == "adan'f") then gosub AUTOMOVE 29
              if ("%detour" == "corik") then gosub AUTOMOVE 114
          }
if (("$zoneid" == "67") && matchre("%detour", "ye{2,}t")) then gosub AUTOMOVE west
if (("$zoneid" == "67") && matchre("%detour", "(steel|ylono|fayrin|horse|spire|wyvern|corik|adan'f)")) then gosub AUTOMOVE 132
if (("$zoneid" == "66") && matchre("%detour", "(steel|fayrin|ylono|corik|adan'f)")) then
          {
              if ("%detour" == "steel") then gosub AUTOMOVE 99
              if ("%detour" == "fayrin") then gosub AUTOMOVE 127
              if ("%detour" == "ylono") then gosub AUTOMOVE 495
              if matchre("(corik|adan'f)", "%detour") then
                  {
                      if ("$guild" == "Thief") then
                          {
                              gosub AUTOMOVE 66
                              put go trail
                              pause 0.5
                              gosub MOVE south
                              gosub MOVE south
                              pause 0.2
                              gosub AUTOMOVE shard
                              gosub AUTOMOVE 228
                              pause
                              send climb embrasure
                              wait
                          }
                      if (!matchre("%shardCitizen", "(?i)yes") && ("$zoneid" == 66)) then
                          {
                              gosub AUTOMOVE 216
                              gosub AUTOMOVE 230
                          }
                      if (matchre("%shardCitizen", "(?i)yes") && ("$zoneid" == 66) && ($roomid > 54)) then
                          {
                              gosub AUTOMOVE 215
                              gosub AUTOMOVE 230
                          }
                      if ("$zoneid" == "66") then gosub AUTOMOVE 3
                      if ("%detour" == "adan'f") then gosub AUTOMOVE 29
                      if ("%detour" == "corik") then gosub AUTOMOVE 114
                  }
              goto ARRIVED
          }
if (("$zoneid" == "66") && matchre("%detour", "(horse|spire|wyvern)")) then
          {
              gosub AUTOMOVE 217
              if ("%detour" == "horse") then gosub AUTOMOVE 199
              if ("%detour" == "spire") then gosub AUTOMOVE 334
              if ("%detour" == "wyvern") then gosub AUTOMOVE 15
          }
if ("$zoneid" == "66") then
     {
          if ($Athletics.Ranks > 350) then
          {
               echo ** Athletics high enough for Shard Walls! Climbing Wall
               gosub AUTOMOVE 70
               pause 0.01
               send climb wall
               pause 0.5
               pause 0.3
               gosub MOVE east
               gosub MOVE climb ladder
               pause 0.001
          }
     }
if (("$zoneid" == "66") && ("$guild" == "Thief")) then
          {
               gosub AUTOMOVE 66
               gosub MOVE go trail
               pause 0.2
               gosub MOVE south
               gosub MOVE south
               pause 0.2
               gosub AUTOMOVE shard
          }
if ("$zoneid" == "66a") then gosub AUTOMOVE shard
if (matchre("%shardCitizen", "(?i)yes") && ("$zoneid" == 66) && ($roomid > 54)) then gosub AUTOMOVE 215
if ("$zoneid" == "66") then gosub AUTOMOVE 216
if ("$zoneid" == "67") then gosub AUTOMOVE 81
if (("$zoneid" == "67") && matchre("gondola", "%detour")) then
          {
              gosub AUTOMOVE north
              gosub AUTOMOVE platform
              goto ARRIVED
          }
if matchre("aesry", "%detour") then
          {
              if matchre("$game", "DRF") then goto AESRY_LONG
              gosub AUTOMOVE 734
              gosub JOINLOGIC
              gosub AUTOMOVE 113
          }
if (("$zoneid" == "69") && matchre("%detour", "ye{2,}t")) then
          {
              echo
              echo ######################
              echo * CONGRATULATIONS!
              echo * SECRET YOLO OPTION SELECTED!
              echo * YOU FOUND THE TOP SECRET MISSION
              echo * ABORT NOW IF YE ARE SCARED
              echo ######################
              echo
              pause
              gosub AUTOMOVE 530
              echo
              echo ######################
              echo * ABORT NOW IF YE ARE SCARED
              echo ######################
              echo
              pause 2
              echo
              echo #########
              echo * YEEEEET!!!
              echo #########
              echo
              goto ARRIVED
          }
goto ARRIVED
#################################################################################
THERENGIA:
THEREN:
var label THERENGIA
## IF IN RATHA - HEAD BACK TO MAINLAND
if (("$zoneid" == "90") && !matchre("%destination", "\b(rath?a?|aesr?y?|hara|taisg?a?t?h?|ross?m?a?n?s?|rive?r?h?a?v?e?n?|have?n?|ther?e?n?b?o?r?o?u?g?h?|lang?e?n?f?i?r?t?h?|musp?a?r?i?|forn?s?t?e?d?|hvar?a?l?|oasi?s?|haize?n?|yeehar?|zaul?f?u?n?g?)")) then
    {
          if (matchre("$game", "(?i)DRX") && (%portal == 1)) then
               {
                    if (matchre("$zoneid", "\b(1|30|40|47|67|90|99|107|116)\b") && (%ported == 0)) then gosub PORTAL_TIME
               }
## TAKE MAMMOTHS FROM RATHA - TO FC - THEN BACK TO MAINLAIND (ACENAMACRA)
        var ToRatha 0
        gosub AUTOMOVE 24
        pause 0.5
        put go rocks
        pause
        gosub JOINLOGIC
        pause
        gosub JOINLOGIC
        gosub AUTOMOVE 2
    }
## IF IN RATHA AND GOING TO RIVERHAVEN/THEREN AREA - TAKE THE KREE'LA
     if (("$zoneid" == "90") && !matchre("%destination", "\b(rath?a?|aesr?y?|hara|taisg?a?t?h?)")) then
          {
               if matchre("%destination", "\b(ross?m?a?n?s?|rive?r?h?a?v?e?n?|have?n?|ther?e?n?b?o?r?o?u?g?h?|lang?e?n?f?i?r?t?h?|musp?a?r?i?|forn?s?t?e?d?|hvar?a?l?|oasi?s?|haize?n?|yeehar?|zaul?f?u?n?g?)\b") then
                    {
                         gosub AUTOMOVE 1
                         gosub FERRYLOGIC
                    }
               gosub AUTOMOVE 2
               gosub FERRYLOGIC
          }
if (("$zoneid" == "42") && matchre("%detour", "muspari")) then
     {
          gosub AUTOMOVE gate
     }
if (("$zoneid" == "47") && matchre("%destination", "muspari")) then goto ARRIVED
if (matchre("$game", "(?i)DRX") && (%portal == 1)) then
     {
          if (matchre("$zoneid", "\b(1|30|40|47|67|90|99|107|116)\b") && (%ported == 0)) then gosub PORTAL_TIME
     }
if (("$zoneid" == "48") && matchre("%detour", "muspari")) then
     {
          gosub AUTOMOVE 3
          gosub FERRYLOGIC
          pause 0.3
     }
if (("$zoneid" == "48") && !matchre("%destination", "(oasis|yeehar|haizen)")) then
     {
          gosub AUTOMOVE 1
          gosub FERRYLOGIC
          pause 0.3
     }
if (("$zoneid" == "42") && ("%detour" == "rakash")) then gosub AUTOMOVE lang
if ("$zoneid" == "7a") then gosub AUTOMOVE NTR
if ("$zoneid" == "2") then gosub AUTOMOVE cross
if ("$zoneid" == "1a") then gosub AUTOMOVE cross
if ("$zoneid" == "2a") then gosub AUTOMOVE cross
if ("$zoneid" == "6")  then gosub AUTOMOVE cross
if ("$zoneid" == "67a") then gosub AUTOMOVE shard
if matchre("$zoneid", "106|107|108") then goto QITRAVEL
if (matchre("%destination", "(ratha|hara?j?a?a?l?)") && matchre("$zoneid", "\b(1|30|42|47|61|66|67|90|99|107|108|116)\b")) then
     {
          if (matchre("$game", "(?i)DRX") && (%portal == 1)) then
          {
               if (matchre("$zoneid", "\b(1|30|40|47|67|90|99|107|116)\b") && (%ported == 0)) then gosub PORTAL_TIME
          }
     if (matchre("$game", "(?i)DRF") && matchre("%destination", "\brath?a?") || (%premium == 1) && matchre("%destination", "\brath?a?")) then
               {
                    echo *** GOING TO FC
                    gosub TO_SEACAVE
                    gosub AUTOMOVE 2
                    var ToRatha 1
                    gosub JOINLOGIC
                    gosub AUTOMOVE 252
                    goto ARRIVED
               }
      if (matchre("$game", "(?i)DRF") && matchre("%destination", "\b(haraj?a?a?l?)")) then
          {
               echo ** TO FANG COVE
               gosub TO_SEACAVE
               gosub AUTOMOVE 3
               gosub JOINLOGIC
               goto ARRIVED
          }
    }
if matchre("$zonename", "(Hara'jaal|Mer'Kresh|M'Riss)") then
          {
              var backuplabel THERENGIA
              var backupdetour %detour
              var detour mriss
              var tomainland 1
              goto QITRAVEL
          }
#debug 10
if (("$zoneid" == "150") && matchre("$game", "(?i)DRF") && ("%detour" == "hara")) then
          {
              gosub AUTOMOVE 3
              gosub FERRYLOGIC
              pause
          }
if (("$zoneid" == "35") && ("%detour" != "throne")) then
          {
              gosub INFO_CHECK
              if (%lirums < 240) then goto NOCOIN
              gosub AUTOMOVE 166
              gosub FERRYLOGIC
              pause
          }
if ("$zoneid" == "127") then gosub AUTOMOVE 510
if ("$zoneid" == "126") then gosub AUTOMOVE 49
if (matchre("$game", "(?i)DRX") && (%portal == 1)) then
     {
          if (matchre("$zoneid", "\b(1|30|40|47|67|90|99|107|116)\b") && (%ported == 0)) then gosub PORTAL_TIME
     }
if ("$zoneid" == "116") then gosub AUTOMOVE 3
if ("$zoneid" == "114") then
          {
              gosub INFO_CHECK
              if (%dokoras < 140) then goto NOCOIN
              gosub AUTOMOVE 1
              gosub FERRYLOGIC
              put go oak doors
              waitforre ^Obvious
          }
if (("$zoneid" == "113") && ("$roomid" == "1")) then gosub AUTOMOVE 5
if ("$zoneid" == "123") then gosub AUTOMOVE 175
if ("$zoneid" == "69") then gosub AUTOMOVE 1
if ("$zoneid" == "68a") then gosub AUTOMOVE 29
if ("$zoneid" == "68b") then gosub AUTOMOVE 44
if ("$zoneid" == "68") then
     {
     if (matchre("$roomname", "(Blackthorn Canyon|Corik's Wall|Stormfells|Shadow's Reach|Reach Forge|Darkling Wood, Trader Outpost)") || (($roomid > 67) && ($roomid < 75))) then
          {
               gosub AUTOMOVE 68
               gosub AUTOMOVE 65
               gosub AUTOMOVE 62
               pause 0.1
          }
     if ($Athletics.Ranks > 250) then
          {
               echo ** Athletics high enough for Shard Walls! Taking Walls
               gosub AUTOMOVE 2
               pause 0.2
               put climb wall
               wait
               pause 0.4
          }
     }
if (("$zoneid" == "68") && matchre("%shardCitizen", "(?i)yes")) then
     {
          gosub AUTOMOVE 1
          gosub AUTOMOVE 135
     }
if (("$zoneid" == "68") && matchre("%shardCitizen", "(?i)no")) then gosub AUTOMOVE 15
if (matchre("$game", "(?i)DRX") && (%portal == 1)) then
     {
          if (matchre("$zoneid", "\b(1|30|40|47|67|90|99|107|116)\b") && (%ported == 0)) then gosub PORTAL_TIME
     }
if (("$zoneid" == "67") && ("$guild" == "Thief")) then
          {
              gosub AUTOMOVE 566
              pause 0.5
              gosub AUTOMOVE 23
          }
if ("$zoneid" == "67a") then gosub AUTOMOVE STR
if ("$zoneid" == "67") then gosub AUTOMOVE 132
if (matchre("%destination", "\b(ratha|hara?j?a?a?l?)") && matchre("$zoneid", "\b(1|30|42|47|61|66|67|90|99|107|108|116)\b")) then
     {
          if (matchre("$game", "(?i)DRX") && (%portal == 1)) then
          {
               if ("$zoneid" == "66") then gosub AUTOMOVE east
               if (matchre("$zoneid", "\b(1|30|40|47|67|90|99|107|116)\b") && (%ported == 0)) then gosub PORTAL_TIME
          }
     if (matchre("$game", "(?i)DRF") && matchre("%destination", "\brath?a?") || (%premium == 1) && matchre("%destination", "\brath?a?")) then
               {
                    echo *** GOING TO FC
                    gosub TO_SEACAVE
                    gosub AUTOMOVE 2
                    var ToRatha 1
                    gosub JOINLOGIC
                    gosub AUTOMOVE 252
                    goto ARRIVED
               }
      if (matchre("$game", "(?i)DRF") && matchre("%destination", "\b(haraj?a?a?l?)")) then
          {
               echo ** TO FANG COVE
               gosub TO_SEACAVE
               gosub AUTOMOVE 3
               gosub JOINLOGIC
               goto ARRIVED
          }
    }
if (("$zoneid" == "66") && matchre("gondola", "%detour")) then
          {
              gosub AUTOMOVE platform
              goto ARRIVED
          }
if (("$zoneid" == "66") && ("$guild" == "Thief") && ($Athletics.Ranks >= %underGondola) && ($Athletics.Ranks < 600)) then
          {
               put khri flight harrier
               pause
          }
if (("$zoneid" == "66") && ("$guild" == "Ranger") && ($Athletics.Ranks >= %underGondola)) then
          {
               put prep athlet 10
               pause 8
               put cast
          }
if (("$zoneid" == "66") && ($Athletics.Ranks >= %underGondola)) then
          {
               echo ** Athletics high enough for underGondola! Taking shortcut!
               gosub AUTOMOVE 317
          }
if (("$zoneid" == "66") && ($Athletics.Ranks < %underGondola)) then
          {
              echo ** Athletics too low for underGondola - Taking Gondola!
              gosub AUTOMOVE 156
              pause
              gosub FERRYLOGIC
          }
if ("$zoneid" == "65") then gosub AUTOMOVE 44
delay 0.0001
if ("$zoneid" == "63") then gosub AUTOMOVE 112
if ("$zoneid" == "62") then gosub AUTOMOVE 100
if ("$zoneid" == "112") then gosub AUTOMOVE 112
if ("$zoneid" == "59") then gosub AUTOMOVE 12
if ("$zoneid" == "58") then gosub AUTOMOVE 2
if (("$zoneid" == "50") && ($Athletics.Ranks > %segoltha)) then gosub SEGOLTHA_NORTH
if ("$zoneid" == "50") then gosub SEGOLTHA_SOUTH
if ("$zoneid" == "61") then gosub AUTOMOVE 115
if (("$zoneid" == "50") && ($Athletics.Ranks < %segoltha)) then gosub AUTOMOVE STR
if (("$zoneid" == "60") && ("$guild" == "Thief")) then
          {
              if ($Athletics.Ranks >= %underSegoltha) then
                  {
                      gosub AUTOMOVE segoltha
                      gosub AUTOMOVE 6
                  }
          }
if (("$zoneid" == "60") && ($Athletics.Ranks >= %segoltha)) then gosub AUTOMOVE 108
if (("$zoneid" == "60") && ($Athletics.Ranks < %segoltha)) then
          {
              echo ** Athletics too low for Segoltha - Taking Ferry
              gosub INFO_CHECK
              if %kronars < 100 then goto NOCOIN
              gosub AUTOMOVE 42
              pause
              gosub FERRYLOGIC
          }
if (("$zoneid" == "50") && ($Athletics.Ranks > %segoltha)) then gosub SEGOLTHA_NORTH
if ("$zoneid" == "13") then gosub AUTOMOVE 71
if ("$zoneid" == "4a") then gosub AUTOMOVE 15
if ("$zoneid" == "32") then gosub AUTOMOVE 1
if ("$zoneid" == "4") then gosub AUTOMOVE 14
if ("$zoneid" == "8") then gosub AUTOMOVE 43
if ("$zoneid" == "10") then gosub AUTOMOVE NTR
if ("$zoneid" == "9b") then gosub AUTOMOVE 9
if ("$zoneid" == "14b") then gosub AUTOMOVE 217
if ("$zoneid" == "11") then gosub AUTOMOVE 2
if (matchre("$game", "(?i)DRX") && (%portal == 1)) then
     {
          if (matchre("$zoneid", "\b(1|30|40|47|67|90|99|107|116)\b") && (%ported == 0)) then gosub PORTAL_TIME
     }
if ("$zoneid" == "1") then
     {
          if ($invisible == 1) then
               {
                    gosub AUTOMOVE N gate
                    gosub AUTOMOVE NTR
                    goto THERENGIA_1
               }
          gosub AUTOMOVE 171
     }
THERENGIA_1:
if (("$zoneid" == "7") && matchre("%detour", "(muspari|oasis)") && ("$game" != "DRF")) then
          {
              gosub AUTOMOVE 271
              gosub JOINLOGIC
              goto ARRIVED
          }
if (("$zoneid" == "7") && ("%detour" == "caravansary")) then
          {
              gosub AUTOMOVE caravan
              goto ARRIVED
          }
### CHECK HERE TO MAKE SURE BURDEN IS NOT TOO HIGH AT LOWER RANKS
if ("$zoneid" == "7") then
     {
          if ((($Athletics.Ranks < 170) && (%burden > 2)) || (($Athletics.Ranks < 190) && (%burden > 3))) then
               {
                    echo * BURDEN TOO HIGH FOR FALDESU RIVER @ CURRENT RANKS!
                    goto THERENGIA_FERRY
               }
          if ($Athletics.Ranks >= %faldesu) then goto THERENGIA_2
     }
if ("$zoneid" != "7") then goto THERENGIA_2
if ($Athletics.Ranks >= %faldesu) then goto THERENGIA_2
THERENGIA_FERRY:
if ("$zoneid" == "7") then
          {
              echo ** Athletics too low for Faldesu - Taking Ferry
              gosub INFO_CHECK
              if (%lirums < 140) then goto NOCOIN
              gosub AUTOMOVE 81
              gosub FERRYLOGIC
          }
THERENGIA_2:
if (("$zoneid" == "7") && ($Athletics.Ranks >= %faldesu)) then
     {
         gosub AUTOMOVE 197
         pause 0.1
         send #mapper reset
         pause 0.5
         pause 0.2
         if ("$zoneid" == "14c") then gosub FALDESU_NORTH
     }
if (("$zoneid" == "7") && ($Athletics.Ranks >= %faldesu)) then
     {
         gosub AUTOMOVE 197
         pause 0.1
         send #mapper reset
         pause 0.5
         pause 0.2
     }
if ("$zoneid" == "14c") then gosub FALDESU_NORTH
if ("$zoneid" == "33a") then gosub AUTOMOVE 46
if ("$zoneid" == "33") then gosub AUTOMOVE 1
if (("$zoneid" == "31") && ("%detour" == "zaulfung")) then
     {
          gosub AUTOMOVE 89
          pause 0.1
          put go curving path
          pause 0.5
          gosub SICKLY_TREE
     }
if ("$zoneid" == "31") then
     {
          gosub AUTOMOVE 1
          pause 0.1
          send #mapper reset
          pause 0.0001
     }
if (("$zoneid" == "34a") && !matchre("%detour", "rossman")) then gosub AUTOMOVE forest
if (("$zoneid" == "34") && matchre("%detour", "rossman")) then
          {
              gosub INFO_CHECK
              if (%lirums < 70) then goto NOCOIN
              gosub AUTOMOVE 22
              goto ARRIVED
          }
if (("$zoneid" == "34") && matchre("%detour", "(lang|theren|rakash|muspari|oasis|fornsted|el'bain)")) then
     {
     if (($roomid < 120) || ($roomid > 153)) then
          {
               gosub AUTOMOVE 53
               if matchre("$roomobjs", "two fragile ropes") then
                    {
                         gosub STOWING
                         send climb rope
                         pause 0.5
                         gosub SHUFFLE_NORTH
                    }
          }
          gosub AUTOMOVE 137
     }
if (("$zoneid" == "34") && matchre("%detour", "(haven|zaulfung|throne)")) then
          {
              if (($roomid > 120) && ($roomid < 153)) then
                    {
                    if ($Athletics.Ranks < %rossmanSouth) then gosub AUTOMOVE 137
                    if ($Athletics.Ranks >= %rossmanSouth) then
                         {
                              gosub AUTOMOVE 121
                              if matchre("$roomdesc", "pair of ropes tied to trees") then
                                   {
                                        gosub STOWING
                                        send climb rope
                                        pause 0.5
                                        gosub SHUFFLE_SOUTH
                                   }
                         }
                  }
               if ("$zoneid" == "34") then gosub AUTOMOVE 15
               if ("$zoneid" == "34") then gosub AUTOMOVE 15
               if ("$zoneid" == "33a") then gosub AUTOMOVE 46
               if ("$zoneid" == "33a") then gosub AUTOMOVE 46
               if ("$zoneid" == "33") then gosub AUTOMOVE 1
               if ("$zoneid" == "33") then gosub AUTOMOVE 1
          }
if (("$zoneid" == "47") && (matchre("$game", "(?i)DRX") && (%portal == 1) && (%ported == 0))) then gosub PORTAL_TIME
if (("$zoneid" == "47") && ($Athletics.Ranks >= %muspari.shortcut)) then gosub VELAKA_SHORTCUT
if ("$zoneid" == "47") then
          {
              echo
              echo ** Athletics too LOW for Muspari Shortcut - Taking Long Route
              echo
              gosub AUTOMOVE 117
              gosub FERRYLOGIC
          }
if (("$zoneid" == "41") && matchre("%detour", "(muspari|fornsted|oasis)")) then
          {
              if matchre("%detour", "fornsted") then
                  {
                      gosub AUTOMOVE 91
                      goto ARRIVED
                  }
              gosub PASSPORT_CHECK
              if (%passport == 0) then
               {
                   gosub AUTOMOVE 53
                   pause 0.5
                   put east
                   waitforre ^Just when it seems
                   pause 0.5
                   put #mapper reset
                   pause 0.3
                   put east
                   pause 0.4
                   gosub GET_PASSPORT
                   gosub AUTOMOVE 376
                   pause 0.5
                   put west
                   waitforre ^Just when it seems
                   pause
                   put #mapper reset
               }
              if matchre("%detour", "(muspari|oasis)") then
                  {
                    echo
                    echo ** Athletics too low for Muspari Shortcut - Taking Long Route
                    echo
                    gosub AUTOMOVE 91
                    gosub PASSPORT
                    gosub AUTOMOVE 160
                    if ($Athletics.Ranks >= %muspari.shortcut) then goto HAIZEN_SHORTCUT
                    gosub FERRYLOGIC
                    gosub STOWING
                  }
          }
if (("$zoneid" == "48") && matchre("%detour", "oasis")) then
     {
          gosub AUTOMOVE 22
          if matchre("%destination", "(?i)oasis?") then goto ARRIVED
     }
if (("$zoneid" == "41") && !matchre("%detour", "(muspari|fornsted|oasis)")) then
          {
              gosub AUTOMOVE 53
              pause 0.5
              put east
              waitforre ^Just when it seems
              pause 0.5
              put #mapper reset
          }
if (matchre("$game", "(?i)DRX") && (%portal == 1)) then
     {
          if (matchre("$zoneid", "\b(1|30|40|47|67|90|99|107|116)\b") && (%ported == 0)) then gosub PORTAL_TIME
     }
if (("$zoneid" == "47") && matchre("muspari", "%detour")) then
          {
              gosub AUTOMOVE 235
              goto ARRIVED
          }
if ("$zoneid" == "47") then
          {
              gosub AUTOMOVE 117
              gosub FERRYLOGIC
          }
if (matchre("$game", "(?i)DRX") && (%portal == 1)) then
     {
          if (matchre("$zoneid", "\b(1|30|40|47|67|90|99|107|116)\b") && (%ported == 0)) then gosub PORTAL_TIME
     }
if (("$zoneid" == "30") && matchre("%detour", "(rossman|lang|theren|rakash|muspari|oasis|fornsted|el'bain|mriss|merk|hara)")) then
          {
              if $Athletics.Ranks < %rossmanNorth then
                  {
                      echo
                      echo ** Athletics too low for Rossman Shortcut - Taking Ferry
                      echo
                      gosub INFO_CHECK
                      if (%lirums < 140) then goto NOCOIN
                      gosub AUTOMOVE 99
                      gosub FERRYLOGIC
                  }
              if $Athletics.Ranks >= %rossmanNorth then
                  {
                      echo
                      echo ** Athletics high enough for Jantspyre River - Taking Rossman's Shortcut!
                      echo
                      gosub AUTOMOVE 174
                      gosub AUTOMOVE 29
                      gosub AUTOMOVE 48
                      if ("%detour" == "rossman") then
                          {
                              gosub AUTOMOVE 22
                              goto ARRIVED
                          }
                      gosub AUTOMOVE 53
                      if matchre("$roomobjs", "two fragile ropes") then
                           {
                              gosub STOWING
                              send climb rope
                              pause 0.5
                              gosub SHUFFLE_NORTH
                           }
                      gosub AUTOMOVE 137
                  }
          }
if (matchre("$game", "(?i)DRX") && (%portal == 1)) then
     {
          if (matchre("$zoneid", "\b(1|30|40|47|67|90|99|107|116)\b") && (%ported == 0)) then gosub PORTAL_TIME
     }
if ("$zoneid" == "116") then
			{
               gosub INFO_CHECK
			evalmath TherenCoin $circle*20
			if (%dokoras < %TherenCoin) then goto NOCOIN
			gosub AUTOMOVE 217
			}
if ("$zoneid" == "126") then
			{
               gosub INFO_CHECK
			evalmath TherenCoin $circle*20
			if (%dokoras < %TherenCoin) then
				{
				gosub AUTOMOVE 49
				goto NOCOIN
				}
			gosub AUTOMOVE 103
			}
if ("$zoneid" == "127") then
			{
               gosub INFO_CHECK
			evalmath TherenCoin $circle*20
			if (%dokoras < %TherenCoin) then
				{
				gosub AUTOMOVE 510
				gosub AUTOMOVE 49
				goto NOCOIN
				}
			gosub AUTOMOVE 363
			gosub JOINLOGIC
			}
# if matchre("rakash", "(?i)%detour") then goto ARRIVED
if ("$zoneid" == "40a") then gosub AUTOMOVE 125
if "$zoneid" == "42" && "%detour" != "theren" then gosub AUTOMOVE 2
if (("$zoneid" == "40") && matchre("$game", "(?i)DRX") && (%portal == 1) && !matchre("%detour", "(?i)(el'bain|lang|rakash)") && (%ported == 0)) then gosub PORTAL_TIME
PASSPORT_RECOVER:
if (("$zoneid" == "40") && matchre("%detour", "(muspari|oasis|fornsted|hvaral)")) then
          {
              gosub PASSPORT_CHECK
              if (%passport == 0) then gosub GET_PASSPORT
          }
if (("$zoneid" == "40") && ("%detour" == "rossman")) then
          {
              gosub AUTOMOVE 213
              gosub AUTOMOVE 22
              goto ARRIVED
          }
if (("$zoneid" == "40") && matchre("%detour", "(?i)(lang|rakash|el'bain|mriss|merk|hara)")) then
          {
              if ("%detour" == "el'bain") then
                  {
                      gosub AUTOMOVE 142
                      goto ARRIVED
                  }
              if ("%detour" == "lang") then
                  {
                      gosub AUTOMOVE 1
                      goto ARRIVED
                  }
              if ("%detour" == "rakash") then
                  {
                      gosub AUTOMOVE 263
                      gosub AUTOMOVE 96
                      goto ARRIVED
                  }
              if matchre("%detour", "(mriss|merk|hara)") then
                  {
                      gosub AUTOMOVE 305
                      gosub JOINLOGIC
                      goto QITRAVEL
                  }
          }
if (("$zoneid" == "40") && matchre("%detour", "(?i)(haven|zaulfung|throne)")) then
          {
              if ($Athletics.Ranks >= %rossmanSouth) then
                  {
                      echo
                      echo ** Athletics high enough for Jantspyre River - Taking Rossman's Shortcut!
                      echo
                      gosub AUTOMOVE 213
                      gosub AUTOMOVE 121
                      if matchre("$roomdesc", "pair of ropes tied to trees") then
                         {
                             gosub STOWING
                             send climb rope
                             pause 0.5
                             gosub SHUFFLE_SOUTH
                         }
               if ("$zoneid" == "34") then gosub AUTOMOVE 15
               if ("$zoneid" == "34") then gosub AUTOMOVE 15
               if ("$zoneid" == "33a") then gosub AUTOMOVE 46
               if ("$zoneid" == "33a") then gosub AUTOMOVE 46
               if ("$zoneid" == "33") then gosub AUTOMOVE 1
               if ("$zoneid" == "33") then gosub AUTOMOVE 1
                    }
              if ($Athletics.Ranks < %rossmanSouth) then
                  {
                      echo ** Athletics too low for Rossman Shortcut - Taking Ferry
                      gosub INFO_CHECK
                      if (%lirums < 140) then goto NOCOIN
                      gosub AUTOMOVE 36
                      gosub FERRYLOGIC
                  }
          }
if (("$zoneid" == "40") && ("%detour" == "theren")) then gosub AUTOMOVE 211
if (("$zoneid" == "42") && ("%detour" == "theren")) then
          {
              gosub AUTOMOVE 56
              goto ARRIVED
          }
if (("$zoneid" == "40") && matchre("%detour", "(muspari|oasis|fornsted|hvaral)")) then
          {
              gosub AUTOMOVE 376
              pause 0.5
              put west
              waitforre ^Just when it seems
              pause
              put #mapper reset
          }
if (("$zoneid" == "41") && ("%detour" == "fornsted")) then
          {
              gosub AUTOMOVE 91
              goto ARRIVED
          }
if (("$zoneid" == "41") && ("%detour" == "hvaral")) then
          {
              gosub AUTOMOVE 91
              gosub PASSPORT
              gosub AUTOMOVE 145
              goto ARRIVED
          }
if (("$zoneid" == "41") && matchre("%detour", "(muspari|oasis)")) then
          {
              gosub AUTOMOVE 91
              gosub PASSPORT
              gosub AUTOMOVE 160
              if ($Athletics.Ranks >= %muspari.shortcut) then goto HAIZEN_SHORTCUT
              gosub FERRYLOGIC
          }
if (("$zoneid" == "48") && matchre("%detour", "oasis")) then
     {
          gosub AUTOMOVE 22
          if matchre("%destination", "(?i)oasi?s?") then goto ARRIVED
     }
if (("$zoneid" == "41") && matchre("%detour", "(rossman|lang|theren|rakash|el'bain|haven|zaulfung)")) then
          {
              gosub AUTOMOVE 53
              waitforre ^Just when
              pause
              put #mapper reset
          }
if (("$zoneid" == "30") && ("%detour" == "throne")) then
          {
              gosub AUTOMOVE throne city barge
              gosub FERRYLOGIC
              goto ARRIVED
          }
if (("$zoneid" == "30") && ("%detour" == "zaulfung")) then
          {
              gosub AUTOMOVE 203
              gosub AUTOMOVE 100
          }
if ("$zoneid" == "30") then
          {
              gosub AUTOMOVE 8
              goto ARRIVED
          }
if (("$zoneid" == "48") && matchre("%destination", "(haize?n?|yeehar)")) then
     {
          gosub AUTOMOVE 66
          goto VELAKA_DUNES
     }
gosub STOWING
goto ARRIVED
#######################################################################
SHUFFLE_SOUTH:
     if ($roomid == 121) then
          {
               echo *** ROPE OCCUPIED - TRYING AGAIN IN 20..
               pause 20
               if ($monstercount > 0) then gosub RETREAT
               send climb rope
               pause 0.5
               pause 0.2
               goto SHUFFLE_SOUTH
          }
     pause 0.001
     send shuffle south
     pause
     pause 0.5
     if ($roomid == 53) then return
     if matchre("$roomdesc", "The trail twists around") then return
     pause 0.01
     pause 0.01
     if ($stunned == 1) then waiteval ($stunned == 0)
     if ($standing == 0) then gosub STAND
     if ($roomid == 121) then
          {
               if ($monstercount > 0) then gosub RETREAT
               send climb rope
               pause 0.8
               pause 0.5
          }
     goto SHUFFLE_SOUTH
SHUFFLE_NORTH:
     if ($roomid == 53) then
          {
               echo *** ROPE OCCUPIED - TRYING AGAIN IN 20..
               pause 20
               if ($monstercount > 0) then gosub RETREAT
               send climb rope
               pause 0.5
               pause 0.2
               goto SHUFFLE_NORTH
          }
     pause 0.001
     if ($monstercount > 0) then gosub RETREAT
     send shuffle north
     pause
     pause 0.5
     if ($roomid == 121) then return
     if matchre("$roomdesc", "A steep-sided ravine") then return
     pause 0.01
     pause 0.01
     if ($stunned == 1) then waiteval ($stunned == 0)
     if ($standing == 0) then gosub STAND
     if ($roomid == 53) then
          {
               if ($monstercount > 0) then gosub RETREAT
               send climb rope
               pause 0.8
               pause 0.5
          }
     goto SHUFFLE_NORTH
#######################################################################
SICKLY_TREE:
     pause 0.001
     echo *** LOOKING FOR THE SICKLY TREE
     if matchre("$roomobjs", "sickly tree") then goto SICKLY_TREE_2
     gosub RANDOMWEIGHT east
     if matchre("$roomobjs", "sickly tree") then goto SICKLY_TREE_2
     gosub RANDOMWEIGHT east
     if matchre("$roomobjs", "sickly tree") then goto SICKLY_TREE_2
     gosub RANDOMWEIGHT northeast
     if matchre("$roomobjs", "sickly tree") then goto SICKLY_TREE_2
     gosub RANDOMMOVE
     if matchre("$roomobjs", "sickly tree") then goto SICKLY_TREE_2
     gosub RANDOMMOVE
     if matchre("$roomobjs", "sickly tree") then goto SICKLY_TREE_2
     gosub RANDOMWEIGHT west
     if matchre("$roomobjs", "sickly tree") then goto SICKLY_TREE_2
     gosub RANDOMWEIGHT west
     goto SICKLY_TREE
SICKLY_TREE_2:
     pause 0.001
     put climb sickly tree
     pause 0.5
     pause 0.3
     if ("$zoneid" == "31") then goto SICKLY_TREE
     return
VELAKA_DUNES:
     pause 0.01
     if (matchre("%destination", "(haize?n?)") && matchre("$roomobjs", "(?i)twisting trail")) then
          {
               gosub MOVE go trail
               pause 0.3
               gosub AUTOMOVE 29
               goto ARRIVED
          }
     if (matchre("%destination", "(oasis?)") && matchre("$roomobjs", "(?i)path")) then
          {
               gosub MOVE go path
               pause 0.3
               gosub AUTOMOVE 2
               goto ARRIVED
          }
     if (matchre("%destination", "yeeha?r?") && matchre("$roomobjs", "(?i)canyon")) then
          {
               gosub MOVE go canyon
               pause 0.1
               gosub AUTOMOVE 49
               goto ARRIVED
          }
     gosub RANDOMMOVE
     goto VELAKA_DUNES

HAIZEN_SHORTCUT:
     echo ########################
     echo *** WE HAVE 700+ ATHLETICS!~
     echo *** TAKING DESERT DUNES SHORTCUT TO MUSPARI
     echo ########################
     pause
     gosub AUTOMOVE 208
     pause
     gosub AUTOMOVE 66
HAIZEN_SHORTCUT_1:
     pause 0.2
     if (matchre("%destination", "(haize?n?|muspar?i?)") && matchre("$roomobjs", "(?i)twisting trail")) then
          {
               gosub MOVE go trail
               pause 0.3
               gosub AUTOMOVE 29
               if matchre("%destination", "haize?n?") then goto ARRIVED
               goto HAIZEN_SHORTCUT_2
          }
     if (matchre("%destination", "oasi?s?") && matchre("$roomobjs", "(?i)path")) then
          {
               gosub MOVE go path
               pause 0.3
               gosub AUTOMOVE 2
               goto ARRIVED
          }
     if (matchre("%destination", "yeeha?r?") && matchre("$roomobjs", "(?i)canyon")) then
          {
               gosub MOVE go canyon
               pause 0.1
               gosub AUTOMOVE 49
               goto ARRIVED
          }
     gosub RANDOMMOVE
     goto HAIZEN_SHORTCUT_1
HAIZEN_SHORTCUT_2:
     pause 0.2
     gosub AUTOMOVE 36
     pause 0.2
HAIZEN_SHORTCUT_3:
     gosub MOVE west
     gosub MOVE west
     gosub MOVE west
     gosub MOVE southwest
     gosub MOVE west
     gosub MOVE northwest
     gosub MOVE west
     gosub MOVE southwest
     gosub MOVE west
     gosub MOVE southwest
     gosub MOVE west
     gosub MOVE northwest
     gosub MOVE west
     gosub MOVE west
     gosub MOVE west
     gosub MOVE west
     gosub MOVE northwest
     gosub MOVE west
     gosub MOVE southwest
     gosub MOVE west
     gosub MOVE west
     gosub MOVE west
     gosub MOVE west
     gosub MOVE west
     gosub MOVE west
HAIZEN_SHORTCUT_33:
     if matchre("$roomobjs", "black stones") then goto HAIZEN_SHORTCUT_22
     gosub MOVE southwest
     if matchre("$roomobjs", "black stones") then goto HAIZEN_SHORTCUT_22
     gosub MOVE west
     if matchre("$roomobjs", "black stones") then goto HAIZEN_SHORTCUT_22
     gosub MOVE southwest
     if matchre("$roomobjs", "black stones") then goto HAIZEN_SHORTCUT_22
     gosub MOVE northwest
     if matchre("$roomobjs", "black stones") then goto HAIZEN_SHORTCUT_22
     gosub MOVE southwest
     if matchre("$roomobjs", "black stones") then goto HAIZEN_SHORTCUT_22
     gosub MOVE west
     if matchre("$roomobjs", "black stones") then goto HAIZEN_SHORTCUT_22
     gosub MOVE southwest
     if matchre("$roomobjs", "black stones") then goto HAIZEN_SHORTCUT_22
     gosub MOVE west
     if matchre("$roomobjs", "black stones") then goto HAIZEN_SHORTCUT_22
     gosub MOVE west
     if matchre("$roomobjs", "black stones") then goto HAIZEN_SHORTCUT_22
     gosub MOVE southwest
     if matchre("$roomobjs", "black stones") then goto HAIZEN_SHORTCUT_22
     gosub MOVE west
     if matchre("$roomobjs", "black stones") then goto HAIZEN_SHORTCUT_22
     if ($zoneid != 47) then goto HAIZEN_SHORTCUT_33
     goto HAIZEN_SHORTCUT_3
HAIZEN_SHORTCUT_22:
     pause 0.4
     put go stone
     pause
HAIZEN_SHORTCUT_4:
     echo **** Trying to Navigate the stupid Velaka Desert...
     echo **** Looking for the "rocky trail"
     if matchre("$roomobjs", "rocky trail") then goto HAIZEN_SHORTCUT_5
     gosub RANDOMWEIGHT west
     if matchre("$roomobjs", "rocky trail") then goto HAIZEN_SHORTCUT_5
     gosub RANDOMWEIGHT west
     if matchre("$roomobjs", "rocky trail") then goto HAIZEN_SHORTCUT_5
     gosub RANDOMWEIGHT west
     if matchre("$roomobjs", "rocky trail") then goto HAIZEN_SHORTCUT_5
     gosub RANDOMWEIGHT west
     if matchre("$roomobjs", "rocky trail") then goto HAIZEN_SHORTCUT_5
     gosub RANDOMMOVE
     if matchre("$roomobjs", "rocky trail") then goto HAIZEN_SHORTCUT_5
     gosub RANDOMMOVE
     if matchre("$roomobjs", "rocky trail") then goto HAIZEN_SHORTCUT_5
     gosub RANDOMMOVE
     if matchre("$roomobjs", "rocky trail") then goto HAIZEN_SHORTCUT_5
     gosub RANDOMMOVE
     if matchre("$roomobjs", "rocky trail") then goto HAIZEN_SHORTCUT_5
     gosub RANDOMMOVE
     if matchre("$roomobjs", "rocky trail") then goto HAIZEN_SHORTCUT_5
     gosub RANDOMWEIGHT east
     if matchre("$roomobjs", "rocky trail") then goto HAIZEN_SHORTCUT_5
     gosub RANDOMWEIGHT east
     if matchre("$roomobjs", "rocky trail") then goto HAIZEN_SHORTCUT_5
     gosub RANDOMWEIGHT east
     if matchre("$roomobjs", "rocky trail") then goto HAIZEN_SHORTCUT_5
     gosub RANDOMWEIGHT east
     if matchre("$roomobjs", "rocky trail") then goto HAIZEN_SHORTCUT_5
     gosub RANDOMMOVE
     if matchre("$roomobjs", "rocky trail") then goto HAIZEN_SHORTCUT_5
     gosub RANDOMMOVE
     if matchre("$roomobjs", "rocky trail") then goto HAIZEN_SHORTCUT_5
     gosub RANDOMMOVE
     if matchre("$roomobjs", "rocky trail") then goto HAIZEN_SHORTCUT_5
     gosub RANDOMMOVE
     if matchre("$roomobjs", "rocky trail") then goto HAIZEN_SHORTCUT_5
     gosub RANDOMMOVE
     if matchre("$roomobjs", "rocky trail") then goto HAIZEN_SHORTCUT_5
     gosub RANDOMMOVE
     if matchre("$roomobjs", "rocky trail") then goto HAIZEN_SHORTCUT_5
     gosub RANDOMMOVE
     if matchre("$roomobjs", "rocky trail") then goto HAIZEN_SHORTCUT_5
     gosub RANDOMMOVE
     if matchre("$roomobjs", "rocky trail") then goto HAIZEN_SHORTCUT_5
     gosub RANDOMMOVE
     if matchre("$roomobjs", "rocky trail") then goto HAIZEN_SHORTCUT_5
     gosub RANDOMMOVE
     goto HAIZEN_SHORTCUT_4
HAIZEN_SHORTCUT_5:
     put go trail
     pause 0.5
     goto ARRIVED


VELAKA_SHORTCUT:
     echo ########################
     echo *** WE HAVE 700+ ATHLETICS!~
     echo *** TAKING DESERT DUNES SHORTCUT FROM MUSPARI
     echo ########################
     pause
     if ("$zoneid" == "48") then goto VELAKA_SHORTCUT_3
     if ("$roomid" != "0") then gosub AUTOMOVE 118
VELAKA_SHORTCUT_1:
     pause 0.01
     echo *** LOOKING FOR THE BLACK STONES
     if matchre("$roomobjs", "black stones") then
          {
               gosub MOVE go stone
               pause 0.3
               goto VELAKA_SHORTCUT_2
          }
     gosub RANDOMWEIGHT east
     if matchre("$roomobjs", "black stones") then goto VELAKA_SHORTCUT_1
     gosub RANDOMEAST
     if matchre("$roomobjs", "black stones") then goto VELAKA_SHORTCUT_1
     gosub RANDOMEAST
     if matchre("$roomobjs", "black stones") then goto VELAKA_SHORTCUT_1
     gosub RANDOMEAST
     if matchre("$roomobjs", "black stones") then goto VELAKA_SHORTCUT_1
     gosub RANDOMEAST
     if matchre("$roomobjs", "black stones") then goto VELAKA_SHORTCUT_1
     gosub RANDOMEAST
     if matchre("$roomobjs", "black stones") then goto VELAKA_SHORTCUT_1
     gosub RANDOMEAST
     if matchre("$roomobjs", "black stones") then goto VELAKA_SHORTCUT_1
     gosub RANDOMEAST
     if matchre("$roomobjs", "black stones") then goto VELAKA_SHORTCUT_1
     gosub RANDOMEAST
     if matchre("$roomobjs", "black stones") then goto VELAKA_SHORTCUT_1
     gosub RANDOMEAST
     if matchre("$roomobjs", "black stones") then goto VELAKA_SHORTCUT_1
     gosub RANDOMEAST
     if matchre("$roomobjs", "black stones") then goto VELAKA_SHORTCUT_1
     gosub RANDOMEAST
     if matchre("$roomobjs", "black stones") then goto VELAKA_SHORTCUT_1
     gosub RANDOMMOVE
     if matchre("$roomobjs", "black stones") then goto VELAKA_SHORTCUT_1
     gosub RANDOMMOVE
     if matchre("$roomobjs", "black stones") then goto VELAKA_SHORTCUT_1
     gosub RANDOMMOVE
     if matchre("$roomobjs", "black stones") then goto VELAKA_SHORTCUT_1
     gosub RANDOMMOVE
     if matchre("$roomobjs", "black stones") then goto VELAKA_SHORTCUT_1
     gosub RANDOMMOVE
     if matchre("$roomobjs", "black stones") then goto VELAKA_SHORTCUT_1
     gosub RANDOMWEST
     if matchre("$roomobjs", "black stones") then goto VELAKA_SHORTCUT_1
     gosub RANDOMWEST
     if matchre("$roomobjs", "black stones") then goto VELAKA_SHORTCUT_1
     gosub RANDOMWEST
     if matchre("$roomobjs", "black stones") then goto VELAKA_SHORTCUT_1
     gosub RANDOMWEST
     if matchre("$roomobjs", "black stones") then goto VELAKA_SHORTCUT_1
     gosub RANDOMWEST
     if matchre("$roomobjs", "black stones") then goto VELAKA_SHORTCUT_1
     gosub RANDOMWEST
     if matchre("$roomobjs", "black stones") then goto VELAKA_SHORTCUT_1
     gosub RANDOMSOUTH
     if matchre("$roomobjs", "black stones") then goto VELAKA_SHORTCUT_1
     gosub RANDOMSOUTH
     if matchre("$roomobjs", "black stones") then goto VELAKA_SHORTCUT_1
     gosub RANDOMWEST
     if matchre("$roomobjs", "black stones") then goto VELAKA_SHORTCUT_1
     gosub RANDOMWEST
     if matchre("$roomobjs", "black stones") then goto VELAKA_SHORTCUT_1
     gosub RANDOMSOUTH
     if matchre("$roomobjs", "black stones") then goto VELAKA_SHORTCUT_1
     gosub RANDOMSOUTH
     if matchre("$roomobjs", "black stones") then goto VELAKA_SHORTCUT_1
     gosub RANDOMWEST
     if matchre("$roomobjs", "black stones") then goto VELAKA_SHORTCUT_1
     gosub RANDOMWEST
     if matchre("$roomobjs", "black stones") then goto VELAKA_SHORTCUT_1
     gosub RANDOMSOUTH
     if matchre("$roomobjs", "black stones") then goto VELAKA_SHORTCUT_1
     gosub RANDOMSOUTH
     if matchre("$roomobjs", "black stones") then goto VELAKA_SHORTCUT_1
     gosub RANDOMWEST
     if matchre("$roomobjs", "black stones") then goto VELAKA_SHORTCUT_1
     gosub RANDOMWEST
     if matchre("$roomobjs", "black stones") then goto VELAKA_SHORTCUT_1
     gosub RANDOMWEST
     if matchre("$roomobjs", "black stones") then goto VELAKA_SHORTCUT_1
     gosub RANDOMWEST
     if matchre("$roomobjs", "black stones") then goto VELAKA_SHORTCUT_1
     gosub RANDOMWEST
     goto VELAKA_SHORTCUT_1
VELAKA_SHORTCUT_2:
     echo
     echo ** TRUDGING THROUGH THE DESERT
     echo ** NICE AND EASY... HOPE WE DON'T GET LOST..
     echo
     gosub MOVE east
     gosub MOVE northeast
     gosub MOVE east
     if matchre("$roomobjs", "black stones") then goto VELAKA_SHORTCUT_2
     gosub MOVE east
     gosub MOVE northeast
     gosub MOVE east
     if matchre("$roomobjs", "black stones") then goto VELAKA_SHORTCUT_2
     gosub MOVE northeast
     gosub MOVE southeast
     gosub MOVE northeast
     gosub MOVE east
     gosub MOVE northeast
     gosub MOVE east
     if matchre("$roomobjs", "black stones") then goto VELAKA_SHORTCUT_2
     gosub MOVE east
     gosub MOVE east
     gosub MOVE east
     if matchre("$roomobjs", "black stones") then goto VELAKA_SHORTCUT_2
     gosub MOVE east
     gosub MOVE east
     gosub MOVE northeast
     gosub MOVE east
     if matchre("$roomobjs", "black stones") then goto VELAKA_SHORTCUT_2
     gosub MOVE southeast
     gosub MOVE east
     gosub MOVE east
     gosub MOVE east
     if matchre("$roomobjs", "black stones") then goto VELAKA_SHORTCUT_2
     gosub MOVE east
     gosub MOVE southeast
     gosub MOVE east
     gosub MOVE northeast
     gosub MOVE east
     if matchre("$roomobjs", "black stones") then goto VELAKA_SHORTCUT_2
     gosub MOVE northeast
     gosub MOVE east
     gosub MOVE southeast
     gosub MOVE east
     if matchre("$roomobjs", "black stones") then goto VELAKA_SHORTCUT_2
VELAKA_SHORTCUT.22:
VELAKA_SHORTCUT_22:
     gosub MOVE northeast
     gosub MOVE east
     if matchre("$roomobjs", "black stones") then goto VELAKA_SHORTCUT_2
     gosub MOVE east
     gosub MOVE east
     gosub MOVE southeast
     if matchre("$roomobjs", "black stones") then goto VELAKA_SHORTCUT_2
     gosub MOVE east
     gosub MOVE southeast
     if matchre("$roomobjs", "black stones") then goto VELAKA_SHORTCUT_2
     gosub MOVE east
     gosub MOVE south
     gosub MOVE southeast
     if matchre("$roomobjs", "black stones") then goto VELAKA_SHORTCUT_2
     if ($roomid == 0) then goto VELAKA_SHORTCUT_22
VELAKA_SHORTCUT_3:
     pause 0.4
     put go twisting trail
     pause
VELAKA_SHORTCUT_4:
     if matchre("$roomobjs", "broad valley") then goto VELAKA_SHORTCUT_5
     gosub RANDOMWEIGHT west
     if matchre("$roomobjs", "broad valley") then goto VELAKA_SHORTCUT_5
     gosub RANDOMWEIGHT west
     if matchre("$roomobjs", "broad valley") then goto VELAKA_SHORTCUT_5
     gosub RANDOMWEIGHT west
     if matchre("$roomobjs", "broad valley") then goto VELAKA_SHORTCUT_5
     gosub RANDOMMOVE
     if matchre("$roomobjs", "broad valley") then goto VELAKA_SHORTCUT_5
     gosub RANDOMMOVE
     if matchre("$roomobjs", "broad valley") then goto VELAKA_SHORTCUT_5
     gosub RANDOMMOVE
     if matchre("$roomobjs", "broad valley") then goto VELAKA_SHORTCUT_5
     gosub RANDOMMOVE
     goto VELAKA_SHORTCUT_4
VELAKA_SHORTCUT_5:
     pause 0.1
     put go valley
     pause 0.5
     gosub AUTOMOVE dry
     pause 0.5
     return
######################################################################################
FORD:
var label FORD
if (matchre("$game", "(?i)DRX") && (%portal == 1)) then
     {
          if (matchre("$zoneid", "\b(1|30|40|47|67|90|99|107|116)\b") && (%ported == 0)) then gosub PORTAL_TIME
     }
if matchre("$zoneid", "(Hara'jaal|Mer'Kresh|M'Riss)") then
          {
              var backuplabel FORD
              var backupdetour %detour
              var detour mriss
              var tomainland 1
              goto QITRAVEL
          }
if ("$zoneid" == "48") then
     {
          gosub AUTOMOVE 1
          gosub FERRYLOGIC
          pause
     }
if (("$zoneid" == "35") && ("%detour" != "throne")) then
          {
              gosub INFO_CHECK
              if (%lirums < 240) then goto NOCOIN
              gosub AUTOMOVE 166
              gosub FERRYLOGIC
              pause
          }
if (("$zoneid" == "47") && (matchre("$game", "(?i)DRX") && (%portal == 1) && (%ported == 0))) then gosub PORTAL_TIME
if (("$zoneid" == "47") && ($Athletics.Ranks >= %muspari.shortcut)) then gosub VELAKA_SHORTCUT
if ("$zoneid" == "47") then
          {
              gosub AUTOMOVE 117
              gosub FERRYLOGIC
          }
if ("$zoneid" == "41") then
          {
              gosub AUTOMOVE 53
              pause 0.5
              put east
              waitforre ^Just when it seems
              pause
              put #mapper reset
          }
if ("$zoneid" == "40a") then gosub AUTOMOVE 125
if ("$zoneid" == "42") then gosub AUTOMOVE 2
if (("$zoneid" == "40") && matchre("$game", "(?i)DRX") && (%portal == 1) && (%ported == 0)) then gosub PORTAL_TIME
if (("$zoneid" == "40") && ($Athletics.Ranks >= %rossmanSouth)) then gosub AUTOMOVE 213
if (("$zoneid" == "40") && ($Athletics.Ranks < %rossmanSouth)) then
          {
              echo ** Athletics too low for Rossman Shortcut - Taking Ferry
              gosub INFO_CHECK
		    evalmath BoarNeeded $circle*20
              if (%lirums < %BoarNeeded) then goto NOCOIN
              gosub AUTOMOVE 263
          }
if ("$zoneid" == "40a") then
			{
                    gosub INFO_CHECK
				evalmath BoarNeeded $circle*20
				if (%lirums < %BoarNeeded) then
					{
					gosub AUTOMOVE 125
					goto NOCOIN
					}
				gosub AUTOMOVE 68
				gosub JOINLOGIC
				goto FORD_3
			}
if ("$zoneid" == "34a") then gosub AUTOMOVE 134
if ("$zoneid" == "34") then gosub AUTOMOVE 15
if ("$zoneid" == "33a") then gosub AUTOMOVE 46
if ("$zoneid" == "33") then gosub AUTOMOVE 1
if ("$zoneid" == "32") then gosub AUTOMOVE 1
if ("$zoneid" == "31") then gosub AUTOMOVE river
if (matchre("$game", "(?i)DRX") && (%portal == 1)) then
     {
          if (matchre("$zoneid", "\b(1|30|40|47|67|90|99|107|116)\b") && (%ported == 0)) then gosub PORTAL_TIME
     }
if (("$zoneid" == "30") && ($Athletics.Ranks < %faldesu)) then
          {
              echo ** Athletics too low for Faldesu - Taking Ferry
              gosub INFO_CHECK
              if (%lirums < 140) then goto NOCOIN
              gosub AUTOMOVE 103
              pause
              gosub FERRYLOGIC
          }
if (("$zoneid" == "30") && ($Athletics.Ranks >= %faldesu)) then
          {
              ## TO FALDESU
              gosub AUTOMOVE 203
              gosub AUTOMOVE 79
          }
if ("$zoneid" == "14c") then gosub FALDESU_SOUTH
if ("$zoneid" == "14c") then gosub FALDESU_SOUTH
if ("$zoneid" == "13") then gosub AUTOMOVE 71
if ("$zoneid" == "4a") then gosub AUTOMOVE 15
if ("$zoneid" == "4") then gosub AUTOMOVE 14
if ("$zoneid" == "8") then gosub AUTOMOVE 43
if ("$zoneid" == "10") then gosub AUTOMOVE NTR
if ("$zoneid" == "9b") then gosub AUTOMOVE 9
if ("$zoneid" == "14b") then gosub AUTOMOVE 217
if ("$zoneid" == "11") then gosub AUTOMOVE 2
if ("$zoneid" == "7") then gosub AUTOMOVE 349
if (matchre("$game", "(?i)DRX") && (%portal == 1)) then
     {
          if (matchre("$zoneid", "\b(1|30|40|47|67|90|99|107|116)\b") && (%ported == 0)) then gosub PORTAL_TIME
     }
if ("$zoneid" == "1") then
          {
              if ("$guild" == "Thief") then
                  {
                      if ($Athletics.Ranks >= %underSegoltha) then
                          {
                              gosub AUTOMOVE 650
                              gosub AUTOMOVE 23
                          }
                  }
              if (($Athletics.Ranks >= %segoltha) && ("$zoneid" == "1")) then
                  {
                      gosub AUTOMOVE 476
                      gosub SEGOLTHA_SOUTH
                  }
              if ("$zoneid" == "1") then
                  {
                      echo ** Athletics too low - Taking Ferry
                      gosub INFO_CHECK
                      if %kronars < 100 then goto NOCOIN
                      gosub AUTOMOVE 236
                      gosub FERRYLOGIC
                  }
              pause
              put south
              wait
              put #mapper reset
          }
if ("$zoneid" == "50") then gosub SEGOLTHA_SOUTH
if ("$zoneid" == "60") then gosub AUTOMOVE 57
if ("$zoneid" == "58") then gosub AUTOMOVE 2
if (("$zoneid" == "61") && ("%detour" == "ain")) then gosub AUTOMOVE 126
if (("$zoneid" == "114") && ("%detour" != "ain")) then
          {
              gosub INFO_CHECK
              if (%dokoras < 120) then goto NOCOIN
              gosub AUTOMOVE 4
              gosub FERRYLOGIC
              gosub MOVE west
          }
if (("$zoneid" == "63") && ($Athletics.Ranks < %underGondola)) then
          {
              gosub AUTOMOVE 112
              gosub AUTOMOVE 100
              gosub AUTOMOVE 126
          }
if (("$zoneid" == "112") && ("$guild" == "Ranger") && ($Athletics.Ranks >= %underGondola)) then
          {
               put prep athlet 10
               pause 8
               put cast
          }
if (("$zoneid" == "112") && ("$guild" == "Thief") && ($Athletics.Ranks >= %underGondola) && ($Athletics.Ranks < 600)) then
          {
               put khri flight harrier
               pause 0.5
               pause 0.4
          }
if (("$zoneid" == "112") && ("%detour" == "ain")) then
          {
              if ($Athletics.Ranks >= %underGondola) then
                  {
                      gosub AUTOMOVE 112
                      gosub AUTOMOVE 130
                  }
              if ($Athletics.Ranks < %underGondola) then
                  {
                      gosub INFO_CHECK
                      if (%dokoras < 120) then goto NOCOIN
                      gosub AUTOMOVE 98
                      gosub FERRYLOGIC
                  }
          }
if ("$zoneid" == "112") then gosub AUTOMOVE 112
if ("$zoneid" == "58") then gosub AUTOMOVE 2
if ("$zoneid" == "61") then gosub AUTOMOVE 130
if ("$zoneid" == "63") then gosub AUTOMOVE 112
if (("$zoneid" == "62") && ($Athletics.Ranks >= %underGondola)) then
          {
             gosub AUTOMOVE 41
             pause
             if matchre("$game", "(?i)DRF") then
                   {
                        put sw
                        pause 0.5
                        put sw
                        pause 0.7
                        put s
                        pause 0.5
                        gosub AUTOMOVE 153
                        goto FORD_2
                   }
             if matchre("$game", "(?i)DR") then
                   {
                        put sw
                        pause 0.5
                        put sw
                        pause 0.7
                        put go blockade
                        pause 0.8
                        pause 0.1
                        gosub AUTOMOVE 153
                        goto FORD_2
                   }
          }
if (matchre("$game", "(?i)DRX") && (%portal == 1)) then
     {
          if (matchre("$zoneid", "\b(1|30|40|47|67|90|99|107|116)\b") && (%ported == 0)) then gosub PORTAL_TIME
     }
if (matchre("$game", "(?i)DR") && ("$zoneid" == "62")) then
          {
              gosub AUTOMOVE 41
              put sw
              pause 0.5
              put sw
              pause 0.5
              put go blockade
              pause 0.8
              pause 0.1
              gosub AUTOMOVE 2
              gosub FERRYLOGIC
          }
if (matchre("$game", "(?i)DRF") && ("$zoneid" == "62")) then
          {
              gosub AUTOMOVE 41
              put sw
              pause 0.5
              pause
              put sw
              pause 0.5
              put s
              pause 0.5
              gosub AUTOMOVE 2
              gosub FERRYLOGIC
          }
FORD_2:
if ("$zoneid" == "65") then gosub AUTOMOVE 1
if ("$zoneid" == "68b") then gosub AUTOMOVE 44
if ("$zoneid" == "68a") then gosub AUTOMOVE 29
if ("$zoneid" == "68") then
     {
     if (matchre("$roomname", "(Blackthorn Canyon|Corik's Wall|Stormfells|Shadow's Reach|Reach Forge|Darkling Wood, Trader Outpost)") || (($roomid > 67) && ($roomid < 75))) then
          {
               gosub AUTOMOVE 68
               gosub AUTOMOVE 65
               gosub AUTOMOVE 62
               pause 0.1
          }
     if ($Athletics.Ranks > 250) then
          {
               gosub AUTOMOVE 2
               pause 0.2
               put climb wall
               wait
               pause 0.4
          }
     }
if (("$zoneid" == "68") && matchre("%shardCitizen", "(?i)yes")) then
     {
          gosub AUTOMOVE 1
          pause 0.1
          gosub AUTOMOVE 135
     }
if (("$zoneid" == "68") && matchre("%shardCitizen", "(?i)no")) then gosub AUTOMOVE 15
if (matchre("$game", "(?i)DRX") && (%portal == 1)) then
     {
          if (matchre("$zoneid", "\b(1|30|40|47|67|90|99|107|116)\b") && (%ported == 0)) then gosub PORTAL_TIME
     }
if (("$zoneid" == "67") && ("$guild" == "Thief")) then
          {
              gosub AUTOMOVE 566
              gosub AUTOMOVE 23
          }
if ("$zoneid" == "67a") then gosub AUTOMOVE STR
if ("$zoneid" == "67") then gosub AUTOMOVE West
if ("$zoneid" == "66") then gosub AUTOMOVE 217
delay 0.0001
if ("$zoneid" == "67a") then gosub AUTOMOVE STR
if ("$zoneid" == "67") then gosub AUTOMOVE West
if ("$zoneid" == "66") then gosub AUTOMOVE 217
if ("$zoneid" == "69") then
     {
          gosub AUTOMOVE 283
          pause 0.2
          put #mapper reset
          pause 0.2
     }
FORD_3:
if ("$zoneid" == "69") then
     {
          gosub AUTOMOVE 283
          pause 0.2
          put #mapper reset
          pause 0.2
     }
if (("$zoneid" == "127") && matchre("%detour", "(raven|outer|inner|ain)")) then gosub AUTOMOVE 510
if (("$zoneid" == "126") && matchre("%detour", "(raven|outer|inner|ain)")) then gosub AUTOMOVE 49
if (("$zoneid" == "116") && matchre("%detour", "(raven|ain)")) then gosub AUTOMOVE 3
if (("$zoneid" == "123") && ("%detour" == "ain")) then
          {
              gosub INFO_CHECK
              if (%dokoras < 120) then goto NOCOIN
              gosub AUTOMOVE 174
              gosub FERRYLOGIC
          }
if (("$zoneid" == "123") && ("%detour" == "raven")) then
          {
              gosub AUTOMOVE 133
              goto ARRIVED
          }
if ("$zoneid" == "123") then gosub AUTOMOVE 169
if (("$zoneid" == "116") && ("%detour" == "outer")) then
          {
              gosub AUTOMOVE 225
              goto ARRIVED
          }
if (("$zoneid" == "116") && ("%detour" == "inner")) then
          {
              gosub AUTOMOVE 96
              goto ARRIVED
          }
if (("$zoneid" == "113") && ("$roomid" == "4")) then
          {
              gosub MOVE west
              waitforre ^Obvious
          }
if (("$zoneid" == "113") && ("$roomid" == "8")) then
          {
              gosub MOVE north
          }
if (("$zoneid" == "114") && ("%detour" == "ain")) then gosub AUTOMOVE 34
if ("$zoneid" == "116") then gosub AUTOMOVE 217
if ("$zoneid" == "126") then gosub AUTOMOVE 103
if ("$zoneid" == "127") then gosub AUTOMOVE 24
goto ARRIVED

AESRYBACK:
  pause 0.01
  pause 0.01
  var label AESRYBACK
  if ("$zoneid" == "98") then gosub AUTOMOVE 86
  if (matchre("$game", "(?i)DRX") && (%portal == 1) && (%ported == 0)) then gosub PORTAL_TIME
  if matchre("$game", "(?i)DRF") then goto AESRY_LONG
  gosub AUTOMOVE 427
  gosub JOINLOGIC
  return

QITRAVEL:
  pause 0.01
  var label QITRAVEL
  if (matchre("$game", "(?i)DRX") && (%portal == 1)) then
     {
          if (matchre("$zoneid", "\b(1|30|40|47|67|90|99|107|116)\b") && (%ported == 0)) then gosub PORTAL_TIME
     }
  if !matchre("106|107|108", "$zoneid") then goto therengia
  if (("$zoneid" == "108") && matchre("%detour", "(merk|hara)")) then
            {
                gosub AUTOMOVE 151
                if ("$roomid" != "151") then gosub AUTOMOVE 151
                gosub FERRYLOGIC
            }
  if (("$zoneid" == "107") && ("%detour" == "hara")) then
            {
                gosub AUTOMOVE 78
                gosub FERRYLOGIC
                gosub AUTOMOVE 173
            }
  if (("$zoneid" == "106") && matchre("$game", "(?i)DRF")) then
            {
                gosub AUTOMOVE 102
                gosub JOINLOGIC
                pause
                put #mapper reset
                goto %label
            }
  if (("$zoneid" == "106") && matchre("%detour", "(merk|mriss)")) then
            {
                gosub AUTOMOVE 101
                gosub FERRYLOGIC
            }
  if (("$zoneid" == "107") && ("%detour" == "merk")) then
            {
                gosub AUTOMOVE 194
                goto ARRIVED
            }
  if (("$zoneid" == "107") && ("%detour" == "mriss")) then
            {
                gosub AUTOMOVE 113
                gosub FERRYLOGIC
            }
  if %tomainland then
            {
                gosub AUTOMOVE 222
                var tomainland 0
                var label %backuplabel
                var detour %backupdetour
                gosub JOINLOGIC
                pause
                put #mapper reset
                goto %label
            }
  if (("$zoneid" == "108") && ("%detour" == "mriss")) then
            {
                gosub AUTOMOVE 150
                goto ARRIVED
            }
     goto ARRIVED
#############################################################
ARRIVED:
     if_2 then gosub AUTOMOVE %2 %3 %4
     ### Backup in case Automapper majorly screws up - Double check to make sure it's in the correct Zone ID
     ### If not at your destination will restart script from beginning - Only support for main cities for now
     if (matchre("%destination", "\b(cros?s?i?n?g?s?|xing?)") && ("$zoneid" != "1")) then goto START
     if (matchre("%destination", "\b(rive?r?h?a?v?e?n?|have?n?)") && ("$zoneid" != "30")) then goto START
     if (matchre("%destination", "\b(shar?d?)") && ("$zoneid" != "67")) then goto START
     if (matchre("%destination", "\b(leth)") && ("$zoneid" != "61")) then goto START
     if (matchre("%destination", "\b(hib?a?r?n?h?v?i?d?a?r?|out?e?r?)") && ("$zoneid" != "116")) then goto START
     if (matchre("%destination", "\b(theren?)") && ("$zoneid" != "42")) then goto START
     if (matchre("%destination", "\b(boar?c?l?a?n?)") && ("$zoneid" != "127")) then goto START
     echo
     echo ** AMAZING!!
     echo
     echo      |\          .(' *) ' .
     echo      | \        ' .*) .'*
     echo      |(*\      .*(// .*) .
     echo      |___\       // (. '*
     echo      (((''\     // '  * .
     echo      ((c'7')   /\)
     echo      ((((^))  /  \
     echo    .-')))(((-'   /
     echo       (((()) __/'
     echo        )))( |
     echo         (()
     echo          ))
     echo
     ##
  put #parse YOU ARRIVED!
  put #parse YOU ARRIVED!
  put #parse REACHED YOUR DESTINATION
  delay 0.000001
  put #parse YOU ARRIVED!
  put #parse REACHED YOUR DESTINATION
  # put #play Just Arrived.wav
  eval destination toupper("%destination")
  echo ## WOW! YOU ARRIVED AT YOUR DESTINATION: %destination in %t seconds!  That's FAST! ##
  echo ## STARTED FROM: %starting
  put #echo >Log #1ad1ff * TRAVEL ARRIVAL: $zonename (Map: $zoneid | Room: $roomid)
  put #class arrive off
  exit
#####################################################################################
## ENGINE
STOPINVIS:
STOP_INVIS:
     delay 0.0001
     if ("$guild" == "Necromancer") then
          {
               gosub PUT release eotb
               pause 0.1
          }
     if ("$guild" == "Thief") then
          {
               gosub PUT khri stop silence vanish
               pause 0.1
          }
      if ("$guild" == "Ranger") then
          {
               gosub PUT release blend
               pause 0.1
          }
     if matchre("$guild", "(Moon Mage|Moon)") then
          {
               gosub PUT release rf
               pause 0.1
          }
     pause 0.1
     if ($invisible == 1) then
          {
               if ($SpellTimer.RefractiveField.active == 1) then gosub PUT release RF
               if ($SpellTimer.StepsofVuan.active == 1) then gosub PUT release SOV
               if ($SpellTimer.EyesoftheBlind.active == 1) then gosub PUT release EOTB
               if ($SpellTimer.Blend.active == 1) then gosub PUT release BLEND
               if ($SpellTimer.KhriSilence.active == 1) then gosub PUT khri stop silence
               if ($SpellTimer.KhriVanish.active == 1) then gosub PUT khri stop vanish
               pause 0.0001
          }
return
######################################################################################
# RIVER TRAVEL
SEGOLTHA_NORTH:
     pause 0.1
     if matchre("$roomid", "\b(24|25|26|27|28|29|31|42|43|44|45|46)\b") then gosub AUTOMOVE 23
     echo
     echo *** Swimming the Segoltha - Heading NORTH
     echo
     if matchre("$roomid", "\b(7|6|5)\b") then
          {
               gosub MOVE east
               goto SEGOLTHA_NORTH
          }
    if matchre("$roomid", "\b(35|34|33|32)\b") then
          {
               pause 0.1
               gosub AUTOMOVE 3
               return
          }
    if matchre("$roomid", "\b(5|4|3|2|1)\b") then
          {
               gosub AUTOMOVE crossing
               return
          }
     if matchre("$roomid", "\b(7|6|5)\b") then
          {
               gosub MOVE east
               goto SEGOLTHA_NORTH
          }
    if ($north) then gosub MOVE north
    pause 0.1
    goto SEGOLTHA_NORTH
SEGOLTHA_SOUTH:
     pause 0.1
     if ("$zoneid" == "1") then gosub AUTOMOVE segoltha
     if matchre("$roomid", "\b(24|25|26|27|28|29)\b") then
          {
               pause 0.1
               gosub AUTOMOVE south
               return
          }
     echo
     echo *** Swimming the Segoltha - Heading SOUTH
     echo
     if matchre("$roomid", "\b(1|2|3|4|5|6)\b") then
          {
               gosub AUTOMOVE 7
               goto SEGOLTHA_SOUTH
          }
    if (($roomid == 0) && ($south)) then
          {
               gosub MOVE south
               pause 0.1
               goto SEGOLTHA_SOUTH
          }
    if ($south) then gosub MOVE south
    pause 0.1
    if ((!$southwest) && (!$southeast) && (!$south)) then
          {
               pause 0.1
               gosub AUTOMOVE south
               return
          }
    goto SEGOLTHA_SOUTH
FALDESU_NORTH:
    echo
    echo *** Swimming the Faldesu - Heading NORTH
    echo
    gosub MoveAllTheWay north
    if ($northwest) then
         {
             gosub MOVE northwest
             gosub MoveAllTheWay northeast
         }
    if ((!$northwest) && (!$northeast) && (!$north)) then
         {
              gosub Move climb stone bridge
              pause 0.01
              put #mapper reset
              pause 0.001
              return
         }
    goto FALDESU_NORTH
FALDESU_SOUTH:
    echo
    echo *** Swimming the Faldesu - Heading SOUTH
    echo
    if ($south) then
         {
             gosub MOVE south
             pause 0.1
             goto FALDESU_SOUTH
         }
    if ($southwest) then
         {
             gosub Move southwest
             pause 0.1
             gosub MoveAllTheWay southeast
         }
    if ((!$southwest) && (!$southeast) && (!$south)) then
         {
              pause 0.1
              gosub Move climb stone bridge
              pause 0.01
              put #mapper reset
              pause 0.001
              return
         }
    goto FALDESU_SOUTH
MoveAllTheWay:
    # Keeps moving in a direction until it is no longer a portal option
    var direction $1
MovingAllTheWay:
    if $%direction then gosub Move %direction
    pause .1
    if $%direction then goto MovingAllTheWay
    return
PASSPORTCHECK:
  pause 0.2
  put get my passport
  pause 1
  pause 0.4
  if !matchre("$righthand $lefthand", "passport") then put get my passport from my portal
  pause
  pause
  if !matchre("$righthand $lefthand", "passport") then var passport 0
  if matchre("$righthand $lefthand", "passport") then var passport 1
  put stow passport
  pause 0.4
  return
################################################################################################################
### STANDALONE FERRY CHECK TO MAKE SURE WE AREN'T IN A FERRY (USED FOR RANDOMMOVE SUB IF SCRIPT GETS LOST IN A ROOMID == 0)
FERRY_CHECK:
  delay 0.000001
  var OffTransport dock
  action var OffTransport platform when a barge platform
  action var OffTransport pier when the Riverhaven pier
  action var OffTransport beach when You also see the beach|mammoth and the beach
  action var OffTransport ladder when You also see a ladder|mammoth and a ladder
  action var OffTransport wharf when the Langenfirth wharf
  action var OffTransport dock when \[\"Her Opulence\"\]|\[\"Hodierna's Grace\"\]|\[\"Kertigen's Honor\"\]|\[\"His Daring Exploit\"\]|\[The Evening Star\]|\[The Damaris' Kiss\]|\[A Birch Skiff\]|\[A Highly Polished Skiff\]|\[\"Imperial Glory\"\]|\[\"The Riverhawk\"\]|Baso Docks|a dry dock|the salt yard dock|covered stone dock|\[The Galley Sanegazat\]|\[The Galley Cercorim\]|\[Aboard the Warship, Gondola\]|\[The Halasa Selhin, Main Deck\]|the south bank docks\.
  delay 0.0001
  matchre ONFERRY \[\"Her Opulence\"\]|\[\"Hodierna's Grace\"\]|\[\"Kertigen's Honor\"\]|\[\"His Daring Exploit\"\]|\[\"Northern Pride\", Main Deck\]|\[\"Theren's Star\", Deck\]|\[The Evening Star\]|\[The Damaris' Kiss\]|\[A Birch Skiff\]|\[A Highly Polished Skiff\]|\[\"The Desert Wind\"\]|\[\"The Suncatcher\"\]|\[\"The Riverhawk\"\]|\[\"Imperial Glory\"\]\"Hodierna's Grace\"|\"Her Opulence\"\]|\[The Galley Cercorim\]|\[The Jolas, Fore Deck\]|\[Aboard the Warship, Gondola\]|\[The Halasa Selhin, Main Deck\]|\[Aboard the Mammoth, Platform\]
  matchre ONFERRY Secured to the gigantic balloon overhead, the armored ironwood gondola dangles on a convoluted network of hempen rope\.
  matchre ONFERRY ^One of the barge's crew members stops you and requests a transportation fee|A row of benches occupies the deck
  matchre ONFERRY Long, wide and low, this vessel is built for utility, but the hand of luxury can be discerned in the ornately carved walnut railings, down-cushioned benches and the well polished deck
  matchre ONFERRY ^A few weary travelers lean against a railing at the bow of this ferry, anxiously waiting to reach the opposite bank\.
  matchre ONFERRY ^The ferry rocks gently as you step aboard\. Surrounded by the cool, briny air of the Segoltha, you take your place on the deserted deck and gaze up into the night sky\.
  matchre ONFERRY ^Most of the passengers on this low riding barge have descended into quiet conversation, not wishing to stir the night\. A single lantern, swinging from the fore rail, pushes its dull gold rays across the dark water\.
  matchre ONFERRY ^This is the only barge of its type to ply the waters of Lake Gwenalion|^A white-washed wood railing surrounds the entire upper deck of the barge
  matchre ONFERRY ^The first of the massive barges to traverse Lake Gwenalion, \"Theren's Star\" still maintains a quiet elegance despite its apparent age\.
  matchre ONFERRY ^Long and low, the sleek lines of the ferry are designed so that it slips through the water with a minimum of disturbance\.
  matchre ONFERRY ^This particular skiff is roomy and solid with benches only slightly worn from use
  matchre ONFERRY ^The newly crafted skiff smells of fresh wood and paint\.
  matchre ONFERRY ^The warship (continues|rumbles)|^The din of battle abates as the Gnomish crew|^Sputtering loudly, the cast\-iron stove
  matchre ONFERRY ^The resounding boom of a nearby cannon|^A flaming arrow narrowly misses the balloon|^Your ears are left ringing as the crew begins to fire the cannons|^Fang's Peak sinks below the southern horizon
  matchre ONFERRY ^The Desert Wind barge is made up of a wooden flatboat mounted atop steel rails
  matchre ONFERRY ^The deck of the wooden barge is mostly covered with tightly packed crates and barrels, all tied down so as not to tumble about or fall overboard during the sometimes turbulent river journeys\.
  matchre ONFERRY ^A row of water-stained benches occupies the deck of the Imperial Glory, where wealthy passengers can sit at ease and view the beautiful landscape, rolling forests and a few sandy beaches, of southern Therengia\.
  matchre ONFERRY ^The light bowl-shaped boat has a blue leather hide stretched tightly over its birch sapling frame
  matchre ONFERRY ^Flecks of foam spray through the air when the Jolas cuts through the waves\.
  matchre ONFERRY ^The deck is split down the middle by an open pit, bracketed on each end by the two masts\.
  matchre ONFERRY ^Walking in this tiny area is difficult due to the litter of ropes, some coiled and some stretching from the railings and belaying pins up into the maze of wood and canvas above\.
  matchre ONFERRY ^In anticipation of the sudden influx of passengers, makeshift benches have been hastily constructed from kegs, driftwood, and nets stretched tight between boards, then have been cleverly placed so that they are as out of the way as possible\.
  matchre ONFERRY ^Passengers and cargo crowd the deck of the sleek, black galley\.
  matchre ONFERRY ^The light bowl-shaped boat has a new leathery hide stretched tightly over its birch sapling frame\.
  matchre ONFERRY ^The galley, like its twin, carries passengers and cargo, but it can easily become a war galley\.
  matchre ONFERRY ^The bowsprit attached to the jib boom on the bow is rigged to hold three triangular foresails in front of the foremast\.
  matchre ONFERRY ^The length of this ferry is filled to capacity with travelers making their way to the opposite bank of the Segoltha
  matchre ONFERRY ^A few weary travelers lean against a railing at the bow of this ferry
  matchre ONFERRY ^Passengers and cargo crowd the deck of the sleek, black galley\.|^The galley, like its twin, carries passengers and cargo,|^Grease spewed from the galley
  matchre ONFERRY ^The Selhin ties off to the Uaro Dock\!
  matchre NOFERRY ^Encumbrance
  send look;-0.8 enc
  pause 0.5
  pause 0.2
  matchwait 5
NOFERRY:
  if matchre ("$roomname","Aboard the Mammoth") then goto ONFERRY
  if matchre ("$roomname","Imperial") then goto ONFERRY
  if matchre ("$roomname","Kertigen") then goto ONFERRY
  if matchre ("$roomname","Hodierna") then goto ONFERRY
  if matchre ("$roomname","Opulence") then goto ONFERRY
  if matchre ("$roomname","Daring") then goto ONFERRY
  if matchre ("$roomname","Northern Pride") then goto ONFERRY
  if matchre ("$roomname","Theren's Star") then goto ONFERRY
  if matchre ("$roomname","Damaris") then goto ONFERRY
  if matchre ("$roomname","Evening Star") then goto ONFERRY
  if matchre ("$roomname","Birch Skiff") then goto ONFERRY
  if matchre ("$roomname","Polished Skiff") then goto ONFERRY
  if matchre ("$roomname","Desert Wind") then goto ONFERRY
  if matchre ("$roomname","Suncatcher") then goto ONFERRY
  if matchre ("$roomname","Riverhawk") then goto ONFERRY
  if matchre ("$roomname","Imperial Glory") then goto ONFERRY
  if matchre ("$roomname","Galley Cercorim") then goto ONFERRY
  if matchre ("$roomname","Jolas") then goto ONFERRY
  if matchre ("$roomname","Aboard the Warship") then goto ONFERRY
  if matchre ("$roomname","Halasa Selhin") then goto ONFERRY
  if matchre("$roomobjs","the beach") then goto OFFTHERIDE
  if matchre("$roomobjs","a ladder") then goto OFFTHERIDE
  return
####################################################################################################
### BEGINNING FERRY CHECK LOGIC - CHECK WHICH LOCATION WE ARE IN (AND/OR WHICH DIRECTION WE ARE GOING) TO TAKE CORRECT FERRY
FERRYLOGIC:
  gosub INFO_CHECK
  if matchre("$zoneid", "\b(1|7|30|35|60|40|41|47|48|90|113|106|107|108|150)\b") then goto FERRY
  if matchre("$roomname", "Aboard the Mammoth") then goto FERRY
  if matchre("$roomname", "Gondola") then
     {
         if matchre("%destination", "\b(acen?e?m?a?c?r?a?|cros?s?i?n?g?s?|xing?|knif?e?c?l?a?n?|tige?r?c?l?a?n?|dirg?e?|arth?e?d?a?l?e?|haiz?e?n?|oasis?|kaer?n?a?|ilay?a?t?a?i?p?|illa?y?a?t?a?i?p?a?|taipa|leth?d?e?r?i?e?l?|acen?a?m?a?c?r?a?|vipe?r?s?|guar?d?i?a?n?s?|leuc?r?o?s?|malod?o?r?o?u?s?|bucc?a?|dokt?|sorr?o?w?s?|misens?e?o?r?|beis?s?w?u?r?m?s?|ston?e?c?l?a?n?|bone?w?o?l?f?|germ?i?s?h?d?i?n?|alfr?e?n?s?|cara?v?a?n?s?a?r?y?|rive?r?h?a?v?e?n?|have?n?|ross?m?a?n?s?|ther?e?n?b?o?r?o?u?g?h?|lang?e?n?f?i?r?t?h?|el'?b?a?i?n?s?|elb?a?i?n?s?|raka?s?h?|thro?n?e?|musp?a?r?i?|forn?s?t?e?d?|hvar?a?l?|zaul?f?u?n?g?|mri?s?s?|merk?r?e?s?h?|kre?s?h?|har?a?j?a?a?l?|rath?a?)\b") then
          {
               echo
               echo *** ON GONDOLA! - HEADING NORTH
               echo
               var direction north
               goto ONGONDOLA
          }
         if matchre("%destination", "\b(shar?d?|grani?t?e?|garg?o?y?l?e?|spir?e?|horse?c?l?a?n?|fayr?i?n?s?|steel?c?l?a?w?|cori?k?s?|ada?n?f?|ylo?n?o?|wyve?r?n?|aing?h?a?z?a?l?|rave?n?s?|hib?a?r?n?h?v?i?d?a?r?|out?e?r?|inne?r?|boar?c?l?a?n?|aes?r?y?|sur?l?a?e?n?i?s?|fan?g?|cov?e?)\b") then
          {
               echo
               echo *** ON GONDOLA! - HEADING SOUTH
               echo
               var direction south
               goto ONGONDOLA
          }
        if matchre("%destination", "\bgondola?\b") then goto ARRIVED
     }
  if ("$zoneid" == "66") then
        {
            var direction north
            goto GONDOLA
        }
  if ("$zoneid" == "62") then
        {
            var direction south
            goto GONDOLA
        }
  if matchre("$roomname", ("\[\"Her Opulence\"\]|\[\"Hodierna's Grace\"\]|\[\"Kertigen's Honor\"\]|\[\"His Daring Exploit\"\]|\[\"Northern Pride\", Main Deck\]|\[\"Theren's Star\", Deck\]|\[The Evening Star\]|\[The Damaris' Kiss\]|\[A Birch Skiff\]|\[A Highly Polished Skiff\]|\[\"The Desert Wind\"\]|\[\"The Suncatcher\"\]|\[\"The Riverhawk\"\]|\[\"Imperial Glory\"\]\"Hodierna's Grace\"|\"Her Opulence\"\]|\[The Galley Cercorim\]|\[The Jolas, Fore Deck\]|\[Aboard the Warship, Gondola\]|\[The Halasa Selhin, Main Deck\]|\[Aboard the Mammoth, Platform\]")) then goto FERRY
  else goto NODESTINATION
GONDOLA:
  pause 0.1
  send look
  pause
  pause 0.5
  if matchre("$roomname", "Gondola") then goto ONGONDOLA
  matchre ONGONDOLA \[Gondola, Cab (North|South)\]
  matchwait 3
  echo
  echo *** Waiting for Gondola to arrive
  echo
GONDOLA_LOOP:
  if matchre("$roomobjs", "gondola") then send go gondola
  if matchre("$roomname", "Gondola") then goto ONGONDOLA
  pause 2
  if matchre("$roomobjs", "gondola") then send go gondola
  if matchre("$roomname", "Gondola") then goto ONGONDOLA
  pause 2
  if matchre("$roomobjs", "gondola") then send go gondola
  if matchre("$roomname", "Gondola") then goto ONGONDOLA
  pause 2
  if matchre("$roomobjs", "gondola") then send go gondola
  if matchre("$roomname", "Gondola") then goto ONGONDOLA
  pause 2
  if matchre("$roomobjs", "gondola") then send go gondola
  if matchre("$roomname", "Gondola") then goto ONGONDOLA
  pause 2
  if matchre("$roomobjs", "gondola") then send go gondola
  if matchre("$roomname", "Gondola") then goto ONGONDOLA
  pause 2
  if matchre("$roomobjs", "gondola") then send go gondola
  if matchre("$roomname", "Gondola") then goto ONGONDOLA
  pause 2
  if matchre("$roomobjs", "gondola") then send go gondola
  if matchre("$roomname", "Gondola") then goto ONGONDOLA
  pause 2
  if matchre("$roomobjs", "gondola") then send go gondola
  if matchre("$roomname", "Gondola") then goto ONGONDOLA
  pause 2
  if matchre("$roomobjs", "gondola") then send go gondola
  if matchre("$roomname", "Gondola") then goto ONGONDOLA
  pause 2
  if matchre("$roomobjs", "gondola") then send go gondola
  if matchre("$roomname", "Gondola") then goto ONGONDOLA
  pause 2
  if matchre("$roomobjs", "gondola") then send go gondola
  if matchre("$roomname", "Gondola") then goto ONGONDOLA
  pause 2
  if matchre("$roomobjs", "gondola") then send go gondola
  if matchre("$roomname", "Gondola") then goto ONGONDOLA
  pause 2
  echo
  echo *** Waiting for Gondola to arrive
  echo
  goto GONDOLA_LOOP
ONGONDOLA:
  pause 0.8
  if ("%direction" == "north") && ($north == 1) then gosub MOVE north
  if ("%direction" == "south") && ($south == 1) then gosub MOVE south
GONDOLAWAIT:
  echo
  echo *** ON GONDOLA - Heading %direction
  echo
  #if ($out) then goto GONDOLAOUT
  waitforre ^With a soft
  if ($standing == 0) then gosub STAND
GONDOLAOUT:
  if ("%direction" == "north") && ($north == 1) then gosub MOVE north
  if ("%direction" == "south") && ($south == 1) then gosub MOVE south
  put look
  pause 0.8
  send out
  pause
  # put #mapper reset
  pause 0.2
  pause 0.2
  return

INVIS:
  gosub STOP_INVIS
#################################################################################
### MAIN FERRY LOGIC - CHECK FOR AND WAIT TO BOARD FERRY 
FERRY:
  delay 0.0001
  var OnFerry 0
  var TransportName NULL
  var OffTransport dock
  action var OffTransport platform when a barge platform
  action var OffTransport pier when the Riverhaven pier
  action var OffTransport beach when You also see the beach|mammoth and the beach
  action var OffTransport ladder when You also see a ladder|mammoth and a ladder
  action var OffTransport wharf when the Langenfirth wharf
  action var OffTransport dock when \[\"?Her Opulence\"?\]|\[\"?Hodierna's Grace\"?\]|\[\"?Kertigen's Honor\"?\]|\[\"?His Daring Exploit\"?\]|\[The Evening Star\]|\[The Damaris' Kiss\]|\[A Birch Skiff\]|\[A Highly Polished Skiff\]|\[\"?Imperial Glory\"?\]|\[\"?The Riverhawk\"?\]|\[\"?The Kree'la, Main Deck\"?]\|\[\"?The Skirr'lolasu, Main Deck\"?\]|Baso Docks|a dry dock|the salt yard dock|covered stone dock|\[The Galley Sanegazat\]|\[The Galley Cercorim\]|\[Aboard the Warship, Gondola\]|\[The Halasa Selhin, Main Deck\]|the south bank docks\.
  action var TransportName Kertigen's Honor when Kertigen's Honor
  action var TransportName Hodierna's Grace when Hodierna's Grace
  action var TransportName Her Opulence when Her Opulence
  action var TransportName His Daring Exploit when His Daring Exploit
  action var TransportName Northern Pride when Northern Pride
  action var TransportName Theren's Star when Theren's Star
  action var TransportName The Damaris when The Damaris
  action var TransportName Evening Star when Evening Star
  action var TransportName Birch Skiff when Birch Skiff
  action var TransportName Polished Skiff when Polished Skiff
  action var TransportName Desert Wind when Desert Wind
  action var TransportName Suncatcher when Suncatcher
  action var TransportName Riverhawk when Riverhawk
  action var TransportName Imperial Glory when Imperial Glory
  action var TransportName Galley Cercorim when Galley Cercorim
  action var TransportName Jolas when Jolas
  action var TransportName Warship when Aboard the Warship
  action var TransportName Halasa Selhin when Halasa Selhin
  action var TransportName Night Sky when Night Sky
  action var TransportName Skirr'lolasu when Skirr'lolasu
  action var TransportName Kree'la when Kree'la
  action var TransportName Sanegazat when Sanegazat
  action var TransportName Degan when Degan
  action var OnFerry 1 when \[\"?Imperial Glory\"?
  action var OnFerry 1 when \[\"?Kertigen's Honor\"?
  action var OnFerry 1 when \[\"?Hodierna's Grace\"?
  action var OnFerry 1 when \[\"?Her Opulence\"?
  action var OnFerry 1 when \[\"?His Daring Exploit\"?
  action var OnFerry 1 when \[\"?Theren's Star\"?
  action var OnFerry 1 when \[\"?A Birch Skiff\"?
  action var OnFerry 1 when \[\"?A Highly Polished Skiff\"?
  action var OnFerry 1 when \[\"?Aboard the Warship\"?
  action var OnFerry 1 when \[\"?(The )?Desert Wind\"?
  action var OnFerry 1 when \[\"?(The )?Suncatcher\"?
  action var OnFerry 1 when \[\"?(The )?Damaris' Kiss\"?
  action var OnFerry 1 when \[\"?(The )?Evening Star\"?
  action var OnFerry 1 when \[\"?(The )?Riverhawk\"?
  action var OnFerry 1 when \[\"?(The )?Galley Cercorim\"?
  action var OnFerry 1 when \[\"?(The )?Jolas\"?
  action var OnFerry 1 when \[\"?(The )?Halasa Selhin\"?
  action var OnFerry 1 when \[\"?(The )?Night Sky\"?
  action var OnFerry 1 when \[\"?(The )?Kree'la\"?
  action var OnFerry 1 when \[\"?(The )?Skirr'lolasu\"?
  action var OnFerry 1 when \[\"?(The )?Galley Sanegazat\"?
  action var OnFerry 1 when \[\"?Degan\"?
  if ($invisible) then gosub STOP_INVIS
  delay 0.0001
  if (%OnFerry == 1) then goto ONFERRY
  echo
  echo ##############
  echo # Checking for a Transport...
  echo ##############
  echo
  matchre ONFERRY \[\"Her Opulence\"\]|\[\"Hodierna\'s Grace\"\]|\[\"Kertigen\'s Honor\"\]|\[\"His Daring Exploit\"\]|\[\"?The Kree'la, Main Deck\"?]\|\[\"?The Skirr'lolasu, Main Deck\"?\]|\[\"Northern Pride\", Main Deck\]|\[\"Theren's Star\", Deck\]|\[The Evening Star\]|\[The Damaris' Kiss\]|\[A Birch Skiff\]|\[A Highly Polished Skiff\]|\[\"The Desert Wind\"\]|\[\"The Suncatcher\"\]|\[\"The Riverhawk\"\]|\[\"Imperial Glory\"\]\"Hodierna's Grace\"|\[\"Her Opulence\"\]|\[The Galley Cercorim\]|\[The Jolas, Fore Deck\]|\[Aboard the Warship, Gondola\]|\[The Halasa Selhin, Main Deck\]|\[Aboard the Mammoth, Platform\]
  matchre ONFERRY Secured to the gigantic balloon overhead, the armored ironwood gondola dangles on a convoluted network of hempen rope\.
  matchre ONFERRY ^One of the barge's crew members stops you and requests a transportation fee|A row of benches occupies the deck
  matchre ONFERRY Long, wide and low, this vessel is built for utility, but the hand of luxury can be discerned in the ornately carved walnut railings, down-cushioned benches and the well polished deck
  matchre ONFERRY ^A few weary travelers lean against a railing at the bow of this ferry, anxiously waiting to reach the opposite bank\.
  matchre ONFERRY ^The ferry rocks gently as you step aboard\. Surrounded by the cool, briny air of the Segoltha, you take your place on the deserted deck and gaze up into the night sky\.
  matchre ONFERRY ^Most of the passengers on this low riding barge have descended into quiet conversation, not wishing to stir the night\. A single lantern, swinging from the fore rail, pushes its dull gold rays across the dark water\.
  matchre ONFERRY ^This is the only barge of its type to ply the waters of Lake Gwenalion|^A white-washed wood railing surrounds the entire upper deck of the barge
  matchre ONFERRY ^The first of the massive barges to traverse Lake Gwenalion, \"Theren's Star\" still maintains a quiet elegance despite its apparent age\.
  matchre ONFERRY ^Long and low, the sleek lines of the ferry are designed so that it slips through the water with a minimum of disturbance\.
  matchre ONFERRY ^This particular skiff is roomy and solid with benches only slightly worn from use
  matchre ONFERRY ^The newly crafted skiff smells of fresh wood and paint\.
  matchre ONFERRY ^The warship (continues|rumbles)|^The din of battle abates as the Gnomish crew|^Sputtering loudly, the cast-iron stove
  matchre ONFERRY ^The resounding boom of a nearby cannon|^A flaming arrow narrowly misses the balloon|^Your ears are left ringing as the crew begins to fire the cannons|^Fang's Peak sinks below the southern horizon
  matchre ONFERRY ^The Desert Wind barge is made up of a wooden flatboat mounted atop steel rails
  matchre ONFERRY ^The deck of the wooden barge is mostly covered with tightly packed crates and barrels, all tied down so as not to tumble about or fall overboard during the sometimes turbulent river journeys\.
  matchre ONFERRY ^A row of water-stained benches occupies the deck of the Imperial Glory, where wealthy passengers can sit at ease and view the beautiful landscape, rolling forests and a few sandy beaches, of southern Therengia\.
  matchre ONFERRY ^The light bowl-shaped boat has a blue leather hide stretched tightly over its birch sapling frame
  matchre ONFERRY ^Flecks of foam spray through the air when the Jolas cuts through the waves\.
  matchre ONFERRY ^The deck is split down the middle by an open pit, bracketed on each end by the two masts\.
  matchre ONFERRY ^Walking in this tiny area is difficult due to the litter of ropes, some coiled and some stretching from the railings and belaying pins up into the maze of wood and canvas above\.
  matchre ONFERRY ^In anticipation of the sudden influx of passengers, makeshift benches have been hastily constructed from kegs, driftwood, and nets stretched tight between boards, then have been cleverly placed so that they are as out of the way as possible\.
  matchre ONFERRY ^Passengers and cargo crowd the deck of the sleek, black galley\.
  matchre ONFERRY ^The light bowl-shaped boat has a new leathery hide stretched tightly over its birch sapling frame\.
  matchre ONFERRY ^The galley, like its twin, carries passengers and cargo, but it can easily become a war galley\.
  matchre ONFERRY ^The bowsprit attached to the jib boom on the bow is rigged to hold three triangular foresails in front of the foremast\.
  matchre ONFERRY ^The length of this ferry is filled to capacity with travelers making their way to the opposite bank of the Segoltha
  matchre ONFERRY ^A few weary travelers lean against a railing at the bow of this ferry
  matchre ONFERRY ^Passengers and cargo crowd the deck of the sleek, black galley\.|^The galley, like its twin, carries passengers and cargo,|^Grease spewed from the galley
  matchre ONFERRY ^The Selhin ties off to the Uaro Dock\!
  matchre INVIS ^How do you expect .+ crew to let you onboard if they can't see you\?
  send look
  pause 0.7
  if (%OnFerry == 1) then goto ONFERRY
  pause 0.2
  if matchre("$roomobjs", "Gnomish warship") then send join warship
  if matchre("$roomobjs", "Riverhawk") then send go riverhawk
  if matchre("$roomobjs", "Imperial") then send go imperial glory
  if matchre("$roomobjs", "Star") then send go ferry
  if matchre("$roomobjs", "skiff") then send go skiff
  if matchre("$roomobjs", "Kiss") then send go ferry
  if matchre("$roomobjs", "ferry") then send go ferry
  if matchre("$roomobjs", "barge") then send go barge
  if matchre("$roomobjs", "galley") then send go galley
  if matchre("$roomobjs", "Jolas") then send go jolas
  if matchre("$roomobjs", "Skirr'lolasu") then send go skirr
  if matchre("$roomobjs", "Kree'la") then send go kree
  if matchre("$roomobjs", "Selhin") then send go selhin
  if matchre("$roomobjs", "Halasa") then put go selhin
  if matchre("$roomobjs", "warship") then send join warship
  matchwait 5
  if (%OnFerry == 1) then goto ONFERRY
  if ($hidden == 0) then put hide
  pause 10
  echo
  echo ##############
  echo # Waiting for a transport..
  echo ##############
  echo
  pause 0.3
  if ($zoneid == 90) then
     {
          echo ** RATHA PUBLIC TRANSPORTS COULD TAKE A WHILE TO ARRIVE...
          pause 20
     }
  goto FERRY
## RIDING ON A FERRY - WE SHOULD ONLY BE HERE WHEN WE ARE RIDING ON A FERRY - THIS IS FOR THE 'NPC TRANSPORTS'
ONFERRY:
  pause 0.0001
  if (%OffRide == 1) then goto OFFTHERIDE
  var OffRide 0
  var OffTransport dock
  action var OffTransport platform when a barge platform
  action var OffTransport pier when the Riverhaven pier
  action var OffTransport beach when You also see the beach|mammoth and the beach
  action var OffTransport ladder when You also see a ladder|mammoth and a ladder
  action var OffTransport wharf when the Langenfirth wharf
  action var OffTransport dock when \[\"Her Opulence\"\]|\[\"Hodierna's Grace\"\]|\[\"Kertigen's Honor\"\]|\[\"His Daring Exploit\"\]|\[The Evening Star\]|\[The Damaris' Kiss\]|\[A Birch Skiff\]|\[A Highly Polished Skiff\]|\[\"Imperial Glory\"\]|\[\"The Riverhawk\"\]|Baso Docks|a dry dock|the salt yard dock|covered stone dock|\[The Galley Sanegazat\]|\[The Galley Cercorim\]|\[Aboard the Warship, Gondola\]|\[The Halasa Selhin, Main Deck\]|the south bank docks\.
  action var TransportName Imperial Glory when Imperial Glory
  action var TransportName Kertigen's Honor when Kertigen's Honor
  action var TransportName Hodierna's Grace when Hodierna's Grace
  action var TransportName Her Opulence when Her Opulence
  action var TransportName His Daring Exploit when His Daring Exploit
  action var TransportName Northern Pride when Northern Pride
  action var TransportName Theren's Star when Theren's Star
  action var TransportName The Damaris when The Damaris
  action var TransportName Evening Star when Evening Star
  action var TransportName Birch Skiff when Birch Skiff
  action var TransportName Polished Skiff when Polished Skiff
  action var TransportName Desert Wind when Desert Wind
  action var TransportName Suncatcher when Suncatcher
  action var TransportName Riverhawk when Riverhawk
  action var TransportName Imperial Glory when Imperial Glory
  action var TransportName Gallet Cercorim when Gallet Cercorim
  action var TransportName Jolas when Jolas
  action var TransportName Warship when Aboard the Warship
  action var TransportName Halasa Selhin when Halasa Selhin
  action var TransportName Night Sky when Night Sky
  action var TransportName Skirr'lolasu when Skirr'lolasu
  action var TransportName Kree'la when Kree'la
  action var TransportName Sanegazat when Sanegazat
  action var TransportName Degan when Degan
  action var TransportName Mammoth when Aboard the Mammoth
  action var OffRide 1 when dock and its crew ties the (ferry|barge) off\.|^You come to a very soft stop|^The skiff lightly taps|^The sand barge pulls into dock
  action var OffRide 1 when ^The barge pulls into dock|The crew ties it off and runs out the gangplank\.
  action var OffRide 1 when ^The captain barks the order to tie off the .+ to the docks\.
  action var OffRide 1 when ^The warship lands with a creaky lurch|^The captain barks the order to tie off .+ to the docks\.|returning to Fang Cove|returning to Ratha
  matchre OASIS_CHECK ^The sand barge pulls up to a desert oasis and stops\.
  matchre OFFTHERIDE dock and its crew ties the (ferry|barge) off\.|^You come to a very soft stop|^The skiff lightly taps|^The sand barge pulls into dock
  matchre OFFTHERIDE ^The barge pulls into dock|The crew ties it off and runs out the gangplank\.
  matchre OFFTHERIDE ^The captain barks the order to tie off the .+ to the docks\.
  matchre OFFTHERIDE ^The warship lands with a creaky lurch|^The captain barks the order to tie off .+ to the docks\.|returning to Fang Cove|returning to Ratha
  pause 0.001
  put look
  pause
  if (%OffRide == 1) then goto OFFTHERIDE
  echo
  echo ###############
  echo # Riding on Public Transport!
  echo # %TransportName
  echo ###############
  echo
  if ($hidden == 0) then
     {
          send hide
          pause
     }
  if matchre("$roomname", "(Skirr'lolasu|Kree'la)") then
     {
          echo * Transport/Dock waiting times can be extra long on this ferry!
          pause 20
     }
  pause
  if (%OffRide == 1) then goto OFFTHERIDE
  if matchre("$roomobjs", "the beach") && matchre("%destination", "\bratha?") then goto OFFTHERIDE
  if matchre("$roomobjs", "a ladder") && !matchre("%destination", "\bratha?") then goto OFFTHERIDE
  if ("$guild" == "Necromancer") then
     {
          if (($spellROC == 0) || ($spellEOTB == 0)) then gosub NECRO_PREP
     }
  if (%OffRide == 1) then goto OFFTHERIDE
  matchwait 60
  goto ONFERRY
  
## HALFWAY CHECK FOR THE MUSPARI/OASIS TRANSPORT
OASIS_CHECK:
  pause 0.1
  if matchre("%destination", "\b(haiz?e?n?|oasis?)\b") then
     {
          var OffTransport oasis
          goto OFFTHERIDE
     }
  goto ONFERRY

### GETTING OFF THE FERRY 
OFFTHERIDE:
  pause 0.0001
  var OffTransport dock
  action var OffTransport platform when a barge platform
  action var OffTransport pier when the Riverhaven pier
  action var OffTransport beach when You also see the beach|mammoth and the beach
  action var OffTransport ladder when You also see a ladder|mammoth and a ladder
  action var OffTransport wharf when the Langenfirth wharf
  action var OffTransport dock when \[\"Her Opulence\"\]|\[\"Hodierna's Grace\"\]|\[\"Kertigen's Honor\"\]|\[\"His Daring Exploit\"\]|\[The Evening Star\]|\[The Damaris' Kiss\]|\[A Birch Skiff\]|\[A Highly Polished Skiff\]|\[\"Imperial Glory\"\]|\[\"The Riverhawk\"\]|Baso Docks|a dry dock|the salt yard dock|covered stone dock|\[The Galley Sanegazat\]|\[The Galley Cercorim\]|\[Aboard the Warship, Gondola\]|\[The Halasa Selhin, Main Deck\]|the south bank docks\.
  if ($hidden == 1) then
     {
          send unhide
          pause 0.5
     }
  send look
  pause 0.5
  pause 0.2
  # if ("$guild" == "Necromancer") then
     # {
          # if (($spellROC == 0) || ($spellEOTB == 0)) then gosub NECRO_PREP
     # }
  pause 0.001
  if ($standing == 0) then gosub STAND
  if matchre("$roomname", "Rocky Path") then
     {
          pause 0.001
          send go beach
          pause 0.5
          pause 0.5
          put #mapper reset
          return
     }
  pause 0.001
  pause 0.001
  if matchre("$roomname", "Jolas") then
    {
        pause 0.001
        if matchre("$roomobjs", "Sumilo") then put go dock
        if matchre("$roomobjs", "Wharf") then put go end
        pause 0.5
        pause 0.5
        put #mapper reset
        return
    }
  if ($standing == 0) then gosub STAND
  put go %OffTransport
  wait
  pause 0.7
  put #mapper reset
  return
  
### LOGIC FOR GETTING ON THE MAMMOTHS / WARSHIPS 
### MAINLY USED FOR ISLAND TRAVEL - MAMMOTHS/WARSHIPS ETC FROM ACENAMACRA/RATHA/FANG COVE
JOINLOGIC:
  delay 0.001
  matchre ONJOINED ^\[Aboard the Dirigible, Gondola\]|^\[Alongside a Wizened Ranger\]|^An intricate network of silken rope|^\[Aboard the Balloon, Gondola\]|^A veritable spiderweb of ropes secures|^Thick, barnacle-encrusted ropes secure the platform to the|\[Aboard the Mammoth, Platform\]|\[The Bardess' Fete, Deck\]|^Silken rigging suspends the sweeping teak|\[Aboard the Warship, Gondola\]
  matchre ONJOINED ^You join the Merelew driver|^Thick, barnacle-encrusted ropes secure the platform to the mammoth's back
  put look
  pause 0.3
  pause 0.2
  if matchre("$roomobjs $roomname", "(^\[Aboard the Dirigible, Gondola\]|^\[Alongside a Wizened Ranger\]|^An intricate network of silken rope|^\[Aboard the Balloon, Gondola\]|^A veritable spiderweb of ropes secures|^Thick, barnacle-encrusted ropes secure the platform to the|\[Aboard the Mammoth, Platform\]|\[The Bardess' Fete, Deck\]|^Silken rigging suspends the sweeping teak|\[Aboard the Warship, Gondola\])") then goto ONJOINED
  if matchre("$roomobjs", "warship") then send join warship
  if matchre("$roomobjs", "airship") then put join airship
  if matchre("$roomobjs", "dirigible") then put join dirigible;join dirigible
  if matchre("$roomobjs", "balloon") then put join balloon;join balloon
  if matchre("$roomobjs", "Gnomish warship") then send join warship
  if matchre("$roomobjs", "Riverhawk") then send go riverhawk
  if matchre("$roomobjs", "Imperial") then send go imperial glory
  if matchre("$roomobjs", "Star") then send go ferry
  if matchre("$roomobjs", "skiff") then send go skiff
  if matchre("$roomobjs", "Skirr'lolasu") then send go skirr
  if matchre("$roomobjs", "Kiss") then send go ferry
  if matchre("$roomobjs", "ferry") then send go ferry
  if matchre("$roomobjs", "barge") then send go barge
  if matchre("$roomobjs", "galley") then send go galley
  if matchre("$roomobjs", "Jolas") then send go jolas
  if matchre("$roomobjs", "Selhin") then send go selhin
  if matchre("$roomobjs", "Halasa") then put go selhin
  if matchre("$roomobjs", "warship") then send join warship
  if matchre("$roomobjs", "wizened ranger") then put join wizened ranger;join wizened ranger
  if (("$zoneid" == "58") && matchre("$roomobjs", "tall sea mammoth")) then put join tall mammoth
  if (("$zoneid" == "90") && matchre("$roomobjs", "massive sea mammoth")) then put join sea mammoth
  if ("$zoneid" == "150") then
        {
            if ("%detour" == "fang") then goto ARRIVED
            if ((%ToRatha == 1) && matchre("$roomobjs", "massive sea mammoth")) then put join sea mammoth
            if ((%ToRatha == 0) && matchre("$roomobjs", "tall sea mammoth")) then put join tall mammoth
            if (("%detour" == "hara") && matchre("$roomobjs", "warship")) then put join warship
        }
  matchwait 3
  echo
  echo ###############
  echo # Waiting for a transport..
  echo ###############
  echo
  pause 3
  if matchre("$roomobjs", "warship") then send join warship
  if matchre("$roomobjs", "airship") then put join airship
  if matchre("$roomobjs", "dirigible") then put join dirigible;join dirigible
  if matchre("$roomobjs", "balloon") then put join balloon;join balloon
  if matchre("$roomobjs", "Gnomish warship") then send join warship
  if matchre("$roomobjs", "Riverhawk") then send go riverhawk
  if matchre("$roomobjs", "Imperial") then send go imperial glory
  if matchre("$roomobjs", "Star") then send go ferry
  if matchre("$roomobjs", "skiff") then send go skiff
  if matchre("$roomobjs", "Skirr'lolasu") then send go skirr
  if matchre("$roomobjs", "Kiss") then send go ferry
  if matchre("$roomobjs", "ferry") then send go ferry
  if matchre("$roomobjs", "barge") then send go barge
  if matchre("$roomobjs", "galley") then send go galley
  if matchre("$roomobjs", "Jolas") then send go jolas
  if matchre("$roomobjs", "Selhin") then send go selhin
  if matchre("$roomobjs", "Halasa") then put go selhin
  if matchre("$roomobjs", "warship") then send join warship
  if matchre("$roomobjs", "wizened ranger") then put join wizened ranger;join wizened ranger
  if (("$zoneid" == "58") && matchre("$roomobjs", "tall sea mammoth")) then put join tall mammoth
  if (("$zoneid" == "90") && matchre("$roomobjs", "massive sea mammoth")) then put join sea mammoth
  if ("$zoneid" == "150") then
        {
            if ("%detour" == "fang") then goto ARRIVED
            if ((%ToRatha == 1) && matchre("$roomobjs", "massive sea mammoth")) then put join sea mammoth
            if ((%ToRatha == 0) && matchre("$roomobjs", "tall sea mammoth")) then put join tall mammoth
            if (("%detour" == "hara") && matchre("$roomobjs", "warship")) then put join warship
        }
  matchwait 3
  goto JOINLOGIC

ONJOINED:
  pause 0.1
ONJOINED1:
  action var TransportName Imperial Glory when Imperial Glory
  action var TransportName Kertigen's Honor when Kertigen's Honor
  action var TransportName Hodierna's Grace when Hodierna's Grace
  action var TransportName Her Opulence when Her Opulence
  action var TransportName His Daring Exploit when His Daring Exploit
  action var TransportName Northern Pride when Northern Pride
  action var TransportName Theren's Star when Theren's Star
  action var TransportName The Damaris when The Damaris
  action var TransportName Evening Star when Evening Star
  action var TransportName Birch Skiff when Birch Skiff
  action var TransportName Polished Skiff when Polished Skiff
  action var TransportName Desert Wind when Desert Wind
  action var TransportName Suncatcher when Suncatcher
  action var TransportName Riverhawk when Riverhawk
  action var TransportName Imperial Glory when Imperial Glory
  action var TransportName Gallet Cercorim when Gallet Cercorim
  action var TransportName Jolas when Jolas
  action var TransportName Warship when Aboard the Warship
  action var TransportName Halasa Selhin when Halasa Selhin
  action var TransportName Night Sky when Night Sky
  action var TransportName Skirr'lolasu when Skirr'lolasu
  action var TransportName Kree'la when Kree'la
  action var TransportName Sanegazat when Sanegazat
  action var TransportName Degan when Degan
  action var TransportName Mammoth when Aboard the Mammoth
  put look
  pause 0.5
  echo
  echo ##############
  echo # Riding on a Transport!
  echo # %TransportName
  echo ##############
  echo
  matchre OFFJOINED ^The grasses of this wide clearing|^From its northwest-facing position|^A deep firepit has been hacked into the frozen earth
  matchre OFFJOINED ^The distance between the surrounding hills is narrower|^The ironwood platform has withstood|^A rickety platform in the top of this huge
  matchre OFFJOINED ^Beyond the harbor, spray is thrown|^Giant boulders are scattered|^Crudely assembled yet sturdy just the
  matchre OFFJOINED \[Fang Cove, Dock\]|\[Smuggler's Wharf\]|\[Outside Muspar'i\]|\[Northeast Wilds, Grimsage Way\]
  matchre OFFJOINED ^The once pristine tower of the Warrior Mages|returning to Fang Cove|returning to Ratha
  matchwait 22
  goto ONJOINED1
OFFJOINED:
  put look
  wait
  if matchre("$roomname", "(Rocky Path|Shore Walk)") then put go beach
  pause
  put #mapper reset
  return
### END OF FERRY LOGIC 
########################################################################################################
PASSPORT_CHECK:
  pause 0.2
  matchre YES_PASSPORT ^You tap
  matchre PASSPORT_CHECK2 ^What were you|^I could not
  send tap my passport
  matchwait 5
PASSPORT_CHECK2:
  pause 0.1
  send look in my portal
  pause 0.3
  matchre YES_PASSPORT ^You tap
  matchre NO_PASSPORT ^What were you|^I could not
  send tap my passport in my portal
  matchwait 5
NO_PASSPORT:
  var passport 0
  echo * NO MUSPARI PASSPORT
  return
YES_PASSPORT:
  var passport 1
  echo * MUSPARI PASSPORT FOUND!
  return

GET_PASSPORT:
    echo
    echo ===============
    echo ** NO PASSPORT FOUND
    echo ** GOING TO GET ONE
    echo ===============
    echo
    if ("$zoneid" == "40") then gosub AUTOMOVE theren
    pause 0.2
    gosub AUTOMOVE passport
    pause 0.5
    pause 0.2
    put ask lic for passport
    pause 0.5
    put ask lic for passport
    pause 0.5
    gosub STOWING
    gosub AUTOMOVE gate
    return

PASSPORT:
  gosub STOWING
  pause 0.3
  matchre RETURN ^You get|^You are already
  matchre PASSPORT2 ^What were you|^I could not
  send get my passport
  matchwait 5
PASSPORT2:
  pause 0.1
  gosub STOWING
  pause 0.2
  send look in my portal
  pause 0.5
  matchre RETURN ^You get|^You are already
  matchre NOPASSPORT ^What were you|^I could not
  send get my passport from my portal
  matchwait 5

NOPASSPORT:
  echo ### You don't have a Muspari Passport! Go back to Therenborough to get one.
  goto ARRIVED

### COIN LOGIC - GET MONEY FROM THE BANK TO TAKE FERRIES
### ONLY REACHES THIS SUB IF WE DON'T HAVE ENOUGH MONEY ON HAND 
NOCOIN:
  put #parse NO COINS!
  echo
  echo ###################################
  echo # You don't have enough coins to travel - you vagrant!
  echo # Trying to get some coins from the nearest bank!!!
  echo ###################################
  echo
  pause 0.4
  put wealth
  pause
  if ($invisible == 1) then gosub STOP_INVIS
  if ("$zoneid" == "1") then
        {
            var currencyneeded kro
            if (%kronars < 120) then
               {
                    gosub AUTOMOVE exchange
                    gosub KRONARS
               }
            if (%kronars >= 120) then goto COIN_CONTINUE
            gosub AUTOMOVE teller
            if ($invisible == 1) then gosub STOP_INVIS
            put withdraw 120 copper
            wait
        }
  if ("$zoneid" == "60") then gosub AUTOMOVE leth
  if ("$zoneid" == "61") then
        {
            var currencyneeded kro
            gosub AUTOMOVE 57
            if (%kronars < 120) then
               {
                    gosub AUTOMOVE exchange
                    gosub KRONARS
               }
            if (%kronars >= 120) then goto COIN_CONTINUE
            gosub AUTOMOVE teller
            if ($invisible == 1) then gosub STOP_INVIS
            put withdraw 120 copper
            wait
        }
   if ("$zoneid" == "30") then
        {
            var currencyneeded lir
            if (%lirums < 140) then
               {
                    gosub AUTOMOVE exchange
                    gosub LIRUMS
               }
            if (%lirums >= 140) then goto COIN_CONTINUE
            gosub AUTOMOVE teller
            if ($invisible == 1) then gosub STOP_INVIS
            put withdraw 140 copper
            wait
        }
   if ("$zoneid" == "35") then
        {
            var currencyneeded lir
            if (%lirums < 140) then
               {
                    gosub AUTOMOVE exchange
                    gosub LIRUMS
               }
            if (%lirums >= 140) then goto COIN_CONTINUE
            gosub AUTOMOVE teller
            if ($invisible == 1) then gosub STOP_INVIS
            put withdraw 140 copper
            wait
        }
   if ("$zoneid" == "7") then
        {
            var currencyneeded lir
            gosub AUTOMOVE 349
            if (%lirums < 200) then
               {
                    gosub AUTOMOVE exchange
                    gosub LIRUMS
               }
            if (%lirums >= 200) then goto COIN_CONTINUE
            gosub AUTOMOVE teller
            if ($invisible == 1) then gosub STOP_INVIS
            put withdraw 200 copper
            wait
            pause 0.2
            gosub AUTOMOVE exchange
            pause 0.2
            put exchange 200 copper kronar for lirum
            wait
            pause 0.2
        }
    if ("$zoneid" == "40") then
        {
            var currencyneeded lirtoboar
            gosub AUTOMOVE 211
            if (%lirums < %BoarNeeded) then
               {
                    gosub AUTOMOVE exchange
                    gosub LIRUMS
               }
            gosub AUTOMOVE teller
            if (%lirums >= %BoarNeeded) then goto COIN_CONTINUE
            if ($invisible == 1) then gosub STOP_INVIS
            if matchre("%detour", "(mriss|merk|hara)") then
                {
                    var currencyneeded qi
                    put withdraw 10 gold
                }
            else put withdraw %BoarNeeded copper
            wait
        }
    if (("$zoneid" == "113") && ("$roomid" == "4")) then gosub AUTOMOVE 10
    if (("$zoneid" == "113") && ("$roomid" == "9")) then gosub AUTOMOVE 8
    if ("$zoneid" == "114") then
        {
            var currencyneeded dok
            if (%dokoras < 120) then
               {
                    gosub AUTOMOVE exchange
                    gosub DOKORAS
               }
            if (%dokoras > 120) then goto COIN_CONTINUE
            gosub AUTOMOVE teller
            if ($invisible == 1) then gosub STOP_INVIS
            put withdraw 120 copper
            wait
        }
    if (("$zoneid" == "113") && ("$roomid" == "6")) then gosub AUTOMOVE 7
    if ("$zoneid" == "123") then gosub AUTOMOVE hibar
    if (("$zoneid" == "116") && matchre("%detour", "(rossman|lang|theren|rakash|muspari|fornsted|el'bain|mriss|merk|hara)")) then
        {
            var currencyneeded doktotheren
            if (%dokoras < %TherenCoin) then
               {
                    gosub AUTOMOVE exchange
                    gosub DOKORAS
               }
            if (%dokoras > %TherenCoin) then goto COIN_CONTINUE
            gosub AUTOMOVE teller
            if ($invisible == 1) then gosub STOP_INVIS
		  put withdraw %TherenCoin copper
            wait
        }
	if (("$zoneid" == "116") && !matchre("%detour", "(rossman|lang|theren|rakash|muspari|fornsted|el'bain|mriss|merk|hara)")) then
        {
            var currencyneeded dok
            if (%dokoras < 120) then
               {
                    gosub AUTOMOVE exchange
                    gosub DOKORAS
               }
            if (%dokoras > 120) then goto COIN_CONTINUE
            gosub AUTOMOVE teller
            if ($invisible == 1) then gosub STOP_INVIS
            put withdraw 120 copper
            wait
        }
     if (("$zoneid" == "113") && ("$roomid" == "1")) then gosub AUTOMOVE 5
     if ("$zoneid" == "112") then
        {
            var currencyneeded dok
            if (%dokoras < 120) then
               {
                    gosub AUTOMOVE exchange
                    gosub DOKORAS
               }
            if (%dokoras > 120) then goto COIN_CONTINUE
            gosub AUTOMOVE teller
            if ($invisible == 1) then gosub STOP_INVIS
            put withdraw 120 copper
            wait
        }
    if (("$zoneid" == "67") && ("%detour" == "aesry")) then
        {
            var currencyneeded aesry
            gosub AUTOMOVE teller
            if ($invisible == 1) then gosub STOP_INVIS
            if matchre("$game", "(?i)DR") then put withdraw 10 gold
            if matchre("$game", "(?i)DRF") then
               {
                    var currencyneeded lir
                    put withdraw 5 silver
                    wait
                    gosub AUTOMOVE exchange
                    put exchange all dok to lirum
               }
            pause
        }
	if (("$zoneid" == "67") && !matchre("(rossman|lang|theren|rakash|muspari|fornsted|el'bain|mriss|merk|hara|cross|river|haven|arthe|kaerna|stone|sorrow|throne|hvaral)", "%detour")) then
        {
            var currencyneeded kro
            gosub AUTOMOVE exchange
            gosub DOKORAS
            gosub AUTOMOVE teller
            if ($invisible == 1) then gosub STOP_INVIS
            put withdraw 300 copper
            wait
            gosub AUTOMOVE exchange
            pause 0.3
            put exchang 50 copper dok to kro
            wait
            pause 0.5
            if matchre("(rossman|lang|theren|rakash|muspari|fornsted|el'bain|mriss|merk|hara|river|haven|arthe|kaerna|stone|sorrow|throne|hvaral)", "%detour") then put exchang 250 copper dok to lir
            pause 0.5
        }
    if ("$zoneid" == "99") then
        {
            var currencyneeded aesryback
            gosub AUTOMOVE teller
            if ($invisible == 1) then gosub STOP_INVIS
            put withdraw 10 gold
        }
    if ("$zoneid" == "107") then
        {
            var currencyneeded lir
            gosub AUTOMOVE teller
            if ($invisible == 1) then gosub STOP_INVIS
            put withdraw 140 copper
        }
    if ("$zoneid" == "108") then
        {
            echo ## YOU ARE ON MRISS WITH NO COINS!  YOU NEED TO FIND A FRIEND FOR HELP!
            echo ## OR KILL SOME STUFF AND SELL HIDES / GEMS!
            exit
        }
    gosub INFO_CHECK
    pause 0.3
    if (("%currencyneeded" == "kro") && (%kronars < 50)) then goto COINQUIT
    if (("%currencyneeded" == "lirtoboar") && (%lirums < %BoarNeeded)) then goto COINQUIT
    if (("%currencyneeded" == "lir") && (%lirums < 70)) then goto COINQUIT
    if (("%currencyneeded" == "dok") && (%dokoras < 60)) then goto COINQUIT
    if (("%currencyneeded" == "doktotheren") && (%dokoras < %TherenCoin)) then goto COINQUIT
    if (("%currencyneeded" == "aesry") && (%dokoras < 10000)) then goto COINQUIT
    if (("%currencyneeded" == "aesryback") && (%lirums < 10000)) then goto COINQUIT
    if (("%currencyneeded" == "qi") && (%lirums < 10000)) then goto COINQUIT
    put #echo >Log #ffff4d Withdrew ferry money to ride from $zonename
    echo * YOU HAD MONEY IN THE BANK, LET'S TRY THIS AGAIN!
    pause
    goto %label
COIN_CONTINUE:
    put #echo >Log #ffff4d Withdrew ferry money to ride from $zonename
    echo * YOU EXCHANGED SOME MONIES, LET'S TRY THIS AGAIN!
    pause
    goto %label
COINQUIT:
    echo * YOU DIDN'T HAVE ENOUGH MONEY IN THE BANK TO RIDE PUBLIC TRANSPORT.
    echo * EITHER GET MORE ATHLETICS, OR MORE MONEY, FKING NOOB!
    put #echo >Log #ff0000 Travel Script Aborted! No money in bank to ride ferry in $zonename!
    put #parse OUT OF MONEY!
    exit
LIRUMS:
     var Target.Currency LIRUMS
     if ("%kronars" != "0") then gosub EXCHANGE KRONARS
     if ("%dokoras" != "0") then gosub EXCHANGE DOKORAS
     goto EXCHANGE_FINISH
KRONARS:
     var Target.Currency KRONARS
     if ("%lirums" != "0") then gosub EXCHANGE LIRUMS
     if ("%dokoras" != "0") then gosub EXCHANGE DOKORAS
     goto EXCHANGE_FINISH
DOKORAS:
     var Target.Currency DOKORAS
     if ("%kronars" != "0") then gosub EXCHANGE KRONARS
     if ("%lirums" != "0") then gosub EXCHANGE LIRUMS
     goto EXCHANGE_FINISH
EXCHANGE:
     var Coin $0
EXCHANGE_CONTINUE:
     pause 0.01
     matchre EXCHANGE_CONTINUE ^\.\.\.wait\s+\d+\s+sec(?:onds?|s)?\.?|^Sorry,
     matchre EXCHANGE_FINISH ^You hand your money to the money-changer\.\s*After collecting a.* fee, .* hands you .*\.
     matchre EXCHANGE_FINISH Enjoy the holiday, friend\!
     matchre EXCHANGE_FINISH ^The money-changer says crossly, \"A transaction that small isn't worth my time\.\s*The minimum is one bronze or ten coppers\.\"
     matchre EXCHANGE_FINISH ^You count out all of your .* and drop them in the proper jar\.\s*After figuring a .* fee in the ledger beside the jar, you reach into the one filled with .* and withdraw .*\.
     matchre EXCHANGE_FINISH ^One of the guards mutters, \"None of that, $charactername\.\s*You'd be lucky to get anything at all with an exchange that small\.\"
     matchre EXCHANGE_FINISH ^But you don't have any .*\.
     matchre EXCH_INVIS ^How can you exchange money when you can't be seen\?
     matchre EXCHANGE_SMALLER transactions larger than a thousand
     matchre EXCHANGE_FINISH ^There is no money-changer here\.
     put EXCHANGE ALL %Coin FOR %Target.Currency
     matchwait
EXCHANGE_SMALLER:
     pause 0.1
     pause 0.1
     matchre EXCHANGE_SMALLER ^\.\.\.wait\s+\d+\s+sec(?:onds?|s)?\.?|^Sorry,
     matchre EXCHANGE_SMALLER ^You hand your .* to the money-changer\.\s*After collecting a.* fee, .* hands you .*\.
     matchre RETURN ^The money-changer says crossly, \"A transaction that small isn't worth my time\.\s*The minimum is one bronze or ten coppers\.\"
     matchre RETURN ^One of the guards mutters, \"None of that, $charactername\.\s*You'd be lucky to get anything at all with an exchange that small\.\"
     matchre EXCH_INVIS ^How can you exchange money when you can't be seen\?
     matchre EXCHANGE_CONTINUE Enjoy the holiday, friend\!
     matchre EXCHANGE_CONTINUE ^You count out all of your .* and drop them in the proper jar\.\s*After figuring a .* fee in the ledger beside the jar, you reach into the one filled with .* and withdraw .*\.
     matchre EXCHANGE_CONTINUE ^But you don't have any .*\.
     matchre EXCHANGE_CONTINUE ^You don't have that many
     matchre EXCHANGE_FINISH ^There is no money-changer here\.
     put EXCHANGE 1000 plat %Coin FOR %Target.Currency
     matchwait
EXCHANGE_FINISH:
     pause 0.001
     put wealth
     pause 0.5
     RETURN
EXCH_INVIS:
     delay 0.001
     gosub STOP_INVIS
     goto EXCHANGE_CONTINUE

TO_SEACAVE:
TO_SEACAVES:
     if ("$zoneid" == "67") then gosub AUTOMOVE east
     if ("$zoneid" == "127") then gosub AUTOMOVE south
     if ("$zoneid" == "124") then gosub AUTOMOVE hib
     if ("$zoneid" == "112") then gosub AUTOMOVE leth
     if ("$zoneid" == "4") then gosub AUTOMOVE cross
     if ("$zoneid" == "7") then gosub AUTOMOVE cross
     if ("$zoneid" == "67") then gosub AUTOMOVE east
     if ("$zoneid" == "42") then gosub AUTOMOVE gate
     pause 0.1
     gosub AUTOMOVE portal
     pause 0.5
     if ($invisible == 1) then gosub STOP_INVIS
     if ($invisible == 1) then gosub STOP_INVIS
     pause 0.2
     send go meeting portal
     pause 0.5
     pause 0.2
     return

INFO_CHECK:
     action put #var guild $1 when Guild\:\s+(.*)$
     action put #var circle $1 when Circle\: (\d+)
     action var kronars 0 when No Kronars\.
     action var kronars $1;eval kronars replacere("%kronars", ",", "") when \(([0-9,]*) copper Kronars\)\.
     action var lirums 0 when No Lirums\.
     action var lirums $1;eval lirums replacere("%lirums", ",", "") when \(([0-9,]*) copper Lirums\)\.
     action var dokoras 0 when No Dokoras\.
     action var dokoras $1;eval dokoras replacere("%dokoras", ",", "") when \(([0-9,]*) copper Dokoras\)\.
     delay 0.0001
     send info;encumbrance
     waitforre ^\s*Encumbrance\s*\:
     pause 0.001
     delay 0.001
     delay 0.001
     action remove Guild\:\s+(.*)$
     action remove Circle\: (\d+)
     return

###########################################################################################################
## Plat Portals
#########################################################
EKKO:
     echo
     echo ========================
     echo * USING PLAT PORTALS TO TRAVEL!
     echo * Starting ZoneID:$zoneid RoomID:$roomid
     echo * Final Destination: %destination
     echo ========================
     echo
     pause 0.02
return
PORTAL_TIME:
     action var portal 0;var ported 0 when ^You step towards the shimmering portal, but the wall of magic around it flares\.
## CROSS PORTAL ENTRANCE Zone 1 Room 484
CROSS_PORTAL:
     if ("$zoneid" == "1") then
          {
               if matchre("%destination", "cross?i?n?g?s?") then return
               if matchre("%destination", "\b(knif?e?c?l?a?n?|tige?r?c?l?a?n?|dirg?e?|arth?e?d?a?l?e?|kaer?n?a?|ilay?a?t?a?i?p?|illa?y?a?t?a?i?p?a?|taipa|leth?d?e?r?i?e?l?|acen?a?m?a?c?r?a?|vipe?r?s?|guar?d?i?a?n?s?|leuc?r?o?s?|malod?o?r?o?u?s?|bucc?a?|dokt?|sorr?o?w?s?|misens?e?o?r?|beis?s?w?u?r?m?s?|ston?e?c?l?a?n?|bone?w?o?l?f?|germ?i?s?h?d?i?n?|alfr?e?n?s?|cara?v?a?n?s?a?r?y?)\b") then return
               pause 0.01
               if ($roomid != 484) then gosub AUTOMOVE 484
               if ($roomid != 484) then goto CROSS_PORTAL
               gosub EKKO
               pause 0.1
               var ported 1
               put go portal
               wait
               pause 0.4
               pause 0.1
               if (%ported == 0) then return
               put #mapper reset
               pause 0.4
               if ($roomid == 0) then gosub RANDOMMOVE
               if ($roomid == 0) then gosub RANDOMMOVE
               if matchre("%destination", "aesr?y?") then goto ARRIVED
          }
## AESRY PORTAL ENTRANCE Zone 99 Room 115
AESRY_PORTAL:
     if ("$zoneid" == "99") then
          {
               if matchre("%destination", "aesr?y?") then return
               pause 0.3
               if ($roomid != 115) then gosub AUTOMOVE 115
               if ($roomid != 115) then goto AESRY_PORTAL
               gosub EKKO
               pause 0.2
               var ported 1
               put go portal
               wait
               pause 0.4
               pause 0.1
               if (%ported == 0) then return
               put #mapper reset
               pause 0.2
               if ($roomid == 0) then gosub RANDOMMOVE
               if ($roomid == 0) then gosub RANDOMMOVE
               if matchre("%destination", "shard?") then goto ARRIVED
               if matchre("%destination", "\b(grani?t?e?|garg?o?y?l?e?|spir?e?|horse?c?l?a?n?|fayr?i?n?s?|steel?c?l?a?w?|cori?k?s?|ada?n?f?|ylo?n?o?|wyve?r?n?|rave?n?s?|fan?g?|cov?e?)\b") then
                    {
                         gosub clear
                         goto ILITHI
                    }
          }
## SHARD PORTAL ENTRANCE Zone 67 Room 455
SHARD_PORTAL:
     if ("$zoneid" == "67") then
          {
               if matchre("%destination", "\b(grani?t?e?|garg?o?y?l?e?|spir?e?|horse?c?l?a?n?|fayr?i?n?s?|steel?c?l?a?w?|cori?k?s?|ada?n?f?|ylo?n?o?|wyve?r?n?|rave?n?s?|fan?g?|cov?e?|shard?)\b") then return
               if ($roomid != 455) then gosub AUTOMOVE 455
               if ($roomid != 455) then goto SHARD_PORTAL
               gosub EKKO
               pause 0.2
               var ported 1
               put go portal
               wait
               pause 0.4
               pause 0.1
               if (%ported == 0) then return
               put #mapper reset
               pause 0.4
               if ($roomid == 0) then gosub RANDOMMOVE
               if ($roomid == 0) then gosub RANDOMMOVE
               if matchre("%destination", "(mriss?|merk?r?e?s?h?)") then goto ARRIVED
          }
## MERKRESH PORTAL ENTRANCE Zone 107 Room 273
MERKRESH_PORTAL:
     if ("$zoneid" == "107") then
          {
               if matchre("%destination", "(mriss?|merk?r?e?s?h?)") then return
               pause 0.3
               if ($roomid != 273) then gosub AUTOMOVE 273
               if ($roomid != 273) then goto MERKRESH_PORTAL
               gosub EKKO
               pause 0.2
               var ported 1
               put go portal
               wait
               pause 0.4
               pause 0.1
               if (%ported == 0) then return
               put #mapper reset
               pause 0.4
               if ($roomid == 0) then gosub RANDOMMOVE
               if ($roomid == 0) then gosub RANDOMMOVE
               if matchre("%destination", "(rive?r?h?a?v?e?n?|have?n?|rossm?a?n?)") then goto ARRIVED
          }
## RIVERHAVEN PORTAL ENTRANCE Zone 30 Room 331
RIVERHAVEN_PORTAL:
     if ("$zoneid" == "30") then
          {
               if matchre("%destination", "(riverh?a?v?e?n?|haven|rossman)") then return
               pause 0.3
               if ($roomid != 331) then gosub AUTOMOVE 331
               if ($roomid != 331) then goto RIVERHAVEN_PORTAL
               gosub EKKO
               pause 0.2
               var ported 1
               put go portal
               wait
               pause 0.4
               pause 0.1
               if (%ported == 0) then return
               put #mapper reset
               pause 0.4
               if ($roomid == 0) then gosub RANDOMMOVE
               if ($roomid == 0) then gosub RANDOMMOVE
               if matchre("%destination", "(ratha?)") then goto ARRIVED
          }
## RATHA PORTAL ENTRANCE Zone 90 Room 468
RATHA_PORTAL:
     if ("$zoneid" == "90") then
          {
               if matchre("%destination", "(ratha?)") then return
               pause 0.3
               if ($roomid != 468) then gosub AUTOMOVE 468
               if ($roomid != 468) then goto RATHA_PORTAL
               gosub EKKO
               pause 0.2
               var ported 1
               put go portal
               wait
               pause 0.4
               pause 0.1
               if (%ported == 0) then return
               put #mapper reset
               pause 0.4
               if ($roomid == 0) then gosub RANDOMMOVE
               if ($roomid == 0) then gosub RANDOMMOVE
               if matchre("%destination", "(el'?b?a?i?n?s?|elbai?n?s?)") then goto ARRIVED
               if matchre("%destination", "\b(ther?e?n?b?o?r?o?u?g?h?|lang?e?n?f?i?r?t?h?|el'?b?a?i?n?s?|elb?a?i?n?s?|raka?s?h?|thro?n?e?|forn?s?t?e?d?|hvar?a?l?)\b") then
                    {
                         gosub clear
                         goto THERENGIA
                    }
          }
## ELBAINS PORTAL ENTRANCE Zone 40 Room 254
ELBAINS_PORTAL:
     if ("$zoneid" == "40") then
          {
               if matchre("%destination", "\b(ther?e?n?b?o?r?o?u?g?h?|lang?e?n?f?i?r?t?h?|el'?b?a?i?n?s?|elb?a?i?n?s?|raka?s?h?|thro?n?e?|forn?s?t?e?d?|hvar?a?l?|el'?b?a?i?n?s?|elbai?n?s?|ross?m?a?n?s?)\b") then return
               if ($roomid != 254) then gosub AUTOMOVE 254
               if ($roomid != 254) then goto ELBAINS_PORTAL
               gosub EKKO
               pause 0.2
               var ported 1
               put go portal
               wait
               pause 0.4
               pause 0.1
               if (%ported == 0) then return
               put #mapper reset
               pause 0.4
               if ($roomid == 0) then gosub RANDOMMOVE
               if ($roomid == 0) then gosub RANDOMMOVE
               if matchre("%destination", "(mus?p?a?r?i?)") then goto ARRIVED
          }
## MUSPARI PORTAL ENTRANCE Zone 47 Room 97
MUSPARI_PORTAL:
     if ("$zoneid" == "47") then
          {
               if matchre("%destination", "(mus?p?a?r?i?)") then return
               if ($roomid != 97) then gosub AUTOMOVE 97
               if ($roomid != 97) then goto MUSPARI_PORTAL
               gosub EKKO
               pause 0.2
               var ported 1
               put go portal
               wait
               pause 0.4
               pause 0.1
               if (%ported == 0) then return
               put #mapper reset
               pause 0.4
               if ($roomid == 0) then gosub RANDOMMOVE
               if ($roomid == 0) then gosub RANDOMMOVE
               if matchre("%destination", "(hiba?r?n?h?v?i?d?a?r?)") then goto ARRIVED
               if matchre("%destination", "\b(aing?h?a?z?a?l?|rave?n?s?|hib?a?r?n?h?v?i?d?a?r?|out?e?r?|inne?r?|boar?c?l?a?n?)\b") then
                    {
                         gosub clear
                         goto FORD
                    }
          }
## HIBAR PORTAL ENTRANCE Zone 116 Room 188
HIB_PORTAL:
     if ("$zoneid" == "127") then gosub AUTOMOVE boar
     if ("$zoneid" == "126") then gosub AUTOMOVE boar
     put east
     pause 0.5
     pause 0.2
     if ("$zoneid" == "116") then
          {
               if matchre("%destination", "\b(aing?h?a?z?a?l?|rave?n?s?|hib?a?r?n?h?v?i?d?a?r?|out?e?r?|inne?r?|boar?c?l?a?n?|hiba?r?n?h?v?i?d?a?r?)\b") then return
               if ($roomid != 188) then gosub AUTOMOVE 188
               if ($roomid != 188) then goto HIB_PORTAL
               gosub EKKO
               pause 0.2
               var ported 1
               put go portal
               wait
               pause 0.4
               pause 0.1
               if (%ported == 0) then return
               put #mapper reset
               pause 0.1
               if ($roomid == 0) then gosub RANDOMMOVE
               if ($roomid == 0) then gosub RANDOMMOVE
               if matchre("%destination", "cross?i?n?g?s?") then goto ARRIVED
               if matchre("%destination", "\b(knif?e?c?l?a?n?|tige?r?c?l?a?n?|dirg?e?|arth?e?d?a?l?e?|kaer?n?a?|ilay?a?t?a?i?p?|illa?y?a?t?a?i?p?a?|taipa|leth?d?e?r?i?e?l?|acen?a?m?a?c?r?a?|vipe?r?s?|guar?d?i?a?n?s?|leuc?r?o?s?|malod?o?r?o?u?s?|bucc?a?|dokt?|sorr?o?w?s?|misens?e?o?r?|beis?s?w?u?r?m?s?|ston?e?c?l?a?n?|bone?w?o?l?f?|germ?i?s?h?d?i?n?|alfr?e?n?s?|cara?v?a?n?s?a?r?y?)\b") then
                    {
                         gosub clear
                         goto CROSSING
                    }
          }
     goto CROSS_PORTAL
###############################################################
#### END OF PLAT PORTAL LOGIC
###############################################################
NECRO_PREP:
     if ("$guild" != "Necromancer") then return
     var donotcastlist The Crossing, Western Gate|Northeast Wilds, Outside Northeast Gate
     pause 0.01
     if ($spellEOTB == 0) then gosub EOTB
     #if ($SpellTimer.EyesoftheBlind.active == 0) then gosub EOTB
     if ($SpellTimer.RiteofContrition.active == 0) then gosub ROC
     return
JUSTICE_CHECK:
     pause 0.001
     matchre NECRO_KNOWN sorcerer|monster|necromancer
     matchre NECRO_UNKNOWN You|You're
     send justice
     matchwait 8
     goto NECRO_KNOWN
NECRO_KNOWN:
     var Necro.Known 1
     echo * KNOWN AS A NECRO!
     return
NECRO_UNKNOWN:
     var Necro.Known 0
     echo * NOT KNOWN AS A NECRO
     return
ROC:
     var ROCLoop 0
     var NecroPrep ROC
ROC_1:
     math ROCLoop add 1
     # if matchre("%spelltimer", "Liturgy") && ($Utility.Ranks >= 800) then var NecroPrep ROG
     if (%ROCLoop > 1) then var NecroPrep ROC
     if ($Utility.Ranks < 60) then return
     if (($spellROC == 1) && ("%NecroPrep" == "ROC")) then goto NECRO_DONE
     # if (($spellROG == 1) && ("%NecroPrep" == "ROG")) then goto NECRO_DONE
     echo **** Prepping %NecroPrep ****
     pause 0.1
     if ("$preparedspell" != "None") then send release spell
     pause 0.3
     if ((matchre("$roomobjs", "exchange board")) || (matchre("$roomname", "([T|t]eller|[E|e]xchange|[B|b]ank)")) || (matchre("$roomname", "(%donotcastlist)"))) then
          {
               echo *** BAD ROOM
               return
          }
     # gosub NECRO_CHECKROOM
     if ($Utility.Ranks < 350) then var NecroMana 5
     if (($Utility.Ranks >= 350) && ($Utility.Ranks < 450)) then var NecroMana 7
     if (($Utility.Ranks >= 450) && ($Utility.Ranks < 600)) then var NecroMana 9
     if (($Utility.Ranks >= 600) && ($Utility.Ranks < 800)) then var NecroMana 10
     if (($Utility.Ranks >= 800) && ($Utility.Ranks < 900)) then var NecroMana 12
     if (($Utility.Ranks >= 900) && ($Utility.Ranks < 1000)) then var NecroMana 15
     if ($Utility.Ranks >= 1000) then var NecroMana 20
     pause 0.2
     put prep %NecroPrep %NecroMana
     pause 17
     if ((!("$roomplayers" == "")) && (matchre("$preparedspell", "(Rite of Contrition|Eyes of the Blind)"))) then gosub RANDOMMOVE
     put cast
     pause 0.6
     pause 0.3
     matchre ROC_1 ivory mask|bone structure beneath is subtly altered|gleaming with arcane power|mutative nervous system|whitened ridges|black mist|sheath of spell-disrupting miasma|sensitive eye-cysts
     matchre ROC_RETURN You are
     put look $charactername
     matchwait 2
ROC_RETURN:
     if (($spellROC == 0) && ($spellROG == 0) && (ROCLoop < 2)) then goto ROC_1
     var ROCLoop 0
     return
EOTB:
     var EOTBLoop 0
     var NecroPrep EOTB
EOTB_1:
     if ($invisible == 1) then goto NECRO_DONE
     if ($Utility.Ranks < 30) then return
     pause 0.1
     echo  **** Prepping EOTB ****
     if ("$preparedspell" != "None") then send release spell
     pause 0.3
     ## ** Waits for invis pulse or casts the spell if invisible is off..
     pause 0.1
     if (($SpellTimer.EyesoftheBlind.active == 1) && ($invisible == 0)) then
          {
               ## ** This return is slightly different, it will not wait for pulse inside the exchange.
               ## ** It will also not wait for a pulse if destination == exchange, account or any teller trips to the exchange when moving areas.
               ## ** It should wait for a pulse inside the teller if going anywhere else.
               if (((matchre("$roomobjs", "exchange rate board")) || (matchre("$roomname", "([T|t]eller|[E|e]xchange|[B|b]ank)")) || (matchre("$roomname", "(%donotcastlist)"))) && ((matchre("$roomname", "([T|t]eller|[E|e]xchange|[B|b]ank)")) && (matchre("%Destination", "(teller|exchange)")))) then return
               matchre EOTB_1 ^Your spell subtly|^Your corruptive mutation fades
               matchwait 30
               # put #echo >log Red *** Error with EOTB not pulsing invis. Attempting to recast.
          }
     if ($invisible == 1) then return
     ## ** If script made it to this section then EOTB must be recast.
     ## ** This will not cast while inside the bank or any other unapproved rooms.
     if ((matchre("$roomobjs", "exchange rate board")) || (matchre("$roomname", "([T|t]eller|[E|e]xchange|[B|b]ank)")) || (matchre("$roomname", "(%donotcastlist)"))) then return
     if ($stamina < 30) then return
     # gosub NECRO_CHECKROOM
     if ($Utility.Ranks < 120) then var NecroMana 5
     if ($Utility.Ranks >= 120) && ($Utility.Ranks < 240) then var NecroMana 7
     if ($Utility.Ranks >= 240) && ($Utility.Ranks < 400) then var NecroMana 10
     if ($Utility.Ranks >= 400) && ($Utility.Ranks < 500) then var NecroMana 12
     if ($Utility.Ranks >= 500) && ($Utility.Ranks < 700) then var NecroMana 15
     if ($Utility.Ranks >= 700) then var NecroMana 25
     pause 0.4
     put prep EOTB %NecroMana
     pause 16
     put cast
     pause 0.5
     # if (($invisible == 0) && (EOTBLoop < 1)) then goto EOTB_1
     var EOTBLoop 0
     return
NECRO_DONE:
     delay 0.0001
     return
NECRO_CHECKROOM:
     pause 0.01
     pause 0.01
     pause 0.01
     if !("$roomplayers" == "") then gosub RANDOMMOVE
     send search
     pause $roundtime
     pause 0.5
     if !("$roomplayers" == "") then gosub RANDOMMOVE
     echo **** FOUND EMPTY ROOM! ***
     return
#############################################################################################
#############################################################################################
### ESCAPING MODULES (For Escaping from Areas where Automapper doesn't work/path properly)
#############################################################################################
#############################################################################################
ALDAUTH_ESCAPE:
     pause 0.0001
     gosub AUTOMOVE 682
     pause 0.01
     send go door
     pause 0.8
     pause 0.6
     return
EHHRSK_ESCAPE:
     if (($roomid >= 734) && ($roomid <= 755)) then goto KRAHEI_ESCAPE_1
     if (($roomid >= 756) && ($roomid <= 770)) then goto KRAHEI_ESCAPE_2
     if (($roomid >= 771) && ($roomid <= 782)) then goto KRAHEI_ESCAPE_3
KRAHEI_ESCAPE_1:
     gosub AUTOMOVE 747
     put go valve
     wait
     pause 0.1
     return
KRAHEI_ESCAPE_2:
     gosub AUTOMOVE 760
     put go valve
     wait
     pause 0.1
     return
KRAHEI_ESCAPE_3:
     gosub AUTOMOVE 771
     put go valve
     wait
     pause 0.1
     return

SHARD_FAVOR_ESCAPE:
     echo
     echo *** ESCAPING SHARD FAVOR AREA
     echo
     if ($standing == 0) then gosub STAND
     if matchre("$roomname", "Wyvern Mountain, Raised Dais") then gosub MOVE down
     pause 0.1
     if matchre("$roomname", "Wyvern Mountain, Dragon Shrine") then gosub MOVE up
     if matchre("$roomobjs", "low opening") then goto SHARD_FAVORE_ESCAPE_2
     if matchre("$roomobjs", "black arch") then
          {
               put go black arch
               pause 0.3
          }
     pause 0.1
     goto SHARD_FAVOR_ESCAPE
SHARD_FAVORE_ESCAPE_2:
     pause 0.001
     if ($prone == 0) then send lie
     pause 0.2
     pause 0.1
     if ($prone == 0) then send lie
     pause 0.1
     send go opening
     waitforre ^Tangled brush|\[Wyvern Trail, Clearing\]
     if ($standing == 0) then gosub STAND
     return

MAELSHYVE_FORTRESS_ESCAPE:
     echo ===========================
     echo ** ESCAPING FROM MAELSHYVE'S FORTRESS
     echo ===========================
     gosub AUTOMOVE 109
	gosub MOVE south
     gosub circle
     gosub RETREAT
	move south
	gosub AUTOMOVE 93
	put touch etching
	pause 0.5
	pause 0.5
	pause 0.5
	gosub MOVE south
     gosub MOVE south
     return
BENEATH_ZAULFUNG_ESCAPE:
     echo =======================
     echo ** ESCAPING FROM BENEATH ZAULFUNG
     echo =======================
     pause 0.4
     pause 0.5
     gosub AUTOMOVE 5
     pause 0.5
     if ($zoneid == 31b) then goto BENEATH_ZAULFUNG_ESCAPE
ZAULFUNG_ESCAPE_0:
     gosub AUTOMOVE 121
ZAULFUNG_ESCAPE:
### LESSER SHADOW HOUNDS MAZE Map 31a (Rancid Mire)
if matchre("$roomname", "Trackless Swamp") then gosub ZAULFUNG_ESCAPE_2
     echo ======================
     echo ** ESCAPING FROM LESSER SHADOW HOUNDS
     echo ======================
     if matchre("$roomobjs", "curving path") then goto ZAULFUNG_MAZE_2
     gosub RANDOMWEIGHT west
     if matchre("$roomobjs", "curving path") then goto ZAULFUNG_MAZE_2
     gosub RANDOMWEIGHT west
     if matchre("$roomobjs", "curving path") then goto ZAULFUNG_MAZE_2
     gosub RANDOMWEIGHT west
     if matchre("$roomobjs", "curving path") then goto ZAULFUNG_MAZE_2
     gosub RANDOMMOVE
     if matchre("$roomobjs", "curving path") then goto ZAULFUNG_MAZE_2
     gosub RANDOMMOVE
     if matchre("$roomobjs", "curving path") then goto ZAULFUNG_MAZE_2
     gosub RANDOMMOVE
ZAULFUNG_MAZE_2:
     pause 0.2
     put go path
     wait
     pause 0.5
     return
ZAULFUNG_ESCAPE_2:
     if (matchre("$roomdesc", "Rancid mire")) then gosub ZAULFUNG_ESCAPE
     echo ======================
     echo ** ESCAPING FROM SWAMP TROLLS
     echo ======================
     if !$standing then put stand
     gosub TRUE_RANDOM
     if ($up) then gosub MOVE up
     pause 0.1
     if ($roomid != 0) then return
     gosub TRUE_RANDOM
     if ($up) then gosub MOVE up
     pause 0.1
     if ($roomid != 0) then return
     pause 0.1
     pause 0.1
     goto ZAULFUNG_ESCAPE_2
ZAULFUNG_ESCAPE_3:
     if (matchre("$roomname", "Zaulfung, Chickee")) then gosub ZAULFUNG_ESCAPE
     echo ======================
     echo ** ESCAPING FROM SWAMP TROLLS
     echo ======================
     if !$standing then put stand
     gosub TRUE_RANDOM
     if ($up) then gosub MOVE up
     pause 0.1
     if ($roomid != 0) then return
     gosub TRUE_RANDOM
     if ($up) then gosub MOVE up
     pause 0.1
     if ($roomid != 0) then return
     pause 0.1
     pause 0.1
     goto ZAULFUNG_ESCAPE_2
BROCKET_ESCAPE:
     echo ===================
     echo ** ESCAPING BROCKET DEER
     echo ==================
	 if ($east) then gosub move east
      if ($east) then gosub move east
      if ($east) then gosub move east
      if matchre("$roomobjs", "rolling hill") then
          {
               send climb hill
               pause 0.5
               pause 0.1
          }
      if matchre("$roomobjs", "log fence") then
          {
               send climb fence
               pause 0.5
               gosub move NE
          }
      if ($roomid != 0) then return
      if ($west) then gosub move west
      if ($west) then gosub move west
      if ($west) then gosub move west
      if matchre("$roomobjs", "gentle hill") then
          {
               send climb hill
               pause 0.5
               pause 0.1
          }
	 if ($east) then gosub move east
      if ($east) then gosub move east
      if ($east) then gosub move east
      if matchre("$roomobjs", "log fence") then
          {
               send climb fence
               pause 0.5
               gosub move NE
          }
      if ($roomid != 0) then return
     goto BROCKET_ESCAPE
DEADMAN_ESCAPE:
     echo ===================
     echo ** ESCAPING DEADMAN'S CONFIDE BEACH
     echo ===================
     pause 0.3
     if matchre("$roomdesc", "A cliff wall rises out of sight") then goto DEADMAN_ESCAPE_2
     gosub TRUE_RANDOM
     if matchre("$roomdesc", "A cliff wall rises out of sight") then goto DEADMAN_ESCAPE_2
     gosub TRUE_RANDOM
     if matchre("$roomdesc", "A cliff wall rises out of sight") then goto DEADMAN_ESCAPE_2
     gosub TRUE_RANDOM
     if matchre("$roomdesc", "A cliff wall rises out of sight") then goto DEADMAN_ESCAPE_2
     gosub TRUE_RANDOM
     if matchre("$roomdesc", "A cliff wall rises out of sight") then goto DEADMAN_ESCAPE_2
     gosub TRUE_RANDOM
     if matchre("$roomdesc", "A cliff wall rises out of sight") then goto DEADMAN_ESCAPE_2
     gosub TRUE_RANDOM
     if matchre("$roomdesc", "A cliff wall rises out of sight") then goto DEADMAN_ESCAPE_2
     gosub TRUE_RANDOM
     if matchre("$roomdesc", "A cliff wall rises out of sight") then goto DEADMAN_ESCAPE_2
     gosub TRUE_RANDOM
     if matchre("$roomdesc", "A cliff wall rises out of sight") then goto DEADMAN_ESCAPE_2
     gosub TRUE_RANDOM
     if matchre("$roomdesc", "A cliff wall rises out of sight") then goto DEADMAN_ESCAPE_2
     gosub TRUE_RANDOM
     if matchre("$roomdesc", "A cliff wall rises out of sight") then goto DEADMAN_ESCAPE_2
     gosub TRUE_RANDOM
     if matchre("$roomdesc", "A cliff wall rises out of sight") then goto DEADMAN_ESCAPE_2
     gosub TRUE_RANDOM
     goto DEADMAN_ESCAPE
DEADMAN_ESCAPE_2:
     gosub RETREAT
     pause 0.001
     put climb handhold
     wait
     pause 0.2
     pause 0.2
     put look
     pause 0.2
     if matchre("$roomname", "Deadman's Confide, Beach") then
          {
               gosub TRUE_RANDOM
               pause 0.1
               gosub TRUE_RANDOM
               pause 0.1
               goto DEADMAN_ESCAPE
          }
     return

USHNISH_ESCAPE:
     echo ==================================
     echo ** ESCAPING FANGS OF USHNISH - SHIFTING MAZE
     echo ==================================
USHNISH_ESCAPE_1:
     pause 0.001
     if matchre("$roomname", "Temple of Ushnish") then goto USHNISH_ESCAPE_TEMPLE
     if matchre("$roomname", "Beyond the Gate of Souls") then goto USHNISH_ESCAPE_3
     gosub RANDOMMOVE
     if matchre("$roomobjs", "steep cliff") then goto USHNISH_ESCAPE_2
     gosub RANDOMMOVE
     if matchre("$roomobjs", "steep cliff") then goto USHNISH_ESCAPE_2
     gosub RANDOMMOVE
     if matchre("$roomobjs", "steep cliff") then goto USHNISH_ESCAPE_2
     gosub RANDOMNORTH
     if matchre("$roomobjs", "steep cliff") then goto USHNISH_ESCAPE_2
     gosub RANDOMNORTH
     if matchre("$roomobjs", "steep cliff") then goto USHNISH_ESCAPE_2
     gosub RANDOMNORTH
     if matchre("$roomobjs", "steep cliff") then goto USHNISH_ESCAPE_2
     gosub RANDOMMOVE
     if matchre("$roomobjs", "steep cliff") then goto USHNISH_ESCAPE_2
     gosub RANDOMMOVE
     if matchre("$roomobjs", "steep cliff") then goto USHNISH_ESCAPE_2
     gosub RANDOMMOVE
     if matchre("$roomobjs", "steep cliff") then goto USHNISH_ESCAPE_2
     gosub RANDOMMOVE
     if matchre("$roomobjs", "steep cliff") then goto USHNISH_ESCAPE_2
     gosub RANDOMMOVE
     if matchre("$roomobjs", "steep cliff") then goto USHNISH_ESCAPE_2
     gosub RANDOMSOUTH
     if matchre("$roomobjs", "steep cliff") then goto USHNISH_ESCAPE_2
     gosub RANDOMSOUTH
     if matchre("$roomobjs", "steep cliff") then goto USHNISH_ESCAPE_2
     gosub RANDOMSOUTH
     if matchre("$roomobjs", "steep cliff") then goto USHNISH_ESCAPE_2
     gosub RANDOMSOUTH
     if matchre("$roomobjs", "steep cliff") then goto USHNISH_ESCAPE_2
     gosub RANDOMSOUTH
     if matchre("$roomobjs", "steep cliff") then goto USHNISH_ESCAPE_2
     goto USHNISH_ESCAPE_1
USHNISH_ESCAPE_2:
     pause 0.1
     pause 0.1
     put climb cliff
     pause 0.5
     pause 0.2
USHNISH_ESCAPE_TEMPLE:
     echo =========================
     echo ** ESCAPING TEMPLE OF USHNISH
     echo =========================
     pause 0.5
     if matchre("$roomname", "The Fangs of Ushnish") then goto USHNISH_ESCAPE_1
     if matchre("$roomname", "Temple of Ushnish") then gosub AUTOMOVE 224
     if matchre("$roomname", "Before the Temple of Ushnish") then goto USHNISH_ESCAPE_3
USHNISH_ESCAPE_3:
     pause 0.1
     gosub RETREAT
     put go lava field
     pause 0.5
     pause 0.2
USHNISH_ESCAPE_GATE:
     echo =======================================
     echo ** ESCAPING GATE OF SOULS BLASTED PLAINS MAZE
     echo =======================================
USHNISH_ESCAPE_GATE_1:
     gosub RANDOMMOVE
     if matchre("$roomname", "The Fangs of Ushnish") then goto USHNISH_ESCAPE_1
     if matchre("$roomobjs", "low cavern") then goto USHNISH_ESCAPE_4
     gosub RANDOMMOVE
     if matchre("$roomobjs", "low cavern") then goto USHNISH_ESCAPE_4
     gosub RANDOMMOVE
     if matchre("$roomobjs", "low cavern") then goto USHNISH_ESCAPE_4
     gosub RANDOMMOVE
     if matchre("$roomobjs", "low cavern") then goto USHNISH_ESCAPE_4
     gosub RANDOMNORTH
     if matchre("$roomobjs", "low cavern") then goto USHNISH_ESCAPE_4
     gosub RANDOMNORTH
     if matchre("$roomobjs", "low cavern") then goto USHNISH_ESCAPE_4
     gosub RANDOMNORTH
     if matchre("$roomobjs", "low cavern") then goto USHNISH_ESCAPE_4
     gosub RANDOMNORTH
     if matchre("$roomobjs", "low cavern") then goto USHNISH_ESCAPE_4
     gosub RANDOMNORTH
     if matchre("$roomobjs", "low cavern") then goto USHNISH_ESCAPE_4
     goto USHNISH_ESCAPE_GATE_1
USHNISH_ESCAPE_4:
     pause 0.2
     pause 0.1
     send go cavern
     pause 0.5
     pause 0.5
     send lie
     pause 0.2
     send go tunnel
     waitforre Rising in a snubbed tower
     pause 0.2
     gosub STAND
     gosub AUTOMOVE 104
     return
VELAKADUNES_ESCAPE:
     echo ===========================
     echo ** ESCAPING FROM VELAKA DUNES MAZE
     echo ===========================
VELAKADUNES_ESCAPE_1:
     pause 0.01
     if (matchre("%destination", "(haize?n?)") && matchre("$roomobjs", "(?i)twisting trail")) then
          {
               gosub MOVE go trail
               pause 0.3
               gosub AUTOMOVE 29
               goto ARRIVED
          }
     if (matchre("%destination", "(oasis?)") && matchre("$roomobjs", "(?i)path")) then
          {
               gosub MOVE go path
               pause 0.3
               gosub AUTOMOVE 2
               goto ARRIVED
          }
     if (matchre("%destination", "yeeha?r?") && matchre("$roomobjs", "(?i)canyon")) then
          {
               gosub MOVE go canyon
               pause 0.1
               gosub AUTOMOVE 49
               goto ARRIVED
          }
     if matchre("$roomobjs", "(?i)path") then
          {
               gosub MOVE go path
               pause 0.3
               gosub AUTOMOVE 2
          }
     gosub RANDOMMOVE
     goto VELAKADUNES_ESCAPE_1
VELAKA_ESCAPE:
VELAKA_ESCAPE_1:
     echo =======================
     echo ** ESCAPING FROM VELAKA DESERT MAZE
     echo =======================
     pause 0.001
     if matchre("$roomname", "Walk of Bones") then gosub AUTOMOVE 118
     if (matchre("$roomobjs", "black stone") && !matchre("%destination", "muspar?i?")) then goto VELAKA_ESCAPE_ALT
     if matchre("$roomobjs", "rocky trail") then goto VELAKA_ESCAPE_2
     gosub RANDOMWEIGHT west
     if (matchre("$roomobjs", "black stone") && !matchre("%destination", "muspar?i?")) then goto VELAKA_ESCAPE_ALT
     if matchre("$roomobjs", "rocky trail") then goto VELAKA_ESCAPE_2
     gosub RANDOMWEIGHT west
     if (matchre("$roomobjs", "black stone") && !matchre("%destination", "muspar?i?")) then goto VELAKA_ESCAPE_ALT
     if matchre("$roomobjs", "rocky trail") then goto VELAKA_ESCAPE_2
     gosub RANDOMWEIGHT west
     if (matchre("$roomobjs", "black stone") && !matchre("%destination", "muspar?i?")) then goto VELAKA_ESCAPE_ALT
     if matchre("$roomobjs", "rocky trail") then goto VELAKA_ESCAPE_2
     gosub RANDOMWEIGHT west
     if (matchre("$roomobjs", "black stone") && !matchre("%destination", "muspar?i?")) then goto VELAKA_ESCAPE_ALT
     if matchre("$roomobjs", "rocky trail") then goto VELAKA_ESCAPE_2
     gosub RANDOMMOVE
     if (matchre("$roomobjs", "black stone") && !matchre("%destination", "muspar?i?")) then goto VELAKA_ESCAPE_ALT
     if matchre("$roomobjs", "rocky trail") then goto VELAKA_ESCAPE_2
     gosub RANDOMMOVE
     if (matchre("$roomobjs", "black stone") && !matchre("%destination", "muspar?i?")) then goto VELAKA_ESCAPE_ALT
     if matchre("$roomobjs", "rocky trail") then goto VELAKA_ESCAPE_2
     gosub RANDOMMOVE
     if (matchre("$roomobjs", "black stone") && !matchre("%destination", "muspar?i?")) then goto VELAKA_ESCAPE_ALT
     if matchre("$roomobjs", "rocky trail") then goto VELAKA_ESCAPE_2
     gosub RANDOMMOVE
     if (matchre("$roomobjs", "black stone") && !matchre("%destination", "muspar?i?")) then goto VELAKA_ESCAPE_ALT
     if matchre("$roomobjs", "rocky trail") then goto VELAKA_ESCAPE_2
     gosub RANDOMMOVE
     if (matchre("$roomobjs", "black stone") && !matchre("%destination", "muspar?i?")) then goto VELAKA_ESCAPE_ALT
     if matchre("$roomobjs", "rocky trail") then goto VELAKA_ESCAPE_2
     gosub RANDOMWEIGHT east
     if (matchre("$roomobjs", "black stone") && !matchre("%destination", "muspar?i?")) then goto VELAKA_ESCAPE_ALT
     if matchre("$roomobjs", "rocky trail") then goto VELAKA_ESCAPE_2
     gosub RANDOMWEIGHT east
     if (matchre("$roomobjs", "black stone") && !matchre("%destination", "muspar?i?")) then goto VELAKA_ESCAPE_ALT
     if matchre("$roomobjs", "rocky trail") then goto VELAKA_ESCAPE_2
     gosub RANDOMWEIGHT east
     if (matchre("$roomobjs", "black stone") && !matchre("%destination", "muspar?i?")) then goto VELAKA_ESCAPE_ALT
     if matchre("$roomobjs", "rocky trail") then goto VELAKA_ESCAPE_2
     gosub RANDOMWEIGHT east
     if (matchre("$roomobjs", "black stone") && !matchre("%destination", "muspar?i?")) then goto VELAKA_ESCAPE_ALT
     if matchre("$roomobjs", "rocky trail") then goto VELAKA_ESCAPE_2
     gosub RANDOMWEIGHT east
     if (matchre("$roomobjs", "black stone") && !matchre("%destination", "muspar?i?")) then goto VELAKA_ESCAPE_ALT
     if matchre("$roomobjs", "rocky trail") then goto VELAKA_ESCAPE_2
     gosub RANDOMMOVE
     if (matchre("$roomobjs", "black stone") && !matchre("%destination", "muspar?i?")) then goto VELAKA_ESCAPE_ALT
     if matchre("$roomobjs", "rocky trail") then goto VELAKA_ESCAPE_2
     gosub RANDOMMOVE
     if (matchre("$roomobjs", "black stone") && !matchre("%destination", "muspar?i?")) then goto VELAKA_ESCAPE_ALT
     if matchre("$roomobjs", "rocky trail") then goto VELAKA_ESCAPE_2
     gosub RANDOMMOVE
     if (matchre("$roomobjs", "black stone") && !matchre("%destination", "muspar?i?")) then goto VELAKA_ESCAPE_ALT
     if matchre("$roomobjs", "rocky trail") then goto VELAKA_ESCAPE_2
     gosub RANDOMMOVE
     if (matchre("$roomobjs", "black stone") && !matchre("%destination", "muspar?i?")) then goto VELAKA_ESCAPE_ALT
     if matchre("$roomobjs", "rocky trail") then goto VELAKA_ESCAPE_2
     gosub RANDOMMOVE
     if (matchre("$roomobjs", "black stone") && !matchre("%destination", "muspar?i?")) then goto VELAKA_ESCAPE_ALT
     if matchre("$roomobjs", "rocky trail") then goto VELAKA_ESCAPE_2
     gosub RANDOMMOVE
     if (matchre("$roomobjs", "black stone") && !matchre("%destination", "muspar?i?")) then goto VELAKA_ESCAPE_ALT
     if matchre("$roomobjs", "rocky trail") then goto VELAKA_ESCAPE_2
     gosub RANDOMMOVE
     goto VELAKA_ESCAPE_1
VELAKA_ESCAPE_2:
     send go trail
     wait
     pause 0.1
     return
VELAKA_ESCAPE_ALT:
     send go stone
     wait
     pause 0.1
     return
WARRENS_ESCAPE:
     echo ==========================
     echo ** ESCAPING FROM SHARD WARRENS
     echo ==========================
     pause 0.1
     if ("$guild" == "Necromancer") then
          {
               gosub AUTOMOVE 316
               gosub AUTOMOVE 29
               pause 0.5
               return
          }
     if ("$guild" == "Thief") then
          {
               gosub AUTOMOVE 279
               gosub AUTOMOVE 292
               gosub AUTOMOVE 596
               pause 0.2
               gosub AUTOMOVE 8
               return
          }
     if ("$guild" != "Thief") then
          {
               gosub AUTOMOVE 255
               gosub AUTOMOVE 381
               pause 0.5
               gosub AUTOMOVE 185
               pause 0.2
               send go grate
               waitforre Flush against the rock foundations|Obvious|The water shoves you out|^I could|^YOU HAVE
               return
          }
     return
MAELSHYVE_ASCENT_ESCAPE:
     echo ==============================
     echo ** ESCAPING FROM MAESHYVE'S ASCENT
     echo ==============================
     if ($hidden == 0) then gosub HIDE
     pause 0.1
     gosub AUTOMOVE 447
     pause 0.2
     if ($roomid != 447) then goto MAELSHYVE_ASCENT_ESCAPE
     send go throne
     pause 8
ABYSSAL_ESCAPE:
     pause
     echo ===================
     echo ** ESCAPING FROM ABYSS
     echo ===================
     pause 0.2
     if ($stunned) then waiteval (!$stunned)
     pause
     gosub AUTOMOVE 199
     return
CIRCLE:
     pause 0.2
	put stand circle
	match RETURN As the lights within the circle fade and die, you step out
     matchre RETURN ^You are already standing\.
     matchre RETURN ^You step into the etched circle, but nothing seems to happen, so you step back out\.
	matchwait 40
     goto CIRCLE
ADDERNEST_ESCAPE:
     echo ===========================
     echo ** ESCAPING FROM ADDER'S NEST
     echo ===========================
     pause 0.2
     gosub AUTOMOVE 434
     gosub PUT climb open
     gosub PUT go port
     pause 0.5
     pause 0.2
NORTHWIND_ESCAPE:
     pause 0.2
     gosub AUTOMOVE 506
     pause 0.5
     send pull sconce
     pause 0.5
     pause 0.3
     gosub MOVE go door
     pause 0.3
     gosub MOVE SE
     pause 0.3
ASKETI_ESCAPE:
     put #queue clear
     echo ============================
     echo ** ESCAPING FROM ASKETI'S MOUNT
     echo ============================
     ### 100 foot cliff
     gosub AUTOMOVE 369
     pause 0.1
     gosub AUTOMOVE 124
     pause 0.1
     gosub AUTOMOVE south
     return
CROC_ESCAPE:
     pause 0.1
     echo ============================
     echo ** ESCAPING FROM CROCODILE MAZE
     echo ============================
     var croc.count 0
     var direction sw
     goto CROC_MOVE
CROC_RET:
     gosub retreat
     pause 0.1
CROC_MOVE:
     math croc.count add 1
     if (%croc.count > 6) && ("%direction" == "sw") then
          {
               var direction north
               var croc.count 0
          }
     if (%croc.count > 6) && ("%direction" == "north") then
          {
               var direction south
               var croc.count 0
          }
     if (%croc.count > 6) && ("%direction" == "south") then
          {
               var direction east
               var croc.count 0
          }
     if (%croc.count > 6) && ("%direction" == "east") then
          {
               var direction sw
               var croc.count 0
          }
     pause 0.0001
     pause 0.0001
     matchre CROC_RET ^You are engaged
     matchre CROC_MOVE ^\.\.\.wait|^Sorry, you may only type|^You.*are.*still.*stunned\.
     matchre REEDGO ^.?Roundtime\:?
     put %direction
     matchwait 20
     goto CROC_MOVE
REEDGO:
     pause .0001
     pause 0.1
     pause .0001
     matchre CROC_RET ^You are engaged
     matchre REEDGO ^\.\.\.wait|^Sorry, you may only type|^You.*are.*still.*stunned\.
     matchre CROC_MOVE ^\[The Marsh, In The Water\]|^What were you
     matchre OUT_OF_CROCS ^\[The Marsh, Stone Road\]
     put go reed
     matchwait 20
     goto CROC_MOVE
OUT_OF_CROCS:
     pause .0001
     pause .0001
     put south
     wait
     pause 0.1
     put south
     wait
     pause 0.1
     put south
     wait
     put southeast
     pause 0.5
     if matchre("$roomname", "The Marsh, In The Water") then goto CROC_ESCAPE
     put #parse OUT OF CROCS
     pause 0.5
     return
EMPTY_HANDS:
     delay 0.0001
     if ("$lefthand" != "Empty") then gosub STOW my $lefthandnoun
     if ("$righthand" != "Empty") then gosub STOW my $righthandnoun
     return

#####################################################################################
#######################################################################
#### ENTERING GATE OF SOULS AREA / TEMPLE OF USHNISH MAZE ZONES
GATE_OF_SOULS:
USHNISH_GO:
     if matchre("$roomname", "Beyond the Gate of Souls") then gosub USHNISH_AT_ZONE1
     if matchre("$roomname", "Temple of Ushnish") then gosub USHNISH_AT_ZONE3
     if matchre("$roomname", "The Fangs of Ushnish") then gosub USHNISH_AT_ZONE4
     if ("$zoneid" == "1") then gosub AUTOMOVE NTR
     if ("$zoneid" != "7") then return
     pause 0.2
     if (("$zoneid" == "7") && ($roomid == 188)) then goto USHNISH_GO22
     gosub AUTOMOVE gate of soul
     pause 0.2
USHNISH_GO2:
     gosub stowing
     if ($invisible) then gosub STOP_INVIS
     pause 0.1
USHNISH_GO22:
     if ("$zoneid" == "1") then goto USHNISH_GO
     pause 0.1
     if ($roomid != 188) then gosub AUTOMOVE 188
     if contains("$roomobjs", "low tunnel") then goto USHNISH_GO3
     if ($standing == 0) then gosub STAND
     if contains("$roomobjs", "low tunnel") then goto USHNISH_GO3
     gosub RETREAT
     matchre USHNISH_GO3 ^At the bottom of the hollow, a low tunnel is revealed
     matchre USHNISH_GO22 ^You stop pushing
     send push boulder
     matchwait 20
     goto USHNISH_GO2
USHNISH_GO3:
     gosub RETREAT
     if ("$zoneid" == "1") then goto USHNISH_GO
     if ($roomid != 188) then gosub AUTOMOVE 188
     if !contains("$roomobjs", "low tunnel") then goto USHNISH_GO2
     put fall
     wait
     pause 0.2
     pause 0.2
     if ($standing == 1) then put lie
     if !contains("$roomobjs", "low tunnel") then goto USHNISH_GO2
USHNISH_GO_3:
     pause 0.1
     matchre USHNISH_GO_3 ^Sorry
     matchre USHNISH_GO_ZONE1 ^Wriggling on your stomach, you crawl into a low tunnel
     matchre USHNISH_GO3 ^It's a pretty tight fit
     send go tunnel
     matchwait 20
     goto USHNISH_GO3
#### TO BEYOND GATE OF SOULS - BLASTED PLAIN - MAZE AREA - ZONEID=0
USHNISH_GO_ZONE1:
     matchre USHNISH_GO_ZONE11 Coarse black grit blows in swirling eddies
     matchwait 90
USHNISH_GO_ZONE11:
     gosub STAND
     pause 0.2
     put go lava field
     pause 0.5
#### FROM BEYOND GATE OF SOULS (MAZE) TO TEMPLE OF USHNISH (MAPPED AREA)
USHNISH_GO_ZONE2:
     echo *** Attempting to find Sandstone Temple inside this damn Maze...
     pause 0.3
     if matchre("$roomobjs", "sandstone temple") then goto USHNISH_GO_ZONE3
     gosub RANDOMWEIGHT east
     if matchre("$roomobjs", "sandstone temple") then goto USHNISH_GO_ZONE3
     gosub RANDOMWEIGHT east
     if matchre("$roomobjs", "sandstone temple") then goto USHNISH_GO_ZONE3
     gosub RANDOMMOVE
     if matchre("$roomobjs", "sandstone temple") then goto USHNISH_GO_ZONE3
     gosub RANDOMMOVE
     if matchre("$roomobjs", "sandstone temple") then goto USHNISH_GO_ZONE3
     gosub RANDOMMOVE
     if matchre("$roomobjs", "sandstone temple") then goto USHNISH_GO_ZONE3
     gosub RANDOMMOVE
     if matchre("$roomobjs", "sandstone temple") then goto USHNISH_GO_ZONE3
     gosub RANDOMMOVE
     if matchre("$roomobjs", "sandstone temple") then goto USHNISH_GO_ZONE3
     gosub RANDOMMOVE
     if matchre("$roomobjs", "sandstone temple") then goto USHNISH_GO_ZONE3
     gosub RANDOMMOVE
     if matchre("$roomobjs", "sandstone temple") then goto USHNISH_GO_ZONE3
     gosub RANDOMMOVE_SOUTH
     if matchre("$roomobjs", "sandstone temple") then goto USHNISH_GO_ZONE3
     gosub RANDOMMOVE_SOUTH
     pause 0.1
     if matchre("$roomobjs", "sandstone temple") then goto USHNISH_GO_ZONE3
     goto USHNISH_GO_ZONE2
USHNISH_GO_ZONE3:
     echo =========================
     echo ** FOUND THE TEMPLE OF USHNISH!
     echo =========================
     pause 0.2
     pause 0.2
     send go temple
     pause 0.2
     pause 0.3
     pause 0.2
     put south
     pause 0.3
     pause 0.2
     put south
     pause 0.3
     pause 0.2
     pause 0.2
     put southeast
     pause 0.5
     pause 0.2
     put go door
     pause 0.5
     return

#########################################################################################################################################
#########################################################################################################################################
#### AUTOMOVEMENT - TRAVEL ROUTINES
#########################################################################################################################################
#########################################################################################################################################
##################################################
#### AUTOMOVE
AUTOMOVE:
     # action var exit $1;var webtype $2;goto websarestupid when ^As you approach (?:an?|the)\b.*? ((?:[\w'-]+) [\w'-]+|[\w'-]+), you become tangled up in the.*? \b(metallic|spidersilk|phantasmal|dew-covered|shadowy nightweaver silk)\b webbing
     # action goto ABYSS_ESCAPE when ^With lightning speed, something large and arachnid bursts from below, dragging you into a web-filled, subterranean gloom!
     delay 0.00001
     action (moving) on
     var Moving 0
     var randomloop 0
     var Destination $0
     var automovefailCounter 0
     if ($hidden == 1) then gosub UNHIDE
     if ($standing == 0) then gosub AUTOMOVE_STAND
     if ($roomid == 0) then gosub RANDOMMOVE
     if ("$roomid" == "%Destination") then return
AUTOMOVE_GO:
     delay 0.00001
     matchre AUTOMOVE_FAILED ^(?:AUTOMAPPER )?MOVE(?:MENT)? FAILED
     matchre AUTOMOVE_RETURN ^YOU HAVE ARRIVED(?:\!)?
     matchre AUTOMOVE_RETURN ^SHOP CLOSED(?:\!)?
     matchre AUTOMOVE_FAIL_BAIL ^DESTINATION NOT FOUND
     matchre AUTOMOVE_FAILED ^You don't seem
     put #goto %Destination
     matchwait 3
     if (%Moving == 0) then goto AUTOMOVE_FAILED
     matchre AUTOMOVE_FAILED ^(?:AUTOMAPPER )?MOVE(?:MENT)? FAILED
     matchre AUTOMOVE_RETURN ^YOU HAVE ARRIVED(?:\!)?
     matchre AUTOMOVE_RETURN ^SHOP CLOSED(?:\!)?
     matchre AUTOMOVE_FAIL_BAIL ^DESTINATION NOT FOUND
     matchwait 180
     goto AUTOMOVE_FAILED
AUTOMOVE_STAND:
     delay 0.00001
     if ($standing == 1) then goto AUTOMOVE_RETURN
     matchre AUTOMOVE_STAND ^\.\.\.wait|^Sorry,|^You are still stunned\.
     matchre AUTOMOVE_STAND ^Roundtime\:?|^\[Roundtime\:?|^\(Roundtime\:?|^\[Roundtime|^Roundtime
     matchre AUTOMOVE_STAND ^The weight of all your possessions prevents you from standing\.
     matchre AUTOMOVE_STAND ^You are still stunned\.
     matchre AUTOMOVE_RETURN ^You stand(?:\s*back)? up\.
     matchre AUTOMOVE_RETURN ^You are already standing
     send stand
     matchwait 20
     goto AUTOMOVE_STAND
AUTOMOVE_FAILED:
     delay 0.00001
     # put #script abort automapper
     pause 0.00001
     math automovefailCounter add 1
     if (%automovefailCounter > 5) then goto AUTOMOVE_FAIL_BAIL
     if (%automovefailCounter > 1) then send #mapper reset
     pause 0.01
     if ($roomid == 0) || (%automovefailCounter > 2) then gosub RANDOMMOVE
     goto AUTOMOVE_GO
AUTOMOVE_FAIL_BAIL:
     action (moving) off
     put #echo >Log Crimson *** AUTOMOVE FAILED. ***
     put #echo >Log Destination: %Destination
     put #echo Crimson *** AUTOMOVE FAILED.  ***
     put #echo Crimson Destination: %Destination
AUTOMOVE_RETURN:
     pause 0.00001
     var randomloop 0
     var automovefailCounter 0
     action (moving) off
     ### MICRO PAUSES ADDED HERE - TO AVOID TRIPUPS WITH MAP/ZONEID CHANGES
     ### SOMETIMES IT WOULD RETURN TOO FAST AND AUTOMAPPER WOULD STILL REGISTER THE OLD MAP
     ### PERHAPS #MAPPER RESET COULD WORK, BUT COULD NOT THINK OF A FLUID WAY TO ADD THAT WASN'T SPAMMING CONSTANTLY
     ### THIS JUST ADDS A *SLIGHT* PAUSE AFTER EVERY "GOSUB AUTOMOVE" WHICH SHOULD GIVE ENOUGH TIME
     ### FOR AUTOMAPPER TO REGISTER ANY ZONE ID CHANGES - BUT NOT REALLY INTERFERE WITH THE SPEED MUCH
     pause 0.001
     pause 0.01
     pause 0.01
     return
ABYSS_ESCAPE:
     echo * OH SHIT
     goto INIT
################################
# MOVE SINGLE
################################
MOVE:
     delay 0.00001
     var Direction $0
     var movefailCounter 0
     var moveRetreat 0
     var randomloop 0
     var lastmoved %Direction
MOVE_RESUME:
     matchre MOVE_RETRY ^\.\.\.wait|^Sorry, you may only type|^Please wait\.|You are still stunned\.
     matchre MOVE_RETURN_CHECK ^You can't (swim|move|climb) in that direction\.
     matchre MOVE_RESUME ^You make your way up the .*\.\s*Partway up, you make the mistake of looking down\.\s*Struck by vertigo, you cling to the .* for a few moments, then slowly climb back down\.
     matchre MOVE_RESUME ^You pick your way up the .*, but reach a point where your footing is questionable\.\s*Reluctantly, you climb back down\.
     matchre MOVE_RESUME ^You approach the .*, but the steepness is intimidating\.
     matchre MOVE_RESUME ^You struggle
     matchre MOVE_RESUME ^You blunder
     matchre MOVE_RESUME ^You slap
     matchre MOVE_RESUME ^You work
     matchre MOVE_RESUME make much headway
     matchre MOVE_RESUME ^You flounder around in the water\.
     matchre MOVE_RETREAT ^You are engaged to .*\!
     matchre MOVE_RETREAT ^You can't do that while engaged\!
     matchre MOVE_STAND ^You start up the .*, but slip after a few feet and fall to the ground\!\s*You are unharmed but feel foolish\.
     matchre MOVE_STAND ^Running heedlessly over the rough terrain, you trip over an exposed root and land face first in the dirt\.
     matchre MOVE_STAND ^You can't do that while lying down\.
     matchre MOVE_STAND ^You can't do that while sitting\!
     matchre MOVE_STAND ^You can't do that while kneeling\!
     matchre MOVE_STAND ^You must be standing to do that\.
     matchre MOVE_STAND ^You don't seem
     matchre MOVE_STAND ^You must stand first\.
     matchre MOVE_STAND ^Stand up first.
     matchre MOVE_DIG ^You make no progress in the mud \-\- mostly just shifting of your weight from one side to the other\.
     matchre MOVE_DIG ^You find yourself stuck in the mud, unable to move much at all after your pathetic attempts\.
     matchre MOVE_DIG ^You struggle forward, managing a few steps before ultimately falling short of your goal\.
     matchre MOVE_DIG ^Like a blind, lame duck, you wallow in the mud in a feeble attempt at forward motion\.
     matchre MOVE_DIG ^The mud holds you tightly, preventing you from making much headway\.
     matchre MOVE_DIG ^You fall into the mud with a loud \*SPLUT\*\.
     matchre MOVE_FAIL_BAIL ^You can't go there
     matchre MOVE_FAILED ^Noticing your attempt
     matchre MOVE_FAILED ^I could not find what you were referring to\.
     matchre MOVE_FAILED ^What were you referring to\?
     matchre MOVE_RETURN ^It's pitch dark
     matchre MOVE_RETURN ^Obvious
     send %Direction
     matchwait 8
     goto MOVE_RETURN
MOVE_RETRY:
     pause
     goto MOVE_RESUME
MOVE_STAND:
     delay 0.00001
     matchre MOVE_STAND ^\.\.\.wait|^Sorry,|^You are still stunned\.
     matchre MOVE_STAND ^You are overburdened and cannot manage to stand\.
     matchre MOVE_STAND ^The weight
     matchre MOVE_STAND ^You try
     matchre MOVE_STAND ^You don't
     matchre MOVE_RETREAT ^You are already standing\.
     matchre MOVE_RETREAT ^You stand(?:\s*back)? up\.
     matchre MOVE_RETREAT ^You stand up\.
     send stand
     matchwait 8
     goto MOVE_STAND
MOVE_RETREAT:
     delay 0.00001
     math moveRetreat add 1
     if (%moveRetreat > 4) then
          {
               send search
               pause 0.5
               pause 0.3
               var moveRetreat 0
          }
     if ($invisible == 1) then gosub STOP_INVIS
     matchre MOVE_RETREAT ^\.\.\.wait|^Sorry,|^You are still stunned\.
     matchre MOVE_RETREAT ^You retreat back to pole range\.
     matchre MOVE_RETREAT ^You stop advancing
     matchre MOVE_RETREAT ^You try to back away
     matchre MOVE_STAND ^You must stand first\.
     matchre MOVE_RESUME ^You retreat from combat\.
     matchre MOVE_RESUME ^You are already as far away as you can get\!
     send retreat
     matchwait 10
     goto MOVE_RETREAT
MOVE_DIG:
     delay 0.00001
     matchre MOVE_DIG ^\.\.\.wait|^Sorry,|^You are still stunned\.
     matchre MOVE_DIG ^You struggle to dig off the thick mud caked around your legs\.
     matchre MOVE_STAND ^You manage to dig enough mud away from your legs to assist your movements\.
     matchre MOVE_DIG_STAND ^Maybe you can reach better that way, but you'll need to stand up for that to really do you any good\.
     matchre MOVE_RESUME ^You will have to kneel
     send dig
     matchwait 10
     goto MOVE_DIG
MOVE_DIG_STAND:
     delay 0.00001
     matchre MOVE_DIG_STAND ^\.\.\.wait|^Sorry,|^You are still stunned\.
     matchre MOVE_DIG_STAND ^The weight
     matchre MOVE_DIG_STAND ^You try
     matchre MOVE_DIG_STAND ^You are overburdened and cannot manage to stand\.
     matchre MOVE_DIG ^You stand(?:\s*back)? up\.
     matchre MOVE_DIG ^You are already standing\.
     send stand
     matchwait 10
     goto MOVE_DIG_STAND
MOVE_FAILED:
     var moved 0
     math movefailCounter add 1
     if (%movefailCounter > 3) then goto MOVE_FAIL_BAIL
     pause 0.5
     put look
     delay 0.4
     goto MOVE_RESUME
MOVE_FAIL_BAIL:
     put #echo
     # put #echo >$Log Crimson *** MOVE FAILED. ***
     put #echo Crimson *** MOVE FAILED.  ***
     put #echo
     return
MOVE_RETURN_CHECK:
     put look
     delay 0.001
MOVE_RETURN:
     var moved 1
     var randomloop 0
     delay 0.00001
     unvar moveloop
     unvar movefailCounter
     return
FIND_MYSELF:
### OLD RANDOM MOVEMENT SUB - NO LONGER USED (MAINLY FOR POSTERITY)
MOVERANDOM:
moveRandomDirection:
     var moveloop 0
     moveRandomDirection_2:
     math moveloop add 1
     if matchre("$roomname", "Deadman's Confide, Beach") || (matchre("$roomobjs","thick fog") || matchre("$roomexits","thick fog")) then
          {
               gosub TRUE_RANDOM
               return
          }
     if matchre("$roomname", "Deadman's Confide, Beach") || (matchre("$roomobjs","thick fog") || matchre("$roomexits","thick fog")) then
          {
               gosub TRUE_RANDOM
               return
          }
     if $north then
          {
               gosub MOVE north
               return
          }
     if $northwest then
          {
               gosub MOVE northwest
               return
          }
     if $northeast then
          {
               gosub MOVE northeast
               return
          }
     if $southeast then
          {
               gosub MOVE southeast
               return
          }
     if $south then
          {
               gosub MOVE south
               return
          }
     if $west then
          {
               gosub MOVE west
               return
          }
     if $east then
          {
               gosub MOVE east
               return
          }
     if $southwest then
          {
               gosub MOVE southwest
               return
          }
     if $out then
          {
               gosub MOVE out
               return
          }
     if $up then
          {
               gosub MOVE up
               return
          }
     if $down then
          {
               gosub MOVE down
               return
          }
     if (matchre("$roomobjs $roomdesc","\barchway") && ("%lastmoved" != "go archway")) then
          {
               gosub MOVE go archway
               return
          }
     if (matchre("$roomobjs $roomdesc","\barch") && ("%lastmoved" != "go arch")) then
          {
               gosub MOVE go arch
               return
          }
     if matchre("$roomobjs $roomdesc","\b(stairs|staircase|stairway)\b") then
          {
               gosub MOVE climb stair
               return
          }
     if matchre("$roomobjs $roomdesc","\bsteps\b") then
          {
               gosub MOVE climb step
               return
          }
     if matchre("$roomobjs $roomdesc","\b(exit|curtain|arch|door|gate|hole|hatch|trapdoor|path|animal trail|tunnel|portal|docks)\b") then
          {
               gosub MOVE go $1
               return
          }
     if (matchre("$roomobjs $roomdesc","narrow hole") && ("%lastmoved" != "go hole")) then gosub MOVE go hole
     if (matchre("$roomobjs $roomdesc","bank docks") && ("%lastmoved" != "go dock")) then gosub MOVE go dock
     if (matchre("$roomobjs $roomdesc","\bcrevice") && ("%lastmoved" != "go crevice")) then gosub MOVE go crevice
     if (%moved == 1) then return
     if (matchre("$roomobjs $roomdesc","\bgate\b") && ("%lastmoved" != "go gate")) then gosub MOVE go gate
     if (matchre("$roomobjs $roomdesc","\barch\b") && ("%lastmoved" != "go arch")) then gosub MOVE go arch
     if (%moved == 1) then return
     if (matchre("$roomexits","\bforward") && ("%lastmoved" != "forward")) then gosub MOVE forward
     if (matchre("$roomexits","\baft\b") && ("%lastmoved" != "aft")) then gosub MOVE aft
     if (%moved == 1) then return
     if (matchre("$roomexits","\bstarboard") && ("%lastmoved" != "starboard")) then gosub MOVE starboard
     if (matchre("$roomexits","\bport\b") && ("%lastmoved" != "port")) then gosub MOVE port
     if (%moved == 1) then return
     if (matchre("$roomobjs $roomdesc","\barchway") && ("%lastmoved" != "go archway")) then gosub MOVE go archway
     if (matchre("$roomobjs $roomdesc","\bexit\b") && ("%lastmoved" != "go exit")) then gosub MOVE go exit
     if (matchre("$roomobjs $roomdesc","\bpath\b") && ("%lastmoved" != "go path")) then gosub MOVE go path
     if (matchre("$roomobjs $roomdesc","\bledge\b") && ("%lastmoved" != "go ledge")) then gosub MOVE go ledge
     if (%moved == 1) then return
     if (matchre("$roomobjs $roomdesc","\btrapdoor\b") && ("%lastmoved" != "go trapdoor")) then gosub MOVE go trapdoor
     if (matchre("$roomobjs $roomdesc","\bcurtain\b") && ("%lastmoved" != "go curtain")) then gosub MOVE go curtain
     if (matchre("$roomobjs $roomdesc","\bdoor") && ("%lastmoved" != "go door")) then gosub MOVE go door
     if (matchre("$roomobjs $roomdesc","double door") && ("%lastmoved" != "go door")) then gosub MOVE go door
     if (%moved == 1) then return
     if (matchre("$roomobjs $roomdesc","\bportal\b") && ("%lastmoved" != "go portal")) then gosub MOVE go portal
     if (matchre("$roomobjs $roomdesc","\btunnel\b") && ("%lastmoved" != "go tunnel")) then gosub MOVE go tunnel
     if (matchre("$roomobjs $roomdesc","\bjagged crack\b") && ("%lastmoved" != "go crack")) then gosub MOVE go crack
     if (matchre("$roomobjs $roomdesc","\bthe street\b") && ("%lastmoved" != "go street")) then gosub MOVE go street
     if (matchre("$roomobjs $roomdesc","(?i)\ba gate\b") && ("%lastmoved" != "go gate")) then gosub MOVE go gate
     if (%moved == 1) then return
     if (matchre("$roomobjs $roomdesc","\b(stairs|staircase|stairway)\b") && ("%lastmoved" != "climb stair")) then gosub MOVE climb stair
     if (matchre("$roomobjs $roomdesc","\bsteps\b") && ("%lastmoved" != "climb step")) then gosub MOVE climb step
     if (matchre("$roomobjs $roomdesc","\btrail\b") && ("%lastmoved" != "go trail")) then gosub MOVE go trail
     if (%moved == 1) then return
     if (matchre("$roomobjs $roomdesc","\bpanel\b") && ("%lastmoved" != "go panel")) then gosub MOVE go panel
     if (matchre("$roomobjs $roomdesc","\btent flap\b") && ("%lastmoved" != "go flap")) then gosub MOVE go flap
     if (matchre("$roomobjs $roomdesc","\bnarrow track\b") && ("%lastmoved" != "go track")) then gosub MOVE go track
     if (matchre("$roomobjs $roomdesc","\blava field\b") && ("%lastmoved" != "go lava field")) then gosub MOVE go lava field
     if (%moved == 1) then return
     if (matchre("$roomname", "Deadman's Confide, Beach") || matchre("$roomobjs","thick fog") || matchre("$roomexits","thick fog")) then gosub TRUE_RANDOM
     if matchre("$roomname","Smavold's Toggery") then gosub MOVE go door
     if matchre("$roomname","Temple Hill Manor, Grounds") then gosub MOVE go gate
     if matchre("$roomname","Darkling Wood, Ironwood Tree") then gosub MOVE climb pine branches
     if matchre("$roomname","Darkling Wood, Pine Tree") then gosub MOVE climb white pine
     if (%moved == 1) then return
     if matchre("$roomname","The Sewers, Beneath the Grate") then gosub MOVE go grate
     if matchre("$roomobjs","strong creeper") then gosub MOVE climb ladder
     if matchre("$roomobjs","the garden") then gosub MOVE go garden
     if matchre("$roomobjs","underside of the Bridge of Rooks") then gosub MOVE climb bridge
     if (%moved == 1) then return
     if matchre("$roomobjs","stone wall") then gosub MOVE climb niche
     if matchre("$roomobjs","narrow ledge") then gosub MOVE climb ledge
     if matchre("$roomobjs","craggy niche") then gosub MOVE climb niche
     if matchre("$roomobjs","double door") then gosub MOVE go door
     if matchre("$roomobjs","staircase") then gosub MOVE climb stair
     if matchre("$roomobjs","the exit") then gosub MOVE go exit
     if (%moved == 1) then return
     echo * No random direction possible?? Looking to attempt to reset room exit vars
     send search
     pause 0.4
     pause 0.2
     #might need a counter here to prevent infinite loops
     put look
     pause 0.5
     delay 0.2
     if (%moveloop > 6) then
          {
               echo * Cannot find a room exit!! Stupid fog!
               echo * ATTEMPTING RANDOM DIRECTIONS...
               gosub LIGHT_SOURCE
               pause 0.2
               gosub TRUE_RANDOM
               return
          }
     goto moveRandomDirection_2
###################################################################################
### NEW RANDOM MOVEMENT ENGINE BY SHROOM
### ATTEMPTS TO MOVE UNTIL AUTOMAPPER REGISTERS POSITION
### THIS IS NORMALLY CALLED WHEN AUTOMAPPER GETS LOST OR ROOMID == 0
### ALSO USED TO NAVIGATE THROUGH MAZE AREAS
### CAN BE USED AS A STANDALONE SUB
### ATTEMPTS RANDOM DIRECTIONS AND DOESN'T BACKTRACK FROM LAST KNOWN DIRECTION IF POSSIBLE
### IF IT CANNOT FIND A OBVIOUS ROOM EXIT AFTER SEVERAL LOOPS - WILL TRY ~ANY POSSIBLE EXIT~ IT CAN FIND
### WILL MOVE IN TRUE RANDOM DIRECTIONS IF IT CANNOT SEE ANY ROOM EXITS (PITCH BLACK)
###################################################################################
RANDOMMOVE:
     delay 0.00001
     var moved 0
     var moveloop 0
RANDOMMOVE_1:
     math moveloop add 1
     math randomloop add 1
     if (%randomloop == 1) then gosub DARK_CHECK_1
     if (%darkroom == 1) then gosub LIGHT_SOURCE
     if !($standing) then gosub STAND
## IF WE'VE DONE 20/40 LOOPS, DO A QUICK LOOK AND MAKE SURE NOT ON A FERRY
     if matchre("%moveloop", "\b(40)\b") then
          {
               echo * CANNOT FIND A ROOM EXIT??!
               put look
               pause 0.4
               gosub FERRY_CHECK
          }
### TRY A LIGHT SOURCE IF ROOM IS PITCH BLACK AND THEN TRY TRUE RANDOM DIRECTIONS
     if (%moveloop > 20) then
          {
               if matchre("$roomobjs $roomdesc","pitch black") then gosub LIGHT_SOURCE
               var lastmoved null
               gosub TRUE_RANDOM
          }
### IF WE'VE DONE 50+ LOOPS - DO ALL CHECKS - LIGHT SOURCE/FERRY CHECK AND RESET BACK TO 0
     if (%moveloop > 50) then
          {
               echo ~~~~~~~~~~~~~~~~~~~
               echo * Cannot find a room exit??? Stupid fog???
               echo * ZONE: $zoneid | ROOM: $roomid
               echo * SEND THE ROOM DESCRIPTION/EXITS WHEN YOU TYPE LOOK
               echo * ATTEMPTING RANDOM DIRECTIONS...
               echo * SHOULD AUTO-RECOVER IF YOU CAN FIND AN EXIT
               echo ~~~~~~~~~~~~~~~~~~~
               pause 0.5
               gosub FERRY_CHECK
               pause 0.5
               if matchre("$roomobjs $roomdesc","pitch black") then gosub LIGHT_SOURCE
               pause 0.2
               gosub TRUE_RANDOM
               var lastmoved null
               var randomloop 0
               var moveloop 0
               return
          }
### MOVE INTO TRUE RANDOM MODE
     if (%moveloop > 55) then
          {
               if matchre("$roomobjs $roomdesc","pitch black") then gosub LIGHT_SOURCE
               var lastmoved null
               gosub TRUE_RANDOM
          }
### HERE BEGINS CONDITIONAL CHECKS FOR VERY SPECIFIC ROOMS AND HOW TO *TRY* AND HANDLE THEM
     if matchre("$roomname", "\[Skeletal Claw\]") then
          {
               echo ~~~~~~~~~~~~~~~~~~~~~
               echo # IN THE SKELETAL CLAW! OH NO!!!
               echo # WE MIGHT DIE IF SOMEONE DOESN'T CAST UNCURSE ON IT!
               echo # ATTEMPTING TO ESCAPE.............
               echo ~~~~~~~~~~~~~~~~~~~~~
               gosub MOVE out
               return
          }
     if (matchre("$roomname", "Deadman's Confide, Beach") || matchre("$roomobjs","thick fog") || matchre("$roomexits","thick fog")) then gosub TRUE_RANDOM
     if matchre("$roomname","Smavold's Toggery") then gosub MOVE go door
     if matchre("$roomname","Temple Hill Manor, Grounds") then gosub MOVE go gate
     if matchre("$roomname","(Ylono's Repairs|Catrox's Forge|Unspiek's Repair Shop|Kamze's Repair|Storage Shed)") then gosub MOVE out
     if matchre("$roomname","Darkling Wood, Ironwood Tree") then gosub MOVE climb pine branches
     if matchre("$roomname","Darkling Wood, Pine Tree") then gosub MOVE climb white pine
     if (%moved == 1) then return
     if matchre("$roomname","The Sewers, Beneath the Grate") then gosub MOVE go grate
     if matchre("$roomobjs","strong creeper") then gosub MOVE climb ladder
     if matchre("$roomobjs","the garden") then gosub MOVE go garden
     if matchre("$roomobjs","underside of the Bridge of Rooks") then gosub MOVE climb bridge
     if (%moved == 1) then return
### IF WE HAVE DONE 10 LOOPS WITH NO MATCHES - LOOK FOR AND TRY SOME OF THE MOST COMMON NON-CARDINAL EXITS
     if (%moveloop > 10) then
          {
          if matchre("$roomobjs","stone wall") then gosub MOVE climb wall
          if matchre("$roomobjs","narrow ledge") then gosub MOVE climb ledge
          if matchre("$roomobjs","craggy niche") then gosub MOVE climb niche
          if matchre("$roomobjs","double door") then gosub MOVE go door
          if matchre("$roomobjs","staircase") then gosub MOVE climb stair
          if matchre("$roomobjs","the exit") then gosub MOVE go exit
          if matchre("$roomobjs","\bdocks?") then gosub MOVE go dock
          if matchre("$roomobjs","\bdoor\b") then gosub MOVE go door
          if matchre("$roomobjs","\bledge\b") then gosub MOVE go ledge
          if matchre("$roomobjs","\barch\b") then gosub MOVE go arch
          if matchre("$roomobjs","\bgate\b") then gosub MOVE go gate
          if matchre("$roomobjs","\btrapdoor\b") then gosub MOVE go trapdoor
          if matchre("$roomobjs","\bcrevice\b") then gosub MOVE go crevice
          if matchre("$roomobjs","\bcurtain\b") then gosub MOVE go curtain
          if matchre("$roomobjs","\bportal\b") then gosub MOVE go portal
          if matchre("$roomobjs","\btrail\b") then gosub MOVE go trail
          if matchre("$roomobjs","\bpath\b") then gosub MOVE go path
          if matchre("$roomobjs","\bhole\b") then gosub MOVE go hole
          }
     if (%moved == 1) then return
### HERE BEGINS THE TRUE NORMAL CARDINAL CHECKS - HIT A RANDOM NUMBER THEN CHECK IF IT MATCHES A ROOM EXIT
### AS LONG AS THE ROOM EXIT IS VALID AND IS NOT THE OPPOSITE OF OUR LAST DIRECTION - THEN TAKE IT
     random 1 11
     if ((%r == 1) && ($north) && ("%lastmoved" != "south")) then gosub MOVE north
     if ((%r == 2) && ($northeast) && ("%lastmoved" != "southwest")) then gosub MOVE northeast
     if ((%r == 3) && ($east) && ("%lastmoved" != "west")) then gosub MOVE east
     if ((%r == 4) && ($northwest) && ("%lastmoved" != "southeast")) then gosub MOVE northwest
     if ((%r == 5) && ($southeast) && ("%lastmoved" != "northwest")) then gosub MOVE southeast
     if ((%r == 6) && ($south) && ("%lastmoved" != "north")) then gosub MOVE south
     if ((%r == 7) && ($southwest) && ("%lastmoved" != "northeast")) then gosub MOVE southwest
     if ((%r == 8) && ($west) && ("%lastmoved" != "east")) then gosub MOVE west
     if (%r == 9) && ($out) then gosub MOVE out
     if ((%r == 10) && ($up) && ("%lastmoved" != "up")) then gosub MOVE up
     if ((%r == 11) && ($down) && ("%lastmoved" != "down")) then gosub MOVE down
     if (%moved == 1) then return
### 2ND LOOP RANDOMIZED - SAME AS THE FIRST CHECK BUT THE DIRECTIONS HAVE BEEN SWITCHED UP
     if ((%r == 1) && ($southwest) && ("%lastmoved" != "northeast")) then gosub MOVE southwest
     if ((%r == 2) && ($west) && ("%lastmoved" != "east")) then gosub MOVE west
     if ((%r == 3) && ($south) && ("%lastmoved" != "north")) then gosub MOVE south
     if ((%r == 4) && ($southeast) && ("%lastmoved" != "northwest")) then gosub MOVE southeast
     if ((%r == 5) && ($east) && ("%lastmoved" != "west")) then gosub MOVE east
     if ((%r == 6) && ($northeast) && ("%lastmoved" != "southwest")) then gosub MOVE northeast
     if ((%r == 7) && ($northwest) && ("%lastmoved" != "southeast")) then gosub MOVE northwest
     if (%r == 8) && ($out) then gosub MOVE out
     if ((%r == 9) && ($north) && ("%lastmoved" != "south")) then gosub MOVE north
     if ((%r == 10) && ($down) && ("%lastmoved" != "up")) then gosub MOVE down
     if ((%r == 11) && ($up) && ("%lastmoved" != "down")) then gosub MOVE up
     if (%moved == 1) then return
### 3RD LOOP - NOW WE JUST HARD CHECK FOR ANY OBVIOUS EXIT IN THE SAME NUMBER
### AS LONG AS IT WASN'T OPPOSITE OUR LAST DIRECTION
     random 1 4
     if ((%r == 1) && ($south) && ("%lastmoved" != "north")) then gosub MOVE south
     if ((%r == 1) && ($northeast) && ("%lastmoved" != "southwest")) then gosub MOVE northeast
     if ((%r == 1) && ($northwest) && ("%lastmoved" != "southeast")) then gosub MOVE northwest
     if ((%r == 1) && ($west) && ("%lastmoved" != "east")) then gosub MOVE west
     if ((%r == 1) && ($east) && ("%lastmoved" != "west")) then gosub MOVE east
     if (%moved == 1) then return
     if ((%r == 1) && ($north) && ("%lastmoved" != "south")) then gosub MOVE north
     if ((%r == 1) && ($southeast) && ("%lastmoved" != "northwest")) then gosub MOVE southeast
     if ((%r == 1) && ($southwest) && ("%lastmoved" != "northeast")) then gosub MOVE southwest
     if (%moved == 1) then return
     if ((%r == 2) && ($south) && ("%lastmoved" != "north")) then gosub MOVE south
     if ((%r == 2) && ($northeast) && ("%lastmoved" != "southwest")) then gosub MOVE northeast
     if ((%r == 2) && ($northwest) && ("%lastmoved" != "southeast")) then gosub MOVE northwest
     if ((%r == 2) && ($west) && ("%lastmoved" != "east")) then gosub MOVE west
     if (%moved == 1) then return
     if ((%r == 2) && ($east) && ("%lastmoved" != "west")) then gosub MOVE east
     if ((%r == 2) && ($north) && ("%lastmoved" != "south")) then gosub MOVE north
     if ((%r == 2) && ($southeast) && ("%lastmoved" != "northwest")) then gosub MOVE southeast
     if ((%r == 2) && ($southwest) && ("%lastmoved" != "northeast")) then gosub MOVE southwest
     if (%moved == 1) then return
     if ((%r == 3) && ($west) && ("%lastmoved" != "east")) then gosub MOVE west
     if ((%r == 3) && ($east) && ("%lastmoved" != "west")) then gosub MOVE east
     if ((%r == 3) && ($north) && ("%lastmoved" != "south")) then gosub MOVE north
     if ((%r == 3) && ($southwest) && ("%lastmoved" != "northeast")) then gosub MOVE southwest
     if ((%r == 3) && ($south) && ("%lastmoved" != "north")) then gosub MOVE south
     if (%moved == 1) then return
     if ((%r == 3) && ($northeast) && ("%lastmoved" != "southwest")) then gosub MOVE northeast
     if ((%r == 3) && ($northwest) && ("%lastmoved" != "southeast")) then gosub MOVE northwest
     if ((%r == 3) && ($southeast) && ("%lastmoved" != "northwest")) then gosub MOVE southeast
     if (%moved == 1) then return
     if ((%r == 4) && ($south) && ("%lastmoved" != "north")) then gosub MOVE south
     if ((%r == 4) && ($northeast) && ("%lastmoved" != "southwest")) then gosub MOVE northeast
     if ((%r == 4) && ($northwest) && ("%lastmoved" != "southeast")) then gosub MOVE northwest
     if ((%r == 4) && ($west) && ("%lastmoved" != "east")) then gosub MOVE west
     if (%moved == 1) then return
     if ((%r == 4) && ($east) && ("%lastmoved" != "west")) then gosub MOVE east
     if ((%r == 4) && ($north) && ("%lastmoved" != "south")) then gosub MOVE north
     if ((%r == 4) && ($southeast) && ("%lastmoved" != "northwest")) then gosub MOVE southeast
     if ((%r == 4) && ($southwest) && ("%lastmoved" != "northeast")) then gosub MOVE southwest
     if (%moved == 1) then return
### THIS IS THE MAJOR CHECK FAILOVER
### IF DONE 13 LOOPS WITH NO MATCH THEN CHECK FOR ~ANY POSSIBLE OBVIOUS ROOM EXIT~ (AS LONG AS THAT WASN'T OUR LAST MOVE)
     if (%moveloop > 13) then
          {
               if ($out) then gosub MOVE out
               if (%moved == 1) then return
               if (($north) && ("%lastmoved" != "south")) then gosub MOVE north
               if (($south) && ("%lastmoved" != "north")) then gosub MOVE south
               if (%moved == 1) then return
               if (($east) && ("%lastmoved" != "west")) then gosub MOVE east
               if (($west) && ("%lastmoved" != "east")) then gosub MOVE west
               if (%moved == 1) then return
               if (($northeast) && ("%lastmoved" != "southwest")) then gosub MOVE northeast
               if (($northwest) && ("%lastmoved" != "southeast")) then gosub MOVE northwest
               if (%moved == 1) then return
               if (($southeast) && ("%lastmoved" != "northwest")) then gosub MOVE southeast
               if (($southwest) && ("%lastmoved" != "northeast")) then gosub MOVE southwest
               if (%moved == 1) then return
               if (matchre("$roomobjs $roomdesc","narrow hole") && ("%lastmoved" != "go hole")) then gosub MOVE go hole
               if (matchre("$roomobjs $roomdesc","large hole") && ("%lastmoved" != "go hole")) then gosub MOVE go hole
               if (matchre("$roomobjs $roomdesc","\bcrevice") && ("%lastmoved" != "go crevice")) then gosub MOVE go crevice
               if (matchre("$roomobjs $roomdesc","\bdocks") && ("%lastmoved" != "go dock")) then gosub MOVE go dock
               if (%moved == 1) then return
               if (matchre("$roomobjs $roomdesc","\bpath\b") && ("%lastmoved" != "go path")) then gosub MOVE go path
               if (matchre("$roomobjs $roomdesc","\btrail\b") && ("%lastmoved" != "go trail")) then gosub MOVE go trail
               if (matchre("$roomobjs $roomdesc","\bpanel\b") && ("%lastmoved" != "go panel")) then gosub MOVE go panel
               if (matchre("$roomobjs $roomdesc","\btent flap\b") && ("%lastmoved" != "go flap")) then gosub MOVE go flap
               if (%moved == 1) then return
               if matchre("$roomname","(Ylono's Repairs|Catrox's Forge|Unspiek's Repair Shop|Kamze's Repair|Storage Shed)") then gosub MOVE out
               if (matchre("$roomobjs $roomdesc","\bdoor") && ("%lastmoved" != "go door")) then gosub MOVE go door
               if (matchre("$roomobjs $roomdesc","double door") && ("%lastmoved" != "go door")) then gosub MOVE go door
               if (matchre("$roomobjs $roomdesc","\btrapdoor\b") && ("%lastmoved" != "go trapdoor")) then gosub MOVE go trapdoor
               if (matchre("$roomobjs $roomdesc","\bcurtain\b") && ("%lastmoved" != "go curtain")) then gosub MOVE go curtain
               if (%moved == 1) then return
               if (matchre("$roomobjs $roomdesc","\bnarrow track\b") && ("%lastmoved" != "go track")) then gosub MOVE go track
               if (matchre("$roomobjs $roomdesc","\blava field\b") && ("%lastmoved" != "go lava field")) then gosub MOVE go lava field
               if (matchre("$roomobjs $roomdesc","\bgate\b") && ("%lastmoved" != "go gate")) then gosub MOVE go gate
               if (matchre("$roomobjs $roomdesc","\barch\b") && ("%lastmoved" != "go arch")) then gosub MOVE go arch
               if (matchre("$roomobjs $roomdesc","\bexit\b") && ("%lastmoved" != "go exit")) then gosub MOVE go exit
               if (%moved == 1) then return
               if (matchre("$roomexits","\bforward") && ("%lastmoved" != "forward")) then gosub MOVE forward
               if (matchre("$roomexits","\baft\b") && ("%lastmoved" != "aft")) then gosub MOVE aft
               if (%moved == 1) then return
               if (matchre("$roomexits","\bstarboard") && ("%lastmoved" != "starboard")) then gosub MOVE starboard
               if (matchre("$roomexits","\bport\b") && ("%lastmoved" != "port")) then gosub MOVE port
               if (%moved == 1) then return
               if (matchre("$roomobjs $roomdesc","\bledge\b") && ("%lastmoved" != "go ledge")) then gosub MOVE go ledge
               if (matchre("$roomobjs $roomdesc","\bportal\b") && ("%lastmoved" != "go portal")) then gosub MOVE go portal
               if (matchre("$roomobjs $roomdesc","\btunnel\b") && ("%lastmoved" != "go tunnel")) then gosub MOVE go tunnel
               if (%moved == 1) then return
               if (matchre("$roomobjs $roomdesc","\bjagged crack\b") && ("%lastmoved" != "go crack")) then gosub MOVE go crack
               if (matchre("$roomobjs $roomdesc","\bthe street\b") && ("%lastmoved" != "go street")) then gosub MOVE go street
               if (matchre("$roomobjs $roomdesc","(?i)\ba gate\b") && ("%lastmoved" != "go gate")) then gosub MOVE go gate
               if (%moved == 1) then return
               if (matchre("$roomobjs $roomdesc","\b(stairs|staircase|stairway)\b") && ("%lastmoved" != "climb stair")) then gosub MOVE climb stair
               if (matchre("$roomobjs $roomdesc","\bsteps\b") && ("%lastmoved" != "climb step")) then gosub MOVE climb step
               if (%moved == 1) then return
          }
     if (%moved == 0) then goto RANDOMMOVE_1
     # if ($roomid == 0) then goto RANDOMMOVE
     # if $roomid == 0 then goto moveRandomDirection_2
     return
### RANDOM CARDINAL DIRECTIONS ONLY
RANDOMMOVE_CARDINAL:
     delay 0.00001
     var moved 0
     math randomloop add 1
     if (%randomloop > 50) then
          {
               var lastmoved null
               var randomloop 0
               echo * Cannot find a room exit??
               echo * Attempting to Revert back..
               echo * Trying Alternate Methods..
               if matchre("$roomobjs $roomdesc","pitch black") then gosub LIGHT_SOURCE
               pause 0.2
               gosub TRUE_RANDOM
               return
          }
     if matchre("$roomname", "Deadman's Confide, Beach") || (matchre("$roomobjs","thick fog") || matchre("$roomexits","thick fog")) then
          {
               gosub TRUE_RANDOM
               return
          }
     if matchre("$roomname","Temple Hill Manor, Grounds") then
          {
               gosub MOVE go gate
               return
          }
     if matchre("$roomname","Darkling Wood, Ironwood Tree") then
          {
               gosub MOVE climb pine branches
               return
          }
     if matchre("$roomname","Darkling Wood, Pine Tree") then
          {
               gosub MOVE climb white pine
               return
          }
     if matchre("$roomobjs","strong creeper") then
          {
               gosub MOVE climb ladder
               return
          }
     if matchre("$roomobjs","bank docks") then
          {
               gosub MOVE go dock
               return
          }
     if (%moved == 1) then return
     random 1 11
     if ((%r == 1) && ($north) && ("%lastmoved" != "south")) then gosub MOVE north
     if ((%r == 2) && ($northeast) && ("%lastmoved" != "southwest")) then gosub MOVE northeast
     if ((%r == 3) && ($east) && ("%lastmoved" != "west")) then gosub MOVE east
     if ((%r == 4) && ($northwest) && ("%lastmoved" != "southeast")) then gosub MOVE northwest
     if ((%r == 5) && ($southeast) && ("%lastmoved" != "northwest")) then gosub MOVE southeast
     if ((%r == 6) && ($south) && ("%lastmoved" != "north")) then gosub MOVE south
     if ((%r == 7) && ($southwest) && ("%lastmoved" != "northeast")) then gosub MOVE southwest
     if ((%r == 8) && ($west) && ("%lastmoved" != "east")) then gosub MOVE west
     if (%r == 9) && ($out) then gosub MOVE out
     if ((%r == 10) && ($up) && ("%lastmoved" != "up")) then gosub MOVE up
     if ((%r == 11) && ($down) && ("%lastmoved" != "down")) then gosub MOVE down
     if (%moved == 1) then return
     if ((%r == 1) && ($southwest) && ("%lastmoved" != "northeast")) then gosub MOVE southwest
     if ((%r == 2) && ($west) && ("%lastmoved" != "east")) then gosub MOVE west
     if ((%r == 3) && ($south) && ("%lastmoved" != "north")) then gosub MOVE south
     if ((%r == 4) && ($southeast) && ("%lastmoved" != "northwest")) then gosub MOVE southeast
     if ((%r == 5) && ($east) && ("%lastmoved" != "west")) then gosub MOVE east
     if ((%r == 6) && ($northeast) && ("%lastmoved" != "southwest")) then gosub MOVE northeast
     if ((%r == 7) && ($northwest) && ("%lastmoved" != "southeast")) then gosub MOVE northwest
     if (%r == 8) && ($out) then gosub MOVE out
     if ((%r == 9) && ($north) && ("%lastmoved" != "south")) then gosub MOVE north
     if ((%r == 10) && ($down) && ("%lastmoved" != "up")) then gosub MOVE down
     if ((%r == 11) && ($up) && ("%lastmoved" != "down")) then gosub MOVE up
     if (%moved == 1) then return
     if (%moved == 0) then goto RANDOMMOVE_CARDINAL
     # if ($roomid == 0) then goto RANDOMMOVE
     # if $roomid == 0 then goto moveRandomDirection_2
     return
### GO IN RANDOM DIRECTIONS, PREFER A SOUTHERN / WESTERN DIRECTION IF AVAILABLE
RANDOMMOVE_SOUTH:
     delay 0.0001
     var moved 0
     math randomloop add 1
     if (%randomloop > 5) then
          {
               put look
               pause 0.2
               var lastmoved null
               var randomloop 0
               return
          }
     if $south then
          {
               gosub MOVE south
               return
          }
     if $southwest then
          {
               gosub MOVE southwest
               return
          }
     if $southeast then
          {
               gosub MOVE southeast
               return
          }
     if $northwest then
          {
               gosub MOVE northwest
               return
          }
     if $west then
          {
               gosub MOVE west
               return
          }
     if $north then
          {
               gosub MOVE north
               return
          }
     if $northeast then
          {
               gosub MOVE northeast
               return
          }
     if $east then
          {
               gosub MOVE east
               return
          }

     if $out then
          {
               gosub MOVE out
               return
          }
     if $up then
          {
               gosub MOVE up
               return
          }
     if $down then
          {
               gosub MOVE down
               return
          }
     pause 0.01
     if (%moved == 0) then goto RANDOMMOVE_SOUTH
     # if $roomid == 0 then goto moveRandomDirection_2
     return
### TRUE RANDOM USED FOR MOVING IN PURE RANDOM DIRECTIONS REGARDLESS OF WHATS IN ROOM (FOG FILLED OR DARK ROOMS)
TRUE_RANDOM:
     delay 0.0001
     var moved 0
     math randomloop add 1
     if (%randomloop > 12) then
          {
               put look
               pause 0.2
               var lastmoved null
               var randomloop 0
          }
     random 1 8
     if (%r == 1) then gosub MOVE n
     if (%r == 2) then gosub MOVE ne
     if (%r == 3) then gosub MOVE e
     if (%r == 4) then gosub MOVE nw
     if (%r == 5) then gosub MOVE se
     if (%r == 6) then gosub MOVE s
     if (%r == 7) then gosub MOVE sw
     if (%r == 8) then gosub MOVE w
     if (%moved == 1) then return
     if (matchre("$roomobjs $roomdesc","\bexit\b") && ("%lastmoved" != "go exit")) then gosub MOVE go exit
     if (matchre("$roomobjs $roomdesc","\bdocks\b") && ("%lastmoved" != "go dock")) then gosub MOVE go dock
     if (matchre("$roomobjs $roomdesc","\bpath\b") && ("%lastmoved" != "go path")) then gosub MOVE go path
     if (matchre("$roomobjs $roomdesc","\btrapdoor\b") && ("%lastmoved" != "go trapdoor")) then gosub MOVE go trapdoor
     if (matchre("$roomobjs $roomdesc","\bcurtain\b") && ("%lastmoved" != "go path")) then gosub MOVE go curtain
     if (matchre("$roomobjs $roomdesc","\bdoor") && ("%lastmoved" != "go door")) then gosub MOVE go door
     if (matchre("$roomobjs $roomdesc","\bgate") && ("%lastmoved" != "go gate")) then gosub MOVE go gate
     if (matchre("$roomobjs $roomdesc","\barch") && ("%lastmoved" != "go arch")) then gosub MOVE go arch
     if (matchre("$roomobjs $roomdesc","\barchway") && ("%lastmoved" != "go archway")) then gosub MOVE go archway
     if (%moved == 1) then return
     if (matchre("$roomobjs $roomdesc","\bportal\b") && ("%lastmoved" != "go portal")) then gosub MOVE go portal
     if (matchre("$roomobjs $roomdesc","\btunnel\b") && ("%lastmoved" != "go tunnel")) then gosub MOVE go tunnel
     if (matchre("$roomobjs $roomdesc","\b(stairs|staircase|stairway)\b") && ("%lastmoved" != "climb stair")) then gosub MOVE climb stair
     if (matchre("$roomobjs $roomdesc","\bsteps\b") && ("%lastmoved" != "climb step")) then gosub MOVE climb step
     if (%moved == 1) then return
     if (matchre("$roomobjs $roomdesc","\bpanel\b") && ("%lastmoved" != "go panel")) then gosub MOVE go panel
     if (matchre("$roomobjs $roomdesc","\bnarrow track\b") && ("%lastmoved" != "go track")) then gosub MOVE go track
     if (matchre("$roomobjs $roomdesc","\bthe garden\b") && ("%lastmoved" != "go garden")) then gosub MOVE go garden
     if (matchre("$roomobjs $roomdesc","\btent flap\b") && ("%lastmoved" != "go flap")) then gosub MOVE go flap
     if (matchre("$roomobjs $roomdesc","\blava field\b") && ("%lastmoved" != "go lava field")) then gosub MOVE go lava field
     if (%moved == 0) then goto TRUE_RANDOM
     return
RANDOMWEIGHT:
     var weight $1
     var randomweight
     if $%weight then var randomweight %randomweight|%weight
     if $north%weight then var randomweight %randomweight|north%weight
     if $south%weight then var randomweight %randomweight|south%weight
     eval randomweightcount count("%randomweight", "|")
RANDOMWEIGHT_2:
     if ("%randomweight" == "") then return
     random 1 %randomweightcount
     gosub MOVE %randomweight(%r)
     return
RANDOMNORTH:
     if (($north) && ("%lastmoved" != "south")) then
          {
               gosub MOVE north
               goto RANDOMSOUTH_RETURN
          }
     if (($northeast) && ("%lastmoved" != "southwest")) then
          {
               gosub MOVE northeast
               goto RANDOMSOUTH_RETURN
          }
     if (($northwest) && ("%lastmoved" != "southeast")) then
          {
               gosub MOVE northwest
               return
          }
     if (($west) && ("%lastmoved" != "east")) then
          {
               gosub MOVE west
               goto RANDOMSOUTH_RETURN
          }
     if (($east) && ("%lastmoved" != "west")) then
          {
               gosub MOVE east
               goto RANDOMSOUTH_RETURN
          }
     var lastmoved null
     return
RANDOMSOUTH:
     if (($south) && ("%lastmoved" != "north")) then
          {
               gosub MOVE south
               goto RANDOMSOUTH_RETURN
          }
     if (($southeast) && ("%lastmoved" != "northwest")) then
          {
               gosub MOVE southeast
               goto RANDOMSOUTH_RETURN
          }
     if (($southwest) && ("%lastmoved" != "northeast")) then
          {
               gosub MOVE southwest
               goto RANDOMSOUTH_RETURN
          }
     if (($east) && ("%lastmoved" != "west")) then
          {
               gosub MOVE east
               goto RANDOMSOUTH_RETURN
          }
     if (($west) && ("%lastmoved" != "east")) then
          {
               gosub MOVE west
               goto RANDOMSOUTH_RETURN
          }
     var lastmoved null
RANDOMSOUTH_RETURN:
     return

### NO VALID DESTINATION SET OR FOUND ERROR
NODESTINATION:
  Echo ---------------------------------------------------------------------------------------------------------
  Echo ## *** TRAVEL ERROR! ***
  Echo ## Either you did not enter a destination
  Echo ## Or your destination is not recognized.  Please try again!
  Echo ##
  Echo ## SYNTAX IS:
  Echo ## .travel CITYNAME or .travel CITYNAME ROOMNUMBER/LABEL
  Echo ##
  Echo ## EXAMPLES:
  Echo ## .travel cross - Travel to Crossing
  Echo ## .travel cross 144 - Travel to crossing THEN move to room 144
  Echo ## .travel cross teller - Travel to Crossing THEN move to bank teller
  Echo ##
  Echo ## Valid Destinations are:               ##
  Echo -------------------------------------------
  Echo ## Zoluren:
  Echo ## Crossing | Arthe Dale | West Gate     ##
  echo ## Tiger Clan | Wolf Clan | Dokt         ##
  Echo ## Knife Clan | Kaerna | Stone Clan      ##
  Echo ## Caravansary | Dirge | Ushnish         ##
  Echo ## Sorrow's | Beisswurms | Misenseor     ##
  Echo ## Leucros | Vipers | Malodorous Buccas  ##
  Echo ## Alfren's Ferry | Leth Deriel          ##
  Echo ## Ilaya Taipa  |  Acenemacra            ##
  Echo -------------------------------------------
  Echo ## Therengia:
  Echo ## Riverhaven | Rossmans | Langenfirth   ##
  Echo ## El'Bains | Therenborough | Rakash     ##
  Echo ## Fornsted | Zaulfung |  Throne City    ##
  Echo ## Hvaral | Haizen | Oasis | Yeehar      ##
  Echo ## Muspar'i                              ##
  Echo -------------------------------------------
  Echo ## Ilithi:
  Echo ## Shard | Horse Clan | Fayrin's Rest    ##
  Echo ## Steelclaw Clan | Spire |Corik's Wall  ##
  Echo ## Ylono | Granite Gargoyles | Gondola   ##
  Echo ## Bone Wolves | Germishdin | Fang Cove  ##
  Echo ## Wyvern Mountain                       ##
  Echo -------------------------------------------
  Echo ## Forfedhdar:
  Echo ## Raven's Point | Ain Ghazal| Outer Hib ##
  Echo ## Inner Hib | Hibarnhvidar |Boar Clan   ##
  Echo -------------------------------------------
  Echo ## Qi:
  Echo ## Aesry Surlaenis'a | Ratha | M'riss    ##
  Echo ## Mer'Kresh | Hara'jaal (TF ONLY)       ##
  Echo ## Taisgath                              ##
  Echo -------------------------------------------
  Echo -------------------------------------------
  Echo ## SPECIAL:
  Echo ## YEET (TOP SECRET - DO NOT USE :P)     ##
  ECHO ## *UNLESS YOU LIKE SURPRISES ;)         ##
  Echo -------------------------------------------
  exit

RETURN_CLEAR:
     delay 0.0001
     put #queue clear
     return
