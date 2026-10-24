#pragma once

#include "godot_cpp/core/property_info.hpp"

#include <godot_cpp/classes/resource.hpp>
#include <godot_cpp/variant/variant.hpp>

namespace godot {
    class GaeaGenerationSettings : public Resource {
        GDCLASS(GaeaGenerationSettings, Resource)

    private:
        bool randomize_seed_on_generate;
        int seed;
        Vector3i world_size;

    protected:
        static void _bind_methods();
        void _validate_property(PropertyInfo& p_property) const;
        bool _property_can_revert(const StringName& p_name) const;
        bool _property_get_revert(const StringName& p_name, Variant& r_property) const;

    public:
        void set_randomize_seed_on_generate(const bool value);
        bool get_randomize_seed_on_generate() const;

        void set_seed(const int value);
        int get_seed() const;

        void set_world_size(const Vector3i value);
        Vector3i get_world_size() const;

        GaeaGenerationSettings();
    };
}// namespace godot
