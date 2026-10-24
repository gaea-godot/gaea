#include "result.h"

#include "godot_cpp/variant/typed_array.hpp"

#include <godot_cpp/core/class_db.hpp>
#include <godot_cpp/variant/dictionary.hpp>

using namespace godot;

void GaeaResult::_bind_methods() {
    ClassDB::bind_method(D_METHOD("add_layer", "idx", "value", "resource"), &GaeaResult::add_layer);
    ClassDB::bind_method(D_METHOD("get_layer", "idx"), &GaeaResult::get_layer);
    ClassDB::bind_method(D_METHOD("get_layer_count"), &GaeaResult::get_layer_count);
    ClassDB::bind_method(D_METHOD("get_enabled_layers_indexes"), &GaeaResult::get_enabled_layers_indexes);
}

void GaeaResult::add_layer(const int idx, const Variant& value, const Ref<GaeaLayer> resource) {
    if (resource.is_valid() && !resource->get_enabled()) { grid[idx] = Variant(); }

    grid[idx] = value;
}

Variant GaeaResult::get_layer(const int idx) const {
    ERR_FAIL_COND_V_MSG(!grid.has(idx), Variant(), vformat("GaeaResult doesn't have a layer at index %s", idx));
    return grid.get(idx);
}

int GaeaResult::get_layer_count() const {
    return grid.size();
}

TypedArray<int> GaeaResult::get_enabled_layers_indexes() const {
    TypedArray<int> arr;
    if (grid.is_empty()) { return arr; }
    for (auto i = grid.begin(); i != grid.end(); ++i) {
        if (i->value.get_type() == Variant::NIL) { continue; }
        arr.append(i->key);
    }
    return arr;
}

