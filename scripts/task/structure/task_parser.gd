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
	
	# Object feilmeldinger (3 - 5)
	INVALID_OBJECT_TYPE,
	INVALID_OBJECT_ATTRIBUTES,
	MISSING_CHILD_OBJECT,
	
	# Key-events feilmeldinger (6 - x)
	MISSING_REQUIRED_KEY_EVENTS,
	NO_EVENT_CMD,
	MISSING_CMD_TYPE,
	NONEXISTANT_CMD_OBJECT,
	NONEXISTANT_CMD_TYPE,
	INVALID_CMD_DEFINITION,
}
var errno: ErrorCode = ErrorCode.OK
var err_desc: String = ""



# Parse_json_task():	Parser ut en oppgave i JSON form.
func parse(json_str: String) -> Task:

	var task: Task = Task.new()
	var json: Dictionary = JSON.parse_string(json_str)
	
	if not json.has_all(["objects", "key-events"]):
		set_error(ErrorCode.MISSING_FIELD, "parse(): Mangler et hovedfelt")
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
		match object_type:
			"file":
				ir_obj = _parse_file(name, json_objects[name])
			"directory":
				ir_obj = _parse_directory(name, json_objects[name])
			"npc-messenger":
				ir_obj = ParsedObject.new(name, "npc-messenger")
			"server":
				ir_obj = _parse_server(name, json_objects[name])
			"server-process":
				ir_obj = _parse_server_process(name, json_objects[name])
			_:
				set_error(ErrorCode.INVALID_OBJECT_TYPE, "_handle_objects(): Ugyldig objekt ("+ object_type +") prøves å parses")
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
			elif ir_obj.type == "server-process":
				ir_obj.parsed_object.resources.append(child.parsed_object)
		
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
		set_error(ErrorCode.INVALID_OBJECT_ATTRIBUTES, "_parse_file(): Mangler et påkrevd objektattributt for objektet '" + ref_name + "'")
		return null
	ir_obj.parsed_object = File.new(file_object.get("name"), null)
	ir_obj.parsed_object.update_content(file_object.get("content"))
	ir_obj.parsed_object.update_metadata(file_object.get("metadata"))
	return ir_obj


# _parse_directory():	Parser en katalog og returnerer et ir_objekt.
func _parse_directory(ref_name: String, dir_object: Dictionary) -> ParsedObject:
	var ir_obj: ParsedObject = ParsedObject.new(ref_name, dir_object.get("type"))
	if not dir_object.has_all(["name", "content"]):
		set_error(ErrorCode.INVALID_OBJECT_ATTRIBUTES, "_parse_dir(): Mangler et påkrevd objektattributt for objektet '" + ref_name + "'")
		return null
	ir_obj.parsed_object = Directory.new(dir_object.get("name"), null, null)
	ir_obj.children = dir_object.get("content")
	return ir_obj
	

# _parse_server():		Parser en server og returnerer et ir_objekt.
func _parse_server(ref_name: String, server_object: Dictionary) -> ParsedObject:
	var ir_obj: ParsedObject = ParsedObject.new(ref_name, server_object.get("type"))
	if not server_object.has_all(["hostname"]):
		set_error(ErrorCode.INVALID_OBJECT_ATTRIBUTES, "_parse_server(): Mangler et påkrevd objektattributt for objektet '" + ref_name + "'")
		return null
	ir_obj.parsed_object = Server.new(server_object.get("hostname"))
	return ir_obj


# _parse_server_process():		Parser en serverprosess og returnerer et ir_objekt.
func _parse_server_process(ref_name: String, server_process_object: Dictionary) -> ParsedObject:
	var ir_obj: ParsedObject = ParsedObject.new(ref_name, server_process_object.get("type"))
	if not server_process_object.has_all(["process-type","resources"]):
		set_error(ErrorCode.INVALID_OBJECT_ATTRIBUTES, "Mangler et påkrevd objektattributt for objektet '" + ref_name + "'")
		return null
	ir_obj.children = server_process_object.get("resources")
	ir_obj.parsed_object = _create_server_process(server_process_object.get("process-type"))
	if ir_obj.parsed_object == null:
		return null
	return ir_obj

# ---------------------------------------------------------------- #





