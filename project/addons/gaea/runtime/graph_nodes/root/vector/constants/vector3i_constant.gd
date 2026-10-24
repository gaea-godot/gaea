@tool
class_name GaeaNodeVector3iConstant
extends GaeaNodeConstant
## [Vector3i] constant.


func _get_output_port_type(_output_name: StringName) -> GaeaValue.ArgType:
	return GaeaValue.ARG_TYPE_VECTOR3I


func _get_title() -> String:
	return "Vector3iConstant"


func _get_description() -> String:
	return "[code]Vector3i[/code] constant."
