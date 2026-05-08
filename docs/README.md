# TextCap — Developer Documentation

This folder contains the engineering documentation for **CodeHaks TextCap**. The user-facing entry point lives in the repository [README.md](../README.md); this index is for contributors and maintainers.

## Index

| Document | Audience | Purpose |
| :--- | :--- | :--- |
| [architecture.md](architecture.md) | New contributors | Layered design, namespaces, Revit interop notes. |
| [build-and-load.md](build-and-load.md) | Anyone building locally | Per-version build matrix, `build.bat`, addin install workflow. |
| [developer-guide.md](developer-guide.md) | Active contributors | Daily workflow, code map, debugging tips. |
| [testing.md](testing.md) | Contributors adding tests | Extending the existing MSTest project; Revit-integration tests. |
| [roadmap.md](roadmap.md) | Maintainers, planners | Suggested improvements and future features. |
| [contributing.md](contributing.md) | External contributors | Branching, commit style, review expectations. |

## Conventions

- All paths in these docs are written relative to the repository root.
- "the shared project" = [src/Shared/](../src/Shared/).
- "per-version csprojs" = [src/TextCap 2024/](../src/TextCap%202024/), [src/TextCap 2025/](../src/TextCap%202025/), [src/TextCap 2026/](../src/TextCap%202026/).
- The C# root namespace is `TextCap` (the assembly is `TextCap.dll`).
