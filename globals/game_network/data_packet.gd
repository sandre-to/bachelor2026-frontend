extends RefCounted
class_name DataPacket

# Datapacket:
# Et objekt som representerer en datapakke sendt over nettverket.
# Objektet har en header og et datafelt som kan være en av tre datatyper.

# Headerfelt
var _sender_ip: String
var _receiver_ip: String
var _receiver_port: int

# Innholdet, formulert som JSON
var _content: Dictionary


func _init(
		s_ip: String, r_ip: String, r_port: int, content: Dictionary
	) -> void:
	self._sender_ip = s_ip
	self._receiver_ip = r_ip
	self._receiver_port = r_port
	self._content = content



# Create_reply_packet():	Lager en datapakke med byttet sender og mottaker IP-adresse
static func create_reply_packet(
		recipient_packet: DataPacket, content: Dictionary
	) -> DataPacket:
	return DataPacket.new(
		recipient_packet.get_receiver_ip(),
		recipient_packet.get_sender_ip(),
		recipient_packet.get_receiver_port(),
		content
	)



func get_sender_ip() -> String:
	return _sender_ip

func get_receiver_ip() -> String:
	return _receiver_ip

func get_receiver_port() -> int:
	return _receiver_port

func get_content() -> Dictionary:
	return _content
