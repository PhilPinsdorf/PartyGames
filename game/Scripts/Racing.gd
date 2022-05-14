extends Node2D

var positions = []
var reached_checkpoints = {}
var finished_laps = {}
var blacklist = ["OuterBorder", "InnerBorder", "InnerCollider", "OuterCollider"]

func _ready():
	Network.connect("client_connected", self, "_on_new_client")
	$Countdown/Control/Text.connect("timer_finished", self, "_on_timer_finished")
	
	var rng = RandomNumberGenerator.new()
	rng.randomize()
	var n = rng.randi_range(0, 4)
	var track = load("res://Scenes/Games/Racing/Maps/Map{n}.tscn".format({"n": n}))
	Global.instance_node_at_loc(track, $Background, Vector2(960, 540))
	
	positions = $Background/Map/SpawnPositions.get_children()
	
	var car = preload("res://Scenes/Games/Racing/Car.tscn")
	for id in PlayerManager.user_ids:
		# Spawn player
		var pos = positions[0].global_position
		var rot = positions[0].global_rotation
		var spot = PlayerManager.id_spot_assignment[id]
		Global.instance_node_at_loc_rot_name_color(car, $Cars, pos, rot, str(id), spot)
		positions.remove(0)
	
	$Background/Map/Checkpoints/checkpoint0.connect("body_shape_exited", self, "_reached_checkpoint", [0])
	$Background/Map/Checkpoints/checkpoint1.connect("body_shape_exited", self, "_reached_checkpoint", [1])
	$Background/Map/Checkpoints/checkpoint2.connect("body_shape_exited", self, "_reached_checkpoint", [2])
	$Background/Map/Checkpoints/checkpoint3.connect("body_shape_exited", self, "_reached_checkpoint", [3])
	
	for id in PlayerManager.user_ids:
		reached_checkpoints[str(id)] = -1
		finished_laps[str(id)] = 0


func _reached_checkpoint(body_rid, body, body_shape_index, local_shape_index, cpid):
	var id = str(body.name)
	
	if blacklist.has(id): return
	
	if cpid != (reached_checkpoints[id] + 1): return
	reached_checkpoints[id] = cpid
	print("Car " + str(id) + " reached checkpoint " + str(cpid) + "!")
		
	if cpid == 3:
		finished_laps[id] += 1
		reached_checkpoints[id] = -1
		print("Finished Lap!")
		
	if finished_laps[id] == 1:
		for car in $Cars.get_children():
			car.started = false
		GameManager.finish_game(id)
		print(str(id) + " has finished the game!")


func _on_timer_finished():
	for car in $Cars.get_children():
		car.started = true
