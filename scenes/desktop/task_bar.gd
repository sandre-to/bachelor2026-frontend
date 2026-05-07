class_name TaskBar extends Panel

@onready var file_explorer: FileExplorer = %FileExplorer
@onready var tool_selector: ToolSelector = %ToolSelector

func _on_files_button_pressed() -> void:
	file_explorer.visible = not file_explorer.visible

func _on_tools_button_pressed() -> void:
	tool_selector.visible = not tool_selector.visible
