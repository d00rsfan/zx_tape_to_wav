import 'blocks.dart';

class TapeBlockInfo {
  final int index;
  final String typeName;
  final String? title;
  final int? dataLength;
  final bool isHeader;
  final int sampleOffset;
  final Duration timeOffset;
  final Duration duration;

  TapeBlockInfo({
    required this.index,
    required this.typeName,
    this.title,
    this.dataLength,
    this.isHeader = false,
    required this.sampleOffset,
    required this.timeOffset,
    required this.duration,
  });

  factory TapeBlockInfo.fromBlock(
    BlockBase block,
    int index,
    int startSample,
    int endSample,
    int frequency, {
    String? groupName,
  }) {
    String typeName;
    String? title = groupName;
    int? dataLength;
    bool isHeader = false;

    if (block is DataBlock) {
      final data = block.data;
      isHeader = data.isNotEmpty && data[0] < 128;

      if (isHeader && data.length >= 12) {
        final headerType = data[1];
        final fileName = String.fromCharCodes(data.sublist(2, 12)).trimRight();
        final headerTypeName = _headerTypeName(headerType);
        typeName = headerTypeName;
        title = fileName;
      } else {
        typeName = 'Data';
      }
      dataLength = data.length;
    } else if (block is PureToneBlock) {
      typeName = 'Tone';
    } else if (block is PulseSequenceBlock) {
      typeName = 'Pulses';
    } else if (block is PauseOrStopTheTapeBlock) {
      typeName = 'Pause';
    } else if (block is GeneralizedDataBlock) {
      typeName = 'Data';
      dataLength = block.data.length;
    } else {
      typeName = 'Unknown';
    }

    final durationSamples = endSample - startSample;
    final timeOffsetUs = (startSample * 1000000) ~/ frequency;
    final durationUs = (durationSamples * 1000000) ~/ frequency;

    return TapeBlockInfo(
      index: index,
      typeName: typeName,
      title: title,
      dataLength: dataLength,
      isHeader: isHeader,
      sampleOffset: startSample,
      timeOffset: Duration(microseconds: timeOffsetUs),
      duration: Duration(microseconds: durationUs),
    );
  }

  static String _headerTypeName(int headerType) {
    switch (headerType) {
      case 0:
        return 'Program';
      case 1:
        return 'Number Array';
      case 2:
        return 'Character Array';
      case 3:
        return 'Code';
      default:
        return 'Header';
    }
  }
}
