extends Resource
class_name ServerCommunicator

# ServerCommunicator:
# Dette er objektet som brukes for å kommunisere med backenden gjennom websocket.

# Notater:
# - Forbindelsen baseres på websocket, ikke websocket secure. Dette må endres.

const socket_url: String = "ws://localhost:8080"
const game_endpoint: String = "/game"

var server = WebSocketPeer.new()


func _init() -> void:
	pass	


# Connect_to_game():	Kobler forbindelsen til /game -endepunktet
func connect_to_game() -> void:
	var error = server.connect_to_url(socket_url + game_endpoint)




# _handle_connection_error():	Håndterer forbindelsesfeil
func _handle_connection_error() -> void:
	pass
