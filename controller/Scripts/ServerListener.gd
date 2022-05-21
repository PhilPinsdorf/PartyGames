extends Node

var server_cleanup_threshold = 3
var socket_udp: PacketPeerUDP
var listen_port = Network.DEFAULT_PORT
var known_server = {}

func _ready():
	$CleanupThreshold.wait_time = server_cleanup_threshold
	Network.known_servers.clear()
	start_listener()
	pass

func start_listener():
	$CleanupThreshold.start()
	socket_udp = PacketPeerUDP.new()
	if socket_udp.listen(listen_port) != OK:
		print("Server sniffing failed")
	else:
		print("Server sniffing started")
	pass

func _process(delta):
	print(socket_udp.get_packet().get_string_from_ascii())
	"""
	print(socket_udp.get_available_packet_count())
	if socket_udp.get_available_packet_count() > 0:
		var server_ip = socket_udp.get_packet_ip()
		var array_bytes = socket_udp.get_packet()
		var server_message = array_bytes.get_string_from_ascii()
		print(server_message, server_ip)
		var game_info = parse_json(server_message)
		var last_seen = OS.get_unix_time()
		var server = {'ip': server_ip, 'name': game_info.name, 'count': game_info.player_count, 'last_seen': last_seen}
		known_server[server_ip] = server
	"""

func _cleanup_threshold():
	var now = OS.get_unix_time()
	for server_ip in known_server:
		var server_info = known_server[server_ip]
		if (now - server_info.last_seen) > server_cleanup_threshold:
			known_server.erase(server_ip)
	pass 
