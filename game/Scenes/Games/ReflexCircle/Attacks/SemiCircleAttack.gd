extends Node2D

var new_rotation = 0

func _ready():
	pass

func start_attack():
	find_rotation()
	
	rotation = deg2rad(new_rotation)
	visible = true
	yield(get_tree().create_timer(2.0), "timeout")
	modulate = Color("#ff0000")
	yield(get_tree().create_timer(5.0), "timeout")
	
	reset_attack()
	pass

func reset_attack():
	visible = false
	modulate = Color("#ffffff")
	rotation = 0
	pass

func find_rotation():
	var rng = RandomNumberGenerator.new()
	rng.randomize()
	var n = rng.randi_range(0, 360)
	new_rotation = n
	pass

func _draw():
	draw_circle_arc_poly(Vector2(0, 0), 450, -100, 100, Color(1, 1, 1, 0.5))
	pass

func draw_circle_arc_poly(center, radius, angle_from, angle_to, color):
	var nb_points = 32
	var points_arc = PoolVector2Array()
	points_arc.push_back(center)
	var colors = PoolColorArray([color])

	for i in range(nb_points + 1):
		var angle_point = deg2rad(angle_from + i * (angle_to - angle_from) / nb_points - 90)
		points_arc.push_back(center + Vector2(cos(angle_point), sin(angle_point)) * radius)
	
	draw_polygon(points_arc, colors)
	get_node("Collider/CollisionPolygon2D").polygon = points_arc
