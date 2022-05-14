extends RigidBody2D

var speed = 5
var direction = 0
var accelerration = Vector2(speed, 0)
var started = false

func _ready():
	PacketManager.connect("driving_button", self, "_on_button_action")
	pass 

func _process(delta):
	pass

func _physics_process(delta):
	if(started):
		apply_central_impulse(accelerration.rotated(rotation))
		apply_torque_impulse(30 * direction)
	pass

func _on_button_action(id, action):
	if(id == int(name)):
		match action:
			0:
				direction = -1
				accelerration = Vector2(3, 0)
			1, 3:
				direction = 0
				accelerration = Vector2(speed, 0)
			2:
				direction = 1
				accelerration = Vector2(3, 0)
	pass
