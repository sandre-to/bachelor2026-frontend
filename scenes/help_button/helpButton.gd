extends Button
class_name HelpButton

signal help_requested

func _ready() -> void:
	pressed.connect(_on_pressed)

func _on_pressed() -> void:
	print("HELP BUTTON INTERNAL")
	help_requested.emit()
