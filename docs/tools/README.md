# Website reference data

The site is static HTML, CSS and JavaScript. No package installation or build is required for GitHub Pages. Serve the repository's `docs` directory to preview it locally.

`assets/catalog.json` is generated from `source/uSMBIOS.pas` and the sample links in the repository README. From the repository root, run:

```sh
node docs/tools/build-reference.cjs
```

The generator carries the category descriptions and selected logical relationships. Review those mappings when adding library support. Field descriptions and signatures come from the MPL-2.0 library source; see the repository LICENSE.md. The common SMBIOS header is not counted among each structure's fields. This catalog describes declarations, not a guarantee that all optional or variable-layout data is present or fully decoded on every machine.

`assets/memory-sample.json` was produced by running TSMBIOS against the `SMBIOS_Sample_3_2_Base64` demonstration fixture in `testing/LoadSMBIOSDump.dpr`. It is sample data, not visitor telemetry. The fixture contains four memory device records; their parent array declares six devices. These values are intentionally preserved. Configured speed zero is displayed as unknown, and missing strings as not reported.

To regenerate it, extract the fixture to a temporary file:

```sh
node docs/tools/extract-fixture.cjs <temporary-folder>/sample.bin
```

Compile `ExportMemorySample.dpr` with a modern Delphi compiler, the `System`, `Winapi` and `System.Win` unit scopes, and `DISABLEWMI`. Send executable and DCU outputs to a temporary directory. Run the resulting executable with the fixture and destination JSON paths as its two arguments:

```sh
ExportMemorySample.exe <temporary-folder>/sample.bin docs/assets/memory-sample.json
```

The exporter uses `TSMBios.Create(False)` and reads only that file. It does not inspect the current computer. Check the generated values and labels in the memory walkthrough after regenerating.
