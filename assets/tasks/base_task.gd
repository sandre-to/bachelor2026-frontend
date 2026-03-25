class_name BaseTask extends Control

enum TaskType {
	CRYPTO_TASK,
	STEGANO_TASK,
	WEB_TASK
}

# Legacy
#@export var task: Task = null

@export var type: TaskType
@export var dynamic_data: Dictionary[String, Variant] = {}

func _ready() -> void:
	NetworkManager.connect("message_received", _on_message)




# Initialize_objects():	Funksjonen som initialiserer objektene brukt i oppgaven
func initialize_objects() -> void:
	pass
	



# _handle_task_msg():	Kjører når backenden sender oppgaven
func _handle_task_msg(msg: Dictionary) -> void:
	pass
	
	
	
# _handle_task_init_msg():	Kjører når backenden får ACK fra backenden ang oppgaveinitialiseringen
func _handle_task_init_msg(msg: Dictionary) -> void:
	pass



# _on_message():	Meldingsruteren for baseTask (koblet opp mot NetworkManagers signal)	
func _on_message(msg: Dictionary) -> void:
	var type: String = msg.get("type")

	if type == "task":
		_handle_task_msg(msg)
	elif type == "task-init-status":	# ER FORTSATT PARSE-STATUS I BACKEND !!!
		_handle_task_init_msg(msg)
	return
