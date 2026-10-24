#pragma once

#include "layer.h"

#include <godot_cpp/classes/resource.hpp>
#include <godot_cpp/variant/variant.hpp>

namespace godot {
    class GaeaResult : public RefCounted {
        GDCLASS(GaeaResult, RefCounted)

    private:
        AHashMap<int, Variant> grid;

    protected:
        static void _bind_methods();

    public:
        void add_layer(const int idx, const Variant& value, const Ref<GaeaLayer> resource);
        Variant get_layer(const int idx) const;
        int get_layer_count() const;
        TypedArray<int> get_enabled_layers_indexes() const;
    };
}// namespace godot
