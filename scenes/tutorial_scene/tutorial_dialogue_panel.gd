class_name TutorialDialoguePanel extends Panel

@export var dialog_move_speed: float = 0.25

@onready var tutorial_text: RichTextLabel = %TutorialText
@onready var next_button: Button = $NextButton
@onready var clear_button: Button = %ClearButton
@onready var files_button: Button = %FilesButton
@onready var tools_button: Button = %ToolsButton
@onready var animation: AnimationPlayer = %Animation
@onready var file_explorer := %FileExplorer
@onready var tutorial_task_manager: TutorialTasks = %TutorialTaskManager
@onready var play_button: Button = %PlayButton
@onready var tutorial_tool_selector: TutorialToolSelector = $"../TutorialToolSelector"
@onready var steg_tool_button: = $"../TutorialToolSelector/Panel/HBoxContainer/StegToolButton"
@onready var task_button: Button = $"../TutorialTaskManager/TaskButton"
@onready var task_1: Button = %Task1
@onready var task_2: Button = %Task2
@onready var task_3: Button = %Task3

var dialogue_data := {}
var dialogue := []
var current_index := 0
var current_dialogue_key := ""

var is_typing := false
var active_tween: Tween

# Viktig sjekk for å ikke trigge dialog etter første gang
var task_pressed := false
var tool_pressed := false
var files_pressed := false
var clear_pressed := false

func _ready() -> void:
	steg_tool_button.hide()
	SignalBus.task_completed.connect(_on_task_completed)
	
	await get_tree().create_timer(0.8).timeout
	load_dialogue()
	start_dialogue("intro")
	
func start_dialogue(key: String) -> void:
	if key in dialogue_data:
		current_dialogue_key = key
		dialogue = dialogue_data[key]
		current_index = 0
		if key == "files":
			animation.play("files_button")
			files_button.disabled = false
		if key == "tools":
			animation.play("tools_button")
			tools_button.disabled = false
		if key == "clear_button":
			animation.play("clear_button")
			clear_button.disabled = false
		if key == "steg_task_info":
			task_1.hide()
			tutorial_task_manager.show()
			task_button.disabled = false
			task_2.show()
			
		show_next_line()
	else:
		push_error("Dialogue key not found: " + key)

func load_dialogue() -> void:
	var file := FileAccess.open(
		"res://scenes/tutorial_scene/tutorial_messages.json", 
		FileAccess.READ)
		
	dialogue_data = JSON.parse_string(file.get_as_text())

func show_next_line():
	if current_index < dialogue.size():
		tutorial_text.text = dialogue[current_index]
		current_index += 1
		type_text()
	else:
		end_of_dialogue()

func _on_next_button_pressed() -> void:
	if current_index >= dialogue.size():
		end_of_dialogue()
	else:
		show_next_line()

func type_text() -> void:
	tutorial_text.visible_characters = 0
	
	for i in tutorial_text.text.length():
		tutorial_text.visible_characters = i + 1
		await get_tree().create_timer(0.028, false).timeout

func end_of_dialogue() -> void:
	if current_dialogue_key == "intro":
		start_dialogue("files")
	elif current_dialogue_key == "files":
		pass # Denne venter på at spilleren trykker på "files" før dialogen går videre
	elif current_dialogue_key == "files_folder":
		animation.stop()
		file_explorer.hide()
		active_tween = create_tween()
		active_tween.set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_SINE)
		active_tween.tween_property(self, "position", position - Vector2(500, 0), dialog_move_speed)
		
		await get_tree().create_timer(0.15).timeout
		start_dialogue("tools")
	elif current_dialogue_key == "tools":
		pass
	elif current_dialogue_key == "tools_info":
		animation.stop()
		active_tween = create_tween()
		active_tween.set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_SINE)
		active_tween.tween_property(self, "position", position + Vector2(0, 200), dialog_move_speed)
		start_dialogue("clear_button")
	elif current_dialogue_key == "tasks":
		tutorial_task_manager.show()
		animation.play("tasks_animation")
		start_dialogue("next_tasks")
	elif current_dialogue_key == "last_section":
		start_dialogue("crypto_task")
		active_tween = create_tween()
		active_tween.set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_SINE)
		active_tween.tween_property(self, "position", position + Vector2(-70, -200), dialog_move_speed)
	
	
	elif current_dialogue_key == "steg_tool_info":
		FileSystem.add_image_file("saintSofelin", "res://scenes/file_explorer/pictures/devSofie.png") 
		start_dialogue("steg_task_info")
	elif current_dialogue_key == "steg_task_info":
		start_dialogue("steg_task")
		
	elif current_dialogue_key == "steg_done":
		start_dialogue("web_tool_info")

func _on_files_button_pressed() -> void:
	if files_pressed: return
	
	files_pressed = true
	files_button.disabled = true
	
	start_dialogue("files_folder")
	active_tween = create_tween()
	active_tween.set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_SINE)
	active_tween.tween_property(self, "position", position + Vector2(500, 0), dialog_move_speed)

func _on_tools_button_pressed() -> void:
	if tool_pressed: return
	
	tool_pressed = true
	tools_button.disabled = true
	
	start_dialogue("tools_info")
	active_tween = create_tween()
	active_tween.set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_SINE)
	active_tween.tween_property(self, "position", position + Vector2(0, -200), dialog_move_speed)

func _on_clear_button_pressed() -> void:
	if clear_pressed: return
	
	clear_pressed = true
	clear_button.disabled = true
	animation.stop()
	
	start_dialogue("tasks")
	
func _on_task_1_pressed() -> void:
	if task_pressed: return
	
	task_pressed = true
	#animation.stop()
	show()
	start_dialogue("last_section")
	clear_button.disabled = false
	tools_button.disabled = false
	files_button.disabled = false
func _on_task_completed(task_type: String) -> void:
	tutorial_task_manager.clear_current_task()
	tutorial_task_manager.hide()

	match task_type:
		"crypto":
			steg_tool_button.show()
			tools_button.disabled = false
			start_dialogue("steg_tool_info")
		"steg":
			start_dialogue("steg_done")
		"web":
			start_dialogue("finished")
			
			
			
#REMEMBER TO REMOVE FUNC BELOW
func _on_crypto_task_completed() -> void: #endre til etter stegogweb
	tutorial_task_manager.clean_current_task()
	tutorial_task_manager.hide()
	start_dialogue("crypto_done")
	
	if current_dialogue_key == "crypto_task":
		start_dialogue("crypto_done")
	elif current_dialogue_key == "steg_task":
		start_dialogue("web_tool_info")
	elif current_dialogue_key == "web_task":
		start_dialogue("finished")
	#play_button.show()
	#next_button.hide()
	#clear_button.disabled = true
	#tools_button.disabled = true
	#files_button.disabled = true
	#tutorial_tool_selector.hide_selected_tools()
	#clear_button.pressed.emit()
	#active_tween = create_tween()
	#active_tween.set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_SINE)
	#active_tween.tween_property(self, "position", position + Vector2(70, 200), dialog_move_speed)

func steg_task() -> void:
	start_dialogue("steg_task")
	pass

func web_task() -> void:
	start_dialogue("web_task")
	pass
