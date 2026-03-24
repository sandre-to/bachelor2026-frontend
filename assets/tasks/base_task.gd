class_name BaseTask extends Control

enum TaskType {
	CRYPTO_TASK,
	STEGANO_TASK,
	WEB_TASK
}

@export var type: TaskType
@export var task: Task = null
var socket: WebSocketPeer = WebSocketPeer.new()
