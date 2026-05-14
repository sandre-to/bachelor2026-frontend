class_name BaseTask extends Control

@export var tasks: Dictionary[String, Array] = {
	"tutorial": [
		"res://tasks/crypto/tutorial_crypto.tres",
		"res://tasks/steg/steg_tutorial.tres",
		"res://tasks/web_exploit/web_tutorial.tres"
	],
	"bulk_1": [
		"res://tasks/crypto/crypto1.tres",
		"res://tasks/steg/steg1.2.tres",
		"res://tasks/web_exploit/web1.3.tres",
		"res://tasks/crypto/crypto2.tres"
	]
}

@export var task: TaskData

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
	
	error_panel.hide()
	hint_box.hide()
	hint_2.disabled = true
	hint_3.disabled = true
	var buttons = hint_container.get_children()
	for i in range(buttons.size()):
		buttons[i].pressed.connect(_on_hint_pressed.bind(i + 1))
		
func set_data_info(key: String, index: int) -> void:
	if key in tasks.keys():
		task = load(tasks[key][index])
		title.text = task.name
		description.text = task.description
		puzzle.text = task.puzzle_text

		match task.type:
			TaskData.TaskType.CRYPTO:
				pass
			TaskData.TaskType.WEB:
				SignalBus.send_web_data.emit(task)
			TaskData.TaskType.STEGANO:
				set_steg_info()
	else:
		push_error("Key does not exist in tasks: ", key)

func _on_confirm_button_pressed() -> void:
	completed_task()
	
func _on_enter_flag_text_submitted(_new_text: String) -> void: 
	completed_task()
	
func _on_hint_pressed(index: int) -> void: 
	if not task.hints: return
	
	match index:
		1: 
			hint_box.set_hint_text(task.hints[0], index)
			hint_2.disabled = false
		2:
			hint_box.set_hint_text(task.hints[1], index)
			hint_3.disabled = false
		3:
			hint_box.set_hint_text(task.flag, index)
			
func completed_task() -> void:
	if not task or enter_flag.text.strip_edges() != task.flag: 
		error_panel.show()
		return
	
	SignalBus.task_completed.emit(
		TaskData.TaskType.keys()[task.type].to_lower())
	print("TASK COMPLETED")

func _on_copy_text_button_pressed() -> void:
	DisplayServer.clipboard_set(puzzle.text)

func hide_all_hints() -> void:
	hint_container.hide()

func set_steg_info() -> void:
	var file := FileSystem.get_file_entity(FileSystem.PICTURE_DIR + "/" + task.image_name)
	file.metadata["type"] = "image"
	file.metadata["Author"] = task.author
	file.metadata["Software"] = task.software
	file.metadata["Comment"] = task.comment
	file.metadata[task.flag_metadata_key] = task.flag
