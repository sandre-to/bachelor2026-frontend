extends Resource
class_name AuthNetwork

# Alle entitetene
var servers: Array[Server]

func send_networkpacket() -> HttpResponse:
	
	# Midlertidig informasjon
	var content = "HARDKODA INNHOLD: ERSTATT ETTERSOM TING FUNGERER :)"
	var from_ip = "12.23.34.45"
	var port    = 443
	var to_ip   = "100.219.21.53"
	var datapacket := NetworkPacket.new(to_ip, port, from_ip, content)
	
	# Mottakeren
	var receiver: Server = _get_server(to_ip)
	
	if receiver == null or receiver.is_firewall_blocked(datapacket):
		return HttpResponse.new(
			HttpResponse.ResponseCode.REQUEST_TIMEOUT,
			"Connection Timed Out"
			)
	
	if receiver.is_port_open(datapacket):
		return HttpResponse.new(
			HttpResponse.ResponseCode.REQUEST_TIMEOUT,
			"Connection Refused"
			)
	
	# Pakken er sendt til en gyldig mottaker, send til prosess
	return receiver.call_process(datapacket)


# Henter nettverksobjektet, returnerer null hvis den ikke eksisterer
func _get_server(ip: String) -> Server:
	for server in servers:
		if server.ip_addr == ip:
			return server
	return null
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
