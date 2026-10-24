#include "grid.h"

#include <godot_cpp/core/class_db.hpp>

using namespace godot;

void GaeaGrid::_bind_methods() {
    ClassDB::bind_method(D_METHOD("set_cell", "cell", "value"), &GaeaGrid::set_cell);
    ClassDB::bind_method(D_METHOD("set_xyz", "x", "y", "z", "value"), &GaeaGrid::set_xyz);
    ClassDB::bind_method(D_METHOD("get_cell", "cell", "default_value"), &GaeaGrid::get_cell, DEFVAL(Variant()));
    ClassDB::bind_method(D_METHOD("get_xyz", "x", "y", "z", "default_value"), &GaeaGrid::get_xyz, DEFVAL(Variant()));
    ClassDB::bind_method(D_METHOD("get_cells"), &GaeaGrid::get_cells);
    ClassDB::bind_method(D_METHOD("get_cell_count"), &GaeaGrid::get_cell_count);
    ClassDB::bind_method(D_METHOD("has", "cell"), &GaeaGrid::has);
    ClassDB::bind_method(D_METHOD("erase", "cell"), &GaeaGrid::erase);
    ClassDB::bind_method(D_METHOD("is_empty"), &GaeaGrid::is_empty);
    ClassDB::bind_method(D_METHOD("fill", "area", "value"), &GaeaGrid::fill);
    ClassDB::bind_method(D_METHOD("get_size"), &GaeaGrid::get_size);
    ClassDB::bind_method(D_METHOD("get_position"), &GaeaGrid::get_position);
    ClassDB::bind_method(D_METHOD("get_end"), &GaeaGrid::get_end);

    ADD_PROPERTY(PropertyInfo(Variant::VECTOR3I, "size"), "", "get_size");
    ADD_PROPERTY(PropertyInfo(Variant::VECTOR3I, "position"), "", "get_position");
    ADD_PROPERTY(PropertyInfo(Variant::VECTOR3I, "end"), "", "get_end");
}

Vector3i GaeaGrid::get_size() const {
    return size;
}

Vector3i GaeaGrid::get_position() const {
    return position;
}

Vector3i GaeaGrid::get_end() const {
    return end;
}

void GaeaGrid::set_cell(const Vector3i cell, const Variant& p_variant) {
    Variant value = _validate_value(p_variant);
    if (value.get_type() == Variant::Type::NIL) {
        ERR_FAIL_MSG("Attempted to set value of invalid type or null value in GaeaGrid.");
    }

    grid[cell] = value;
    position = position.min(cell);
    end = end.max(cell);
    size = end - position + Vector3i(1, 1, 1);
}

void GaeaGrid::set_xyz(const int32_t x, const int32_t y, const int32_t z, const Variant& p_variant) {
    set_cell(Vector3i(x, y, z), p_variant);
}

Variant GaeaGrid::get_cell(const Vector3i cell, const Variant& default_value) const {
    if (!grid.has(cell)) { return default_value; }
    return grid.get(cell);
}

Variant GaeaGrid::get_xyz(const int32_t x, const int32_t y, const int32_t z, const Variant& default_value) const {
    return get_cell(Vector3i(x, y, z), default_value);
}

TypedArray<Vector3i> GaeaGrid::get_cells() const {
    TypedArray<Vector3i> arr;
    if (grid.is_empty()) { return arr; }
    for (auto i = grid.begin(); i != grid.end(); ++i) {
        arr.append(i->key);
    }
    return arr;
}

int GaeaGrid::get_cell_count() const {
    return grid.size();
}

bool GaeaGrid::has(const Vector3i cell) const {
    return grid.has(cell);
}

void GaeaGrid::erase(const Vector3i cell) {
    grid.erase(cell);
}

bool GaeaGrid::is_empty() const {
    return grid.is_empty();
}

void GaeaGrid::fill(const AABB& area, const Variant& p_variant) {
    Variant value = _validate_value(p_variant);
    if (value.get_type() == Variant::Type::NIL) {
        ERR_FAIL_MSG("Attempted to fill GaeaGrid with value of invalid type or null value.");
    }

    for (int x = area.position.x; x < area.get_end().x; x++) {
        for (int y = area.position.y; y < area.get_end().y; y++) {
            for (int z = area.position.z; z < area.get_end().z; z++) {
                set_xyz(x, y, z, p_variant);
            }
        }
    }
}

void GaeaGrid::clear() {
    TypedArray<Vector3i> cells = get_cells();
    for (int i = 0; i < cells.size(); i++) {
        erase(cells[i]);
    }
}

//* Sample *//

Variant GaeaSample::_validate_value(const Variant& p_variant) const {
    if (Variant::can_convert_strict(p_variant.get_type(), Variant::Type::FLOAT)) { return float(p_variant); }
    ERR_FAIL_V_MSG(Variant(), vformat("Couldn't convert value of type '%s' to float.", Variant::get_type_name(p_variant.get_type())));
}

//* Map *//
Variant GaeaMap::_validate_value(const Variant& p_variant) const {
    if (p_variant.get_type() != Variant::OBJECT) {
        ERR_FAIL_V_MSG(Variant(), "GaeaMap only accepts GaeaMaterial values.");
    }
    return p_variant;
}
