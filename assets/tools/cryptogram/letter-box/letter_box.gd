class_name LetterBox extends Panel

@onready var guessed_letter: Label = %GuessedLetter
@onready var sub_letter: Label = $VBoxContainer/SubLetter
@onready var line: Panel = $VBoxContainer/Panel
@onready var button: Button = $%Button

var focused: bool = false

func _input(event: InputEvent) -> void:
	if not focused:
		return
	
	# Fjern bokstaven hvis spilleren trykker på backspace.
	if event.is_action_pressed("backspace"):
		set_guessed_letter("")
		button.release_focus()
		button.button_pressed = false
		return
	
	# Setter inn gjettet bokstav.
	var input_letter := event.as_text()
	if input_letter.length() != 1:
		return

	button.release_focus()
	button.button_pressed = false
	set_guessed_letter(input_letter)

func set_guessed_letter(input_letter: String) -> void:
	guessed_letter.text = input_letter.to_upper()

func set_sub_letter(input_letter: String) -> void:
	sub_letter.text = input_letter.to_upper()

func _on_button_toggled(toggled_on: bool) -> void:
	focused = toggled_on
	focus_mode = Control.FOCUS_ALL
