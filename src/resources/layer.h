#pragma once

#include "value.h"
#include <godot_cpp/classes/resource.hpp>

namespace godot {
    class GaeaLayer : public Resource {
        GDCLASS(GaeaLayer, Resource)

    private:
        bool enabled;
				GaeaValue::ArgType type;

    protected:
        static void _bind_methods();

    public:
        GaeaLayer();
        ~GaeaLayer() override = default;

        void set_enabled(const bool value);
        bool get_enabled() const;

				void set_type(const GaeaValue::ArgType value);
				GaeaValue::ArgType get_type() const;
    };
}// namespace godot
