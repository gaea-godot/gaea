extends "res://testing/test_grid_output_base.gd"


const AREA: AABB = AABB(Vector3.ZERO, Vector3(16, 16, 16))
const FREQUENCY: float = 0.04


func test_voronoi() -> void:
	node = GaeaNodeVoronoi.new()
	node.salt = 0

	var noise: FastNoiseLite = FastNoiseLite.new()
	noise.seed = 0
	noise.noise_type = FastNoiseLite.TYPE_CELLULAR
	noise.frequency = FREQUENCY
	noise.cellular_distance_function = FastNoiseLite.DISTANCE_EUCLIDEAN_SQUARED
	noise.fractal_type = FastNoiseLite.FRACTAL_NONE
	noise.cellular_return_type = FastNoiseLite.RETURN_CELL_VALUE
	var expected_grid: Dictionary
	for x in range(0, AREA.size.x):
		for y in range(0, AREA.size.y):
			for z in range(0, AREA.size.z):
				expected_grid.set(Vector3i(x, y, z), (noise.get_noise_3d(x, y, z) + 1.0) * 0.5)

	var expected_hash: int = expected_grid.hash()

	var grid := _assert_output_grid_matches(
		AREA, expected_hash, false,
		{ &"frequency": FREQUENCY }, &"result"
	)

	for cell in grid.get_cells():
		assert_float(grid.get_cell(cell, -1.0))\
			.override_failure_message("Value is not between 0.0 and 1.0 in [b]%s[/b]" % node.get_tree_name())\
			.is_between(0.0, 1.0)

		if is_failure():
			return
