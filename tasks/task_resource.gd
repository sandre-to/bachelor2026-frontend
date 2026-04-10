class_name TaskData extends Resource

enum TaskType {
	CRYPTO,
	STEGANO,
	WEB_EXPLOIT
}

@export var id: int
@export var type: TaskType
@export var name: String = "" 
@export var completed: bool = false
@export_multiline() var description: String = ""

# Felt hentet av backenden #
@export var dynamic_data: Dictionary = {}
@export_multiline() var extra_description: String = ""
var hint_costs: Array[float] = []


#func _init(_id: int, _name: String, _type: TaskType, _desc: String) -> void:
	#id = _id
	#name = _name
	#type = _type
	#description = _desc
	
	# Denne funksjonen kontakter backenden, starter oppgavesesjonen og henter data
	# For å slippe å sette opp backenden må du sette "dynamic_data" og "extra_description" selv.
	#_alert_backend(id)
	


func _alert_backend(id: int) -> bool:
	var req_id: int = Backend.send_own({
		"type": "task",
		"data": {
			"taskID": id
		}
	})
	
	var response: Dictionary = await Backend.await_message(req_id)
	if response.get("status") == "error":
		# FEILHÅNDTER #
		return false
	
	if not response.has("metadata"):
		# FEILHÅNDTER #
		return false
		
	if not response.has("dynamic"):
		# FEILHÅNDTER #
		return false
		
	dynamic_data = response.get("dynamic")

	var task_metadata: Dictionary = response.get("metadata")
	if task_metadata.has("extraDescription"):
		extra_description = task_metadata.get("extraDescription")
	if task_metadata.has("hintCosts"):
		hint_costs = task_metadata.get("hintCosts")
	
	return true
