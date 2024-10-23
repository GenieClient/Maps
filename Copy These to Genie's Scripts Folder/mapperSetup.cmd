#mapperSetup.cmd
# all the vars
# this file will let you set all travel and automapper global variables in one place
# it's also got macros and aliases so give it a read!

####  AUTOMAPPER Setup!  ####
#Use the command line to set the following preferences:
#  Typeahead
#    Standard Account = 1, Premium Account = 2, LTB Premium = 3
#    0: wait for correct confirmation of sent commands
put#var automapper.typeahead 1
#  Pause
#    Time to pause before sending a "put x" command
#var automapper.pause 0.01
#  Infinite Loop Protection
#    Increase if you get infinte loop errors
#var automapper.loop 0.001
#  Waiteval Time Out
#    prevents waiting forever for wave to collapse
#var automapper.wavetimeout 15
#  Echoes
#    how verbose do you want automapper to be?
#var automapper.verbose 1
#  Ice Road Behavior
#    1: collect rocks on the ice road when lacking skates
#    0: just wait 15 seconds with no RT instead
#var automapper.iceroadcollect 1
#  Cyclic Spells
#    1: Turn off cyclic spells before moving
#    0: Leave cyclic spells running while moving
#var automapper.cyclic 1
#  Color
#    What should the default automapper echo color be?
#var automapper.color #33CC99
#  Class
#    Which classes should automapper turn on and off?
#var automapper.class -arrive -combat -joust -racial -rp
#  Brooms, Carpets, and Clouds, OH MY!
#    Do you have a special movement item you want to use?
#var automapper.broom_carpet
#  Cyclic handling
#    Release cyclics so you don't get arrseted?
#var automapper.ReleaseCyclics True
####  Welcome to automapper walk help!  ####
# Related macros
# ---------------
# Add the following macro for toggling Power Walking:
put #macro {P, Control} {#if {$powerwalk = 1}{#tvar powerwalk 0;#echo *** Power Walking off}{#tvar powerwalk 1;#echo *** Power Walking on}}
#
# Add the following macro for toggling Sigil Walking:
put #macro {G, Control} {#if {$automapper.sigilwalk = 1}{#tvar automapper.sigilwalk 0;#echo *** Sigil Walking off}{#tvar automapper.sigilwalk 1;#echo *** Sigil Walking on}}
#
# Add the following macro for toggling Caravans:
put #macro {C, Control} {#if {$caravan = 1}{#tvar caravan 0;#echo *** Caravan Following off}{#tvar caravan 1;#echo *** Caravan Following on}}
#
# Follow this same process for `mapwalking`, `searchwalking`, `automapper.userwalk`
##  USER Walking: this can do whatever you'd like!
#      you MUST define globals
put #var automapper.UserWalkAction ~~SoMeAcTiOn~~
put #var automapper.UserWalkSuccess ~~TeXtToMaTcH~~
#      you MAY define global
#  Stop and heal at vela'thor plants
#   Best to set this on a temporary basis
#   put #var automapper.seekhealing 1
# ---------------
####  Related aliases  ####
# Add the following aliases for toggling dragging:
# #alias {drag0} {#tvar drag 0;#unvar drag.target}
# #alias {drag1} {#tvar drag 1;#tvar drag.target $0}
# Add the following aliases for toggling treasure map mode:
# #alias {map0} {#tvar mapwalk 0}
# #alias {map1} {#tvar mapwalk 1}
# Repeat this style as needed for other walk types

####  TRAVEL Setup!  ####
if matchre("$client", "Genie") then var helpecho #33CC99 mono
if matchre("$client", "Outlander") then var helpecho #33CC99
if matchre("%1", "help|HELP|Help|^$") then {
  put #echo %helpecho <~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~>
Welcome to travel Setup!   (version %version)
Use the command line to set the following preferences:
  Pause
    Time to pause before sending a "put x" command
#var automapper.pause 0.01
  Infinite Loop Protection
    Increase if you get infinte loop errors
#var automapper.loop 0.001
  Waiteval Time Out
    prevents waiting forever for wave to collapse
#var automapper.wavetimeout 15
  Cyclic Spells
    1: Turn off cyclic spells before moving
    0: Leave cyclic spells running while moving
#var automapper.cyclic 1
  Color
    What should the default automapper echo color be?
#var automapper.color #33CC99
  Are you traveling with a group of capped characters?
    Are you bold enough to risk group breaking anyway?
#var TRAVEL.GroupShortCutsAnyway True
  Echoes
    how verbose do you want .travel to be?
#var TRAVEL.verbose True

Ranks to use Rossman's shortcut to swim the Jantspyre River
  North is ~safe~ around 200 and POSSIBLE ~175 W/ no armor
  South is much easier, safe at ~90
#var TRAVEL.RossmanNorth 200
#var TRAVEL.RossmanSouth 90

Ranks to swim the Faldesu River - Haven <-> NTR
  Safe ~ 190
  Possible ~ 160+ w/ no burden/buffs
#var TRAVEL.Faldesu 190

Ranks to swim the Segoltha River - Tiger/Crossing <-> STR
  Safe ~ 550
  Possible ~ 530+ w/ no burden/buffs
#var TRAVEL.Segoltha 550

Ranks to climb Under Gondola shortcut
  Safe ~ 510
  Possible ~ 480+ w/ buffs and a rope
#var TRAVEL.UnderGondola 515

Ranks to use 5th passage, Under-Segoltha (THIEF only)
  Safe ~ 50
  Possible ~ 35 w/ no burden/buffs
#var TRAVEL.UnderSegoltha 515

Ranks for Velka Desert Shortcut - Hvaral <-> Muspar'i
  THIS IS THE HARDEST SHORTCUT IN THE GAME
  FRIENDS DON'T LET FRIENDS WALK TO MUSPAR'I, USE THE BLIMP
  Safe ~ 800
  Possible ~ 760 w/ buffs
#var TRAVEL.muspari 2000

try `.automapper help` for help with automapper variables
  there is commonality-these variables will affect how travel works
    as it manages automapper
Now save! (#save vars for Genie | cmd-s for Outlander)
  put #echo %helpecho <~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~>
