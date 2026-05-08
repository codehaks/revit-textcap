# Developer Guide

Day-to-day notes for developing on TextCap.

## Code map

| Where to look | What lives there |
| :--- | :--- |
| [src/Shared/App.cs](../src/Shared/App.cs) | Ribbon panel + pulldown + four push-buttons. Edit here to change icons, button labels, or panel name. |
| [src/Shared/Commands/](../src/Shared/Commands/) | Four `IExternalCommand` classes. Each delegates to `TextTransaction.ProcessLowerCaseConversion(commandData, TextConvert.ToXxx)`. |
| [src/Shared/Api/TextTransaction.cs](../src/Shared/Api/TextTransaction.cs) | Selection handling + `Transaction` lifecycle. **All Revit-API mutations live here.** |
| [src/Shared/Core/TextService.cs](../src/Shared/Core/TextService.cs) | Pure string transforms — no Revit references. **Add new case styles here**, then wire a new command. |

## Adding a new case style

1. Add a public static method to `TextConvert` in [Core/TextService.cs](../src/Shared/Core/TextService.cs), e.g. `ToReverseCase(string)`.
2. Add a unit test in [tests/TextCap.Test/](../tests/TextCap.Test/).
3. Create a new command class under `src/Shared/Commands/`, copying one of the existing four. The whole body is one line: `TextTransaction.ProcessLowerCaseConversion(commandData, TextConvert.ToReverseCase)`.
4. Register the new file in [`src/Shared/Shared.projitems`](../src/Shared/Shared.projitems) under `<ItemGroup>`.
5. Wire a new `AddPushButton` call in [App.cs](../src/Shared/App.cs).

## Adding a new file to the shared project

The `.projitems` file is the source-of-truth list. Add an entry like:

```xml
<Compile Include="$(MSBuildThisFileDirectory)Path\To\NewFile.cs" />
```

For images / icons, add a `<Resource>` entry under the same parent.

## Debugging in Revit

1. Build Debug (`build.bat Debug`).
2. Copy `dist\Revit 2024\TextCap.{dll,pdb,addin}` into `%AppData%\Autodesk\Revit\Addins\2024\`.
3. In Visual Studio, open the appropriate per-version csproj, set the project's **Start external program** to `C:\Program Files\Autodesk\Revit <year>\Revit.exe`, and press **F5**.
4. Set breakpoints in shared source — they hit regardless of which per-version assembly is loaded, because the `.pdb` maps to the shared `.cs`.

## Adding a new Revit version

When Autodesk releases Revit 2027:

1. Copy `src/TextCap 2026/` to `src/TextCap 2027/`, rename the `.csproj`, and update the `RevitAPI` / `RevitAPIUI` HintPaths to `Revit 2027\…`.
2. Add the new csproj to [`TextCap.sln`](../TextCap.sln) and the `SharedMSBuildProjectFiles` block.
3. Add a `call :build 2027 …` line to [`build.bat`](../build.bat).
4. Update the version matrix in [build-and-load.md](build-and-load.md) and the README badges.

## Coding conventions

- C# `latest` lang version, x64 only, AnyCPU platform.
- `Core/` types must be pure C# (no `Autodesk.Revit.*`). This is what makes them unit-testable in `tests/TextCap.Test/`.
- All Revit-API calls live under `Api/` and `Commands/`.
- Each mutating operation owns its own `Transaction`.
