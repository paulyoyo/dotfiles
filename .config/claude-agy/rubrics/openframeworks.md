# Rubric: openFrameworks apps (C++)

Primary lens: a creative-coding app that must hold its frame rate live. Simple, readable C++
that keeps per-frame work cheap and resources owned clearly. Modern C++ (C++17) with RAII.
Secondary lens: SOLID, adapted below. When a principle adds indirection that costs frame time
or readability for no concrete gain, simplicity wins: report under "Tensions".

Do not recommend architectures (ECS, heavy scene graphs, frameworks) because they are popular.
Recommend a change only when it removes a concrete problem. Adding abstractions is a cost.

## Slices

| Slice | Paths |
|---|---|
| app | src/ofApp.h, src/ofApp.cpp, src/main.cpp |
| modules | every other file in src/ |
| shaders | bin/data/shaders (and any .vert/.frag/.glsl) |
| config-data | addons.make, config.make, Makefile, *.xcodeproj settings summary, bin/data layout (list files, do not read binaries) |

## Rules

### F. Frame loop and realtime

- F1. Nothing expensive per frame: no file loading (ofImage::load, ofLoadImage, ofxAssimp loads), no allocation of large buffers, no shader compilation, no `new` in update()/draw(). Load and allocate in setup() or on demand outside the loop.
- F2. Reuse GPU resources: ofFbo, ofVbo, ofMesh, ofTexture allocated once and reused; flag reallocation every frame or on every window resize without need.
- F3. Frame-rate independence: animation and physics use ofGetLastFrameTime() / elapsed time, not frame counts, unless locked frame rate is intentional.
- F4. update() changes state, draw() only renders. Flag state mutation or heavy computation in draw().
- F5. Audio callbacks (audioIn/audioOut): no allocation, no locks held for long, no file or network I/O, no printing. Share data with the main thread through atomics or a lock-free/double buffer.
- F6. Threads (ofThread, std::thread): shared data protected consistently; threads stopped and joined in exit() or destructors; no GL calls outside the main thread.
- F7. External I/O (OSC, MIDI, serial, DMX, Syphon/Spout, video capture): handled without blocking the frame; reconnection when a device disappears.

### M. Modern C++ and ownership

- M1. RAII and the rule of zero: no raw owning pointers or manual delete; std::unique_ptr / values instead. Flag leaks and double ownership.
- M2. const-correctness and pass-by-reference for heavy objects (ofPixels, ofMesh, vectors).
- M3. Paths through ofToDataPath / relative data paths; flag absolute paths from the author's machine.
- M4. ofParameter / ofxGui (or equivalent) for tweakable values instead of magic numbers scattered in code; parameters saved and loaded.

### S. SOLID, adapted

- S1. Single Responsibility: ofApp should orchestrate, not contain every effect, input handler and render pass. Flag ofApp files that are growing into god objects; suggest one class per visual module or input source.
- S2. Open/Closed: flag long switch/if chains over modes or scenes repeated in update and draw; suggest one class per scene with update()/draw().
- S5. Dependency Inversion only at hardware/protocol boundaries (OSC, MIDI, serial, DMX): one small wrapper each, so the app can run without the device.

### X. Cross-cutting

- X1. Shaders: consistent GLSL version, uniforms set once per frame not per draw call when avoidable, no unused uniforms/varyings, precision issues noted.
- X2. Build: addons listed in addons.make actually used; unused addons removed.
- X3. Dead code: unused classes, commented-out blocks, stale assets referenced nowhere.

## Review focus (for a single change)

New per-frame allocations or loads; GL calls off the main thread; audio-callback safety; ownership of new resources; ofApp growing instead of a new module; hardcoded absolute paths.

## Verification

1. Build: `make -j` (or `xcodebuild -project <App>.xcodeproj -configuration Release build` if there is no Makefile)
2. There are usually no automated tests: after building, list a short manual smoke test for Paul (what to run, what to look at, expected frame rate).
