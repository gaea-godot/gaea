@tool
class_name GaeaNodeComposeVector
extends GaeaNodeVectorBase
## Composes floats to vector.


func _get_title() -> String:
	return "VectorCompose"


func _get_description() -> String:
	return (
		"Composes a [code]%s[/code] from numbers."
		% [_get_vector_type_name()]
	)


#region Arguments
func _get_arguments_list() -> Array[StringName]:
	var array: Array[StringName] = super()
	match _get_vector_type():
		VectorType.VECTOR2, VectorType.VECTOR2I:
			array.append_array([&"x", &"y"])
		VectorType.VECTOR3, VectorType.VECTOR3I:
			array.append_array([&"x", &"y", &"z"])
	return array


func _get_argument_display_name(arg_name: StringName) -> String:
	if arg_name == &"type":
		return super(arg_name)
	return arg_name


func _get_argument_type(arg_name: StringName) -> GaeaValue.ArgType:
	if arg_name == &"type":
		return super(arg_name)
	return GaeaValue.ARG_TYPE_INT if _is_integer_vector() else GaeaValue.ARG_TYPE_FLOAT
#endregion


#region Outputs
func _get_output_ports_list() -> Array[StringName]:
	return [&"vector"]


func _get_output_port_display_name(_output_name: StringName) -> String:
	return "Result"


func _get_output_port_type(_output_name: StringName) -> GaeaValue.ArgType:
	return _get_vector_type() as GaeaValue.ArgType


#endregion


func _get_tree_items() -> Array[GaeaNodeResource]:
	var array: Array[GaeaNodeResource] = []

	for i in VectorType.values():
		var item: GaeaNodeResource = get_script().new()
		item.set_default_argument_value_override(&"type", i)
		item.set_tree_name_override(_get_vector_type_name(i) + "Compose")
		array.append(item)

	return array


func _get_data(_output_port: StringName, pouch: GaeaGenerationPouch) -> Variant:
	match _get_arg(&"type", pouch):
		VectorType.VECTOR2:
			return Vector2(
				_get_arg(&"x", pouch),
				_get_arg(&"y", pouch),
			)
		VectorType.VECTOR3:
			return Vector3(
				_get_arg(&"x", pouch),
				_get_arg(&"y", pouch),
				_get_arg(&"z", pouch),
			)
		VectorType.VECTOR2I:
			return Vector2i(
				_get_arg(&"x", pouch),
				_get_arg(&"y", pouch),
			)
		VectorType.VECTOR3I:
			return Vector3i(
				_get_arg(&"x", pouch),
				_get_arg(&"y", pouch),
				_get_arg(&"z", pouch),
			)
	return null
