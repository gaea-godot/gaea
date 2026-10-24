#include "value.h"

#include "godot_cpp/variant/typed_array.hpp"
#include "grid.h"

#include <cstdint>
#include <godot_cpp/classes/control.hpp>
#include <godot_cpp/classes/editor_interface.hpp>
#include <godot_cpp/classes/engine.hpp>
#include <godot_cpp/classes/resource_loader.hpp>
#include <godot_cpp/classes/script.hpp>
#include <godot_cpp/core/class_db.hpp>
#include <godot_cpp/core/gdextension_interface_loader.hpp>
#include <godot_cpp/variant/dictionary.hpp>

using namespace godot;

void GaeaValue::_bind_methods() {
    ClassDB::bind_static_method("GaeaValue", D_METHOD("is_wireable", "type"), &GaeaValue::is_wireable);
    ClassDB::bind_static_method("GaeaValue", D_METHOD("is_valid_connection", "from", "to"), &GaeaValue::is_valid_connection);
    ClassDB::bind_static_method("GaeaValue", D_METHOD("has_preview", "type"), &GaeaValue::has_preview);
    ClassDB::bind_static_method("GaeaValue", D_METHOD("get_type_string", "type"), &GaeaValue::get_type_string);
    ClassDB::bind_static_method("GaeaValue", D_METHOD("get_default_value", "type"), &GaeaValue::get_default_value);
    ClassDB::bind_static_method("GaeaValue", D_METHOD("get_types"), &GaeaValue::get_types);
    ClassDB::bind_static_method("GaeaValue", D_METHOD("from_variant_type", "type", "hint", "hint_string"), &GaeaValue::from_variant_type);
    ClassDB::bind_static_method("GaeaValue", D_METHOD("from_old_slot_type", "old_type"), &GaeaValue::from_old_slot_type);
    ClassDB::bind_static_method("GaeaValue", D_METHOD("get_color", "type"), &GaeaValue::get_color);
    ClassDB::bind_static_method("GaeaValue", D_METHOD("get_default_color", "type"), &GaeaValue::get_default_color);
    ClassDB::bind_static_method("GaeaValue", D_METHOD("get_display_icon", "type"), &GaeaValue::get_display_icon);
    ClassDB::bind_static_method("GaeaValue", D_METHOD("get_slot_icon", "type"), &GaeaValue::get_slot_icon);
    ClassDB::bind_static_method("GaeaValue", D_METHOD("get_default_slot_icon", "type"), &GaeaValue::get_default_slot_icon);
    ClassDB::bind_static_method("GaeaValue", D_METHOD("get_editor_for_type", "type"), &GaeaValue::get_editor_for_type);
    ClassDB::bind_static_method("GaeaValue", D_METHOD("can_cast", "from", "to"), &GaeaValue::can_cast);
    ClassDB::bind_static_method("GaeaValue", D_METHOD("cast_value", "from", "to", "value"), &GaeaValue::cast_value);

    BIND_ENUM_CONSTANT(ARG_TYPE_CATEGORY)
    BIND_ENUM_CONSTANT(ARG_TYPE_NIL)
    BIND_ENUM_CONSTANT(ARG_TYPE_BOOLEAN)
    BIND_ENUM_CONSTANT(ARG_TYPE_INT)
    BIND_ENUM_CONSTANT(ARG_TYPE_FLOAT)
    BIND_ENUM_CONSTANT(ARG_TYPE_VECTOR2)
    BIND_ENUM_CONSTANT(ARG_TYPE_VECTOR2I)
    BIND_ENUM_CONSTANT(ARG_TYPE_VECTOR3)
    BIND_ENUM_CONSTANT(ARG_TYPE_VECTOR3I)
    BIND_ENUM_CONSTANT(ARG_TYPE_ANY)
    BIND_ENUM_CONSTANT(ARG_TYPE_RANGE)
    BIND_ENUM_CONSTANT(ARG_TYPE_MATERIAL)
    BIND_ENUM_CONSTANT(ARG_TYPE_TEXTURE)
    BIND_ENUM_CONSTANT(ARG_TYPE_SAMPLE)
    BIND_ENUM_CONSTANT(ARG_TYPE_MAP)
    BIND_ENUM_CONSTANT(ARG_TYPE_BITMASK)
    BIND_ENUM_CONSTANT(ARG_TYPE_BITMASK_EXCLUSIVE)
    BIND_ENUM_CONSTANT(ARG_TYPE_FLAGS)
    BIND_ENUM_CONSTANT(ARG_TYPE_NEIGHBORS)
    BIND_ENUM_CONSTANT(ARG_TYPE_RULES)
    BIND_ENUM_CONSTANT(ARG_TYPE_VARIABLE_NAME)
    BIND_ENUM_CONSTANT(ARG_TYPE_ENUM)

    BIND_ENUM_CONSTANT(COORDINATE_FORMAT_ALIGNED_3D)
    BIND_ENUM_CONSTANT(COORDINATE_FORMAT_ALIGNED_2D)
    BIND_ENUM_CONSTANT(COORDINATE_FORMAT_VERTICAL_OFFSET_2D)
    BIND_ENUM_CONSTANT(COORDINATE_FORMAT_HORIZONTAL_OFFSET_2D)

    BIND_ENUM_CONSTANT(CELL_CHECK_MODE_BOOL)
    BIND_ENUM_CONSTANT(CELL_CHECK_MODE_TRISTATE)
}

