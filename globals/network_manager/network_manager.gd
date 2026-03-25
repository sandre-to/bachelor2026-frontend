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


# Signal som sendes når en ny melding kommer
signal message_received(message: Dictionary)

const BACKEND_URL: String = "ws://localhost:8080/game"
const CONNECTION_ATTEMPTS: int 				= 5		# Antall forsøk på tilkobling
const CONNECTION_INTERVAL_SECONDS: float 	= 1.5	# Antall sekunder mellom hver serverpoll

var _socket = WebSocketPeer.new()
var _connected: bool = false

var _pending_requests: Dictionary = {}


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
func connect_to_backend() -> bool:
	var error: Error = _socket.connect_to_url(BACKEND_URL)
	if error != OK:
		return false
		
	# Vent på at forbindelsen kommer gjennom
	for attempt in range(CONNECTION_ATTEMPTS):
		_socket.poll()
		print("Prøver å koble til...")
		if _socket.get_ready_state() != WebSocketPeer.State.STATE_OPEN:
			await get_tree().create_timer(CONNECTION_INTERVAL_SECONDS).timeout
			continue
		else:
			print("Koblet til!! :)))")
			_connected = true
			return true
		
	print("Kunne ikke koble til :(")	
	return false



# Send():	Sender en melding til backenden
func send(type: String, data: Dictionary) -> int:
	var msg: Dictionary = {
		"type": type,
		"data": data
	}
	return _send_text(msg)



# Send_own():	Sender en helt egendefinert melding til backenden
#				NB: Alle meldinger skal ha "type": "..."
func send_own(msg: Dictionary) -> int:
	return _send_text(msg)



func await_message(request_id: int) -> Dictionary:
	while _pending_requests.get(request_id) == null:
		await get_tree().process_frame
	
	var result = _pending_requests.get(request_id)
	_pending_requests.erase(request_id)
	return result



# _send_text():	Sender en konstruert melding til backenden
func _send_text(msg: Dictionary) -> int:
	_socket.poll()
	while _socket.get_ready_state() == WebSocketPeer.State.STATE_CONNECTING:
		_socket.poll()
	
	if _socket.get_ready_state() != WebSocketPeer.State.STATE_OPEN:
		_announce_disconnection()
		return false

	var request_id: int = randi() % 10000000
	msg.set("requestID", request_id)
	_pending_requests[request_id] = null

	_socket.send_text(JSON.stringify(msg))
	return request_id



# _read_messages():	Henter meldingene ut i fra meldingskøen
func _read_messages() -> void:
	while _socket.get_available_packet_count() > 0:
		var msg: Dictionary = JSON.parse_string(
			_socket.get_packet().get_string_from_utf8()
		)
		_handle_msg(msg)
		



func _handle_msg(msg: Dictionary) -> void:
	if msg.has("requestID") and int(msg.get("requestID")) in _pending_requests:
		_pending_requests.set(int(msg.get("requestID")), msg)
	else:
		emit_signal("message_received", msg)		# Feilhåndter :,(


# _announce_disconnection():	Skriver ut at en nettverksfeil har tatt plass
func _announce_disconnection() -> void:
	_connected = false
	print("Mistet forbindelsen ;(")
	print("Kode:  ", _socket.get_close_code())
	print("Grunn: ", _socket.get_close_reason())
