extends Control

var name_lables = []

onready var start_server_parent = $Background/StartServer
onready var server_started_parent = $Background/ServerStarted
onready var server_name_edit = $Background/StartServer/ServerName
onready var server_created_lable = $Background/ServerStarted/ServerCreated
onready var start_game_button = $Background/ServerStarted/StartGame

func _ready():
	PacketManager.connect("user_connected", self, "_user_connected")
	
	server_started_parent.hide()
	$Background/ServerStarted/UsernameBackground/BgRed.self_modulate = Global.colorRed
	$Background/ServerStarted/UsernameBackground/BgBlue.self_modulate = Global.colorBlue
	$Background/ServerStarted/UsernameBackground/BgYellow.self_modulate = Global.colorYellow
	$Background/ServerStarted/UsernameBackground/BgGreen.self_modulate = Global.colorGreen
	
	name_lables.append($Background/ServerStarted/UsernameBackground/BgRed/Name)
	name_lables.append($Background/ServerStarted/UsernameBackground/BgBlue/Name)
	name_lables.append($Background/ServerStarted/UsernameBackground/BgYellow/Name)
	name_lables.append($Background/ServerStarted/UsernameBackground/BgGreen/Name)

func _on_CreateServer_pressed():
	if server_name_edit.text != "":
		start_server_parent.hide()
		server_started_parent.show()
		server_created_lable.text = "Server \"" + server_name_edit.text + "\" Created!"
		start_game_button.disabled = true
		Network.create_server()

func _on_StartGame_pressed():
	get_tree().change_scene("res://Scenes/Racing/Racing.tscn")
	
func _user_connected(username, count):
	name_lables[count].text = username
