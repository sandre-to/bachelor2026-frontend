extends Node

# NetworkManager:
# Dette er objektet som brukes for å kommunisere med backenden gjennom websocket.

# Notater:
# - Forbindelsen baseres på websocket, ikke websocket secure. Dette må endres.

# Adresser & endepunkter
const SOCKET_URL: String = "ws://localhost:8080"
const GAME_ENDPOINT: String = "/game"

const TIMEOUT_SECONDS: int 			= 2	# Antall sekunder klienten venter
const CONNECTION_ATTEMPTS: int 		= 5	# Antall forsøk på tilkobling
const POLL_INTERVAL_SECONDS: int 	= 1	# Antall sekunder mellom hver serverpoll

var _socket = WebSocketPeer.new()
var connected: bool = false


@warning_ignore("unused_parameter")
func _process(delta: float) -> void:
	if not connected:
		return
	
	_socket.poll()
	var state: WebSocketPeer.State = _socket.get_ready_state()
	if state == WebSocketPeer.State.STATE_OPEN:
		read_messages()
	elif state == WebSocketPeer.State.STATE_CLOSED:
		_handle_connection_error()
	elif state == WebSocketPeer.State.STATE_CLOSING:
		return
		
	
func read_messages() -> void:
	while _socket.get_available_packet_count() > 0:
		print(_socket.get_packet().get_string_from_utf8())
	
	
func send_messages() -> void:
	pass


# Connect_to_game():	Kobler forbindelsen til /game -endepunktet
func connect_to_game() -> void:
	var error = _socket.connect_to_url(SOCKET_URL + GAME_ENDPOINT)
	if error != OK:
		_handle_connection_error()
		return

	# Vent på på at forbindelsen starter opp
	connected = await _wait_for_connection()

		

# _handle_connection_error():	Håndterer forbindelsesfeil
func _handle_connection_error() -> void:
	pass


# _wait_for_connection():	Venter på at forbindelsen oppstår
func _wait_for_connection() -> bool:
	
	var socket_state: WebSocketPeer.State
	for i in range(CONNECTION_ATTEMPTS):

		# Vent TIMEOUT_SECONDS sekunder og sjekk _sockettilstanden
		await get_tree().create_timer(TIMEOUT_SECONDS).timeout
		socket_state = _socket.get_ready_state()

		if socket_state == WebSocketPeer.State.STATE_CLOSED:
			break
		elif socket_state == WebSocketPeer.State.STATE_OPEN:
			return true
	
	return false
	
