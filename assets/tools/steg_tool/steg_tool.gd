extends Tool
class_name StegTool

# Hvis Tool har en type property dere bruker:
@export var tool_type: ToolType = ToolType.STEGANOTOOL

var current_path: String = ""
var last_result: Dictionary = {}

func _ready() -> void:
	# Koble UI her når du har noder på plass
	# Eksempel (endre til riktige nodepaths):
	# %LoadButton.pressed.connect(_on_load_pressed)
	# %ScanButton.pressed.connect(_on_scan_pressed)
	# %ClearButton.pressed.connect(_on_clear_pressed)
	pass

# Denne kaller du fra UI når spiller har valgt fil.
func run_with_path(abs_path: String) -> Dictionary:
	current_path = abs_path

	var entity = Filesystem.get_file_entity(abs_path)
	if entity == null:
		return _error("Fant ikke fil: %s" % abs_path)

	var metadata := extract_metadata(entity, abs_path)
	var findings := analyze_metadata(metadata)

	last_result = {
		"metadata": metadata,
		"findings": findings
	}

	return last_result

func extract_metadata(entity: Variant, abs_path: String) -> Dictionary:
	var data: Dictionary = {}
	data["file_name"] = abs_path.get_file()
	data["abs_path"] = abs_path

	# Tilpass etter hva file-entity faktisk har:
	if entity is Dictionary:
		if entity.has("size"): data["file_size"] = entity["size"]
		if entity.has("mime"): data["mime"] = entity["mime"]
	elif entity.has_method("get_size"):
		data["file_size"] = entity.get_size()

	# MVP: legg inn felter dere kan bruke i CTF-levels
	# Senere: parse PNG tEXt/iTXt, enkel EXIF, GPS osv.
	data["comment"] = "example metadata"

	return data

func analyze_metadata(metadata: Dictionary) -> Array:
	var results: Array = []

	for k in metadata.keys():
		var v := str(metadata[k])

		if v.find("flag{") != -1 or v.find("ctf{") != -1:
			results.append({
				"type": "flag",
				"severity": "high",
				"title": "Mulig flagg",
				"path": str(k),
				"value": v
			})

		if _is_base64_like(v):
			results.append({
				"type": "base64",
				"severity": "warn",
				"title": "Ser ut som Base64",
				"path": str(k),
				"value": v
			})

		if v.length() > 120:
			results.append({
				"type": "long_string",
				"severity": "info",
				"title": "Uvanlig lang tekst",
				"path": str(k),
				"preview": v.substr(0, 80) + "..."
			})

	return results

func _is_base64_like(text: String) -> bool:
	if text.length() < 16:
		return false
	var r := RegEx.new()
	r.compile("^[A-Za-z0-9+/]+={0,2}$")
	return r.search(text) != null

func _error(msg: String) -> Dictionary:
	return {"error": true, "message": msg}
