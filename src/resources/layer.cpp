#include "layer.h"

#include <godot_cpp/core/class_db.hpp>

using namespace godot;

void GaeaLayer::_bind_methods() {
    ClassDB::bind_method(D_METHOD("get_enabled"), &GaeaLayer::get_enabled);
    ClassDB::bind_method(D_METHOD("set_enabled", "value"), &GaeaLayer::set_enabled);
    ClassDB::bind_method(D_METHOD("get_type"), &GaeaLayer::get_type);
    ClassDB::bind_method(D_METHOD("set_type", "value"), &GaeaLayer::set_type);

    ADD_PROPERTY(PropertyInfo(Variant::BOOL, "enabled"), "set_enabled", "get_enabled");
    ADD_PROPERTY(
      PropertyInfo(Variant::INT, "type", PROPERTY_HINT_ENUM, "bool:1,int:2,float:3,Vector2:5,Vector2i:6,Vector3:9,Vector3i:10,Any:99,Range:100,Material:101,Texture:102,Sample:200,Map:201"),
      "set_type",
      "get_type"
    );
}

GaeaLayer::GaeaLayer() {
    enabled = true;
    type = GaeaValue::ARG_TYPE_MAP;
}

void GaeaLayer::set_enabled(const bool value) {
    if (enabled != value) {
        enabled = value;
        emit_changed();
    }
}

bool GaeaLayer::get_enabled() const {
    return enabled;
}

void GaeaLayer::set_type(const GaeaValue::ArgType value) {
		if (type != value) {
			ERR_FAIL_COND_MSG(!GaeaValue::is_wireable(value), "GaeaLayer can only be of wireable type.");
			type = value;
			emit_changed();
		}
}

GaeaValue::ArgType GaeaLayer::get_type() const {
    return type;
}
