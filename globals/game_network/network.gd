extends Node
class_name Network

# Network:
# Det simulerte nettverket

# Brukerens IP-adresse
@export var user_ip: String

# Tilkoblede servere
@export var connected_servers: Array[Server]

# Statiske servere
var _dns: Server = DnsServer.new()



func _ready() -> void:
	user_ip = _generate_ip()
	
	# Koble til statiske servere
	connect_server(_dns, DnsServer.static_ip)	# DNS



# Send_from_user():	Sender en datapakke fra brukeren til en server på nettverket
func send_from_user(recipient_address: String, recipient_port: int, content: Dictionary) -> DataPacket:
	# Sjekk om man trenger DNS
	if not recipient_address.is_valid_ip_address():
		var dns_request: DataPacket = DataPacket.new(
			user_ip, DnsServer.static_ip, 53, {"domain": recipient_address}
		)
		var dns_response: DataPacket = _route_packet(dns_request)
		if dns_response.get_content().has("error"):
			return dns_response
		
		recipient_address = dns_response.get_content().get("ip")
		if recipient_address == "no-match":
			return dns_response
	
	var to_send: DataPacket = DataPacket.new(
		user_ip,
		recipient_address, recipient_port,
		content
	)
	return _route_packet(to_send)



# Get_dev_by_hostname():	Gir serveren basert på vertsnavnet
func get_server_by_hostname(hostname: String) -> Server:
	for server in connected_servers:
		if server.get_hostname() == hostname:
			return server
	return null



# Connect_server():	Kobler til en server til nettverket
#					Returnerer en bool for å sjekke om det gikk
func connect_server(server: Server, static_ip = "") -> bool:
	var valid_ip: String
	if static_ip.is_valid_ip_address() && not _ip_in_use(static_ip):
		valid_ip = static_ip
	else:
		valid_ip = _generate_ip()
	server.set_ip(valid_ip)
	connected_servers.append(server)
	return true



# Disconnect_server():	Avkobler en server
#						Returnerer en bool for å indikere om noe skjedde
func disconnect_server(server: Server) -> bool:
	var dumbass_index: int = connected_servers.find(server)
	if dumbass_index == -1:
		return false
	connected_servers.remove_at(dumbass_index)
	return true



# Dns():	Returnerer DNS-serveren (Navnet indikerer at man jobber med DNS)
func dns() -> DnsServer:
	return _dns



# _route_packet():	Ruter en datapakke til en server på nettverket
func _route_packet(datapacket: DataPacket) -> DataPacket:
	var server: Server = _get_server(datapacket.get_receiver_ip())
	if server == null:
		return DataPacket.create_reply_packet(
			datapacket,
			{
				"error": "Connection Timed Out"
			}
		)
	return server.receive_datapacket(datapacket)



# _generate_ip():	Genererer en ny IP-adresse for for en nytilkoblet enhet.
#					Returnerer en tom string dersom det ikke finnes en ledig IP.
#		   Notat:	Denne funksjonen kan muligens holde på for ALLTID, det er ganske 
#					usannsynlig, men vi bor i en grusom verden så det kommer 
#					HELT sikkert til å skje; refaktorer.
func _generate_ip() -> String:
	while true:
		# Generer en tilfeldig IP
		var ip: String = ""
		for i in range(4):
			ip += str(1 + (randi() % 254))
			if i < 3:
				ip += "."
		# Sjekk om IP-en er i bruk
		if not _ip_in_use(ip):
			return ip
	return ""



# _ip_in_user():	Sjekker om en IP-adresse er tatt i bruk
func _ip_in_use(ip: String) -> bool:
	for server in connected_servers:
		if server.get_ip() == ip:
			return true
	return false



# _get_server():	Returnerer en nettverksenhet basert på IP.
func _get_server(ip: String) -> Server:
	var server_index: int = connected_servers.find_custom(func(server): return server.get_ip() == ip)
	if server_index == -1:
		return null
	return connected_servers[server_index]
