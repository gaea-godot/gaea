@tool
class_name GaeaNodeFalloffMap
extends GaeaNodeResource
## Returns a grid that goes from higher values in the center to lower in the borders.
## Rate can be adjusted with [param start] and [param end].
##
## For lower [param start] values, the transition will be smoother.[br]
## For lower [param end] values, the generated 'square' will be smaller.[br]
## Multiplying this with a [GaeaNodeSimplexSmooth]'s generation can create island-looking terrains.

enum FalloffArea {
	## The area encompassed by a given generation task. Often means the space a given chunk takes up.
	ChunkArea,
	## The world area defined in the generation settings.
	WorldArea,
	## A custom area defined by position and size arguments.
	CustomArea,
}

enum FalloffShape {
	SQUARE,
	ROUNDED_SQUARE,
	CIRCLE,
	SQUIRCLE,
}

@abstract
class FalloffSampler:
	var area: AABB
	var start: float
	var end: float
	var pos: Vector3
	var center: Vector3
	var radii: Vector3
	#var pos_x: float
	#var pos_y: float
	#var pos_z: float
	#var size_x: float
	#var size_y: float
	#var size_z: float
	#var size_x_is_smaller: bool
	#var size_y_is_smaller: bool
	#var size_z_is_smaller: bool
	#var size_x_adjusted: float
	#var size_y_adjusted: float
	#var size_z_adjusted: float
	#var size_x_half: float
	#var size_y_half: float
	#var size_z_half: float
	#var size_y_minus_x_half: float
	#var size_x_minus_y_half: float
	#var size_z_minus_z_half: float

	func _init(_area: AABB, _start: float, _end: float):

		area = _area
		start = _start
		end = _end
		pos = area.position
		center = area.get_center()
		radii = area.size / 2

		#pos_x = area.position.x
		#pos_y = area.position.y
		#pos_z = area.position.z
		#size_x = area.size.x
		#size_y = area.size.y
		#size_z = area.size.z
		#var ratio: float = 1.0
		#size_x_is_smaller = size_x <= size_y
		#if not size_x_is_smaller:
			#ratio = float(size_y) / float(size_x)
		#size_y_is_smaller = size_y <= size_x
		#if not size_y_is_smaller:
			#ratio = float(size_x) / float(size_y)
		#size_x_adjusted = size_x * ratio
		#size_y_adjusted = size_y * ratio
		#size_z_adjusted = size_z * ratio
		#size_x_half = size_x * 0.5
		#size_y_half = size_y * 0.5
		#size_z_half = size_z * 0.5
		#size_x_minus_y_half = size_x - size_y_half
		#size_y_minus_x_half = size_y - size_x_half
		_on_init()

	func _on_init():
		pass

	func normalize(vector:Vector3) -> Vector3:
		# vector relative to the center, normalized based on radii
		return (vector - center) / radii

	#func normalize_x(x: float) -> float:
		#x -= pos_x
		#if size_x_is_smaller:
			#return remap(x, 0, size_x - 1.0, -1.0, 1.0)
		#if x < size_y_half:
			#return remap(x, 0, size_x_adjusted - 1.0, -1.0, 1.0)
		#if x > size_x_minus_y_half:
			#return remap(size_x - x, 1.0, size_x_adjusted, -1.0, 1.0)
		#return 0
#
	#func normalize_y(y: float) -> float:
		#y -= pos_y
		#if size_y_is_smaller:
			#return remap(y, 0, size_y - 1.0, -1.0, 1.0)
		#if y < size_x_half:
			#return remap(y, 0, size_y_adjusted - 1.0, -1.0, 1.0)
		#if y > size_y_minus_x_half:
			#return remap(size_y - y, 1.0, size_y_adjusted, -1.0, 1.0)
		#return 0

	func sample(vector: Vector3) -> float:
		var value: float = clampf(_get_sample(vector), 0.0, 1.0)

		var range_clamped: float = clampf(value, start if start < end else end, end if end > start else start)

		match range_clamped:
			start: return 1.0
			end: return 0.0
			_: return smoothstep(1.0, 0.0, inverse_lerp(start, end, value))

	@abstract
	func _get_sample(_vector:Vector3) -> float


class FalloffSamplerSquare:
	extends FalloffSampler

	func _get_sample(vector:Vector3) -> float:
		var absolute_normal := normalize(vector).abs()
		return maxf(maxf(absolute_normal.x, absolute_normal.y), absolute_normal.z)

		# Original 2D Calculation
		#return maxf(absf(normalize_x(vector.x)), absf(normalize_y(vector.y)))


