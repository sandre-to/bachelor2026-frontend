@abstract
extends Resource
class_name AbstractDevice

# AbstractDevice:
# Dette er en abstrakt klasse som beskriver hva en nettverks-
# enhet ser ut og hvordan de oppfører seg i nettverket. Det
# er ment for å skille hvordan brukere og servere oppfører seg.


var _hostname: String
var _ip: String

# Nettverket enheten er tilkoblet til
var _connected_network: AbstractNetwork = null

func _init(hostname: String) -> void:
	_hostname = hostname



@abstract
# Send_datapacket(): Sender en datapakke og returnerer responsen
func send_datapacket(datapacket: DataPacket) -> DataPacket

@abstract
# Receive_datapacket(): Metoden som kjører når nettverket ruter en pakke
# 						Dersom porten er åpen kjøres prosessen knyttet til den porten.
func receive_datapacket(datapacket: DataPacket) -> DataPacket


# Connect_to_network():	Kobler enheten til et gitt nettverk
func connect_to_network(network: AbstractNetwork, ip: String) -> void:
	_ip = ip
	_connected_network = network

# Disconnect_from_network():	Avkobler enheten fra nettverket
func disconnect_from_network() -> void:
	_ip = ""
	_connected_network = null
	

func get_hostname() -> String:
	return _hostname

func get_ip() -> String:
	return _ip

func get_network() -> AbstractNetwork:
	return _connected_network
