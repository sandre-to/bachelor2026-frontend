extends Server
class_name DnsServer

# Den konstante IP-adressen til hoved DNS-serveren
const static_ip = "8.8.8.8"

# Domenenavn knyttet til IP-adresse; {Domenenavn: IP}
var _dns_records: Dictionary[String, String] = {}

func _init() -> void:
	_hostname = "Bunni Public DNS"
	open_port(53, dns_lookup)



func dns_lookup(dp: DataPacket) -> DataPacket:
	var response_payload: Dictionary[String, String]
	if dp.get_content().has("domain"):
		response_payload = {
			"ip": get_domain(dp.get_content().get("domain"))
		}
	else:
		response_payload = {
			"error": "bad-request"
		}
	return DataPacket.create_reply_packet(dp, response_payload)



func add_domain_name(domain_name: String, ip_address: String) -> void:
	if not _dns_records.has(domain_name):
		_dns_records.set(domain_name, ip_address)



func remove_domain(domain_name: String) -> void:
	_dns_records.erase(domain_name)
	
	

func get_domain(domain_name: String) -> String:
	return _dns_records.get(domain_name, "no-match")
