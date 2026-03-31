@tool
extends GaeaCurve
class_name GaeaCurve2D

enum AggregationMethod
{
	X, Y, Z,
	AVERAGE,
}

@export var curve: Curve2D
@export var scalar_aggregation: AggregationMethod = AggregationMethod.X
@export var z_default: float = 0


func _sample(offset: float) -> float:
	var result = curve.sample(0, offset)
	match scalar_aggregation:
		AggregationMethod.X: return result.x
		AggregationMethod.Y: return result.y
		AggregationMethod.Z: return z_default
		AggregationMethod.AVERAGE, _: return (result.x + result.y)/2


func _sample_2d(idx: int, t: float) -> Vector2:
	return curve.sample(idx, t)


func _sample_3d(idx: int, t: float) -> Vector3:
	var result = curve.sample(idx, t)
	return Vector3(result.x, result.y, z_default)
