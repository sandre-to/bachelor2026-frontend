class_name CryptogramPuzzle extends Control

const ALPHABET_LETTERS: String = "abcdefghijklmnopqrstuvwxyz"

var test_string: String = "good good"

func _ready() -> void:
	_randomize_alphabet()
	_substitute_letter(test_string)
	
func _substitute_letter(input_word: String) -> void:
	var scrambled_word: Array[String]
	var new_alphabet := _randomize_alphabet()
	
	for i in input_word.length():
		for j in ALPHABET_LETTERS.length():
			if input_word[i] == " ":
				scrambled_word.append(" ")
				break
			
			if input_word[i] == ALPHABET_LETTERS[j]:
				scrambled_word.append(new_alphabet[j])
	
	print(ALPHABET_LETTERS)
	print(new_alphabet)
	print(scrambled_word)
	
func _randomize_alphabet() -> Array[String]:
	var new_alphabet: Array[String]
	for i in range(ALPHABET_LETTERS.length()):
		new_alphabet.append(ALPHABET_LETTERS[i])
	new_alphabet.shuffle()
	return new_alphabet
