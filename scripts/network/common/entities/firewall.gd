extends Resource
class_name Firewall

enum Policy {BLOCK_ALL, WHITE_LIST, BLACK_LIST, OPEN}
var current_policy: Policy = Policy.OPEN

var specified_ips: Array[String]


func audit_datapackage(datapacket: DataPacket) -> bool:
	if current_policy == Policy.BLOCK_ALL or ip_is_blacklisted(datapacket.get_sender_ip()):
		return false
	return true


func ip_is_blacklisted(ip: String) -> bool:
	return (current_policy == Policy.BLACK_LIST) and specified_ips.has(ip)


func ip_is_whitelisted(ip: String) -> bool:
	return (current_policy == Policy.WHITE_LIST) and specified_ips.has(ip)
