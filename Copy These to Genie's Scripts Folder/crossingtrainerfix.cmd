### This script is an automap plugin fix for the stat trainer rooms in Crossing.
### These rooms do not have the full xml feed that other rooms do,
### so the room variables do not populate and the automapper
### thinks it is still in the room you entered from.
### This script is called for all arcs in the connecting room to the trainer,
### since that is where the variables are populated from.
### If a movement error is detected then the script assumes you are
### inside the training room, and moves you into the room the
### variables are populated from before moving you along the
### rest of the auto-mapped path.

if contains("$roomdesc","Many people stand about, watching others engaged in a bizarre ritual") then goto Agility
if contains("$roomdesc","A smattering of applause greets you when you enter the cottage") then goto Charisma
if contains("$roomdesc","The tiny windowless hovel feels cramped despite its minimal furnishings") then goto Discipline
if contains("$roomdesc","This classroom is done in tones of golden yellow and a gentle aqua") then goto Intelligence
if contains("$roomdesc","This room is filled with what at first seems to be a group of demented jugglers and acrobats") then goto Reflex
if contains("$roomdesc","A circular cage set vertically awaits you") then goto Stamina
if contains("$roomdesc","This room, dark and crowded with iron") then goto Strength
if contains("$roomdesc","This large classroom is used at various times for general instruction and the more specialized classes") then goto Wisdom


Trainer:
	action var trainer 0 when ^Obvious paths:|^Obvious exits:
	action var trainer 1 when ^You can't go there\.|^What were you referring to\?
	
	send %0
	waitforre ^You can't|^What were|^Obvious paths:|^Obvious exits:
	if "%trainer" = "1" then
	{
		send out
		pause 0.1
		send %0
	}
	send #parse MOVE SUCCESSFUL
	exit
	
Agility:
	action var trainer 0 when The Crossing, Damaris Lane
	action var trainer 1 when The Academy of Agility
	
	send %0
	waitforre The Academy of Agility|The Crossing, Damaris Lane
	if "%trainer" = "1" then
	{
		send out
		pause 0.1
		send %0
	}
	pause
	send look
	send #parse MOVE SUCCESSFUL
	exit
	
Charisma:
	action var trainer 0 when The Crossing, Water Sprite Way
	action var trainer 1 when Woodruff's Recitation Room
	
	send %0
	waitforre The Crossing, Water Sprite Way|Woodruff's Recitation Room
	if "%trainer" = "1" then
	{
		send out
		pause 0.1
		send %0
	}
	pause
	send look
	send #parse MOVE SUCCESSFUL
	exit
	
Discipline:
	action var trainer 0 when The Crossing, Fostra Square
	action var trainer 1 when A Mud Hovel|The tiny windowless hovel feels cramped despite its minimal furnishings
	
	send %0
	waitforre A Mud Hovel|The Crossing, Fostra Square
	if "%trainer" = "1" then
	{
		send out
		pause 0.1
		send %0
	}
	pause
	send look
	send #parse MOVE SUCCESSFUL
	exit
	
Intelligence:
	action var trainer 0 when Asemath Academy, Northern Walkway
	action var trainer 1 when Asemath Academy, Classroom|This classroom is done in tones of golden yellow and a gentle aqua
	
	send %0
	waitforre Asemath Academy, Classroom|This classroom is done in tones of golden yellow and a gentle aqua
	if "%trainer" = "1" then
	{
		send out
		pause 0.1
		send %0
	}
	pause
	send look
	send #parse MOVE SUCCESSFUL
	exit
	
Reflex:
	action var trainer 0 when The Crossing, Mongers' Bazaar|Some ramshackle stalls and tattered tents comprise the informal flea market known as 
	action var trainer 1 when Rartan's Collegium of Inner Juggling and Reflexology
	
	send %0
	waitforre Rartan's Collegium of Inner Juggling and Reflexology|The Crossing, Mongers' Bazaar
	if "%trainer" = "1" then
	{
		send out
		pause 0.1
		send %0
	}
	pause
	send look
	send #parse MOVE SUCCESSFUL
	exit
	
Stamina:
	action var trainer 0 when The Crossing, Champions' Square
	action var trainer 1 when Barbarian Guild, Stamina Training Room
	
	send %0
	waitforre Barbarian Guild, Stamina Training Room|The Crossing, Champions' Square
	if "%trainer" = "1" then
	{
		send out
		pause 0.1
		send %0
	}
	pause
	send look
	send #parse MOVE SUCCESSFUL
	exit
	
Strength:
	action var trainer 0 when Tembeg's Armory, Workroom|Town Green Northwest
	action var trainer 1 when Tembeg's Armory, Salesroom
	
	send %0
	waitforre Tembeg's Armory, Workroom|Tembeg's Armory, Salesroom|Town Green Northwest
	if "%trainer" = "1" then
	{
		send out
		pause 0.1
		send %0
	}
	pause
	send look
	send #parse MOVE SUCCESSFUL
	exit
	
Wisdom:
	action var trainer 0 when Asemath Academy, Northern Walkway
	action var trainer 1 when Asemath Academy, Classroom|This large classroom is used at various times for general instruction and the more specialized classes
	
	send %0
	waitforre Asemath Academy, Northern Walkway|TThis large classroom is used at various times for general instruction and the more specialized classes
	if "%trainer" = "1" then
	{
		send out
		pause 0.1
		send %0
	}
	pause
	send look
	send #parse MOVE SUCCESSFUL
	exit