bool GaeaValue::is_wireable(const ArgType type) {
    return type > ARG_TYPE_NIL && type < ARG_TYPE_BITMASK;
}

bool GaeaValue::is_valid_connection(const ArgType from, const ArgType to) {
    return from == to || from == ARG_TYPE_ANY || to == ARG_TYPE_ANY || GaeaValue::can_cast(from, to);
}

bool GaeaValue::has_preview(const ArgType type) {
    return (type > ARG_TYPE_NIL && type < ARG_TYPE_ANY) || type == ARG_TYPE_SAMPLE || type == ARG_TYPE_MAP;
}

String GaeaValue::get_type_string(const ArgType type) {
    Variant::Type variant_type = static_cast<Variant::Type>(type);
    if (variant_type < Variant::VARIANT_MAX) { return Variant::get_type_name(variant_type); }

    switch (type) {
        case ARG_TYPE_RANGE:
            return "Range";
        case ARG_TYPE_MATERIAL:
            return "Material";
        case ARG_TYPE_TEXTURE:
            return "Texture";
        case ARG_TYPE_SAMPLE:
            return "Sample";
        case ARG_TYPE_MAP:
            return "Map";
        case ARG_TYPE_BITMASK:
            return "Bitmask";
        case ARG_TYPE_BITMASK_EXCLUSIVE:
            return "Exclusive Bitmask";
        case ARG_TYPE_FLAGS:
            return "Flags";
        case ARG_TYPE_NEIGHBORS:
            return "Neighbors";
        case ARG_TYPE_RULES:
            return "Rules";
        case ARG_TYPE_VARIABLE_NAME:
            return "Variable Name";
        case ARG_TYPE_ENUM:
            return "Enum";
        default:
            return "";
    }
}

Variant GaeaValue::get_default_value(const ArgType type) {
    switch (type) {
        case ARG_TYPE_BOOLEAN:
            return false;
        case ARG_TYPE_INT:
        case ARG_TYPE_ENUM:
            return 0;
        case ARG_TYPE_FLOAT:
            return 0.0;
        case ARG_TYPE_VECTOR2:
            return Vector2();
        case ARG_TYPE_VECTOR2I:
            return Vector2i();
        case ARG_TYPE_VECTOR3:
            return Vector3();
        case ARG_TYPE_VECTOR3I:
            return Vector3i();
        case ARG_TYPE_RANGE: {
            Dictionary dict = Dictionary(Dictionary(), Variant::STRING, "", Variant(), Variant::FLOAT, "", Variant());
            dict["min"] = 0.0;
            dict["max"] = 1.0;
            return dict;
        }
        case ARG_TYPE_SAMPLE:
            return memnew(GaeaSample);
        case ARG_TYPE_MAP:
            return memnew(GaeaMap);
        case ARG_TYPE_NEIGHBORS:
            return TypedArray<Vector3i>();
        case ARG_TYPE_RULES:
            return TypedArray<int>();
        case ARG_TYPE_VARIABLE_NAME: {
            return Dictionary(Dictionary(), Variant::VECTOR3I, "", Variant(), Variant::BOOL, "", Variant());
        }
        default:
            return Variant();
    }
}

