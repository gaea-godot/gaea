@tool
class_name GaeaNodeFloatConstant
extends GaeaNodeConstant
## [float] constant.


func _get_output_port_type(_output_name: StringName) -> GaeaValue.ArgType:
	return GaeaValue.ARG_TYPE_FLOAT


func _get_title() -> String:
	return "FloatConstant"


func _get_description() -> String:
	return "[code]float[/code] constant."
