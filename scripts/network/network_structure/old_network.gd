extends Resource
class_name OldNetwork

# AuthoratativeNetwork:
# Dette er klassen som representerer "internettet" i spillet,
# det ruter datapakker mellom enheter og passer på at pakkene
# får lov til å få kontakt.

# Notater: (Kristoffer)
# - Trenger vi en firewall dersom vi har available_ og blocked_devices?
#   Det kan være fint for pedagogiste grunner, men virker kanskje litt rart
#   at en NPC-server trenger en brannmur. Kanskje noen oppgaver krever
#   at man går rundt brannmuren på et vis? Men kan det være CTF, eller blir
#   det for "nettverksorientert"?
# - Når spilleren skal få en respons tilbake, må man ha en port spilleren kan
#	få den på. I virkeligheten er det en tilfeldig port, men dette må settes
#	av applikasjonen.

var available_devices: Array[Device] = []
var hidden_devices: Array[Device] = []



func _init() -> void:
	available_devices.append(
		Device.new("ORACLE", "9.9.9.9")
	)


# Initialize_available_device(): Lager og legger til en dev i available_devices
func initialize_available_device(hostname: String, ip: String) -> Device:
	var dev: Device = Device.new(hostname, ip)
	available_devices.append(dev)
	return dev


# Initialize_hidden_device(): Lager og legger til en dev i hidden_devices
func initialize_hidden_device(hostname: String, ip: String) -> Device:
	var dev: Device = Device.new(hostname, ip)
	hidden_devices.append(dev)
	return dev


# Switch_dev_state():	Gjør en gjemt dev synlig, eller en synlig dev gjemt
func switch_dev_state(hostname: String) -> void:
	var dev: Device = _get_dev_by_hostname(hostname)
	if available_devices.has(dev):
		available_devices.erase(dev)
		hidden_devices.append(dev)
	elif hidden_devices.has(dev):
		hidden_devices.erase(dev)
		available_devices.append(dev)
		

# Route_packet():	Ruter en datapakke til en enhet på det synlige nettverket
func route_packet(datapacket: DataPacket) -> DataPacket:
	var dev: Device = _get_available_dev(datapacket.get_receiver_ip())
	if dev == null:
		return DataPacket.copy_header(
			datapacket, 
			ErrorResponse.new(ErrorResponse.NetworkError.ENETUNREACH)
		)
	
	return dev.receive_datapacket(datapacket)


# _get_available_dev(): Privat hjelpefunksjon
func _get_available_dev(ip: String) -> Device:
	for dev in available_devices:
		if dev.ip == ip:
			return dev
	return null


# _get_dev_by_hostname(): Privat hjelpefunksjon
func _get_dev_by_hostname(hostname: String) -> Device:
	for dev in available_devices:
		if dev.hostname == hostname:
			return dev
	for dev in hidden_devices:
		if dev.hostname == hostname:
			return dev
	return null
