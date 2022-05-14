extends Node

enum GameState {LOBBY, INGAME, ENDED}
enum ControlerType {RACING = PacketManager.Packet.CHANGE_TO_DRIVING, REFLEX = PacketManager.Packet.CHANGE_TO_REFLEX}

var car_module = GameModule.new("Racing", "res://Scenes/Racing/Racing.tscn", ControlerType.RACING)

var scores = {}
var all_games = [car_module]
var game_queue = []

func _ready():
	pass

func start_next_game():
	choose_games(1)
	
	# Change Scene
	get_tree().change_scene(game_queue[0].get_scene())
	
	# Update Controller on Client Side
	for id in PlayerManager.user_ids:
		PacketManager.send_packet(id, game_queue[0].get_controler_type())
	pass

func finish_game():
	pass

func choose_game():
	var rand_module = randi() % all_games.size()
	game_queue.append(all_games[rand_module])
	all_games.remove(rand_module)

func choose_games(quantity):
	for i in range(quantity):
		choose_game()

class GameModule:
	var title
	var scene
	var controler_type

	func _init(pTitle, pScene, pControler_type):
		title = pTitle
		scene = pScene
		controler_type = pControler_type
		pass

	func get_title():
		return title

	func get_scene():
		return scene

	func get_controler_type():
		return controler_type 
