extends TaskCMD
class_name OpenPortCMD

# OpenPortCMD:
# En oppgavekommando som åpner en port på en gitt server.

static func create(_params: Dictionary) -> OpenPortCMD:
	if not _params.has_all(["server", "port", "process"]):
		return null	
	return OpenPortCMD.new(_params)


func execute() -> bool:
	


	return false
