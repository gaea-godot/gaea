@tool
class_name GaeaNodeRandomScatter
extends GaeaNodeResource
## Randomly places [param amount] [param material]s in the cells of [param reference].


func _get_title() -> String:
	return "RandomScatter"


func _get_description() -> String:
	return "Randomly places [param amount] [param material]s in the cells of [param reference]."


func _get_arguments_list() -> Array[StringName]:
	return [&"reference", &"material", &"amount"]


func _get_argument_type(arg_name: StringName) -> GaeaValue.ArgType:
	match arg_name:
		&"reference":
			return GaeaValue.ARG_TYPE_SAMPLE
		&"material":
			return GaeaValue.ARG_TYPE_MATERIAL
		&"amount":
			return GaeaValue.ARG_TYPE_INT
	return GaeaValue.ARG_TYPE_NIL


func _get_output_ports_list() -> Array[StringName]:
	return [&"map"]


func _get_output_port_type(_output_name: StringName) -> GaeaValue.ArgType:
	return GaeaValue.ARG_TYPE_MAP


func _get_required_arguments() -> Array[StringName]:
	return [&"reference", &"material"]


func _get_data(_output_port: StringName, pouch: GaeaGenerationPouch) -> GaeaMap:
	var reference_sample: GaeaSample = _get_arg(&"reference", pouch)
	var material: GaeaMaterial = _get_arg(&"material", pouch)

	var result: GaeaMap = GaeaMap.new()
	var cells_to_place_on: Array = reference_sample.get_cells()
	cells_to_place_on.shuffle()
	cells_to_place_on.resize(mini(_get_arg(&"amount", pouch), cells_to_place_on.size()))

	var rng: RandomNumberGenerator = _get_rng(pouch)

	material = material.prepare_sample(rng)
	if not is_instance_valid(material):
		material = _get_arg(&"material", pouch)
		var error := (
			"Recursive limit reached (%d): Invalid material provided at %s"
			% [GaeaMaterial.RECURSIVE_LIMIT, material.resource_path]
		)
		_log_error(error, graph.resources.find(self))
		return result

	for cell: Vector3i in cells_to_place_on:
		result.set_cell(cell, material.execute_sample(rng, reference_sample.get_cell(cell)))

	return result


func _get_seed(pouch: GaeaGenerationPouch) -> int:
	return super(pouch) + hash(pouch.area)
