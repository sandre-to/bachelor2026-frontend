class_name CryptogramPuzzle extends Control

#Engelsk alfabetet
const ALPHABET_LETTERS: String = "abcdefghijklmnopqrstuvwxyz"

var test_string: String = "abc"
var mapped_letters: Dictionary[String, String] = {}

func _ready() -> void:
	_randomize_alphabet()
	_substitute_letter(test_string)
	
func _substitute_letter(input_word: String) -> void:
	var scrambled_word: Array[String]
	var new_alphabet := _randomize_alphabet()
	var index = 0
	
	while index < ALPHABET_LETTERS.length():
		mapped_letters[ALPHABET_LETTERS[index]] = new_alphabet[index]
		index += 1
		
	for i in mapped_letters.size():
		print("Keys: %s Value: %s" % [mapped_letters.keys()[i], mapped_letters.values()[i]])
		
	#for i in input_word.length():
		#for j in ALPHABET_LETTERS.length():
			##Sjekker om det er mellomrom i ordet. 
			##Hvis det er, så hopper den over til neste iterasjon.
			#if input_word[i] == " ":
				#scrambled_word.append(" ")
				#break
			#
			##Legger til bokstavene i en ny array
			#if input_word[i] == ALPHABET_LETTERS[j]:
				#scrambled_word.append(new_alphabet[j])
	
	#Print meldinger for debugging
	#print(new_alphabet)
	#print(scrambled_word)

# Funksjon for å endre rekkefølgen på alfabetet
func _randomize_alphabet() -> Array[String]:
	var new_alphabet: Array[String]
	for i in range(ALPHABET_LETTERS.length()):
		new_alphabet.append(ALPHABET_LETTERS[i])
	new_alphabet.shuffle()
	return new_alphabet
