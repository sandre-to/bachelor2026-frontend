class_name BaseTask extends Control

@export var task: TaskData

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
	

# start():	Metoden som kjører når oppgaven startes
func start() -> void:
	# Spør backenden om å starte
	var request_success: bool = await request_task()
	if not request_success:
		return
	
	set_task_info()
	
	# Initialiser den spesifike oppgaven
	var init_success: bool = _on_start()
	if not init_success:
		return
	
	# Fortell backenden at initen fungerte
	var backend_synced: bool = await parse_finished()
	if not backend_synced:
		return
	


# _on_start():	Metoden hvor alle oppgaver initialiserer seg selv;
#				alle oppgaver implementerer metoden selv.
#				Returnerer en bool for å indikere om initialiseringen fungerte.
func _on_start() -> bool:
	return false



func set_task_info() -> void: 
	title.text = task.name
	description.text = task.description

func _on_confirm_button_pressed() -> void: 
	var flag_correct: bool = await verify_flag()
	if flag_correct:
		completed_task()

	print("SUBMIT")
	
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



# request_task():	Spør backenden om å starte oppgaven
#					Kaller på API-et: respondToTask
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
	if task_metadata.has("hintCosts"):
		task_metadata.get("hintCosts")
	
	return true



# parse_finished():	Forteller backenden at oppgaven er ferdig initialisert
#					Kaller på API-et: respondToParseStatus
func parse_finished() -> bool:
	var req_id: int = Backend.send_own({
		"type": "parse-status",
		"status": "success"
	})
	
	var response: Dictionary = await Backend.await_message(req_id)
	return response.get("status") == "success"



# verify_flag():	Verifiserer et flagg ved å spørre backenden
#					Kaller på API-et: respondToValidateFlag
func verify_flag() -> bool:
	var req_id: int = Backend.send_own({
		"type": "validate-flag",
		"data": {
			"flag": enter_flag.text
		}
	})
	
	var response: Dictionary = await Backend.await_message(req_id)

	if response.get("status") != "success":
		# Noe har gått MEGA DEGA galt og er 
		# grunnet spilleren mest sannsynlig (emoji i flagget els)
		print(response)
		return false

	if response.get("data").get("result") == "correct":
		return true
	
	return false
