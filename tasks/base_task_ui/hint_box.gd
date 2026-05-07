class_name HintBox extends Panel

@onready var hint_title: Label = %HintTitle
@onready var label: Label = %Label
@onready var close_hint_button: Button = %CloseHintButton

func _ready() -> void:
	close_hint_button.pressed.connect(func(): 
		hide()
	)

func set_hint_text(hint: String, index: int) -> void:
	show()
	hint_title.text = "HINT " + str(index)
	label.text = hint

func _on_close_hint_button_pressed() -> void:
	hide()
