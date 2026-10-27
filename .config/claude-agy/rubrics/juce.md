# Rubric: JUCE apps and plugins (C++)

Primary lens: audio software that must never glitch. Realtime safety first, then clear thread
ownership, then readable modern C++ (C++17/20) with RAII and JUCE idioms.
Secondary lens: SOLID, adapted below. When a principle adds indirection on the audio path or
obscures thread ownership, the realtime/clarity lens wins: report under "Tensions".

Do not recommend architectures because they are popular. Recommend a change only when it
removes a concrete problem. Adding abstractions is a cost.

## Slices

| Slice | Paths |
|---|---|
| audio | the AudioProcessor / AudioAppComponent / audio callback classes and everything they call on the audio thread |
| background | job queues, ThreadPool jobs, worker threads, file/model processing, IPC with other apps |
| ui | Components, editors, LookAndFeel, timers, listeners |
| state-io | parameters (APVTS), state save/restore, settings, file formats, device management |
| build | CMakeLists.txt or *.jucer summary, module list, dependencies (list, do not read vendored JUCE code) |
| tests | juce::UnitTest classes or any test target |

Skip JUCE's own modules and any vendored third-party code.

## Rules

### RT. Realtime audio thread

- RT1. No allocation on the audio thread: no new/delete, no std::vector growth, no std::string building, no juce::String concatenation, no AudioBuffer resize in processBlock / getNextAudioBlock. Allocate in prepareToPlay.
- RT2. No blocking: no locks that the message or worker threads may hold for long (CriticalSection/std::mutex), no file or network I/O, no Logger/DBG in release paths, no waiting on other threads.
- RT3. Cross-thread data through std::atomic, juce::AbstractFifo / lock-free queues, or SpinLock with try-lock only. Flag data shared without synchronization.
- RT4. Parameters read via APVTS atomics (getRawParameterValue) or cached pointers, not by string lookup per block. Smoothing (SmoothedValue) where parameters are audible.
- RT5. ScopedNoDenormals in the audio callback; handling of changing sample rate and block size in prepareToPlay.

### TH. Threads and lifetime

- TH1. Clear ownership of every thread: message thread, audio thread, workers. Flag UI objects touched from worker/audio threads; UI updates must go through MessageManager::callAsync, AsyncUpdater or a Timer.
- TH2. Lifetimes across threads: callAsync lambdas capturing `this` without a Component::SafePointer / WeakReference; jobs outliving the object that created them; threads not stopped in destructors.
- TH3. Listeners removed in destructors (ChangeListener, Parameter listeners, Value listeners, MidiInputCallback). Flag dangling registrations.
- TH4. Background job queues: cancellation supported, progress reported to the UI safely, errors surfaced to the user, no unbounded queue growth, no busy-waiting.

### M. Modern C++ and JUCE idioms

- M1. RAII and the rule of zero: std::unique_ptr / values, no raw owning pointers, JUCE_DECLARE_NON_COPYABLE_WITH_LEAK_DETECTOR on classes that own resources.
- M2. Component hierarchy: child components owned as members, layout in resized(), painting in paint() without heavy work; repaint only what changed and not faster than needed.
- M3. State: getStateInformation / setStateInformation (or app settings via PropertiesFile) round-trips everything the user expects to persist; versioning of saved state.
- M4. Files and paths through juce::File and special locations, not hardcoded absolute paths.

### S. SOLID, adapted

- S1. Single Responsibility: flag processors, main components or controllers that mix DSP, file management, UI logic and IPC. Suggest splitting by thread role first (audio / background / UI), then by feature.
- S2. Open/Closed: repeated switch over modes/engine types in several places; suggest a small polymorphic type or a table.
- S5. Dependency Inversion only at external boundaries (other apps like Traktor, ML models, hardware controllers, network): one wrapper each, so the rest can be tested with a fake.

### X. Cross-cutting

- X1. Error handling: failures in file loading, model loading or device opening reported to the user, not ignored.
- X2. Dead code, unused JUCE modules in the build, commented-out blocks.

## Review focus (for a single change)

Any new work on the audio thread (allocation, locks, logging); new cross-thread data without atomics/FIFOs; callAsync lambdas without SafePointer; listeners not removed; UI touched off the message thread; job cancellation and lifetime.

## Verification

1. Build: `cmake --build build --config Release` if CMake, else `xcodebuild -project Builds/MacOSX/<Name>.xcodeproj -configuration Release build`
2. Run unit tests if a test target or juce::UnitTestRunner exists
3. Otherwise list a short manual smoke test for Paul (load, process, cancel a job, quit while busy)
