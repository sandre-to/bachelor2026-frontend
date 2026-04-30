class_name Desktop extends Control

@onready var animation: AnimationPlayer = $Animation
@onready var color_rect: ColorRect = $Animation/ColorRect

@onready var file_explorer: Control = $FileExplorer
@onready var tool_panel: Panel = %ToolPanel
@onready var task_manager: Control = %TaskManager
@onready var task_display: Panel = %Panel
@onready var tool_selector: ToolSelector = %ToolSelector
@onready var notepad_app: NotepadApp = %NotepadApp
@onready var browser: Browser = %Browser

func _ready() -> void:
	color_rect.show()
	animation.play("fade_in")
	await animation.animation_finished
	animation.queue_free()
	
	tool_selector.hide()
	Backend.connect_to_backend()	# MIDLERTIDIG

func _draw() -> void:
	draw_circle(Vector2(1920.0 / 2, 1080.0 / 2), 5000, Color.BLACK)

func _on_home_button_pressed() -> void:
	file_explorer.hide()
	tool_selector.hide()
	task_display.hide()
	notepad_app.hide()
	browser.hide()
	for tool in tool_panel.get_children():
		tool.hide()
