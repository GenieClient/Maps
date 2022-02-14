#debuglevel 10
put #class racial off
put #class rp off
put #class arrive off
put #class combat off
put #class joust off

# automapper.cmd version 7.6

# last changed: Feb 5, 2022

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
#
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
# debuglevel 10
ABSOLUTE_TOP:
# Type ahead declaration
# ---------------
# The following will use a global to set it by character.  This helps when you have both premium and standard accounts.
# Standard Account = 1, Premium Account = 2, LTB Premium = 3
     if !def(automapper.typeahead) then var typeahead.max 1
     else var typeahead.max $automapper.typeahead
	 var typeahead 0
     if !def(caravan) then put #tvar caravan 0
     if !def(mapwalk) then put #tvar mapwalk 0
     if !def(powerwalk) then put #tvar powerwalk 0
     if !def(searchwalk) then put #tvar searchwalk 0
     if !def(drag) then put #tvar drag 0
     # ---------------
     action var current_path %0 when ^You go
     if ($mapwalk) then
          {
               put get my map
               waitforre ^You get|^You are already holding
          }
     var removed 0
     var checked 0
     var slow_on_ice 0
     var closed 0
     var movewait 0
     var startingStam $stamina
     var failcounter 0
     var depth 0
     var movewait 0
     var closed 0
     var checked 0
     var slow_on_ice 0
     var wearingskates 0
     var move_TORCH You push up on the (stone basin|torch)\, and the stone wall closes\.
     var move_OK ^Obvious (paths|exits)|^It's pitch dark|The shop appears to be closed\, but you catch the attention of a night attendant inside\,
     var move_FAIL ^You can't swim in that direction|You can't go there|^A powerful blast of wind blows you to the|^What were you referring to|^I could not find what you were referring to\.|^You can't sneak in that direction|^You can't ride your.+(broom|carpet) in that direction|^You can't ride your.+(broom|carpet) in that direction|^You can't ride that way\.$
     var move_RETRY_GO ^You can't climb that\.$
     var move_RETRY ^\.\.\.wait|^Sorry, you may only|^Sorry, system is slow|^You can't ride your.+(broom|carpet) in that direction|^You can't ride your.+(broom|carpet) in that direction|^The weight of all|lose your balance during the effort|^You are still stunned|^You're still recovering from your recent|^The mud gives way beneath your feet as you attempt to climb higher, sending you sliding back down the slope instead\!|You're not sure you can
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
     # ---------------
     gosub actions
     goto loop
     # ---------------
     
