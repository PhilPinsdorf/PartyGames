extends Control

onready var username = $Background/Username/UserNameEdit
var server_entry = load("res://Scenes/ServerEntry.tscn")

func _ready():
	pass

func _on_JoinButton_pressed():
	if username.text != "":
		PacketManager.send_packet(100)
		PacketManager.username = username.text
	pass 


func _refresh_server_list():
	for child in $Background/ServerSelector/ScrollContainer/VBoxContainer.get_children():
		child.queue_free()
	
	"""
	for ip in $ServerListener.known_server:
		var node = Global.instance_node(server_entry, $Background/ServerSelector/ScrollContainer/VBoxContainer)
		node.server_ip = ip
		node.get_node("ServerName").text = $ServerListener.known_server[ip].name
		node.get_node("PlayerCount").text = str($ServerListener.known_server[ip].count) + "/4"
		node.get_node("JoinButton").connect("pressed", self, "_join_server")
	"""
	pass

func _join_server():
	# #var ip = node.server_ip
	# #Network.server = Network.known_servers[]
	pass
