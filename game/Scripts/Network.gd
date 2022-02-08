extends Node

# Signals
signal client_connected
signal received_packet

# Constants
const DEFAULT_PORT = 28960
const MAX_CLIENTS = 6

# Variables
var _server = WebSocketServer.new()

func _ready() -> void:
	# Connect Methods
	_server.connect("client_connected", self, "_connected")
	_server.connect("client_disconnected", self, "_disconnected")
	_server.connect("client_close_request", self, "_close_request")
	_server.connect("data_received", self, "_on_data")

func create_server():
	# Start listening on the given port.
	if _server.listen(DEFAULT_PORT) == OK:
		print("Started Websocket Server!")
	else:
		print("Unable to start Websocket Server!")
		set_process(false)

func _connected(id, proto):
	print("Client %d connected!" % id)
	emit_signal("client_connected", id)

func _close_request(id, code, reason):
	print("Client %d disconnecting with code: %d, reason: %s" % [id, code, reason])

func _disconnected(id, was_clean = false):
	print("Client %d disconnected, clean: %s" % [id, str(was_clean)])

func _on_data(id):
	var pkt = _server.get_peer(id).get_packet()
	print("Received Packet %s for id=%10d" % [pkt.get_string_from_utf8(), id])
	emit_signal("received_packet", id, pkt.get_string_from_utf8())

func send_packet(id, content):
	_server.get_peer(id).put_packet(content.to_utf8())

func _process(delta):
	_server.poll()
