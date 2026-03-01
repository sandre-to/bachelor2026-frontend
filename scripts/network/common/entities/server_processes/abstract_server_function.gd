@abstract
extends Resource
class_name AbstractServerProcess

# AbstractServerProcess:
# Dette er en klasse som beskriver serverfunksjonaliteter.

# En dict med alle objekter serveren kan gi og bruke
var resources: Array[Variant] = []

@abstract
# Action():	Funksjonen som inneholder logikken serveren følger.
func action(datapacket: DataPacket) -> DataPacket


func _to_string() -> String:
	return str(resources)
