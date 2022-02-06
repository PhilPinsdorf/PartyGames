extends Control

onready var create_server_button = $Background/Multiplayer_configure/Create_server
onready var server_created_lable = $Background/Multiplayer_configure/Server_created
onready var room_code_lable = $Background/Multiplayer_configure/Room_code
onready var start_game_button = $Background/Multiplayer_configure/Start_game

func _ready():
	create_server_button.show()
	server_created_lable.hide()
	room_code_lable.hide()
	start_game_button.hide()

func _on_Create_server_pressed():
	create_server_button.hide()
	server_created_lable.show()
	room_code_lable.show()
	start_game_button.show()
	Network.create_server()
	Network.room_lable = room_code_lable
	


func _on_Start_game_pressed():
	print("Started Game!")
