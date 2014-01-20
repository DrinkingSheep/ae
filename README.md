# AE

AE - VN Tools is a multipurpose utility for working with common Visual Novel
and game archive, image and misc data formats.

AE is written in Delphi 7 from scratch.

It includes:

* Archiver tool
* EDGE - image manipulation/conversion tool
* GrapS - RAW image data reader
* Data processing tool

Win32 binaries: http://wks.arai-kibou.ru/ae.php?p=dl

Online manual: http://wks.arai-kibou.ru/ae.php?p=docu

## How to compile:

Install the following visual design components:

* src/lib/_jiskit/Unicode components/jiskit_tlabelw.dpk
* src/lib/_jiskit/Unicode dialogs/jiskit_udialogs.dpk
* src/lib/credits/credits.pas
* src/lib/PercentCube.pas

Next, open /src/AnimEd.dpr.

You'll also need the latest version of JVCL/JCL (Project JEDI).

## If application's interface differs from English on the first run:

* Click on the third tab from the right end and switch to the one you need.

or

* Remove all unwanted .lang files from application's directory.
