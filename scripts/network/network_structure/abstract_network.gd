@abstract
extends Resource
class_name AbstractNetwork

# AbstractNetwork:
# Dette er den abstrakte klassen som beskriver felleskapene
# til nettverket i storymodus og kompetetivmodus.

# Errorkoder
enum ErrorCode{
	OK,
	INVALID_IP,
	NET_DEV_NOT_FOUND
}
var errno: ErrorCode = ErrorCode.OK

var connected_entities: Array[AbstractDevice]



@abstract
# Route_packet():	Ruter en datapakke til en enhet på det synlige nettverket
func route_packet(datapacket: DataPacket) -> DataPacket

@abstract
# Let_device_connect():	Lar en enhet koble til nettverket.
func let_device_connect(device: AbstractDevice) -> bool

@abstract
# Disconnect_device():	Avkobler en enhet fra nettverket.
#						Returnerer en bool basert på om enheten eksisterer eller ikke.
func disconnect_device(device: AbstractDevice) -> bool


# Is_valid_ip():		Sjekker om en gitt IP-adresse er gyldig.
func is_valid_ip(ip: String) -> bool:
	if ip.get_slice_count(".") != 4:
		set_error(ErrorCode.INVALID_IP)
		return false
	
	for i in range(4):
		var segment: String = ip.get_slice(".", i)
	
		# Er segmentet en int?
		if not segment.is_valid_int():
			set_error(ErrorCode.INVALID_IP)
			return false

		# Er segmentet mellom 0 og 255?
		var seg_int: int = segment.to_int()
		if seg_int > 255 or seg_int < 0:
			set_error(ErrorCode.INVALID_IP)
			return false
	
	return true
	

# Set_error():	Setter en ny error
func set_error(error: ErrorCode) -> void:
	errno = error
	
# Get_error():	Returnerer den nåverende erroren og reset verdien.
func get_error() -> ErrorCode:
	var to_return: ErrorCode = errno
	errno = ErrorCode.OK
	return to_return
