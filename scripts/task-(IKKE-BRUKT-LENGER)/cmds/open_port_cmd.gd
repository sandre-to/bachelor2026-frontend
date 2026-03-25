extends TaskCMD
class_name OpenPortCMD

# OpenPortCMD:
# En oppgavekommando som åpner en port på en gitt server.

# Notater (Kristoffer):
# - Hvis kommandoen oppdager en feil, hva burde skje?
#	Skal en feilmelding skrives noen steder, eller burde feilen fikses?

# Create():	OpenPortCMD sin statiske fabrikkmetode.
#			Den verifiserer inputtet og henter det den trenger fra taskobjektet.
static func create(_params: Dictionary, _task: Task) -> OpenPortCMD:
	if not _params.has_all(["server", "port", "process"]):
		return null
	
	var cmd_objects: Dictionary[String, Variant] = {
		"server": _task.objects[_params["server"]],
		"port": _params["port"],
		"process": _task.objects[_params["process"]]
	}
	
	if cmd_objects["server"] is not Server \
	or cmd_objects["port"] is not float \
	or cmd_objects["process"] is not AbstractServerProcess:
		return null
	
	var cmd: OpenPortCMD = OpenPortCMD.new(cmd_objects, _task)
	return cmd


func execute() -> bool:
	return params["server"].open_port(params["port"], params["process"])
