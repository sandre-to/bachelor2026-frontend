extends Resource
class_name DataPacket

# Datapacket:
# Et objekt som representerer en datapakke sendt over nettverket.
# Objektet har en header og et datafelt som kan være en av tre datatyper.

# Headerfelt
var _sender_ip: String
var _receiver_ip: String
var _receiver_port: int

# Innholdet. Dette skal enten være en HTTP-respons, File, ErrorResponse eller tekst.
var _data: Variant


func _init(_s_ip: String, _r_ip: String, _r_port: int, _content: Variant) -> void:
	self._sender_ip = _s_ip
	self._receiver_ip = _r_ip
	self._receiver_port = _r_port
	self._data = _content
	
	
# Copy_header():	Lager en ny datapakke med de samme IP-adressene.	[APPLIKASJONEN MÅ SETTE EN PORT HER]
static func copy_header(datapacket: DataPacket, port, content: Variant) -> DataPacket:
	return DataPacket.new(
		datapacket._receiver_ip,
		datapacket._sender_ip,
		port, 
		content
	)
	
func get_sender_ip() -> String:
	return _sender_ip

func get_receiver_ip() -> String:
	return _receiver_ip

func get_receiver_port() -> int:
	return _receiver_port

func get_data() -> Variant:
	return _data

func _to_string() -> String:
	var content_type: String = "Text"
	if _data is File:
		content_type = "File"
	elif _data is HttpResponse:
		content_type = "HTTP-response"
	elif _data is ErrorResponse:
		content_type = "Error"
	return "Datapacket:\nSender IP:\t\t%s\nReceiver IP:\t%s\nReceiver Port:\t%s\nContent is:\t\t%s\n" % [_sender_ip, _receiver_ip, str(_receiver_port), content_type]
