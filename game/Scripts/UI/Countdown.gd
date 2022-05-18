extends Label

signal timer_finished

var sec = 5
var screen_text = "5"

func _ready():
	set_text(screen_text)
	pass

func _on_Timer_timeout():
	sec -= 1;
	screen_text = str(sec)
	
	if (sec == 0):
		screen_text = "Go!"
	
	if (sec == -1):
		visible = false
		emit_signal("timer_finished")
		$Timer.queue_free()
	
	set_text(screen_text)
	pass
