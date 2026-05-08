# Testing

TextCap ships with a small MSTest project at [tests/TextCap.Test/](../tests/TextCap.Test/).

## Existing test project

- **Framework:** MSTest 2.2.10
- **TFM:** `net48` (matches the 2024 build)
- **Scope:** Pure-C# tests against `TextCap.Core.TextConvert`. The test project does *not* reference `RevitAPI.dll` and cannot exercise selection, transactions, or text-note mutations.

To run:

```bat
msbuild tests\TextCap.Test\TextCap.Test.csproj /p:Configuration=Debug
vstest.console tests\TextCap.Test\bin\Debug\TextCap.Test.dll
```

(Alternatively, use the Visual Studio Test Explorer.)

## Unit-testable surface

The pure parts of the codebase are easy to cover here:

- `TextConvert.ToUpperCase / ToLowerCase / ToTitleCase / ToSentenceCase` — string transforms.

Add tests for edge cases as new cases are introduced (empty strings, single-character input, mixed-language strings, leading whitespace).

## Integration tests against Revit

Revit-API integration tests need to run **inside** a Revit process. Two practical options:

1. **`RevitTestFramework`** (community) — runs xUnit/NUnit tests inside a Revit instance.
2. **Manual smoke tests** — documented step list run before tagging a release. See [build-and-load.md](build-and-load.md#load-into-revit).

For now, the project relies on manual smoke tests against Revit 2024 / 2025 / 2026:

1. Build all three (`build.bat`).
2. Install each into the matching `%AppData%\Autodesk\Revit\Addins\<year>\` folder.
3. Open a sample project containing several `TextNote` elements (annotation view).
4. Select multiple notes → run **Codehaks ▸ Text Cap ▸ Upper Case** → confirm all selected notes uppercase, others untouched, single undo entry.
5. With nothing selected → run **Lower Case** → pick notes one by one → press **Esc** → confirm pick mode exits cleanly.
6. Repeat for Sentence and Title cases.
