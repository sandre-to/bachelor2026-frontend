@abstract
extends Resource
class_name AbstractServerProcess

# AbstractServerProcess:
# Dette er en klasse som beskriver serverfunksjonaliteter.

# En dict med alle objekter serveren kan gi og bruke
var resources: Dictionary[String, Variant] = {}

@abstract
# Action():	Funksjonen som inneholder logikken serveren følger.
func action(datapacket: DataPacket) -> DataPacket