TypedArray<int> GaeaValue::get_types() {
    TypedArray<int> typed_array;
    typed_array.append_array({
      ARG_TYPE_CATEGORY,
      ARG_TYPE_NIL,
      ARG_TYPE_BOOLEAN,
      ARG_TYPE_INT,
      ARG_TYPE_FLOAT,
      ARG_TYPE_VECTOR2,
      ARG_TYPE_VECTOR2I,
      ARG_TYPE_VECTOR3,
      ARG_TYPE_VECTOR3I,
      ARG_TYPE_ANY,
      ARG_TYPE_RANGE,
      ARG_TYPE_MATERIAL,
      ARG_TYPE_TEXTURE,
      ARG_TYPE_SAMPLE,
      ARG_TYPE_MAP,
      ARG_TYPE_BITMASK,
      ARG_TYPE_BITMASK_EXCLUSIVE,
      ARG_TYPE_FLAGS,
      ARG_TYPE_NEIGHBORS,
      ARG_TYPE_RULES,
      ARG_TYPE_VARIABLE_NAME,
      ARG_TYPE_ENUM,
    });
    return typed_array;
}


GaeaValue::ArgType GaeaValue::from_variant_type(const Variant::Type type, const PropertyHint hint, const String hint_string) {
    switch (type) {
        case Variant::BOOL:
            return ARG_TYPE_BOOLEAN;
        case Variant::INT:
            return ARG_TYPE_INT;
        case Variant::FLOAT:
            return ARG_TYPE_FLOAT;
        case Variant::VECTOR2:
            return ARG_TYPE_VECTOR2;
        case Variant::VECTOR2I:
            return ARG_TYPE_VECTOR2I;
        case Variant::VECTOR3:
            return ARG_TYPE_VECTOR3;
        case Variant::VECTOR3I:
            return ARG_TYPE_VECTOR3I;
        case Variant::OBJECT:
            if (hint_string == "GaeaMaterial") { return ARG_TYPE_MATERIAL; }

            if (hint_string.begins_with("Texture")) { return ARG_TYPE_TEXTURE; }
        default:
            return ARG_TYPE_NIL;
    }
}

GaeaValue::ArgType GaeaValue::from_old_slot_type(const int32_t old_type) {
    switch (old_type) {
        case 0:
            return ARG_TYPE_SAMPLE;
        case 1:
            return ARG_TYPE_MAP;
        case 2:
            return ARG_TYPE_MATERIAL;
        case 3:
            return ARG_TYPE_VECTOR2;
        case 4:
            return ARG_TYPE_FLOAT;
        case 5:
            return ARG_TYPE_RANGE;
        case 6:
            return ARG_TYPE_BOOLEAN;
        case 7:
            return ARG_TYPE_VECTOR3;
        default:
            return ARG_TYPE_NIL;
    }
}

Color GaeaValue::get_color(const ArgType type) {
    Engine* engine = Engine::get_singleton();
    if (engine->is_editor_hint()) {
        ResourceLoader* resource_loader = ResourceLoader::get_singleton();
        Ref<Script> gaea_editor_settings = resource_loader->load("uid://duu3vekk7pxwk");
        if (((Dictionary) gaea_editor_settings->get_script_constant_map()["CONFIGURABLE_SLOT_COLORS"]).has(type)) {
            return gaea_editor_settings->call("get_configured_color_for_value_type", type);
        }
    }
    return get_default_color(type);
}

Color GaeaValue::get_default_color(const ArgType type) {
    switch (type) {
        case ARG_TYPE_BOOLEAN:
            return Color("ffdd59");// YELLOW
        case ARG_TYPE_INT:
        case ARG_TYPE_FLOAT:
            return Color("a0a0a0");// GRAY
        case ARG_TYPE_VECTOR2I:
        case ARG_TYPE_VECTOR2:
            return Color("00bfff");// LIGHT BLUE
        case ARG_TYPE_VECTOR3I:
        case ARG_TYPE_VECTOR3:
            return Color("8e44ad");// MAGENTA
        case ARG_TYPE_ANY:
            return Color("ff00fe");// LIGHT MAGENTA
        case ARG_TYPE_RANGE:
            return Color("f04c7f");// PINK
        case ARG_TYPE_MATERIAL:
            return Color("eb2f06");// RED
        case ARG_TYPE_SAMPLE:
            return Color("f0f8ff");// WHITE
        case ARG_TYPE_MAP:
            return Color("27ae60");// GREEN
        case ARG_TYPE_TEXTURE:
            return Color("e67e22");// ORANGE
        default:
            return Color("ffffff");
    }
}

