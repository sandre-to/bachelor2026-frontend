extends Resource
class_name TaskParser

# TaskParser:
# Dette er en singeltonklasse som har ansvar for å parse en oppgave
# gitt av backenden inn til et Task-objekt.

# Notater (Kristoffer):
# - Når et objekt parses, så lages alle objektene først, deretter så 
#	knyttes objekter som har et forhold sammen, f.eks en katalog som 
#	inneholder en fil. 
# 


# Errorkoder hvis parsingen gikk galt
enum ErrorCode{
	OK,
	UNEXPECTED_FIELD,
	MISSING_FIELD,
	
	# Object feilmeldinger
	INVALID_OBJECT_TYPE,
	INVALID_OBJECT_ATTRIBUTES,
	MISSING_CHILD_OBJECT,
	
	# Key-events feilmeldinger
	MISSING_REQUIRED_KEY_EVENTS,
	NO_EVENT_CMD,
	
}
var error_code: ErrorCode = ErrorCode.OK


# Gyldige kommandoer som oppgaven kan utføre
const valid_task_cmds: Array[String] = [
	"send-message",		# Får en NPC-messsenger til å sende en melding til spilleren
	"open-port",		# Åpner en serverport
	"close-port"		# Lukker en serverport
]

# Gyldige triggers
const valid_triggers: Array[String] = [
	"timed",
	"user-message"
]


# Parse_json_task():	Parser ut en oppgave i JSON form.
func parse(json_str: String) -> Task:

	var task: Task = Task.new()
	var json: Dictionary = JSON.parse_string(json_str)
	
	if not json.has_all(["objects", "key-events", "triggers"]):
		set_error(ErrorCode.MISSING_FIELD)
		return null
	
	if not _handle_objects(json.get("objects"), task):
		return null
	
	if not _handle_key_events(json.get("key-events"), task):
		return null
	
	return task





# --------------------------| Objects |-------------------------- #
# Under denne linjen ligger alt knyttet til parsingen av objekter #

# _handle_objects():	Parser objekter, returnerer en bool basert på suksess.
func _handle_objects(json_objects: Dictionary, task: Task) -> bool:
	
	# Midlertidig parseobjekter
	var intermediate_objects: Array[ParsedObject]
	
	# 1: Konverter JSON til ir_objekter
	for name in json_objects:
		
		# ir = Intermediate representation
		var ir_obj: ParsedObject
	
		# Hva slags objekt er det
		var object_type: String = json_objects[name].get("type")
		if object_type == "file":
			ir_obj = _parse_file(name, json_objects[name])
		elif object_type == "directory":
			ir_obj = _parse_directory(name, json_objects[name])
		elif object_type == "npc-messenger":
			ir_obj = ParsedObject.new(name, "npc-messenger")
		elif object_type == "server":
			ir_obj = _parse_server(name, json_objects[name])
		else:
			set_error(ErrorCode.INVALID_OBJECT_TYPE)
			return false
			
		# Hvis objektet var definert dårlig (error er satt av parserfunksjonen)
		if ir_obj == null:
			return false
		
		intermediate_objects.append(ir_obj)
		
	# 2: Knytt objekter sammen
	for ir_obj in intermediate_objects:
		if not ir_obj.has_children():
			continue
		
		# Gå gjennom barna
		for child_name in ir_obj.children:
			var child: ParsedObject = _get_child_object(child_name, intermediate_objects)
			if child == null:
				return false

			# Hva slags objekt er forelderobjektet?			
			if ir_obj.type == "directory":
				ir_obj.parsed_object.insert_into(child.parsed_object)
		
	# 3: Gi objekter til task
	for ir_obj in intermediate_objects:
		task.objects.set(ir_obj.name, ir_obj.parsed_object)
		
	return true
	

# ---------------| Objektparsere |--------------- #
# Alle funksjoner som parser et objekt ligger under denne linjen.

# _parse_file():		Parser en fil og returnerer et ir_objekt.
func _parse_file(ref_name: String, file_object: Dictionary) -> ParsedObject:
	var ir_obj: ParsedObject = ParsedObject.new(ref_name, file_object.get("type"))
	if not file_object.has_all(["name", "metadata", "content"]):
		set_error(ErrorCode.INVALID_OBJECT_ATTRIBUTES)
		return null
	ir_obj.parsed_object = File.new(file_object.get("name"), null)
	ir_obj.parsed_object.update_content(file_object.get("content"))
	ir_obj.parsed_object.update_metadata(file_object.get("metadata"))
	return ir_obj


# _parse_directory():	Parser en katalog og returnerer et ir_objekt.
func _parse_directory(ref_name: String, dir_object: Dictionary) -> ParsedObject:
	var ir_obj: ParsedObject = ParsedObject.new(ref_name, dir_object.get("type"))
	if not dir_object.has_all(["name", "content"]):
		set_error(ErrorCode.INVALID_OBJECT_ATTRIBUTES)
		return null
	ir_obj.parsed_object = Directory.new(dir_object.get("name"), null, null)
	ir_obj.children = dir_object.get("content")
	return ir_obj
	

# _parse_server():		Parser en server og returnerer et ir_objekt.
func _parse_server(ref_name: String, server_object: Dictionary) -> ParsedObject:
	var ir_obj: ParsedObject = ParsedObject.new(ref_name, server_object.get("type"))
	if not server_object.has_all(["hostname", "ip"]):
		set_error(ErrorCode.INVALID_OBJECT_ATTRIBUTES)
		return null
	ir_obj.parsed_object = Device.new(server_object.get("hostname"), server_object.get("ip"))
	return ir_obj

# ---------------------------------------------------------------- #





# -------------------------| Key-events |------------------------- #
# Under ligger funksjoner knyttet til parsingen av nøkkelhendelser #

# _handle_key_events():	Funksjoner som parser nøkkelhendelser.
func _handle_key_events(key_events: Dictionary, task: Task) -> bool:
	
	if not key_events.has_all(["task-start", "correct-flag-submit"]):
		set_error(ErrorCode.MISSING_REQUIRED_KEY_EVENTS)
		return false
		
	# 1: task-start
	var task_start: Dictionary = key_events.get("task-start")
	
	# 1.1: Hent ut kommandoene
	if not task_start.has("cmd"):
		set_error(ErrorCode.NO_EVENT_CMD)
		return false

	for cmd in task_start.get("cmd"):
		pass
	
	return true


# ---------------------------------------------------------------- #





# ------------------| Parser API-funksjoner |------------------ #
# Under ligger noen funksjoner som blir brukt rundt bruken av parseren

# Get_error():	Returnerer den nåverende erroren og reset verdien.
func get_error() -> ErrorCode:
	var to_return: ErrorCode = error_code
	error_code = ErrorCode.OK
	return to_return

# Set_error():	Setter en ny error
func set_error(error: ErrorCode) -> void:
	error_code = error


# ---------------| Miniskule hjelpefunksjoner |--------------- #

# _get_child_object():	Returnerer et objekt basert på navnet
func _get_child_object(child_name: String, objects: Array[ParsedObject]) -> ParsedObject:
	for obj in objects:
		if obj.name == child_name:
			return obj
	set_error(ErrorCode.MISSING_CHILD_OBJECT)
	return null
	
