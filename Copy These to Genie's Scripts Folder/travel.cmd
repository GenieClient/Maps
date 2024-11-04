#travel.cmd
var version 6.2024-11-04
# debug 5 is for outlander; genie debuglevel 10
# debuglevel 10
 debug 5
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
#################################################################################
####  DONT TOUCH ANYTHING BELOW THIS LINE UNLESS YOU KNOW WHAT YOU'RE DOING  ####
#################################################################################
include mapperINC
# checks for outlander v. genie, outlander does not suppor the `mono` flag
if (matchre("$client", "Genie")) then var helpecho #33CC99 mono
if (matchre("$client", "Outlander")) then var helpecho #33CC99
if (matchre("%1", "help|HELP|Help|^$")) then {
  put #echo %helpecho <~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~>
  put #echo %helpecho {  Welcome to travel Setup!   (version %version)                        }
  put #echo %helpecho {  Use the command line to set the following preferences:               }
  put #echo %helpecho {    Pause                                                              }
  put #echo %helpecho {      Time to pause before sending a "put x" command                   }
  put #echo %helpecho {      #var automapper.pause 0.01                                       }
  put #echo %helpecho {    Waiteval Time Out                                                  }
  put #echo %helpecho {      prevents waiting forever for wave to collapse                    }
  put #echo %helpecho {      #var automapper.wavetimeout 15                                   }
  put #echo %helpecho {    Cyclic Spells                                                      }
  put #echo %helpecho {      1: Turn off cyclic spells before moving                          }
  put #echo %helpecho {      0: Leave cyclic spells running while moving                      }
  put #echo %helpecho {      #var automapper.cyclic 1                                         }
  put #echo %helpecho {    Color                                                              }
  put #echo %helpecho {      What should the default automapper echo color be?                }
  put #echo %helpecho {      #var automapper.color #33CC99                                    }
  put #echo %helpecho {    Are you traveling with a group of capped characters?               }
  put #echo %helpecho {      Are you bold enough to risk group breaking anyway?               }
  put #echo %helpecho {      #var TRAVEL.GroupShortCutsAnyway True                            }
  put #echo %helpecho {    Echoes                                                             }
  put #echo %helpecho {      how verbose do you want .travel to be?                           }
  put #echo %helpecho {      #var TRAVEL.verbose True                                         }
  put #echo %helpecho {    Bags                                                               }
  put #echo %helpecho {      When travel needs to stow stuff, where does it go?               }
  put #echo %helpecho {      #var TRAVEL.bagMain backpack                                     }
  put #echo %helpecho {      #var TRAVEL.backupBag duffelbag                                  }
  put #echo %helpecho {                                                                       }
  put #echo %helpecho {  Ranks to use Rossman's shortcut to swim the Jantspyre River          }
  put #echo %helpecho {    North is ~safe~ around 200 and POSSIBLE ~175 W/ no armor           }
  put #echo %helpecho {    South is much easier, safe at ~90                                  }
  put #echo %helpecho {    #var TRAVEL.RossmanNorth 200                                       }
  put #echo %helpecho {    #var TRAVEL.RossmanSouth 90                                        }
  put #echo %helpecho {                                                                       }
  put #echo %helpecho {  Ranks to swim the Faldesu River - Haven <-> NTR                      }
  put #echo %helpecho {    Safe ~ 190                                                         }
  put #echo %helpecho {    Possible ~ 160+ w/ no burden/buffs                                 }
  put #echo %helpecho {    #var TRAVEL.Faldesu 190                                            }
  put #echo %helpecho {                                                                       }
  put #echo %helpecho {  Ranks to swim the Segoltha River - Tiger/Crossing <-> STR            }
  put #echo %helpecho {    Safe ~ 550                                                         }
  put #echo %helpecho {    Possible ~ 530+ w/ no burden/buffs                                 }
  put #echo %helpecho {    #var TRAVEL.Segoltha 550                                           }
  put #echo %helpecho {                                                                       }
  put #echo %helpecho {  Ranks to climb Under Gondola shortcut                                }
  put #echo %helpecho {    Safe ~ 510                                                         }
  put #echo %helpecho {    Possible ~ 480+ w/ buffs and a rope                                }
  put #echo %helpecho {    #var TRAVEL.UnderGondola 515                                       }
  put #echo %helpecho {                                                                       }
  put #echo %helpecho {  Ranks to use 5th passage, Under-Segoltha (THIEF only)                }
  put #echo %helpecho {    Safe ~ 50                                                          }
  put #echo %helpecho {    Possible ~ 35 w/ no burden/buffs                                   }
  put #echo %helpecho {    #var TRAVEL.UnderSegoltha 515                                      }
  put #echo %helpecho {                                                                       }
  put #echo %helpecho {  Ranks for Velka Desert Shortcut - Hvaral <-> Muspar'i                }
  put #echo %helpecho {    THIS IS THE HARDEST SHORTCUT IN THE GAME                           }
  put #echo %helpecho {    FRIENDS DON'T LET FRIENDS WALK TO MUSPAR'I, USE THE BLIMP          }
  put #echo %helpecho {    Safe ~ 800                                                         }
  put #echo %helpecho {    Possible ~ 760 w/ buffs                                            }
  put #echo %helpecho {    #var TRAVEL.muspari 2000                                           }
  put #echo %helpecho {                                                                       }
  put #echo %helpecho {  try `.automapper help` for help with automapper variables            }
  put #echo %helpecho {    there is commonality-these variables will affect how travel works  }
  put #echo %helpecho {      as it manages automapper                                         }
  put #echo %helpecho {  Now save! (#save vars for Genie | cmd-s for Outlander)               }
  put #echo %helpecho <~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~>
  exit
}
#### CHANGELOG ####
#2024-10-17
# Hanryu
#   version bump
#   Big rewrite, pulled out commons subs to an INC
#   unified look and feel with automapper.cmd
#   Finally pulled in Jon's path logic

