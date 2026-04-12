# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project

Dart/Flutter library that converts ZX Spectrum `.TAP` and `.TZX` tape image files into `.WAV` audio files. Published to pub.dev as `zx_tape_to_wav_x` (maintained fork of `zx_tape_to_wav`).

## Commands

```bash
flutter pub get          # Install dependencies
flutter test             # Run all tests
flutter test --name 'test tzx conversion'  # Run a single test by name
```

## Architecture

**Data flow:** TAP/TZX bytes → `ZxTape.create()` → block parsing → `toWavBytes()` → `WavBuilder` → audio filter writer → WAV bytes with RIFF header.

**Key layers:**

- **`ZxTape`** (`lib/src/zx_tape.dart`) — Public facade. Factory `create()` detects tape type (TAP vs TZX via magic bytes), `toWavBytes()` orchestrates conversion. Blocks are lazily parsed.
- **Block hierarchy** (`lib/src/lib/blocks.dart`) — `BlockBase` subclasses model 17+ TZX block types (standard/turbo/pure data, tones, pulses, loops, generalized data, metadata). Each block type maps to a TZX block ID.
- **`WavBuilder`** (`lib/src/lib/wav_builder.dart`) — Synthesizes audio samples from blocks. Manages CPU/sound time synchronization via LCM. Handles loop/jump control blocks. Generates RIFF WAV headers.
- **Audio filters** (`lib/src/lib/writers/`) — Strategy pattern with `BinaryWriter` (no filter), `BassBoostWriter` (IIR biquad at 250Hz/20dB), and `TapirWriter` (analog microphone circuit simulation based on Tapir 1.0). `AudioFilterType.heuristic` auto-selects Tapir for generalized data blocks, otherwise BassBoost.

## Pre-publish checklist

Run these steps after any code changes before publishing to pub.dev:

```bash
flutter analyze lib/          # Must show "No issues found" (uses lints/core.yaml)
flutter test                  # All tests must pass
flutter pub publish --dry-run # Verify package is ready for publishing
```

The `analysis_options.yaml` includes `package:lints/core.yaml` — the same ruleset pub.dev uses for scoring. Any lint violations will cost points on pub.dev.

## Conventions

- Dart 3 (SDK >=3.0.0 <4.0.0)
- Uses Flutter's `ReadBuffer` for binary parsing
- Tests are integration-style: full conversion pipeline writing output WAV files to `example/assets/out/`
- Test fixtures (`.tap`/`.tzx` files) live in `example/assets/roms/`