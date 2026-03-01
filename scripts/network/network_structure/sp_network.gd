extends AbstractNetwork
class_name SPNetwork

# SPNetwork:
# Denne klassen (Single Player Network) representerer nettverket
# i singerplayer modus.


# Route_packet():	Ruter en datapakke til en enhet på nettverket
func route_packet(datapacket: DataPacket) -> DataPacket:
	var dev: AbstractDevice = _get_dev(datapacket.get_receiver_ip())
	if dev == null:
		print("wat")
		return DataPacket.copy_header(
			datapacket,
			ErrorResponse.new(ErrorResponse.NetworkError.ENETUNREACH)
		)
	return dev.receive_datapacket(datapacket)


# Let_device_connect():	Lar en enhet koble til nettverket.
func connect_device(device: AbstractDevice) -> bool:
	var new_ip: String = _generate_ip()
	if new_ip.is_empty():
		return false
	device.connect_to_network(self, new_ip)
	connected_entities.append(device)
	return true


# Disconnect_device():	Avkobler en enhet fra nettverket.
#						Returnerer en bool basert på om enheten eksisterer eller ikke.
func disconnect_device(device: AbstractDevice) -> bool:
	if not connected_entities.has(device):
		return false
	device.disconnect_from_network()
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
