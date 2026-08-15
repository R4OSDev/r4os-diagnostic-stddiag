STDDIAG.R4X
===========

STDDIAG.R4X ist die R4STD-Diagnose.

Projektstruktur seit 0.51.21:
- `build.zig` baut die Diagnose als eigenes SDK-Projekt.
- `build.zig.zon` bindet `r4os_sdk` als Paket.
- `module.R4MF` beschreibt Artefakt, Zielpfad, R4L-Imports und Contract.

Build:

    cd Code\System\Diagnostics\StdDiag
    ..\..\..\DevTools\Zig\zig.exe build

Ergebnis:

    Code\System\Diagnostics\StdDiag\zig-out\STDDIAG.R4X

Contract:
- Build-Profil: `Zig/R4XStart`
- R4XStart-Entry: `stddiag_main`
- App-Klasse: `console`
- R4L-Imports: `R4SYS:Query:1`, `R4STD:DATE_V1:1`,
  `R4STD:TIME_V1:1`
- Zielpfad im Image: `C:\R4OS\SOFTWARE\TERMINAL\DIAG\STDDIAG.R4X`
