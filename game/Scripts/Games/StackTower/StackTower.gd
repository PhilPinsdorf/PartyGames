extends Node2D

onready var tween = $Tween
var sway_amount = 250
var going_right = true

var rng = RandomNumberGenerator.new()
var smallBlock = load("res://Scenes/Games/StackTower/Blocks/Small.tscn") 
var lBlock = load("res://Scenes/Games/StackTower/Blocks/L-Shape.tscn") 
var longBlock = load("res://Scenes/Games/StackTower/Blocks/Long.tscn") 
var dust = load("res://Scenes/Particles/Dust.tscn") 
var blocks
var can_drop = {}
var current_block = {}
var current_rotation = {}
var possible_rotations = [0, 90, 180, 270]
var finished_for = {}

func _ready():
	PacketManager.connect("button_pressed", self, "_on_button_action")
	
	blocks = [smallBlock, longBlock, lBlock]
	
	for id in PlayerManager.user_ids:
		can_drop[str(id)] = true
		
		var spot = PlayerManager.id_spot_assignment[str(id)]
		var parent = $Spawner.get_node("pos{n}".format({"n": spot}))
		parent.modulate = PlayerManager.id_color_assignment[str(id)]
		spawn_block(id)
	
	start_tween()
	pass

func start_tween():
	tween.playback_speed = 0.5
	tween.interpolate_property($Spawner, "position:x", $Spawner.position.x, $Spawner.position.x + sway_amount, 1,Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
	tween.start()
	going_right = false
	pass

func choose_block(id):
	rng.randomize()
	var n = rng.randi_range(0, blocks.size() - 1)
	
	current_block[str(id)] = n
	pass

func choose_rotation(id):
	rng.randomize()
	var n = rng.randi_range(0, 3)
	
	current_rotation[str(id)] = possible_rotations[n]
	pass

func spawn_block(id):
	choose_block(id)
	choose_rotation(id)
	
	var spot = PlayerManager.id_spot_assignment[str(id)]
	var parent = $Spawner.get_node("pos{n}".format({"n": spot}))
	var block = blocks[current_block[str(id)]]
		
	var unused_block = Global.instance_node(block, parent)
	unused_block.visible = false
	var sprite = unused_block.get_child(1)
	unused_block.remove_child(sprite)
	parent.add_child(sprite)
	unused_block.queue_free()
	sprite.rotation = deg2rad(current_rotation[str(id)])
	pass

func drop_block(id):
	current_block[str(id)]
	var spot = PlayerManager.id_spot_assignment[str(id)]
	var spawner = $Spawner.get_node("pos{n}".format({"n": spot}))
	
	spawner.get_child(0).queue_free()
	
	var parent = $SpawnedBlocks
	var block = blocks[current_block[str(id)]]
	
	var dropping_block = Global.instance_node(block, parent)
	dropping_block.position = spawner.global_position
	dropping_block.modulate = PlayerManager.id_color_assignment[str(id)]
	dropping_block.rotation = deg2rad(current_rotation[str(id)])
	pass

func _on_Tween_tween_completed(object, key):
	if going_right:
		tween.interpolate_property($Spawner, "position:x", $Spawner.position.x, $Spawner.position.x + sway_amount, 1,Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
		tween.start()
		going_right = false
	else:
		tween.interpolate_property($Spawner, "position:x", $Spawner.position.x, $Spawner.position.x - sway_amount, 1,Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
		tween.start()
		going_right = true
	pass

func _on_button_action(id, action):
	if can_drop[str(id)] == true and action == 0:
		can_drop[str(id)] = false
		
		drop_block(id)
		
		yield(get_tree().create_timer(1.0), "timeout")
		
		spawn_block(id)
		
		can_drop[str(id)] = true
	pass

func _on_destructor_body_entered(body):
	var dust_node = Global.instance_node_at_loc(dust, $Particles, body.position)
	dust_node.emitting = true
	body.queue_free()
	pass


func _on_detection_zone_reached(body, spot):
	yield(get_tree().create_timer(1), "timeout")
	
	var detector_node: Area2D = $Detection.get_node("Detector{n}".format({"n": spot}))
	if detector_node.get_overlapping_bodies().has(body):
		# Still colliding after one second (Most likely to bw finished)
		start_finished_test(body, spot)
	pass
	
func start_finished_test(body, spot):
	var detector_node: Area2D = $Detection.get_node("Detector{n}".format({"n": spot}))
	var text_node: Label = $Countdown.get_node("Text{n}".format({"n": spot}))
	if detector_node.get_overlapping_bodies().has(body):
		if finished_for.has(spot):
			finished_for[spot] -= 1
		else:
			finished_for[spot] = 3
		
		if finished_for[spot] == 0:
			text_node.text = "!"
			GameManager.finish_game(PlayerManager.get_id_from_spot(spot))
		else:
			text_node.text = str(finished_for[spot])
			yield(get_tree().create_timer(1), "timeout")
			start_finished_test(body, spot)
	else:
		text_node.text = ""
		finished_for.erase(spot)
	pass
