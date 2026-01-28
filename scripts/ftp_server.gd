class_name FTPServer extends Server

var files: Array

func _init(id: int, ip_adress: String, open_ports: Array[int]) -> void:
	super(id, ip_adress, open_ports)
