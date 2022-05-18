extends Node2D

var rng = RandomNumberGenerator.new()
var current_attack: int
var directions = [-1, 1]
onready var tween = get_node("Tween")

const lowest_waiting_time = 0.5
const highest_waiting_time = 3.0
const highest_attack_index = 2

func _ready():
	rng.randomize()
	start_new_attack()
	pass

func start_new_attack():
	var wait = rng.randf_range(lowest_waiting_time, highest_waiting_time)
	yield(get_tree().create_timer(wait), "timeout")
	
	current_attack = rng.randi_range(0, highest_attack_index)
	
	var attack_node = $Attacks.get_child(current_attack)
	var collider_node = attack_node.get_node("Collider")
	
	match current_attack:
		0:
			# Semi Circle Attack
			# Rotate to start Position
			var amount = rng.randi_range(90, 270)
			var direction = rng.randi_range(0, 1)
			var final_rotation = rotation + deg2rad((amount * directions[direction]))
			tween.playback_speed = 1
			tween.interpolate_property(self, "rotation", rotation, final_rotation, 1, Tween.TRANS_QUART, Tween.EASE_IN_OUT)
			tween.start()
			yield(tween, "tween_completed")
			
			attack_node.visible = true
			yield(get_tree().create_timer(1.5), "timeout")
			attack_node.modulate = Color("#ff0000")
			collider_node.monitoring = true
			
			yield(get_tree().create_timer(2), "timeout")
			
			collider_node.monitoring = false
			attack_node.modulate = Color("#ffffff")
			attack_node.visible = false
		1:
			var direction = rng.randi_range(0, 1)
			var warning_rotation = rotation + deg2rad((45 * directions[direction]))
			var final_rotation = rotation + deg2rad((180 * directions[direction]))
			
			attack_node.visible = true
			
			tween.playback_speed = 0.3
			tween.interpolate_property(self, "rotation", rotation, final_rotation, 1,Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
			tween.start()
			
			yield(get_tree().create_timer(1.5), "timeout")
			
			attack_node.modulate = Color("#ff0000")
			collider_node.monitoring = true
			
			yield(tween, "tween_completed")
			
			collider_node.monitoring = false
			attack_node.modulate = Color("#ffffff")
			attack_node.visible = false
		2:
			tween.playback_speed = 1
			tween.interpolate_property(self, "rotation", rotation, 0, 1,Tween.TRANS_SINE, Tween.EASE_IN_OUT)
			tween.start()
			
			yield(tween, "tween_completed")
			
			attack_node.visible = true
			for i in 3:
				for player in get_parent().get_node("Player").get_children():
					var player_position = player.global_position
					var direction = player_position - global_position
					var normalized_direction = direction.normalized()
					var pos0 = 100 * normalized_direction
					var pos1 = 450 * normalized_direction
					
					var line = Line2D.new()
					attack_node.get_node("Lines").add_child(line)
					line.points = [pos0, pos1]
					line.default_color = Color(1, 1, 1, 0.5)
					
					var collider = CollisionShape2D.new()
					attack_node.get_node("Collider").add_child(collider)
					var rectangle = RectangleShape2D.new()
					rectangle.extents = Vector2(5, 175)
					collider.shape = rectangle
					collider.position = 275 * normalized_direction
					var angle = Vector2(0, -1).angle_to(normalized_direction)
					collider.rotation = angle
				yield(get_tree().create_timer(1.5), "timeout")
			
			attack_node.modulate = Color("#ff0000")
			collider_node.monitoring = true
			
			yield(get_tree().create_timer(1.5), "timeout")
			
			collider_node.monitoring = false
			attack_node.modulate = Color("#ffffff")
			attack_node.visible = false
			
			for child in attack_node.get_node("Lines").get_children():
				child.queue_free()
			
			for child in attack_node.get_node("Collider").get_children():
				child.queue_free()
	start_new_attack()
	pass