# -------------------------| Key-events |------------------------- #
# Under ligger funksjoner knyttet til parsingen av nøkkelhendelser #

# _handle_key_events():	Funksjoner som parser nøkkelhendelser.
func _handle_key_events(key_events: Dictionary, task: Task) -> bool:
	
	if not key_events.has_all(["task-start", "correct-flag-submit"]):
		set_error(ErrorCode.MISSING_REQUIRED_KEY_EVENTS, "_handle_key_events(): Mangler påkrevd nøkkelhendelse")
		return false
		
	# 1: task-start
	var task_start: Dictionary = key_events.get("task-start")
	
	# 1.1: Kommandoer
	if not task_start.has("cmd"):
		set_error(ErrorCode.NO_EVENT_CMD, "_handle_key_events(): Mangler kommandoer for task-start")
		return false

	task.task_start_cmds = _parse_event_cmds(task_start.get("cmd"), task)
	
	# 1.2: Andre felt
	# ... (ingen rn)
	
	# 2: correct-flag-submit
	var correct_flag_submit: Dictionary = key_events.get("correct-flag-submit")
	
	# 2.1: Kommandoer
	if not correct_flag_submit.has("cmd"):
		set_error(ErrorCode.NO_EVENT_CMD, "_handle_key_events(): Mangler kommandoer for correct-flag-submit")
		return false
	
	task.correct_flag_cmds = _parse_event_cmds(correct_flag_submit.get("cmd"), task)

	# 2.2: Andre felt
	# ... (ingen rn)
	
	# 3: Andre events
	
	return true


# _parse_event_cmds():	Parser kommandoene ut ifra en dict.
func _parse_event_cmds(event_cmds: Array, task: Task) -> Array[TaskCMD]:
	var cmds: Array[TaskCMD] = []
	for cmd_dict in event_cmds:
		if not cmd_dict.has("type"):
			set_error(ErrorCode.MISSING_CMD_TYPE, "_handle_key_events(): Kommando mangler type")
			return []

		var cmd_type: String = cmd_dict.get("type")
		cmd_dict.erase("type")

		var cmd: TaskCMD
		match cmd_type:
			"open-port":
				cmd = OpenPortCMD.create(cmd_dict, task)
			"close-port":
				cmd = ClosePortCMD.create(cmd_dict, task)
			_:
				set_error(ErrorCode.NONEXISTANT_CMD_TYPE, "_handle_key_events(): Kommando har dårlig definert ellen manglende parameter (" + cmd_type +")")
				return []
				
		if cmd == null:
			set_error(ErrorCode.INVALID_CMD_DEFINITION, "_handle_key_events(): En kommando (type: " + cmd_type + ") kunne ikke parses")
			return []
				
		cmds.append(cmd)
	return cmds


# ---------------------------------------------------------------- #





# ------------------| Parser API-funksjoner |------------------ #
# Under ligger noen funksjoner som blir brukt rundt bruken av parseren

# Get_error():	Returnerer den nåverende erroren og reset verdien.
func get_error() -> ErrorCode:
	var to_return: ErrorCode = errno
	errno = ErrorCode.OK
	return to_return

# Get_error_desc():	Returnerer en beskrivelse av feilen.
func get_error_desc() -> String:
	return err_desc

# Set_error():	Setter en ny error.
func set_error(error: ErrorCode, desc: String) -> void:
	errno = error
	err_desc = desc


# ---------------| Miniskule hjelpefunksjoner |--------------- #

# _get_child_object():	Returnerer et objekt basert på navnet
func _get_child_object(child_name: String, objects: Array[ParsedObject]) -> ParsedObject:
	for obj in objects:
		if obj.name == child_name:
			return obj
	set_error(ErrorCode.MISSING_CHILD_OBJECT, "_get_child_object(): Barneobjektet (" + child_name + ") finnes ikke")
	return null
	

# _create_server_process():	Lager en serverprosess med riktig type
func _create_server_process(process_type: String) -> AbstractServerProcess:
	if process_type == "basic-ftp-process":
		return BasicFTPProcess.new()
	set_error(ErrorCode.INVALID_OBJECT_ATTRIBUTES, "_create_server_process(): Typen serverprosess eksisterer ikke")
	return null
