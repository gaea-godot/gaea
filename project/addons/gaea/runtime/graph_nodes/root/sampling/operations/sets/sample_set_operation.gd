@tool
class_name GaeaNodeSampleSetOp
extends GaeaNodeSetOp
## Sample version of [GaeaNodeSetOp].


func _get_title() -> String:
	return "SampleSetOp"


func _get_output_port_type(_output_name: StringName) -> GaeaValue.ArgType:
	return GaeaValue.ARG_TYPE_SAMPLE
