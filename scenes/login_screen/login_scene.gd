class_name LoginScreen extends Control

@export var host_url: String = "http://localhost:8080"

# UI Knapper
@onready var choose_login_button: Button = $MarginContainer/VBoxContainer/ChooseLoginOrRegister/VBoxContainer/ChooseLoginButton
@onready var register_user_button: Button = $MarginContainer/VBoxContainer/ChooseLoginOrRegister/VBoxContainer/RegisterUserButton

@onready var user_label: Label = $MarginContainer/VBoxContainer/UserLabel
@onready var http_request: HTTPRequest = $HTTPRequest

# Registrer eller login panel
@onready var log_or_reg_panel: PanelContainer = $MarginContainer/VBoxContainer/ChooseLoginOrRegister
@onready var login_panel: PanelContainer = $MarginContainer/VBoxContainer/LoginPanel
@onready var register_panel: PanelContainer = $MarginContainer/VBoxContainer/RegisterPanel

func _ready() -> void:
	log_or_reg_panel.show()
	register_panel.hide()
	login_panel.hide()
	
	#Setter opp HTTP Request til en URL
	http_request.request_completed.connect(_on_request_completed)
	http_request.request("https://api.github.com/sandre-to/bachelor2026-frontend")
	

func _on_request_completed(_result: int, _response_code: int, _headers: PackedStringArray, 
	body: PackedByteArray) -> void:
	
	var json = JSON.parse_string(body.get_string_from_utf8())
	print(json["status"])

func _on_register_user_button_pressed() -> void:
	log_or_reg_panel.hide()
	register_panel.show()

func _on_choose_login_button_pressed() -> void:
	log_or_reg_panel.hide()
	login_panel.show()
