extends Node

# NetworkManager:
# Dette er objektet som brukes for å kommunisere med backenden gjennom websocket.

# Bruksanvisning:
# - SENDING AV MELDINGER:
#	1. 	Kall på NetworkManager.send(type, data)
#		eller NetworkManager.send_with_status(type, status, data) 
#		Forskjellen mellom disse er at "send()" sender en melding
#		uten et statusfelt og "send_with_status()" lar deg spesifisere
#		en status dersom det er nødvendig.
#	2. 	Type skal være en gyldig typeID nevnt i matchcasen 
#	   	metoden: handleMessage(), i filen GameHandler.java i backenden.
#	3. 	Data skal være en dictionary (JSON), ez as. Hvis du lurer på
#		dataformatet på det API-et, se javadocs for den metoden API-et
#		kommer til å kalle på.

#
# - MOTTAKELSE AV MELDINGER:
#	1.	Knytt en funksjon til signalet "message_received" med parameteret "msg".
#	2.	I funksjonen, gjør sjekket og return hvis false (ikke ment for deg):
#			if msg.get("type") == "typen du forventer"
#	3.	Sjekk feltet "status" for å sjekke om en feil oppsto; alle API-er kan 
#		returnere en feilmelding.
#	4.	Hent innholdet fra feltet "data", håndter som JSON.

# TODO:
# - Flere punkter trenger å feilhåndteres.
# - Signal for nettverksfeil?


# Signal som sendes når en ny melding kommer (bare broadcastmeldinger)
signal message_received(message: Dictionary)

const BACKEND_URL: String = "ws://localhost:8080/game"
const MAX_CONNECTION_ATTEMPTS: int 			= 5		# Antall forsøk på tilkobling
const CONNECTION_INTERVAL_SECONDS: float 	= 1.5	# Antall sekunder mellom hver serverpoll

var _socket = WebSocketPeer.new()
var _connected: bool = false

# Knyttet til gjennoppretting av forbindelsen
var _is_reconnecting: bool = false
var _current_reattempts: int = 0

# Forespørsler som er på vei
var pending_requests: Dictionary = {}


@warning_ignore("unused_parameter")
func _process(delta: float) -> void:
	if not _connected:
		return
	
	_socket.poll()
	match _socket.get_ready_state():
		WebSocketPeer.State.STATE_OPEN:
			_read_messages()
		WebSocketPeer.State.STATE_CONNECTING:
			print("wtf why")
		WebSocketPeer.State.STATE_CLOSING:
			return	# La forbindelsen lukke ordentlig
		WebSocketPeer.State.STATE_CLOSED:
			_announce_disconnection()



# Connect_to_backend():	Kobler til backenden
func connect_to_backend() -> void:
	var error: Error = _socket.connect_to_url(BACKEND_URL)
	if error != OK:
		_reconnect()
	
	

# _reconnect():	Selvbeskrivene.
func _reconnect() -> void:
	if _is_reconnecting:
		return
	
	_is_reconnecting = true
	for attempt in range(MAX_CONNECTION_ATTEMPTS):
		await get_tree().create_timer(CONNECTION_INTERVAL_SECONDS).timeout
	
		var error: Error = _socket.connect_to_url(BACKEND_URL)
		if error == OK:
			_is_reconnecting = false
			return
	
	_is_reconnecting = false
			

# Await_message():	Venter på svaret backenden gir
func await_message(request_id: float) -> Dictionary:
	while pending_requests.get(request_id) == null:
		await get_tree().process_frame
		
	var result: Dictionary = pending_requests.get(request_id)
	pending_requests.erase(request_id)
	
	return result



# Send():	Sender en melding til backenden
func send(type: String, data: Dictionary) -> int:
	var msg: Dictionary = {
		"type": type,
		"data": data
	}
	return _send_text(msg)



# Send_with_status():	Sender en melding til backenden med status
func send_with_status(type: String, status: String, data: Dictionary) -> int:
	var msg: Dictionary = {
		"type": type,
		"status": status,
		"data": data
	}
	return _send_text(msg)



# Send_own():	Sender en helt egendefinert melding til backenden
#				NB: Alle meldinger skal ha "type": "..."
func send_own(msg: Dictionary) -> int:
	return _send_text(msg)



# Purge_request_promise():	Fjerner request_id fra pending_requests
#							Dette brukes etter API-kall når man ikke forventer et svar; en slags free();
func purge_request_promise(request_id: int) -> void:
	pending_requests.erase(request_id)



# _send_text():	Sender en konstruert melding til backenden
func _send_text(msg: Dictionary) -> int:
	_socket.poll()
	while _socket.get_ready_state() == WebSocketPeer.State.STATE_CONNECTING:
		_socket.poll()
	
	if _socket.get_ready_state() != WebSocketPeer.State.STATE_OPEN:
		_announce_disconnection()
		return -1

	# Request-ID som knytter en melding med et svar
	var request_id: int = randi() % 1000000
	msg.set("requestID", request_id)
	pending_requests[request_id] = null

	_socket.send_text(JSON.stringify(msg))
	return request_id



# _read_messages():	Henter meldingene ut i fra meldingskøen
func _read_messages() -> void:
	while _socket.get_available_packet_count() > 0:
		var msg: Dictionary = JSON.parse_string(
			_socket.get_packet().get_string_from_utf8()
		)
		_handle_message(msg)



# _handle_message():	Putter meldingen i pending_requests, eller broadcaster den
func _handle_message(msg: Dictionary) -> void:
	if msg.has("requestID") and int(msg["requestID"]) in pending_requests:
		pending_requests.set(msg.get("requestID"), msg)
	else:
		emit_signal("message_received", msg)	# Events



# _announce_disconnection():	Skriver ut at en nettverksfeil har tatt plass
func _announce_disconnection() -> void:
	_connected = false
	print("Mistet forbindelsen ;(")
	print("Kode:  ", _socket.get_close_code())
	print("Grunn: ", _socket.get_close_reason())
