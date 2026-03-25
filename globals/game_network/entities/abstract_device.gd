@abstract
extends Resource
class_name AbstractDevice

# AbstractDevice:
# Dette er en abstrakt klasse som beskriver hva en nettverks-
# enhet ser ut og hvordan de oppfører seg i nettverket. Det
# er ment for å skille hvordan brukere og servere oppfører seg.


var _hostname: String
var _ip: String

func _init(hostname: String) -> void:
	_hostname = hostname


	
@abstract
# Receive_datapacket(): Metoden som kjører når nettverket ruter en pakke
# 						Dersom porten er åpen kjøres prosessen knyttet til den porten.
func receive_datapacket(datapacket: DataPacket) -> DataPacket



func get_hostname() -> String:
	return _hostname

func set_ip(ip: String) -> void:
	_ip = ip

func get_ip() -> String:
	return _ip
