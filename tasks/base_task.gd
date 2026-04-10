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

# Override disse funksjonene i de ulike oppgavene
func set_task_info() -> void: pass

func _on_confirm_button_pressed() -> void: 
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
