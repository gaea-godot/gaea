#include "generation_settings.h"

#include "godot_cpp/classes/global_constants.hpp"

#include <godot_cpp/core/class_db.hpp>

using namespace godot;

void GaeaGenerationSettings::_bind_methods() {
    ClassDB::bind_method(D_METHOD("set_randomize_seed_on_generate", "value"), &GaeaGenerationSettings::set_randomize_seed_on_generate);
    ClassDB::bind_method(D_METHOD("get_randomize_seed_on_generate"), &GaeaGenerationSettings::get_randomize_seed_on_generate);

    ClassDB::bind_method(D_METHOD("set_seed", "value"), &GaeaGenerationSettings::set_seed);
    ClassDB::bind_method(D_METHOD("get_seed"), &GaeaGenerationSettings::get_seed);

    ClassDB::bind_method(D_METHOD("set_world_size", "value"), &GaeaGenerationSettings::set_world_size);
    ClassDB::bind_method(D_METHOD("get_world_size"), &GaeaGenerationSettings::get_world_size);

    ADD_PROPERTY(PropertyInfo(Variant::BOOL, "randomize_seed_on_generate"), "set_randomize_seed_on_generate", "get_randomize_seed_on_generate");
    ADD_PROPERTY(PropertyInfo(Variant::INT, "seed"), "set_seed", "get_seed");
    ADD_PROPERTY(PropertyInfo(Variant::VECTOR3I, "world_size"), "set_world_size", "get_world_size");
}

void GaeaGenerationSettings::_validate_property(PropertyInfo& p_property) const {
    if (p_property.name == StringName("seed") && randomize_seed_on_generate) {
        p_property.usage |= PROPERTY_USAGE_READ_ONLY;
    }
}

bool GaeaGenerationSettings::_property_can_revert(const StringName& p_name) const {
    return p_name == StringName("seed");
}

bool GaeaGenerationSettings::_property_get_revert(const StringName& p_name, Variant& r_property) const {
    if (p_name == StringName("seed")) {
        r_property = rand();
        return true;
    }
    return false;
}

void GaeaGenerationSettings::set_randomize_seed_on_generate(const bool value) {
    randomize_seed_on_generate = value;
    notify_property_list_changed();
}

bool GaeaGenerationSettings::get_randomize_seed_on_generate() const {
    return randomize_seed_on_generate;
}

void GaeaGenerationSettings::set_seed(const int value) {
    seed = value;
}

int GaeaGenerationSettings::get_seed() const {
    return seed;
}

void GaeaGenerationSettings::set_world_size(const Vector3i value) {
    world_size = value.max(Vector3i(1, 1, 1));
}

Vector3i GaeaGenerationSettings::get_world_size() const {
    return world_size;
}

GaeaGenerationSettings::GaeaGenerationSettings() {
    seed = rand();
    world_size = Vector3i(64, 64, 1);
}
