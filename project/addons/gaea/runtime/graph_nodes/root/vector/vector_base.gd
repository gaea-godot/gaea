@tool
@abstract
class_name GaeaNodeVectorBase
extends GaeaNodeResource
## Base class for vector operation nodes.

enum VectorType {
	VECTOR2 = GaeaValue.ARG_TYPE_VECTOR2,
	VECTOR3 = GaeaValue.ARG_TYPE_VECTOR3,
	VECTOR2I = GaeaValue.ARG_TYPE_VECTOR2I,
	VECTOR3I = GaeaValue.ARG_TYPE_VECTOR3I,
}


func _get_vector_type() -> VectorType:
	return _get_arg_safe(&"type", GaeaValue.ARG_TYPE_ENUM, VectorType.VECTOR2) as VectorType


func _get_vector_type_name(type: VectorType = _get_vector_type()) -> String:
	return VectorType.find_key(type).to_pascal_case()


func _get_arguments_list() -> Array[StringName]:
	return [&"type"]


func _get_argument_type(arg_name: StringName) -> GaeaValue.ArgType:
	return GaeaValue.ARG_TYPE_ENUM if arg_name == &"type" else GaeaValue.ARG_TYPE_NIL


func _get_argument_hint(arg_name: StringName) -> Dictionary[String, Variant]:
	if arg_name == &"type":
		return {
			"options": VectorType,
			"display_name_provider": func(_id: int, key: String) -> String: return key.to_pascal_case()
		}
	return super(arg_name)


func _get_argument_default_value(arg_name: StringName) -> Variant:
	if arg_name == &"type":
		return VectorType.VECTOR2
	return super(arg_name)


func _get_enum_option_icon(_enum_idx: int, option_value: int) -> Texture:
	return GaeaValue.get_display_icon(option_value)


func _on_argument_value_changed(arg_name: StringName, _new_value: Variant) -> void:
	if arg_name == &"type":
		notify_argument_list_changed()


func _is_integer_vector() -> bool:
	return _get_vector_type() in [VectorType.VECTOR2I, VectorType.VECTOR3I]
