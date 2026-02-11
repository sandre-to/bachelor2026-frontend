class_name CaesarCipher extends Tool

@onready var text_input: TextEdit = $MainPanel/TextEdit
@onready var shift_input: LineEdit = $MainPanel/LineEdit
@onready var output_label: RichTextLabel = $OutputPanel/OutputLabel

var tool_type: ToolType = ToolType.CRYPTOTOOL

func encrypt(text: String, shift: int) -> String:
	if text_input.text == "":
		push_error("User entered empty text.")
		return ""
	
	if not valid_shift(shift_input.text):
		push_error("Shift entered is not a valid number.")
		return ""
	
	if shift > 9: 
		push_error("The number entered is bigger than 9.")
		return ""
	
	var result := ""
	# Gå gjennom hele teksten (input fra bruker)
	for i in range(text.length()):
		var character := text[i]
		
		# Hvis det er store bokstaver (blokk bokstaver)
		if character >= "A" and character <= "Z":
			result += char((character.unicode_at(0) + shift - 65) % 26 + 65)
		# Hvis det er små bokstaver
		elif character >= "a" and character <= "z":
			result += char((character.unicode_at(0) + shift - 97) % 26 + 97)
		else:
			result += character
	
	return result

func valid_shift(input: String) -> bool:
	return input.is_valid_int()

func _on_encrypt_pressed() -> void:
	output_label.text = encrypt(text_input.text, int(shift_input.text))

func _on_decrypt_pressed() -> void:
	output_label.text = encrypt(text_input.text, -int(shift_input.text))
