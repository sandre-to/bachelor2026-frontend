class_name CaesarCipher extends Tool

@onready var text_input: TextEdit = $%TextEdit
@onready var shift_input: LineEdit = $%LineEdit
@onready var output_label: RichTextLabel = $%OutputLabel
@onready var line_edit: LineEdit = %LineEdit

var number: int = 0

func _ready() -> void:
	line_edit.text = str(number)

func encrypt(text: String, shift: int) -> String:
	if text_input.text == "":
		push_error("User entered empty text.")
		return ""
	
	if not valid_shift(shift_input.text):
		push_error("Shift entered is not a valid number.")
		return ""
	
	if abs(shift) > 9:
		push_error("The number entered is bigger than 9.")
		return ""
	
	var result := ""
	# Gå gjennom hele teksten (input fra bruker)
	for i in range(text.length()):
		var c := text[i]
		var code := c.unicode_at(0)
		
		# Hvis det er store bokstaver (blokk bokstaver)
		if code >= 65 and code <= 90:
			result += char(mod(code + shift - 65, 26) + 65)
		elif code >= 97 and code <= 122:
			result += char(mod(code + shift - 97, 26) + 97)
		else:
			result += c
		
	return result

func valid_shift(input: String) -> bool:
	return input.is_valid_int()

func _on_encrypt_pressed() -> void:
	output_label.text = encrypt(text_input.text, int(shift_input.text))

func _on_decrypt_pressed() -> void:
	output_label.text = encrypt(text_input.text, -int(shift_input.text))

func mod(a: int, b: int) -> int:
	return (a % b + b) % b

func _on_up_shift_pressed() -> void:
	if number >= 9:
		number = 9
		line_edit.text = str(number)
		return
		
	number += 1
	line_edit.text = str(number)
	

func _on_down_shift_pressed() -> void:
	if number <= 0:
		number = 0
		line_edit.text = str(number)
		return
		
	number -= 1
	line_edit.text = str(number)
