#mapperINC.cmd
# THE include script for automapper.cmd and travel.cmd
var version 1.2024-10-17
goto mapperINCreturn

#2024-10-17
# Hanryu
#   take subs that overlap from travel and automapper and pull them into a common include
#   initial release
#   THIS_IS_A_LABEL:
#   aLocalVar

#### check citizenship for shard ####
#  you do have to ask about titles to get them, so you could be a citizen and not know it
CITIZENSHIP:
  put #var citizenship none
  action (citizenship) put #var citizenship $1 when "^\s*\d\)\s+of (Aesry Surlaenis'a|Forfedhdar|Ilithi|M'Riss|Ratha|Therengia|Velaka|Zoluren|Acenamacra|Arthe Dale|Crossing|Dirge|Ilaya Taipa|Kaerna Village|Leth Deriel|Fornsted|Hvaral|Langenfirth|Riverhaven|Rossman's Landing|Siksraja|Therenborough|Fayrin's Rest|Shard|Steelclaw Clan|Zaldi Taipa|Ain Ghazal|Boar Clan|Hibarnhvidar|Raven's Point|Mer'Kresh|Muspar'i)"
  put title affiliation list
  send encumbrance
  waitfor Encumbrance :
  action (citizenship) off
  return
####
#### set premie status ####
PREMIUM_CHECK:
  gosub ECHO Checking Premium
  match PREMIUM_YES Account Status: Premium
  match PREMIUM_NO Current Account Status: Basic
  match PREMIUM_NO Current Account Status: F2P
  put played
  matchwait 5
  goto PREMIUM_NO
PREMIUM_NO:
  put #var premium 0
  return
PREMIUM_YES:
  put #var premium 1
  gosub ECHO Premium Enabled!
  if !matchre("$game", "DRX") then return
PREMIUM_TIME:
  var premtime 0
  matchre PREMIUM_SET ^You have a cumulative Premium time of (\d+) months\.
  matchre PREMIUM_SET ^You have a cumulative Platinum time of (\d+) months\.
  put premium 10
  matchwait 5
  return
PREMIUM_SET:
  var premtime $1
  if (%premtime >= 6) then {
    var portal 1
    if matchre("$game", "DRX") then gosub ECHO Using Plat Portals!
  }
  return
####
#### Universal formatted echo ####
#### gosub ECHO Some Line
#### gosub ECHO Some|multi|line text|box
#### initial idea by Hanryu, Jon fixed it for genie
ECHO:

debug 0

  var echoVar $0
  if !matchre("%echoVar", "\|") then {
    eval border replacere("%echoVar", ".", "~")
    put #echo
    put #echo %color <~~%border~~>
    put #echo %color {  %echoVar  }
    put #echo %color <~~%border~~>
    put #echo

debug 5

    return
  } else {
    eval echoVarLines count("%echoVar", "|")
    var c 0
    var lineMaxLen 0
    PRINTBOXEVAL:
      var line%c %echoVar[%c]
      if (len(%line%c) > %lineMaxLen) then eval lineMaxLen len(%line%c)
      math c add 1
      if (%c <= %echoVarLines) then goto printboxEval
    PADRIGHT:
      if (%c <= 0) then goto PRINTBOX
      math c subtract 1
      if (len(%line%c) = %lineMaxLen) then goto PADRIGHT
      eval whiteLoopVar %lineMaxLen - len(%line%c)
      WHITERIGHT:
        var line%c %line%c_
        math whiteLoopVar subtract 1
        eval temp %whiteLoopVar % 50
        if (%temp == 49) then delay %infiniteLoopProtection
        if (%whiteLoopVar > 0) then goto WHITERIGHT
        eval line%c replacere("%line%c", "_", " ")
        goto PADRIGHT
    PRINTBOX:
      eval border replacere("%line%c", ".", "~")
      put #echo
      put #echo %color <~~~%border~~~>
      PRINTBOXLOOP:
        put #echo %color {  %line%c  }
        math c add 1
        if (%c <= %echoVarLines) then goto PRINTBOXLOOP
      put #echo %color <~~~%border~~~>
      put #echo

debug 5

      return
  }
####
#### Do a thing
ACTION_WAIT:
  pause %command_pause
  if ($roundtime > 0) then pause $roundtime
  if ($stunned) then waiteval (!$stunned)
  if ($webbed) then waiteval (!$webbed)
