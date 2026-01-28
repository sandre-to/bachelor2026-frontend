class_name WebServer extends Server

var sites: Array

func _init(id: int, ip_adress: String, open_ports: Array[int]) -> void:
	super(id, ip_adress, open_ports)
