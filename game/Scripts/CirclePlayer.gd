extends Area2D

var d := 0.0
var radius = 400
var speed = 1
var pivot : Vector2
var direction = 1
var sin_start = 0
var cos_start = 0

func _ready():
	PacketManager.connect("button_pressed", self, "_on_button_action")
	
	pivot = get_viewport_rect().size / 2
	
	var x = global_position.x - pivot.x
	var y = global_position.y - pivot.y
	
	if x != 0: sin_start = x / abs(x)
	if y != 0: cos_start = y / abs(y)
	
	pass
	
func _process(delta):
	d += delta * direction
	
	position = Vector2(
		(sin(d * speed + atan2(sin_start, cos_start))) * radius,
		(cos(d * speed + atan2(sin_start, cos_start))) * radius 
	) + pivot

func _on_button_action(id, action):
	if(id == int(name)):
		match action:
			0:
				direction *= -1
	pass
