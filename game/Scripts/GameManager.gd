extends Node

enum GameState {LOBBY, INGAME, ENDED}
enum ControlerType {RACING = PacketManager.Packet.CHANGE_TO_DRIVING, REFLEX = PacketManager.Packet.CHANGE_TO_REFLEX}

const games_to_play = 2

var car_module = GameModule.new("Racing", "res://Scenes/Games/Racing/Racing.tscn", ControlerType.RACING)
var reflex_circle_module = GameModule.new("Reflex Circle", "res://Scenes/Games/ReflexCircle/ReflexCircle.tscn", ControlerType.REFLEX)
var evaluate_time_module = GameModule.new("Evaluate Time", "res://Scenes/Games/Timer/EvaluateTime.tscn", ControlerType.REFLEX)

var scores = {}
var all_games = [evaluate_time_module, car_module]
var game_queue = []

func _ready():
	pass
	
func start_ingame_state():
	for id in PlayerManager.user_ids:
		scores[str(id)] = 0
	
	choose_games(games_to_play)
	
	start_next_game()
	pass

func start_next_game():
	# Change Scene
	get_tree().change_scene(game_queue[0].get_scene())
	
	# Update Controller on Client Side
	for id in PlayerManager.user_ids:
		PacketManager.send_packet(id, game_queue[0].get_controler_type())
	
	game_queue.remove(0)
	pass

func finish_game(winner):
	scores[winner] += 1
	
	yield(get_tree().create_timer(3.0), "timeout")
	
	get_tree().change_scene("res://Scenes/UI/Leaderboard.tscn")
	
	yield(get_tree().create_timer(5.0), "timeout")
	
	if game_queue.size() > 0:
		start_next_game()
	else:
		get_tree().quit(0)
	pass

func choose_game():
	all_games.shuffle()
	game_queue.append(all_games[0])
	all_games.remove(0)

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
