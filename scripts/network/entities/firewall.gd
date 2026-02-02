extends Resource
class_name Firewall

# Blokkeringsinnstillingene
enum BlockingPolicy {BLOCK_ALL, BLOCK_NONE, WHITE_LIST, BLACK_LIST}
var current_policy := BlockingPolicy.BLOCK_ALL
var blocked_ips: Array[String] = []


# Sjekker om en IP-adresse er blokkert
func is_blocked(ip: String) -> bool:
	if current_policy == BlockingPolicy.BLOCK_NONE:
		return false
	elif current_policy == BlockingPolicy.WHITE_LIST && ip_in_block_list(ip):
		return true
	elif current_policy == BlockingPolicy.BLACK_LIST && not ip_in_block_list(ip):
		return true
	return true

func update_block_policy(policy: BlockingPolicy) -> void:
	current_policy = policy

func add_ip_to_block_list(ip: String) -> void:
	if not blocked_ips.has(ip):
		blocked_ips.append(ip)

func ip_in_block_list(ip: String) -> bool:
	return blocked_ips.has(ip)
