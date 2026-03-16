extends Node
class_name FlagManager

# Sett denne én gang per run/spiller/save
var seed: int = 0

# Valgfritt: prefix-format
@export var prefix: String = "flag{"
@export var suffix: String = "}"

func set_seed(new_seed: int) -> void:
	seed = new_seed

# Deterministisk "random" fra seed + level_id + key
# key kan være f.eks. filsti, "steg_bunny_1", tag-navn osv.
func get_flag(level_id: String, key: String = "") -> String:
	var token := _token(level_id, key)
	return "%s%s%s" % [prefix, token, suffix]

# Hvis dere vil verifisere flagg-innsending
func validate(submitted: String, level_id: String, key: String = "") -> bool:
	return submitted == get_flag(level_id, key)

# ---- Intern: bygger en stabil token ----
func _token(level_id: String, key: String) -> String:
	# Kombiner til én streng
	var s := "%d|%s|%s" % [seed, level_id, key]

	# Hash til en kort token (stabil, men ikke "krypto-sikker" hvis seed er kjent)
	# Du kan bytte til SHA256 hvis dere vil.
	var h := s.hash() # 32-bit int
	if h < 0:
		h = -h

	# Gjør den litt lengre/penere (base36-ish)
	return _to_base36(h).pad_zeros(10)

func _to_base36(n: int) -> String:
	var chars := "0123456789abcdefghijklmnopqrstuvwxyz"
	if n == 0:
		return "0"
	var out := ""
	var x := n
	while x > 0:
		out = chars[x % 36] + out
		x /= 36
	return out