Ref<Texture2D> GaeaValue::get_display_icon(const ArgType type) {
    ResourceLoader* resource_loader = ResourceLoader::get_singleton();
    switch (type) {
        // Basic types
        case ARG_TYPE_BOOLEAN:
            return resource_loader->load("uid://0l53mu4blspj");
        case ARG_TYPE_INT:
            return resource_loader->load("uid://bilsfh3nrbhkl");
        case ARG_TYPE_FLOAT:
            return resource_loader->load("uid://baw7ye0h4xdcx");
        case ARG_TYPE_VECTOR2I:
            return resource_loader->load("uid://bpel4ys42dkjc");
        case ARG_TYPE_VECTOR2:
            return resource_loader->load("uid://c8uvy6c2syjk5");
        case ARG_TYPE_VECTOR3I:
            return resource_loader->load("uid://cd0polwxfqhyi");
        case ARG_TYPE_VECTOR3:
            return resource_loader->load("uid://bkknri7u8ghs4");
        // Simple types
        case ARG_TYPE_RANGE:
            return resource_loader->load("uid://wx4ccwofr8yy");
        case ARG_TYPE_MATERIAL:
            return resource_loader->load("uid://b0vqox8bodse");
        case ARG_TYPE_TEXTURE: {
            Engine* engine = Engine::get_singleton();
            if (engine->is_editor_hint()) {
                EditorInterface* editor_interface = (EditorInterface*) engine->get_singleton("EditorInterface");
                return editor_interface->get_base_control()->get_theme_icon("Image", "EditorIcons");
            }
            return NULL;
        }
        // Dictionary types
        case ARG_TYPE_SAMPLE:
            return resource_loader->load("uid://dkccxw7yq1mth");
        case ARG_TYPE_MAP:
            return resource_loader->load("uid://c2i5wqidu1r1o");
        default:
            return NULL;
    }
}

Ref<Texture2D> GaeaValue::get_slot_icon(const ArgType type) {
    Engine* engine = Engine::get_singleton();
    if (engine->is_editor_hint()) {
        ResourceLoader* resource_loader = ResourceLoader::get_singleton();
        Ref<Script> gaea_editor_settings = resource_loader->load("uid://duu3vekk7pxwk");
        if (((Dictionary) gaea_editor_settings->get_script_constant_map()["CONFIGURABLE_SLOT_COLORS"]).has(type)) {
            return gaea_editor_settings->call("get_configured_icon_for_value_type", type);
        }
    }
    return get_default_slot_icon(type);
}

Ref<Texture2D> GaeaValue::get_default_slot_icon(const ArgType type) {
    ResourceLoader* resource_loader = ResourceLoader::get_singleton();
    switch (type) {
        case ARG_TYPE_BOOLEAN:
            return resource_loader->load("uid://4b3i1xqd4052");
        case ARG_TYPE_INT:
        case ARG_TYPE_FLOAT:
            return resource_loader->load("uid://dqob6v3dudlri");
        case ARG_TYPE_VECTOR2I:
        case ARG_TYPE_VECTOR2:
            return resource_loader->load("uid://bidpo1iw1t0vt");
        case ARG_TYPE_VECTOR3I:
        case ARG_TYPE_VECTOR3:
            return resource_loader->load("uid://dbvw3j8fnmhpu");
        case ARG_TYPE_ANY: {
            Engine* engine = Engine::get_singleton();
            if (engine->is_editor_hint()) {
                EditorInterface* editor_interface = (EditorInterface*) engine->get_singleton("EditorInterface");
                return editor_interface->get_base_control()->get_theme_icon("NodeInfo", "EditorIcons");
            }
        }
        case ARG_TYPE_RANGE:
            return resource_loader->load("uid://dfsmxavxasx7x");
        case ARG_TYPE_MATERIAL:
            return resource_loader->load("uid://daasmk1v2rpcm");
        case ARG_TYPE_TEXTURE:
            return resource_loader->load("uid://ccqq5l0ruur37");
        case ARG_TYPE_SAMPLE:
            return resource_loader->load("uid://yo87adchyr3w");
        case ARG_TYPE_MAP:
            return resource_loader->load("uid://d2rmsal7c6sdi");
        default: {
            WARN_PRINT(vformat("No slot icon found for type '%s'.", get_type_string(type)));
            return NULL;
        }
    }
}

