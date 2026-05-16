## 1.2.0

- Add `AudioFilterType.sine` — harmonic-clean output that replaces every rectangular half-period with a half-sine arc of the same duration. Runs of equal-length pulses (e.g. pilot tone) become a mathematically clean sine wave, eliminating the odd-harmonic content of a square wave. Reduces speaker buzz and improves recording fidelity when writing back to magnetic tape (linear region of the B-H curve, no saturation transients at edges).
- Fix block metadata offsets in `toWavBytesWithBlocks()` for buffered audio filters (`tapir`, `sine`). Previously `TapeBlockInfo.sampleOffset` / `duration` were computed from the writer's emitted byte count, which lags behind logical sample position for filters that buffer same-level series. Now tracked via a sample counter in `WavBuilder`, accurate for all filters.
- Fix off-by-one byte at the start of every WAV produced with `tapir` or `sine` filter (phantom initial-state sample). `_seriesLen` initialization corrected; final WAV size now matches the logical sample count exactly.
- Make `flush()` idempotent in `SineWriter` and `TapirWriter`.

**Note for consumers using exhaustive `switch` expressions on `AudioFilterType`:** add a `case AudioFilterType.sine` (or a wildcard) — the new enum value is source-breaking under Dart 3 exhaustiveness checking.

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
