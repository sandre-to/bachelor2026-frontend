class_name LoginScreen extends Control

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

# URL-er
@export var host_url: String = "http://localhost:8080"
@export var register_url: String = "/api/user/register"
@export var login_url: String = "/login"	# Endre til /api/user/login
var last_request_type: String = "None"


func _ready() -> void:
	log_or_reg_panel.show()
	register_panel.hide()
	login_panel.hide()
	
	#Setter opp HTTP Request til en URL
	http_request.request_completed.connect(_on_request_completed)


# _on_request_completed():	Når en forespørsel sendes
@warning_ignore("unused_parameter")
func _on_request_completed(
		result: int, 
		response_code: int, 
		headers: PackedStringArray, 
		body: PackedByteArray
	) -> void:
	
	var response_text: String = body.get_string_from_utf8()
	print(response_text)
	
	if last_request_type == "Login":
	# TODO: Lag en WS-forbindelse & GTFO til desktopscenen
		pass
	elif last_request_type == "Register":
	# TODO: Vis statusmelding til brukeren
		pass
	else:
		print("wtf")



# _on_confirm_register_pressed():	Registrer brukeren
func _on_confirm_register_pressed() -> void:
	var username: String = register_panel.get_node("UsernameEnter").text
	var email: String = register_panel.get_node("EmailEnter").text
	var password: String = register_panel.get_node("PasswordEnter").text
	var passwordConfirm: String = register_panel.get_node("PasswordEnter2").text
	
	# TODO:	Vis denne meldingen for brukeren
	if password != passwordConfirm:
		print("Password not matching")
		return
	
	#Lagrer informasjonen i JSON-format
	var user_data: Dictionary[String, String] = {
		"username": username,
		"email": email,
		"password": password,
		"passwordConfirm": passwordConfirm
	}
	
	var json_string: String = JSON.stringify(user_data)
	var headers := ["Content-Type: application/json"]
	var error := http_request.request(
		host_url + register_url,	# Siden + /api/user/register
		headers,
		HTTPClient.METHOD_POST,
		json_string
	)
	
	if error != OK:
		print("Error sending request: ", error)
	else:
		last_request_type = "Register"


# _on_confirm_button_pressed():	Logger brukeren inn
func _on_confirm_button_pressed() -> void:
	var username: String = login_panel.get_node("UsernameEnter").text
	var password: String = login_panel.get_node("PasswordEnter").text
	
	#Lagrer informasjonen i JSON-format
	var user_data: Dictionary[String, String] = {
		"username": username,
		"password": password,
	}
	
	var json_string: String = JSON.stringify(user_data)
	var headers := ["Content-Type: application/json"]
	var error := http_request.request(
		host_url + login_url,	# Siden + /api/user/login
		headers,
		HTTPClient.METHOD_POST,
		json_string
	)
	
	# TODO: what
	if error != OK:
		print("Error sending request: ", error)
	else:
		last_request_type = "Login"
	

	

func _on_register_user_button_pressed() -> void:
	log_or_reg_panel.hide()
	register_panel.show()


func _on_choose_login_button_pressed() -> void:
	log_or_reg_panel.hide()
	login_panel.show()


func _on_back_from_register_button_pressed() -> void:
	log_or_reg_panel.show()
	register_panel.hide()


func _on_back_from_login_button_pressed() -> void:
	log_or_reg_panel.show()
	login_panel.hide()
