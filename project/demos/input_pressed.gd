extends RefCounted

class_name InputPressed

var action:String = ""
var pressed:bool = false
var pressed_dir:Vector2 = Vector2.ZERO

func _init(_action:String, _pressed_dir:Vector2) -> void:
	action = _action
	pressed_dir = _pressed_dir

func handle(event:InputEvent):
	if event.is_action_pressed(action):
		pressed = true
	elif event.is_action_released(action):
		pressed = false

func dir() -> Vector2:
	return pressed_dir if pressed else Vector2.ZERO
