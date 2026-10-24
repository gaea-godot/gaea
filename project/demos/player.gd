extends Sprite2D

@export_range(0, 100) var speed = 50.0
var inputs:Array[InputPressed] = [
	InputPressed.new("move_right", Vector2.RIGHT), InputPressed.new("move_left", Vector2.LEFT),
	InputPressed.new("move_up", Vector2.UP), InputPressed.new("move_down", Vector2.DOWN)
]
var direction:Vector2 = Vector2.ZERO

func _unhandled_input(event: InputEvent) -> void:
	direction = Vector2.ZERO
	for input in inputs:
		input.handle(event)
		direction += input.dir()
	direction = direction.normalized()

func pressed(event: InputEvent, action: String):
	return event.is_action_pressed(action)

func released(event: InputEvent, action: String):
	return event.is_action_released(action)

func _physics_process(delta: float) -> void:
	position += direction * speed * delta
