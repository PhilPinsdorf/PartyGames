extends Node

var broadcast_interval = 1.0
var server_info = {}

var socket_udp: PacketPeerUDP
var broadcast_port = Network.DEFAULT_PORT

func _ready():
	$BroadcastTimer.wait_time = broadcast_interval
	pass

func start_broadcast():
	socket_udp = PacketPeerUDP.new()
	socket_udp.set_broadcast_enabled(true)
	socket_udp.set_dest_address("255.255.255.255", broadcast_port)
	
	$BroadcastTimer.start()
	pass

func stop_broadcast():
	$BroadcastTimer.stop()
	if socket_udp != null:
		socket_udp.close()
	pass

func _broadcast():
	print("NOw!")
	server_info['name'] = Network.server_name
	server_info['player_count'] = PlayerManager.user_count()
	var packet_message = to_json(server_info)
	var packet = packet_message.to_ascii()
	socket_udp.put_packet(packet)
	pass 
