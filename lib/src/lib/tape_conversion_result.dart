import 'dart:typed_data';

import 'tape_block_info.dart';

class TapeConversionResult {
  final Uint8List wavBytes;
  final List<TapeBlockInfo> blocks;
  final List<String> warnings;

  TapeConversionResult(this.wavBytes, this.blocks,
      {this.warnings = const []});
}
