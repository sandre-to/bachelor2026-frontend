class_name Desktop extends Control

const WINDOW: PackedScene = preload("res://scenes/window/custom_window.tscn")

@onready var animation: AnimationPlayer = $Animation
@onready var color_rect: ColorRect = $Animation/ColorRect
@onready var file_explorer: Control = $FileExplorer

var root: Node = null

func _ready() -> void:
	color_rect.show()
	animation.play("fade_in")
	root = get_tree().root

func _on_files_button_pressed() -> void:
	file_explorer.visible = not file_explorer.visible
