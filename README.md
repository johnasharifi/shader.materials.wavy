# Shader.vertex.wavy

[Video of shader in operation](https://youtu.be/zh7mAoxVeFw)

# Introduction
Files for a vertex shader which is designed to distort the positions of vertices in a flat mesh.

# How to use
* Option 1: open .unitypackage with Unity3D
* Option 2: Download Assets/ShaderWavy into a Unity project. Create a material M, point the material's shader at ShaderWavy. Create a plane, point the plane's material at M.

# Details
Params:
* Base color: color for central parts of the mesh
* Peak color: color for high parts of the mesh
* Trough color: color for low parts of mesh
* World wave - direction: range 0 - PI, describes direction of global waves
* World wave - height: vertical displacement of global waves
* World wave - speed: time from peak to peak
* World wave - freq: space between peaks
* Local wave - freq: space between local wave peaks
* Local wave - height: vertical displacement of local waves
* Local wave - XYZ speed: x, vertical, and z displacement-over-time of waves
