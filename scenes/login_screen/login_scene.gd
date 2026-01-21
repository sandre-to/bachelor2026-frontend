class_name LoginScreen extends Control

@onready var register_user_button: Button = $MarginContainer/VBoxContainer/PanelContainer/RegisterUserButton
@onready var user_label: Label = $MarginContainer/VBoxContainer/UserLabel

func _on_register_user_button_pressed() -> void:
	print("Register new user")
