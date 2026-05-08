# CodeHaks **TextCap** for Revit

[![Build](https://img.shields.io/badge/build-msbuild-blue?logo=.net)](docs/build-and-load.md)
[![Revit](https://img.shields.io/badge/Revit-2024%20%7C%202025%20%7C%202026-005CA9?logo=autodesk&logoColor=white)](docs/build-and-load.md#revit-version-matrix)
[![.NET](https://img.shields.io/badge/.NET-Framework%204.8%20%7C%208.0--windows-512BD4?logo=dotnet&logoColor=white)](docs/architecture.md#target-frameworks)
[![Platform](https://img.shields.io/badge/platform-Windows%20x64-0078D6?logo=windows&logoColor=white)](#requirements)
[![License: Apache 2.0](https://img.shields.io/badge/license-Apache%202.0-blue.svg)](LICENSE.txt)
[![PRs Welcome](https://img.shields.io/badge/PRs-welcome-brightgreen.svg)](docs/contributing.md)

**CodeHaks TextCap** is a Revit add-in that converts the case of `TextNote` elements — Upper, Lower, Sentence, or Title — across one or many text notes at a time. The add-on adds a *Codehaks* ribbon panel with a *Text Cap* pulldown that exposes the four case commands.

The codebase is built around a single shared-source project that is compiled into three per-Revit-version assemblies — one for Revit 2024 (.NET Framework 4.8) and one each for Revit 2025 / 2026 (.NET 8 on Windows).

---

## Highlights

- **Four case conversions** — Upper, Lower, Sentence, Title — applied to selected `TextNote` elements via a single `Transaction` per command.
- **Two workflows** — bulk (pre-select notes, run command) and individual (run command, pick notes interactively until cancelled).
- **Ribbon integration** — adds a *Codehaks* panel with a *Text Cap* pulldown button (16/32-px branded icons) under the Add-Ins tab.
- **Multi-version build** — one shared project (`src/Shared/`), three thin per-version csprojs that differ only in target framework and Revit reference paths.
- **Single one-shot builder** — [`build.bat`](build.bat) compiles all targets and collects DLL + `.addin` into `dist/Revit <year>/`.

---

## Requirements

| | |
| :--- | :--- |
| **OS** | Windows 10 / 11, x64 |
| **Revit** | 2024, 2025, or 2026 (installed at `C:\Program Files\Autodesk\Revit <year>\`) |
| **.NET (build-time)** | .NET Framework 4.8 SDK *and* .NET 8 SDK |
| **Build tools** | MSBuild 17+ / Visual Studio 2022 17.8+ |

See [docs/build-and-load.md](docs/build-and-load.md) for the full version matrix.

---

## Quick start

### Build everything

```bat
build.bat              :: Release into dist\Revit 2024|2025|2026\
build.bat Debug        :: Debug build
```

Or build a single target:

```bat
msbuild "src\TextCap 2026\TextCap 2026.csproj" /p:Configuration=Release
```

### Load into Revit

1. Copy `dist\Revit <year>\TextCap.dll` and `dist\Revit <year>\TextCap.addin` into:
   `%AppData%\Autodesk\Revit\Addins\<year>\`
2. Launch Revit `<year>` and open a project.
3. Click **Add-Ins ▸ Codehaks ▸ Text Cap** on the ribbon and pick a case command.

Full walkthrough: [docs/build-and-load.md](docs/build-and-load.md).

---

## In-Revit commands

| Surface | Description |
| :--- | :--- |
| **Codehaks ▸ Text Cap ▸ Upper Case** | Convert selected `TextNote`s to `UPPER CASE`. |
| **Codehaks ▸ Text Cap ▸ Lower Case** | Convert selected `TextNote`s to `lower case`. |
| **Codehaks ▸ Text Cap ▸ Sentence Case** | Convert to `Sentence case` (first letter capitalised). |
| **Codehaks ▸ Text Cap ▸ Title Case** | Convert to `Title Case` (every word capitalised). |

Run with text notes already selected for bulk conversion, or with nothing selected to enter pick-one-at-a-time mode (Esc to finish).

---

## Documentation

| Document | What's inside |
| :--- | :--- |
| [docs/architecture.md](docs/architecture.md) | High-level design, layering, namespaces, Revit interop notes. |
| [docs/build-and-load.md](docs/build-and-load.md) | Build pipeline, version matrix, manifest install instructions. |
| [docs/developer-guide.md](docs/developer-guide.md) | Day-to-day development workflow, code map, debugging in Revit. |
| [docs/testing.md](docs/testing.md) | How to extend the existing MSTest project and add Revit-integration tests. |
| [docs/roadmap.md](docs/roadmap.md) | Future ideas, suggested improvements, technical-debt items. |
| [docs/contributing.md](docs/contributing.md) | Branching, commit conventions, review checklist. |

---

## Support

Open an issue on the GitHub repo, or email **[support@codehaks.com](mailto:support@codehaks.com)**.

---

## License

Released under the [Apache License 2.0](LICENSE.txt).

---

**CodeHaks TextCap** — Tidy your Revit text-note casing in one click.
