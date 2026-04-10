class_name CryptoScene extends BaseTask

func _ready() -> void:
	super._ready()
	set_data_info()

func set_data_info() -> void:
	title.text = task.name
	description.text = task.description
	puzzle.text = task.cipher_text

func _on_hint_pressed(index: int) -> void:
	match index:
		1:
			print("Button 1")
		2:
			print("Button 2")
		3:
			print("Button 3")
