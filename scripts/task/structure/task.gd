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

# Tabell med kommandoene som skal kjøres når oppgaven startes
var task_start_cmds: Array[TaskCMD] = []

# Hovednettverket oppgaven kobler til
var network: AbstractNetwork





# For debugging
func _to_string() -> String:
	var to_return: String = ""
	for object in objects:
		to_return += object + ", "
	return "TASK OBJECTS: [" + to_return + "]"
