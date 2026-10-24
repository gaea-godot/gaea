#!/usr/addons/gaea/env python
import os
import sys


libname = "gaea"
projectdir = "project"

localEnv = Environment(tools=["default"], PLATFORM="")

# Build profiles can be used to decrease compile times.
# You can either specify "disabled_classes", OR
# explicitly specify "enabled_classes" which disables all other classes.
# Modify the example file as needed and uncomment the line below or
# manually specify the build_profile parameter when running SCons.

# localEnv["build_profile"] = "build_profile.json"

customs = ["custom.py"]
customs = [os.path.abspath(path) for path in customs]

opts = Variables(customs, ARGUMENTS)
opts.Update(localEnv)

Help(opts.GenerateHelpText(localEnv))

env = localEnv.Clone()

env = SConscript("godot-cpp/SConstruct", {"api_version": 4.3, "env": env, "customs": customs})

env.Append(CPPPATH=["src/"])
sources = [
    Glob("src/*.cpp"),
    Glob("src/nodes/*.cpp"),
    Glob("src/resources/*.cpp")
    ]

if env["target"] in ["editor", "template_debug"]:
    try:
        doc_data = env.GodotCPPDocData("src/gen/doc_data.gen.cpp", source=Glob("doc_classes/*.xml"))
        sources.append(doc_data)
    except AttributeError:
        print("Not including class reference as we're targeting a pre-4.3 baseline.")

# .dev doesn't inhibit compatibility, so we don't need to key it.
# .universal just means "compatible with all relevant arches" so we don't need to key it.
suffix = env['suffix'].replace(".dev", "").replace(".universal", "")

lib_filename = "{}{}{}{}".format(env.subst('$SHLIBPREFIX'), libname, suffix, env.subst('$SHLIBSUFFIX'))

library = env.SharedLibrary(
    "addons/gaea/libs/{}/{}".format(env['platform'], lib_filename),
    source=sources,
)

copy = env.Install("{}/addons/gaea/libs/{}/".format(projectdir, env["platform"]), library)

default_args = [library, copy]
Default(*default_args)
