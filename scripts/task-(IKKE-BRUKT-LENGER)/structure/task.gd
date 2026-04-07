extends Resource
class_name Task

# Task:
# Dette er objektet som holder på hele oppgaven som spilles ut.
# Når brukeren trykker "spill", så skal klienten sende backenden en forespørsel
# om oppgavestrukturen, så lages en instanse av dette objektet med det i JSON-filen.

# Metadata
@export var id: int
@export var name: String
@export var description: String

# Tabell av objekter som lever i oppgaven
@export_category("Objects")
@export var objects: Dictionary[String, Variant] = {}

# Kommandoene som kjøres når oppgaven startes
@export var task_start_cmds: Array[TaskCMD] = []

# Kommandoene som kjøres når riktig flagg angis
@export var correct_flag_cmds: Array[TaskCMD] = []

# Kommandoene som kjøres når et feil flagg angis
@export var wrong_flag_cmds: Array[TaskCMD] = []



# Start():	Selvforklarende
func start() -> void:
	for cmd in task_start_cmds:
		cmd.execute()


# Finish():	Kjører når riktig flagg angis
func finish() -> void:
	for cmd in correct_flag_cmds:
		cmd.execute()


# Abort():	Rydder opp oppgaven når brukeren avbryter den
func abort() -> void:
	pass


# For debugging
func _to_string() -> String:
	var to_return: String = ""
	for object in objects:
		to_return += object + ", "
	return "TASK OBJECTS: [" + to_return + "]"
