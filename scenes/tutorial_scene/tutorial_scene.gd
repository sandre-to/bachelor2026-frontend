# Håndterer tutorial-scenen og tilhørende UI
class_name TutorialScene extends Control

@onready var tutorial_task_manager: TutorialTasks = %TutorialTaskManager
@onready var file_explorer: Control = $FileExplorer
@onready var tool_panel: Panel = %ToolPanel
@onready var main_buttons: HBoxContainer = %HBoxContainer
@onready var tool_selector: TutorialToolSelector = %TutorialToolSelector

@onready var animation: AnimationPlayer = $Animation
@onready var color_rect: ColorRect = $Animation/ColorRect
#initialiserer tutorial og skjuler UI-elementer
func _ready() -> void:
	animation.play("fade_in")
	file_explorer.hide()
	tool_selector.hide()
	
	animation.play("panel_popup")
	disable_main_buttons()
	#tutorial_task_manager.hide()
#viser/skjuler filutforsker
func _on_files_button_pressed() -> void:
	file_explorer.visible = not file_explorer.visible
	
#viser/skjuler verktøypanel
func _on_tools_button_pressed() -> void:
	tool_selector.visible = not tool_selector.visible
	
#aktiverer/deaktiverer hovedknapper
func disable_main_buttons() -> void:
	for button in main_buttons.get_children():
		button.disabled = not button.disabled

func _on_play_button_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/desktop/desktop_environment.tscn")

#lukker åpne paneler og verktøy
func _on_clear_button_pressed() -> void:
	file_explorer.hide()
	tool_selector.hide()
	for tool in tool_panel.get_children():
		tool.hide()
#hopper over tutorialen
func _on_skip_tutorial_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/desktop/desktop_environment.tscn")
