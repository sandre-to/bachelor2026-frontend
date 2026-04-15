class_name BaseTask extends Control

@export var task: TaskData = null

@onready var title: Label = %Title
@onready var description: Label = %Description
@onready var puzzle: RichTextLabel = %Puzzle
@onready var enter_flag: LineEdit = %EnterFlag

# --- KNAPPER ---
@onready var confirm_button: Button = %ConfirmButton
@onready var hint_container: HBoxContainer = %HintContainer
@onready var hint_1: Button = %Hint1
@onready var hint_2: Button = %Hint2
@onready var hint_3: Button = %Hint3

func _ready() -> void:
	# Hente data fra backend
	if not task:
		push_error("Missing task resource. Please add one.")
		return
	
	# Koble til knapper slik at det funker i inherited klasser
	confirm_button.pressed.connect(_on_confirm_button_pressed)
	enter_flag.text_submitted.connect(_on_enter_flag_text_submitted)
	
	var buttons = hint_container.get_children()
	for i in range(buttons.size()):
		buttons[i].pressed.connect(_on_hint_pressed.bind(i + 1))
	

func start() -> void:
	await request_task()
	_on_start()
	await parse_finished()
	
	
func _on_start() -> bool:
	return false

# Override disse funksjonene i de ulike oppgavene
func set_task_info() -> void: pass

func _on_confirm_button_pressed() -> void: 
	print("SUBMIT")
	var req_id: int = Backend.send_own({
		"type": "validate-flag",
		"data": {
			"flag": enter_flag.text
		}
	})
	var response: Dictionary = await Backend.await_message(req_id)
	print(response)



func _on_enter_flag_text_submitted(_new_text: String) -> void: 
	_on_confirm_button_pressed()
	
func _on_hint_pressed(_index: int) -> void: pass


func completed_task() -> void:
	var hints := hint_container.get_children()
	for hint in hints:
		hint.disabled = true
	
	description.text = "COMPLETED, GOOD JOB!"
	confirm_button.disabled = true
	task.completed = true
	



func get_task_data() -> void:
	
	pass



func request_task() -> bool:
	var req_id: int = Backend.send_own({
		"type": "task",
		"data": {
			"taskID": task.id
		}
	})
	
	var response: Dictionary = await Backend.await_message(req_id)
	print(response)
	
	if response.get("status") == "error":
		# FEILHÅNDTER #
		print(response["data"])
		return false
	
	var response_data = response.get("data")
	if not response_data.has("metadata"):
		# FEILHÅNDTER #
		return false
		
	if not response_data.has("data"):
		# FEILHÅNDTER #
		return false
		
	task.backend_data = response_data.get("data")
	
	var task_metadata: Dictionary = response_data.get("metadata")
	if task_metadata.has("extraDescription"):
		task.extra_description = task_metadata.get("extraDescription")
#	if task_metadata.has("hintCosts"):
#		task.hint_costs = task_metadata.get("hintCosts")
	
	return true


func parse_finished() -> bool:
	var req_id: int = Backend.send_own({
		"type": "parse-status",
		"status": "success"
	})
	
	var response: Dictionary = await Backend.await_message(req_id)
	return response.get("status") == "success"
