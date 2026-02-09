class_name CryptogramPuzzle extends Control

# Engelsk alfabet
const ALPHABET_LETTERS: String = "abcdefghijklmnopqrstuvwxyz"

# Tenkte å lage ulike tekstfiler etter hvilke nivå spilleren er på.
# Alle setninger må være på engelsk.

# Nive 1 (skal være veldig lett).
# Les en teksfil som består av setninger med tre til fire ord.
# Hvert ord skal ikke inneholde mer enn fire bokstaver.
# Eksempel på setning: "Is it safe"?

# Dette er kun en test string som sendes inn i "generate_words" funksjonen.
@export var test_string: String = ""
@export var letter_box_scene: PackedScene

@onready var word_manager: GridContainer = %WordManager

var mapped_letters: Dictionary[String, String] = {}

func _ready() -> void:
	_substitute_letter()
	generate_words(test_string)

func _substitute_letter() -> void:
	var new_alphabet := _randomize_alphabet()
	
	#Gi hver bokstav en ny verdi
	for i in ALPHABET_LETTERS.length():
		mapped_letters[ALPHABET_LETTERS[i]] = new_alphabet[i]
	
	#Printer ut key: value for debugging
	for i in mapped_letters.size():
		print("Keys: %s Value: %s" % [mapped_letters.keys()[i], mapped_letters.values()[i]])

# Funksjon for å endre rekkefølgen på alfabetet
func _randomize_alphabet() -> Array[String]:
	var new_alphabet: Array[String]
	
	#Ender rekkefølgen på nye alfabetet helt til det ikke samsvarer med "vanlige alfabetet"
	while true:
		new_alphabet.clear()
		
		for i in ALPHABET_LETTERS.length():
			new_alphabet.append(ALPHABET_LETTERS[i])

		new_alphabet.shuffle()

		if _is_not_duplicate_letter(new_alphabet):
			return new_alphabet
		
	return []

func _is_not_duplicate_letter(alphabet: Array[String]) -> bool:
	for i in range(alphabet.size()):
		if alphabet[i] == ALPHABET_LETTERS[i]:
			return false
	return true

func generate_words(words: String) -> void:
	for letter in words:
		var lower_case_letter := letter.to_lower()
		var letter_box: LetterBox = letter_box_scene.instantiate()
		word_manager.add_child(letter_box)
		
		# Mellomrom i setningen.
		if letter == " ":
			letter_box.button.disabled = true
			letter_box.button.self_modulate = 0
			letter_box.line.hide()
			continue
		
		# Sjekker om bokstavene som er sendt finnes i alfabetet
		if ALPHABET_LETTERS.contains(lower_case_letter):
			var style := StyleBoxLine.new()
			style.color = Color.WHITE #Bokstaver får en hvit linje som indikerer at det ikke er mellomrom
			letter_box.line.add_theme_stylebox_override("panel", style)
			
			letter_box.set_sub_letter(mapped_letters.get(lower_case_letter))
			letter_box.button.disabled = false
			letter_box.button.modulate = Color.WHITE
			continue
		
		# Denne delen kjører kun hvis det er symboler eller annet. 
		letter_box.button.self_modulate = 0
		letter_box.guessed_letter.text = letter
		letter_box.line.hide()
