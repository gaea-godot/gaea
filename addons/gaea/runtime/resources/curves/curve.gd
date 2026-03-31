@tool
@icon("../../../assets/types/material.svg")
@abstract
class_name GaeaCurve
extends Resource
## Used to wrap [class Curve], [class Curve2D], and [class Curve3D] for cross-compatibility in [class GaeaGraph]s.
##
## This is an abstract class. On its own, it doesn't do anything,
## but it is extended for the sake of wrapping any given curve class.
## See [GaeaMathCurve], [GaeaCurve2D], and [GaeaCurve3D].
## It can also be used to hold sub-resources to be selected programmatically.
## See [PointwiseRandomGaeaMaterial] for an [GaeaMaterial] exammple of this.

func sample(offset:float) -> float:
	return _sample(offset)

func _sample(_offset:float) -> float:
	return 0

func sample_2d(idx: int, t: float) -> Vector2:
	return _sample_2d(idx, t)

func _sample_2d(_idx: int, _t: float) -> Vector2:
	return Vector2.ZERO

func sample_3d(idx: int, t: float) -> Vector3:
	return _sample_3d(idx, t)

func _sample_3d(_idx: int, _t: float) -> Vector3:
	return Vector3.ZERO
