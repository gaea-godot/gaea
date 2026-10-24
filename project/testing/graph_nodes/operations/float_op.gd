extends "res://testing/graph_nodes/operations/num_op.gd"



func before():
	node = GaeaNodeFloatOp.new()


func _get_failure_message() -> String:
	return "[b]GaeaNodeFloatOp[/b] returned an unexpected value with operation [b]%s[/b]." % GaeaNodeFloatOp.Operation.keys()[node._get_arg_safe(&"operation", GaeaValue.ARG_TYPE_ENUM)]


func test_add() -> void:
	node.set_argument_value(&"operation", GaeaNodeFloatOp.Operation.ADD)
	_assert_operation_result([2.0, 1.0], 3.0)
	_assert_operation_result([1.0, -0.5], 0.5)


func test_subtract() -> void:
	node.set_argument_value(&"operation", GaeaNodeFloatOp.Operation.SUBTRACT)
	_assert_operation_result([2.0, 1.0], 1.0)
	_assert_operation_result([1.0, -0.5], 1.5)


func test_multiply() -> void:
	node.set_argument_value(&"operation", GaeaNodeFloatOp.Operation.MULTIPLY)
	_assert_operation_result([4.0, 2.0], 8.0)
	_assert_operation_result([4.0, -2.0], -8.0)


func test_divide() -> void:
	node.set_argument_value(&"operation", GaeaNodeFloatOp.Operation.DIVIDE)
	_assert_operation_result([2.0, 1.0], 2.0)
	_assert_operation_result([1.0, -0.5], -2.0)


func test_power() -> void:
	node.set_argument_value(&"operation", GaeaNodeFloatOp.Operation.POWER)
	_assert_operation_result([2.0, 2.0], 4.0)
	_assert_operation_result([1.0, 0.0], 1.0)
	_assert_operation_result([2.0, -1.0], 0.5)


func test_min_and_max() -> void:
	node.set_argument_value(&"operation", GaeaNodeFloatOp.Operation.MAX)
	_assert_operation_result([1.0, 2.0], 2.0)

	node.set_argument_value(&"operation", GaeaNodeFloatOp.Operation.MIN)
	_assert_operation_result([1.0, 2.0], 1.0)


func test_abs() -> void:
	node.set_argument_value(&"operation", GaeaNodeFloatOp.Operation.ABS)
	_assert_operation_result([-2.0], 2.0)


func test_rounding() -> void:
	node.set_argument_value(&"operation", GaeaNodeFloatOp.Operation.CEIL)
	_assert_operation_result([0.5], 1.0)

	node.set_argument_value(&"operation", GaeaNodeFloatOp.Operation.FLOOR)
	_assert_operation_result([0.5], 0.0)

	node.set_argument_value(&"operation", GaeaNodeFloatOp.Operation.ROUND)
	_assert_operation_result([0.4], 0.0)
	_assert_operation_result([0.6], 1.0)


func test_clamp() -> void:
	node.set_argument_value(&"operation", GaeaNodeFloatOp.Operation.CLAMP)
	_assert_operation_result([0.5, 0.0, 1.0], 0.5)
	_assert_operation_result([-INF, 0.0, 1.0], 0.0)
	_assert_operation_result([INF, 0.0, 1.0], 1.0)


func test_remap() -> void:
	node.set_argument_value(&"operation", GaeaNodeFloatOp.Operation.REMAP)
	_assert_operation_result([0.5, 0.0, 1.0, 2.0, 4.0], 3.0)


func test_sign() -> void:
	node.set_argument_value(&"operation", GaeaNodeFloatOp.Operation.SIGN)
	_assert_operation_result([1.0], 1.0)
	_assert_operation_result([-1.0], -1.0)
	_assert_operation_result([0.0], 0.0)


func test_smoothstep() -> void:
	node.set_argument_value(&"operation", GaeaNodeFloatOp.Operation.SMOOTHSTEP)
	_assert_operation_result([0.0, 1.0, 0.9], smoothstep(0.0, 1.0, 0.9))


func test_step() -> void:
	node.set_argument_value(&"operation", GaeaNodeFloatOp.Operation.STEP)
	_assert_operation_result([0.6, 0.5], 1.0)
	_assert_operation_result([0.4, 0.5], 0.0)
	_assert_operation_result([0.5, 0.5], 1.0)


func test_wrap() -> void:
	node.set_argument_value(&"operation", GaeaNodeFloatOp.Operation.WRAP)
	_assert_operation_result([1.5, 0.0, 1.0], 0.5)
	_assert_operation_result([0.5, 0.0, 1.0], 0.5)
