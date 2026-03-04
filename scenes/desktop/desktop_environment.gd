class_name Desktop extends Control

const WINDOW: PackedScene = preload("res://scenes/window/custom_window.tscn")

@onready var crypto_task: CryptoTask = %CryptoTask
var root: Node = null

func _ready() -> void:
	root = get_tree().root
	crypto_task.hide()

func _on_crypto_button_pressed() -> void:
	_instantiate_tool(Tool.ToolType.CRYPTO_TOOL)

func _on_select_task_item_selected(index: int) -> void:
	match index: 
		1:
			crypto_task.visible = not crypto_task.visible
		2:
			print("Stegano task")
		3:
			print("Web task")
		_:
			print("Hello there.")

# Metode for å åpne nytt verktøy vindu
func _instantiate_tool(type: Tool.ToolType) -> void:
	var window := WINDOW.instantiate() as CustomWindow
	var tool := SceneManager.find_tool(type)
	window.initialize(tool)
	
	if not _window_exists(tool):
		root.add_child(window)
		return
	window.queue_free()

# Metode for å åpne ny oppgave vindu
func _instantiate_task(type: BaseTask.TaskType) -> void:
	var window := WINDOW.instantiate() as CustomWindow
	var task := SceneManager.find_task(type)
	window.initialize(task)
	
	if not _window_exists(task):
		root.add_child(window)
		return
	window.queue_free()

func _window_exists(scene: PackedScene) -> bool:
	for node in root.get_children():
		if node is CustomWindow:
			if node.current_scene == scene:
				return true
	return false