Ref<PackedScene> GaeaValue::get_editor_for_type(const ArgType type) {
    ResourceLoader* resource_loader = ResourceLoader::get_singleton();
    Engine* engine = Engine::get_singleton();
    ERR_FAIL_COND_V_MSG(!engine->is_editor_hint(), NULL, "The method get_editor_for_type can only by used in the Godot Editor.");
    switch (type) {
        case ARG_TYPE_FLOAT:
        case ARG_TYPE_INT:
            return resource_loader->load("uid://dp7blnx7abb5e");
        case ARG_TYPE_VECTOR2:
        case ARG_TYPE_VECTOR2I:
        case ARG_TYPE_VECTOR3:
        case ARG_TYPE_VECTOR3I:
            return resource_loader->load("uid://mlwupvg8a886");
        case ARG_TYPE_VARIABLE_NAME:
            return resource_loader->load("uid://bn8i1l4q13pdw");
        case ARG_TYPE_RANGE:
            return resource_loader->load("uid://t4osuglcgg6l");
        case ARG_TYPE_BITMASK:
        case ARG_TYPE_BITMASK_EXCLUSIVE:
        case ARG_TYPE_FLAGS:
            return resource_loader->load("uid://chdg8ey4ln8d1");
        case ARG_TYPE_CATEGORY:
            return resource_loader->load("uid://x6n8ylnxoyno");
        case ARG_TYPE_BOOLEAN:
            return resource_loader->load("uid://byaonbbfa2bx8");
        case ARG_TYPE_NEIGHBORS:
            return resource_loader->load("uid://d11yc7l6sneof");
        case ARG_TYPE_RULES:
            return resource_loader->load("uid://dy4n2a5hkaxsb");
        case ARG_TYPE_ENUM:
            return resource_loader->load("uid://cxvfo0jd720y7");
        default:
            return resource_loader->load("uid://i2nwlab8rau");
    }
}

bool GaeaValue::can_cast(const ArgType from, const ArgType to) {
    if (from == to) { return true; }
    if (from == ARG_TYPE_ANY || to == ARG_TYPE_ANY) { return true; }
    Variant::Type variant_from_type = static_cast<Variant::Type>(from);
    Variant::Type variant_to_type = static_cast<Variant::Type>(to);
    // If they're built-in variant types, check if they can be converted.
    if (variant_from_type < Variant::VARIANT_MAX && variant_to_type < Variant::VARIANT_MAX) {
        if (Variant::can_convert_strict(variant_from_type, variant_to_type)) { return true; }
    }

    const ArgType* valid_types = nullptr;

    switch (from) {
        case ARG_TYPE_BOOLEAN: {
            static const ArgType valid[] = {ARG_TYPE_VECTOR2, ARG_TYPE_VECTOR2I, ARG_TYPE_VECTOR3, ARG_TYPE_VECTOR3I, ARG_TYPE_RANGE, ARG_TYPE_NIL};
            valid_types = valid;
        } break;
        case ARG_TYPE_FLOAT: {
            static const ArgType valid[] = {ARG_TYPE_VECTOR2, ARG_TYPE_VECTOR2I, ARG_TYPE_VECTOR3, ARG_TYPE_VECTOR3I, ARG_TYPE_RANGE, ARG_TYPE_NIL};
            valid_types = valid;
        } break;
        case ARG_TYPE_INT: {
            static const ArgType valid[] = {ARG_TYPE_VECTOR2, ARG_TYPE_VECTOR2I, ARG_TYPE_VECTOR3, ARG_TYPE_VECTOR3I, ARG_TYPE_RANGE, ARG_TYPE_NIL};
            valid_types = valid;
        } break;
        case ARG_TYPE_VECTOR2: {
            static const ArgType valid[] = {ARG_TYPE_VECTOR3I, ARG_TYPE_RANGE, ARG_TYPE_NIL};
            valid_types = valid;
        } break;
        case ARG_TYPE_VECTOR2I: {
            static const ArgType valid[] = {ARG_TYPE_VECTOR3I, ARG_TYPE_RANGE, ARG_TYPE_NIL};
            valid_types = valid;
        } break;
        case ARG_TYPE_VECTOR3: {
            static const ArgType valid[] = {ARG_TYPE_VECTOR2, ARG_TYPE_VECTOR2I, ARG_TYPE_RANGE, ARG_TYPE_NIL};
            valid_types = valid;
        } break;
        case ARG_TYPE_VECTOR3I: {
            static const ArgType valid[] = {ARG_TYPE_VECTOR2, ARG_TYPE_VECTOR2I, ARG_TYPE_RANGE, ARG_TYPE_NIL};
            valid_types = valid;
        } break;
        case ARG_TYPE_RANGE: {
            static const ArgType valid[] = {ARG_TYPE_VECTOR2, ARG_TYPE_VECTOR2I, ARG_TYPE_VECTOR3, ARG_TYPE_VECTOR3I, ARG_TYPE_NIL};
            valid_types = valid;
        } break;
        default: {
        }
    }

    if (valid_types) {
        uint32_t i = 0;
        while (valid_types[i] != ARG_TYPE_NIL) {
            if (to == valid_types[i]) { return true; }
            i++;
        }
    }

    return false;
}

