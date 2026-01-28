class_name Server extends NetworkObject

@export var open_ports: Array[int]

func _init(id: int, ip_adress: String, open_ports: Array[int]) -> void:
	self.ID = id
	self.ip_adress = ip_adress
	self.open_ports = open_ports
	
func open_port(port: int) -> void:
	pass
