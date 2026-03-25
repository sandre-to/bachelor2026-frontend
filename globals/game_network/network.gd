extends Node
class_name Network

# Network:
# Det simulerte nettverket

# Tilkoblede enheter
@export var connected_entities: Array[AbstractDevice]

# Brukerens nettverkskort
@export var user_device: UserDevice

func _ready() -> void:
	user_device = UserDevice.new("brukernavn ig")



# Send_from_user():	Sender en datapakke fra brukeren til en enhet på nettverket
func send_from_user(to_ip: String, to_port: int, content: PacketData) -> DataPacket:
	var to_send: DataPacket = DataPacket.new(
		user_device.get_ip(),
		to_ip, to_port,
		content
	)
	return _route_packet(to_send)



# Send_to_user():	Sender en datapakke fra en IP-adresse
#					IP-adressen trenger ikke å eksistere på nettet og porten er bare for show
func send_to_user(from_ip: String, to_port: int, content: PacketData) -> void:
	var to_send: DataPacket = DataPacket.new(
		from_ip,
		user_device.get_ip(), to_port,
		content
	)
	user_device.receive_datapacket(to_send)



# _route_packet():	Ruter en datapakke til en enhet på nettverket
func _route_packet(datapacket: DataPacket) -> DataPacket:
	var dev: AbstractDevice = _get_dev(datapacket.get_receiver_ip())
	if dev == null:
		return DataPacket.copy_header(
			datapacket,
			ErrorResponse.new(ErrorResponse.NetworkError.ENETUNREACH)
		)
	return dev.receive_datapacket(datapacket)



# Get_dev_by_hostname():	Gir nettverksenheten basert på vertsnavnet
func get_dev_by_hostname(hostname: String) -> AbstractDevice:
	for dev in connected_entities:
		if dev.get_hostname() == hostname:
			return dev
	return null



# Connect_device():	Kobler til en enhet til nettverket
#					Returnerer en bool for å sjekke om det gikk
func connect_device(device: AbstractDevice) -> bool:
	var new_ip: String = _generate_ip()
	if new_ip == "":
		return false
	device.set_ip(new_ip)
	connected_entities.append(device)
	return true



# Disconnect_device():	Avkobler en enhet
#						Returnerer en bool for å indikere om noe skjedde
func disconnect_device(device: AbstractDevice) -> bool:
	var dumbass_index: int = connected_entities.find(device)
	if dumbass_index == -1:
		return false
	connected_entities.remove_at(dumbass_index)
	return true
	
	
	
# _generate_ip():	Genererer en ny IP-adresse for for en nytilkoblet enhet.
#					Returnerer en tom string dersom det ikke finnes en ledig IP.
func _generate_ip() -> String:
	# Liten sjekk i tilfellet det er dritmange enheter på nettverket.
	# Dette burde aldri skje, men man anner ikke hva disse tullingene
	# kommer til å finne på.
	if connected_entities.size() > 400000000:
		return ""
	
	while true:
		# Generer en tilfeldig IP
		var ip: String = ""
		for i in range(4):
			ip += str(1 + (randi() % 254))
			if i < 3:
				ip += "."
		# Sjekk om IP-en er i bruk
		if connected_entities.find_custom(func(dev): return dev.get_ip() == ip) == -1:
			return ip
	return ""
	
	
	
# _get_dev():	Returnerer en nettverksenhet basert på IP.
func _get_dev(ip: String) -> AbstractDevice:
	var dev_index: int = connected_entities.find_custom(func(dev): return dev.get_ip() == ip)
	if dev_index == -1:
		return null
	return connected_entities[dev_index]
