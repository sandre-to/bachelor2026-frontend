class_name CryptoTutorial extends TutorialTask


func _on_start() -> bool:
	type = "crypto"
	puzzle.text = task.cipher_text
	return true
	
