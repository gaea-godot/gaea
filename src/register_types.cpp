#include "register_types.h"

#include "resources/generation_settings.h"
#include "resources/grid.h"
#include "resources/layer.h"
#include "resources/result.h"
#include "resources/value.h"

#include <gdextension_interface.h>

#include <godot_cpp/core/class_db.hpp>
#include <godot_cpp/core/defs.hpp>
#include <godot_cpp/godot.hpp>

using namespace godot;

void initialize_gdextension_types(ModuleInitializationLevel p_level) {
    if (p_level != MODULE_INITIALIZATION_LEVEL_SCENE) { return; }

    GDREGISTER_ABSTRACT_CLASS(GaeaValue);
    GDREGISTER_ABSTRACT_CLASS(GaeaGrid);
    GDREGISTER_CLASS(GaeaSample);
    GDREGISTER_CLASS(GaeaMap);
    GDREGISTER_CLASS(GaeaLayer);
    GDREGISTER_CLASS(GaeaResult);
    GDREGISTER_CLASS(GaeaGenerationSettings);
}

void uninitialize_gdextension_types(ModuleInitializationLevel p_level) {
    if (p_level != MODULE_INITIALIZATION_LEVEL_SCENE) { return; }
}

extern "C" {
// Initialization
GDExtensionBool GDE_EXPORT
gaea_library_init(GDExtensionInterfaceGetProcAddress p_get_proc_address, GDExtensionClassLibraryPtr p_library, GDExtensionInitialization* r_initialization) {
    GDExtensionBinding::InitObject init_obj(p_get_proc_address, p_library, r_initialization);
    init_obj.register_initializer(initialize_gdextension_types);
    init_obj.register_terminator(uninitialize_gdextension_types);
    init_obj.set_minimum_library_initialization_level(MODULE_INITIALIZATION_LEVEL_SCENE);

    return init_obj.init();
}
}
