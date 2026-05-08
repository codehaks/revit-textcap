# Roadmap

Loose backlog of ideas and known gaps. Not a commitment — listed here so contributors know what's already on the radar.

## Near-term

- **Modernise the test project.** [tests/TextCap.Test/](../tests/TextCap.Test/) is `packages.config`-style MSTest 2.2.10. Migrate to SDK-style with `<PackageReference>` so it builds with `dotnet test` instead of `vstest.console`.
- **Wire `Core/TextService.cs` into the test project.** The test project should reference `Shared.projitems` (excluding Revit-coupled files) so `TextConvert` is unit-testable end-to-end.
- **Better Sentence-case handling.** Current implementation only capitalises the first character of the whole string. Should split on sentence boundaries (`.`, `!`, `?`).

## Medium-term

- **Bundle packaging.** Ship a `.bundle` folder with `PackageContents.xml` so users can drop one folder into `%AppData%\Autodesk\ApplicationPlugins\` and pick up all three Revit-version variants automatically.
- **Pre-flight selection filter.** Use `ISelectionFilter` so `PickObject` only highlights `TextNote` elements (today the user can pick anything, and non-text picks are silently no-ops).
- **Localization.** Externalise UI strings ("Upper Case", "Text Cap" panel name) into `.resx` files.

## Long-term

- **Revit 2027 support.** Add `src/TextCap 2027/` once Autodesk publishes the SDK; the [developer guide](developer-guide.md#adding-a-new-revit-version) describes the steps.
- **CI build.** GitHub Actions matrix: `windows-latest` × {2024, 2025, 2026} → upload `dist/Revit <year>/` as artifacts.
