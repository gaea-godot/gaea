@tool
class_name GaeaNodeVoronoi
extends GaeaNodeResource
## Fills the grid with [param value].


func _get_title() -> String:
	return "Voronoi"


func _get_description() -> String:
	return "Constructs a Voronoi diagram."


func _get_arguments_list() -> Array[StringName]:
	return [&"frequency"]


func _get_argument_type(_arg_name: StringName) -> GaeaValue.Type:
	return GaeaValue.Type.FLOAT


func _get_argument_hint(_arg_name: StringName) -> Dictionary[String, Variant]:
	return {&"max": 1, &"min": 0.0001}


func _get_argument_default_value(_arg_name: StringName) -> Variant:
	return 0.04


func _get_output_ports_list() -> Array[StringName]:
	return [&"result"]


func _get_output_port_type(_output_name: StringName) -> GaeaValue.Type:
	return GaeaValue.Type.SAMPLE


func _get_data(_output_port: StringName, pouch: GaeaGenerationPouch) -> GaeaValue.Sample:
	var noise: FastNoiseLite = FastNoiseLite.new()
	noise.seed = pouch.settings.seed + salt
	noise.noise_type = FastNoiseLite.TYPE_CELLULAR
	noise.frequency = _get_arg(&"frequency", pouch)
	noise.cellular_distance_function = FastNoiseLite.DISTANCE_EUCLIDEAN_SQUARED
	noise.fractal_type = FastNoiseLite.FRACTAL_NONE
	noise.cellular_return_type = FastNoiseLite.RETURN_CELL_VALUE

	var result := GaeaValue.Sample.new()
	for x in _get_axis_range(Vector3i.AXIS_X, pouch.area):
		for y in _get_axis_range(Vector3i.AXIS_Y, pouch.area):
			for z in _get_axis_range(Vector3i.AXIS_Z, pouch.area):
				result.set_xyz(x, y, z, (noise.get_noise_3d(x, y, z) + 1.0) * 0.5)
	return result
