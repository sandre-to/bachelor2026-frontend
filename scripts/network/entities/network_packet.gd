extends Resource
class_name NetworkPacket

# NetworkPacket:
# Et objekt som skal representere en datapakke
# sendt over nettverket til en server

# Til-feltene; informasjon om mottakeren
var to_ip: String
var to_port: int

# Fra-feltene; informasjon om senderen
var from_ip: String

# Selve innholdet
var content: String

func _init(_to_ip: String, _to_port: int, _from_ip: String, _content: String) -> void:
	self.to_ip = _to_ip
	self.to_port = _to_port
	self.from_ip = _from_ip
	self.content = _content