# Shroom
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
action goto NOCOIN when You haven't got enough (?:.+) to pay for your trip\.|You reach your funds, but realize you're short\.|\"Hey,\"\s+he says,\s+\"You haven't got enough Lirums to pay for your trip\.
action (moving) var Moving 1 when ^Obvious (?:paths|exits)|^\s*[\[\(]?Roundtime\s*\:?
action send fatigue when ^You can see a ferry approaching on the left side\.|^The ferry|^A kingfisher|^A burst of|^The Elven|^The skiff|^The polemen|^Small waves|^The sturdy stone|^You are about a fourth of the way across\.|^The ferry moves away, nearly out of view\.|ferry passing you on the left\.|^You are nearing the docks\.|^A swarm of eels passes beneath the keel, probably on their way to the river's fresh water to spawn\.|followed by the clatter of wood on wood\.|^A family of dolphins leaps from the water beside the galley\.|^Some geese in a perfect V fly north high overhead\.|^Some small blue sharks slide past through the water\.|^A sailor walks by with a coil of rope\.|^A green turtle as large as a tower shield swims past
action send fatigue when ^You are nearing the docks\.|A drumbeat sounds through the ship\.|^You are about a fourth of the way across\.|^A galley comes into sight, its oars beating rhythmically\.|^The galley moves away, the beat of its drum slowly fading\.|^For a few minutes, the drumbeat from below is echoed across the water by the beat from the galley passing on the left\.|^The door swings shut of its own accord, and the gondola pushes off\.|^The platform vanishes against the ridgeline\.|^The gondola arrives at the center of the chasm, and keeps heading (north|south)\.|^The cab trundles on along as the ropes overhead creak and moan\.|^The ropes creak as the gondola continues (north|south)\.|^The gondola creaks as a wind pushes it back and forth\.|^You hear a bell ring out three times|^The barge|^Several oars pull|^All that is visible|^The opposite bank|^A few of the other passengers|^The shore disappears
action send fatigue when ^A desert oasis|^The oasis|^The endless expanse of the desert|^The dock disappears from view quickly|sand-bearing winds buffet|^Several skilled yeehar-handlers|^The Sand Elf|^The harsh winds|^The Gemfire Mountains|^The extreme heat causes|^The sand barge|^The large yeehars|^The murderous shriek|dark-skinned elf|Dark-skinned Elves|^As the barge is pulled|^As the dirigible continues|^The thick canopy of|^The dirigible|^The sinuous Southern Trade Route|^The Reshal Sea|^The peculiar sight|^A long moment of breathless suspense
action send fatigue when ^A Gnomish mechanic|^As the dirigible|^A breathtaking panorama|^The Gnomish operators|^The river quickly gives|^A massive peak|^A large flock|^Far below, you see|^The Greater Fist|^A clangorous commotion|^Passing over land|^A human who had been|^A cowled passenger peers|^The balloon|^A few scattered islands|^The mammoth's fur|^The sea mammoth|^The air cools|^Scarcely visible in|^Another sea mammoth|^Steadily climbing,|^As the airship leaves the mountain range|^With a swift turn of the|^With another yank on the|^The pilot adjusts his controls|^Turning his wheel, the pilot points the airship|^With a confident spin of the|^Coming down from the mountain|^A whoosh of steam escapes|^The warship (?:rumbles|continues)|^The tropical island|(?:crewmen|crewman) (?:works|rush|swabs)|^Sputtering loudly, the cast-iron stove|^Gnomish (?:crew|pilot|crewman)|warship (?:proceeds|continues)
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
action put look when "YOU HAVE BEEN IDLE TOO LONG. PLEASE RESPOND."
put #tvar spellROG 0
put #tvar spellROC 0
put #tvar spellEOTB 0
#auto disembark TOGGLE ready
#  the Kree'la (Riverhaven <-> Ratha)
#  the Lybadel (Riverhaven <-> Aesry)
#  the Skirr'lolasu (Crossing <-> Ratha)
#  The "Damaris's Kiss" (Ain Ghazal <-> Haalikshal Highway)
#  the "Evening Star" (Ain Ghazal <-> Haalikshal Highway)
#  The gondola (Zoluren <-> Ilithi)
#  Both Crossing<-->Leth ferries (Hodierna's Grace and Kertigen's Honor)
#  Both Crossing<-->Haven ferries (His Daring Exploit and Her Opulence)
#  Boar <-> Lang via Wizend Ranger
TOGGLE:
  matchre TOGGLE ^You will now remain on the transport
  matchre TOGGLESET ^You will now automatically disembark
  put toggle disembark
  matchwait
TOGGLESET:
var dockRoomTitles 
var ferryRoomTitles \[Aboard the Dirigible, Gondola\]|\[Alongside a Wizened Ranger\]|\[Aboard the Balloon, Gondola\]|\[Aboard the Mammoth, Platform\]|\[The Bardess' Fete, Deck\]|\[Aboard the Warship, Gondola\]|\[\"?A Birch Skiff\"?\]|\[\"?A Highly Polished Skiff\"?\]|\[\"?Aboard the Mammoth, Platform\"?\]|\[\"?Aboard the Warship, Gondola\"?\]|\[\"?(The )?Degan.+?\]|\[\"?Her Opulence\"?\]|\[\"?His Daring Exploit\"?\]|\[\"?Hodierna's Grace\"?\]|\[\"?Imperial Glory\"?\]|\[\"?Kertigen's Honor\"?\]|\[\"?Northern Pride.+?\]|\[\"?The Damaris' Kiss\"?\]|\[\"?The Desert Wind\"?\]|\[\"?The Evening Star\"?\]|\[\"?The Galley Cercorim\"?\]|\[\"?The Galley Sanegazat\"?\]|\[\"?The Halasa Selhin.+?\]|\[\"?The Jolas.+?\]|\[\"?The Kree'la.+?\]|\[\"?The Night Sky.+?\]|\[\"?The Riverhawk\"?\]|\[\"?The Skirr'lolasu.+?\]|\[\"?The Suncatcher\"?\]|\[\"?Theren's Star.+?\]
var ferryArrivedAtDockMsgs ^The barge pulls into dock|^The captain barks the order to tie off the .+ to the docks\.|The crew ties it off and runs out the gangplank\.|^The warship lands with a creaky lurch|^You come to a very soft stop|dock and its crew ties the (ferry|barge) off\.|^The sand barge pulls into dock|^The skiff lightly taps|returning to Fang Cove|returning to Ratha
var ferryArrivedAtDestinationMsgs 
action (ferry_disembark) var ferryDisembarked 1 when %dockRoomTitles
action (ferry_disembark) var ferryAtDock 1 when %ferryArrivedAtDock
action (ferry_disembark) var ferryDisembarkMovement platform when a barge platform
action (ferry_disembark) var ferryDisembarkMovement pier when the Riverhaven pier
action (ferry_disembark) var ferryDisembarkMovement beach when You also see the beach|mammoth and the beach
action (ferry_disembark) var ferryDisembarkMovement ladder when You also see a ladder|mammoth and a ladder
action (ferry_disembark) var ferryDisembarkMovement wharf when the Langenfirth wharf
action (ferry_disembark) var ferryDisembarkMovement dock when Baso Docks|a dry dock|the salt yard dock|covered stone dock|the south bank docks\.
action (ferry_disembark) off

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
var Kronars 0
var Dokoras 0
var Lirums 0
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
if (!def(guild) || !def(circle)) then action (guildcircle) on
gosub INFO_CHECK
if !def(premium) then gosub PREMIUM_CHECK
if !def(citizenship) then gosub CITIZENSHIP
var shardCitizen False
if (matchre("$citizenship", "Shard")) then var shardCitizen True
if !def(travel.rossmanNorth) then var rossmanNorth 200
else var rossmanNorth $travel.rossmanNorth
if !def(travel.rossmanSouth) then var rossmanSouth 90
else var rossmanSouth $travel.rossmanSouth
if !def(travel.faldesu) then var faldesu 190
else var faldesu $travel.faldesu
if !def(travel.segoltha) then var segoltha 550
else var segoltha $travel.segoltha
if !def(travel.underGondola) then var underGondola 515
else var underGondola $travel.underGondola
if !def(travel.underSegoltha) then var underSegoltha 50
else var underSegoltha $travel.underSegoltha
if !def(travel.muspari) then var muspari 2000
else var muspari $travel.muspari
# what color do you want for echos?
if !def(automapper.color) then var color #B3FF66
else var color $automapper.color
if (matchre("$client", "Genie")) then var color %color mono
# Time to pause before sending a "put x" command
if !def(automapper.pause) then var command_pause 0.01
else var command_pause $automapper.pause
# verbosity
if !def(TRAVEL.verbose) then var verbose 1
else var verbose $TRAVEL.verbose
# Decrease at your own risk, increase if you get infinte loop errors
#default is 0.1 for Outlander, 0.001 for Genie
var infiniteLoopProtection 0.1
if def(client) then {
  if (matchre("$client", "Genie|None")) then var infiniteLoopProtection 0.001
  if (matchre("$client", "Outlander")) then var infiniteLoopProtection 0.1
}
if def(automapper.loop) then var infiniteLoopProtection $automapper.loop
if (def(TRAVEL.mainBag) && def(TRAVEL.backupBag)) then {
  var mainBag $TRAVEL.mainBag
  var backupBag $TRAVEL.backupBag
} else {
  gosub BAG_CHECK
}
TOP:
timer clear
timer start
put #echo >Log %color * TRAVEL START: $zonename (Map:$zoneid | Room:$roomid)
if !def(Athletics.Ranks) then {
  gosub ECHO Athletics.Ranks not set! Attempting to Auto-Fix...| Do you have the EXPTracker Plugin installed??
  pause %command_pause
  put #tvar Athletics.Ranks 0
  put exp 0
  waitforre ^EXP HELP|^Overall state
  pause %command_pause
}
if (!def(Athletics.Ranks) || ($Athletics.Ranks == 0)) then {
  gosub ECHO Still not registering Athletics.Ranks!!! Make sure you have the EXPTracker Plugin!!|Going for it anyway - But this will cause you to skip Athletics Shortcuts!
}
if ($hidden) then gosub UNHIDE
if (($joined == 1) && ($travel.GroupShortCutsAnyway == False)) then {
  var rossmanNorth 2000
  var rossmanSouth 2000
  var faldesu 2000
  var segoltha 2000
  var underGondola 2000
  var underSegoltha 2000
  var shardCitizen False
  if (%verbose) then gosub ECHO You are in a group!  You will NOT be taking the gravy short cuts today!
}
START:
action (moving) on
if (%verbose) then {
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
  gosub ECHO STARTING AREA:| $roomname| MAP: $zoneid | ROOM: $roomid|| DESTINATION: %destination
}
eval destination tolower("%destination")
## DESTINATION
## SPECIAL ESCAPE SECTION FOR MAZES/HARD TO ESCAPE AREAS BY SHROOM
## THIS CHECKS IF WE ARE STARTING FROM A KNOWN MAZE / MESSED UP AREA THAT AUTOMAPPER GETS LOST IN
## THEN USES SPECIAL ESCAPE LOGIC TO GET TO A KNOWN LOCATION THAT AUTOMAPPER CAN USE BEFORE STARTING SCRIPT
if (matchre("$roomname", "The Raven's Court")) then gosub AUTOMOVE 74
if (("$zoneid" == "47") && ($Athletics.Ranks >= %muspari.shortcut) && (!matchre("%destination", "\b(?:musp?a?r?i?)"))) then gosub VELAKA_SHORTCUT
if (matchre("$roomname", "(?:Velaka, Slot Canyon|Yeehar's Graveyard|Heru Taipa)")) then gosub AUTOMOVE 66
if (matchre("$roomname", "(?:Wyvern Mountain, Cavern|Wyvern Mountain, Dragon Shrine|Wyvern Mountain, Raised Dais)")) then gosub SHARD_FAVOR_ESCAPE
if (matchre("$roomname", "(?:Cavern of Glass|Aldauth's Lair)")) then gosub ALDAUTH_ESCAPE
if (matchre("$roomname", "Ehhrsk Highway")) then gosub EHHRSK_ESCAPE
if ((matchre("$roomname", "Zaulfung, Swamp")) && (matchre("$roomdesc", "Rancid mire"))) then gosub ZAULFUNG_ESCAPE
if (matchre("$roomname", "Zaulfung, Trackless Swamp")) then gosub ZAULFUNG_ESCAPE_2
if (matchre("$roomname", "Velaka Desert")) then gosub VELAKA_ESCAPE
if (matchre("$roomname", "Undershard")) then gosub WARRENS_ESCAPE
if (matchre("$roomname", "The Marsh, In The Water")) then gosub CROC_ESCAPE
if (matchre("$roomname", "Maelshyve's Ascent")) then gosub MAELSHYVE_ASCENT_ESCAPE
if (matchre("$roomname", "(?:Abyssal Descent|Abyssal Seed)")) then gosub ABYSSAL_ESCAPE
if (matchre("$roomname", "Deadman's Confide, Beach")) then gosub DEADMAN_ESCAPE
if (matchre("$roomname", "Adder's Nest")) then gosub ADDERNEST_ESCAPE
if (matchre("$roomname", "Temple of the North Wind, Catacombs")) then gosub NORTHWIND_ESCAPE
if (matchre("$roomname", "Temple of the North Wind, High Priestess' Sanctum")) then gosub ASKETI_ESCAPE
if (matchre("$roomname", "Temple of the North Wind, Dark Sanctuary")) then gosub ASKETI_ESCAPE
if (matchre("$roomname", "Temple of the North Wind, Last Sacrifice")) then gosub ASKETI_ESCAPE
if (matchre("$roomname", "Asketi's Mount")) then gosub ASKETI_ESCAPE
if (matchre("$roomname", "The Fangs of Ushnish")) then gosub USHNISH_ESCAPE
if (matchre("$roomname", "Temple of Ushnish")) then gosub USHNISH_ESCAPE_2
if (matchre("$roomname", "Beyond the Gate of Souls")) then gosub USHNISH_ESCAPE_3
if (matchre("$roomname", "Clover Fields")) then gosub BROCKET_ESCAPE
if (matchre("$roomname", "Maelshyve's Fortress, Inner Sanctum")) then gosub MAELSHYVE_FORTRESS_ESCAPE
if (matchre("$roomname", "(?:Maelshyve's Fortress, Hall of Malice|Glutton's Rest|Fallen Altar|Great Dais|Inner Sanctum)")) then gosub MAELSHYVE_FORTRESS_ESCAPE
if (matchre("$roomname", "(?:Charred Caverns|Beneath the Zaulfung|Maelshyve's Threshold)")) then gosub BENEATH_ZAULFUNG_ESCAPE
if (matchre("$roomname", "(?:Zaulfung, Dense Swamp|Kweld Gelvdael|Zaulfung, Urrem'tier's Spire|Zaulfung, Crooked Treetop)")) then gosub ZAULFUNG_ESCAPE_0
if ((matchre("$roomname", "Zaulfung, Swamp")) && (matchre("$roomdesc", "Rancid mire"))) then gosub ZAULFUNG_ESCAPE
if (matchre("$roomname", "Zaulfung, Trackless Swamp")) then gosub ZAULFUNG_ESCAPE_2
if (matchre("$roomname", "Velaka, Dunes")) then gosub VELAKADUNES_ESCAPE
## CHECK TO SEE IF SCRIPT IS STARTED ON BOARD CERTAIN FERRIES - IF SO INITIATE FERRY LOGIC
if (matchre("$roomname", "(%ferryRoomTitles)")) then gosub FERRYLOGIC
## IF SCRIPT IS STARTED IN A ROOMID == 0 - DOUBLE CHECK TO SEE IF WE ARE ON ANY FERRY
## IF NOT ON A FERRY - MOVE IN RANDOM DIRECTIONS AND ATTEMPT TO GET AUTOMAPPER TO REGISTER THE ROOM NUMBER
if (("$zoneid" == "0") || ("$roomid" == "0")) then {
  gosub ECHO Unknown map or room id - Attempting to move in random direction to recover
  gosub FERRY_CHECK
  gosub RANDOMMOVE
}
## SECOND ATTEMPT - IF AUTOMAPPER IS IN ROOMID=0 CONTINUE TO MOVE IN RANDOM DIRECTIONS AND ATTEMPT TO FIND ROOM NUMBER
if (("$zoneid" == "0") || ("$roomid" == "0")) then gosub RANDOMMOVE
## IF ROOMID IS STILL 0 THEN ABORT SCRIPT
if ("$roomid" == "0") then {
  gosub ECHO You are in a spot not recognized by Genie, please start somewhere else!|  ROOMID = 0 ! THIS MEANS THE MAP DOESN'T KNOW WHERE YOU ARE!|  TRY MOVING IN RANDOM DIRECTIONS UNTIL THE MAP REGISTERS LOCATIONS
  exit
}
## CHECK COMMON 'SUB' MAP AREAS WE MIGHT GET STUCK IN AND MOVE TO THE MAIN MAP
if ("$zoneid" == "2d") then gosub AUTOMOVE Map2a_Temple.xml
if ("$zoneid" == "1j") then gosub AUTOMOVE Map1_Crossing.xml
if ("$zoneid" == "1l") then gosub AUTOMOVE Map1_Crossing.xml
if ("$zoneid" == "2a") then gosub AUTOMOVE Map1_Crossing.xml
## IF IN FOREST GRYPHONS - TAKE THE EASIEST PATH OUT (Avoid Automapper getting stuck on a hard climb)
if (("$zoneid" == "34") && ($roomid > 89) && ($roomid < 116)) then {
  gosub AUTOMOVE 90
  gosub AUTOMOVE 49
}
##################
###Pather Start###
##################
gosub Load
gosub Paths

if (def(travel.test) && ($travel.test = 1)) then {
    pause
    echo %Path_Weight
    echo %Path_Paths
    echo %Path_Arcs
    echo %Path_Names
    echo %Path_Rooms
    exit
} 

var i_Path 0
Travel_Path:
if ("%Path_Arcs(%i_Path)" != "") then {
  gosub automove %Path_Arcs(%i_Path) "%Path_Rooms(%i_Path)"
  math i_Path add 1
  goto Travel_Path
}
goto ARRIVED


Paths:
    if !(matchre("%Maps", "\|%Current_Zone\|")) then {
            gosub %Current_Zone
        var Maps %Maps%Current_Zone|
    }
    if ("%Arc_Queue(1)" != "") then {
        gosub Arc_Queue
        if ("%Current_Zone" != "") then goto Paths
    }
goto Link_Paths

Arc_Queue:
    var i_Arc_Queue 1
    var j_Arc_Queue 0
    var t_Arc_Queue 
    var Next_Shortest_Path
    Pick_Shortest_Path:
        eval t_Arc_Queue replacere("%Arc_Queue(%i_Arc_Queue)", ";", "|")
        if (%j_Arc_Queue != 0) then {
            if (%t_Arc_Queue(1) < %Next_Shortest_Path) then {
                var Next_Shortest_Path %t_Arc_Queue(1)
                var Current_Zone %t_Arc_Queue(0)
                var j_Arc_Queue %i_Arc_Queue
            }
        } else {
            var Next_Shortest_Path %t_Arc_Queue(1)
            var Current_Zone %t_Arc_Queue(0)
            var j_Arc_Queue %i_Arc_Queue
        }
        math i_Arc_Queue add 1
        if ("%Arc_Queue(%i_Arc_Queue)" != "") then goto Pick_Shortest_Path
        eval Arc_Queue replacere("%Arc_Queue", "\|%Current_Zone;[^\|]+\|", "|")
return

Link_Paths:
    var Previous_Zone %Ending_Zone
    if !(matchre("%Maps", "\|%Previous_Zone\|")) then {
        echo No path to destination
        exit
    }
    Link_Paths_Loop:
        eval Current_Zone replacere("%Link%Previous_Zone", "^.*\|Link", "")
        var Path_Map %%Current_Zone_to_%Previous_Zone
        var Path_Paths %Current_Zone_to_%Previous_Zone|%Path_Paths
        var Path_Part %Path_Map(0)
        var Path_Weight %Path_Part|%Path_Weight
        var Path_Part %Path_Map(2)
        var Path_Arcs %Path_Part|%Path_Arcs
        var Path_Part %Path_Map(3)
        var Path_Names %Path_Part|%Path_Names
        var Path_Part %Path_Map(4)
        var Path_Rooms %Path_Part|%Path_Rooms
        if ("%Current_Zone" != "") && ("%Current_Zone" != "%Starting_Zone") then {
            var Previous_Zone %Current_Zone
            goto Link_Paths_Loop
        }
return

Map_to_Map:
    var Map_to_Map $1
    var Map_to_Map_Vars $0
    eval Map_to_Map_Vars replacere("%Map_to_Map_Vars", "^%Map_to_Map ", "")
    eval Map_to_Map_Maps replacere("%Map_to_Map", "_to_", "|")
    if (matchre("%Maps", "\|%Map_to_Map_Maps(1)\|")) then return
    gosub Check_Distance %Map_to_Map_Maps(0) %Map_to_Map_Maps(1) %Map_to_Map_Vars(0) %Map_to_Map_Vars(1)
    if (%updt_time == 1) then {
        var %Map_to_Map %Map_to_Map_Vars
        var Arc_Queue %Arc_Queue%Map_to_Map_Maps(1);%chk_curSet|
    }
return

Check_Distance:
    var chk_curM Link$1
    var chk_nxtM Link$2
    var chk_curSet $3
    var chk_Set_Mod $4
    var updt_time 0
    if ("%chk_Set_Mod" != "0") then gosub Modify_Weight
    if (("%chk_Set_Mod" != "0") && (%mod_weight == 0)) then return
    var temp %%chk_curM
    evalmath chk_curSet (%temp(0) + %chk_curSet)
    if ("%chk_nxtM" == "") then return
    if ("%%chk_nxtM" == "\%%chk_nxtM") then {
        #Var does not exist
        if  ("%chk_curSet" != "") then gosub Link_Maps
    } else {
        #Var does exist checking value
        if  ("%%chk_nxtM" != "") then {
            var temp %%chk_nxtM
            var chk_prvSet %temp(0)
            if (%chk_curSet < %chk_prvSet) then gosub Link_Maps
        }
    }
return

Link_Maps:
    var %chk_nxtM %chk_curSet|%chk_curM
    var updt_time 1
return

Modify_Weight:
    var mod_weight 0
    ###AND checks###
    if matchre("%chk_Set_Mod", "Athletics;([^;]+);?") then {
        if !(def(Athletics.Ranks) && ($Athletics.Ranks >= %$1)) then return
        if !(matchre("%chk_Set_Mod", "([^;]+;){2,}")) then var mod_weight 1
    }
    ###OR checks###
    if matchre("%chk_Set_Mod", "Guild;([^;]+);?") then {
        if (def(guild) && matchre("%Guild", "(?i)$1")) then var mod_weight 1
    }

    if matchre("%chk_Set_Mod", "Citizenship;([^;]+);?") then {
        if (def(citizenship) && matchre("%Citizenship", "(?i)$1")) then var mod_weight 1
    }
    if matchre("%chk_Set_Mod", "Subscription;([^;]+);?") then {
        if (def(subscription) && matchre("%Subscription", "(?i)$1")) then {
            var mod_weight 1
            var chk_curSet 1
            return
        }
    }
    if matchre("%chk_Set_Mod", "Game;([^;]+);?") then {
        if (def(game) && matchre("$Game", "(?i)$1")) then var mod_weight 1
    }
    if matchre("%chk_Set_Mod", "Moons;([^;]+);?") then {
        if (def(Moons) && matchre("$Moons", "(?i)%$1")) then var mod_weight 1
    }
    if matchre("%chk_Set_Mod", "Courage;([^;]+);?") then {
        if (def(Courage) && matchre("$Courage", "(?i)%$1")) then var mod_weight 1
    }

    if (%mod_weight = 1) then {
        var chk_curSet 10
    } else var chk_curSet 99999999999
return

##########################
###Map Data Starts Here###
##########################

    Map99999Array:
    Map118eArray:
    return



    Map1Array:
        ## CROSS PORTAL ENTRANCE Zone 1 Room 484
        gosub Map_to_Map Map1Array_to_Map99Array 1|Subscription;Platinum|1049|Map99_Aesry_Surlaenis'a.xml|Aesry Surlaenis'a, Staho Pivo'hrr'schu'Mus
        gosub Map_to_Map Map1Array_to_Map150Array 10|Subscription;Premium|652|Map150_Fang_Cove.xml|Fang Cove, Fate's Fortune Lane
        gosub Map_to_Map Map1Array_to_Map50Array 20|0|476|Map50_Segoltha_River.xml|Riverbank Trail
        gosub Map_to_Map Map1Array_to_Map1a_4Array 10|Guild;Thief|650|Map1a_Crossing_Thief.xml|Riverbank Mudflats, Rough Stairway
        gosub Map_to_Map Map1Array_to_Map1a_3Array 10|Guild;Thief|853|Map1a_Crossing_Thief.xml|Underground Passageway
        gosub Map_to_Map Map1Array_to_Map1a_3Array 10|Guild;Thief|854|Map1a_Crossing_Thief.xml|Underground Passageway
        gosub Map_to_Map Map1Array_to_Map1a_1Array 10|Guild;Thief|855|Map1a_Crossing_Thief.xml|A Dank Dark Passage
        gosub Map_to_Map Map1Array_to_Map1a_1Array 10|Guild;Thief|856|Map1a_Crossing_Thief.xml|A Dank, Cluttered Passage
        gosub Map_to_Map Map1Array_to_Map1a_2Array 10|Guild;Thief|859|Map1a_Crossing_Thief.xml|The Raven's Court, Secret Passage
        gosub Map_to_Map Map1Array_to_Map1a_2Array 10|Guild;Thief|860|Map1a_Crossing_Thief.xml|Behind the Half Pint Inn
        gosub Map_to_Map Map1Array_to_Map1a_2Array 10|Guild;Thief|861|Map1a_Crossing_Thief.xml|The Raven's Court, Basement
        gosub Map_to_Map Map1Array_to_Map1jArray 10|0|850|Map1j_Market_Plaza.xml|Market Plaza, Foyer
        gosub Map_to_Map Map1Array_to_Map1lArray 10|0|477|Map1l_Crossing_Amusement_Pier.xml|Amusement Pier, Entrance
        gosub Map_to_Map Map1Array_to_Map1mArray 10|0|294|Map1m_Crossing_Jadewater.xml|Jadewater Mansion, Cobbled Path
        gosub Map_to_Map Map1Array_to_Map2aArray 10|0|440|Map2a_Temple.xml|Temple Grounds, Entry Gates
        gosub Map_to_Map Map1Array_to_Map2dArray 10|0|1005|Map2d_Escape_Tunnels.xml|Crossing Escape Tunnels, Kuniyo's Egress
        gosub Map_to_Map Map1Array_to_Map2dArray 10|0|1006|Map2d_Escape_Tunnels.xml|Crossing Escape Tunnels, Truffenyi's Way
        gosub Map_to_Map Map1Array_to_Map2dArray 10|0|1007|Map2d_Escape_Tunnels.xml|Crossing Escape Tunnels, Hodierna's Path
        gosub Map_to_Map Map1Array_to_Map4Array 10|0|172|Map4_Crossing_West_Gate.xml|Mycthengelde, Flatlands
        # gosub Map_to_Map Map1Array_to_Map4Array 10|Athletics;CrossingWall|403|Map4_Crossing_West_Gate.xml|Mycthengelde, Flatlands
        # gosub Map_to_Map Map1Array_to_Map4Array 10|Athletics;CrossingWall|434|Map4_Crossing_West_Gate.xml|Northwall Trail, Wooded Grove
        # gosub Map_to_Map Map1Array_to_Map4Array 10|Athletics;CrossingWall|864|Map4_Crossing_West_Gate.xml|Northwall Trail, Wooded Grove
        # gosub Map_to_Map Map1Array_to_Map4Array 10|Athletics;CrossingWall|868|Map4_Crossing_West_Gate.xml|Wildulf Woods, Dense Forest
        gosub Map_to_Map Map1Array_to_Map502Array 10|0|1017|Map502_The_Seacaves_of_Peri'el.xml|The Seacaves of Peri'el, Tidal Cave
        gosub Map_to_Map Map1Array_to_Map6Array 10|0|173|Map6_Crossing_North_Gate.xml|North Turnpike, Forest
        gosub Map_to_Map Map1Array_to_Map6Array 10|Guild;Ranger|985|Map6_Crossing_North_Gate.xml|Northwall Trail, Tree Top
        gosub Map_to_Map Map1Array_to_Map7Array 10|0|171|Map7_NTR.xml|Northeast Wilds, Outside Northeast Gate
        gosub Map_to_Map Map1Array_to_Map8Array 10|0|170|Map8_Crossing_East_Gate.xml|Eastern Tier, Outside Gate
        # gosub Map_to_Map Map1Array_to_Map8Array 10|Athletics;CrossingWall|389|Map8_Crossing_East_Gate.xml|Outside East Wall, Footpath
        # gosub Map_to_Map Map1Array_to_Map8Array 10|Athletics;CrossingWall|402|Map8_Crossing_East_Gate.xml|Outside East Wall, Footpath
        # gosub Map_to_Map Map1Array_to_Map8Array 10|Athletics;CrossingWall|862|Map8_Crossing_East_Gate.xml|Outside East Wall, Footpath
        gosub Map_to_Map Map1Array_to_Map998_9Array 10800|0|368|Map998_Transports.xml|The Skirr'lolasu, Main Deck
        gosub Map_to_Map Map1Array_to_Map998_1Array 500|0|935|Map998_Transports.xml|Kertigen's Honor
        gosub Map_to_Map Map1Array_to_Map998_1Array 500|0|936|Map998_Transports.xml|Hodierna's Grace
    return

    Map10Array:
        gosub Map_to_Map Map10Array_to_Map7Array 10|0|116|Map7_NTR.xml|Foothills, Stony Incline
    return

    Map106Array:
        gosub Map_to_Map Map106Array_to_MapTF1Array 10|Game;DRF|99|MapTF1_The_Arch.xml|Droughtman's Maze, The Opal Lounge
    return

    Map107Array:
        ## MERKRESH PORTAL ENTRANCE Zone 107 Room 273
        gosub Map_to_Map Map107Array_to_Map30Array 1|Subscription;Platinum|360|Map30_Riverhaven.xml|Riverhaven, Tree-shaded Lane
        gosub Map_to_Map Map107Array_to_Map107aArray 500|0|285|Map107a_Belarritaco_Bay.xml|The Galley Sanegazat
        gosub Map_to_Map Map107Array_to_Map107aArray 500|0|286|Map107a_Belarritaco_Bay.xml|The Galley Cercorim
        gosub Map_to_Map Map107Array_to_Map150Array 10|Subscription;Premium|315|Map150_Fang_Cove.xml|Fang Cove, Fate's Fortune Lane
    return

    Map107aArray:
        gosub Map_to_Map Map107aArray_to_Map107Array 500|0|4|Map107_Mer'Kresh.xml|Mer'Kresh, The Galley Dock
        gosub Map_to_Map Map107aArray_to_Map108Array 500|0|3|Map108_M'Riss.xml|Belarritaco Bay, The Galley Dock
    return

    Map108Array:
        gosub Map_to_Map Map108Array_to_Map107aArray 500|0|307|Map107a_Belarritaco_Bay.xml|The Galley Sanegazat
        gosub Map_to_Map Map108Array_to_Map107aArray 500|0|308|Map107a_Belarritaco_Bay.xml|The Galley Cercorim
        gosub Map_to_Map Map108Array_to_Map150Array 10|Subscription;Premium|378|Map150_Fang_Cove.xml|Fang Cove, Fate's Fortune Lane
    return

    Map11Array:
        gosub Map_to_Map Map11Array_to_Map7Array 10|0|2|Map7_NTR.xml|Northern Trade Road, Wooded Valley
    return

    Map112Array:
        gosub Map_to_Map Map112Array_to_Map113_1Array 100|0|98|Map113_West_Segoltha.xml|Ilaya Taipa, Baso Dock
        gosub Map_to_Map Map112Array_to_Map61Array 100|0|112|Map61_Leth_Deriel.xml|Old Crank's Road, Forest
    return

    Map113_1Array:
        gosub Map_to_Map Map113_1Array_to_Map112Array 500|0|5|Map112_Ilaya_Taipa.xml|Ilaya Taipa, Northeast Harbor Wall
        gosub Map_to_Map Map113_1Array_to_Map114Array 500|0|10|Map114_Ain_Ghazal.xml|Ain Ghazal, River Road
        return
        Map113_2Array:
        gosub Map_to_Map Map113_2Array_to_Map114Array 500|0|9|Map114_Ain_Ghazal.xml|Ain Ghazal, River Road
        gosub Map_to_Map Map113_2Array_to_Map123Array 500|0|7|Map123_Himineldar_Shel.xml|Haalikshal Highway, Himineldar Shel to Ain Ghazal
    return

    Map114Array:
        gosub Map_to_Map Map114Array_to_Map113_1Array 100|0|1|Map113_West_Segoltha.xml|Ain Ghazal, East Pier
        gosub Map_to_Map Map114Array_to_Map113_2Array 100|0|4|Map113_West_Segoltha.xml|Ain Ghazal, Ferry Dock
        gosub Map_to_Map Map114Array_to_Map150Array 10|Subscription;Premium|175|Map150_Fang_Cove.xml|Fang Cove, Fate's Fortune Lane
    return

    Map116Array:
        ## HIBAR PORTAL ENTRANCE Zone 116 Room 188
        gosub Map_to_Map Map116Array_to_Map1Array 1|Subscription;Platinum|493|Map1_Crossing.xml|Communal Center, Veranda
        gosub Map_to_Map Map116Array_to_Map118eArray 10|0|216|Map118e_Firecats.xml|Cavern of Fire, Stalagmite Maze
        gosub Map_to_Map Map116Array_to_Map123Array 10|0|3|Map123_Himineldar_Shel.xml|Lewkar Awg, The Courtyard
        gosub Map_to_Map Map116Array_to_Map126Array 10|0|217|Map126_Hawstkaal_Road.xml|Gate to Hibarnhvidar
        gosub Map_to_Map Map116Array_to_Map150Array 10|Subscription;Premium|419|Map150_Fang_Cove.xml|Fang Cove, Fate's Fortune Lane
    return

    Map123Array:
        gosub Map_to_Map Map123Array_to_Map113_2Array 100|0|174|Map113_West_Segoltha.xml|Haalikshal Highway, Ferry Dock
        gosub Map_to_Map Map123Array_to_Map116Array 10|0|169|Map116_Hibarnhvidar.xml|Haalikshal Highway, The Sky Road
        gosub Map_to_Map Map123Array_to_Map69Array 10|0|175|Map69_Shard_West_Gate.xml|Cragstone Vale, Roadway
        gosub Map_to_Map Map123Array_to_Map69Array 500|0|268|Map69_Shard_West_Gate.xml|Seord Kerwaith, Gear Gate
    return

    Map126Array:
        gosub Map_to_Map Map126Array_to_Map116Array 10|Athletics;BoarArchersFord|49|Map116_Hibarnhvidar.xml|Outer Hibarnhvidar, Market Road
        gosub Map_to_Map Map126Array_to_Map127Array 10|Athletics;BoarArchersFord|103|Map127_Boar_Clan.xml|Hawstkaal Road, Boar Clan Bridge
    return

    Map127Array:
        gosub Map_to_Map Map127Array_to_Map126Array 10|0|510|Map126_Hawstkaal_Road.xml|Hawstkaal Road, Dense Forest
    return

    Map12aArray:
        gosub Map_to_Map Map12aArray_to_Map7Array 10|0|60|Map7_NTR.xml|Northern Trade Road, Deep Forest
    return

    Map13Array:
        gosub Map_to_Map Map13Array_to_Map7Array 10|0|71|Map7_NTR.xml|North Roads Caravansary
    return

    Map14bArray:
        gosub Map_to_Map Map14bArray_to_Map7Array 10|0|217|Map7_NTR.xml|Sicle Grove, Low Mound
    return

    Map14cArray:
        gosub Map_to_Map Map14cArray_to_Map31Array 100|Athletics;RiverhavenFaldesu|22|Map31_Riverhaven_East_Gate.xml|Riverhaven, Stone Bridge
        gosub Map_to_Map Map14cArray_to_Map7Array 100|Athletics;RiverhavenFaldesu|21|Map7_NTR.xml|The Marsh, Stone Road
    return

    Map14dArray:
        gosub Map_to_Map Map14dArray_to_Map7cArray 10|0|1|Map7c_NTR_Part2.xml|North Road, Plains
    return

    Map150Array:
        gosub Map_to_Map Map150Array_to_Map58Array 300|0|231|Map58_Acenamacra_Village.xml|Acenamacra Pier
        gosub Map_to_Map Map150Array_to_Map90Array 300|0|53|Map90_Ratha.xml|Shore Walk, Rocky Path
    return

    Map1a_1Array:
            gosub Map_to_Map Map1a_1Array_to_Map1Array 10|Guild;Thief|29|Map1_Crossing.xml|The Crossing, Trollferry Quay
            gosub Map_to_Map Map1a_1Array_to_Map1Array 10|Guild;Thief|30|Map1_Crossing.xml|The Strand, Crystalline Beach
        return
        Map1a_2Array:

            gosub Map_to_Map Map1a_2Array_to_Map1Array 10|Guild;Thief|33|Map1_Crossing.xml|The Raven's Court, Garden of Midnight
            gosub Map_to_Map Map1a_2Array_to_Map1Array 10|Guild;Thief|35|Map1_Crossing.xml|The Raven's Court, Scullery
            gosub Map_to_Map Map1a_2Array_to_Map1Array 10|Guild;Thief|39|Map1_Crossing.xml|The Crossing, Werfnen's Strole
        return
        Map1a_3Array:
            gosub Map_to_Map Map1a_3Array_to_Map1Array 10|Guild;Thief|4|Map1_Crossing.xml|The Crossing, Town Green Northeast
            gosub Map_to_Map Map1a_3Array_to_Map1Array 10|Guild;Thief|43|Map1_Crossing.xml|Thieves' Guild, Master's Den
            gosub Map_to_Map Map1a_3Array_to_Map1Array 10|Guild;Thief|5|Map1_Crossing.xml|The Crossing, Oralana Ramble
        return
        Map1a_4Array:
            gosub Map_to_Map Map1a_4Array_to_Map1Array 10|Guild;Thief;Athletics;Crossing5thPassage|6|Map1_Crossing.xml|Riverbank Mudflats
            gosub Map_to_Map Map1a_4Array_to_Map60Array 10|Guild;Thief;Athletics;Crossing5thPassage|23|Map60_STR1.xml|Southern Trade Route, Endrus Forest
    return

    Map1jArray:
        gosub Map_to_Map Map1jArray_to_Map1Array 10|0|1|Map1_Crossing.xml|The Crossing, Mongers' Square
    return

    Map1lArray:
        gosub Map_to_Map Map1lArray_to_Map1Array 10|0|1|Map1_Crossing.xml|The Crossing, Esplanade Eluned
    return

    Map1mArray:
        gosub Map_to_Map Map1mArray_to_Map1Array 10|0|1|Map1_Crossing.xml|The Crossing, Eylhaar Bane Road
        gosub Map_to_Map Map1mArray_to_Map7Array 10|0|28|Map7_NTR.xml|Jadewater Mansion, Rear Entrance
    return

    Map2Array:
        gosub Map_to_Map Map2Array_to_Map4Array 10|0|2|Map4_Crossing_West_Gate.xml|Mycthengelde, Knoll
    return

    Map2aArray:
        gosub Map_to_Map Map2aArray_to_Map1Array 10|0|3|Map1_Crossing.xml|The Crossing, Immortals' Approach
        gosub Map_to_Map Map2aArray_to_Map2dArray 10|0|188|Map2d_Escape_Tunnels.xml|Temple, North Tower
    return

    Map2dArray:
        gosub Map_to_Map Map2dArray_to_Map1Array 10|Guild;Cleric|24|Map1_Crossing.xml|Clerics' Guild, Wine Cellar
        gosub Map_to_Map Map2dArray_to_Map1Array 10|Guild;Ranger|39|Map1_Crossing.xml|Wilds, Pine Needle Path
        gosub Map_to_Map Map2dArray_to_Map1Array 10|Guild;Empath|4|Map1_Crossing.xml|The Healerie, Entrance Hall
        gosub Map_to_Map Map2dArray_to_Map2aArray 10|0|62|Map2a_Temple.xml|Temple Grounds, North Tower
    return

    Map30Array:
        ## RIVERHAVEN PORTAL ENTRANCE Zone 30 Room 331
        gosub Map_to_Map Map30Array_to_Map90Array 1|Subscription;Platinum|565|Map90_Ratha.xml|Sshoi-sson Palace, Portico
        gosub Map_to_Map Map30Array_to_Map150Array 10|Subscription;Premium|445|Map150_Fang_Cove.xml|Fang Cove, Fate's Fortune Lane
        gosub Map_to_Map Map30Array_to_Map30aArray 10|0|384|Map30a_Dunshade_Manor.xml|Dunshade Manor, Front Lawn
        gosub Map_to_Map Map30Array_to_Map30bArray 10|Guild;Thief|396|Map30b_Riverhaven_Thief.xml|Riverhaven, Smugglers' Passage
        gosub Map_to_Map Map30Array_to_Map30bArray 10|Guild;Thief|397|Map30b_Riverhaven_Thief.xml|Riverhaven, Smugglers' Passage
        gosub Map_to_Map Map30Array_to_Map31Array 10|0|203|Map31_Riverhaven_East_Gate.xml|Riverhaven, Stone Bridge
        gosub Map_to_Map Map30Array_to_Map32Array 10|0|204|Map32_Riverhaven_North_Gate.xml|Riverhaven, Outside North Gate
        gosub Map_to_Map Map30Array_to_Map33Array 10|0|174|Map33_Riverhaven_West_Gate.xml|Riverhaven Exterior, Southwest Gate
        gosub Map_to_Map Map30Array_to_Map35Array 500|0|207|Map35_Throne_City.xml|Stone Docks, Covered Shore
        gosub Map_to_Map Map30Array_to_Map998_2Array 300|0|201|Map998_Transports.xml|Her Opulence
        gosub Map_to_Map Map30Array_to_Map998_2Array 300|0|202|Map998_Transports.xml|His Daring Exploit
        gosub Map_to_Map Map30Array_to_Map998_3Array 500|0|205|Map998_Transports.xml|Theren's Star, Deck
        gosub Map_to_Map Map30Array_to_Map998_3Array 500|0|483|Map998_Transports.xml|Northern Pride, Main Deck
        gosub Map_to_Map Map30Array_to_Map998_7Array 500|0|218|Map998_Transports.xml|Lybadel, Main Deck
        gosub Map_to_Map Map30Array_to_Map998_6Array 500|0|444|Map998_Transports.xml|The Kree'la, Main Deck
    return

    Map30aArray:
        gosub Map_to_Map Map30aArray_to_Map30Array 10|0|57|Map30_Riverhaven.xml|Riverhaven, Crossroads
    return

    Map30bArray:
        gosub Map_to_Map Map30bArray_to_Map30Array 10|Guild;Thief|13|Map30_Riverhaven.xml|Riverhaven, Ring Road West
        gosub Map_to_Map Map30bArray_to_Map30Array 10|Guild;Thief|14|Map30_Riverhaven.xml|Riverhaven, River Road West
        gosub Map_to_Map Map30bArray_to_Map32Array 10|Guild;Thief|12|Map32_Riverhaven_North_Gate.xml|Wildlands, Meandering Path
    return

    Map31Array:
        gosub Map_to_Map Map31Array_to_Map14cArray 10|0|79|Map14c_Faldesu.xml|Faldesu River, North Bank
        gosub Map_to_Map Map31Array_to_Map30Array 10|0|1|Map30_Riverhaven.xml|Riverhaven, River Road East
        gosub Map_to_Map Map31Array_to_Map31aArray 10|0|100|Map31a_Zaulfung.xml|Zaulfung, Swamp
    return

    Map31aArray:
        gosub Map_to_Map Map31aArray_to_Map31Array 10|0|122|Map31_Riverhaven_East_Gate.xml|Zaulfung, Dense Swamp
        gosub Map_to_Map Map31aArray_to_Map31bArray 10|0|117|Map31b_Maelshyve's_Fortress.xml|Zaulfung, Underwater
        gosub Map_to_Map Map31aArray_to_Map31bArray 10|0|123|Map31b_Maelshyve's_Fortress.xml|Beneath The Zaulfung, Charred Caverns
    return

    Map31bArray:
        gosub Map_to_Map Map31bArray_to_Map31aArray 10|0|122|Map31a_Zaulfung.xml|Kweld Gelvdael, Dark Tunnel
        gosub Map_to_Map Map31bArray_to_Map31aArray 10|0|5|Map31a_Zaulfung.xml|Zaulfung, Ruined Shrine
        gosub Map_to_Map Map31bArray_to_Map501Array 1000|Courage;DeathWish|123|Map501_Soul_of_Maelshyve.xml|Soul of Maelshyve, The Involution
    return

    Map32Array:
        gosub Map_to_Map Map32Array_to_Map30Array 10|0|1|Map30_Riverhaven.xml|Riverhaven, Theren Way
        gosub Map_to_Map Map32Array_to_Map30bArray 10|Guild;Thief|81|Map30b_Riverhaven_Thief.xml|Riverhaven, Smugglers' Passage
    return

    Map33Array:
        gosub Map_to_Map Map33Array_to_Map30Array 10|0|1|Map30_Riverhaven.xml|Riverhaven, River Road West
        gosub Map_to_Map Map33Array_to_Map33aArray 10|0|29|Map33a_Road_to_Therenborough.xml|Mistwood Forest Road
    return

    Map33aArray:
        gosub Map_to_Map Map33aArray_to_Map33Array 10|0|46|Map33_Riverhaven_West_Gate.xml|Riverhaven Exterior, Trodden Path
        gosub Map_to_Map Map33aArray_to_Map34Array 40|Athletics;RossmanJantspyreNorth|48|Map34_Mistwood_Forest.xml|Jantspyre River, In the Water
    return

    Map34Array:
        gosub Map_to_Map Map34Array_to_Map33aArray 40|Athletics;RossmanJantspyreSouth|15|Map33a_Road_to_Therenborough.xml|Jantspyre River, South Bank
        gosub Map_to_Map Map34Array_to_Map34aArray 10|0|22|Map34a_Rossman's_Landing.xml|Rossman's Landing, Foregate Passage
        gosub Map_to_Map Map34Array_to_Map40Array 10|0|137|Map40_Langenfirth_to_Therenborough.xml|North Road, Farmlands
    return

    Map34aArray:
        gosub Map_to_Map Map34aArray_to_Map34Array 10|0|134|Map34_Mistwood_Forest.xml|Rossman's Landing, Southeast Gate
    return

    Map35Array:
        gosub Map_to_Map Map35Array_to_Map30Array 500|0|199|Map30_Riverhaven.xml|Salt Yard, Barge Dock
        gosub Map_to_Map Map35Array_to_Map42Array 10|Moons;Up|198|Map42_Therenborough_and_Keep.xml|Gealeranendae College, Tear of Grazhir Exhibit
    return
    # 35a_1
    # 35|59>35a|11

    # 35a_2
    # 35|61>35a|1
    # 35|102>35a|3

    # 35a_3
    # 35|17>35a|4
    # 35|148>35a|6

    Map35a_1Array:
        gosub Map_to_Map Map35a_1Array_to_Map35Array 10|Guild;Thief|16|Map35_Throne_City.xml|Old Throne City, Dahl Aeliy
        return
        Map35a_2Array:
        gosub Map_to_Map Map35a_2Array_to_Map35Array 10|Guild;Thief|7|Map35_Throne_City.xml|Imperial Palace, Dungeon
        gosub Map_to_Map Map35a_2Array_to_Map35Array 10|Guild;Thief|8|Map35_Throne_City.xml|Old Throne City, Dahl Aeliy
        return
        Map35a_3Array:
        gosub Map_to_Map Map35a_3Array_to_Map35Array 10|Guild;Thief|9|Map35_Throne_City.xml|Old Throne City, Entertainment District
        gosub Map_to_Map Map35a_3Array_to_Map35Array 10|Guild;Thief|10|Map35_Throne_City.xml|Seven Star Exchange and Pawn
    return

    Map4Array:
        gosub Map_to_Map Map4Array_to_Map1Array 10|0|14|Map1_Crossing.xml|The Crossing, Western Gate
        # gosub Map_to_Map Map4Array_to_Map1Array 10|Athletics;CrossingWall|265|Map1_Crossing.xml|Crossing, North Wall Battlements
        # gosub Map_to_Map Map4Array_to_Map1Array 10|Athletics;CrossingWall|266|Map1_Crossing.xml|Crossing, West Gate Battlements
        # gosub Map_to_Map Map4Array_to_Map1Array 10|Athletics;CrossingWall|267|Map1_Crossing.xml|Crossing, West Wall Battlements
        gosub Map_to_Map Map4Array_to_Map2Array 10|0|15|Map2_Lake_of_Dreams.xml|Laakvor
        gosub Map_to_Map Map4Array_to_Map4aArray 10|0|87|Map4a_Tiger_Clan.xml|Tiger Clan Home, Dirt Pathway
        gosub Map_to_Map Map4Array_to_Map6Array 10|0|264|Map6_Crossing_North_Gate.xml|Northwall Trail, Wooded Grove
    return

    Map40Array:
        ## ELBAINS PORTAL ENTRANCE Zone 40 Room 254
        gosub Map_to_Map Map40Array_to_Map47Array 1|Subscription;Platinum|394|Map47_Muspar'i.xml|Old Lata'arna Keep, Exchange Vault
        gosub Map_to_Map Map40Array_to_Map150Array 10|Subscription;Premium|375|Map150_Fang_Cove.xml|Fang Cove, Fate's Fortune Lane
        gosub Map_to_Map Map40Array_to_Map34Array 10|0|213|Map34_Mistwood_Forest.xml|Mistwood Forest Road
        gosub Map_to_Map Map40Array_to_Map40aArray 10|0|263|Map40a_Langenfirth_to_Siksraja.xml|Langenfirth, Trail Above the Fens
        gosub Map_to_Map Map40Array_to_Map41Array 70|0|376|Map41_Marauders.xml|Ker'Leor, Deep Forest Path
        gosub Map_to_Map Map40Array_to_Map42Array 10|0|211|Map42_Therenborough_and_Keep.xml|Therenborough, Town Gate
        gosub Map_to_Map Map40Array_to_Map998_3Array 500|0|245|Map998_Transports.xml|Northern Pride, Main Deck
        gosub Map_to_Map Map40Array_to_Map998_3Array 500|0|377|Map998_Transports.xml|Theren's Star, Deck
        gosub Map_to_Map Map40Array_to_Map99999Array 10|0|316|Map99999_Guildfest.xml|Fairegrounds Entrance
    return 

    Map40aArray:
        gosub Map_to_Map Map40aArray_to_Map40Array 10|0|125|Map40_Langenfirth_to_Therenborough.xml|Langenfirth, Blufe Path
        # gosub Map_to_Map Map40aArray_to_Map127Array ranger something to boar
    return

    Map41Array:
        gosub Map_to_Map Map41Array_to_Map40Array 70|0|53|Map40_Langenfirth_to_Therenborough.xml|Theren Road
        gosub Map_to_Map Map41Array_to_Map48Array 70|0|208|Map48_Haizen_Cugis.xml|Velaka Desert, Beneath the Dry Dock
        gosub Map_to_Map Map41Array_to_Map998_5Array 500|0|184|Map998_Transports.xml|The Desert Wind
        gosub Map_to_Map Map41Array_to_Map998_5Array 500|0|207|Map998_Transports.xml|The Suncatcher
    return

    Map42Array:
        gosub Map_to_Map Map42Array_to_Map35Array 10|Moons;Up|292|Map35_Throne_City.xml|Phelim's Sanctum, Tear of Grazhir
        gosub Map_to_Map Map42Array_to_Map40Array 10|0|2|Map40_Langenfirth_to_Therenborough.xml|North Road, Barony Pass
    return

    Map47Array:
        ## MUSPARI PORTAL ENTRANCE Zone 47 Room 97
        gosub Map_to_Map Map47Array_to_Map116Array 1|Subscription;Platinum|562|Map116_Hibarnhvidar.xml|Inner Hibarnhvidar, Tower Base
        gosub Map_to_Map Map47Array_to_Map150Array 10|Subscription;Premium|483|Map150_Fang_Cove.xml|Fang Cove, Fate's Fortune Lane
        gosub Map_to_Map Map47Array_to_Map47aArray 10|Guild;Thief|367|Map47a_Muspar'i_Thief.xml|Muspar'i, Behind the Justice Office
        gosub Map_to_Map Map47Array_to_Map47aArray 10|Guild;Thief|368|Map47a_Muspar'i_Thief.xml|Muspar'i, Rear Lot
        gosub Map_to_Map Map47Array_to_Map47aArray 10|Guild;Thief|369|Map47a_Muspar'i_Thief.xml|Muspar'i, Shadow of the Great Gate
        gosub Map_to_Map Map47Array_to_Map48Array 10|Athletics;HaizenCugisDesert|391|Map48_Haizen_Cugis.xml|Velaka Desert
        gosub Map_to_Map Map47Array_to_Map998_5Array 500|0|143|Map998_Transports.xml|The Desert Wind
        gosub Map_to_Map Map47Array_to_Map998_5Array 500|0|482|Map998_Transports.xml|The Suncatcher
    return

    Map47aArray:
        gosub Map_to_Map Map47aArray_to_Map47Array 10|Guild;Thief|1|Map47_Muspar'i.xml|Muspar'i, Great Gate Square
        gosub Map_to_Map Map47aArray_to_Map47Array 10|Guild;Thief|2|Map47_Muspar'i.xml|Muspar'i, Tuul Yamshuk Staho
        gosub Map_to_Map Map47aArray_to_Map47Array 10|Guild;Thief|3|Map47_Muspar'i.xml|Muspar'i, Golden Heights
        gosub Map_to_Map Map47aArray_to_Map47Array 10|Guild;Thief|4|Map47_Muspar'i.xml|Muspar'i, Shorka's Square
    return

    Map48Array:
        gosub Map_to_Map Map48Array_to_Map41Array 10|Athletics;HaizenCugisDesert|92|Map41_Marauders.xml|Hvaral, Dry Dock
        gosub Map_to_Map Map48Array_to_Map47Array 10|Athletics;HaizenCugisDesert|129|Map47_Muspar'i.xml|Velaka Desert
        gosub Map_to_Map Map48Array_to_Map998_5Array 500|0|67|Map998_Transports.xml|The Suncatcher
        gosub Map_to_Map Map48Array_to_Map998_5Array 500|0|68|Map998_Transports.xml|The Desert Wind
    return

    Map4aArray:
        gosub Map_to_Map Map4aArray_to_Map4Array 10|0|15|Map4_Crossing_West_Gate.xml|Grassland Path, Village Gate
        gosub Map_to_Map Map4aArray_to_Map50Array 10|0|73|Map50_Segoltha_River.xml|Tiger Clan, Grassy Trail
    return

    Map50Array:
        gosub Map_to_Map Map50Array_to_Map1Array 200|Athletics;CrossingSegoltha|8|Map1_Crossing.xml|The Crossing, Haven's End
        gosub Map_to_Map Map50Array_to_Map4aArray 200|Athletics;CrossingSegoltha|36|Map4a_Tiger_Clan.xml|Tiger Clan Home, Old Mill
        gosub Map_to_Map Map50Array_to_Map60Array 200|Athletics;CrossingSegoltha|30|Map60_STR1.xml|Southern Trade Route, Segoltha Plain
    return

    Map501Array:
        gosub Map_to_Map Map501Array_to_Map31bArray 10000|Courage;DeathWish|52|Map31b_Maelshyve's_Fortress.xml|Maelshyve's Fortress, Inner Sanctum
        gosub Map_to_Map Map501Array_to_Map66Array 10000|Courage;DeathWish|53|Map66_STR3.xml|Abyssal Nether, Maelshyve's Remnant
    return

    Map502Array:
        gosub Map_to_Map Map502Array_to_Map1Array 10|0|24|Map1_Crossing.xml|The Crossing, Landfall Jetty
    return

    Map510Array:
        gosub Map_to_Map Map510Array_to_Map1Array 10|0|82|Map1_Crossing.xml|The Crossing, Town Green Southeast
    return

    Map58Array:
        gosub Map_to_Map Map58Array_to_Map61Array 10|0|2|Map61_Leth_Deriel.xml|Fala Inisulen, Road
        gosub Map_to_Map Map58Array_to_Map150Array 300|0|52|Map150_Fang_Cove.xml|Aboard the Mammoth, Platform
    return

    Map59Array:
        gosub Map_to_Map Map59Array_to_Map61Array 10|0|12|Map61_Leth_Deriel.xml|Eik Wood, Granite Outcroppings
    return

    Map6Array:
        gosub Map_to_Map Map6Array_to_Map1Array 10|Guild;Ranger|116|Map1_Crossing.xml|Ranger's Guild, The Tree House
        gosub Map_to_Map Map6Array_to_Map1Array 10|0|23|Map1_Crossing.xml|North Gate, Gate
        gosub Map_to_Map Map6Array_to_Map4Array 10|0|114|Map4_Crossing_West_Gate.xml|Northwall Trail, Wooded Grove
        gosub Map_to_Map Map6Array_to_Map7Array 10|0|98|Map7_NTR.xml|Northern Trade Road, Open Forest
    return

    Map60Array:
        gosub Map_to_Map Map60Array_to_Map1a_4Array 10|Guild;Thief;Athletics;Crossing5thPassage|107|Map1a_Crossing_Thief.xml|Southern Trade Route, Endrus Forest
        gosub Map_to_Map Map60Array_to_Map50Array 10|0|108|Map50_Segoltha_River.xml|Fisherman's Trail, Footpath
        gosub Map_to_Map Map60Array_to_Map61Array 10|0|57|Map61_Leth_Deriel.xml|Southern Trade Route, Bosque Deriel
        gosub Map_to_Map Map60Array_to_Map998_1Array 300|0|106|Map998_Transports.xml|Hodierna's Grace
        gosub Map_to_Map Map60Array_to_Map998_1Array 300|0|124|Map998_Transports.xml|Kertigen's Honor
    return

    Map61Array:
        gosub Map_to_Map Map61Array_to_Map112Array 10|0|126|Map112_Ilaya_Taipa.xml|Old Crank's Road, Forest
        gosub Map_to_Map Map61Array_to_Map150Array 10|Subscription;Premium|236|Map150_Fang_Cove.xml|Fang Cove, Fate's Fortune Lane
        gosub Map_to_Map Map61Array_to_Map58Array 10|0|178|Map58_Acenamacra_Village.xml|Fala Inisulen, Sequoia Tunnel
        gosub Map_to_Map Map61Array_to_Map59Array 10|0|182|Map59_Boggy_Wood.xml|Eik Wood, Granite Outcroppings
        gosub Map_to_Map Map61Array_to_Map60Array 10|0|115|Map60_STR1.xml|Southern Trade Route, Bosque Deriel
        gosub Map_to_Map Map61Array_to_Map62Array 10|0|130|Map62_STR2.xml|Southern Trade Route, Esouvar Deriel
    return

    Map62Array:
        gosub Map_to_Map Map62Array_to_Map61Array 10|0|100|Map61_Leth_Deriel.xml|Southern Trade Route, Esouvar Deriel
        gosub Map_to_Map Map62Array_to_Map63Array 10|0|101|Map63_Oshu'ehhrsk_Manor.xml|Silhouette Forest, Near the Southern Trade Route
        gosub Map_to_Map Map62Array_to_Map65Array 10|Athletics;ShardUnderGondola|153|Map65_Under_the_Gondola.xml|Chasm, Vertical Pothole
        gosub Map_to_Map Map62Array_to_Map998_4Array 300|0|1|Map998_Transports.xml|Gondola, Cab North
    return

    Map62bArray:
    #no path to here
        gosub Map_to_Map Map62bArray_to_Map62Array 10|0|20|Map62_STR2.xml|Southern Trade Route, Alongside the Forest
    return

    Map63Array:
        # gosub Map_to_Map Map63Array_to_Map999Array 10|0|118|Map999_The_Ways.xml|Astral Plane, Asharshpar'i Conduit
        gosub Map_to_Map Map63Array_to_Map62Array 10|0|112|Map62_STR2.xml|Southern Trade Route, Esouvar Deriel
    return

    Map65Array:
        gosub Map_to_Map Map65Array_to_Map62Array 10|Athletics;ShardUnderGondola|44|Map62_STR2.xml|Obsidian Pass, Mountain Trail
        # gosub Map_to_Map Map65Array_to_Map62Array 60|shall we path this?|48|Map62_STR2.xml|Southern Trade Route, Alongside the Forest
        gosub Map_to_Map Map65Array_to_Map66Array 10|0|1|Map66_STR3.xml|Dragon's Spine, Astrar's Sorrow
    return

    Map66Array:
        gosub Map_to_Map Map66Array_to_Map150Array 10|Subscription;Premium|618|Map150_Fang_Cove.xml|Fang Cove, Fate's Fortune Lane
        gosub Map_to_Map Map66Array_to_Map501Array 1000000|Courage;DeathWish|682|Map501_Soul_of_Maelshyve.xml|Soul of Maelshyve, The Sowing
        gosub Map_to_Map Map66Array_to_Map65Array 10|0|317|Map65_Under_the_Gondola.xml|Dragon's Spine, Behind the Waterfall
        gosub Map_to_Map Map66Array_to_Map67Array 100|Citizenship;Shard;Time;Day|215|Map67_Shard.xml|Shard, North City Gates
        gosub Map_to_Map Map66Array_to_Map67Array 10|0|216|Map67_Shard.xml|Shard, East City Gates
        gosub Map_to_Map Map66Array_to_Map67a_2Array 10|Guild;Thief|617|Map67a_Shard_Thief.xml|Shard, Smuggler's Bridge
        gosub Map_to_Map Map66Array_to_Map68Array 80|0|3|Map68_Shard_South_Gate.xml|Derelict Road, Whistling Wood
        gosub Map_to_Map Map66Array_to_Map69Array 10|0|217|Map69_Shard_West_Gate.xml|Shard, Northwestern Shore
        gosub Map_to_Map Map66Array_to_Map998_4Array 300|0|218|Map998_Transports.xml|Gondola, Cab South
    return

    Map67Array:
        ## SHARD PORTAL ENTRANCE Zone 67 Room 455
        gosub Map_to_Map Map67Array_to_Map107Array 1|Subscription;Platinum|808|Map107_Mer'Kresh.xml|Wharf End, Mer'Kresh
        gosub Map_to_Map Map67Array_to_Map66Array 10|Citizenship;Shard;Time;Day|135|Map66_STR3.xml|Shard, North Bridge
        gosub Map_to_Map Map67Array_to_Map66Array 10|0|132|Map66_STR3.xml|Shard, East Bridge
        gosub Map_to_Map Map67Array_to_Map67a_1Array 10|Guild;Thief|136|Map67a_Shard_Thief.xml|Shard, Tunnels
        gosub Map_to_Map Map67Array_to_Map67a_1Array 10|Guild;Thief|149|Map67a_Shard_Thief.xml|Shard Tunnels
        gosub Map_to_Map Map67Array_to_Map67a_1Array 10|Guild;Thief|162|Map67a_Shard_Thief.xml|Shard Tunnels
        gosub Map_to_Map Map67Array_to_Map67a_1Array 10|Guild;Thief|163|Map67a_Shard_Thief.xml|Shard, Abandoned Building
        gosub Map_to_Map Map67Array_to_Map67a_1Array 10|Guild;Thief|380|Map67a_Shard_Thief.xml|Undershard, Tunnels
        gosub Map_to_Map Map67Array_to_Map67a_1Array 10|Guild;Thief|595|Map67a_Shard_Thief.xml|Shard, Basement
        gosub Map_to_Map Map67Array_to_Map67a_1Array 10|Guild;Thief|596|Map67a_Shard_Thief.xml|Undershard, Tunnels
        gosub Map_to_Map Map67Array_to_Map67a_2Array 10|Guild;Thief|566|Map67a_Shard_Thief.xml|Shard, Smuggler's Bridge
        gosub Map_to_Map Map67Array_to_Map68Array 10|Citizenship;Shard;Time;Day|230|Map68_Shard_South_Gate.xml|Old Ilithi Trade Route, Journey's Rest
        #this is not a good route gosub Map_to_Map Map67Array_to_Map68Array 10|0|381|Map68_Shard_South_Gate.xml|Sewer
        gosub Map_to_Map Map67Array_to_Map69Array 10|Citizenship;Shard;Time;Day|129|Map69_Shard_West_Gate.xml|Shard, West Bridge
    return

    Map67a_1Array:
        gosub Map_to_Map Map67a_1Array_to_Map67Array 10|Guild;Thief|10|Map67_Shard.xml|Shard, Crystal Lane
        gosub Map_to_Map Map67a_1Array_to_Map67Array 10|Guild;Thief|11|Map67_Shard.xml|Shard, Emerald Lane Open Market
        gosub Map_to_Map Map67a_1Array_to_Map67Array 10|Guild;Thief|12|Map67_Shard.xml|Shard, Katamba's Crescent Road
        gosub Map_to_Map Map67a_1Array_to_Map67Array 10|Guild;Thief|16|Map67_Shard.xml|Undershard, The Grey Market
        gosub Map_to_Map Map67a_1Array_to_Map67Array 10|Guild;Thief|17|Map67_Shard.xml|Shard, Grey Market
        gosub Map_to_Map Map67a_1Array_to_Map67Array 10|Guild;Thief|6|Map67_Shard.xml|Shard, Ruined Building
        gosub Map_to_Map Map67a_1Array_to_Map67Array 10|Guild;Thief|8|Map67_Shard.xml|Shard, Sunstone Street
        return
        Map67a_2Array:
        gosub Map_to_Map Map67a_2Array_to_Map66Array 10|Guild;Thief|23|Map66_STR3.xml|South Trade Route, Journey's Rest
        gosub Map_to_Map Map67a_2Array_to_Map67Array 10|Guild;Thief|19|Map67_Shard.xml|Shard, Katamba's Crescent Road
    return

    Map68Array:
        gosub Map_to_Map Map68Array_to_Map66Array 30|0|15|Map66_STR3.xml|Prairie
        gosub Map_to_Map Map68Array_to_Map66Array 64|0|215|Map66_STR3.xml|Abandoned Road
        gosub Map_to_Map Map68Array_to_Map67Array 10|Citizenship;Shard;Time;Day|1|Map67_Shard.xml|Shard, The New South Bridge
        gosub Map_to_Map Map68Array_to_Map67Array 10|Guild;Thief;Athletics;ShardSewageEntrance|188|Map67_Shard.xml|Undershard, Sewage Tunnel
        gosub Map_to_Map Map68Array_to_Map67Array 10|Athletics;ShardWalls|225|Map67_Shard.xml|The New Bridge, East Tower
        gosub Map_to_Map Map68Array_to_Map68aArray 10|0|208|Map68a_Ice_Caves.xml|Ice Caves, Cave Mouth
        gosub Map_to_Map Map68Array_to_Map68aArray 10|0|214|Map68a_Ice_Caves.xml|Whistling Wood, Fissure
        gosub Map_to_Map Map68Array_to_Map68bArray 10|0|207|Map68b_Lost_Ground.xml|Corik's Wall, Graev's Gate
    return

    Map68aArray:
        gosub Map_to_Map Map68aArray_to_Map68Array 10|0|29|Map68_Shard_South_Gate.xml|Whistling Wood, Clearing
        gosub Map_to_Map Map68aArray_to_Map68Array 10|0|30|Map68_Shard_South_Gate.xml|Whistling Wood, Narrow Path
    return

    Map68bArray:
        gosub Map_to_Map Map68bArray_to_Map68Array 10|0|44|Map68_Shard_South_Gate.xml|Blackthorn Canyon, Before the Wall
    return

    Map69Array:
        gosub Map_to_Map Map69Array_to_Map123Array 10|0|283|Map123_Himineldar_Shel.xml|Seord Kerwaith, Crystalline Gorge
        gosub Map_to_Map Map69Array_to_Map123Array 300|0|316|Map123_Himineldar_Shel.xml|Raven's Point, Gear Gate
        gosub Map_to_Map Map69Array_to_Map66Array 10|0|1|Map66_STR3.xml|Southern Trade Route, Road to Shard
        gosub Map_to_Map Map69Array_to_Map67Array 10|Citizenship;Shard;Time;Day|31|Map67_Shard.xml|Shard, West City Gates
    return

    Map7Array:
        gosub Map_to_Map Map7Array_to_Map1Array 10|0|349|Map1_Crossing.xml|The Crossing, Northeast Customs
        gosub Map_to_Map Map7Array_to_Map1Array 10|Athletics;CrossingWall|641|Map1_Crossing.xml|Crossing, Northeast Gate Battlements
        gosub Map_to_Map Map7Array_to_Map10Array 10|0|396|Map10_Abandoned_Mine_Lairocott.xml|Lairocott Brach, Entrance
        gosub Map_to_Map Map7Array_to_Map11Array 10|0|394|Map11_Vipers_Rock_Guardians.xml|Wilderness, Overgrown Path
        gosub Map_to_Map Map7Array_to_Map12aArray 10|0|437|Map12a_Misenseor_Abbey.xml|Dense Copse
        gosub Map_to_Map Map7Array_to_Map13Array 10|0|147|Map13_Dirge.xml|Lava Fields, Narrow Trace
        gosub Map_to_Map Map7Array_to_Map14bArray 10|0|253|Map14b_Greater_Fist.xml|Greater Fist Footpath, Large Boulder
        gosub Map_to_Map Map7Array_to_Map14cArray 10|0|197|Map14c_Faldesu.xml|Faldesu River, South Bank
        gosub Map_to_Map Map7Array_to_Map6Array 10|0|347|Map6_Crossing_North_Gate.xml|Northwall Trail, Open Forest
        gosub Map_to_Map Map7Array_to_Map7aArray 10|0|350|Map7a_Vineyard.xml|Northeast Vineyard, Farmhouse
        gosub Map_to_Map Map7Array_to_Map7aArray 10|0|436|Map7a_Vineyard.xml|Baearholt's Farmhold
        gosub Map_to_Map Map7Array_to_Map7cArray 10|0|794|Map7c_DiSilveron.xml|DiSilveron, Front Gate
        gosub Map_to_Map Map7Array_to_Map8Array 10|0|348|Map8_Crossing_East_Gate.xml|Outside East Wall, Footpath
        gosub Map_to_Map Map7Array_to_Map998_2Array 300|0|640|Map998_Transports.xml|Her Opulence
        gosub Map_to_Map Map7Array_to_Map998_2Array 300|0|787|Map998_Transports.xml|His Daring Exploit
        gosub Map_to_Map Map7Array_to_Map9bArray 10|0|397|Map9b_Sorrow's_Reach.xml|Foothills, Abandoned Road
    return

    Map7aArray:
        gosub Map_to_Map Map7aArray_to_Map7Array 10|0|15|Map7_NTR.xml|Northern Trade Road, Farmlands
        gosub Map_to_Map Map7aArray_to_Map7Array 10|0|65|Map7_NTR.xml|Northern Trade Road, Grasslands
    return

    Map7cArray:
        gosub Map_to_Map Map7cArray_to_Map7Array 10|0|1|Map7_NTR.xml|Northern Trade Road, Farmlands
    return

    Map8Array:
        # gosub Map_to_Map Map8Array_to_Map1Array 10|0|124|Map1_Crossing.xml|Crossing, East Gate Battlements
        # gosub Map_to_Map Map8Array_to_Map1Array 10|0|125|Map1_Crossing.xml|Crossing, East Wall Battlements
        # gosub Map_to_Map Map8Array_to_Map1Array 10|0|126|Map1_Crossing.xml|Crossing, East Wall Battlements
        gosub Map_to_Map Map8Array_to_Map1Array 10|0|43|Map1_Crossing.xml|The Crossing, Eastern Gate
        gosub Map_to_Map Map8Array_to_Map7Array 10|0|53|Map7_NTR.xml|Northeast Wilds, Outside Northeast Gate
        gosub Map_to_Map Map8Array_to_Map8aArray 10|0|70|Map8a_Lost_Crossing.xml|Observatory, Foyer
    return

    Map8aArray:
        gosub Map_to_Map Map8aArray_to_Map8Array 10|0|15|Map8_Crossing_East_Gate.xml|Observatory, First Level
    return

    Map90Array:
        ## RATHA PORTAL ENTRANCE Zone 90 Room 468
        gosub Map_to_Map Map90Array_to_Map40Array 1|Subscription;Platinum|876|Map40_Langenfirth_to_Therenborough.xml|Outside the Circle, The Ironwoods
        gosub Map_to_Map Map90Array_to_Map150Array 300|0|835|Map150_Fang_Cove.xml|Aboard the Mammoth, Platform
        gosub Map_to_Map Map90Array_to_Map150Array 10|Subscription;Premium|836|Map150_Fang_Cove.xml|Fang Cove, Fate's Fortune Lane
        gosub Map_to_Map Map90Array_to_Map90aArray 10|0|228|Map90a_Sand_Sprites_Ochre_La'heke.xml|Ratha, Rocky Shore
        gosub Map_to_Map Map90Array_to_Map90dArray 10|Moons;Up|628|Map90d_Taisgath.xml|Crescent Cove, Shrine to Phelim
        gosub Map_to_Map Map90Array_to_Map92Array 10|0|663|Map92_Ratha_NW.xml|Ratha, Outside Sur'oson Gate
        gosub Map_to_Map Map90Array_to_Map95Array 10|0|662|Map95_Ratha_NE.xml|Reshalia, Coastal Road
        gosub Map_to_Map Map95Array_to_Map998_8Array 500|0|NEEDS NODE ON MAP|Map998_Transports.xml|The Halasa Selhin, Main Deck
    return

    Map90aArray:
        gosub Map_to_Map Map90aArray_to_Map90Array 10|0|1|Map90_Ratha.xml|Ratha, Port Walk
    return

    Map90dArray:
        gosub Map_to_Map Map90dArray_to_Map90Array 10|0|63|Map90_Ratha.xml|Phelim's Temple, Planetarium
    return

    Map92Array:
        gosub Map_to_Map Map92Array_to_Map90Array 10|0|1|Map90_Ratha.xml|Shh'o'kumu Terrace, Sur'oson Gate
    return

    Map95Array:
        gosub Map_to_Map Map95Array_to_Map90Array 10|0|1|Map90_Ratha.xml|Shh'o'kumu Terrace, Por'oson Gate
        gosub Map_to_Map Map95Array_to_Map998_8Array 500|0|245|Map998_Transports.xml|The Halasa Selhin, Main Deck
    return

    Map98Array:
        gosub Map_to_Map Map98Array_to_Map98aArray 10|0|36|Map98a_Sea_Caves.xml|Sea Caves, Tunnel
        gosub Map_to_Map Map98Array_to_Map99Array 10|0|86|Map99_Aesry_Surlaenis'a.xml|Aesry Surlaenis'a, Beneath the Prayer Gate
        gosub Map_to_Map Map98Array_to_Map998_7Array 500|0|148|Map998_Transports.xml|Lybadel, Main Deck
        gosub Map_to_Map Map98Array_to_Map998_8Array 500|0|338|Map998_Transports.xml|The Halasa Selhin, Main Deck
    return

    Map98aArray:
        gosub Map_to_Map Map98aArray_to_Map98Array 10|0|109|Map98_Road_to_Aesry.xml|Ocean, Near the Cove
        gosub Map_to_Map Map98aArray_to_Map98Array 10|0|97|Map98_Road_to_Aesry.xml|Aesry Surlaenis'a, Cliff Path
    return

    Map99Array:
        ## AESRY PORTAL ENTRANCE Zone 99 Room 115
        gosub Map_to_Map Map99Array_to_Map67Array 1|Subscription;Platinum|463|Map67_Shard.xml|First Bank of Ilithi, Exchange Vault
        gosub Map_to_Map Map99Array_to_Map150Array 10|Subscription;Premium|392|Map150_Fang_Cove.xml|Fang Cove, Fate's Fortune Lane
        gosub Map_to_Map Map99Array_to_Map98Array 10|0|390|Map98_Road_to_Aesry.xml|Aesry Surlaenis'a, Eluned Prayer Gate
    return

    Map998_1Array:
        gosub Map_to_Map Map998_1Array_to_Map1Array 100|0|45|Map1_Crossing.xml|The Crossing, Alfren's Ferry
        gosub Map_to_Map Map998_1Array_to_Map60Array 100|0|44|Map60_STR1.xml|Southern Trade Route, Segoltha South Bank
        return
        Map998_2Array:
        gosub Map_to_Map Map998_2Array_to_Map30Array 100|0|36|Map30_Riverhaven.xml|Riverhaven, Ferry Dock
        gosub Map_to_Map Map998_2Array_to_Map7Array 100|0|35|Map7_NTR.xml|North Road, Ferry
        return
        Map998_3Array:
        gosub Map_to_Map Map998_3Array_to_Map30Array 500|0|47|Map30_Riverhaven.xml|Riverhaven, Pier
        gosub Map_to_Map Map998_3Array_to_Map40Array 500|0|48|Map40_Langenfirth_to_Therenborough.xml|Langenfirth, Wharf
        return
        Map998_4Array:
        gosub Map_to_Map Map998_4Array_to_Map62Array 100|0|37|Map62_STR2.xml|Obsidian Pass, Platform
        gosub Map_to_Map Map998_4Array_to_Map66Array 100|0|27|Map66_STR3.xml|Obsidian Pass, Platform
        return
        Map998_5Array:
        gosub Map_to_Map Map998_5Array_to_Map41Array 500|0|50|Map41_Marauders.xml|Hvaral, Dry Dock
        gosub Map_to_Map Map998_5Array_to_Map47Array 500|0|41|Map47_Muspar'i.xml|Outside Muspar'i, Barge Platform
        gosub Map_to_Map Map998_5Array_to_Map48Array 500|0|51|Map48_Haizen_Cugis.xml|Velaka, Desert Oasis
        gosub Map_to_Map Map998_5Array_to_Map48Array 500|0|53|Map48_Haizen_Cugis.xml|Velaka, Desert Oasis
        return
        Map998_6Array:
        gosub Map_to_Map Map998_6Array_to_Map90Array 108000|0|33|Map90_Ratha.xml|Neh Dock, Port of Ratha
        gosub Map_to_Map Map998_6Array_to_Map30Array 108000|0|60|Map30_Riverhaven.xml|Riverhaven, East Pier
        return
        Map998_7Array:
        gosub Map_to_Map Map998_7Array_to_Map30Array 108000|0|7|Map30_Riverhaven.xml|Riverhaven, East Pier
        gosub Map_to_Map Map998_7Array_to_Map98Array 108000|0|8|Map98_Road_To_Aesry.xml|Aesry Surlaenis'a, Shadaer
        return
        Map998_8Array:
        gosub Map_to_Map Map998_8Array_to_Map90Array 500|0|24|Map90_Ratha.xml|Uaro Dock, Port of Ratha
        gosub Map_to_Map Map998_8Array_to_Map95Array 500|0|15|Map95_Ratha_NE.xml|Pokekehekepi, Beachhead
        gosub Map_to_Map Map998_8Array_to_Map98Array 500|0|10|Map98_Road_To_Aesry.xml|Harbor Docks, Aesry Surlaenis'a
        return
        Map998_9Array:
        gosub Map_to_Map Map998_9Array_to_Map1Array 108000|0|21|Map1_Crossing.xml|The Crossing Docks, South End
        gosub Map_to_Map Map998_9Array_to_Map90Array 108000|0|23|Map90_Ratha.xml|Neh Dock, Port of Ratha
    return

    Map99dArray:
        gosub Map_to_Map Map99dArray_to_Map99Array 10|0|18|Map99_Aesry_Town.xml|Aesry Surlaenis'a
    return

    Map9bArray:
        gosub Map_to_Map Map9bArray_to_Map7Array 10|0|9|Map7_NTR.xml|Foothills, Stony Incline
    return

    MapTF1Array:
        gosub Map_to_Map MapTF1Array_to_Map1Array 10|Game;DRF|23|Map1_Crossing.xml|The Crossing, Town Green Southwest
        gosub Map_to_Map MapTF1Array_to_Map107Array 10|Game;DRF|22|Map107_MerKresh.xml|Wharf End, Mer'Kresh
        gosub Map_to_Map MapTF1Array_to_Map108Array 10|Game;DRF|26|Map108_M'Riss.xml|Belarritaco Bay, The Galley Dock
        gosub Map_to_Map MapTF1Array_to_Map30Array 10|Game;DRF|24|Map30_Riverhaven.xml|Riverhaven, Town Square
        gosub Map_to_Map MapTF1Array_to_Map40Array 10|Game;DRF|25|Map40_Langenfirth_to_Theren_Gate.xml|North Road, Beech Grove
    return

###########################
####Pather Loading start###
###########################
Load:
    # add in handling for starting in a named "Subzone"
    var Starting_Zone Map$zoneidArray
    var Ending_Zone Map%1Array
    if ("%Ending_Zone" = "%Starting_Zone") then {
        echo At destination
        exit
    }
    if ("%Ending_Zone" = "MapArray") then {
        goto NODESTINATION
    }
    if ("%Starting_Zone" = "") then {
        put #mapper reset
        pause
        var Starting_Zone Map$zoneidArray
        if ("%Starting_Zone" = "") then {
            echo unknown starting map
            exit
        }
    }

    var Map_to_Map_Maps
    var Map_to_Map_Vars
    var Map_to_Map_Paths
    var Map_to_Map_Nodes
    var Maps |
    var Arc_Queue |
    var i_Arc_Queue 0

    var Path_Map
    var Path_Part
    var Path_Weight
    var Path_Paths
    var Path_Arcs
    var Path_Names
    var Path_Rooms

    var Current_Zone %Starting_Zone
    var Link%Current_Zone 0|LinkMap0Array
    var LinkMap0Array 0|0
    var AthleticsChecks ShardWalls|ShardSewageEntrance|CrossingWall|ShardUnderGondola|Crossing5thPassage|HaizenCugisDesert|CrossingSegoltha|RiverhavenFaldesu|RossmanJantspyreNorth|RossmanJantspyreSouth|BoarArchersFord

    var Guild
    var Citizenship
    var Subscription
    var Game
    var Courage
    var Moons

    if !def(subscription) then gosub SUBSCRIPTION_CHECK
    var Subscription $subscription
    if !def(citizenship) then gosub CITIZENSHIP
    var Citizenship $citizenship

    if !def(travel.RossmanJantspyreNorth) then var RossmanJantspyreNorth 200
    else var RossmanJantspyreNorth $travel.RossmanJantspyreNorth
    if !def(travel.RossmanJantspyreSouth) then var RossmanJantspyreSouth 90
    else var RossmanJantspyreSouth $travel.RossmanJantspyreSouth
    if !def(travel.RiverhavenFaldesu) then var RiverhavenFaldesu 190
    else var RiverhavenFaldesu $travel.RiverhavenFaldesu
    if !def(travel.CrossingSegoltha) then var CrossingSegoltha 550
    else var CrossingSegoltha $travel.CrossingSegoltha
    if !def(travel.ShardUnderGondola) then var ShardUnderGondola 550
    else var ShardUnderGondola $travel.ShardUnderGondola
    if !def(travel.Crossing5thPassage) then var Crossing5thPassage 50
    else var Crossing5thPassage $travel.Crossing5thPassage
    if !def(travel.HaizenCugisDesert) then var HaizenCugisDesert 800
    else var HaizenCugisDesert $travel.HaizenCugisDesert
    if !def(travel.ShardWalls) then var ShardWalls 350
    else var ShardWalls $travel.ShardWalls
    if !def(travel.ShardSewageEntrance) then var ShardSewageEntrance 300
    else var ShardSewageEntrance $travel.ShardSewageEntrance
    if !def(travel.CrossingWall) then var CrossingWall 350
    else var CrossingWall $travel.CrossingWall
    if !def(travel.BoarArchersFord) then var BoarArchersFord 160
    else var BoarArchersFord $travel.BoarArchersFord

    if (($joined == 1) && ($travel.GroupShortCutsAnyway == False)) then {
        var ShardWalls 2000
        var ShardSewageEntrance 2000
        var CrossingWall 2000
        var ShardUnderGondola 2000
        var Crossing5thPassage 2000
        var HaizenCugisDesert 2000
        var CrossingSegoltha 2000
        var RiverhavenFaldesu 2000
        var RossmanJantspyreNorth 2000
        var RossmanJantspyreSouth 2000
        var BoarArchersFord 2000

        var Citizenship None
        var Subscription Basic

        if (%verbose) then gosub ECHO You are in a group!  You will NOT be taking the gravy short cuts today!
      }
    
return
#############################################################
ARRIVED:
  if_2 then {
    shift
    gosub AUTOMOVE %0
  }
  ### Backup in case Automapper majorly screws up - Double check to make sure it's in the correct Zone ID
  ### If not at your destination will restart script from beginning - Only support for main cities for now
  if ((matchre("%destination", "\b(?:cros?s?i?n?g?s?|xing?)")) && ("$zoneid" != "1")) then goto START
  if ((matchre("%destination", "\b(?:rive?r?h?a?v?e?n?|have?n?)")) && ("$zoneid" != "30")) then goto START
  if ((matchre("%destination", "\b(?:shar?d?)")) && ("$zoneid" != "67")) then goto START
  if ((matchre("%destination", "\b(?:leth)")) && ("$zoneid" != "61")) then goto START
  if ((matchre("%destination", "\b(?:hib?a?r?n?h?v?i?d?a?r?|out?e?r?)")) && ("$zoneid" != "116")) then goto START
  if ((matchre("%destination", "\b(?:theren?)")) && ("$zoneid" != "42")) then goto START
  if ((matchre("%destination", "\b(?:boar?c?l?a?n?)")) && ("$zoneid" != "127")) then goto START
  put #echo %color <~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~>
  put #echo %color {  AMAZING!!                     }
  put #echo %color {                                }
  put #echo %color {      | \        ' .*) .'*      }
  put #echo %color {      |\          .(' *) ' .    }
  put #echo %color {      |(*\      .*(// .*) .     }
  put #echo %color {      |___\       // (. '*      }
  put #echo %color {      (((''\     // '  * .      }
  put #echo %color {      ((c'7')   /\)             }
  put #echo %color {      ((((^))  /  \             }
  put #echo %color {    .-')))(((-'   /             }
  put #echo %color {       (((()) __/'              }
  put #echo %color {        )))( |                  }
  put #echo %color {         (()                    }
  put #echo %color {          ))                    }
  put #echo %color {                                }
  put #echo %color <~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~>
  put #parse YOU ARRIVED!
  put #parse REACHED YOUR DESTINATION
  eval destination toupper("%destination")
  gosub ECHO WOW! YOU ARRIVED AT YOUR DESTINATION: %destination in %t seconds!  That's FAST!|STARTED FROM: %starting
  put #echo >Log #1ad1ff * TRAVEL ARRIVAL: $zonename (Map: $zoneid | Room: $roomid)
  put #class arrive off
  exit
#####################################################################################
## ENGINE
STOP_INVIS:
  pause %infiniteLoopProtection
  if ("$guild" == "Necromancer") then gosub PUT release EOTB
  if ("$guild" == "Thief") then gosub PUT khri stop silence vanish
  if ("$guild" == "Ranger") then gosub PUT release BLEND
  if (matchre("$guild", "(?:Moon Mage|Moon)")) then {
    gosub PUT release RF
    gosub PUT release SOV
  }
  pause %command_pause
  if ($invisible == 1) then goto STOP_INVIS
return
####
####  RIVER TRAVEL  ###
SEGOLTHA_NORTH:
  if (matchre("$roomid", "\b(?:24|25|26|27|28|29|31|42|43|44|45|46)\b")) then gosub AUTOMOVE 23
  if (%verbose) then gosub ECHO Swimming the Segoltha - Heading NORTH
  if (matchre("$roomid", "\b(7|6|5)\b")) then {
    gosub MOVE east
    goto SEGOLTHA_NORTH
  }
  if (matchre("$roomid", "\b(35|34|33|32)\b")) then {
    gosub AUTOMOVE 3
    return
  }
  if (matchre("$roomid", "\b(5|4|3|2|1)\b")) then {
    gosub MOVE Map1_Crossing.xml
    return
  }
 if (matchre("$roomid", "\b(7|6|5)\b")) then {
    gosub MOVE east
    goto SEGOLTHA_NORTH
  }
  if ($north) then gosub MOVE north
  goto SEGOLTHA_NORTH
SEGOLTHA_SOUTH:
  if ("$zoneid" == "1") then gosub AUTOMOVE segoltha
  if (matchre("$roomid", "\b(?:24|25|26|27|28|29)\b")) then {
    gosub AUTOMOVE south
    return
  }
  if (%verbose) then gosub ECHO Swimming the Segoltha - Heading SOUTH
  if (matchre("$roomid", "\b(1|2|3|4|5|6)\b")) then {
    gosub AUTOMOVE 7
    goto SEGOLTHA_SOUTH
  }
  if (($roomid == 0) && ($south)) then {
    gosub MOVE south
    goto SEGOLTHA_SOUTH
  }
  if ($south) then gosub MOVE south
  if ((!$southwest) && (!$southeast) && (!$south)) then {
    gosub AUTOMOVE south
    return
  }
  goto SEGOLTHA_SOUTH
FALDESU_NORTH:
  if (%verbose) then gosub ECHO Swimming the Faldesu - Heading NORTH
  gosub MOVEALLTHEWAY north
  if ($northwest) then {
    gosub MOVE northwest
    gosub MOVEALLTHEWAY northeast
  }
  if ((!$northwest) && (!$northeast) && (!$north)) then {
    gosub MOVE climb stone bridge
    put #mapper reset
    pause %command_pause
    return
  }
  goto FALDESU_NORTH
FALDESU_SOUTH:
  if (%verbose) then gosub ECHO Swimming the Faldesu - Heading SOUTH
  gosub MOVEALLTHEWAY south
  if ($south) then {
    gosub MOVE south
    goto FALDESU_SOUTH
  }
  if ($southwest) then {
    gosub MOVE southwest
    gosub MOVEALLTHEWAY southeast
  }
  if ((!$southwest) && (!$southeast) && (!$south)) then
  {
    gosub MOVE climb stone bridge
    put #mapper reset
    pause %command_pause
    return
  }
  goto FALDESU_SOUTH
####
####  Keeps moving in a direction until it is no longer a portal option  ####
MOVEALLTHEWAY:
  var direction $1
MovingAllTheWay:
  if ($%direction) then gosub MOVE %direction
  if ($%direction) then goto MovingAllTheWay
  return
####
####  Do you have a P3 passport?  ###
PASSPORT_CHECK:
  matchre YES_PASSPORT ^You tap
  matchre PASSPORT_CHECK2 ^What were you|^I could not
  put tap my passport
  matchwait 5
PASSPORT_CHECK2:
  gosub PUT look in my portal
  matchre YES_PASSPORT ^You tap
  matchre NO_PASSPORT ^What were you|^I could not
  send tap my passport in my portal
  matchwait 5
NO_PASSPORT:
  var passport 0
  gosub ECHO NO MUSPARI PASSPORT
  return
YES_PASSPORT:
  var passport 1
  if (%verbose) then gosub ECHO MUSPARI PASSPORT FOUND!
  return

PASSPORT_GET:
  if (%verbose) then gosub ECHO NO PASSPORT FOUND|GOING TO GET ONE
  if ("$zoneid" == "40") then gosub AUTOMOVE theren
  if ("$zoneid" == "42") then {
    gosub AUTOMOVE passport
    gosub STOWING
    gosub PUT ask lic for passport
    gosub PUT ask lic for passport
    gosub STOWING
    gosub AUTOMOVE gate
    return
  }
  goto NOPASSPORT
PASSPORT:
  gosub STOWING
  matchre RETURN ^You get|^You are already
  matchre PASSPORT2 ^What were you|^I could not
  send get my passport
  matchwait 5
PASSPORT2:
  gosub PUT look in my portal
  matchre RETURN ^You get|^You are already
  matchre NOPASSPORT ^What were you|^I could not
  send get my passport from my portal
  matchwait 5
NOPASSPORT:
  gosub ECHO You don't have a Muspari Passport!|Go back to Therenborough to get one.
  goto ARRIVED
####
####  The public transport section  ####
### STANDALONE FERRY CHECK TO MAKE SURE WE AREN'T IN A FERRY (USED FOR RANDOMMOVE SUB IF SCRIPT GETS LOST IN A ROOMID == 0)
FERRY_CHECK:
  var disembarkMovement dock
  action (ferry_check) on
  delay %infiniteLoopProtection
  if (matchre("$roomname", "%ferryRoomTitles")) then goto ONFERRY
  if (matchre("$roomobjs", "the beach")) then goto FERRY_DISEMBARK
  if (matchre("$roomobjs", "a ladder")) then goto FERRY_DISEMBARK
  action (ferry_check) off
  return
### BEGINNING FERRY CHECK LOGIC - CHECK WHICH LOCATION WE ARE IN (AND/OR WHICH DIRECTION WE ARE GOING) TO TAKE CORRECT FERRY
#han: delete join, make it all ferry
JOINLOGIC:
FERRYLOGIC:
  if (matchre("$roomname", "%ferryRoomTitles")) then goto ONFERRY
  gosub INFO_CHECK
#what is the point of this line?
  if (matchre("$zoneid", "\b(?:1|7|30|35|60|40|41|47|48|90|113|106|107|108|150)\b")) then goto FERRY
###  MAIN FERRY LOGIC - CHECK FOR AND WAIT TO BOARD FERRY  ####
###  Also LOGIC FOR GETTING ON THE MAMMOTHS / WARSHIPS
FERRY:
  var OnFerry 0
  var disembarkMovement dock
  action (ferry_check) on
  if ((matchre("$roomname", "%ferryRoomTitles")) || (%OnFerry == 1)) then goto ONFERRY
  if (%verbose) then gosub ECHO Checking for a Transport...
  if ($invisible) then gosub STOP_INVIS
  if (matchre("$roomobjs", "(barge|Northern Pride|Desert Wind|Suncatcher|Theren's Star)")) then gosub MOVE go barge
  if (matchre("$roomobjs", "(ferry|Hodierna's Grace|Kertigen's Honor|Evening Star|Damaris. Kiss|Her Opulence|His Daring Exploit)")) then gosub MOVE go ferry
  if (matchre("$roomobjs", "(skiff|galley|Night Sky|Gondola|Riverhawk|Imperial Glory|Jolas|Skirr'lolasu|Kree'la|Selhin|Halasa|Degan)")) then gosub MOVE go $1
  if (matchre("$roomobjs", "(warship|balloon|airship|dirigible|mammoth)")) then gosub MOVE join $1
#han: still working here


  if (matchre("$roomobjs", "dirigible")) then put join dirigible;join dirigible
  if (matchre("$roomobjs", "balloon")) then put join balloon;join balloon
  if (matchre("$roomobjs", "wizened ranger")) then put join wizened ranger;join wizened ranger
  if ("$zoneid" == "150") then {
    if ("%detour" == "fang") then goto ARRIVED
    if ((%ToRatha == 1) && (matchre("$roomobjs", "massive sea mammoth"))) then put join sea mammoth
    if ((%ToRatha == 0) && (matchre("$roomobjs", "tall sea mammoth"))) then put join tall mammoth
    if (("%detour" == "hara") && (matchre("$roomobjs", "warship"))) then put join warship
  }



  delay %infiniteLoopProtection
  if (matchre("$roomname", "%ferryRoomTitles")) then goto ONFERRY
  if ($hidden == 0) then gosub PUT hide
# waiting for ferry 60 seconds or arrival
  if (%verbose) then gosub ECHO Waiting for a transport..
  eval ferryWaitTimeOut $unixtime + 60
  waiteval ((matchre("$roomobjs", "skiff|galley|Night Sky|Gondola|Riverhawk|Imperial Glory|Jolas|Skirr'lolasu|Kree'la|Selhin|Halasa|Degan|barge|Northern Pride|Desert Wind|Suncatcher|Theren's Star|ferry|Hodierna's Grace|Kertigen's Honor|Evening Star|Damaris. Kiss|Her Opulence|His Daring Exploit|warship|balloon|airship|dirigible|mammoth")) || ($unixtime >= %ferryWaitTimeOut))
  goto FERRY
## RIDING ON A FERRY - WE SHOULD ONLY BE HERE WHEN WE ARE RIDING ON A FERRY - THIS IS FOR THE 'NPC TRANSPORTS'
ONFERRY:
  if (%OffRide == 1) then goto FERRY_DISEMBARK
  var OffRide 0
  var disembarkMovement dock
  action (ferry_disembark) on
  if (matchre("$roomname", "%ferryRoomTitles")) then var transportName $1
  gosub ECHO Riding on Public Transport!|%transportName
#### gondola is the only one where you can't just chill in the same room
  if (matchre("$roomname", "Gondola")) then {
    if (($north) && (matchre("%destination", "\b(?:acen?e?m?a?c?r?a?|cros?s?i?n?g?s?|xing?|knif?e?c?l?a?n?|tige?r?c?l?a?n?|dirg?e?|arth?e?d?a?l?e?|haiz?e?n?|oasis?|kaer?n?a?|ilay?a?t?a?i?p?|illa?y?a?t?a?i?p?a?|taipa|leth?d?e?r?i?e?l?|acen?a?m?a?c?r?a?|vipe?r?s?|guar?d?i?a?n?s?|leuc?r?o?s?|malod?o?r?o?u?s?|bucc?a?|dokt?|sorr?o?w?s?|misens?e?o?r?|beis?s?w?u?r?m?s?|ston?e?c?l?a?n?|bone?w?o?l?f?|germ?i?s?h?d?i?n?|alfr?e?n?s?|cara?v?a?n?s?a?r?y?|rive?r?h?a?v?e?n?|have?n?|ross?m?a?n?s?|ther?e?n?b?o?r?o?u?g?h?|lang?e?n?f?i?r?t?h?|el'?b?a?i?n?s?|elb?a?i?n?s?|raka?s?h?|thro?n?e?|musp?a?r?i?|forn?s?t?e?d?|hvar?a?l?|zaul?f?u?n?g?|mri?s?s?|merk?r?e?s?h?|kre?s?h?|har?a?j?a?a?l?|rath?a?)\b"))) then {
      var direction north
      gosub MOVE %direction
      if (%verbose) then gosub ECHO ON GONDOLA! - Heading %direction
    }
    if (($south) && (matchre("%destination", "\b(?:shar?d?|grani?t?e?|garg?o?y?l?e?|spir?e?|horse?c?l?a?n?|fayr?i?n?s?|steel?c?l?a?w?|cori?k?s?|ada?n?f?|ylo?n?o?|wyve?r?n?|aing?h?a?z?a?l?|rave?n?s?|hib?a?r?n?h?v?i?d?a?r?|out?e?r?|inne?r?|boar?c?l?a?n?|aes?r?y?|sur?l?a?e?n?i?s?|fan?g?|cov?e?)\b"))) then {
      var direction south
    }
    if ($%direction) then {
      gosub MOVE %direction
      if (%verbose) then gosub ECHO ON GONDOLA! - Heading %direction
    }
  }
  if ($hidden == 0) then gosub PUT hide
#check for disembark every 60 seconds or when action fires
  eval ferryWaitTimeOut $unixtime + 60
  waiteval ((%OffRide == 1) || ($unixtime >= %ferryWaitTimeOut))
  if (("$guild" == "Necromancer") && (($spellROC == 0) || ($spellEOTB == 0))) then gosub NECRO_PREP
  if (%OffRide == 1) then goto FERRY_DISEMBARK
  goto ONFERRY
### GETTING OFF THE FERRY 
FERRY_DISEMBARK:
  action (ferry_disembark) off
  action (ferry_check) off
  if ($hidden == 1) then gosub PUT unhide
  if ($standing == 0) then gosub STAND
# did you auto-disembark?
  if (!matchre("$roomname", "%ferryRoomTitles")) then return
  if (matchre("$roomname", "Rocky Path")) then {
    gosub MOVE go beach
    return
  }
  if (matchre("$roomname", "Jolas")) then {
    if (matchre("$roomobjs", "Sumilo")) then gosub MOVE go dock
    if (matchre("$roomobjs", "Wharf")) then gosub MOVE go end
    return
  }
## HALFWAY CHECK FOR THE MUSPARI/OASIS TRANSPORT
  if ((matchre("%destination", "\b(?:haiz?e?n?|oasis?)\b")) && (matchre("$roomobjs", "oasis"))) then {
    gosub MOVE go oasis
    return
  }
## you'll stay on if you'r headed to muspari or havral and you're at the oasis
  if ((matchre("%destination", "\b(?:muspari|havral)\b")) && (matchre("$roomobjs", "oasis"))) then {
    var OffRide 0
    goto ONFERRY
  }
  gosub MOVE go %disembarkMovement
  if (matchre("$roomname", "%ferryRoomTitles")) then goto FERRY_DISEMBARK
  return
####   END OF FERRY LOGIC  ####
####  COIN LOGIC - GET MONEY FROM THE BANK TO TAKE FERRIES
####  ONLY REACHES THIS SUB IF WE DON'T HAVE ENOUGH MONEY ON HAND 
####  Get's here _always_ via goto, return is via goto %label
NOCOIN:
  gosub clear
  gosub ECHO You don't have enough coins to travel - you vagrant!|Trying to get some coins from the nearest bank!!!
  if ("$zoneid" == "1") then gosub COINWITHDRAW 120 kronars
  if ("$zoneid" == "60") then gosub AUTOMOVE leth
  if ("$zoneid" == "60") then {
    gosub AUTOMOVE leth
    gosub COINWITHDRAW 120 Kronars
    gosub AUTOMOVE Map60
  }
  if ("$zoneid" == "61") then gosub COINWITHDRAW 120 kronars
  if ("$zoneid" == "30") then gosub COINWITHDRAW 140 lirums
  if ("$zoneid" == "35") then gosub COINWITHDRAW 140 lirums
  if ("$zoneid" == "7") then {
    gosub MOVE Map1_Crossing.xmling
    gosub COINWITHDRAW 200 lirums
    gosub AUTOMOVE negate
  }
  if ("$zoneid" == "40") then {
    gosub AUTOMOVE therenborough
    if (matchre("%detour", "(mriss|merk|hara)")) then gosub COINWITHDRAW 10000 lirums
    else gosub COINWITHDRAW %BoarNeeded lirums
    gosub AUTOMOVE Map40
  }
  #if on ferry map on the ain side move to ain
  if (("$zoneid" == "113") && (matchre("$roomid", "\b(?:4|8|9|10)\b"))) then gosub AUTOMOVE Map114
  #if on ferry map on the hib side move to hib
  if (("$zoneid" == "113") && (matchre("$roomid", "\b(?:6|7)\b"))) then gosub AUTOMOVE Map123
  #if on ferry map on the ilaya side move to ilaya
  if (("$zoneid" == "113") && (matchre("$roomid", "\b(?:1|5)\b"))) then gosub AUTOMOVE Map112
  if ("$zoneid" == "114") then gosub COINWITHDRAW 120 dokoras
  if ("$zoneid" == "123") then gosub AUTOMOVE hibar
  if (("$zoneid" == "116") && (matchre("%detour", "(rossman|lang|theren|rakash|muspari|fornsted|el'bain|mriss|merk|hara)"))) then gosub COINWITHDRAW %TherenCoin dokoras
  if (("$zoneid" == "116") && (!matchre("%detour", "(rossman|lang|theren|rakash|muspari|fornsted|el'bain|mriss|merk|hara)"))) then gosub COINWITHDRAW 120 dokoras
  if ("$zoneid" == "112") then gosub COINWITHDRAW 120 dokoras
  if (("$zoneid" == "67") && ("%detour" == "aesry") && ("$game" == "DR")) then gosub COINWITHDRAW 10000 dokoras
  if (("$zoneid" == "67") && ("%detour" == "aesry") && ("$game" == "DRF")) then {
    gosub COINWITHDRAW 500 lirums
    gosub AUTOMOVE exchange
    if ($invisible == 1) then gosub STOP_INVIS
    gosub LIRUMS
  }
  if (("$zoneid" == "67") && (!matchre("%detour", "(rossman|lang|theren|rakash|muspari|fornsted|el'bain|mriss|merk|hara|cross|river|haven|arthe|kaerna|stone|sorrow|throne|hvaral)"))) then {
    gosub COINWITHDRAW 500 dokoras
    gosub AUTOMOVE exchange
    gosub PUT exchang 50 copper dok to kro
    if (matchre("%detour", "(rossman|lang|theren|rakash|muspari|fornsted|el'bain|mriss|merk|hara|river|haven|arthe|kaerna|stone|sorrow|throne|hvaral)")) then gosub PUT exchang 250 copper dok to lir
  }
  if ("$zoneid" == "99") then gosub COINWITHDRAW 10000 lirums
  if ("$zoneid" == "107") then gosub COINWITHDRAW 140 lirums
  if ("$zoneid" == "108") then {
    gosub ECHO YOU ARE ON MRISS WITH NO COINS!  YOU NEED TO FIND A FRIEND FOR HELP!|OR KILL SOME STUFF AND SELL HIDES / GEMS!
    exit
  }
  gosub INFO_CHECK
  if (("%currencyneeded" == "%%currencyNeeded")) then goto COINQUIT
  put #echo >Log #ffff4d Withdrew ferry money to ride from $zonename
  if (%verbose) then gosub ECHO YOU HAD MONEY IN THE BANK, LET'S TRY THIS AGAIN!
  goto %label
COIN_CONTINUE:
  put #echo >Log #ffff4d Withdrew ferry money to ride from $zonename
  if (%verbose) then gosub ECHO YOU EXCHANGED SOME MONIES, LET'S TRY THIS AGAIN!
  goto %label
COINQUIT:
  if (%verbose) then gosub ECHO YOU DIDN'T HAVE ENOUGH MONEY IN THE BANK TO RIDE PUBLIC TRANSPORT.|EITHER GET MORE ATHLETICS, OR MORE MONEY, FKING NOOB!
  put #echo >Log #ff0000 Travel Script Aborted! No money in bank to ride ferry in $zonename!
  put #parse OUT OF MONEY!
  exit
COINWITHDRAW:
  eval currencyNeeded toupper($2)
  var noCoinAmmount $1
  if (%%currencyNeeded < %noCoinAmmount) then {
    gosub AUTOMOVE exchange
    if ($invisible == 1) then gosub STOP_INVIS
    gosub %currencyNeeded
  }
  if (%%currencyNeeded >= %noCoinAmmount) then goto COIN_CONTINUE
  gosub AUTOMOVE teller
  if ($invisible == 1) then gosub STOP_INVIS
  gosub PUT withdraw %noCoinAmmount copper
  if (%%currencyNeeded >= %noCoinAmmount) then goto COIN_CONTINUE
  gosub clear
  goto COINQUIT
LIRUMS:
  if ("%Kronars" != "0") then gosub EXCHANGE KRONARS
  if ("%Dokoras" != "0") then gosub EXCHANGE DOKORAS
  goto EXCHANGE_FINISH
KRONARS:
  if ("%Lirums" != "0") then gosub EXCHANGE LIRUMS
  if ("%Dokoras" != "0") then gosub EXCHANGE DOKORAS
  goto EXCHANGE_FINISH
DOKORAS:
  if ("%Kronars" != "0") then gosub EXCHANGE KRONARS
  if ("%Lirums" != "0") then gosub EXCHANGE LIRUMS
  goto EXCHANGE_FINISH
EXCHANGE:
  var denomination $0
EXCHANGE_CONTINUE:
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
  put EXCHANGE ALL %denomination FOR %currencyNeeded
  matchwait
EXCHANGE_SMALLER:
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
  put EXCHANGE 1000 plat %denomination FOR %currencyNeeded
  matchwait
EXCHANGE_FINISH:
  gosub INFO_CHECK
  return
EXCH_INVIS:
  gosub STOP_INVIS
  goto EXCHANGE_CONTINUE
#### END coin handling section
####  Seacaves  ####
TO_SEACAVE:
TO_SEACAVES:
  if ("$zoneid" == "112") then gosub AUTOMOVE Map61_Leth_Deriel.xml
  if ("$zoneid" == "126") then gosub AUTOMOVE Map116_Hibarnhvidar.xml
  if ("$zoneid" == "127") then {
    gosub AUTOMOVE Map126_Hawstkaal_Road.xml
    gosub AUTOMOVE Map116_Hibarnhvidar.xml
  }
  if ("$zoneid" == "4") then gosub MOVE Map1_Crossing.xml
  if ("$zoneid" == "42") then gosub AUTOMOVE Map40_Langenfirth_to_Therenborough.xml
  if ("$zoneid" == "67") then gosub AUTOMOVE egate 66-44
  if ("$zoneid" == "7") then gosub MOVE Map1_Crossing.xml
  gosub AUTOMOVE portal
  if ($invisible == 1) then gosub STOP_INVIS
  gosub MOVE go meeting portal
  return
####
####  NECRO HANDLING  ####
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
  if (%verbose) then gosub ECHO KNOWN AS A NECRO!
  return
NECRO_UNKNOWN:
  var Necro.Known 0
  if (%verbose) then gosub ECHO NOT KNOWN AS A NECRO
  return
ROC:
  var ROCLoop 0
  var NecroPrep ROC
ROC_1:
  math ROCLoop add 1
  # if (matchre("%spelltimer", "Liturgy")) && ($Utility.Ranks >= 800) then var NecroPrep ROG
  if (%ROCLoop > 1) then var NecroPrep ROC
  if ($Utility.Ranks < 60) then return
  if (($spellROC == 1) && ("%NecroPrep" == "ROC")) then goto NECRO_DONE
  # if (($spellROG == 1) && ("%NecroPrep" == "ROG")) then goto NECRO_DONE
  if (%verbose) then gosub ECHO Prepping %NecroPrep
  if ("$preparedspell" != "None") then send release spell
  if (((matchre("$roomobjs", "exchange board"))) || ((matchre("$roomname", "([T|t]eller|[E|e]xchange|[B|b]ank)"))) || ((matchre("$roomname", "(%donotcastlist)")))) then {
    if (%verbose) then gosub ECHO BAD ROOM
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
  gosub PUT prep %NecroPrep %NecroMana
  pause 17
  if ((!("$roomplayers" == "")) && ((matchre("$preparedspell", "(Rite of Contrition|Eyes of the Blind)")))) then gosub RANDOMMOVE
  gosub PUT cast
  pause %command_pause
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
  if (%verbose) then gosub ECHO Prepping EOTB
  if ("$preparedspell" != "None") then send release spell
## ** Waits for invis pulse or casts the spell if invisible is off..
  if (($SpellTimer.EyesoftheBlind.active == 1) && ($invisible == 0)) then {
## ** This return is slightly different, it will not wait for pulse inside the exchange.
## ** It will also not wait for a pulse if destination == exchange, account or any teller trips to the exchange when moving areas.
## ** It should wait for a pulse inside the teller if going anywhere else.
    if ((((matchre("$roomobjs", "exchange rate board"))) || ((matchre("$roomname", "([T|t]eller|[E|e]xchange|[B|b]ank)"))) || ((matchre("$roomname", "(%donotcastlist)")))) && (((matchre("$roomname", "([T|t]eller|[E|e]xchange|[B|b]ank)"))) && ((matchre("%Destination", "(teller|exchange)"))))) then return
    matchre EOTB_1 ^Your spell subtly|^Your corruptive mutation fades
    matchwait 30
    # put #echo >log Red *** Error with EOTB not pulsing invis. Attempting to recast.
  }
  if ($invisible == 1) then return
## ** If script made it to this section then EOTB must be recast.
## ** This will not cast while inside the bank or any other unapproved rooms.
  if (((matchre("$roomobjs", "exchange rate board"))) || ((matchre("$roomname", "([T|t]eller|[E|e]xchange|[B|b]ank)"))) || ((matchre("$roomname", "(%donotcastlist)")))) then return
  if ($stamina < 30) then return
# gosub NECRO_CHECKROOM
  if ($Utility.Ranks < 120) then var NecroMana 5
  if (($Utility.Ranks >= 120) && ($Utility.Ranks < 240)) then var NecroMana 7
  if (($Utility.Ranks >= 240) && ($Utility.Ranks < 400)) then var NecroMana 10
  if (($Utility.Ranks >= 400) && ($Utility.Ranks < 500)) then var NecroMana 12
  if (($Utility.Ranks >= 500) && ($Utility.Ranks < 700)) then var NecroMana 15
  if ($Utility.Ranks >= 700) then var NecroMana 25
  gosub PUT prep EOTB %NecroMana
  pause 16
  gosub PUT cast
  pause %command_pause
#  if (($invisible == 0) && (EOTBLoop < 1)) then goto EOTB_1
  var EOTBLoop 0
  return
NECRO_DONE:
  delay %infiniteLoopProtection
  return
NECRO_CHECKROOM:
  pause %command_pause
  if !("$roomplayers" == "") then gosub RANDOMMOVE
  gosub PUT search
  pause %command_pause
  pause $roundtime
  pause %command_pause
  if !("$roomplayers" == "") then gosub RANDOMMOVE
  if (%verbose) then gosub ECHO FOUND EMPTY ROOM! ***
  return
####  END necro cast
#############################################################################################
### ESCAPING MODULES (For Escaping from Areas where Automapper doesn't work/path properly)
#############################################################################################
ALDAUTH_ESCAPE:
  gosub AUTOMOVE 682
  pause %command_pause
  gosub MOVE go door
  pause %command_pause
  return

EHHRSK_ESCAPE:
  if (($roomid >= 734) && ($roomid <= 755)) then goto KRAHEI_ESCAPE_1
  if (($roomid >= 756) && ($roomid <= 770)) then goto KRAHEI_ESCAPE_2
  if (($roomid >= 771) && ($roomid <= 782)) then goto KRAHEI_ESCAPE_3
KRAHEI_ESCAPE_1:
  gosub AUTOMOVE 747
  gosub MOVE go valve
  pause %command_pause
  return
KRAHEI_ESCAPE_2:
  gosub AUTOMOVE 760
  gosub MOVE go valve
  pause %command_pause
  return
KRAHEI_ESCAPE_3:
  gosub AUTOMOVE 771
  gosub MOVE go valve
  pause %command_pause
  return

SHARD_FAVOR_ESCAPE:
  if (%verbose) then gosub ECHO ESCAPING SHARD FAVOR AREA
  if ($standing == 0) then gosub STAND
  if (matchre("$roomname", "Wyvern Mountain, Raised Dais")) then gosub MOVE down
  if (matchre("$roomname", "Wyvern Mountain, Dragon Shrine")) then gosub MOVE up
  if (matchre("$roomobjs", "low opening")) then goto SHARD_FAVORE_ESCAPE_2
  if (matchre("$roomobjs", "black arch")) then gosub MOVE go black arch
  goto SHARD_FAVOR_ESCAPE
SHARD_FAVORE_ESCAPE_2:
  if ($prone == 0) then gosub PUT lie
  gosub MOVE go opening
  waitforre ^Tangled brush|\[Wyvern Trail, Clearing\]
  if ($standing == 0) then gosub STAND
  return

MAELSHYVE_FORTRESS_ESCAPE:
  if (%verbose) then gosub ECHO ESCAPING FROM MAELSHYVE'S FORTRESS
  gosub AUTOMOVE 109
  gosub MOVE south
  gosub CIRCLE
  gosub RETREAT
  gosub MOVE south
  gosub AUTOMOVE 93
  gosub PUT touch etching
  pause %command_pause
  gosub MOVE south
  gosub MOVE south
  return
BENEATH_ZAULFUNG_ESCAPE:
  if (%verbose) then gosub ECHO ESCAPING FROM BENEATH ZAULFUNG
  gosub AUTOMOVE 5
  pause %command_pause
  if ($zoneid == 31b) then goto BENEATH_ZAULFUNG_ESCAPE
ZAULFUNG_ESCAPE_0:
  gosub AUTOMOVE 121
ZAULFUNG_ESCAPE:
### LESSER SHADOW HOUNDS MAZE Map 31a (Rancid Mire)
  if (matchre("$roomname", "Trackless Swamp")) then gosub ZAULFUNG_ESCAPE_2
  if (%verbose) then gosub ECHO ESCAPING FROM LESSER SHADOW HOUNDS
  if (matchre("$roomobjs", "curving path")) then goto ZAULFUNG_MAZE_2
  gosub RANDOMWEIGHT west
  if (matchre("$roomobjs", "curving path")) then goto ZAULFUNG_MAZE_2
  gosub RANDOMWEIGHT west
  if (matchre("$roomobjs", "curving path")) then goto ZAULFUNG_MAZE_2
  gosub RANDOMWEIGHT west
  if (matchre("$roomobjs", "curving path")) then goto ZAULFUNG_MAZE_2
  gosub RANDOMMOVE
  if (matchre("$roomobjs", "curving path")) then goto ZAULFUNG_MAZE_2
  gosub RANDOMMOVE
  if (matchre("$roomobjs", "curving path")) then goto ZAULFUNG_MAZE_2
  gosub RANDOMMOVE
ZAULFUNG_MAZE_2:
  gosub MOVE go path
  pause %command_pause
  return
ZAULFUNG_ESCAPE_2:
  if ((matchre("$roomdesc", "Rancid mire"))) then gosub ZAULFUNG_ESCAPE
  if (%verbose) then gosub ECHO ESCAPING FROM SWAMP TROLLS
  if !($standing) then gosub STAND
  gosub TRUE_RANDOM
  if ($up) then gosub MOVE up
  pause %command_pause
  if ($roomid != 0) then return
  gosub TRUE_RANDOM
  if ($up) then gosub MOVE up
  pause %command_pause
  if ($roomid != 0) then return
  pause %command_pause
  goto ZAULFUNG_ESCAPE_2
ZAULFUNG_ESCAPE_3:
  if ((matchre("$roomname", "Zaulfung, Chickee"))) then gosub ZAULFUNG_ESCAPE
  if (%verbose) then gosub ECHO ESCAPING FROM SWAMP TROLLS
  if !($standing) then gosub STAND
  gosub TRUE_RANDOM
  if ($up) then gosub MOVE up
  pause %command_pause
  if ($roomid != 0) then return
  gosub TRUE_RANDOM
  if ($up) then gosub MOVE up
  pause %command_pause
  if ($roomid != 0) then return
  pause %command_pause
  goto ZAULFUNG_ESCAPE_2

BROCKET_ESCAPE:
  if (%verbose) then gosub ECHO ESCAPING BROCKET DEER
  if ($east) then gosub MOVE east
  if ($east) then gosub MOVE east
  if ($east) then gosub MOVE east
  if (matchre("$roomobjs", "rolling hill")) then gosub MOVE climb hill
  if (matchre("$roomobjs", "log fence")) then {
    gosub MOVE climb fence
    gosub MOVE NE
  }
  if ($roomid != 0) then return
  if ($west) then gosub MOVE west
  if ($west) then gosub MOVE west
  if ($west) then gosub MOVE west
  if (matchre("$roomobjs", "gentle hill")) then gosub MOVE climb hill
  if ($east) then gosub MOVE east
  if ($east) then gosub MOVE east
  if ($east) then gosub MOVE east
  if (matchre("$roomobjs", "log fence")) then {
    gosub MOVE climb fence
    gosub MOVE NE
  }
  if ($roomid != 0) then return
  goto BROCKET_ESCAPE

DEADMAN_ESCAPE:
  if (%verbose) then gosub ECHO ESCAPING DEADMAN'S CONFIDE BEACH
  if (matchre("$roomdesc", "A cliff wall rises out of sight")) then goto DEADMAN_ESCAPE_2
  gosub TRUE_RANDOM
  if (matchre("$roomdesc", "A cliff wall rises out of sight")) then goto DEADMAN_ESCAPE_2
  gosub TRUE_RANDOM
  if (matchre("$roomdesc", "A cliff wall rises out of sight")) then goto DEADMAN_ESCAPE_2
  gosub TRUE_RANDOM
  if (matchre("$roomdesc", "A cliff wall rises out of sight")) then goto DEADMAN_ESCAPE_2
  gosub TRUE_RANDOM
  if (matchre("$roomdesc", "A cliff wall rises out of sight")) then goto DEADMAN_ESCAPE_2
  gosub TRUE_RANDOM
  if (matchre("$roomdesc", "A cliff wall rises out of sight")) then goto DEADMAN_ESCAPE_2
  gosub TRUE_RANDOM
  if (matchre("$roomdesc", "A cliff wall rises out of sight")) then goto DEADMAN_ESCAPE_2
  gosub TRUE_RANDOM
  if (matchre("$roomdesc", "A cliff wall rises out of sight")) then goto DEADMAN_ESCAPE_2
  gosub TRUE_RANDOM
  if (matchre("$roomdesc", "A cliff wall rises out of sight")) then goto DEADMAN_ESCAPE_2
  gosub TRUE_RANDOM
  if (matchre("$roomdesc", "A cliff wall rises out of sight")) then goto DEADMAN_ESCAPE_2
  gosub TRUE_RANDOM
  if (matchre("$roomdesc", "A cliff wall rises out of sight")) then goto DEADMAN_ESCAPE_2
  gosub TRUE_RANDOM
  if (matchre("$roomdesc", "A cliff wall rises out of sight")) then goto DEADMAN_ESCAPE_2
  gosub TRUE_RANDOM
  goto DEADMAN_ESCAPE
DEADMAN_ESCAPE_2:
  gosub RETREAT
  gosub MOVE climb handhold
  pause %command_pause
  if (matchre("$roomname", "Deadman's Confide, Beach")) then {
    gosub TRUE_RANDOM
    pause %command_pause
    gosub TRUE_RANDOM
    pause %command_pause
    goto DEADMAN_ESCAPE
  }
  return

USHNISH_ESCAPE:
     if (%verbose) then gosub ECHO ESCAPING FANGS OF USHNISH - SHIFTING MAZE
USHNISH_ESCAPE_1:
  if (matchre("$roomname", "Temple of Ushnish")) then goto USHNISH_ESCAPE_TEMPLE
  if (matchre("$roomname", "Beyond the Gate of Souls")) then goto USHNISH_ESCAPE_3
  gosub RANDOMMOVE
  if (matchre("$roomobjs", "steep cliff")) then goto USHNISH_ESCAPE_2
  gosub RANDOMMOVE
  if (matchre("$roomobjs", "steep cliff")) then goto USHNISH_ESCAPE_2
  gosub RANDOMMOVE
  if (matchre("$roomobjs", "steep cliff")) then goto USHNISH_ESCAPE_2
  gosub RANDOMNORTH
  if (matchre("$roomobjs", "steep cliff")) then goto USHNISH_ESCAPE_2
  gosub RANDOMNORTH
  if (matchre("$roomobjs", "steep cliff")) then goto USHNISH_ESCAPE_2
  gosub RANDOMNORTH
  if (matchre("$roomobjs", "steep cliff")) then goto USHNISH_ESCAPE_2
  gosub RANDOMMOVE
  if (matchre("$roomobjs", "steep cliff")) then goto USHNISH_ESCAPE_2
  gosub RANDOMMOVE
  if (matchre("$roomobjs", "steep cliff")) then goto USHNISH_ESCAPE_2
  gosub RANDOMMOVE
  if (matchre("$roomobjs", "steep cliff")) then goto USHNISH_ESCAPE_2
  gosub RANDOMMOVE
  if (matchre("$roomobjs", "steep cliff")) then goto USHNISH_ESCAPE_2
  gosub RANDOMMOVE
  if (matchre("$roomobjs", "steep cliff")) then goto USHNISH_ESCAPE_2
  gosub RANDOMSOUTH
  if (matchre("$roomobjs", "steep cliff")) then goto USHNISH_ESCAPE_2
  gosub RANDOMSOUTH
  if (matchre("$roomobjs", "steep cliff")) then goto USHNISH_ESCAPE_2
  gosub RANDOMSOUTH
  if (matchre("$roomobjs", "steep cliff")) then goto USHNISH_ESCAPE_2
  gosub RANDOMSOUTH
  if (matchre("$roomobjs", "steep cliff")) then goto USHNISH_ESCAPE_2
  gosub RANDOMSOUTH
  if (matchre("$roomobjs", "steep cliff")) then goto USHNISH_ESCAPE_2
  goto USHNISH_ESCAPE_1
USHNISH_ESCAPE_2:
  gosub MOVE climb cliff
USHNISH_ESCAPE_TEMPLE:
  if (%verbose) then gosub ECHO ESCAPING TEMPLE OF USHNISH
  if (matchre("$roomname", "The Fangs of Ushnish")) then goto USHNISH_ESCAPE_1
  if (matchre("$roomname", "Temple of Ushnish")) then gosub AUTOMOVE 224
  if (matchre("$roomname", "Before the Temple of Ushnish")) then goto USHNISH_ESCAPE_3
USHNISH_ESCAPE_3:
  gosub RETREAT
  gosub MOVE go lava field
USHNISH_ESCAPE_GATE:
  if (%verbose) then gosub ECHO ESCAPING GATE OF SOULS BLASTED PLAINS MAZE
USHNISH_ESCAPE_GATE_1:
  gosub RANDOMMOVE
  if (matchre("$roomname", "The Fangs of Ushnish")) then goto USHNISH_ESCAPE_1
  if (matchre("$roomobjs", "low cavern")) then goto USHNISH_ESCAPE_4
  gosub RANDOMMOVE
  if (matchre("$roomobjs", "low cavern")) then goto USHNISH_ESCAPE_4
  gosub RANDOMMOVE
  if (matchre("$roomobjs", "low cavern")) then goto USHNISH_ESCAPE_4
  gosub RANDOMMOVE
  if (matchre("$roomobjs", "low cavern")) then goto USHNISH_ESCAPE_4
  gosub RANDOMNORTH
  if (matchre("$roomobjs", "low cavern")) then goto USHNISH_ESCAPE_4
  gosub RANDOMNORTH
  if (matchre("$roomobjs", "low cavern")) then goto USHNISH_ESCAPE_4
  gosub RANDOMNORTH
  if (matchre("$roomobjs", "low cavern")) then goto USHNISH_ESCAPE_4
  gosub RANDOMNORTH
  if (matchre("$roomobjs", "low cavern")) then goto USHNISH_ESCAPE_4
  gosub RANDOMNORTH
  if (matchre("$roomobjs", "low cavern")) then goto USHNISH_ESCAPE_4
  goto USHNISH_ESCAPE_GATE_1
USHNISH_ESCAPE_4:
  gosub MOVE go cavern
  gosub PUT lie
  gosub MOVE go tunnel
  waitforre Rising in a snubbed tower
  pause %command_pause
  gosub STAND
  gosub AUTOMOVE 104
  return

VELAKADUNES_ESCAPE:
  if (%verbose) then gosub ECHO ESCAPING FROM VELAKA DUNES MAZE
VELAKADUNES_ESCAPE_1:
  if ((matchre("%destination", "(haize?n?)")) && (matchre("$roomobjs", "(?i)twisting trail"))) then {
    gosub MOVE go trail
    gosub AUTOMOVE 29
    goto ARRIVED
  }
  if ((matchre("%destination", "(oasis?)")) && (matchre("$roomobjs", "(?i)path"))) then {
    gosub MOVE go path
    gosub AUTOMOVE 2
    goto ARRIVED
  }
  if ((matchre("%destination", "yeeha?r?")) && (matchre("$roomobjs", "(?i)canyon"))) then {
    gosub MOVE go canyon
    gosub AUTOMOVE 49
    goto ARRIVED
  }
  if (matchre("$roomobjs", "(?i)path")) then {
    gosub MOVE go path
    gosub AUTOMOVE 2
  }
  gosub RANDOMMOVE
  goto VELAKADUNES_ESCAPE_1
VELAKA_ESCAPE:
VELAKA_ESCAPE_1:
  if (%verbose) then gosub ECHO ESCAPING FROM VELAKA DESERT MAZE
  if (matchre("$roomname", "Walk of Bones")) then gosub AUTOMOVE 118
  if ((matchre("$roomobjs", "black stone")) && (!matchre("%destination", "muspar?i?"))) then goto VELAKA_ESCAPE_ALT
  if (matchre("$roomobjs", "rocky trail")) then goto VELAKA_ESCAPE_2
  gosub RANDOMWEIGHT west
  if ((matchre("$roomobjs", "black stone")) && (!matchre("%destination", "muspar?i?"))) then goto VELAKA_ESCAPE_ALT
  if (matchre("$roomobjs", "rocky trail")) then goto VELAKA_ESCAPE_2
  gosub RANDOMWEIGHT west
  if ((matchre("$roomobjs", "black stone")) && (!matchre("%destination", "muspar?i?"))) then goto VELAKA_ESCAPE_ALT
  if (matchre("$roomobjs", "rocky trail")) then goto VELAKA_ESCAPE_2
  gosub RANDOMWEIGHT west
  if ((matchre("$roomobjs", "black stone")) && (!matchre("%destination", "muspar?i?"))) then goto VELAKA_ESCAPE_ALT
  if (matchre("$roomobjs", "rocky trail")) then goto VELAKA_ESCAPE_2
  gosub RANDOMWEIGHT west
  if ((matchre("$roomobjs", "black stone")) && (!matchre("%destination", "muspar?i?"))) then goto VELAKA_ESCAPE_ALT
  if (matchre("$roomobjs", "rocky trail")) then goto VELAKA_ESCAPE_2
  gosub RANDOMMOVE
  if ((matchre("$roomobjs", "black stone")) && (!matchre("%destination", "muspar?i?"))) then goto VELAKA_ESCAPE_ALT
  if (matchre("$roomobjs", "rocky trail")) then goto VELAKA_ESCAPE_2
  gosub RANDOMMOVE
  if ((matchre("$roomobjs", "black stone")) && (!matchre("%destination", "muspar?i?"))) then goto VELAKA_ESCAPE_ALT
  if (matchre("$roomobjs", "rocky trail")) then goto VELAKA_ESCAPE_2
  gosub RANDOMMOVE
  if ((matchre("$roomobjs", "black stone")) && (!matchre("%destination", "muspar?i?"))) then goto VELAKA_ESCAPE_ALT
  if (matchre("$roomobjs", "rocky trail")) then goto VELAKA_ESCAPE_2
  gosub RANDOMMOVE
  if ((matchre("$roomobjs", "black stone")) && (!matchre("%destination", "muspar?i?"))) then goto VELAKA_ESCAPE_ALT
  if (matchre("$roomobjs", "rocky trail")) then goto VELAKA_ESCAPE_2
  gosub RANDOMMOVE
  if ((matchre("$roomobjs", "black stone")) && (!matchre("%destination", "muspar?i?"))) then goto VELAKA_ESCAPE_ALT
  if (matchre("$roomobjs", "rocky trail")) then goto VELAKA_ESCAPE_2
  gosub RANDOMWEIGHT east
  if ((matchre("$roomobjs", "black stone")) && (!matchre("%destination", "muspar?i?"))) then goto VELAKA_ESCAPE_ALT
  if (matchre("$roomobjs", "rocky trail")) then goto VELAKA_ESCAPE_2
  gosub RANDOMWEIGHT east
  if ((matchre("$roomobjs", "black stone")) && (!matchre("%destination", "muspar?i?"))) then goto VELAKA_ESCAPE_ALT
  if (matchre("$roomobjs", "rocky trail")) then goto VELAKA_ESCAPE_2
  gosub RANDOMWEIGHT east
  if ((matchre("$roomobjs", "black stone")) && (!matchre("%destination", "muspar?i?"))) then goto VELAKA_ESCAPE_ALT
  if (matchre("$roomobjs", "rocky trail")) then goto VELAKA_ESCAPE_2
  gosub RANDOMWEIGHT east
  if ((matchre("$roomobjs", "black stone")) && (!matchre("%destination", "muspar?i?"))) then goto VELAKA_ESCAPE_ALT
  if (matchre("$roomobjs", "rocky trail")) then goto VELAKA_ESCAPE_2
  gosub RANDOMWEIGHT east
  if ((matchre("$roomobjs", "black stone")) && (!matchre("%destination", "muspar?i?"))) then goto VELAKA_ESCAPE_ALT
  if (matchre("$roomobjs", "rocky trail")) then goto VELAKA_ESCAPE_2
  gosub RANDOMMOVE
  if ((matchre("$roomobjs", "black stone")) && (!matchre("%destination", "muspar?i?"))) then goto VELAKA_ESCAPE_ALT
  if (matchre("$roomobjs", "rocky trail")) then goto VELAKA_ESCAPE_2
  gosub RANDOMMOVE
  if ((matchre("$roomobjs", "black stone")) && (!matchre("%destination", "muspar?i?"))) then goto VELAKA_ESCAPE_ALT
  if (matchre("$roomobjs", "rocky trail")) then goto VELAKA_ESCAPE_2
  gosub RANDOMMOVE
  if ((matchre("$roomobjs", "black stone")) && (!matchre("%destination", "muspar?i?"))) then goto VELAKA_ESCAPE_ALT
  if (matchre("$roomobjs", "rocky trail")) then goto VELAKA_ESCAPE_2
  gosub RANDOMMOVE
  if ((matchre("$roomobjs", "black stone")) && (!matchre("%destination", "muspar?i?"))) then goto VELAKA_ESCAPE_ALT
  if (matchre("$roomobjs", "rocky trail")) then goto VELAKA_ESCAPE_2
  gosub RANDOMMOVE
  if ((matchre("$roomobjs", "black stone")) && (!matchre("%destination", "muspar?i?"))) then goto VELAKA_ESCAPE_ALT
  if (matchre("$roomobjs", "rocky trail")) then goto VELAKA_ESCAPE_2
  gosub RANDOMMOVE
  if ((matchre("$roomobjs", "black stone")) && (!matchre("%destination", "muspar?i?"))) then goto VELAKA_ESCAPE_ALT
  if (matchre("$roomobjs", "rocky trail")) then goto VELAKA_ESCAPE_2
  gosub RANDOMMOVE
  goto VELAKA_ESCAPE_1
VELAKA_ESCAPE_2:
  gosub MOVE go trail
  return
VELAKA_ESCAPE_ALT:
  gosub MOVE go stone
  return

WARRENS_ESCAPE:
  if (%verbose) then gosub ECHO ESCAPING FROM SHARD WARRENS
  if ("$guild" == "Necromancer") then {
    gosub AUTOMOVE 316
    gosub AUTOMOVE 29
    return
  }
  if ("$guild" == "Thief") then {
    gosub AUTOMOVE 279
    gosub AUTOMOVE 292
    gosub AUTOMOVE 596
    gosub AUTOMOVE 8
    return
  }
  if ("$guild" != "Thief") then {
    gosub AUTOMOVE 255
    gosub AUTOMOVE 381
    gosub AUTOMOVE 185
    gosub MOVE go grate
    waitforre Flush against the rock foundations|Obvious|The water shoves you out|^I could|^YOU HAVE
    return
  }
  return

MAELSHYVE_ASCENT_ESCAPE:
  if (%verbose) then gosub ECHO ESCAPING FROM MAESHYVE'S ASCENT
  if ($hidden == 0) then gosub HIDE
  gosub AUTOMOVE 447
  if ($roomid != 447) then goto MAELSHYVE_ASCENT_ESCAPE
  gosub MOVE go throne
#han: why?
  pause 8
ABYSSAL_ESCAPE:
  if (%verbose) then gosub ECHO ESCAPING FROM ABYSS
  if ($stunned) then waiteval (!$stunned)
  gosub AUTOMOVE 199
  return
CIRCLE:
  match RETURN As the lights within the circle fade and die, you step out
  matchre RETURN ^You are already standing\.
  matchre RETURN ^You step into the etched circle, but nothing seems to happen, so you step back out\.
  put stand circle
  matchwait 40
  goto CIRCLE
ADDERNEST_ESCAPE:
  if (%verbose) then gosub ECHO ESCAPING FROM ADDER'S NEST
  gosub AUTOMOVE 434
  gosub PUT climb open
  gosub PUT go port
NORTHWIND_ESCAPE:
  gosub AUTOMOVE 506
  gosub PUT pull sconce
  gosub MOVE go door
  gosub MOVE SE
ASKETI_ESCAPE:
  put #queue clear
  if (%verbose) then gosub ECHO ESCAPING FROM ASKETI'S MOUNT
### 100 foot cliff
  gosub AUTOMOVE 369
  gosub AUTOMOVE 124
  gosub AUTOMOVE south
  return

CROC_ESCAPE:
  if (%verbose) then gosub ECHO ESCAPING FROM CROCODILE MAZE
  var croc.count 0
  var direction sw
  goto CROC_MOVE
CROC_RET:
  gosub retreat
CROC_MOVE:
  math croc.count add 1
  if ((%croc.count > 6) && ("%direction" == "sw")) then {
    var direction north
    var croc.count 0
  }
  if ((%croc.count > 6) && ("%direction" == "north")) then {
    var direction south
    var croc.count 0
  }
  if ((%croc.count > 6) && ("%direction" == "south")) then {
    var direction east
    var croc.count 0
  }
  if ((%croc.count > 6) && ("%direction" == "east")) then {
    var direction sw
    var croc.count 0
  }
  pause %infiniteLoopProtection
  matchre CROC_RET ^You are engaged
  matchre CROC_MOVE ^\.\.\.wait|^Sorry, you may only type|^You.*are.*still.*stunned\.
  matchre REEDGO ^.?Roundtime\:?
  put %direction
  matchwait 20
  goto CROC_MOVE
REEDGO:
  pause %infiniteLoopProtection
  matchre CROC_RET ^You are engaged
  matchre REEDGO ^\.\.\.wait|^Sorry, you may only type|^You.*are.*still.*stunned\.
  matchre CROC_MOVE ^\[The Marsh, In The Water\]|^What were you
  matchre OUT_OF_CROCS ^\[The Marsh, Stone Road\]
  put go reed
  matchwait 20
  goto CROC_MOVE
OUT_OF_CROCS:
  gosub MOVE south
  pause %command_pause
  if ($roundtime > 0) then pause $roundtime
  gosub MOVE south
  pause %command_pause
  if ($roundtime > 0) then pause $roundtime
  gosub MOVE south
  pause %command_pause
  if ($roundtime > 0) then pause $roundtime
  gosub MOVE southeast
  pause %command_pause
  if ($roundtime > 0) then pause $roundtime
  if (matchre("$roomname", "The Marsh, In The Water")) then goto CROC_ESCAPE
  put #parse OUT OF CROCS
  return
####  END escapes
#######################################################################
#### ENTERING GATE OF SOULS AREA / TEMPLE OF USHNISH MAZE ZONES
GATE_OF_SOULS:
USHNISH_GO:
  if (matchre("$roomname", "Beyond the Gate of Souls")) then gosub USHNISH_AT_ZONE1
  if (matchre("$roomname", "Temple of Ushnish")) then gosub USHNISH_AT_ZONE3
  if (matchre("$roomname", "The Fangs of Ushnish")) then gosub USHNISH_AT_ZONE4
  if ("$zoneid" == "1") then gosub MOVE Map7_NTR.xml
  if ("$zoneid" != "7") then return
  if (("$zoneid" == "7") && ($roomid == 188)) then goto USHNISH_GO22
  gosub AUTOMOVE gate of soul
USHNISH_GO2:
  gosub stowing
  if ($invisible) then gosub STOP_INVIS
  pause %command_pause
USHNISH_GO22:
  if ("$zoneid" == "1") then goto USHNISH_GO
  if ($roomid != 188) then gosub AUTOMOVE 188
  if contains("$roomobjs", "low tunnel") then goto USHNISH_GO3
  if ($standing == 0) then gosub STAND
  if contains("$roomobjs", "low tunnel") then goto USHNISH_GO3
  gosub RETREAT
  if ($roundtime > 0) then pause $roundtime
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
  gosub PUT fall
  if ($standing == 1) then gosub PUT lie
  if !contains("$roomobjs", "low tunnel") then goto USHNISH_GO2
USHNISH_GO_3:
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
  if !($standing) then gosub STAND
  gosub PUT go lava field
#### FROM BEYOND GATE OF SOULS (MAZE) TO TEMPLE OF USHNISH (MAPPED AREA)
USHNISH_GO_ZONE2:
  if (%verbose) then gosub ECHO Attempting to find Sandstone Temple inside this damn Maze...
  pause %command_pause
  if (matchre("$roomobjs", "sandstone temple")) then goto USHNISH_GO_ZONE3
  gosub RANDOMWEIGHT east
  if (matchre("$roomobjs", "sandstone temple")) then goto USHNISH_GO_ZONE3
  gosub RANDOMWEIGHT east
  if (matchre("$roomobjs", "sandstone temple")) then goto USHNISH_GO_ZONE3
  gosub RANDOMMOVE
  if (matchre("$roomobjs", "sandstone temple")) then goto USHNISH_GO_ZONE3
  gosub RANDOMMOVE
  if (matchre("$roomobjs", "sandstone temple")) then goto USHNISH_GO_ZONE3
  gosub RANDOMMOVE
  if (matchre("$roomobjs", "sandstone temple")) then goto USHNISH_GO_ZONE3
  gosub RANDOMMOVE
  if (matchre("$roomobjs", "sandstone temple")) then goto USHNISH_GO_ZONE3
  gosub RANDOMMOVE
  if (matchre("$roomobjs", "sandstone temple")) then goto USHNISH_GO_ZONE3
  gosub RANDOMMOVE
  if (matchre("$roomobjs", "sandstone temple")) then goto USHNISH_GO_ZONE3
  gosub RANDOMMOVE
  if (matchre("$roomobjs", "sandstone temple")) then goto USHNISH_GO_ZONE3
  gosub RANDOMMOVE_SOUTH
  if (matchre("$roomobjs", "sandstone temple")) then goto USHNISH_GO_ZONE3
  gosub RANDOMMOVE_SOUTH
  if (matchre("$roomobjs", "sandstone temple")) then goto USHNISH_GO_ZONE3
  pause %command_pause
  goto USHNISH_GO_ZONE2
USHNISH_GO_ZONE3:
  if (%verbose) then gosub ECHO FOUND THE TEMPLE OF USHNISH!
  gosub MOVE go temple
  gosub MOVE south
  gosub MOVE south
  gosub MOVE southeast
  gosub MOVE go door
  return
####  END ushnish
##### AUTOMOVEMENT - TRAVEL ROUTINES  using #goto and automapper.cmd ####
# guarantees this lands where it wants to
# usage:
#   gosub AUTOMOVE Map1
#    used to move between maps, will regex out the id to confirm
#   gosub AUTOMOVE 17
#     used to move to a room on a map, will confirm landing in that room before returning
#   gosub AUTOMOVE egate 66-44
#     used to move to a new map via a special path, will confirm landing in zoneid-roomid before returning
AUTOMOVE:
  action (moving) on
  var Moving 0
  var randomloop 0
  var Destination $1
  var Destination_room $2
  if (!(matchre("%Destination", "\b\d+\b")) && !(matchre("%Destination", "Map(\d+\w?)")) && !(matchre("%Destination", "\w+ (\d+-\d+)"))) then {
    gosub ECHO ERROR: Hanryu messed up the script call, tell him to fix it!
    exit
  }
  var automovefailCounter 0
  if ($hidden == 1) then gosub UNHIDE
  if ($standing == 0) then gosub gosub STAND
  if ($roomid == 0) then gosub RANDOMMOVE
AUTOMOVE_GO:
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
AUTOMOVE_FAILED:
  delay %command_pause
  math automovefailCounter add 1
  if (%automovefailCounter > 5) then goto AUTOMOVE_FAIL_BAIL
  if (%automovefailCounter > 1) then put #mapper reset
  delay %command_pause
  if (($roomid == 0) || (%automovefailCounter > 2)) then gosub RANDOMMOVE
echo why we failing
  pause 10
exit

  goto AUTOMOVE_GO
AUTOMOVE_FAIL_BAIL:
  action (moving) off
  put #echo >Log #DC143C *** AUTOMOVE FAILED. ***
  put #echo >Log Destination: %Destination
  put #echo #DC143C *** AUTOMOVE FAILED.  ***
  put #echo #DC143C Destination: %Destination
AUTOMOVE_RETURN:
#make sure room loads
  delay %infiniteLoopProtection
#check to see if you made it where you wanted to go
if (%Destination_room == $roomname) then {
    goto AUTOMOVE_RETURN_2
} 
  if ((matchre("%Destination", "\b\d+\b")) && (%Destination != $roomid)) then goto AUTOMOVE_FAILED
  if (matchre("%Destination", "Map(\d+\w?\b)")) then {
    if ("$1" != "$zoneid") then goto AUTOMOVE_FAILED
  }
  if (matchre("%Destination", "\w+ (\d+-\d+)")) then {
    if ("$1" != "$zoneid-$roomid") then goto AUTOMOVE_FAILED
  }
  var randomloop 0
  var automovefailCounter 0
  action (moving) off
  #no more need for micropauses, we've confirmed we got where we wanted to be
  return
################################
# MOVE SINGLE
################################
MOVE:
  var Direction $0
  var movefailCounter 0
  var moveRetreat 0
  var randomloop 0
  var lastmoved %Direction
MOVE_RESUME:
  matchre MOVE_RETRY ^\.\.\.wait|^Sorry, you may only type|^Please wait\.|You are still stunned\.
#double join
  matchre MOVE_RESUME ^The .+? says, .Woah there
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
  gosub STAND
  goto MOVE_RESUME
MOVE_RETREAT:
  math moveRetreat add 1
  if (%moveRetreat > 4) then {
    gosub PUT search
    var moveRetreat 0
  }
#  if ($invisible == 1) then gosub STOP_INVIS
  gosub RETREAT
  goto MOVE_RESUME
MOVE_DIG:
  delay %infiniteLoopProtection
  matchre MOVE_DIG ^\.\.\.wait|^Sorry,|^You are still stunned\.
  matchre MOVE_DIG ^You struggle to dig off the thick mud caked around your legs\.
  matchre MOVE_STAND ^You manage to dig enough mud away from your legs to assist your movements\.
  matchre MOVE_DIG_STAND ^Maybe you can reach better that way, but you'll need to stand up for that to really do you any good\.
  matchre MOVE_RESUME ^You will have to kneel
  send dig
  matchwait 10
  goto MOVE_DIG
MOVE_DIG_STAND:
  delay %infiniteLoopProtection
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
  put #echo >Log #DC143C *** MOVE FAILED! ***
  gosub ECHO MOVE FAILED!
  return
MOVE_RETURN_CHECK:
  put look
  delay %infiniteLoopProtection
MOVE_RETURN:
  var moved 1
  var randomloop 0
  unvar moveloop
  unvar movefailCounter
  return

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
  delay %infiniteLoopProtection
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
  if (matchre("%moveloop", "\b(40)\b")) then {
    if (%verbose) then gosub ECHO CANNOT FIND A ROOM EXIT??!
    put look
    pause %command_pause
    gosub FERRY_CHECK
  }
### TRY A LIGHT SOURCE IF ROOM IS PITCH BLACK AND THEN TRY TRUE RANDOM DIRECTIONS
  if (%moveloop > 20) then {
    if (matchre("$roomobjs $roomdesc", "pitch black")) then gosub LIGHT_SOURCE
    var lastmoved null
    gosub TRUE_RANDOM
  }
### IF WE'VE DONE 50+ LOOPS - DO ALL CHECKS - LIGHT SOURCE/FERRY CHECK AND RESET BACK TO 0
  if (%moveloop > 50) then {
    gosub ECHO Cannot find a room exit??? Stupid fog???|ZONE: $zoneid | ROOM: $roomid|SEND THE ROOM DESCRIPTION/EXITS WHEN YOU TYPE LOOK|ATTEMPTING RANDOM DIRECTIONS...|SHOULD AUTO-RECOVER IF YOU CAN FIND AN EXIT
    gosub FERRY_CHECK
    pause %command_pause
    if (matchre("$roomobjs $roomdesc", "pitch black")) then gosub LIGHT_SOURCE
    gosub TRUE_RANDOM
    var lastmoved null
    var randomloop 0
    var moveloop 0
    return
  }
### MOVE INTO TRUE RANDOM MODE
  if (%moveloop > 55) then {
    if (matchre("$roomobjs $roomdesc", "pitch black")) then gosub LIGHT_SOURCE
    var lastmoved null
    gosub TRUE_RANDOM
  }
### HERE BEGINS CONDITIONAL CHECKS FOR VERY SPECIFIC ROOMS AND HOW TO *TRY* AND HANDLE THEM
  if (matchre("$roomname", "\[Skeletal Claw\]")) then {
    gosub ECHO IN THE SKELETAL CLAW! OH NO!!!|WE MIGHT DIE IF SOMEONE DOESN'T CAST UNCURSE ON IT!|ATTEMPTING TO ESCAPE.............
    gosub MOVE out
    return
  }
  if ((matchre("$roomname", "Deadman's Confide, Beach")) || (matchre("$roomobjs", "thick fog")) || (matchre("$roomexits", "thick fog"))) then gosub TRUE_RANDOM
  if (matchre("$roomname", "Smavold's Toggery")) then gosub MOVE go door
  if (matchre("$roomname", "Temple Hill Manor, Grounds")) then gosub MOVE go gate
  if (matchre("$roomname", "(Ylono's Repairs|Catrox's Forge|Unspiek's Repair Shop|Kamze's Repair|Storage Shed)")) then gosub MOVE out
  if (matchre("$roomname", "Darkling Wood, Ironwood Tree")) then gosub MOVE climb pine branches
  if (matchre("$roomname", "Darkling Wood, Pine Tree")) then gosub MOVE climb white pine
  if (%moved == 1) then return
  if (matchre("$roomname", "The Sewers, Beneath the Grate")) then gosub MOVE go grate
  if (matchre("$roomobjs", "strong creeper")) then gosub MOVE climb ladder
  if (matchre("$roomobjs", "the garden")) then gosub MOVE go garden
  if (matchre("$roomobjs", "underside of the Bridge of Rooks")) then gosub MOVE climb bridge
  if (%moved == 1) then return
### IF WE HAVE DONE 10 LOOPS WITH NO MATCHES - LOOK FOR AND TRY SOME OF THE MOST COMMON NON-CARDINAL EXITS
  if (%moveloop > 10) then {
    if (matchre("$roomobjs", "stone wall")) then gosub MOVE climb wall
    if (matchre("$roomobjs", "narrow ledge")) then gosub MOVE climb ledge
    if (matchre("$roomobjs", "craggy niche")) then gosub MOVE climb niche
    if (matchre("$roomobjs", "double door")) then gosub MOVE go door
    if (matchre("$roomobjs", "staircase")) then gosub MOVE climb stair
    if (matchre("$roomobjs", "the exit")) then gosub MOVE go exit
    if (matchre("$roomobjs", "\bdocks?")) then gosub MOVE go dock
    if (matchre("$roomobjs", "\bdoor\b")) then gosub MOVE go door
    if (matchre("$roomobjs", "\bledge\b")) then gosub MOVE go ledge
    if (matchre("$roomobjs", "\barch\b")) then gosub MOVE go arch
    if (matchre("$roomobjs", "\bgate\b")) then gosub MOVE go gate
    if (matchre("$roomobjs", "\btrapdoor\b")) then gosub MOVE go trapdoor
    if (matchre("$roomobjs", "\bcrevice\b")) then gosub MOVE go crevice
    if (matchre("$roomobjs", "\bcurtain\b")) then gosub MOVE go curtain
    if (matchre("$roomobjs", "\bportal\b")) then gosub MOVE go portal
    if (matchre("$roomobjs", "\btrail\b")) then gosub MOVE go trail
    if (matchre("$roomobjs", "\bpath\b")) then gosub MOVE go path
    if (matchre("$roomobjs", "\bhole\b")) then gosub MOVE go hole
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
  if ((%r == 9) && ($out)) then gosub MOVE out
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
  if ((%r == 8) && ($out)) then gosub MOVE out
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
  if (%moveloop > 13) then {
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
    if ((matchre("$roomobjs $roomdesc", "narrow hole")) && ("%lastmoved" != "go hole")) then gosub MOVE go hole
    if ((matchre("$roomobjs $roomdesc", "large hole")) && ("%lastmoved" != "go hole")) then gosub MOVE go hole
    if ((matchre("$roomobjs $roomdesc", "\bcrevice")) && ("%lastmoved" != "go crevice")) then gosub MOVE go crevice
    if ((matchre("$roomobjs $roomdesc", "\bdocks")) && ("%lastmoved" != "go dock")) then gosub MOVE go dock
    if (%moved == 1) then return
    if ((matchre("$roomobjs $roomdesc", "\bpath\b")) && ("%lastmoved" != "go path")) then gosub MOVE go path
    if ((matchre("$roomobjs $roomdesc", "\btrail\b")) && ("%lastmoved" != "go trail")) then gosub MOVE go trail
    if ((matchre("$roomobjs $roomdesc", "\bpanel\b")) && ("%lastmoved" != "go panel")) then gosub MOVE go panel
    if ((matchre("$roomobjs $roomdesc", "\btent flap\b")) && ("%lastmoved" != "go flap")) then gosub MOVE go flap
    if (%moved == 1) then return
    if (matchre("$roomname", "(Ylono's Repairs|Catrox's Forge|Unspiek's Repair Shop|Kamze's Repair|Storage Shed)")) then gosub MOVE out
    if ((matchre("$roomobjs $roomdesc", "\bdoor")) && ("%lastmoved" != "go door")) then gosub MOVE go door
    if ((matchre("$roomobjs $roomdesc", "double door")) && ("%lastmoved" != "go door")) then gosub MOVE go door
    if ((matchre("$roomobjs $roomdesc", "\btrapdoor\b")) && ("%lastmoved" != "go trapdoor")) then gosub MOVE go trapdoor
    if ((matchre("$roomobjs $roomdesc", "\bcurtain\b")) && ("%lastmoved" != "go curtain")) then gosub MOVE go curtain
    if (%moved == 1) then return
    if ((matchre("$roomobjs $roomdesc", "\bnarrow track\b")) && ("%lastmoved" != "go track")) then gosub MOVE go track
    if ((matchre("$roomobjs $roomdesc", "\blava field\b")) && ("%lastmoved" != "go lava field")) then gosub MOVE go lava field
    if ((matchre("$roomobjs $roomdesc", "\bgate\b")) && ("%lastmoved" != "go gate")) then gosub MOVE go gate
    if ((matchre("$roomobjs $roomdesc", "\barch\b")) && ("%lastmoved" != "go arch")) then gosub MOVE go arch
    if ((matchre("$roomobjs $roomdesc", "\bexit\b")) && ("%lastmoved" != "go exit")) then gosub MOVE go exit
    if (%moved == 1) then return
    if ((matchre("$roomexits", "\bforward")) && ("%lastmoved" != "forward")) then gosub MOVE forward
    if ((matchre("$roomexits", "\baft\b")) && ("%lastmoved" != "aft")) then gosub MOVE aft
    if (%moved == 1) then return
    if ((matchre("$roomexits", "\bstarboard")) && ("%lastmoved" != "starboard")) then gosub MOVE starboard
    if ((matchre("$roomexits", "\bport\b")) && ("%lastmoved" != "port")) then gosub MOVE port
    if (%moved == 1) then return
    if ((matchre("$roomobjs $roomdesc", "\bledge\b")) && ("%lastmoved" != "go ledge")) then gosub MOVE go ledge
    if ((matchre("$roomobjs $roomdesc", "\bportal\b")) && ("%lastmoved" != "go portal")) then gosub MOVE go portal
    if ((matchre("$roomobjs $roomdesc", "\btunnel\b")) && ("%lastmoved" != "go tunnel")) then gosub MOVE go tunnel
    if (%moved == 1) then return
    if ((matchre("$roomobjs $roomdesc", "\bjagged crack\b")) && ("%lastmoved" != "go crack")) then gosub MOVE go crack
    if ((matchre("$roomobjs $roomdesc", "\bthe street\b")) && ("%lastmoved" != "go street")) then gosub MOVE go street
    if ((matchre("$roomobjs $roomdesc", "(?i)\ba gate\b")) && ("%lastmoved" != "go gate")) then gosub MOVE go gate
    if (%moved == 1) then return
    if ((matchre("$roomobjs $roomdesc", "\b(stairs|staircase|stairway)\b")) && ("%lastmoved" != "climb stair")) then gosub MOVE climb stair
    if ((matchre("$roomobjs $roomdesc", "\bsteps\b")) && ("%lastmoved" != "climb step")) then gosub MOVE climb step
    if (%moved == 1) then return
  }
  if (%moved == 0) then goto RANDOMMOVE_1
  return
### RANDOM CARDINAL DIRECTIONS ONLY
RANDOMMOVE_CARDINAL:
  delay %infiniteLoopProtection
  var moved 0
  math randomloop add 1
  if (%randomloop > 50) then {
    var lastmoved null
    var randomloop 0
    if (%verbose) then gosub ECHO Cannot find a room exit??
    if (%verbose) then gosub ECHO Attempting to Revert back..
    if (%verbose) then gosub ECHO Trying Alternate Methods..
    if (matchre("$roomobjs $roomdesc", "pitch black")) then gosub LIGHT_SOURCE
    gosub TRUE_RANDOM
    return
  }
  if (matchre("$roomname", "Deadman's Confide, Beach")) || ((matchre("$roomobjs", "thick fog")) || (matchre("$roomexits", "thick fog"))) then {
    gosub TRUE_RANDOM
    return
  }
  if (matchre("$roomname", "Temple Hill Manor, Grounds")) then {
    gosub MOVE go gate
    return
  }
  if (matchre("$roomname", "Darkling Wood, Ironwood Tree")) then {
    gosub MOVE climb pine branches
    return
  }
  if (matchre("$roomname", "Darkling Wood, Pine Tree")) then {
    gosub MOVE climb white pine
    return
  }
  if (matchre("$roomobjs", "strong creeper")) then {
    gosub MOVE climb ladder
    return
  }
  if (matchre("$roomobjs", "bank docks")) then {
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
  if ((%r == 9) && ($out)) then gosub MOVE out
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
  if ((%r == 8) && ($out)) then gosub MOVE out
  if ((%r == 9) && ($north) && ("%lastmoved" != "south")) then gosub MOVE north
  if ((%r == 10) && ($down) && ("%lastmoved" != "up")) then gosub MOVE down
  if ((%r == 11) && ($up) && ("%lastmoved" != "down")) then gosub MOVE up
  if (%moved == 1) then return
  if (%moved == 0) then goto RANDOMMOVE_CARDINAL
  return
### GO IN RANDOM DIRECTIONS, PREFER A SOUTHERN / WESTERN DIRECTION IF AVAILABLE
RANDOMMOVE_SOUTH:
  delay %infiniteLoopProtection
  var moved 0
  math randomloop add 1
  if (%randomloop > 5) then {
    put look
    pause %command_pause
    var lastmoved null
    var randomloop 0
    return
  }
  if $south then goto MOVE south
  if $southwest then goto MOVE southwest
  if $southeast then goto MOVE southeast
  if $northwest then goto MOVE northwest
  if $west then goto MOVE west
  if $north then goto MOVE north
  if $northeast then goto MOVE northeast
  if $east then goto MOVE east
  if $out then goto MOVE out
  if $up then goto MOVE up
  if $down then goto MOVE down
  if (%moved == 0) then goto RANDOMMOVE_SOUTH
  return
### TRUE RANDOM USED FOR MOVING IN PURE RANDOM DIRECTIONS REGARDLESS OF WHATS IN ROOM (FOG FILLED OR DARK ROOMS)
TRUE_RANDOM:
  delay %infiniteLoopProtection
  var moved 0
  math randomloop add 1
  if (%randomloop > 12) then {
    put look
    pause %command_pause
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
  if ((matchre("$roomobjs $roomdesc", "\bexit\b")) && ("%lastmoved" != "go exit")) then gosub MOVE go exit
  if ((matchre("$roomobjs $roomdesc", "\bdocks\b")) && ("%lastmoved" != "go dock")) then gosub MOVE go dock
  if ((matchre("$roomobjs $roomdesc", "\bpath\b")) && ("%lastmoved" != "go path")) then gosub MOVE go path
  if ((matchre("$roomobjs $roomdesc", "\btrapdoor\b")) && ("%lastmoved" != "go trapdoor")) then gosub MOVE go trapdoor
  if ((matchre("$roomobjs $roomdesc", "\bcurtain\b")) && ("%lastmoved" != "go path")) then gosub MOVE go curtain
  if ((matchre("$roomobjs $roomdesc", "\bdoor")) && ("%lastmoved" != "go door")) then gosub MOVE go door
  if ((matchre("$roomobjs $roomdesc", "\bgate")) && ("%lastmoved" != "go gate")) then gosub MOVE go gate
  if ((matchre("$roomobjs $roomdesc", "\barch")) && ("%lastmoved" != "go arch")) then gosub MOVE go arch
  if ((matchre("$roomobjs $roomdesc", "\barchway")) && ("%lastmoved" != "go archway")) then gosub MOVE go archway
  if (%moved == 1) then return
  if ((matchre("$roomobjs $roomdesc", "\bportal\b")) && ("%lastmoved" != "go portal")) then gosub MOVE go portal
  if ((matchre("$roomobjs $roomdesc", "\btunnel\b")) && ("%lastmoved" != "go tunnel")) then gosub MOVE go tunnel
  if ((matchre("$roomobjs $roomdesc", "\b(stairs|staircase|stairway)\b")) && ("%lastmoved" != "climb stair")) then gosub MOVE climb stair
  if ((matchre("$roomobjs $roomdesc", "\bsteps\b")) && ("%lastmoved" != "climb step")) then gosub MOVE climb step
  if (%moved == 1) then return
  if ((matchre("$roomobjs $roomdesc", "\bpanel\b")) && ("%lastmoved" != "go panel")) then gosub MOVE go panel
  if ((matchre("$roomobjs $roomdesc", "\bnarrow track\b")) && ("%lastmoved" != "go track")) then gosub MOVE go track
  if ((matchre("$roomobjs $roomdesc", "\bthe garden\b")) && ("%lastmoved" != "go garden")) then gosub MOVE go garden
  if ((matchre("$roomobjs $roomdesc", "\btent flap\b")) && ("%lastmoved" != "go flap")) then gosub MOVE go flap
  if ((matchre("$roomobjs $roomdesc", "\blava field\b")) && ("%lastmoved" != "go lava field")) then gosub MOVE go lava field
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
  put #echo %helpecho <~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~>
  put #echo %helpecho {              *** TRAVEL ERROR! ***  (version %version)             }
  put #echo %helpecho {  Either you did not enter a destination                                }
  put #echo %helpecho {  Or your destination is not recognized.  Please try again!             }
  put #echo %helpecho {                                                                        }
  put #echo %helpecho {  SYNTAX IS:                                                            }
  put #echo %helpecho {    .travel CITYNAME or .travel CITYNAME ROOMNUMBER/LABEL               }
  put #echo %helpecho {                                                                        }
  put #echo %helpecho {  EXAMPLES:                                                             }
  put #echo %helpecho {    .travel cross - Travel to Crossing                                  }
  put #echo %helpecho {    .travel cross 144 - Travel to crossing THEN move to room 144        }
  put #echo %helpecho {    .travel cross teller - Travel to Crossing THEN move to bank teller  }
  put #echo %helpecho {                                                                        }
  put #echo %helpecho {  Valid Destinations are:                                               }
  put #echo %helpecho {  ZOLUREN:                                                              }
  put #echo %helpecho {    Crossing | Arthe Dale | West Gate | Tiger Clan | Wolf Clan          }
  put #echo %helpecho {    Dokt | Knife Clan | Kaerna | Stone Clan | Caravansary               }
  put #echo %helpecho {    Dirge | Ushnish | Sorrow's | Beisswurms | Misenseor                 }
  put #echo %helpecho {    Leucros | Vipers | Buccas | Alfren's Ferry | Leth Deriel            }
  put #echo %helpecho {    Ilaya Taipa  |  Acenemacra                                          }
  put #echo %helpecho {                                                                        }
  put #echo %helpecho {  THERENGIA:                                                            }
  put #echo %helpecho {    Riverhaven | Rossmans | Langenfirth | El'Bains | Therenborough      }
  put #echo %helpecho {    Rakash | Fornsted | Zaulfung | Throne City                          }
  put #echo %helpecho {    Hvaral | Haizen | Oasis | Yeehar | Muspar'i                         }
  put #echo %helpecho {                                                                        }
  put #echo %helpecho {  ILITHI:                                                               }
  put #echo %helpecho {    Shard | Horse Clan | Fayrin's Rest  Steelclaw Clan | Spire          }
  put #echo %helpecho {    Corik's Wall | Ylono | Granite Gargoyles | Gondola                  }
  put #echo %helpecho {    Bone Wolves | Germishdin | Fang Cove | Wyvern Mountain              }
  put #echo %helpecho {                                                                        }
  put #echo %helpecho {  FORFEDHDAR:                                                           }
  put #echo %helpecho {    Inner Hib | Hibarnhvidar | Boar Clan                                }
  put #echo %helpecho {    Raven's Point | Ain Ghazal| Outer Hib                               }
  put #echo %helpecho {                                                                        }
  put #echo %helpecho {  QI:                                                                   }
  put #echo %helpecho {    Aesry Surlaenis'a | Ratha | M'riss | Taisgath                       }
  put #echo %helpecho {    Mer'Kresh | Hara'jaal (TF ONLY)                                     }
  put #echo %helpecho <~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~>
  exit

RETURN_CLEAR:
  delay %infiniteLoopProtection
  put #queue clear
  return

####  CLIMBING BUFFS  ####
BUFFCLIMB:
  if (("$guild" == "Thief") && ($Athletics.Ranks < 600)) then gosub PUT khri flight harrier
  if (("$guild" == "Ranger") && ($Athletics.Ranks < 600)) then {
    gosub PUT prep athlet 10
    pause 10
    gosub PUT cast
  }
  return
####