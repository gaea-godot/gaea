# meta-description: Node with an enum to be used in the Gaea editor.
@tool
# class_name GaeaNode...
extends GaeaNodeResource
## Node description.


enum Enum1 {
	VALUE_1
}


func _get_title() -> String:
	return "NodeTitle"


func _get_description() -> String:
	return "Node description."


# List of all the arguments, preferably in &"snake_case".
func _get_arguments_list() -> Array[StringName]:
	return [&"enum"]


func _get_argument_type(arg_name: StringName) -> GaeaValue.Type:
	if arg_name == &"enum":
		return GaeaValue.Type.ENUM
	return GaeaValue.Type.NULL


func _get_argument_default_value(arg_name: StringName) -> Variant:
	if arg_name == &"enum":
		return Enum1.VALUE_1
	return GaeaValue.Type.NULL


func _get_argument_hint(arg_name: StringName) -> Dictionary[String, Variant]:
	if arg_name == &"enum":
		return {"options": Enum1}
	return super(arg_name)


# List of all the outputs, preferably in &"snake_case"
func _get_output_ports_list() -> Array[StringName]:
	return []


func _get_output_port_type(output_name: StringName) -> GaeaValue.Type:
	return GaeaValue.Type.NULL


func _get_data(output_port: StringName, area: AABB, graph: GaeaGraph) -> Variant:
	return null