ACTION:
  #requires %success and %action
  action (mapper) off
  var actionloop 0
  var lastLabel ACTION
  math actionloop add 1
  pause %command_pause
  matchre ACTION ^\.\.\.wait|^Sorry,|^Please wait\.|^The weight of all your possessions|^You are overburdened and cannot|^You are so unbalanced|%action_retry
  matchre TAP_CLOAK ^Something else is already hiding your features
  matchre ACTION_RETURN %success
  matchre ACTION_STOW_HANDS ^You must have at least one hand free to do that|^You need a free hand
  matchre ACTION_WAIT ^You're unconscious|^You are still stunned|^You can't do that while|^You don't seem to be able to
  matchre ACTION_FAIL ^(That's|The .*) too (heavy|thick|long|wide)|^There's no room|^Weirdly\,|^As you attempt|^That doesn't belong in there\!
  matchre ACTION_FAIL ^There isn't any more room|^You just can't get the .+ to fit|^Where are you|^What were you|^You can't|^You begin to get up and \*\*SMACK\!\*\*
  matchre UNLOAD ^You should unload
  put %action
  if matchre("%action", "^\.|#") then matchwait
  else matchwait 2
  if (%actionloop > 2) then goto ACTION_FAIL
  if (%typeahead.max = 0) then goto ACTION_MAPPER_ON
  else goto ACTION_RETURN
ACTION_FAIL:
  gosub ECHO Unable to perform action: %action
ACTION_RETURN:
  var action_retry ^0$
  var success ^0$
  if ($roundtime > 0) then pause %command_pause
  if (%subscript) then return
  action (mapper) on
  return
ACTION_STOW_HANDS:
  var actionbackup %action
  var successbackup %success
  gosub STOW_HANDS
  var action %actionbackup
  var success %successbackup
  goto ACTION
ACTION_WALK:
  gosub ACTION_MAPPER_ON
  goto MAIN_LOOP_CLEAR
#### end ACTION
#### SHROOM'S PUT SECTION ####
PUT:
  var putAction $0
  var lastLabel PUT_1
PUT_1:
  matchre WAIT ^\.\.\.wait|^Sorry,|^Please wait\.
  matchre IMMOBILE ^You don't seem to be able to move to do that
  matchre WEBBED ^You can't do that while entangled in a web
  matchre STUNNED ^You are still stunned
  matchre PUT_UNTIE ^You should untie
  matchre PUT_STOW ^You need a free hand|^Free one of your hands|^That will be hard with both your hands full\!
  matchre PUT_STAND ^You should stand up first\.|^Maybe you should stand up\.
  matchre WAIT ^\[Enter your command again if you want to\.\]
  matchre RETURN (You'?r?e?|As|With|Using) (?:accept|adeptly|add|adjust|allow|already|are|aren't|ask|cut|attach|attempt|.+ to|.+ fan|bash|begin|bend|blow|breathe|briefly|bring|bundle|cannot|can't|carefully|cautiously|chop|circle|clasp|close|collect|collector's|concentrate|corruption|count|combine|come|dance|decide|deduce|dodge|don't|drum|draw|effortlessly|eyes|gracefully|deftly|desire|detach|drop|drape|exhale|fade|fail|fake|feel(?! fully rested)|feint|fill|find|filter|focus|form|fumble|gaze|gesture|giggle|gingerly|get|glance|grab|hand|hang|have|icesteel|inhale|insert|kiss|kneel|knock|leap|lean|let|lose|lift|loosen|lob|load|measure|move|must|mutter|mind|not|now|need|offer|open|parry|place|pick|push|pout|pour|put|pull|prepare|press|quietly|quickly|raise|read|reach|ready|realize|recall|remain|release|remove|retreat|reverently|rock|roll|rub|scan|search|secure|sense|set|sheathe|shield|should|shouldn't|shove|silently|sit|skin|slide|sling|slip|slow|slowly|spin|spread|sprinkle|start|stick|stop|strap|struggle|swap|swiftly|swing|switch|tap|take|the|though|touch|tie|tilt|toss|trace|try|tug|turn|twist|unload|untie|vigorously|wave|wear|weave|whisper|whistle|will|wink|wring|work|yank|yell|you|zills) .*(?:\.|\!|\?)?
  matchre RETURN ^Brother Durantine|^Durantine|^Mags|^Ylono|^Malik|^Kilam|^Ragge|^Randal|^Catrox|^Kamze|^Unspiek|^Wyla|^Ladar|^Dagul|^Granzer|^Gemsmith|^Fekoeti|^Diwitt|(?:An|The|A) attendant|^The clerk|A Dwarven|^.*He says,
  matchre RETURN ^The(.*)?(clerk|teller|attendant|mortar|pestle|tongs|bowl|riffler|hammer|gem|book|page|lockpick|sconce|voice|waters|contours|person|is|has|are|slides|fades|hinges|spell|not)
  matchre RETURN ^It('s)?(?:'s|a|and|the)?\s+?(?:would|will|is|a|already|dead|keen|practiced|graceful|stealthy|resounding|full|has)
  matchre RETURN ^\s*[\[\(]?Roundtime\s*\:?
  matchre RETURN ^That('s)?\s+?(?:is|has|was|a|cannot|area|can't|won't|would|already|tool|will|cost|too)
  matchre RETURN ^With(?: (a|and|the))?\s+?(?:keen|practiced|graceful|stealthy|resounding)
  matchre RETURN ^This (is a .+ spell|is an exclusive|spell|ritual)
  matchre RETURN ^The .*(is|has|are|slides|fades|hinges|spell|not|vines|antique|(.+) spider|pattern)
  matchre RETURN ^There('s)?\s+?(?:is(n't)?|does(n't)?|already|no|not)
  matchre RETURN ^But (?:that|you|you're|you've|the)
  matchre RETURN ^Obvious (?:exits|paths)
  matchre RETURN ^There's no room|any more room|no matter how you arrange|have all been used\.
  matchre RETURN ^That's too heavy|too thick|too long|too wide|not designed to carry|cannot hold any more
  matchre RETURN ^(You|I) can't|^Tie what\?|^You just can't|As you attempt to place your
  matchre RETURN suddenly leaps toward you|and flies towards you|with a flick
  matchre RETURN ^Brushing your fingers|^Sensing your intent|^Quietly touching your lips
  matchre RETURN Lucky for you\!\s*That isn't damaged\!|I will not repair something that isn't broken\.
  matchre RETURN I'm sorry, but I don't work on those|There isn't a scratch on that, and I'm not one to rob you\.
  matchre RETURN I don't work on those here\.|I don't repair those here|Please don't lose this ticket\!
  matchre RETURN ^Please rephrase that command\.|^I could not find|^Perhaps you should|^I don't|^Weirdly,|That can't
  matchre RETURN \[You're|\[This is|too injured
  matchre RETURN ^Moving|Brushing|Recalling|Unaware
  matchre RETURN ^.*\[Praying for \d+ sec\.\]
  matchre RETURN ^.+ is not in need|^That is closed\.
  matchre RETURN ^What (?:were you|is it)
  matchre RETURN ^In the name of love\?|^Play on|^(.+) what\?
  matchre RETURN ^It's kind of wet out here\.
  matchre RETURN ^Some (?:polished|people|tarnished|.* zills)
  matchre RETURN ^(\S+) has accepted
  matchre RETURN ^Subservient type|^The shadows|^Close examination|^Try though
  matchre RETURN ^USAGE\:|^Using your|^You.*analyze
  matchre RETURN ^Allows a Moon Mage|^Smoking commands are
  matchre RETURN ^A (?:slit|pair|shadow) .*(?:\.|\!|\?)?
  matchre RETURN ^Your (?:actions|dance|nerves) .*(?:\.|\!|\?)?
  matchre RETURN ^Having no further use for .*, you discard it\.
  matchre RETURN ^After a moment, .*\.
  matchre RETURN ^.* (?:is|are) not in need of cleaning\.
  matchre RETURN \[Type INVENTORY HELP for more options\]|\[Use INVENTORY HELP for more options\.\]
  matchre RETURN ^A vortex|^A chance for|^In a flash|^It is locked|^An aftershock
  matchre RETURN ^In the .* you see .*\.
  matchre RETURN .* (?:Dokoras|Kronars|Lirums)
  matchre RETURN ^You will now store .* in your .*\.
  matchre RETURN ^\[Ingredients can be added by using ASSEMBLE Ingredient1 WITH Ingredient2\]
  matchre RETURN ^\s\*LINK ALL CANCEL\s\*- Breaks all links
  matchre RETURN ^Stalking is an inherently stealthy endeavor, try being out of sight\.
  matchre RETURN ^You're already stalking|^There aren't any
  matchre RETURN ^An offer|shakes (his|her) head
  matchre RETURN ^Tie it off when it's empty\?
  matchre RETURN ^But the merchant can't see you|are invisible
  matchre RETURN Page|^As the world|^Obvious|^A ravenous energy
  matchre RETURN ^In the|^The attendant|^That is already open\.|^Your inner
  matchre RETURN ^(.+) hands you|^Searching methodically|^But you haven't prepared a symbiosis\!
  matchre RETURN ^Illustrations of complex,|^It is labeled|^Your nerves
  matchre RETURN ^The lockpick|^Doing that|is not required to continue crafting
  matchre RETURN ^Without (any|a|the)|^Wouldn't (it|that|you)
  matchre RETURN ^Weirdly, you can't manage
  matchre RETURN ^Hold hands with whom\?
  matchre RETURN ^Something in the area interferes
  matchre RETURN ^With a .+ to your voice,
  matchre RETURN ^You untie|^You coil|^You uncoil
  matchre RETURN ^Turning your focus solemnly inward
  matchre RETURN ^Slow, rich tones form a somber introduction
  matchre RETURN ^Images of streaking stars falling from the heavens
  matchre RETURN ^With .* movements you prepare your body for the .* spell\.
  matchre RETURN ^A strong wind swirls around you as you prepare the .* spell\.
  matchre RETURN ^Shadow and light collide wildly around you as you prepare the .* spell\.
  matchre RETURN ^The wailing of lost souls accompanies your preparations of the .* spell\.
  matchre RETURN ^A soft breeze surrounds your body as you confidently prepare the .* spell\.
  matchre RETURN ^Light withdraws from around you as you speak arcane words for the .* spell\.
  matchre RETURN ^Tiny tendrils of lightning jolt between your hands as you prepare the .* spell\.
  matchre RETURN ^Low, hummed tones form a soft backdrop for the opening notes of the .* enchante\.
  matchre RETURN ^Heatless orange flames blaze between your fingertips as you prepare the .* spell\.
  matchre RETURN ^Throwing your head back, you release a savage roar and growl words for the .* spell\.
  matchre RETURN ^Entering a trance-like state, your hands begin to tremble as you prepare the .* spell\.
  matchre RETURN ^Glowing geometric patterns arc between your upturned palms as you prepare the .* spell\.
  matchre RETURN ^Focusing intently, you slice seven straight lines through the air as you invoke the .* spell.\.
  matchre RETURN ^Accompanied with a flash of light, you clap your hands sharply together in preparation of the .* spell\.
  matchre RETURN ^Icy blue frost crackles up your arms with the ferocity of a blizzard as you begin to prepare the .* spell\!
  matchre RETURN ^A radiant glow wreathes your hands as you weave lines of light into the complicated pattern of the .* spell\.
  matchre RETURN ^Kaleidoscopic ribbons of light swirl between your outstretched hands, coalescing into a spectral wildling spider\.
  matchre RETURN ^Darkly gleaming motes of sanguine light swirl briefly about your fingertips as you gesture while uttering the .* spell\.
  matchre RETURN ^As you begin to solemnly intone the .* spell a blue glow swirls about forming a nimbus that surrounds your entire being\.
  matchre RETURN ^As you slam your fists together and inhale sharply, a glowing outline begins to form and a matrix of blue and white motes surround you\.
  matchre RETURN ^In one fluid motion, you bring your palms close together and a fiery crimson mist begins to burn within them as you prepare the .* spell\.
  matchre RETURN ^The first gentle notes of .* waft from you with delicate ease, riddled with low tones that gradually give way to a higher\-pitched theme\.
  matchre RETURN ^Droplets of water coalesce around your fingertips as your arms undulate like gracefully flowing river currents to form the pattern of the .* spell\.
  matchre RETURN ^Inhaling deeply, you adopt a cyclical rhythm in your breaths to reflect the ebb and flow of the natural world and steel yourself to prepare the .* spell\.
  matchre RETURN ^Calmly reaching out with one hand, a silvery-blue beam of light descends from the sky to fill your upturned palm with radiance as you prepare the .* spell\.
  matchre RETURN ^Turning your head slightly and gazing directly ahead with a calculating stare, tiny sparks of crystalline light flash around your eyes as you prepare the .* spell\.
  matchre RETURN ^You take up a handful of dirt in your palm to prepare the .* spell\.  As you whisper arcane words, you gently blow the dust away and watch as it becomes swirling motes of glittering light that veil your hands in a pale aura\.
  send %putAction
  matchwait 20
  put #echo >Log #DC143C *** MISSING MATCH IN PUT! (%scriptname.cmd) ***
  put #echo >Log #DC143C Command = %putAction
  return
PUT_UNTIE:
  pause %command_pause
  eval putAction replacere("%putAction", "\bget\b", "")
  eval putAction replacere("%putAction", "\bmy\b", "")
  goto PUT_1
PUT_STOW:
  gosub STOWING
  goto PUT_1
PUT_STAND:
  gosub STAND
  goto PUT_1
#### END PUT ####
#### CATCH AND RETRY SUBS
WAIT:
  delay %infiniteLoopProtection
  pause %command_pause
  if (!$standing) then gosub STAND
  goto %lastLabel
WEBBED:
  delay %infiniteLoopProtection
  if ($webbed) then waiteval (!$webbed)
  if (!$standing) then gosub STAND
  goto %lastLabel
IMMOBILE:
  delay %infiniteLoopProtection
  if contains("$prompt" , "I") then pause 20
  if (!$standing) then gosub STAND
  goto %lastLabel
STUNNED:
  delay %infiniteLoopProtection
  if ($stunned) then waiteval (!$stunned)
  if (!$standing) then gosub STAND
  goto %lastLabel
CALMED:
  delay 5
  if ($stunned) then waiteval (!$stunned)
  if (!$standing) then gosub STAND
  goto %lastLabel
####
#### Stow section ####
STOWING:
  var lastLabel STOWING
  if matchre("$righthandnoun $lefthandnoun", "\brope\b") then {
    gosub PUT coil my rope
  }
#  if matchre("$righthandnoun $lefthandnoun", "\b(crossbow|bow|short bow|arbalest|slurbow|sling)\b") then gosub UNLOAD
  if matchre("$righthandnoun $lefthandnoun", "(partisan|shield|buckler|lumpy bundle|halberd|staff|longbow|khuj)") then gosub WEAR MY $1
  if ("$righthand" != "Empty") then GOSUB STOW right
  if ("$lefthand" != "Empty") then GOSUB STOW left
  if ("$righthand" != "Empty") then goto PUT sheath
  return
STOW:
  var stowVar $0
  var lastLabel STOW_1
STOW_1:
  matchre WAIT ^\.\.\.wait|^Sorry,|^Please wait\.
  matchre IMMOBILE ^You don't seem to be able to move to do that
  matchre WEBBED ^You can't do that while entangled in a web
  matchre STUNNED ^You are still stunned
  matchre STOW_ALT not designed to carry anything|any more room|no matter how you arrange|^That's (?:too heavy|too thick|too long|too wide)|^But that's closed|^I can't find your container|^You can't
  matchre RETURN ^Wear what\?|^Stow what\?  Type 'STOW HELP' for details\.|^You put|^You open
  matchre RETURN ^You stop as you realize|^But that is already in your inventory\.|^That can't be picked up
  matchre RETURN needs to be
  matchre UNLOAD ^You (?:need to|should) unload the
  put stow %stowVar
  matchwait 7
  put #echo >$Log #DC143C $datetime *** MISSING MATCH IN STOW! ***
  put #echo >$Log #DC143C $datetime Stow = %stowVar
STOW_FOOT_ITEM:
  gosub STOW_FEET
  gosub STOW_HANDS
  goto ABSOLUTE_TOP
STOW_FEET:
  var action stow feet
  if matchre("%footitem", "(mat|rug|cloth|tapestry)") then var action roll $1
  var success ^You pick up .* lying at your feet|^You carefully gather up the delicate folds|^You start at one end of your|^Stow what\?
  gosub ACTION
## THIS LINE WAS ADDED TO FIX A RARE CONDITION WHERE THE FOOTITEM IS A "CLOTH/RUG" BUT ~CANNOT~ BE ROLLED THUS GOES INTO AN INFINITE LOOP OF FAILING TO ROLL
## It should not really effect a normal stow feet other than firing "stow feet" twice which is inconsequential
  send stow feet
  pause %command_pause
  return
STOW_HANDS:
  if matchre("$righthand", "(khuj|staff|atapwi|parry stick)") then gosub PUT wear $righthandnoun
  if !matchre("Empty", "$lefthand") then gosub STOW_LEFT
  if !matchre("Empty", "$righthand") then gosub STOW_RIGHT
  if (!matchre("Empty", "$lefthand") || !matchre("Empty", "$righthand")) then gosub STOW_ALT
  return
STOW_LEFT:
  var action stow my $lefthandnoun
  var success ^You put|^Stow what\?
  gosub ACTION
  return
STOW_RIGHT:
  var action stow my $righthandnoun
  var success ^You put|^Stow what\?
  gosub ACTION
  return
### BACKUP STOW METHOD IF REGULAR "STOW" FAILS
### Will check for other worn containers and attempt stowing item in alternate containers
STOW_ALT:
  var StowLoop 0
  gosub BAG_CHECK
STOW_ALT_1:
  delay %infiniteLoopProtection
  math StowLoop add 1
  if (matchre("Empty", "$lefthand") && matchre("Empty", "$righthand")) then return
  if (%StowLoop > 3) then {
    gosub ECHO STOW ERROR - CANNOT FIND A PLACE TO STORE %stowVar
    return
  }
  if !matchre("Empty", "$righthand") then var item $righthandnoun
  if !matchre("Empty", "$lefthand") then var item $lefthandnoun
  if !matchre("%mainBag", "NULL") then {
    var action put my %item in my %mainBag
    var success ^You (put|slip)|^What were you|^Stow what\?
    gosub ACTION
  }
  if (matchre("Empty", "$lefthand") && matchre("Empty", "$righthand")) then return
  if !matchre("%backupBag", "NULL") then {
    var action put my %item in my %backupBag
    var success ^You (put|slip)|^What were you|^Stow what\?
    gosub ACTION
  }
  if (matchre("Empty", "$lefthand") && matchre("Empty", "$righthand")) then return
  if !matchre("%thirdBag", "NULL") then {
    var action put my %item in my %thirdBag
    var success ^You (put|slip)|^What were you|^Stow what\?
    gosub ACTION
  }
  if (matchre("Empty", "$lefthand") && matchre("Empty", "$righthand")) then return
  if !matchre("%fourthBag", "NULL") then {
    var action put my %item in my %fourthBag
    var success ^You (put|slip)|^What were you|^Stow what\?
    gosub ACTION
  }
OPEN_THING:
  gosub PUT open back
  gosub PUT open haver
  goto STOWING
REM_WEAR:
  gosub ECHO ERROR IN STOWING - MAKE SURE YOU HAVE ROOM IN CONTAINERS
  gosub ECHO ABORTING SCRIPT!!!
  exit
#### End stow section
#### stand up ####
STAND:
  if matchre("$roomname", "The Breech Tunnels") then return
  var lastLabel STAND_1
STAND_1:
  matchre WAIT ^\.\.\.wait|^Sorry,|^Please wait\.
  matchre WAIT ^\s*[\[\(]?Roundtime\s*\:?
  matchre WAIT ^The weight of all your possessions prevents you from standing\.
  matchre WAIT ^You are overburdened and cannot manage to stand\.
  matchre STUNNED ^You are still stunned
  matchre WEBBED ^You can't do that while entangled in a web
  matchre IMMOBILE ^You don't seem to be able to move to do that
  matchre STAND_RETURN ^You stand (?:back )?up\.
  matchre STAND_RETURN ^You stand up in the water
  matchre STAND_RETURN ^You are already standing\.
  put stand
  matchwait
STAND_RETURN:
  delay %infiniteLoopProtection
  if (!$standing) then goto STAND
  return
#### end stand ####
#### Retreat ####
RETREAT:
  action (mapper) off
  var retreatLoop 0
  var lastLabel RETREAT
RETREAT_1:
  math retreatLoop add 1
  if (%retreatLoop > 5) then goto RETREAT_FLEE
  if ($standing == 0) then gosub STAND
  matchre WAIT ^\.\.\.wait|^Sorry,|^Please wait\.
  matchre STUNNED ^You are still stunned
  matchre WEBBED ^You can't do that while entangled in a web
  matchre IMMOBILE ^You don't seem to be able to move to do that
  matchre RETREAT ^You must stand first\.
  matchre RETREAT ^You stop advancing
  matchre RETREAT ^You retreat back to pole range\.
  matchre RETREAT ^You sneak back out
  matchre RETREAT_RETURN ^You retreat from combat\.|^You are already as far away as you can get\!
  matchre RETREAT_1 ^You try to
  matchre RETREAT_1 revealing your hiding place\!
  put retreat
  matchwait 20
  put #echo >Log #DC143C MISSING MATCH IN %lastLabel! (mapperINC.cmd) ***
RETREAT_FLEE:
#last ditch effort
  pause 0.1
  if ($standing == 0) then gosub STAND
  matchre RETURN ^Obvious|^.?Roundtime\:?|^A master|^Your?
  put flee
  matchwait 10
RETREAT_RETURN:
  action (mapper) on
  return
#### end retreat ####
#### unhide ####
UNHIDE:
  if ($standing == 0) then gosub STAND
  if ($hidden == 0) then return
UNHIDE_1:
  matchre UNHIDE ^\.\.\.wait|^Sorry,|^You are still stunned\.
  matchre STUNNED ^You are still stunned
  matchre WEBBED ^You can't do that while entangled in a web
  matchre IMMOBILE ^You don't seem to be able to move to do that
  matchre RETURN ^But you are not hidden\!|^You come out of hiding\.
  matchre RETURN ^Please rephrase that command\.|^I could not find|^Perhaps you should|^I don't|^Weirdly,
  matchre RETURN (You'?r?e?|As|With) (?:accept|add|adjust|allow|already|are|aren't|ask|attach|attempt|.+ to|.+ fan|bash|begin|bend|blow|breathe|briefly|bundle|cannot|can't|chop|circle|close|corruption|count|combine|come|carefully|dance|decide|dodge|don't|drum|draw|effortlessly|gracefully|deftly|desire|detach|drop|drape|exhale|fade|fail|fall|fake|feel(?! fully rested)|feint|fill|find|filter|form|fumble|gesture|gingerly|get|glance|grab|hand|hang|have|icesteel|insert|kiss|kneel|knock|leap|lean|let|lose|lift|loosen|lob|load|move|must|mind|not|now|need|offer|open|parry|place|pick|push|pout|pour|put|pull|press|quietly|quickly|raise|read|reach|ready|realize|recall|remain|release|remove|retreat|reverently|roll|rub|scan|search|secure|sense|set|sheathe|shield|shouldn't|shove|silently|sit|slide|sling|slip|slowly|spin|spread|sprinkle|stop|strap|struggle|swiftly|swing|switch|tap|take|the|though|tie|tilt|toss|trace|try|tug|turn|twist|unload|untie|vigorously|wave|wear|weave|whisper|will|wink|wring|work|yank|you|zills) .*(?:\.|\!|\?)?
  send unhide
  matchwait 5
  return
#### end unhide ####
#### DARK ROOM HANDLING ####
#####################################################################################################
# LIGHT SOURCE CHECK BY SHROOM - SCRIPT USES WHEN IN PITCH BLACK/DARK ROOMS
# USE ANY KNOWN GUILD SKILLS/SPELLS TO ACTIVATE DARK VISION
# IF NOT ACTIVE OR NO GUILD SPELL - CHECKS FOR/USES LIGHT-PRODUCING ITEMS (STARGLASS/LANTERN/GOGGLES)
#####################################################################################################
DARK_CHECK:
  var darkroom 1
  var lastLabel DARK_CHECK
  delay %infiniteLoopProtection
  pause %command_pause
  matchre DARK_CHECK %move_RETRY
  matchre DARK_YES ^It's pitch dark and you can't see a thing\!|pitch black in here
  matchre LIGHT_YES ^Obvious|^I could|^What
  put look
  matchwait 5
  goto DARK_CHECK
DARK_YES:
  var darkroom 1
  var darkTime $gametime
  return
LIGHT_YES:
  var darkroom 0
  var darkTime $gametime
  return
## FIND A LIGHT SOURCE - FIRST WE CHECK FOR ANY DARKVISION GUILD SKILLS
LIGHT_CHECK:
LIGHT_SOURCE:
  action (mapper) off
  var subscript 0
  var PREP 5
  var darkchecked 1
  gosub DARK_CHECK
  if (%darkroom = 0) then return
  ### KNOWN ISSUE - AFTER SUCCESSFULLY USING DARKVISION - SOMETIMES LOSES REMAINING PATH AFTER RETURNING
  ### Have tried many various things but not sure best way to fix - This may work most of the time
  shift
  math depth subtract 1
  delay %infiniteLoopProtection
  gosub ECHO DARK ROOM: Need a light source! - Checking for DARKVISION
  delay %infiniteLoopProtection
  if ("$preparedspell" != "None") then {
    gosub PUT release spell
    gosub PUT release camb
  }
  if (("$guild" = "Ranger") && ($circle > 39)) then {
    gosub ECHO RANGER - Beseeching Dark to Sing
    gosub PUT align 30
    var action beseech dark to sing
    var success ^\s*[\[\(]?Roundtime\s*\:?
    gosub ACTION
    pause %command_pause
    if ($roundtime > 0) then pause $roundtime
  }
  if ("$guild" = "Thief") then {
    gosub ECHO THIEF - Khri Sight
    gosub PUT khri sight
    pause %command_pause
    if ($roundtime > 0) then pause $roundtime
  }
  if (("$guild" = "Bard") && ($circle > 10)) then {
    gosub ECHO BARD - Eye of Kertigen
    gosub PUT release cyclic
    gosub PUT prep EYE 5
    pause 16
    gosub PUT cast
    pause %command_pause
    if ($roundtime > 0) then pause $roundtime
    gosub PUT perceive self
  }
  if (("$guild" = "Cleric")  && ($circle > 20)) then {
    if ($Utility.Ranks < 120) then var PREP 2
    if (($Utility.Ranks >= 120) && ($Utility.Ranks < 200)) then var PREP 5
    if (($Utility.Ranks >= 200) && ($Utility.Ranks < 300)) then var PREP 9
    if (($Utility.Ranks >= 300) && ($Utility.Ranks < 500)) then var PREP 12
    if (($Utility.Ranks >= 500) && ($Utility.Ranks < 600)) then var PREP 15
    if ($Utility.Ranks >= 600) then var PREP 15
    gosub ECHO CLERIC - Divine Radiance
    gosub PUT prep DR %PREP
    pause 19
    gosub PUT cast
    gosub PUT perceive self
    pause %command_pause
    if ($roundtime > 0) then pause $roundtime
  }
  if (("$guild" = "Moon Mage") && ($circle > 20)) then {
    if ($Utility.Ranks < 120) then var PREP 5
    if (($Utility.Ranks >= 120) && ($Utility.Ranks < 200)) then var PREP 7
    if (($Utility.Ranks >= 200) && ($Utility.Ranks < 300)) then var PREP 12
    if (($Utility.Ranks >= 300) && ($Utility.Ranks < 500)) then var PREP 15
    if (($Utility.Ranks >= 500) && ($Utility.Ranks < 600)) then var PREP 22
    if ($Utility.Ranks >= 600) then var PREP 33
    gosub ECHO MOON MAGE - Tenebrous Sense
    gosub PUT prep TS %PREP
    pause 19
    gosub PUT cast
    pause %command_pause
    if ($roundtime > 0) then pause $roundtime
  }
  if (("$guild" = "Paladin") && ($circle > 15)) then {
    gosub ECHO PALADIN - Glyph of Light
    gosub PUT glyph light
    pause %command_pause
    if ($roundtime > 0) then pause $roundtime
  }
  delay %infiniteLoopProtection
  pause %command_pause
  gosub DARK_CHECK
  if (%darkroom = 0) then goto YES_DARKVISION
### ADDITIONAL CHECKS HERE FOR GOGGLES / GAEZTHEN
# WE REACH THIS SUB IF WE HAVE ~NO GUILD SKILL FOR DARK VISION~
# NOW WE CHECK FOR ITEMS THAT GIVE DARK VISION
# CHECK FOR NIGHTVISION GOGGLES
GOGGLE_CHECK:
GOGGLE_YES:
  delay %infiniteLoopProtection
  gosub PUT get my goggle
  delay %infiniteLoopProtection
  if !matchre("$righthand $lefthand", "(?i)\bgoggle\b") then {
    gosub PUT remove my goggle
    pause %command_pause
    if ($roundtime > 0) then pause $roundtime
  }
  if !matchre("$righthand $lefthand", "\bgoggle\b") then goto STARGLASS_CHECK
  matchre GOGGLE_YES \s*\.\.\.wait|^Sorry,|^Please wait\.|^You are still stunned
  matchre GOGGLE_STOW remains inert|^You rub|^What
  matchre GOGGLE_STOW ^Your tactile sense
  put rub my goggle
  matchwait 5
GOGGLE_STOW:
  pause %command_pause
  gosub PUT wear my goggle
  delay %infiniteLoopProtection
  gosub PUT rub my goggle
  delay %infiniteLoopProtection
  if matchre("$righthand $lefthand", "\bgoggle\b") then gosub STOWING
  gosub DARK_CHECK
  if (%darkroom = 0) then goto YES_DARKVISION
### CHECK FOR A STARGLASS
STARGLASS_CHECK:
  gosub STOWING
  gosub PUT GET my starglass
  delay %infiniteLoopProtection
  if !matchre("$righthand $lefthand", "(?i)\bstarglass\b") then {
    gosub PUT remove my starglass
    pause %command_pause
    if ($roundtime > 0) then pause $roundtime
  }
  if !matchre("$righthand $lefthand", "(?i)starglass") then goto GAETHZEN_CHECK
  gosub PUT CHARGE starglass 20
  pause %command_pause
  if ($roundtime > 0) then pause $roundtime
  gosub PUT CHARGE starglass 20
  pause %command_pause
  if ($roundtime > 0) then pause $roundtime
  put rub my starglass
  pause %command_pause
  if ($roundtime > 0) then pause $roundtime
  gosub PUT WEAR my starglass
  pause %command_pause
  gosub DARK_CHECK
  if (%darkroom = 0) then goto YES_DARKVISION
### CHECK FOR A GAETHZEN LANTERN
GAETHZEN_CHECK:
  gosub STOWING
  var Lantern.Types skull|salamander|sphere|wyvern|statuette|sunburst|star|lantern|firefly|rose|orchid|turnip
  var Lantern.Check 0
  var Lantern.Count 0
  eval Lantern.Count count("%Lantern.Types", "|")
  if (%Lantern.Check > %Lantern.Count) then goto LANTERN_CHECK
GAETHZEN_GET:
  gosub PUT GET my gaethzen %Lantern.Types(%Lantern.Check)
  delay %infiniteLoopProtection
  pause %command_pause
  if !matchre("$righthand $lefthand", "%Lantern.Types(%Lantern.Check)") then {
    gosub PUT remove my gaethzen %Lantern.Types(%Lantern.Check)
    pause %command_pause
  }
  if matchre("$righthand $lefthand", "(?i)%Lantern.Types(%Lantern.Check)") then goto GAETHZEN_SUCCESS
GAETHZAN_FAIL:
  math Lantern.Check add 1
  if (%Lantern.Check > %Lantern.Count) then goto LANTERN_CHECK
  goto GAETHZEN_GET
GAETHZEN_SUCCESS:
  var Gaethzen %Lantern.Types(%Lantern.Check)
  var FullCharge 0
  gosub ECHO FOUND A GAETHZEN! TYPE: %Gaethzen
  gosub STOWING
  gosub RETREAT
  gosub PUT GET my gaethzen %Gaethzen
  delay %infiniteLoopProtection
  pause %command_pause
  if !matchre("$righthand $lefthand", "(?i)%Gaethzen") then goto LANTERN_CHECK
  gosub ECHO CHARGING GAETHZEN
  var action_retry ^\s*[\[\(]?Roundtime\s*\:?
  var success ^The .+ is already holding as much power as you could possibly charge it with\.
  var action CHARGE %Gaethzen 15
  gosub ACTION
GAETHZEN_2:
  gosub PUT focus my %Gaethzen
  gosub PUT rub my %Gaethzen
  gosub PUT wear my %Gaethzen
  gosub STOWING
  gosub DARK_CHECK
  if (%darkroom = 0) then goto YES_DARKVISION
### CHECK HERE FOR A NORMAL OIL LANTERN
LANTERN_CHECK:
  var TriedOil 0
  gosub STOWING
  gosub PUT GET my lantern
  if !matchre("$righthand $lefthand", "lantern") then {
    gosub PUT remove my lantern
    pause %command_pause
  }
  if !matchre("$righthand $lefthand", "(?i)lantern") then goto TORCH_CHECK
LANTERN_DROP:
  gosub PUT drop my lantern
  gosub PUT GET my flint
  gosub PUT GET my knife
  if (!matchre("$righthand $lefthand", "flint") && !matchre("$righthand $lefthand", "knife")) then {
    gosub ECHO FLINT/WEAPON ERROR IN LIGHT SOURCE - Righthand: $righthand / Lefthand: $lefthand
    put #echo >Log #FF3E00 * FLINT/WEAPON ERROR IN LIGHT SOURCE - Righthand: $righthand / Lefthand: $lefthand
    gosub STOWING
    goto GAETHZEN_YES
  }
LANTERN_LIGHT:
  matchre LANTERN_LIGHT %move_RETRY
  matchre LIT_LANTERN manage to get a flame going
  matchre REFUEL_IT But the flames fail to catch hold and they sputter out immediately\.
  put light lantern with my flint
  matchwait 5
  goto LANTERN_LIGHT
REFUEL_IT:
  if (%TriedOil = 1) then goto LANTERN_DONE
  gosub STOWING
  gosub PUT GET lantern
  gosub PUT GET lamp oil
  gosub PUT pour oil in lantern
  var TriedOil 1
  goto LANTERN_DROP
LIT_LANTERN:
  gosub ECHO LANTERN LIT!
  gosub STOWING
  gosub PUT GET lantern
  gosub PUT wear lantern
LANTERN_DONE:
  gosub STOWING
  gosub DARK_CHECK
  if (%darkroom = 0) then goto YES_DARKVISION
### CHECK FOR A TORCH
TORCH_CHECK:
  gosub STOWING
  put #echo %color <~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~>
  put #echo %color <<  ATTEMPTING LAST RESORT FOR LIGHT CHECK!   >>
  put #echo %color <<  FLINT / TORCH / KNIFE                     >>
  put #echo %color <<  CONSIDER ~NOT~ HUNTING IN A DARK AREA...  >>
  put #echo %color <~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~>
  # if (%HaveLighter = 1) then
      # {
            # gosub PUT GET my %Lighter.Name
            # pause 0.1
            # pause 0.0001
            # if !matchre("$righthand", "(?i)%Lighter.Name") then
                # {
                      # echo * LIGHTER NOT FOUND! - TURNING LIGHTER OFF
                      # var HaveLighter 0
                      # goto TORCH_FLINT
                # }
            # gosub PUT GET my torch
            # pause 0.0001
            # pause 0.0001
            # if !matchre("$righthand $lefthand", "(?i)torch") then goto NO_DARKVISION
            # gosub PUT point %Lighter.Name at torch
            # pause 0.0001
            # pause 0.0001
            # gosub STOWIT %Lighter.Name
            # gosub DARK_CHECK
            # if (%darkroom = 0) then goto YES_DARKVISION
      # }
TORCH_FLINT:
  if !matchre("$righthand $lefthand", "(?i)torch") then gosub PUT GET my torch
  if !matchre("$righthand $lefthand", "(?i)torch") then goto NO_DARKVISION
  gosub PUT drop my torch
  gosub PUT GET my flint
  gosub PUT GET my carving knife
  if !matchre("$righthand $lefthand", "(?i)knife") then {
    gosub PUT GET my knife
    if !matchre("$righthand $lefthand", "(?i)knife") then gosub PUT remove my knife
  }
  if !matchre("$righthand $lefthand", "(?i)knife") then {
    gosub PUT GET my blade
  }
  if (!matchre("$righthand $lefthand", "flint") && !matchre("$righthand $lefthand", "(knife|blade)")) then {
    gosub ECHOecho * FLINT/WEAPON ERROR IN LIGHT SOURCE - Righthand: $righthand / Lefthand: $lefthand
    put #echo >Log #FF3E00 * FLINT/WEAPON ERROR IN LIGHT SOURCE - Righthand: $righthand / Lefthand: $lefthand
    gosub STOWING
    goto NO_DARKVISION
  }
  gosub PUT light torch with my flint
  gosub STOWING
  gosub PUT GET torch
  gosub DARK_CHECK
  if (%darkroom = 0) then goto YES_DARKVISION
  goto NO_DARKVISION
YES_DARKVISION:
  gosub ECHO DARKVISION HAS BEEN ACTIVATED!
  var darkroom 0
  put look
  gosub STOWING
  gosub RETREAT
  action (mapper) on
  return
NO_DARKVISION:
  gosub ECHO NO DARK VISION SKILL / ITEM FOUND! STUCK IN THE DARK! Escape Manually!
  gosub ECHO GET YOURSELF A TORCH AND FLINT AT THE LEAST!
  gosub ECHO OR A STARGLASS/GAEZTHEN/LANTERN
  put #echo >Log Red ** NO DARKVISION/TORCH/LIGHTER/GAEZTHEN FOUND!
  put #echo >Log Red ** CONSIDER ~NOT~ HUNTING IN DARK AREAS
  var darkroom 1
  gosub STOWING
  action (mapper) on
  return
DARK_DOUBLECHECK:
  matchre DARK_DOUBLECHECK \s*\.\.\.wait|^Sorry,|^Please wait\.|^You are still stunned
  matchre DARK_NOPE ^It's pitch dark and you can't see a thing\!|pitch black in here
  matchre LIGHT_ROOM Obvious|I|What|You
  put look
  matchwait 5
  return
DARK_NOPE:
  var darkroom 1
  var darkTime $gametime
  return
LIGHT_ROOM:
  var darkroom 0
  var darkTime $gametime
  return
#### END DARK ROOM HANDING SECTION ####
#### Unload ####
UNLOAD:
  var unloadables crossbow|sling|bow|blowgun|arbalest|arbalest|chunenguti|hrr'ibu|jiranoci|jranoki|mahil|taisgwelduan|uku'uanstaho
  var actionbackup %action
  var successbackup %success
  if matchre("$righthand", "%unloadables") then var action unload my $righthandnoun
  if matchre("$lefthand", "%unloadables") then var action unload my $lefthandnoun
  var success ^\s*[\[\(]?[rR]oundtime\s*\:?|^You unload
  gosub ACTION
  gosub STOW_HANDS
  var action %actionbackup
  var success %successbackup
  goto %lastLabel
####
#### THIS AUTO SETS mainBag / backupBag / thirdBag VARIABLES
#### FOR STOWING ROUTINE ONLY - BACKUP CONTAINERS IN CASE DEFAULT "STOW" FAILS - THIS WILL CATCH ANY COMMON LARGE CONTAINERS
#### ~ THIS SHOULD ONLY FIRE IF THE MOVE_STOW ROUTINE TRIGGERS AND DEFAULT STOW DOES NOT FULLY CLEAR HANDS ~
#### THIS WAS MADE AS HAPPY MEDIUM - IS MUCH BETTER THAN USING HARDCODED VARIABLES
#### SETTING THE CONTAINERS AUTOMATICALLY MAKES IT EASY WITHOUT HAVING TO WORRY ABOUT USER VARIABLES / MULTI-CHARACTERS ETC..
#### THIS SHOULD CATCH THE ~MAIN~ BAGS MOST PEOPLE HAVE AT LEAST ONE OR TWO OF
BAG_CHECK:
  var mainBag NULL
  var backupBag NULL
  var thirdBag NULL
  var fourthBag NULL
  var backpack 0
  var brambles 0
  var carryall 0
  var cloak_worn 0
  var duffelbag 0
  var eddy 0
  var haversack 0
  var hippouch 0
  var pack 0
  var rucksack 0
  var shadows 0
  var toolbelt 0
  var vortex 0
  action var backpack 1 when backpack
  action var brambles 1 when dense entangling brambles
  action var carryall 1 when carryall
  action var cloak_worn 1 when cloak
  action var duffelbag 1 when duffel bag
  action var eddy 1 when swirling eddy of incandescent
  action var haversack 1 when haversack
  action var hippouch 1 when light spidersilk hip pouch
  action var pack 1 when \bpack\b
  action var rucksack 1 when rucksack
  action var shadows 1 when encompassing shadows
  action var toolbelt 1 when archeologist's toolbelt
  action var vortex 1 when (hollow vortex of water|corrupted vortex of swirling)
  gosub ECHO Checking Containers...
  matchre BAG_PARSE INVENTORY
  put inv container
  matchwait 3
BAG_PARSE:
  var bags backpack|brambles|carryall|duffelbag|eddy|haversack|hip pouch|pack|rucksack|shadows|toolbelt|vortex
  eval totalBags count("%bags", "|")
BAG_LOOP:
  delay %infiniteLoopProtection
  var bag %bags(%totalBags)
  if (%totalBags < 0) then {
    gosub ECHO Auto-setting container variables|  Main: %mainBag|  Backup: %backupBag|  Third: %thirdBag|  Fourth: %fourthBag
    return
  }
  if ("%%bag" = "1") then {
    if matchre("%mainBag", "NULL") then {
      var mainBag %bag
      goto BAG_NEXT
    }
    if matchre("%backupBag", "NULL") then {
      var backupbag %bag
      goto BAG_NEXT
    }
    if matchre("%thirdBag", "NULL") then {
      var thirdBag %bag
      goto BAG_NEXT
    }
    if matchre("%fourthBag", "NULL") then {
      var fourthBag %bag
      goto BAG_NEXT
    }
  }
BAG_NEXT:
  math totalBags subtract 1
  goto BAG_LOOP
#### end bag search
#### return ####
RETURN:
  return
#####
### END OF FILE ###
mapperINCreturn:
