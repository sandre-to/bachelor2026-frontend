extends Resource
class_name Device

# Device:
# Denne klassen representerer en enhet på nettverket.
# Både spilleren(e) og vanlige servere representeres av denne klassen.

# Notater: (Kristoffer)
# -	Skal spilleren(e) ha mulighet til å lage sine egne servere?
#	Hadde vært litt morsomt, men anner ikke hva det kan brukes til
#	eller evt hvordan man implementerer noe som det.
# - Denne klassen virker veldig lackluster, det er ganske lite her
#	og jeg vet ikke om det er en bedre måte å gjennomføre dette på.

# Referansen til nettverket. Om null, kan det sies av enheten ikke har internet.
var network_connection: AuthoratativeNetwork

var hostname: String
var ip: String

var firewall: Firewall
var ports: Dictionary[int, Callable] = {}	# OBS: Viktig av Callable returnerer en Datapacket


func _init(_hostname: String, _ip: String, _auth_network: AuthoratativeNetwork) -> void:
	hostname = _hostname
	ip = _ip
	network_connection = _auth_network
	firewall = Firewall.new()


# Send_datapacket(): Sender en datapakke og returnerer responsen
func send_datapacket(datapacket: DataPacket) -> DataPacket:
	return network_connection.route_packet(datapacket)


# Receive_datapacket(): Metoden som kjører når nettverket ruter en pakke
# 						Dersom porten er åpen kjøres prosessen knyttet til den porten.
func receive_datapacket(datapacket: DataPacket) -> DataPacket:
	if not port_is_open(datapacket.get_receiver_port()):
		return DataPacket.copy_header(datapacket, "Connection Refused")
	return ports.get(datapacket.get_receiver_port()).call(datapacket)


# Port_is_open(): Returnerer en bool basert på om porten er åpen.
func port_is_open(port: int) -> bool:
	return ports.has(port)


# Open_port(): Åpner en gitt port og gir den en prosess.
func open_port(port: int, process: Callable) -> bool:
	if port_is_open(port):
		return false
	ports.set(port, process)
	return true


# Close_port(): Lukker en gitt port.
func close_port(port: int) -> bool:
	return ports.erase(port)
	 
