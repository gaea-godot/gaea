@tool
extends GaeaCurve
class_name GaeaCurve3D

enum AggregationMethod
{
	X, Y, Z,
	Average,
}

@export var curve: Curve3D
@export var scalar_aggregation: AggregationMethod = AggregationMethod.X
@export var x_aggregation: AggregationMethod = AggregationMethod.X
@export var y_aggregation: AggregationMethod = AggregationMethod.Y


func _sample(offset: float) -> float:
	var result = curve.sample(0, offset)
	return aggregate_scalar(result, scalar_aggregation)


func _sample_2d(idx: int, t: float) -> Vector2:
	var result = curve.sample(idx, t)
	return aggregate_vector2(result, x_aggregation, y_aggregation)


func _sample_3d(idx: int, t: float) -> Vector3:
	return curve.sample(idx, t)


func aggregate_scalar(vector: Vector3, method: AggregationMethod):
	match method:
		AggregationMethod.X: return vector.x
		AggregationMethod.Y: return vector.y
		AggregationMethod.Z: return vector.z
		AggregationMethod.Average, _: return (vector.x + vector.y + vector.z)/3


func aggregate_vector2(vector: Vector3, x_method: AggregationMethod, y_method: AggregationMethod) -> Vector2:
	var x: float = 0
	match x_method:
		AggregationMethod.X: x = vector.x
		AggregationMethod.Y: x = vector.y
		AggregationMethod.Z: x = vector.z
		AggregationMethod.Average: x = (vector.x + vector.z)/2

	var y: float = 0
	match x_method:
		AggregationMethod.X: y = vector.x
		AggregationMethod.Y: y = vector.y
		AggregationMethod.Z: y = vector.z
		AggregationMethod.Average: y = (vector.y + vector.z)/2

	return Vector2(x, y)
