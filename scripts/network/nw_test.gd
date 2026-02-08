extends Node

# Notater:
# - Raffiner transportentitetene
# - Gjør Device til en klasse andre klasser arver fra.
#	På den måten kan man inkludere serverprosessen i klassen,
#	og gir den tilgang til deviceobjektet.

func _ready() -> void:
	# Initialiserer internettet:
	var auth_net: AuthoratativeNetwork = AuthoratativeNetwork.new()
