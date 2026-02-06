class_name LetterBox extends Panel

@onready var guessed_letter: Label = %GuessedLetter
@onready var sub_letter: Label = $VBoxContainer/SubLetter
@onready var line: Panel = $VBoxContainer/Panel
@onready var button: Button = $VBoxContainer/Button

var focused: bool = false

func set_sub_letter(input_letter: String) -> void:
	sub_letter.text = input_letter.to_upper()

func _on_button_toggled(toggled_on: bool) -> void:
	focused = toggled_on
