@abstract
extends Resource
class_name TaskCMD

# TaskCMD:
# Dette er en abstakt klasse som beskriver en kommando 
# en oppgave kan utføre.

# Notater (Kristoffer):
# - Alle TaskCMD-klasser burde ha en statisk fabrikkmetode som verifiserer inputtet
#	før objektet lages (pls kall metoden "create()"). Den burde ta inn parametrene 
#	gitt av oppgave-JSONen og taskobjektet, så burde den bruke parametrene for å
#	hente de objektene den trenger og verifisere om objektene er riktig type. I tillegg,
#	dersom det trengs burde den også hente andre miljøspesifike objekter fra brukeren, 
#	e.g. nettverket. For et eksempel av en slik metode, se på den i "open_port_cmd.gd".

var params: Dictionary[String, Variant]
var task: Task

func _init(_params: Dictionary[String, Variant], _task: Task) -> void:
	params = _params
	task = _task

@abstract
func execute() -> bool
