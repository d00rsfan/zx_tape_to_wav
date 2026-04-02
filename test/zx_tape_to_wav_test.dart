import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:zx_tape_to_wav_x/src/lib/enums.dart';
import 'package:zx_tape_to_wav_x/zx_tape_to_wav_x.dart';

void main() async {
  test('test tzx conversion', () async {
    await new File('example/assets/roms/test.tzx').readAsBytes().then((input) =>
        ZxTape.create(input)
            .then((tape) => tape.toWavBytes(
                audioFilterType: AudioFilterType.none,
                frequency: 44100,
                progress: (percents) {
                  print('progress => $percents');
                }))
            .then((output) =>
                new File('example/assets/out/tzx.wav').writeAsBytes(output)));
  });
  test('test tap conversion', () async {
    await new File('example/assets/roms/test.tap').readAsBytes().then((input) =>
        ZxTape.create(input)
            .then((tape) => tape.toWavBytes(
                frequency: 44100,
                audioFilterType: AudioFilterType.heuristic,
                progress: (percents) {
                  print('progress => $percents');
                }))
            .then((output) =>
                new File('example/assets/out/tap.wav').writeAsBytes(output)));
  });

  test('test block info from tap', () async {
    var input = await File('example/assets/roms/test.tap').readAsBytes();
    var tape = await ZxTape.create(input);
    var result = await tape.toWavBytesWithBlocks(
      frequency: 44100,
      audioFilterType: AudioFilterType.bassBoost,
    );
    print('Total blocks: ${result.blocks.length}');
    print('WAV bytes: ${result.wavBytes.length}');
    for (var b in result.blocks) {
      print('Block ${b.index}: type=${b.typeName}, title=${b.title}, '
          'sampleOffset=${b.sampleOffset}, timeOffset=${b.timeOffset}, '
          'duration=${b.duration}, dataLen=${b.dataLength}, isHeader=${b.isHeader}');
    }
    expect(result.blocks.isNotEmpty, true);
    // Verify offsets are monotonically increasing
    for (var i = 1; i < result.blocks.length; i++) {
      expect(result.blocks[i].sampleOffset >= result.blocks[i - 1].sampleOffset, true,
          reason: 'Block ${i} offset should be >= block ${i - 1} offset');
    }
    // Verify first block starts at 0
    expect(result.blocks.first.sampleOffset, 0);
    // Verify last block doesn't exceed WAV data (WAV has 44-byte header)
    var totalAudioSamples = result.wavBytes.length - 44;
    expect(result.blocks.last.sampleOffset < totalAudioSamples, true,
        reason: 'Last block offset should be within WAV audio data');
  });
}
