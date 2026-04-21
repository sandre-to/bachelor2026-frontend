extends RefCounted
class_name MessageQueue

enum TypePolicy{
	NO_RIGHT,	# Meldingstypen har ikke rett til å være i køen
	UNIQUE,		# Bare en av meldingstypen kan eksistere i køen
	FULL_RIGHT	# Flere av samme type kan eksistere i køen
}

# Knytt en type til en regel
const TYPE_POLICIES: Dictionary[String, TypePolicy] = {
	"task-info": 		TypePolicy.UNIQUE,
	"task": 			TypePolicy.NO_RIGHT,
	"parse-status": 	TypePolicy.NO_RIGHT,
	"validate-flag": 	TypePolicy.UNIQUE,
	"get-hint": 		TypePolicy.NO_RIGHT,
	"cancle-task": 		TypePolicy.NO_RIGHT,
}

const QUEUE_CAPACITY: int = 15

var _message_queue: Array[Dictionary] = []



func queue_message(msg: Dictionary) -> void:
	match TYPE_POLICIES[msg.get("type")]:
		TypePolicy.FULL_RIGHT:
			_queue_full_right(msg)
		TypePolicy.UNIQUE:
			_queue_unique(msg)
		_:
			pass



func flush_next() -> Dictionary:
	return _message_queue.pop_at(0)



func _queue_unique(msg: Dictionary) -> void:
	for queued_msg in _message_queue:
		if queued_msg.get("type") == msg.get("type"):
			_message_queue.erase(queued_msg)
	_message_queue.append(msg)



func _queue_full_right(msg: Dictionary) -> void:
	_message_queue.append(msg)
