class_name NetworkObject extends MasterObject

@export var ip_adress: String = ""

func _to_string() -> String:
	return "IP-adresse: %s + %d" % [ip_adress, ID]
