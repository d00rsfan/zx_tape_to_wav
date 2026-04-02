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
