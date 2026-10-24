#pragma once

#include <godot_cpp/classes/packed_scene.hpp>
#include <godot_cpp/classes/ref_counted.hpp>
#include <godot_cpp/classes/texture2d.hpp>
#include <godot_cpp/templates/pair.hpp>
#include <godot_cpp/variant/variant.hpp>

namespace godot {

    class GaeaValue : public RefCounted {
        GDCLASS(GaeaValue, RefCounted)

    protected:
        static void _bind_methods();

    public:
        enum ArgType {
            ARG_TYPE_CATEGORY = -1,
            ARG_TYPE_NIL = Variant::NIL,
            ARG_TYPE_BOOLEAN = Variant::BOOL,
            ARG_TYPE_INT = Variant::INT,
            ARG_TYPE_FLOAT = Variant::FLOAT,
            ARG_TYPE_VECTOR2 = Variant::VECTOR2,
            ARG_TYPE_VECTOR2I = Variant::VECTOR2I,
            ARG_TYPE_VECTOR3 = Variant::VECTOR3,
            ARG_TYPE_VECTOR3I = Variant::VECTOR3I,
            ARG_TYPE_ANY = 99,
            ARG_TYPE_RANGE = 100,
            ARG_TYPE_MATERIAL = 101,
            ARG_TYPE_TEXTURE = 102,
            ARG_TYPE_SAMPLE = 200,
            ARG_TYPE_MAP = 201,
            ARG_TYPE_BITMASK = 300,
            ARG_TYPE_BITMASK_EXCLUSIVE = 301,
            ARG_TYPE_FLAGS = 302,
            ARG_TYPE_NEIGHBORS = 303,
            ARG_TYPE_RULES = 304,
            ARG_TYPE_VARIABLE_NAME = 305,
            ARG_TYPE_ENUM = 306,
        };

        enum CoordinateFormat {
            COORDINATE_FORMAT_ALIGNED_3D,
            COORDINATE_FORMAT_ALIGNED_2D,
            COORDINATE_FORMAT_VERTICAL_OFFSET_2D,
            COORDINATE_FORMAT_HORIZONTAL_OFFSET_2D,
        };

        enum CellCheckMode {
            CELL_CHECK_MODE_BOOL,
            CELL_CHECK_MODE_TRISTATE
        };

        static bool is_wireable(const ArgType type);
        static bool is_valid_connection(const ArgType from, const ArgType to);
        static bool has_preview(const ArgType type);
        static String get_type_string(const ArgType type);
        static Variant get_default_value(const ArgType type);
				static TypedArray<int> get_types();

        static GaeaValue::ArgType from_variant_type(const Variant::Type type, const PropertyHint hint, const String hint_string);
        static GaeaValue::ArgType from_old_slot_type(const int32_t old_type);

        static Color get_color(const ArgType type);
        static Color get_default_color(const ArgType type);

        static Ref<Texture2D> get_display_icon(const ArgType type);
        static Ref<Texture2D> get_slot_icon(const ArgType type);
        static Ref<Texture2D> get_default_slot_icon(const ArgType type);

        static Ref<PackedScene> get_editor_for_type(const ArgType type);

        static bool can_cast(const ArgType from, const ArgType to);
        static Variant cast_value(const ArgType from, const ArgType to, const Variant& value);

    };

}// namespace godot

VARIANT_ENUM_CAST(GaeaValue::ArgType);
VARIANT_ENUM_CAST(GaeaValue::CoordinateFormat);
VARIANT_ENUM_CAST(GaeaValue::CellCheckMode);
