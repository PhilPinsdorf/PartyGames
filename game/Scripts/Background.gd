extends Panel

const key_color_h_values := [0, .1, .15, .175, .2, .25, .3, .4, .5, .55, .6,
								.65, .675, .7, .725, .75, .8, .825, .85, .9, 1.0]

var shifted_color: Color
var color_shifting_enabled := true
var h_value_index: int = 0
var shift_duration: float = 0.25
var speed_multiplier := 1.0
var ColorTween: Tween = null


func create_ColorTween() -> void:
	var __ColorTween := Tween.new()
	__ColorTween.name = "ColorTween"
	add_child(__ColorTween)
	__ColorTween.owner = self
	ColorTween = __ColorTween


func shift_color(__h: float) -> void:
	shifted_color = shifted_color.from_hsv(__h * speed_multiplier, 1.0, 1.0)
	self_modulate = shifted_color


func shift_through_all_colors() -> void:
	var __start_h: float = key_color_h_values[h_value_index]
	var __end_h: float = key_color_h_values[h_value_index + 1]

	var __ = ColorTween.interpolate_method(self, "shift_color", __start_h, __end_h, shift_duration)
	__ = ColorTween.start()
	yield(ColorTween, "tween_all_completed")

	h_value_index = wrapi(h_value_index + 1, 0, key_color_h_values.size() - 1)

	if color_shifting_enabled:
		shift_through_all_colors()


func _ready():
	create_ColorTween()
	self_modulate = Color.red
	yield(get_tree().create_timer(.7), "timeout") # not required
	shift_through_all_colors()
