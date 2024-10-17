#mapperINC.cmd
# THE include script for automapper.cmd and travel.cmd
var version 1.2024-10-17
goto mapperINCreturn

#2024-10-17
# Hanryu
#   take subs that overlap from travel and automapper and pull them into a common include
#   initial release

#### check citizenship for shard ####
CITIZENSHIP:
  if !def(citizenship) then {
    put #var citizenship none
    action (citizenship) put #var citizenship $1 when "^\s*\d\)\s+of (Aesry Surlaenis'a|Forfedhdar|Ilithi|M'Riss|Ratha|Therengia|Velaka|Zoluren|Acenamacra|Arthe Dale|Crossing|Dirge|Ilaya Taipa|Kaerna Village|Leth Deriel|Fornsted|Hvaral|Langenfirth|Riverhaven|Rossman's Landing|Siksraja|Therenborough|Fayrin's Rest|Shard|Steelclaw Clan|Zaldi Taipa|Ain Ghazal|Boar Clan|Hibarnhvidar|Raven's Point|Mer'Kresh|Muspar'i)"
    put title affiliation list
    send encumbrance
    waitfor Encumbrance :
    action (citizenship) off
  }
return
####

####
ECHO:
  var echoVar $0
  eval border replacere("%echoVar", ".", "~")
  put #echo
  put #echo %color <~~~%border~~~>
  put #echo %color <<  %echoVar  >>
  put #echo %color <~~~%border~~~>
  put #echo
  return
####

#### return ####
RETURN:
  return
#####

### END OF FILE ###
mapperINCreturn:
  return
