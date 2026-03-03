extends TaskCMD
class_name ClosePortCMD

# ClosePortCMD:
# Lukker en gitt servers port.

static func create(_params: Dictionary, _task: Task) -> ClosePortCMD:
	if not _params.has_all(["server", "port"]):
		return null
	
	var cmd_objects: Dictionary[String, Variant] = {
		"server": _task.objects[_params["server"]],
		"port": _params["port"]
	}
	
	if cmd_objects["server"] is not Server \
	or cmd_objects["port"] is not float:
		return null
	
	var cmd: ClosePortCMD = ClosePortCMD.new(cmd_objects, _task)
	return cmd


func execute() -> bool:
	return params["server"].close_port(params["port"])
