extends Control

var name_lables = []

onready var start_server_parent = $Background/StartServer
onready var server_started_parent = $Background/ServerStarted
onready var server_name_edit = $Background/StartServer/ServerName
onready var server_created_lable = $Background/ServerStarted/ServerCreated
onready var start_game_button = $Background/ServerStarted/StartGame

func _ready():
	PacketManager.connect("update_lobby", self, "_update_lobby")
	Network.connect("update_lobby", self, "_update_lobby")
	
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
	GameManager.start_next_game()
	
func _update_lobby():
	print("Should Update")
	
	for nl in name_lables:
		nl.text = ""
		
	for id in PlayerManager.user_ids:
		var spot = PlayerManager.id_spot_assignment[id]
		var username = PlayerManager.id_user_assignment[id]
		name_lables[spot].text = username
		
	if PlayerManager.user_count() >= PlayerManager.MIN_START_PLAYERS:
		start_game_button.disabled = false
