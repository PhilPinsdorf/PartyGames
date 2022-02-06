extends Node

const DEFAULT_PORT = 28960
const MAX_CLIENTS = 6

signal client_connected
signal received_packet

var _http_request = HTTPRequest.new()

var _server = WebSocketServer.new()
var ip_address = ""
var room_lable

func _ready() -> void:
	add_child(_http_request)
	
	for ip in IP.get_local_addresses():
		if ip.begins_with("192.168.") and not ip.ends_with(".1"):
			ip_address = ip
	
	# Connect Methods
	_server.connect("client_connected", self, "_connected")
	_server.connect("client_disconnected", self, "_disconnected")
	_server.connect("client_close_request", self, "_close_request")
	_server.connect("data_received", self, "_on_data")
	_http_request.connect("request_completed", self, "_on_room_code_created")
	
	# var upnp = UPNP.new()
	# upnp.discover(2000, 2, "InternetGatewayDevice")
	# print(upnp.query_external_address())
	
	create_server()
	

func create_server():
	# Start listening on the given port.
	var server_callback = _server.listen(DEFAULT_PORT)
	if server_callback == OK:
		print("Started Websocket Server!")
	else:
		print("Unable to start Websocket Server!")
		set_process(false)
		
	# request_room_code()

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
	
func request_room_code():
	var uri_ip = ip_address.percent_encode()
	_http_request.request("http://localhost:3000/createroom?ip=" + uri_ip)

func _on_room_code_created(result, response_code, headers, body):
	var response = parse_json(body.get_string_from_utf8())
	print(response.code)
	get_tree().get_root().get_node("/root/Network_setup/Background/Multiplayer_configure/Room_code").set_text("Room Code: " + str(response.code))

func _process(delta):
	_server.poll()
