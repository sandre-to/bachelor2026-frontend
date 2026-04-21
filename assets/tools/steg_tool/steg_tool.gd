extends Tool
class_name StegTool

var current_path: String = ""
var last_result: Dictionary = {}

@onready var file_path_input: LineEdit = $CenterContainer/PanelContainer/MarginContainer/VBoxContainer/FileInput/HBoxContainer/LineEdit
@onready var extract_button: Button = $CenterContainer/PanelContainer/MarginContainer/VBoxContainer/FileInput/HBoxContainer/extractButton
@onready var metadata_output: RichTextLabel = $CenterContainer/PanelContainer/MarginContainer/VBoxContainer/MetaDataPanel/Panel/ScrollContainer/Label
@onready var findings_output: Label = $CenterContainer/PanelContainer/MarginContainer/VBoxContainer/FindingsPanel/Panel/Label
@onready var clear_button: Button = $CenterContainer/PanelContainer/MarginContainer/VBoxContainer/HBoxContainer/clearButton
@onready var analyze_button: Button = $CenterContainer/PanelContainer/MarginContainer/VBoxContainer/HBoxContainer/analyzeButton

func _ready() -> void:
	tool_type = ToolType.STEGANO_TOOL
	super()

func run_with_path(abs_path: String) -> Dictionary:
	current_path = abs_path

	var entity: FileEntity = FileSystem.get_file_entity(abs_path)
	if entity == null:
		return _error("Could not find file: %s" % abs_path)

	if not (entity is ImageFile):
		return _error("This tool only works on image files.")

	var metadata := extract_metadata(entity)
	metadata["file_name"] = abs_path.get_file()
	metadata["abs_path"] = abs_path
	
	var findings := analyze_metadata(metadata)
	
	last_result = {
		"metadata": metadata,
		"findings": findings
	}

	return last_result

func extract_metadata(entity: FileEntity) -> Dictionary:
	var data: Dictionary = {}

	for key in entity.metadata.keys():
		data[key] = entity.metadata[key]

	return data

func analyze_metadata(metadata: Dictionary) -> Array:
	var results: Array = []

	for k in metadata.keys():
		var v := str(metadata[k])
		var lower_v := v.to_lower()
		
		if "flag{" in lower_v or "ctf{" in lower_v:
			results.append({
				"type": "flag",
				"severity": "high",
				"title": "Possible flag",
				"path": str(k),
				"value": v
			})

		if _is_base64_like(v):
			results.append({
				"type": "base64",
				"severity": "warn",
				"title": "Detected possible Base64",
				"path": str(k),
				"value": v
			})

		if v.length() > 120:
			results.append({
				"type": "long_string",
				"severity": "info",
				"title": "Unusually long text",
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

func _on_extract_pressed() -> void:
	var path := file_path_input.text.strip_edges()

	if path.is_empty():
		metadata_output.text = "No file path provided."
		findings_output.text = ""
		return

	var result := run_with_path(path)

	if result.get("error", false):
		metadata_output.text = result.get("message", "Unknown error.")
		findings_output.text = ""
		return

	var metadata: Dictionary = result.get("metadata", {})
	last_result = result

	metadata_output.text = _format_metadata(metadata)
	findings_output.text = "Metadata extracted. Ready for analysis."

func _on_analyze_pressed() -> void:
	if last_result.is_empty():
		findings_output.text = "No extracted metadata to analyze."
		return

	var metadata: Dictionary = last_result.get("metadata", {})
	var findings: Array = analyze_metadata(metadata)

	last_result["findings"] = findings
	findings_output.text = _format_findings(findings)

func _on_clear_pressed() -> void:
	file_path_input.text = ""
	metadata_output.text = ""
	findings_output.text = ""
	last_result.clear()
	current_path = ""

func _format_metadata(metadata: Dictionary) -> String:
	var lines: Array[String] = []

	for key in metadata.keys():
		lines.append("%s: %s" % [str(key), str(metadata[key])])

	return "\n".join(lines)

func _format_findings(findings: Array) -> String:
	if findings.is_empty():
		return "No suspicious findings."

	var lines: Array[String] = []

	for finding in findings:
		var title := str(finding.get("title", "Unknown finding"))
		var path := str(finding.get("path", ""))
		lines.append("- %s (%s)" % [title, path])

	return "\n".join(lines)

func _on_extract_button_pressed() -> void:
	_on_extract_pressed()

func _on_clear_button_pressed() -> void:
	_on_clear_pressed()

func _on_analyze_button_pressed() -> void:
	_on_analyze_pressed()

func _on_line_edit_text_submitted(_new_text: String) -> void:
	_on_extract_pressed()
