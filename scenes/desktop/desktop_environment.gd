class_name Desktop extends Control

const WINDOW: PackedScene = preload("res://scenes/window/window.tscn")
var root: Node = null

func _ready() -> void:
	root = get_tree().root

func _on_crypto_button_pressed() -> void:
	if not _tool_exists(root, Tool.ToolType.CRYPTOTOOL):
		var window := WINDOW.instantiate()
		window.current_scene = SceneManager.find_tool_scene(Tool.ToolType.CRYPTOTOOL)
		root.add_child(window)

func _tool_exists(root_node: Node, type: Tool.ToolType) -> bool:
	for node in root_node.get_children():
		if node is CustomWindow:
			var child_node = node.get_child(0)
			if child_node.tool_type == type:
				return true
	return false