Variant GaeaValue::cast_value(const ArgType from, const ArgType to, const Variant& value) {
    if (!can_cast(from, to)) {
        ERR_FAIL_V_MSG(
          Variant(),
          vformat("Could not get data from previous node, missing cast method from %s to %s.", get_type_string(from), get_type_string(to))
        );
    }

    if (from == to) {
        if (from == ARG_TYPE_INT) { return int(value); }
        return value;
    }

    if (from == ARG_TYPE_ANY || to == ARG_TYPE_ANY) { return value; }

    switch (from) {
        case ARG_TYPE_INT:
        case ARG_TYPE_FLOAT:
        case ARG_TYPE_BOOLEAN: {
            switch (to) {
                case ARG_TYPE_BOOLEAN:
                    return value.booleanize();
                case ARG_TYPE_INT:
                    return int(value);
                case ARG_TYPE_FLOAT:
                    return float(value);
                case ARG_TYPE_VECTOR2:
                    return Vector2(float(value), float(value));
                case ARG_TYPE_VECTOR2I:
                    return Vector2i(int(value), int(value));
                case ARG_TYPE_VECTOR3:
                    return Vector3(float(value), float(value), float(value));
                case ARG_TYPE_VECTOR3I:
                    return Vector3i(int(value), int(value), int(value));
                case ARG_TYPE_RANGE: {
                    Dictionary dict = Dictionary();
                    dict["min"] = float(value);
                    dict["max"] = float(value);
                    return dict;
                }
                default: {
                }
            }
        } break;
        case ARG_TYPE_VECTOR2:
        case ARG_TYPE_VECTOR2I: {
            switch (to) {
                case ARG_TYPE_VECTOR2:
                    return Vector2(value);
                case ARG_TYPE_VECTOR2I:
                    return Vector2i(value);
                case ARG_TYPE_VECTOR3:
                    return Vector3(((Vector2) value).x, ((Vector2) value).y, 0.0);
                case ARG_TYPE_VECTOR3I:
                    return Vector3i(((Vector2i) value).x, ((Vector2i) value).y, 0.0);
                case ARG_TYPE_RANGE: {
                    Dictionary dict = Dictionary();
                    dict["min"] = ((Vector2) value).x;
                    dict["max"] = ((Vector2) value).y;
                    return dict;
                }
                default: {
                }
            }
        } break;
        case ARG_TYPE_VECTOR3:
        case ARG_TYPE_VECTOR3I: {
            switch (to) {
                case ARG_TYPE_VECTOR2:
                    return Vector2(((Vector3) value).x, ((Vector3) value).y);
                case ARG_TYPE_VECTOR2I:
                    return Vector2i(((Vector3i) value).x, ((Vector3i) value).y);
                case ARG_TYPE_VECTOR3:
                    return Vector3(value);
                case ARG_TYPE_VECTOR3I:
                    return Vector3i(value);
                case ARG_TYPE_RANGE: {
                    Dictionary dict = Dictionary();
                    dict["min"] = ((Vector2) value).x;
                    dict["max"] = ((Vector2) value).y;
                    return dict;
                }
                default: {
                }
            }
        } break;
        case ARG_TYPE_RANGE: {
            switch (to) {
                case ARG_TYPE_VECTOR2:
                    return Vector2(value["min"], value["max"]);
                case ARG_TYPE_VECTOR2I:
                    return Vector2i(value["min"], value["max"]);
                case ARG_TYPE_VECTOR3:
                    return Vector3(value["min"], value["max"], 0.0);
                case ARG_TYPE_VECTOR3I:
                    return Vector3i(value["min"], value["max"], 0);
                default: {
                }
            }
        } break;
        default: {
        };
    };
    return Variant();
}
