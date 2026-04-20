extends Node

# NetworkManager:
# Dette er objektet som brukes for å kommunisere med backenden gjennom websocket.


# TODO:
# - Flere punkter trenger å feilhåndteres.
# - Hva som skjer når forbindelsen brytes mid-game.
#	Ting som må gjøres for dette:
#	1.	Klassifiseringer av hvilke meldinger som er viktigst
#	2.	Lage kø-system
#		2.1.	Unngå dupes
#		2.2.	Sende i rekkefølge

# Signaler
signal broadcast_recieved(message: Dictionary)	# Når en broadcastmelding kommer (en melding for alle)
signal disconnected(error_info: Dictionary)		# Når klienten mister forbindelsen med backenden

const _BACKEND_URL: String = "ws://localhost:8080/game"
const _CONNECTION_TIMEOUT_MS: int 		= 10 * 1000		# Antall millisekunder etter tilkoblingen avbrytes
const _SAFE_CLOSING_TIMEOUT_MS: int 	= 1  * 1000		# Antall millisekunder som ventes for at forbindelsen lukkes ordentlig
const _AWAIT_MESSAGE_TIMEOUT_MS: int 	= 5  * 1000 	# Antall millisekunder før timeout når man venter på en melding 

const NO_RESPONSE_MSG: Dictionary 	= {"no": "response"} 	# Standartmeldingen som gis hvis mottakelsen av en melding feilet
const COULD_NOT_SEND: int 			= -1					# RequestID-en som gis dersom man ikke kunne sende

var _socket = WebSocketPeer.new()
var _connected: bool 		= false
var _is_connecting: bool	= false
var _was_connected: bool 	= false

# Forespørsler som er på vei; posthuset
var _pending_requests: Dictionary = {}

# En meldingskø for når forbindelsen er nede
var _message_set_queue: Array[Dictionary] = []



@warning_ignore("unused_parameter")
func _process(delta: float) -> void:
	if not _connected and _was_connected:
		connect_to_backend()
		return
	elif not _connected:
		return
	
	_socket.poll()
	if _socket.get_ready_state() == WebSocketPeer.State.STATE_OPEN:
		_read_messages()
	else:
		await _let_close()
		_announce_network_error("Forbindelsen lukket (_process)")



# Connect_to_backend():	Kobler til backenden
func connect_to_backend() -> void:
	if _connected or _is_connecting:
		return
	
	_is_connecting = true
	
	var error: Error = _socket.connect_to_url(_BACKEND_URL)
	if error != OK:
		_announce_network_error("Første tilkobling mislykket (connect_to_backend)")
		_is_connecting = false
		return
	
	var connection_open: bool = await _let_open()
	if not connection_open:
		await _let_close()
		_announce_network_error("Tilkobling mislykket (connect_to_backend)")
		_is_connecting = false
		return
	
	_connected = true
	if _was_connected:
		_flush_message_queue()
	
	_was_connected = true
	_is_connecting = false
	print("Tilkoblet ;)")



# Send():	Sender en konstruert melding til backenden
func send(msg: Dictionary) -> int:
	if not _connected:
		_append_to_message_queue(msg)
		_announce_network_error("Tilkobling mislykket (_send_text)")
		return COULD_NOT_SEND

	# Request-ID som knytter en melding med et svar
	var request_id: int = randi() % 1000000
	msg.set("requestID", request_id)
	_pending_requests[request_id] = null

	var error: Error = _socket.send_text(JSON.stringify(msg))
	if error != OK:
		_let_close()
		_announce_network_error("Kunne ikke sende melding (_send_text)")
		return COULD_NOT_SEND
	
	return request_id



# Await_message():	Venter på svaret backenden gir
func recieve(request_id: float) -> Dictionary:
	var start_time: int = Time.get_ticks_msec()
	while _pending_requests.get(request_id) == null:
		if _should_timeout(start_time, _AWAIT_MESSAGE_TIMEOUT_MS):
			await _let_close()
			_announce_network_error("Ventet for lenge (await_message)")
			return {}
		
		await get_tree().process_frame
	
	var result: Dictionary = _pending_requests.get(request_id)
	_pending_requests.erase(request_id)
	
	return result



# Purge_request_promise():	Fjerner request_id fra _pending_requests
#							Dette brukes etter API-kall hvor man ikke forventer et svar; en slags free();
func purge_request_promise(request_id: int) -> void:
	if not _connected:
		return
	_pending_requests.erase(request_id)



# is_connected_to_backend():	Selvforklarende
func is_connected_to_backend() -> bool:
	return _connected



# _read_messages():	Henter meldingene ut i fra meldingskøen
func _read_messages() -> void:
	while _socket.get_available_packet_count() > 0:
		var msg: Dictionary = JSON.parse_string(
			_socket.get_packet().get_string_from_utf8()
		)
		_handle_message(msg)



# _handle_message():	Putter meldingen i _pending_requests, eller broadcaster den
func _handle_message(msg: Dictionary) -> void:
	if msg.has("requestID") and int(msg["requestID"]) in _pending_requests:
		_pending_requests.set(msg.get("requestID"), msg)
	else:
		emit_signal("broadcast_recieved", msg)	# Events



# _append_to_message_queue():	Legger en melding til i meldingskøen
func _append_to_message_queue(msg: Dictionary) -> void:
	for i in range(len(_message_set_queue)):
		if _message_set_queue[i].get("type") == msg.get("type"):
			_message_set_queue[i] = msg



# _flush_message_queue():	Tømmer meldingskøen
func _flush_message_queue() -> void:
	for msg in _message_set_queue:
		send(msg)



# _announce_network_error():	Skriver ut at en nettverksfeil har tatt plass
func _announce_network_error(process_desc: String) -> void:
	_connected = false
	var error_info: Dictionary = {
		"socket_code": _socket.get_close_code(),
		"socket_desc": _socket.get_close_reason(),
		"process_desc": process_desc
	}
	print("Mistet forbindelsen ;(")
	print("WS-kode: " + str(_socket.get_close_code()))
	if _socket.get_close_code() != -1: print(_socket.get_close_reason())
	print(process_desc)
	emit_signal("disconnected", error_info)



# _let_close():	En hjelpefunksjon for å la forbindelsen lukke ordentlig
#				Funksjonen brukes som et fallnett når forbindelsen lukkes
func _let_close() -> void:
	_socket.poll()
	
	var start_time: int = Time.get_ticks_msec()
	while _socket.get_ready_state() == WebSocketPeer.State.STATE_CLOSING:
		if _should_timeout(start_time, _SAFE_CLOSING_TIMEOUT_MS):	# Drit i sikker lukking amirite
			break
			
		await get_tree().process_frame
		_socket.poll()



# _let_open():	Lar forbindelsen åpne ordentlig
#				Kjører fram til tilstanden endres fra CONNECTING
func _let_open() -> bool:
	_socket.poll()
	
	var start_time: int = Time.get_ticks_msec()
	while _socket.get_ready_state() == WebSocketPeer.State.STATE_CONNECTING:
		
		if _should_timeout(start_time, _CONNECTION_TIMEOUT_MS):	# Tilstanden forblir CONNECTING for lenge
			print("CONNECTING for lenge")
			return false
			
		await get_tree().process_frame
		_socket.poll()
	
	return _socket.get_ready_state() == WebSocketPeer.State.STATE_OPEN



# _should_timeout():	Regner ut om det har gått "time_to_elapse" tid fra "start_time"
func _should_timeout(start_time: int, time_to_elapse: int) -> bool:
	return Time.get_ticks_msec() - start_time >= time_to_elapse
