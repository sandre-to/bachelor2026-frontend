extends PacketData
class_name ErrorResponse

# ErrorResponse:
# Et objekt som beskriver en feilmelding som oppsto under applikasjonslaget.

enum NetworkError {
	OK,				# Ok
	ENETDOWN, 		# Nettverket er nede
	ENETUNREACH, 	# Kan ikke nå nettverket
	ETIMEDOUT, 		# Forbindelsen timed out
	ECONNREFUSED,	# Forbindelsen ble fornektet
	EHOSTISDOWN,	# Verten er nede
	}

const error_description: Dictionary[NetworkError, String] = {
	NetworkError.OK: "Ok",
	NetworkError.ENETDOWN: "Network Is Down",
	NetworkError.ENETUNREACH: "Host Is Unreachable",
	NetworkError.ETIMEDOUT: "Connection Timed Out",
	NetworkError.ECONNREFUSED: "Connection Refused",
	NetworkError.EHOSTISDOWN: "Host Is Down",
}
	
var error_type: NetworkError = NetworkError.OK
var description: String


func _init(_error_type: NetworkError) -> void:
	error_type = _error_type
	description = error_description.get(error_type)

func _to_string() -> String:
	return description

func get_type() -> String:
	return "Error"
