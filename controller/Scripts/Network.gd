extends Node

signal received_packet

const DEFAULT_PORT = 28960

# The URL we will connect to
export var websocket_url = "ws://192.168.178.108:28960"

# Our WebSocketClient instance
var _client: WebSocketClient
var known_servers = {}
var server = {}

func _ready():
	set_process(false)
	connect_to_server()
	pass

func connect_to_server():
	_client = WebSocketClient.new()
	_client.connect("connection_closed", self, "_closed")
	_client.connect("connection_error", self, "_closed")
	_client.connect("connection_established", self, "_connected")
	_client.connect("data_received", self, "_on_data")
	set_process(true)

	# Initiate connection to the given URL.
	var err = _client.connect_to_url(websocket_url)
	if err != OK:
		print("Unable to connect")
		set_process(false)
	pass

func _closed(was_clean = false):
	print("Closed, clean: ", was_clean)
	set_process(false)

func _connected(proto = ""):
	print("Connected with protocol: ", proto)

func send_packet(var packet):
	_client.get_peer(1).put_packet(packet.to_utf8())
	
func _on_data():
	var pkt = _client.get_peer(1).get_packet()
	print("Received Packet %s from Server" % pkt.get_string_from_utf8())
	emit_signal("received_packet", pkt.get_string_from_utf8())

func _process(delta):
	_client.poll()
