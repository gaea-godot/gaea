@tool
class_name GaeaEditorEnumArgument
extends GaeaEditorGraphNodeArgument

var _icon_provider: Callable
var _display_name_provider: Callable

@onready var option_button: OptionButton = %OptionButton


static func parse_options(options: Variant) -> Dictionary[String, int]:
	match typeof(options):
		TYPE_STRING:
			return GaeaEditorEnumArgument.parse_options(options.split(","))
		TYPE_ARRAY:
			var dict: Dictionary[String, int]
			var idx: int = 0
			for option: String in options:
				var id: int = idx
				var split_option: PackedStringArray = option.rsplit(":", true, 2)
				if split_option.size() > 1 and split_option[1].is_valid_int():
					id = int(split_option[1])
				dict.set(split_option[0], id)
				idx += 1
			return dict
		TYPE_DICTIONARY:
			return Dictionary(options, TYPE_STRING, &"", null, TYPE_INT, &"", null)
		_:
			push_error("Invalid value type for enum options.")
			return {}


func _ready() -> void:
	if is_part_of_edited_scene():
		return
	option_button.item_selected.connect(_on_option_button_item_selected)


func _configure() -> void:
	if is_part_of_edited_scene():
		return
	await super()

	_icon_provider = hint.get("icon_provider", Callable())
	_display_name_provider = hint.get(
		"display_name_provider",
		func(_id: int, text: String) -> String: return text.capitalize()
	)

	if hint.has("options"):
		var options := GaeaEditorEnumArgument.parse_options(hint.get("options"))
		for key in options.keys():
			_add_option(key, options[key])


func _add_option(key: String, id: int) -> void:
	option_button.add_item(_display_name_provider.call(id, key), id)
	var idx: int = option_button.get_item_index(id)
	if _icon_provider.is_valid():
		option_button.set_item_icon(idx, _icon_provider.call(id))


func get_arg_value() -> Variant:
	return option_button.get_selected_id()


func set_arg_value(new_value: Variant) -> Error:
	if typeof(new_value) != TYPE_INT:
		return ERR_INVALID_DATA

	option_button.select(option_button.get_item_index(new_value))
	return OK


func _on_option_button_item_selected(index: int) -> void:
	argument_value_changed.emit(option_button.get_item_id(index))
