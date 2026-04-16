class_name Desktop extends Control

const WINDOW: PackedScene = preload("res://scenes/window/custom_window.tscn")

@onready var animation: AnimationPlayer = $Animation
@onready var color_rect: ColorRect = $Animation/ColorRect

@onready var file_explorer: Control = $FileExplorer
@onready var tool_selector: Control = %ToolSelector
@onready var tool_panel: Panel = %ToolPanel
@onready var task_manager: Control = %TaskManager
@onready var notepad: NotepadApp = %NotepadApp

var root: Node = null

func _ready() -> void:
	color_rect.show()
	animation.play("fade_in")
	root = get_tree().root
	
	tool_selector.hide()
	Backend.connect_to_backend()	# MIDLERTIDIG

func _on_files_button_pressed() -> void:
	file_explorer.visible = not file_explorer.visible

func _on_home_button_pressed() -> void:
	file_explorer.hide()
	tool_selector.hide()
	for tool in tool_panel.get_children():
		tool.hide()

func _on_tools_button_pressed() -> void:
	tool_selector.visible = not tool_selector.visible
	
func _on_notepad_button_pressed() -> void:
	notepad.visible = not notepad.visible
	
	if notepad.visible:
		notepad.open_personal_notes()
