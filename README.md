# Eat Wise Native-Port(WIP)
This is a native port of the [EatWise](https://eat-wise-silk.netlify.app/) web application, original source at [GitHub](https://github.com/Shahidul-Khan2004/eat_wise).

# Build
Download [Godot-4.5.1](https://godotengine.org/download/archive/). Open the `project.godot` file in the godot editor and that's it.

# Build Export Template
Prerequisites: Python 3, [Scons](https://scons.org/), MSVC(Visual Studio 2022+). [More info can found here.](https://docs.godotengine.org/en/4.4/contributing/development/compiling/index.html)
Git Repo: https://github.com/godotengine/godot/tree/4.5.1-stable
1. Clone [Godot-4.5.1-stable](https://github.com/godotengine/godot/tree/4.5.1-stable)
   * On Windows open `Developer PowerShell for VS 2022`.
2. Copy `template_release.gdbuild` and `template_release.py` into the cloned folder.
3. Run command: `scons platform=windows profile=template_release.py build_profile=template_release.gdbuild`.

Some export template are already present in `.export-templates`, no-need to build it again for those platforms. Just need to export normally using Godot.

# TODO
Finish Login, Register and User pages.
