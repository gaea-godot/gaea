@tool
class_name GaeaNodeInput
extends GaeaNodeResource
## Returns different input variables.

enum InputVar { WORLD_SIZE, AREA_SIZE, AREA_POSITION, AREA_END }


func _get_title() -> String:
	return "Input"


func _get_description() -> String:
	match _get_arg_safe(&"input", GaeaValue.Type.ENUM):
		InputVar.WORLD_SIZE:
			return "Outputs the [param world_size] parameter in the generator's inspector."
		InputVar.AREA_SIZE:
			return "Outputs the size of the area being currently generated."
		InputVar.AREA_POSITION:
			return "Outputs the position of the area being currently generated."
		InputVar.AREA_END:
			return "Outputs the bottom right corner position of the area being currently generated."
	return super()


func _get_tree_items() -> Array[GaeaNodeResource]:
	var items: Array[GaeaNodeResource]
	for input_type in InputVar.values():
		var item: GaeaNodeResource = get_script().new()
		item.set_default_argument_value_override(&"input", input_type)
		item.set_tree_name_override(InputVar.find_key(input_type).to_pascal_case())
		items.append(item)

	return items


func _get_argument_type(_arg_name: StringName) -> GaeaValue.Type:
	return GaeaValue.Type.ENUM


func _on_argument_value_changed(_arg_name: StringName, _new_value: Variant) -> void:
	notify_argument_list_changed()


func _get_output_ports_list() -> Array[StringName]:
	return [&"value"]


func _get_arguments_list() -> Array[StringName]:
	return [&"input"]


func _get_argument_hint(_arg_name: StringName) -> Dictionary[String, Variant]:
	return {"options": InputVar, "icon_provider": GaeaNodeInput.get_var_icon}


func _get_argument_display_name(_arg_name: StringName) -> String:
	return ""


func _get_overridden_output_port_idx(_output_name: StringName) -> int:
	return 0


func _get_output_port_type(_output_name: StringName) -> GaeaValue.Type:
	return GaeaNodeInput.get_var_type(_get_arg_safe(&"input", GaeaValue.Type.ENUM))


func _get_output_port_description(_output_name: StringName) -> String:
	return "Returns the selected value, in this case: %s" % _get_description().trim_prefix("Outputs ")


static func get_var_icon(input: InputVar) -> Texture2D:
	return GaeaValue.get_display_icon(GaeaNodeInput.get_var_type(input))


static func get_var_type(input: InputVar) -> GaeaValue.Type:
	match input:
		InputVar.WORLD_SIZE:
			return GaeaValue.Type.VECTOR3I
		InputVar.AREA_SIZE, InputVar.AREA_POSITION, InputVar.AREA_END:
			return GaeaValue.Type.VECTOR3
		_:
			return GaeaValue.Type.NULL


func _get_data(_output_port: StringName, pouch: GaeaGenerationPouch) -> Variant:
	match _get_arg(&"input", pouch):
		InputVar.WORLD_SIZE:
			return pouch.settings.world_size
		InputVar.AREA_SIZE:
			return pouch.area.size
		InputVar.AREA_POSITION:
			return pouch.area.position
		InputVar.AREA_END:
			return pouch.area.end

	return null
