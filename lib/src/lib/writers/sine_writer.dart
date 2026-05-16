import 'dart:math';

import '../definitions.dart';
import 'binary_writer.dart';

/// Replaces each rectangular half-period coming from [WavBuilder] with a
/// half-sine arc of the same duration. Amplitude crosses zero at every pulse
/// boundary, so a run of equal-length pulses (e.g. the pilot tone) becomes a
/// mathematically clean sine — eliminating the odd-harmonic content of a
/// square wave.
class SineWriter extends BinaryWriter {
  bool _seriesVal = false;
  int _seriesLen = 0;

  SineWriter();

  @override
  void writeSample(int sample) {
    var bsv = sample == Definitions.signalValue;

    if (bsv == _seriesVal) {
      _seriesLen++;
      return;
    }

    _flush();

    _seriesVal = bsv;
    _seriesLen = 1;
  }

  void _flush() {
    if (_seriesLen <= 0) return;
    var sign = _seriesVal ? 1.0 : -1.0;
    for (var i = 0; i < _seriesLen; i++) {
      var s = sign * sin(pi * i / _seriesLen);
      var v = (s * Definitions.signalValue).round();
      super.writeSample(v);
    }
    _seriesLen = 0;
  }

  @override
  void flush() {
    _flush();
    super.flush();
  }
}