class FalloffSamplerRoundedSquare:
	extends FalloffSampler

	func _get_sample(vector:Vector3) -> float:
		var normalized := normalize(vector)
		return sqrt(normalized.x ** 4 + normalized.y ** 4 + normalized.z ** 4)

		# Original 2D Calculation
		#sqrt(normalize_x(vector.x) ** 4 + (normalize_y(vector.y)) ** 4)


class FalloffSamplerCircle:
	extends FalloffSampler
	var one_on_sqrt_two: float

	func _on_init():
		one_on_sqrt_two = 1.0 / sqrt(2.0)

	func _get_sample(vector: Vector3) -> float:
		return min(1.0, normalize(vector).length())

		# Original 2D Calculation
		#min(1.0, (normalize_x(x) ** 2 + normalize_y(y) ** 2) * one_on_sqrt_two)


class FalloffSamplerSquircle:
	extends FalloffSampler

	func _get_sample(vector: Vector3) -> float:
		var normalized = normalize(vector)
		return 1.0 - ((1.0 - (normalized.x ** 2)) * (1.0 - (normalized.y ** 2)) * (1.0 - (normalized.z ** 2)))

		# Original 2D Calculation
		#return 1.0 - (1.0 - normalize_x(vector.x) ** 2) * (1.0 - normalize_y(vector.y) ** 2)


func _get_title() -> String:
	return "FalloffMap"


func _get_description() -> String:
	return """Returns a grid that goes from higher values in the center to lower in the borders.
Rate can be adjusted with [param start] and [param end]."""


func _get_enums_count() -> int:
	return 2


func _get_enum_options(idx: int) -> Dictionary:
	match idx:
		0: return FalloffArea
		1, _: return FalloffShape


func _on_enum_value_changed(enum_idx: int, _option_value: int) -> void:
	match enum_idx:
		0: notify_argument_list_changed()


func _get_arguments_list() -> Array[StringName]:
	match get_enum_selection(0): # Faloff Area
		FalloffArea.CustomArea: return [&"position", &"size", &"start", &"end"]
		_: return [&"start", &"end"]


func _get_argument_type(arg_name: StringName) -> GaeaValue.Type:
	match arg_name:
		&"position", &"size": return GaeaValue.Type.VECTOR3
		&"start", &"end", _: return GaeaValue.Type.FLOAT


func _get_argument_default_value(arg_name: StringName) -> Variant:
	match arg_name:
		&"position": return Vector3.ZERO
		&"area": return Vector3.ONE
		&"start": return 0.5
		&"end": return 1.0
	return super(arg_name)


func _get_output_ports_list() -> Array[StringName]:
	return [&"falloff"]


func _get_output_port_type(_output_name: StringName) -> GaeaValue.Type:
	return GaeaValue.Type.SAMPLE


func _get_data(_output_port: StringName, pouch: GaeaGenerationPouch) -> GaeaValue.Sample:
	var start: float = _get_arg(&"start", pouch) as float
	var end: float = _get_arg(&"end", pouch) as float
	var result: GaeaValue.Sample = GaeaValue.Sample.new()

	var area: AABB
	match get_enum_selection(0): # Falloff Area
		FalloffArea.ChunkArea:
			area = pouch.area
		FalloffArea.WorldArea:
			area = AABB(Vector3.ZERO, pouch.settings.world_size)
		FalloffArea.CustomArea:
			var position: Vector3 = _get_arg(&"position", pouch)
			var size: Vector3 = _get_arg(&"size", pouch)
			area = AABB(position, size)

	prints("area:", area, "( FaloffArea:", get_enum_selection(0), ")")

	var sampler: FalloffSampler
	match get_enum_selection(1): # Falloff Shape
		FalloffShape.SQUARE:
			sampler = FalloffSamplerSquare.new(area, start, end)
		FalloffShape.ROUNDED_SQUARE:
			sampler = FalloffSamplerRoundedSquare.new(area, start, end)
		FalloffShape.CIRCLE:
			sampler = FalloffSamplerCircle.new(area, start, end)
		FalloffShape.SQUIRCLE:
			sampler = FalloffSamplerSquircle.new(area, start, end)

	for x in _get_axis_range(Vector3i.AXIS_X, area):
		for y in _get_axis_range(Vector3i.AXIS_Y, area):
			for z in _get_axis_range(Vector3i.AXIS_Z, area):
				result.set_xyz(x, y, z, sampler.sample(Vector3i(x, y, z)))
	return result
