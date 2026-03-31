@tool
class_name GaeaCurveScalar
extends GaeaCurve
## A [GaeaCurve] wrapper for Godot's builtin [Curve] class.

## The [Curve] to use for sampling.
@export var curve: Curve
## Default value when populating [method GaeaCurve.sample_2d] and [method GaeaCurve.sample_3d] results.
@export var y_default: float = 0
## Default value when populating [method GaeaCurve.sample_3d] results.
@export var z_default: float = 0


func _sample(offset: float) -> float:
	return curve.sample(offset)


func _sample_2d(_idx: int, t: float) -> Vector2:
	var result = curve.sample(t)
	return Vector2(result, y_default)


func _sample_3d(_idx: int, t: float) -> Vector3:
	var result = curve.sample(t)
	return Vector3(result, y_default, z_default)
