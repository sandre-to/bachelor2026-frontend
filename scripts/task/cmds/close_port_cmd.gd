extends TaskCMD
class_name ClosePortCMD

# ClosePortCMD:
# Lukker en gitt servers port.

static func create(_params: Dictionary, _task: Task) -> ClosePortCMD:
	if not _params.has_all(["server", "port"]):
		return null
	
	var cmd_objects: Dictionary[String, Variant] = {
		"server": _task._params["server"],
		"port": _task._params["port"]
	}
	
	if cmd_objects["server"] is not Server \
	or cmd_objects["port"] is not int:
		return null
	
	var cmd: ClosePortCMD = ClosePortCMD.new(_params, _task)
	return cmd


func execute() -> bool:
	return params["server"].close_port(params["port"])
