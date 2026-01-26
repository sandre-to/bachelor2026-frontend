class_name LoginScreen extends Control

@export var host_url: String = "http://localhost:8080"

# UI Knapper
@onready var choose_login_button: Button = $MarginContainer/VBoxContainer/ChooseLoginOrRegister/VBoxContainer/ChooseLoginButton
@onready var register_user_button: Button = $MarginContainer/VBoxContainer/ChooseLoginOrRegister/VBoxContainer/RegisterUserButton

@onready var user_label: Label = $MarginContainer/VBoxContainer/UserLabel
@onready var http_request: HTTPRequest = $HTTPRequest

# Registrer eller login panel
@onready var log_or_reg_panel: PanelContainer = $MarginContainer/VBoxContainer/ChooseLoginOrRegister
@onready var login_panel: VBoxContainer = $MarginContainer/VBoxContainer/LoginPanel
@onready var register_panel: VBoxContainer = $MarginContainer/VBoxContainer/RegisterPanel
@onready var confirm_register: Button = $MarginContainer/VBoxContainer/RegisterPanel/ConfirmRegister

func _ready() -> void:
	log_or_reg_panel.show()
	register_panel.hide()
	login_panel.hide()
	
	#Setter opp HTTP Request til en URL
	http_request.request_completed.connect(_on_request_completed)
	http_request.request(host_url)
	
func _on_request_completed(
	result: int, 
	response_code: int, 
	headers: PackedStringArray, 
	body: PackedByteArray
	) -> void:
	
	var response_text := body.get_string_from_utf8()
	print("Response code:", response_code)
	print("Response body:", response_text)

	if response_code == 200 or response_code == 201:
		print("Registration successful!")
	else:
		print("Registratison failed!")

func _on_register_user_button_pressed() -> void:
	log_or_reg_panel.hide()
	register_panel.show()

func _on_choose_login_button_pressed() -> void:
	log_or_reg_panel.hide()
	login_panel.show()

func _on_confirm_register_pressed() -> void:
	var username: String = register_panel.get_node("UsernameEnter").text
	var email: String = register_panel.get_node("EmailEnter").text
	var password: String = register_panel.get_node("PasswordEnter").text
	var passwordConfirm: String = register_panel.get_node("PasswordEnter2").text
	
	#Lagrer informasjonen til en JSON-fil
	var user_data := {
		"username": username,
		"email": email,
		"password": password,
		"passwordConfirm": passwordConfirm
	}
	
	var json_string := JSON.stringify(user_data)
	var headers := ["Content-Type: application/json"]
	var error := http_request.request(
		"http://localhost:8080/api/user/register",
		headers,
		HTTPClient.METHOD_POST,
		json_string
	)
	
	if error != OK:
		print("Error sending request: ", error)
