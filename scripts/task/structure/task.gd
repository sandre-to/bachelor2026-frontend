extends Resource
class_name Task

# Task:
# Dette er objektet som holder på hele oppgaven som spilles ut.
# Når brukeren trykker "spill", så skal klienten sende backenden en forespørsel
# om oppgavestrukturen, så lages en instanse av dette objektet med det i JSON-filen.

# Metadata
var id: int
var name: String
var description: String

# Tabell av objekter som lever i oppgaven
var objects: Dictionary[String, Variant] = {}

# Kommandoene som kjøres når oppgaven startes
var task_start_cmds: Array[TaskCMD] = []

# Kommandoene som kjøres når riktig flagg angis
var correct_flag_cmds: Array[TaskCMD] = []

# Kommandoene som kjøres når et feil flagg angis
var wrong_flag_cmds: Array[TaskCMD] = []

# Hovednettverket oppgaven kobler til
# Midlertidig oversettet til SPNetwork, sett til AbstractNetwork senere
var network: SPNetwork





# Start():	Selvforklarende
func start() -> void:
	for cmd in task_start_cmds:
		cmd.execute()


# Finish():	Kjører når riktig flagg angis
func finish() -> void:
	pass


# Abort():	Rydder opp oppgaven når brukeren avbryter den
func abort() -> void:
	pass


# For debugging
func _to_string() -> String:
	var to_return: String = ""
	for object in objects:
		to_return += object + ", "
	return "TASK OBJECTS: [" + to_return + "]"
