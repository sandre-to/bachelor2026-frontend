class_name Desktop extends Control

const WINDOW: PackedScene = preload("res://scenes/window/window.tscn")

func _on_crypto_button_pressed() -> void:
	var window := WINDOW.instantiate()
	window.current_scene = SceneManager.find_tool_scene(Tool.ToolType.CRYPTOTOOL)
	get_tree().current_scene.add_child(window)
