@abstract
extends Resource
class_name Server

# Kontaktinformasjon
var ip_addr: String
var hostname: String

# De forskjellige prosessene:
# Key = Port, Value = Prosessfunksjon
var network_processes: Dictionary[int, Callable]

# Brannmuren
var firewall: Firewall

# Applikasjonens blokkeringsmekanisme (White- / Black-list)
var block_list: Array[String]

# Hvilken blokkeringsmetode er aktiv? (By default: Ingen)
enum AppBlockStatus {NONE, WHITE_LIST, BLACK_LIST}
var app_block_active = AppBlockStatus.NONE


func is_firewall_blocked(packet: NetworkPacket) -> bool:
	return firewall.is_blocked(packet.from_ip)

func is_port_open(packet: NetworkPacket) -> bool:
	return network_processes.has(packet.to_port)

func call_process(port: int) -> HttpResponse:
	# Kjør prosessen
	var response: HttpResponse = network_processes.get(port).call()
	
	# Hvis for en eller en annen grunn prosessen ikke returnerer en HTTP-respons
	return response if response != null else HttpResponse.new(
		HttpResponse.ResponseCode.INTERNAL_SERVER_ERROR,
		"Dum dum prosess returnerer ingen respons >:("
	)
