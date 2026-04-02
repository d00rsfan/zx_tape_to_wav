# zx_tape_to_wav_x [![License Apache 2.0](https://img.shields.io/badge/license-Apache%20License%202.0-green.svg)](https://www.apache.org/licenses/LICENSE-2.0)

Flutter library to convert [.TAP/.TZX](https://documentation.help/BASin/format_tape.html) files (a data format for ZX-Spectrum emulator) into [sound WAV file](https://en.wikipedia.org/wiki/WAV). Maintained fork of [zx_tape_to_wav](https://pub.dev/packages/zx_tape_to_wav) with Generalized Data block support and Tapir analog audio filter.

## In Memory of Andriy S'omak

This library was created by [Andriy S'omak](https://github.com/semack), a talented developer and a passionate ZX Spectrum enthusiast. Andriy passed away on October 23, 2023, leaving behind this project and a community of people who shared his love for retro computing.

I am continuing the development and maintenance of this library in his memory.

## Usage

A simple usage example:
```dart
import 'dart:io';

import 'package:zx_tape_to_wav_x/zx_tape_to_wav_x.dart';

void main() async {
  await new File('assets/roms/test.tzx').readAsBytes().then((input) =>
      ZxTape.create(input)
          .then((tape) => tape.toWavBytes(
          frequency: 44100,
          progress: (percents) {
            print('progress => $percents');
          }))
          .then(
              (output) => new File('assets/out/tzx.wav').writeAsBytes(output)));
}
```

## Block metadata

Use `toWavBytesWithBlocks()` to get WAV audio together with block-level metadata (type, title, data length, time offset, duration):

```dart
final result = await tape.toWavBytesWithBlocks(frequency: 44100);
await File('out.wav').writeAsBytes(result.wavBytes);
for (final block in result.blocks) {
  print('${block.typeName}: ${block.title ?? ""} '
      '(offset: ${block.timeOffset}, duration: ${block.duration})');
}
```

## Contribute

Contributions are welcome! Please open an [Issue](https://github.com/d00rsfan/zx_tape_to_wav/issues) or submit a Pull Request.

For questions, bug reports, or feature requests, reach out through [GitHub Issues](https://github.com/d00rsfan/zx_tape_to_wav/issues).

## Thanks

- [Sergey Kireev](https://github.com/psk7) for the help on the WAV builder;
- [Mikie](https://www.alessandrogrussu.it/tapir/index.html) for his Tapir audio post-processing implementation;
- To everyone who contributes to keeping this project alive.
