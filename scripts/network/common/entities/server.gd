extends AbstractDevice
class_name Server

# Server:
# Dette er klassen som representerer hvordan servere 
# kontrollert av oppgaver oppfører seg.

# Åpne porter som er knyttet til en serverprosess
var open_ports: Dictionary[int, AbstractServerProcess] = {}

func _init(hostname: String, ip: String = "") -> void:
	super(hostname, ip)


# Send_datapacket(): Sender en datapakke og returnerer responsen
func send_datapacket(datapacket: DataPacket) -> DataPacket:
	return get_network().route_packet(datapacket)


# Receive_datapacket(): Metoden som kjører når nettverket ruter en pakke
func receive_datapacket(datapacket: DataPacket) -> DataPacket:
	if not port_is_open(datapacket.get_receiver_port()):
		return DataPacket.copy_header(
			datapacket,
			"Connection Refused"
		)
	return open_ports.get(datapacket.get_receiver_port()).action(datapacket)


# Open_port():	Åpner en gitt port med en gitt serverprosess
func open_port(port: int, process: AbstractServerProcess) -> bool:
	if port > 65535 or port < 1:
		return false
	if open_ports.has(port):
		return false
		
	open_ports[port] = process
	return true
	
	
# Close_port():	Lukker en gitt port
func close_port(port: int) -> bool:
	return open_ports.erase(port)

# Port_is_open():	Herregud du vet
func port_is_open(port: int) -> bool:
	return open_ports.has(port)
