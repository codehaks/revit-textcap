# Architecture

TextCap is a small, layered Revit add-in compiled into three per-version assemblies from a single shared-source project.

## Target frameworks

| Revit | Framework | csproj style |
| :--- | :--- | :--- |
| 2024 | `.NET Framework 4.8` | Old-style (legacy `.csproj`, `<TargetFrameworkVersion>v4.8`) |
| 2025 | `net8.0-windows` | SDK-style (`<Project Sdk="Microsoft.NET.Sdk">`, `<UseWPF>true</UseWPF>`) |
| 2026 | `net8.0-windows` | SDK-style |

All three produce **`TextCap.dll`**; the assembly name is identical so the same `.addin` manifest works against every version.

## Source layout

```
src/
├── Shared/                          (compiled into all three assemblies)
│   ├── Shared.shproj                (.shproj — shared-project metadata)
│   ├── Shared.projitems             (lists every .cs / resource)
│   ├── App.cs                       (IExternalApplication — ribbon + pulldown)
│   ├── Commands/                    (IExternalCommand entry points, one per case)
│   │   ├── UpperCaseCommand.cs
│   │   ├── LowerCaseCommand.cs
│   │   ├── SentenceCaseCommand.cs
│   │   └── TitleCaseCommand.cs
│   ├── Api/
│   │   └── TextTransaction.cs       (selection handling + `Transaction` for the rewrite)
│   ├── Core/
│   │   └── TextService.cs           (pure string transforms — `TextConvert.*`)
│   └── Resources/                   (icon-16.png, icon-32.png — pack:// URIs)
├── TextCap 2024/                    (thin csproj for Revit 2024)
├── TextCap 2025/                    (thin csproj for Revit 2025)
└── TextCap 2026/                    (thin csproj for Revit 2026)

tests/
└── TextCap.Test/                    (MSTest 2.2.10, net48 — unit tests for Core)
```

## Layering

```
┌─────────────────────────────────────────────────────────────┐
│ Revit host                                                  │
└──────────────┬───────────────────────────┬──────────────────┘
               │                           │
   ┌───────────▼─────────┐    ┌────────────▼─────────────┐
   │ App (Ribbon)        │    │ Commands/*Command.cs     │   IExternalCommand
   └─────────────────────┘    └────────────┬─────────────┘
                                            │ delegate to
                                ┌───────────▼─────────────┐
                                │ Api/TextTransaction     │   selection + Transaction
                                └───────────┬─────────────┘
                                            │ uses
                                ┌───────────▼─────────────┐
                                │ Core/TextService        │   pure string transforms
                                └─────────────────────────┘
```

Each `*Command.cs` is a one-line delegate that hands off to `TextTransaction.ProcessLowerCaseConversion(commandData, TextConvert.ToXxx)` — the same code path covers all four cases.

## Selection flow

`TextTransaction.ProcessLowerCaseConversion` chooses one of two paths based on what the user pre-selected:

1. **Bulk path** — `uiDoc.Selection.GetElementIds()` returns ≥1 ids. Calls `UpdateCase`, which wraps a single `Transaction` around the loop and replaces `TextNote.Text` for each id that resolves to a `TextNote` (others are skipped).
2. **Pick path** — nothing was pre-selected. Loops calling `Selection.PickObject(ObjectType.Element)` and runs `UpdateSingleText` per pick (each pick = its own `Transaction`). Cancel via Esc → `OperationCanceledException` ends the loop with `Result.Succeeded`.

## Revit API surface used

| API | Purpose | Stable across 2024/2025/2026 |
| :--- | :--- | :--- |
| `UIDocument.Selection.GetElementIds()` | Read pre-selection | ✓ |
| `UIDocument.Selection.PickObject(ObjectType.Element)` | Interactive pick | ✓ |
| `Document.GetElement(ElementId)` / `Reference` | Resolve picked element | ✓ |
| `TextNote.Text` | Read / write the text-note string | ✓ |
| `Transaction` | Mutation atomicity | ✓ |
| `PulldownButtonData` / `PushButtonData` / `RibbonPanel.AddItem` | Ribbon construction | ✓ |

No version-specific `#if` directives are needed; the same shared source compiles cleanly against all three Revit API surfaces.
