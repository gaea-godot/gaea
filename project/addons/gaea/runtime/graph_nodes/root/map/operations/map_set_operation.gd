@tool
class_name GaeaNodeMapSetOp
extends GaeaNodeSetOp
## Map version of [GaeaNodeSetOp]. Has no Complement node.


func _get_title() -> String:
	return "MapSetOp"


func _get_output_port_type(_output_name: StringName) -> GaeaValue.ArgType:
	return GaeaValue.ARG_TYPE_MAP