actions:
     action (mapper) if %movewait = 0 then shift;if %movewait = 0 then math depth subtract 1;if len("%2") > 0 then echo Next move: %2 when %move_OK
     action (mapper) goto move.torch when %move_TORCH
     action (mapper) goto move.failed when %move_FAIL
     action (mapper) goto move.retry.go when %move_RETRY_GO
     action (mapper) goto move.retry when %move_RETRY|%move_WEB
     action (mapper) goto move.stand when %move_STAND
     action (mapper) goto move.pause when %move_PAUSE
     action (mapper) var movewait 1;goto move.wait when %move_WAIT
     action (mapper) goto move.retreat when %move_RETREAT
     action (mapper) var movewait 0 when %move_END_DELAY
     action (mapper) var closed 1;goto move.closed when %move_CLOSED
     action (mapper) goto move.nosneak when %move_NO_SNEAK
     action (mapper) goto move.go when %move_GO
     action (mapper) goto move.invis when %move_INVIS
     action (mapper) goto move.dive when %move_DIVE
     action (mapper) goto move.muck when %move_MUCK
     action (mapper) goto move.stow when %move_STOW
     action (mapper) goto move.boat when %move_BOAT
     action (mapper) echo Will re-attempt climb in 5 seconds...;send 5 $lastcommand when ^All this climbing back and forth is getting a bit tiresome\.  You need to rest a bit before you continue\.$
     action (mapper) goto move.retry when %swim_FAIL
     action (mapper) goto move.drawbridge when %move_DRAWBRIDGE
     action (mapper) goto move.knock when The gate is closed\.  Try KNOCKing instead
     action (mapper) goto move.rope.bridge when %move_ROPE.BRIDGE
     action (mapper) goto move.fatigue when %move_FATIGUE
     action (mapper) goto move.climb.mount.fail when %climb_mount_FAIL
     action (mapper) goto move.kneel when maybe if you knelt down first\?
     action (mapper) goto move.lie when ^The passage is too small to walk that way\.  You'll have to get down and crawl\.|There's just barely enough room here to squeeze through, and no more.
     action (mapper) var footitem $1;goto stowfootitem when ^You notice an|a?(?:(?:\s\b\w+\B)?(?:intricately|etched|polished|carved|engraved)*).*?(\S+) (?:(?=acid-etched|accented|adorned|affixed|appliqued|attached|balanced|banded|bearing|bound|branded|braided|caked|carved|chased|chisled|cloaked|clutching|coated|constructed|connected|covered|crafted|crested|crowned|dangling|decorated|deformed|designed|detailed|displaying|draped|dyed|embedded|embellished|embroidered|enblazoned|enbossed|encrusted|engraved|enhanced|entitled|etched|fashioned|festooned|featuring|filed|filled|firestained|fitted|flecked|fletched|flaunting|forged|formed|from|gleaming|hewn|highlighted|hilted|hung|in|incised|inlaid|inscribed|inset|intricately|joined|labeled|lavishly|lined|linked|made|marked|mottled|mounted|of|ornamented|padded|painted|polished|reinforced|resembling|rimed|rivited|scattered|scarred|scorched|sealed|set|shaped|shod|spiraled|stamped|stitched|streaked|strung|studded|surmounted|swathed|tangled|tethered|that|tied|tinged|tinted|titled|that|tipped|tooled|topped|trimmed|veined|whorled|wrapped|wrought|with).*)?(?:lying )?at your feet, and do not wish to leave it behind\.
     action (skates) var wearingskates 1 when ^You slide your ice skates on your feet and tightly tie the laces\.|^Your ice skates help you traverse the frozen terrain\.|^Your movement is hindered a little by your ice skates\.
     action (skates) var wearingskates 0 when ^You untie your skates and slip them off of your feet\.
     action var slow_on_ice 1; echo Ice detected! when ^You had better slow down\! The ice is|^At the speed you are traveling
     action goto jailed when a sound not unlike that of a tomb|binds you in chains|firmly off to jail|drag you off to jail|brings you to the jail|the last thing you see before you black out|your possessions have been stripped|You are a wanted criminal, $charactername
     action goto jailed when your belongings have been stripped|in a jail cell wearing a set of heavy manacles|strip you of all your possessions|binds your hands behind your back|Your silence shall be taken as an indication of your guilt|The eyes of the court are upon you|Your silence can only be taken as evidence of your guilt
     return
loop:
     gosub wave
     delay 0.1
     goto loop
wave:
     delay 0.0001
     if (%depth > 0) then return
     if_1 goto wave_do
     goto done
wave_do:
     delay 0.01
     var depth 0
     if_1 gosub move %1
     if %typeahead < 1 then 
	 {	
          if %typeahead < %typeahead.max then math typeahead add 1
          return
	 }
     delay 0.01
     if_2 gosub move %2
     if %typeahead < 2 then 
	 {	
          if %typeahead < %typeahead.max then math typeahead add 1
          return
	 }
     delay 0.01
     if_3 gosub move %3
     if %typeahead < 3 then 
	 {	
          if %typeahead < %typeahead.max then math typeahead add 1
          return
	 }
     delay 0.01
     if_4 gosub move %4
     if %typeahead < 4 then 
	 {	
          if %typeahead < %typeahead.max then math typeahead add 1
          return
	 }
     delay 0.01
     if_5 gosub move %5
     return
done:
     pause 0.001
     if ($standing = 0) then gosub STAND
     put #parse YOU HAVE ARRIVED!
     put #class arrive off
     exit
move:
     math depth add 1
     var movement $0
     var type real
move1:
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
                                   if matchre("%movement", "go ([\S ]+)") then
                                        {
                                             var movement sneak $1
                                        }
                                   else
                                        {
                                             var movement sneak %movement
                                        }
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
     goto move.%type
move.real:
     if (%wearingskates) then
          {
               pause 0.001
               pause 0.001
               pause 0.001
               put remove my skates
               wait
               put stow my skates
               wait
               pause 0.1
               var wearingskates 0
          }
     if (%removed) then
          {
               action (mapper) off
               var removed 0
               echo *** Putting your footwear back on ****
               pause 0.001
               pause 0.001
               put get my %item
               wait
               put wear my %item
               wait
               pause 0.1
               action (mapper) on
          }
     if (("$zoneid" = "62") && ("$game" = "DRF")) then
          {
               if "$roomid" = "41" && "%movement" = "southwest" then
                    {
                         pause 0.0001
                         pause 0.0001
                         move southwest
                         move south
                         math depth subtract 2
                         goto return
                    }
          }
     put %movement
     goto return
