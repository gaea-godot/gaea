#pragma once

#include <godot_cpp/classes/ref_counted.hpp>
#include <godot_cpp/classes/resource.hpp>
#include <godot_cpp/variant/variant.hpp>

namespace godot {
    class GaeaGrid : public RefCounted {
        GDCLASS(GaeaGrid, RefCounted)

    protected:
        static void _bind_methods();
        AHashMap<Vector3i, Variant> grid;
        Vector3i size;
        Vector3i position;
        Vector3i end;

        virtual Variant _validate_value(const Variant& p_variant) const { return p_variant; }

    public:
        Vector3i get_size() const;
        Vector3i get_position() const;
        Vector3i get_end() const;

        void set_cell(const Vector3i cell, const Variant& p_variant);
        void set_xyz(const int32_t x, const int32_t y, const int32_t z, const Variant& p_variant);
        Variant get_cell(const Vector3i cell, const Variant& default_value) const;
        Variant get_xyz(const int32_t x, const int32_t y, const int32_t z, const Variant& default_value) const;
        TypedArray<Vector3i> get_cells() const;
        int32_t get_cell_count() const;
        bool has(const Vector3i cell) const;
        void erase(const Vector3i cell);
        bool is_empty() const;
        void fill(const AABB& area, const Variant& p_variant);
        void clear();
    };

    class GaeaSample : public GaeaGrid {
        GDCLASS(GaeaSample, GaeaGrid)

    protected:
        static void _bind_methods() {}

        Variant _validate_value(const Variant& p_variant) const override;

    public:
        ~GaeaSample() { clear(); }
    };

    class GaeaMap : public GaeaGrid {
        GDCLASS(GaeaMap, GaeaGrid)

    protected:
        static void _bind_methods() {}

        Variant _validate_value(const Variant& p_variant) const override;

    public:
        ~GaeaMap() { clear(); }
    };

}// namespace godot
