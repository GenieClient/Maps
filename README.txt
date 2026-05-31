# Maps of Elanthia

## How to update your maps
1. [Download](https://github.com/GenieClient/Maps/archive/refs/heads/main.zip) a zip of all the maps
2. Unzip the file
3. Copy the unzipped contents to your `<genie folder>/Maps` directory

Questions? Issues? Please join the conversation in the [#automapper Discord channel](https://discord.gg/MtmzE2w)

Instructions for contributing to Genie Maps: 
  https://github.com/GenieClient/Genie4/wiki/08.-AutoMapper#contribute-to-the-map-repository
## Best practices

Number all the maps (exceptions exist).
Reserve a new number in mapnames.csv before creating a new map.

Zone ID categories:
  Game maps (regular DR areas)        1-299
  Festival/Quest maps                 500-799
  Special maps (Wyvern, Microcosm)    900-999
  The Fallen content                  TF prefix (e.g., TF1, TF990)

Folder layout:
  Game maps        -> repo root
  Festival maps    -> "Festivals Copy to the Maps Folder/"
  Quest maps       -> "Quests (Spoiler Alert) Copy to the Maps Folder/"
  Archived maps    -> "Archived Maps/"

Filename + zone ID format:
  Filename : Map<id>_<short_name>.xml  (underscores replace spaces)
  Zone tag : <zone name="..." id="<id>">  (id matches the filename exactly)
  CSV row  : <name>,<numericId>,<extra>

Files in the Festivals folder append "f" to the id:
  Filename : Map612f_Hollow_Eve_Festival_2025.xml
  Zone tag : id="612f"
  CSV row  : Hollow Eve Festival 2025,612,f

Files in the Quests folder append "q" to the id:
  Filename : Map500q_The_Grey_Raven_Prison.xml
  Zone tag : id="500q"
  CSV row  : The Grey Raven Prison,500,q

Exception: festival overlays of a regular game zone share the base game
zone's id without the "f" suffix (Festival of the Boar at id 127, Gor'Tog
Culture Faire at id 4a, Shard Street Faire at id 67).

Please use the HEX CODES to ensure maximum compatibility.
Color order indicates priority.

Fuchsia     (#FF00FF)    throughpoint, portal, or transport
Lime        (#00FF00)    other room of economic interest (bank teller, exchange, loot buyers, post office, services, etc.)
Orange      (#FF8000)    guildleader
Mint        (#00BF80)    auto-healer
Red         (#FF0000)    room where you can purchase an item
Yellow      (#FFFF00)    stat training room
Blue        (#0000FF)    water room (swimming required)
Navy        (#000080)    underwater room (drowning possible)
Amber       (#FFBF00)    roundtime or other non-swimming obstacle
Sienna      (#993300)    mining room
Green       (#008000)    lumber room
Sand        (#C2B280)    Ranger trailhead
Aqua        (#00FFFF)    PC housing
Periwinkle  (#A6A3D9)    pilgrim badge shrine
Eggplant    (#400040)    depart room
Purple      (#800080)    favor altar

#goto label conventions: http://www.elanthia.org/GenieSettings/#Labels
