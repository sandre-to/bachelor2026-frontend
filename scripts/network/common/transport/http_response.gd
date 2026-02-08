extends Resource
class_name HttpResponse

# HttpResponse:
# Et objekt som representerer en HTTP-response

# Responskoder
enum ResponseCode {
	# Gode fine elskelige responser
	OK = 200,	# Vanlig respons ass

	# Klientfeilmeldinger (Spilleren gjorde noe galt)
	BAD_REQUEST 		= 400,	# Hvis man sender egne meldinger feil
	UNAUTHORIZED 		= 401,	# Ikke lov (typisk respons)
	FORBIDDEN			= 403,	# Ditto ^
	NOT_FOUND			= 404,  # Muligens app-blokkeringsrespons
	METHOD_NOT_ALLOWED  = 405,  # Samme som BAD_REQUEST
	REQUEST_TIMEOUT		= 408,  # Muligens brannmurfeilmelding
	TOO_MANY_REQUESTS	= 429,	# Bruteforceforsøks feil
	
	# Serverfeilmeldinger (Spilleren gjorde noe bra)
	INTERNAL_SERVER_ERROR 			= 500,	# Typisk respons
	LOOP_DETECTED					= 508,	# Kanskje brukt?
	NETWORK_AUTHENTICATION_REQUIRED = 511	# Anner ikke :)
}

var response_code: ResponseCode = ResponseCode.OK
var content: String


func _init(_response_code: ResponseCode, _content: String) -> void:
	response_code = _response_code
	content = _content
