@tool
class_name GaeaNodeIntConstant
extends GaeaNodeConstant
## [int] constant.


func _get_output_port_type(_output_name: StringName) -> GaeaValue.ArgType:
	return GaeaValue.ARG_TYPE_INT


func _get_title() -> String:
	return "IntConstant"


func _get_description() -> String:
	return "[code]int[/code] constant."
