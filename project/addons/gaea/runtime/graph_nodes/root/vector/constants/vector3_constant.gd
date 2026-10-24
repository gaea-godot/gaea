@tool
class_name GaeaNodeVector3Constant
extends GaeaNodeConstant
## [Vector3] constant.


func _get_output_port_type(_output_name: StringName) -> GaeaValue.ArgType:
	return GaeaValue.ARG_TYPE_VECTOR3


func _get_title() -> String:
	return "Vector3Constant"


func _get_description() -> String:
	return "[code]Vector3[/code] constant."
