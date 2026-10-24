@tool
class_name GaeaNodeFill
extends GaeaNodeResource
## Fills the grid with [param value].


func _get_title() -> String:
	return "Fill"


func _get_description() -> String:
	return "Fills the grid with [param value]."


func _get_arguments_list() -> Array[StringName]:
	return [&"value"]


func _get_argument_type(_arg_name: StringName) -> GaeaValue.ArgType:
	return GaeaValue.ARG_TYPE_FLOAT


func _get_output_ports_list() -> Array[StringName]:
	return [&"result"]


func _get_output_port_type(_output_name: StringName) -> GaeaValue.ArgType:
	return GaeaValue.ARG_TYPE_SAMPLE


func _get_data(_output_port: StringName, pouch: GaeaGenerationPouch) -> GaeaSample:
	var value: float = _get_arg(&"value", pouch)
	var sample := GaeaSample.new()
	sample.fill(pouch.area, value)
	return sample
