# CLAUDE.md

Guidance for AI assistants (Claude Code and others) working in this repository.

## What this repository is

This is the **map data repository for the Genie client's AutoMapper**, used to
navigate Elanthia in the MUD **DragonRealms**. It contains no application code,
no build system, and no test suite — the deliverables are XML map files, a map
index CSV, and a handful of helper scripts. The Genie client consumes these
files directly; players update their maps by copying the repo contents into
`<genie folder>/Maps`.

Community coordination happens in the `#automapper` Discord channel
(https://discord.gg/MtmzE2w). Contribution instructions live at
https://github.com/GenieClient/Genie4/wiki/08.-AutoMapper#contribute-to-the-map-repository

## Repository layout

| Path | Contents |
|---|---|
| repo root (`Map*.xml`) | Regular game-area maps, loaded from Genie's Maps folder |
| `Festivals Copy to the Maps Folder/` | Festival maps; users copy these in only when a festival is live |
| `Quests (Spoiler Alert) Copy to the Maps Folder/` | Quest maps (contain spoilers); opt-in copy |
| `Archived Maps/` | Old versions of festival/quest maps kept for history (e.g. prior-year Duskruin, Su Helmas) |
| `Copy These to Genie's Scripts Folder/` | Genie `.cmd` scripts that the maps' `move` commands invoke (e.g. `travel.cmd`, `autoclimbup.cmd`) |
| `mapnames.csv` | The map index: `Name,ID,extra`. Reserve a new ID here **before** creating a new map |
| `README.txt` | Canonical statement of the conventions summarized below |
| `colorconvert`, `utf8convert` | One-off bash maintenance scripts (named-color → hex, encoding normalization) |

## Naming and zone-ID conventions

- Number all maps (rare exceptions exist). **Reserve the number in
  `mapnames.csv` before creating a new map.**
- Zone ID ranges:
  - `1–299` — regular game areas
  - `500–799` — festival and quest maps
  - `900–999` — special maps (Wyvern Arena 997, Transports 998, Microcosm 999)
  - `TF` prefix — The Fallen content (`MapTF1`, `MapTF990`)
- Filename format: `Map<id>_<Short_Name>.xml` — underscores replace spaces;
  apostrophes are kept (`Map47_Muspar'i.xml`).
- The `id` attribute of the `<zone>` tag must match the id embedded in the
  filename exactly.
- Sub-maps of an area use a letter suffix on the same number
  (`Map1_Crossing.xml`, `Map1a_Crossing_Thief_Passages.xml`); the letter goes
  in the CSV's `extra` column: `Crossing Thief Passages,1,a`.
- Festival-folder maps append `f` to the id
  (`Map612f_Hollow_Eve_Festival_2025.xml`, `<zone ... id="612f">`,
  CSV row `Hollow Eve Festival 2025,612,f`).
- Quest-folder maps append `q` the same way
  (`Map500q_The_Grey_Raven_Prison.xml`, `id="500q"`).
- Exception: a festival overlay of a regular game zone keeps the base zone's id
  with **no** `f` suffix (Festival of the Boar → 127, Gor'Tog Culture Faire →
  4a, Shard Street Faire → 67).

## Map XML format

Each map is a single `<zone>` document:

```xml
<?xml version="1.0" encoding="utf-8"?>
<zone name="Lake of Dreams" id="2">
  <node id="2" name="Mycthengelde, Knoll" note="Map4_Crossing_West_Gate.xml|Crossing" color="#00FFFF">
    <description>Daytime room description...</description>
    <description>Alternate (night/seasonal) description...</description>
    <position x="0" y="0" z="0" />
    <arc exit="south" move="south" destination="3" />
    <arc exit="go" move="go trench" destination="1" />
  </node>
  <label text="The Strand">
    <position x="183" y="369" z="0" />
  </label>
</zone>
```

Elements and attributes in use:

- **`<zone name id>`** — root element; `id` matches the filename.
- **`<node id name [note] [color]>`** — one room. `id` is unique within the
  zone. Multiple `<description>` children hold the room's variant descriptions
  (day/night/seasonal); the mapper matches on any of them.
- **`<position x y z />`** — drawing coordinates; rooms are typically laid out
  on a 20-unit grid, `z` for different levels.
- **`<arc exit move [destination] [hidden] />`** — an exit. `exit` is the
  direction shown (compass directions, `up`/`down`/`out`, `go`, `climb`,
  `jump`, `dive`, `none`); `move` is the literal command Genie sends, which can
  be a plain direction, a command like `go rough trench`, or a script call.
  `destination` is the target node id in the same zone; omit it for arcs
  leaving the map. `hidden="True"` marks exits not shown in the room's obvious
  paths.
- **`<label text>`** with a nested `<position />` — free-floating text drawn on
  the map.
- **`note`** — pipe-separated list. Used for `#goto` targets/aliases
  (`note="Town Green|TGN|Wanted Board"`) and for cross-map links in the form
  `Map<file>.xml|<label>` (e.g. `note="Map4_Crossing_West_Gate.xml|Crossing"`)
  connecting zone boundaries. `#goto` label conventions:
  http://www.elanthia.org/GenieSettings/#Labels

## Node colors

Use **hex codes only** (never named colors) for maximum compatibility; the
`colorconvert` script exists to fix named colors. Order indicates priority when
a room qualifies for more than one:

| Color | Hex | Meaning |
|---|---|---|
| Fuchsia | `#FF00FF` | throughpoint, portal, or transport |
| Lime | `#00FF00` | other room of economic interest (bank, exchange, loot buyers, post office, services) |
| Orange | `#FF8000` | guildleader |
| Mint | `#00BF80` | auto-healer |
| Red | `#FF0000` | room where you can purchase an item |
| Yellow | `#FFFF00` | stat training room |
| Blue | `#0000FF` | water room (swimming required) |
| Navy | `#000080` | underwater room (drowning possible) |
| Amber | `#FFBF00` | roundtime or other non-swimming obstacle |
| Sienna | `#993300` | mining room |
| Green | `#008000` | lumber room |
| Sand | `#C2B280` | Ranger trailhead |
| Aqua | `#00FFFF` | PC housing |
| Periwinkle | `#A6A3D9` | pilgrim badge shrine |
| Eggplant | `#400040` | depart room |
| Purple | `#800080` | favor altar |

## File encoding — handle with care

- Map files are **UTF-8** (historically UTF-16LE; `utf8convert` did the
  migration). Some files carry a UTF-8 BOM — **preserve the BOM state of any
  file you edit**.
- Nearly all files use **CRLF line endings**; keep them. Do not let an editor
  or tool rewrite line endings, strip BOMs, or re-indent/reflow the XML.
- Room `<description>` lines are very long single lines by design. Do not wrap
  them, and do not "clean up" double spaces inside them — descriptions must
  match game text exactly for the mapper to recognize rooms.

## Genie scripts (`Copy These to Genie's Scripts Folder/`)

These are Genie 4 script files (`.cmd`) in Genie's own scripting language
(`action`/`send`/`waitforre`/`goto`/`put #parse ...`), not Windows batch files.
Map arcs reference them for complex movement (auto-climbing, ferries, bypasses),
and `travel.cmd` is a full cross-continent travel system that depends on these
maps and the ExpTracker plugin. Edit them only with knowledge of Genie script
syntax, and keep the `MOVE SUCCESSFUL` / `MOVE FAILED` `#parse` signals intact —
the automapper waits on them.

## Workflow for common changes

**Adding a new map**
1. Reserve the next free ID by adding a row to `mapnames.csv`
   (`<name>,<numericId>,<extra-letter-or-f/q-suffix>`).
2. Create `Map<id>_<Short_Name>.xml` in the correct folder (root, Festivals, or
   Quests) with a matching `<zone id>`.
3. Follow the color and note conventions above.

**Updating an existing map**
- Edit nodes/arcs in place; keep node ids stable where possible (external
  scripts like `travel.cmd` reference room numbers).
- Match new room descriptions to the exact in-game text.

**Retiring a festival/quest map**
- Move the old version to `Archived Maps/`, typically renaming it with the year
  (e.g. `Map505_Drathrok's_Duskruin-2024.xml`).

**Validation**
- There is no CI. Sanity-check edited XML with `xmllint --noout <file>` (or
  equivalent) before committing, and verify the zone id / filename / CSV row
  all agree.

**Git**
- `main` is the default branch; contributions arrive as PRs from forks and are
  merged by maintainers. Commit messages are short and descriptive of the area
  touched (e.g. "Crossing and Temporal Pocket", "Travel v5.6").
- The only ignored file is `.DS_Store`.
