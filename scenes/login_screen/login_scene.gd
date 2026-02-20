class_name LoginScreen extends Control

@export var host_url: String = "http://localhost:8080"

# UI Knapper
@onready var choose_login_button: Button = $MarginContainer/VBoxContainer/ChooseLoginOrRegister/VBoxContainer/ChooseLoginButton
@onready var register_user_button: Button = $MarginContainer/VBoxContainer/ChooseLoginOrRegister/VBoxContainer/RegisterUserButton

@onready var user_label: Label = $MarginContainer/VBoxContainer/UserLabel

# Registrer eller login panel
@onready var log_or_reg_panel: PanelContainer = $MarginContainer/VBoxContainer/ChooseLoginOrRegister
@onready var login_panel: VBoxContainer = $MarginContainer/VBoxContainer/LoginPanel
@onready var register_panel: VBoxContainer = $MarginContainer/VBoxContainer/RegisterPanel
@onready var confirm_register: Button = %ConfirmRegister

func _ready() -> void:
	log_or_reg_panel.show()
	register_panel.hide()
	login_panel.hide()
	
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
	
	if password != passwordConfirm:
		push_error("Password not matching")
		return
	
	#Lagrer informasjonen til en JSON-fil
	var user_data := {
		"username": username,
		"email": email,
		"password": password,
		"passwordConfirm": passwordConfirm
	}
	
	var json_string := JSON.stringify(user_data)
	var headers := ["Content-Type: application/json"]

func _on_back_button_pressed() -> void:
	register_panel.hide()
	login_panel.hide()
	log_or_reg_panel.show()
