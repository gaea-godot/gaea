@tool
extends GaeaCurve
class_name GaeaMathCurve

@export var curve: Curve
@export var y_default: float = 0
@export var z_default: float = 0


func _sample(offset: float) -> float:
	return curve.sample(offset)


func _sample_2d(_idx: int, t: float) -> Vector2:
	var result = curve.sample(t)
	return Vector2(result, y_default)


func _sample_3d(_idx: int, t: float) -> Vector3:
	var result = curve.sample(t)
	return Vector3(result, y_default, z_default)
