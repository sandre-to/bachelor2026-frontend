extends Node

@export var url: String = ""
@onready var http_request: HTTPRequest = $HTTPRequest

signal request_success(data: Dictionary)
signal request_failed(code: int)

func _ready() -> void:
	# Send et signal når HTTP forespørsel er ferdig.
	http_request.request_completed.connect(_on_request_completed)
	
	if url == "": 
		return
	
	http_request.request(url)

func _on_request_completed(
	result: int, 
	response_code: int, 
	headers: PackedStringArray, 
	body: PackedByteArray) -> void:
	print("Request finished")
