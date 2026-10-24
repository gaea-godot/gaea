@tool
class_name GaeaNodeVectorOp
extends GaeaNodeVectorBase
## Base class for operations between 2 vectors.

enum Operation {
	ADD,
	SUBTRACT,
	MULTIPLY,
	DIVIDE,
}


class Definition:
	var args: Array[StringName]
	var output: String
	var conversion: Callable

	func _init(_args: Array[StringName], _output: String, _conversion: Callable):
		args = _args
		output = _output
		conversion = _conversion


static var operation_definitions: Dictionary[Operation, Definition] = {
	Operation.ADD: Definition.new([&"a", &"b"], "a + b", func(a: Variant, b: Variant): return a + b),
	Operation.SUBTRACT: Definition.new([&"a", &"b"], "a - b", func(a: Variant, b: Variant): return a - b),
	Operation.MULTIPLY: Definition.new([&"a", &"b"], "a * b", func(a: Variant, b: Variant): return a * b),
	Operation.DIVIDE: Definition.new(
		[&"a", &"b"],
		"a / b",
		func(a: Variant, b: Variant): return 0 if b.is_zero_approx() else a / b
	),
}

func _get_title() -> String:
	return "VectorOp"


func _get_description() -> String:
	if get_tree_name() == _get_title():
		if not (has_meta(&"_gaea_graph_node") and is_instance_valid(get_meta(&"_gaea_graph_node"))):
			return "Operation between 2 [code]Vector[/code]s."

	var vector_name := _get_vector_type_name()
	match _get_arg_safe(&"operation", GaeaValue.ARG_TYPE_ENUM):
		Operation.ADD:
			return "Sums 2 [code]%s[/code]s." % vector_name
		Operation.SUBTRACT:
			return "Subtracts 2 [code]%s[/code]s." % vector_name
		Operation.MULTIPLY:
			return "Multiplies 2 [code]%s[/code]s together." % vector_name
		Operation.DIVIDE:
			return "Divides 2 [code]%s[/code]s together." % vector_name
	return ""


func _get_tree_items() -> Array[GaeaNodeResource]:
	var items: Array[GaeaNodeResource]
	items.append_array(super())
	for vector_type in VectorType.keys():
		for operation in operation_definitions.keys():
			var item: GaeaNodeResource = get_script().new()
			item.set_tree_name_override(
				(
					"%s (%s)"
					% [
						Operation.find_key(operation).to_pascal_case(),
						operation_definitions[operation].output
					]
				)
			)
			item.set_default_argument_value_override(&"type", VectorType[vector_type])
			item.set_default_argument_value_override(&"operation", operation)
			items.append(item)
	return items


func _get_arguments_list() -> Array[StringName]:
	var array: Array[StringName] = super()
	array.append(&"operation")
	array.append_array(operation_definitions.get(_get_arg_safe(&"operation", GaeaValue.ARG_TYPE_ENUM)).args)
	return array


func _get_argument_display_name(arg_name: StringName) -> String:
	if arg_name == &"operation" or arg_name == &"type":
		return super(arg_name)
	return arg_name


func _get_argument_type(arg_name: StringName) -> GaeaValue.ArgType:
	if arg_name == &"operation":
		return GaeaValue.ARG_TYPE_ENUM

	var super_value := super(arg_name)
	return super_value if super_value != GaeaValue.ARG_TYPE_NIL else get_type()


func _get_argument_hint(arg_name: StringName) -> Dictionary[String, Variant]:
	if arg_name == &"operation":
		var options: Dictionary = {}
		for operation in operation_definitions.keys():
			options.set(Operation.find_key(operation), operation)
		return {"options": options}
	return super(arg_name)


func _get_argument_default_value(arg_name: StringName) -> Variant:
	if arg_name == &"operation":
		return Operation.ADD
	return VectorType.VECTOR2 if arg_name == &"type" else super(arg_name)


func _on_argument_value_changed(arg_name: StringName, new_value: Variant) -> void:
	if arg_name == &"operation":
		notify_argument_list_changed()
	super(arg_name, new_value)


func _get_output_ports_list() -> Array[StringName]:
	return [&"result"]


func _get_output_port_display_name(_output_name: StringName) -> String:
	return operation_definitions[_get_arg_safe(&"operation", GaeaValue.ARG_TYPE_ENUM)].output


func _get_output_port_type(_output_name: StringName) -> GaeaValue.ArgType:
	return _get_vector_type() as GaeaValue.ArgType


func _get_data(_output_port: StringName, pouch: GaeaGenerationPouch) -> Variant:
	var operation: Operation = _get_arg(&"operation", pouch) as Operation
	var args: Array
	for arg_name: StringName in operation_definitions[operation].args:
		args.append(_get_arg(arg_name, pouch))
	return _get_new_value(operation, args)


func _get_new_value(operation: Operation, args: Array) -> Variant:
	return operation_definitions[operation].conversion.callv(args)