move.power:
     if (%depth > 1) then waiteval (1 = %depth)
     put %movement
     nextroom
	 if (($Attunement.LearningRate = 34) || ($Attunement.Ranks = 1750)) then goto MOVE.DONE
     matchre MOVE.DONE ^\s*Roundtime\s*\:?
     matchre MOVE.DONE ^\s*\[Roundtime\s*\:?
     matchre MOVE.DONE ^\s*\(Roundtime\s*\:?
     matchre MOVE.DONE ^Something in the area is interfering
	 matchre MOVE.DONE ^You feel an extremely pervasive ward 
     put perceive
     matchwait
move.room:
     if (%depth > 1) then waiteval (1 = %depth)
     put %movement
     nextroom
     goto move.done
move.stow:
     if ("$righthand" != "Empty") then put stow right
     if ("$lefthand" != "Empty") then put stow left
     pause 0.1
     if ("$righthand" != "Empty") then put unload $righthandnoun
     pause 0.2
     if matchre("$righthand", "khuj|staff|atapwi") then put wear $righthandnoun
     if ("$righthand" != "Empty") then put stow right
     pause 0.2
     pause 0.2
     put %movement
     pause 0.1
     goto move.done
move.boat:
     matchre move.boat.arrived ^The galley (\w*) glides into the dock
     matchwait 60
     put look
     goto move.boat
move.boat.arrived:
     put %movement
     pause 0.1
     goto move.done
move.ice:
     if (%depth > 1) then waiteval (1 = %depth)
     if (!%checked) then gosub skate.check
     if (%slow_on_ice) then gosub ice.collect
     put %movement
     nextroom
     goto move.done
skate.check:
     var checked 1
     action (mapper) off
     pause 0.01
     echo *** Checking for Ice Skates! ***
     matchre skate.yes ^You tap
     matchre skate.check.2 ^I could not|^What were you
     put tap my skate
     matchwait 7
skate.check.2:
     var checked 1
     action (mapper) off
     pause 0.01
     echo *** Checking for Ice Skates! ***
     matchre skate.yes ^You tap
     matchre skate.no ^I could not|^What were you
     put tap my skate in my watery portal
     matchwait 7
skate.no:
     var slow_on_ice 1
     var wearingskates 0
     action (mapper) on
     echo **** No ice skate support for you! 
     echo **** Collecting rocks in every room like the other peasants
     return
skate.yes:
     action (mapper) off
     echo *** Winner! Ice Skates Found! ***
     echo
footwear.check:
     echo *** Checking current footwear.. ***
     pause 0.1
     matchre footware.remove (boots?|shoes?|moccasins?|sandals?|slippers?|mules|workboots?|footwraps?|footwear|spats?|chopines?|nauda|booties|clogs|buskins?|cothurnes?|galoshes)
     matchre footware.remove (half-boots?|ankle-boots?|gutalles?|hessians?|brogans?|toe ring|toe bells?|toe-bells?|toe-ring|loafers?|pumps?)
     matchre footwear.none ^You aren't wearing anything like that
     matchre wearing.skates skates
     put inv feet
     matchwait 8
     echo **** Error! Do not recognize your footwear!
     goto skate.no
footware.remove:
     var item $0
     var removed 1
     echo *** Removing: %item
     pause 0.2
     pause 0.1
     put remove my %item
     pause 0.5
     put stow my %item
     pause 0.5
     pause 0.1
footwear.none:
skate.get:
     pause 0.001
	match wear.skates You get
	match footwear.stow You need a free hand
     matchre skate.get.2 ^I could not|^What were you
     put get my skates
	matchwait 5
skate.get.2:
     pause 0.001
	match wear.skates You get
	match footwear.stow You need a free hand
     matchre skate.no ^I could not|^What were you
     put get my skates from my watery portal
	matchwait 5
footwear.stow:
	put stow left
	goto skate.get
wear.skates:
     pause 0.2
     pause 0.1
     put wear my skates
     wait
wearing.skates:
     pause 0.1
     var wearingskates 1
     var slow_on_ice 0
     action (mapper) on
     return
ice.collect.p:
     pause 0.5
ice.collect:
     pause 0.1
     action (mapper) off
     echo *** Collecting rocks and pausing so we don't slip and crack our head open..
     matchre ice.collect ^\.\.\.wait|^Sorry\,
     matchre ice.return ^\s*Roundtime\s*\:?
     matchre ice.return ^\s*\[Roundtime\s*\:?
     matchre ice.return ^\s*\(Roundtime\s*\:?
     put collect rock
     matchwait
ice.return:
     var slow_on_ice 0
     pause 0.5
     echo ** Pausing....
     pause 4
     pause 5
     action (mapper) on
     return
move.knock:
     matchre shard.failed Sorry\, you\'re not a citizen
     matchre move.done %move_OK|All right, welcome back|opens the door just enough to let you slip through|wanted criminal
     matchre turn.cloak I can't see your face
     matchre stop.invis The gate guard can't see you
     put knock gate
     matchwait 10
shard.failed:
     if !matchre("$zoneid", "(66|67|68|69)") then goto move.failed
     matchre move.done YOU HAVE ARRIVED\!
     put .sharddetour
	matchwait 45
     goto move.done
stop.invis:
     if ("$guild" = "Thief") then put khri stop silence vanish
     if ("$guild" = "Necromancer") then put release eotb
     if ("$guild" = "Moon Mage") then put release rf
     pause 0.5
     pause 0.2
     goto move.knock
turn.cloak:
     pause 0.1
     matchre turn.cloak ^\.\.\.wait|^Sorry\,
     matchre turn.cloak ^You pull your cloak
     matchre remove.cloak ^You attempt to
     matchre move.knock ^You pull down your
     put turn my cloak
     matchwait 10
     goto move.knock
remove.cloak:
     pause 0.1
     pause 0.1
     put remove my cloak
     pause 0.5
     goto move.knock
move.drag:
move.sneak:
move.swim:
move.rt:
####added this to stop trainer
     pause 0.1
     pause 0.1
     if (%depth > 1) then waiteval (1 = %depth)
     eval movement replacere("%movement", "script crossingtrainerfix ", "")
     put %movement
     pause 0.1
     goto move.done
move.torch:
     action (mapper) off
     pause 0.1
     echo *** RESETTING STONE WALL
     pause 0.3
     pause 0.1
     if ($roomid = 264) then send turn torch on wall
     if ($roomid = 263) then send turn basin on wall
     action (mapper) on
     pause 0.3
     pause 0.1
     put go wall
     goto move.done     
move.web:
     if ($webbed) then waiteval (!$webbed)
     pause 0.1
     put %movement
     pause 0.1
     pause 0.1
     goto move.done
move.muck:
     action (mapper) off
     pause
     if (!$standing) then put stand
     matchre move.muck ^You struggle to dig|^Maybe you can reach better that way, but you'll need to stand up for that to really do you any good\.
     matchre move.muck.done ^You manage to dig|^You will have to kneel closer|^You stand back up.|^You fruitlessly dig
     put dig
     matchwait
move.muck.done:
     action (mapper) on
     goto return.clear
move.slow:
     pause 3
     goto move.real
move.climb:
     matchre move.done %move_OK
     matchre move.climb.mount.fail climb what\?
     matchre move.climb.with.rope %climb_FAIL
     if $broom_carpet = 1 then eval movement replacere("%movement", "climb ", "go ")
     put %movement
     matchwait
move.climb.mount.fail:
     matchre move.done %move_OK
     if $broom_carpet = 1 then eval movement replacere("%movement", "climb ", "go ")
     put %movement
     matchwait
move.climb.with.rope:
     action (mapper) off
     if !matchre("$righthand|$lefthand", "braided heavy rope") then
          {
               pause 0.001
               pause 0.1
               put get my braided rope
               pause 0.2
          }
     if !matchre("$righthand|$lefthand", "heavy rope") then
          {
               pause 0.001
               pause 0.1
               put get my heavy rope
               pause 0.2
          }
     action (mapper) on
     if (("$guild" = "Thief") && ($concentration > 50)) then
          {
               put khri flight focus
               pause 2
               pause 0.5
          }
     pause 0.001
     if matchre("$righthand|$lefthand", "heavy rope") then goto move.climb.with.app.and.rope
     matchre stow.rope %move_OK
     matchre move.climb.with.app.and.rope %climb_FAIL
     put %movement with my rope
     matchwait
move.climb.with.app.and.rope:
     eval climbobject replacere("%movement", "climb ", "")
     put appraise %climbobject quick
     waitforre ^Roundtime:|^You cannot appraise that when you are in combat
     if (("$guild" = "Thief") && ($concentration > 50)) then
          {
               pause 0.001
               put khri flight focus
               pause 2
               pause 0.5
          }
     matchre stow.rope %move_OK
     matchre move.climb.with.app.and.rope %climb_FAIL
     put %movement with my rope
     matchwait
stow.rope:
     if matchre("$righthandnoun|$lefthandnoun", "rope") then
          {
               pause 0.1
               put stow my rope
               pause 0.5
               pause 0.5
          }
     goto move.done
move.search:
     put search
     pause $roundtime
     pause 0.3
     pause 0.1
     put %movement
     pause 0.2
     goto move.done
move.objsearch:
     put search %searchObj
     pause 0.5
     pause 0.1
     if $broom_carpet = 1 then eval movement replacere("%movement", "climb ", "go ")
     put %movement
     pause 0.2
     goto move.done
move.script:
     if (%depth > 1) then waiteval (1 = %depth)
     action (mapper) off
     match move.script.done MOVE SUCCESSFUL
     match move.failed MOVE FAILED
     put .%movement
     matchwait
move.script.done:
     shift
     math depth subtract 1
     if (len("%2") > 0) then echo Next move: %2
     action (mapper) on
     goto move.done
move.pause:
     pause 0.3
     pause 0.1
     put %movement
     pause 0.5
     pause 0.5
     pause 0.2
     goto move.done
move.fatigue:
     echo *** TOO FATIGUED TO CLIMB! ***
fatigue.check:
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
move.invis:
     pause 0.001
     if ("$guild" = "Thief") then put khri stop silence vanish
     if ("$guild" = "Necromancer") then put release eotb
     if ("$guild" = "Moon Mage") then put release rf
     pause 0.3
     pause 0.2
     put %movement
     pause 0.5
     goto move.done
fatigue.wait:
     if ($stamina > 55) then
          {
               put %movement
               pause
               goto move.done
          }
     echo *** Pausing to recover stamina
     pause 10
     goto fatigue.wait
move.stairs:
move.wait:
     pause 0.2
     if (%movewait) then
          {
               matchre MOVE.DONE ^You reach|you reach|^Just when it seems
               matchwait
          }
     goto move.done
move.stand:
     action (mapper) off
     pause 0.5
     matchre move.stand %move_RETRY|^Roundtime|^You are so unbalanced|^You are still
     matchre return.clear ^You stand back up
     matchre return.clear ^You are already standing
     put stand
     matchwait
move.retreat:
     pause 0.0001
     pause 0.0001
     action (mapper) off
     if (!$standing) then put stand
     if ($hidden) then put unhide
     matchre move.retreat %move_RETRY|^Roundtime|^You retreat back
     matchre move.retreat.done ^You retreat from combat|^You sneak back out of combat
     matchre move.retreat.done ^You are already as far away as you can get
     put retreat
     matchwait
move.retreat.done:
     pause 0.0001
     pause 0.0001
     action (mapper) on
     goto return.clear
move.dive:
     if $broom_carpet = 1 then
          {
               eval movement replacere("%movement", "dive ", "")
               put go %movement
          }
     else put dive %movement
     goto move.done
move.go:
     put go %movement
     goto move.done
move.kneel:
     put kneel
     put %movement
     goto move.done
move.lie:
	put lie
	put %movement
	goto move.done
move.nosneak:
     if (%closed) then goto move.closed
     eval movement replacere("%movement", "sneak ", "")
     put %movement
     goto move.done
move.drawbridge:
     waitforre ^Loose chains clank as the drawbridge settles on the ground with a solid thud\.
     put %movement
     goto move.done
move.rope.bridge:
     action instant put retreat;put retreat when melee range|pole weapon range
     waitforre finally arriving|finally reaching
     action remove melee range|pole weapon range
     put %movement
     goto move.done
move.retry:
     echo
     echo *** Retry movement
     echo
     if ($webbed) then waiteval (!$webbed)
     if ($stunned) then
          {
               pause
               goto move.retry
          }
     pause 0.5
     goto return.clear
move.retry.go:
     echo
     echo *** Retry movement
     echo
     eval movement replacere("%movement", "climb ", "go ")
     if ($webbed) then waiteval (!$webbed)
     if ($stunned) then
          {
               pause
               goto move.retry
          }
     pause 0.5
     goto move.rt
move.closed:
     echo
     echo ********************************
     echo SHOP IS CLOSED FOR THE NIGHT!
     echo ********************************
     echo
     put #parse SHOP IS CLOSED
     put #parse SHOP CLOSED
     exit
jailed:
     echo
     echo ********************************
     echo    GOT THROWN IN JAIL!
     echo    ABORTING AUTOMAPPER
     echo ********************************
     echo
     put #parse JAILED
     put #parse NAILED AND JAILED!
     put #parse THROWN IN JAIL
     exit
move.failed:
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
     eval remaining_path replace ("%0", " ", "|")
     echo %remaining_path(1)
     echo %remaining_path(2)
     pause 0.1
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
     if (%type = "search") then put %type
     pause
     echo [Moving: %movement]
     put %movement
     matchwait 5
end_retry:
     pause
     goto return.clear
caravan:
     waitforre ^Your .*\, following you\.
     gosub clear
     goto loop
POWERWALK:
     pause 0.2
     matchre POWERWALK ^\.\.\.wait|^Sorry\,
     matchre POWERWALK.DONE ^\s*Roundtime\s*\:?
     matchre POWERWALK.DONE ^\s*\[Roundtime\s*\:?
     matchre POWERWALK.DONE ^\s*\(Roundtime\s*\:?
     matchre POWERWALK.DONE ^Something in the area is interfering
     put perceive
	matchwait
POWERWALK.DONE:
     gosub clear
     goto loop
SEARCHWALK:
     pause
     send search
     wait
	pause
     gosub clear
     goto loop
SEARCHWALK.DONE:
foragewalk:
     pause 0.2
     put forage $forage
     waitforre ^Roundtime|^Something in the area is interfering
     gosub clear
     goto loop
mapwalk:
     pause
     put study my map
     waitforre ^The map has a large 'X' marked in the middle of it
     gosub clear
     goto loop
return.clear:
     action (mapper) on
     var depth 0
     gosub clear
     goto loop
move.done:
     if ($caravan) then
          {
               goto caravan
          }
     if ($powerwalk) then
          {
               if (($Attunement.LearningRate = 34) || ($Attunement.Ranks = 1750)) then put #var powerwalk 0
               goto powerwalk
          }
     if ($searchwalk) then
          {
               goto SEARCHWALK
          }
     if ($mapwalk) then
          {
               goto mapwalk
          }
     if matchre("($righthand|$lefthand)", "cloak") then
          {
               pause 0.1
               put wear my cloak
               pause 0.3
               pause 0.2
          }
     gosub clear
     goto loop
return:
     pause 0.001
     if ($standing = 0) then gosub STAND
     if ($caravan) then
          {
               goto caravan
          }
     if ($powerwalk) then
          {
               if (($Attunement.LearningRate = 34) || ($Attunement.Ranks = 1750)) then put #var powerwalk 0
               goto powerwalk
          }
     if ($searchwalk) then
          {
               goto SEARCHWALK
          }
     if ($mapwalk) then
          {
               goto mapwalk
          }
     var movewait 0
     return
stowfootitem:
     #debug 10
     pause 0.001
     if matchre("%footitem", "(mat|rug|cloth|tapestry)") then
          {
               put roll %footitem
               pause 0.5
          }
	if !matchre("Empty", "$lefthand|$righthand") then put stow left
     pause 0.1
     put stow feet
     pause 0.2
     pause 0.1
     put stow feet
     pause 0.2
     pause 0.2
     goto ABSOLUTE_TOP
STAND:
     pause 0.001
     pause 0.1
     var LOCATION STAND_1
     STAND_1:
     pause 0.001
     matchre STAND ^\.\.\.wait|^Sorry\,|^Please wait\.
     matchre STAND ^Roundtime\:?|^\[Roundtime\:?|^\(Roundtime\:?|^\[Roundtime|^Roundtime
     matchre STAND ^The weight of all your possessions prevents you from standing\.
     matchre STAND ^You are overburdened and cannot manage to stand\.
     matchre STAND ^You\'re unconscious\!
     matchre DONE ^You are a ghost\!
     matchre STAND ^You are still stunned
     matchre STAND ^You can't do that while entangled in a web
     matchre STAND ^You don't seem to be able to move to do that
     matchre STAND_RETURN ^You stand (?:back )?up\.
     matchre STAND_RETURN ^You stand up in the water
     matchre STAND_RETURN ^You are already standing\.
     matchre STAND_RETURN ^As you stand
     send stand
     matchwait 20
     STAND_RETURN:
     pause 0.1
     pause 0.1
     if ($standing = 0) then goto STAND
     return 