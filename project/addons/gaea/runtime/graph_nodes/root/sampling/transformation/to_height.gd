@tool
class_name GaeaNodeToHeight
extends GaeaNodeResource
#gdlint:disable = max-line-length
## Transforms [param reference] into a new sample grid where the height of each column is determined by [param height_offset] + ([param reference] * [param displacement_intensity])
##
## For each cell in [param reference]'s [param reference_y] row, it'll get the [code]float[/code] value,
## multiply it by [param displacement_intensity] and add [param height_offset] to it. This will be
## the column's height, and every cell below that height (inclusive) will be full while every cell above
## will be empty.[br][br]
## This functions to create a heightmap, which can be used to create 2D side-view or
## 3D terrain.[br][br]
## [b]Note: Keep in mind the y axis in Godot is negative for up in 2D and down in 3D.[/b]
#gdlint:enable = max-line-length

enum Type {
	TYPE_2D, ## Referenced sample will only take into account the x coordinate of the cell.
	TYPE_3D ## Referenced sample will take into account both the x and the z coordinates of the cell.
}


func _get_title() -> String:
	return "ToHeight"


func _get_description() -> String:
	var desc: String = """Transforms [param reference] into a new sample grid \
where the height of each column is determined by [param height_offset] + ([param reference] * [param displacement_intensity])."""
	match _get_arg_safe(&"type", GaeaValue.ARG_TYPE_ENUM):
		Type.TYPE_2D:
			desc += "\n\nReferences all the x values of the [param reference_y] row."
		Type.TYPE_3D:
			desc += "\n\nReferences all the x,z values of the [param reference_y] row."
	return desc


func _get_tree_items() -> Array[GaeaNodeResource]:
	var items: Array[GaeaNodeResource]
	for type in Type.values():
		var item: GaeaNodeToHeight = get_script().new()
		item.set_tree_name_override(_get_title() + ("2D" if _get_arg_safe(&"type", GaeaValue.ARG_TYPE_ENUM) == Type.TYPE_2D else "3D"))
		item.set_default_argument_value_override(&"type", type)
		items.append(item)

	return items


func _get_arguments_list() -> Array[StringName]:
	return [&"type", &"reference", &"reference_y",
			&"height_offset", &"displacement_intensity",
			&"gradient_intensity"]


func _get_argument_type(arg_name: StringName) -> GaeaValue.ArgType:
	match arg_name:
		&"type": return GaeaValue.ARG_TYPE_ENUM
		&"reference": return GaeaValue.ARG_TYPE_SAMPLE
		&"gradient_intensity": return GaeaValue.ARG_TYPE_FLOAT
		_: return GaeaValue.ARG_TYPE_INT


func _get_argument_default_value(arg_name: StringName) -> Variant:
	match arg_name:
		&"displacement_intensity": return 16
		&"gradient_intensity": return 1.0
	return super(arg_name)


func _get_argument_hint(arg_name: StringName) -> Dictionary[String, Variant]:
	if arg_name == &"type":
		return {
			"options": Type,
			"display_name_provider": func(_id: int, key: String) -> String: return key.trim_prefix("TYPE_")
		}
	return super(arg_name)


func _get_output_ports_list() -> Array[StringName]:
	return [&"result"]


func _get_output_port_type(_output_name: StringName) -> GaeaValue.ArgType:
	return GaeaValue.ARG_TYPE_SAMPLE


func _get_data(_output_port: StringName, pouch: GaeaGenerationPouch) -> GaeaSample:
	var sample_reference: GaeaSample = _get_arg(&"reference", pouch)
	var row: int = _get_arg(&"reference_y", pouch)
	var height_offset: int = _get_arg(&"height_offset", pouch)
	var displacement: int = _get_arg(&"displacement_intensity", pouch)
	var gradient_intensity: float = _get_arg(&"gradient_intensity", pouch)
	var result: GaeaSample = GaeaSample.new()
	var type: Type = _get_arg(&"type", pouch) as Type

	var remap_offset: float = 0.0
	if not is_zero_approx(gradient_intensity):
		remap_offset = 100.0 / gradient_intensity

	var z_origin: int = int(pouch.area.position.z)
	var z_range: Array = [z_origin] if (type == Type.TYPE_2D) else (_get_axis_range(Vector3i.AXIS_Z, pouch.area))
	for x in _get_axis_range(Vector3i.AXIS_X, pouch.area):
		if not sample_reference.has(Vector3i(x, row, z_origin)):
			continue
		for z in z_range:
			var height: int = floor(sample_reference.get_xyz(x, row, z) * displacement + height_offset)
			for y in _get_axis_range(Vector3i.AXIS_Y, pouch.area):
				if y >= -height and type == Type.TYPE_2D:
					result.set_xyz(
						x, y, z,
						1.0 if is_zero_approx(remap_offset) else remap(
							y, -height + remap_offset, -height, 0, 1.0
						)
					)
				elif y <= height and type == Type.TYPE_3D:
					result.set_xyz(
						x, y, z,
						1.0 if is_zero_approx(remap_offset) else remap(
							y, height, height - remap_offset, 1.0, 0.0
						)
					)
	return result
