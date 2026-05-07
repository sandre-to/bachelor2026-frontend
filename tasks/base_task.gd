class_name BaseTask extends Control

@export var tasks: Dictionary = {
	"tutorial": [
		"res://tasks/crypto/tutorial_crypto.tres",
		"res://tasks/steg/steg_tutorial.tres",
		"res://tasks/web_exploit/web_tutorial.tres"
	],
	"bulk_1": [
		"res://tasks/crypto/level1-1.tres",
		"res://tasks/steg/steg1.2.tres",
		"res://tasks/web_exploit/web1.3.tres",
		"res://tasks/crypto/level1-4.tres"
	]
}

@export var task: TaskData
@export var task_type: String = ""

@onready var title: Label = %Title
@onready var description: Label = %Description
@onready var puzzle: RichTextLabel = %Puzzle
@onready var enter_flag: LineEdit = %EnterFlag
@onready var hint_box: HintBox = %HintBox
@onready var error_panel: ErrorPanel = %ErrorPanel

# --- KNAPPER ---
@onready var confirm_button: Button = %ConfirmButton
@onready var hint_container: HBoxContainer = %HintContainer
@onready var hint_1: Button = %Hint1
@onready var hint_2: Button = %Hint2
@onready var hint_3: Button = %Hint3

func _ready() -> void:
	# Koble til knapper slik at det funker i arvede klasser
	confirm_button.pressed.connect(_on_confirm_button_pressed)
	enter_flag.text_submitted.connect(_on_enter_flag_text_submitted)
	
	hint_2.disabled = true
	hint_3.disabled = true
	var buttons = hint_container.get_children()
	for i in range(buttons.size()):
		buttons[i].pressed.connect(_on_hint_pressed.bind(i + 1))
		
	set_data_info("bulk_1", 1)

func set_task_info() -> void: 
	title.text = task.name
	description.text = task.description
	puzzle.text = task.extra_description

func set_data_info(key: String, index: int) -> void:
	if key in tasks.keys():
		task = load(tasks[key][index])
		title.text = task.name
		description.text = task.description
		if task.type == TaskData.TaskType.CRYPTO:
			puzzle.text = task.cipher_text
	else:
		push_error("Key does not exist in tasks: ", key)

func _on_confirm_button_pressed() -> void:
	completed_task()
	
func _on_enter_flag_text_submitted(_new_text: String) -> void: 
	completed_task()
	
func _on_hint_pressed(index: int) -> void: 
	match index:
		pass

func completed_task() -> void:
	if not task or enter_flag.text != task.flag: 
		error_panel.show()
		return
		
	SignalBus.task_completed.emit()

func _on_copy_text_button_pressed() -> void:
	DisplayServer.clipboard_set(puzzle.text)
