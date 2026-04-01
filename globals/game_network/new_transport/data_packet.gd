extends RefCounted
class_name DataPacket

# Datapacket:
# Et objekt som representerer en datapakke sendt over nettverket.
# Objektet har en header og et datafelt som kan være en av tre datatyper.

# Headerfelt
var _sender_ip: String
var _receiver_ip: String
var _receiver_port: int

# Typen innhold, altså protokollen brukt, f.eks: HTTP, Fil eller rå-tekst.
var _packet_type: Variant

# Selve innholdet, kan være en Array, Dictionary, String eller File.
var _data: Variant



func _init(
		_s_ip: String, _r_ip: String, _r_port: int, _content_type: Variant, _content: Variant
	) -> void:
	self._sender_ip = _s_ip
	self._receiver_ip = _r_ip
	self._receiver_port = _r_port
	self._data = _content



# Create_reply_packet():	Lager en datapakke med byttet sender og mottaker IP-adresse
static func create_reply_packet(
		recipient_packet: DataPacket, packet_type: Variant, packet_data: Variant
	) -> DataPacket:
	return DataPacket.new(
		recipient_packet.get_receiver_ip(),
		recipient_packet.get_sender_ip(),
		recipient_packet.get_receiver_port(),
		packet_type, packet_data
	)



func get_sender_ip() -> String:
	return _sender_ip

func get_receiver_ip() -> String:
	return _receiver_ip

func get_receiver_port() -> int:
	return _receiver_port

func get_packet_type() -> Variant:
	return _packet_type

func get_data() -> Variant:
	return _data
