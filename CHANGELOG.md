## 1.1.0

- Handle corrupted TAP files with zero-length data blocks instead of crashing
- Add `warnings` field to `TapeConversionResult` — callers can check for tape corruption after conversion
- `WavBuilder` now collects warnings during WAV generation (e.g. `Block #N has empty data`)

## 1.0.1

- Fix 17 static analysis issues flagged by pub.dev (lints/core.yaml)
- Add `analysis_options.yaml` with `package:lints/core.yaml`
- Add `lints` as dev dependency

## 1.0.0

Maintained fork of [zx_tape_to_wav](https://pub.dev/packages/zx_tape_to_wav).
Includes all features from the original up to version 3.1.0:

- Generalized Data block support
- Tapir analog audio filter implementation
- Bass boost audio filter
- Null-safety
- SpeedLock 2 support

New in this release:

- `toWavBytesWithBlocks()` — returns `TapeConversionResult` with WAV bytes and a list of `TapeBlockInfo` metadata (block type, title, data length, sample offset, time offset, duration)
- `TapeBlockInfo` and `TapeConversionResult` exported from the public API

Dependencies:

- Dart SDK bumped to >=3.0.0 <4.0.0, Flutter to >=3.0.0
- `test` dependency bumped to ^1.30.0
