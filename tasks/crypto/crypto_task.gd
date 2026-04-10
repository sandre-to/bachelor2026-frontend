class_name CryptoScene extends BaseTask

@export var tasks: Dictionary[int, CryptoData] = {}
@export var current_level: int = 1

func _ready() -> void:
	if task: return # Returner hvis oppgaven allerede er satt. VIKTIG!
	set_task(current_level)
	super._ready()

func set_data_info() -> void:
	title.text = task.name
	description.text = task.description
	puzzle.text = task.cipher_text

func set_task(i: int) -> void:
	if not tasks.has(i) || tasks.get(i) == null:
		push_error("Invalid number! Task does not exist. Check dictionary for available keys")
		return
	
	task = tasks[i]
	set_data_info()

func _on_hint_pressed(index: int) -> void:
	match index:
		1:
			print("Button 1")
		2:
			print("Button 2")
		3:
			print("Button 3")
