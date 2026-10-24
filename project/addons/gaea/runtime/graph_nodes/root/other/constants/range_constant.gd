@tool
class_name GaeaNodeRangeConstant
extends GaeaNodeConstant
## Range constant.


func _get_output_port_type(_output_name: StringName) -> GaeaValue.ArgType:
	return GaeaValue.ARG_TYPE_RANGE


func _get_title() -> String:
	return "RangeConstant"


func _get_description() -> String:
	return "Range constant."
