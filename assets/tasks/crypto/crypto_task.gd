class_name CryptoTask extends BaseTask

var flag_solution: String = "hellothere"

@onready var enter_flag: LineEdit = %EnterFlag
@onready var hint_1_panel: Panel = $Hint1Panel

func _ready() -> void:
	hint_1_panel.hide()

func _on_confirm_button_pressed() -> void:
	if enter_flag.text.to_lower() == flag_solution:
		print("nice!")
	else:
		print("wrong answer")

func _on_hint_1_pressed() -> void:
	hint_1_panel.visible = not hint_1_panel.visible
