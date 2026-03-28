import 'dart:io';
import 'dart:math' as math;

import 'package:flutter/foundation.dart';
import 'package:image/image.dart' as img;
import 'package:tflite_flutter/tflite_flutter.dart';

final class UiDetectionService {
  static const String _modelAssetPath = 'assets/best_float32.tflite';
  static const double _confidenceThreshold = 0.25;
  static const double _nmsThreshold = 0.45;
  static const List<String> _labels = <String>[
    'Action Bar',
    'BackgroundImage',
    'Bottom_Navigation',
    'Button',
    'Button-Outlined',
    'Button-filled',
    'Call to Action',
    'Card',
    'CheckBox',
    'Checkbox-Checked',
    'Checkbox-UnChecked',
    'CheckedTextView',
    'Chips',
    'Consistency',
    'Contrast',
    'Drawer',
    'DropDown',
    'EditText',
    'Header with Title',
    'Horizontal Alignment',
    'Icon',
    'Icon as Visual Metaphor',
    'Icon with Label',
    'Icon-Button',
    'Image',
    'ImageButton',
    'ImageView',
    'In Focus Popup',
    'Input',
    'Link',
    'List Item',
    'Map',
    'Meaningful Placeholder Text',
    'Modal',
    'Multi_Tab',
    'On-Off Switch',
    'PageIndicator',
    'Profile-image',
    'ProgressBar',
    'Proximity',
    'RadioButton',
    'RatingBar',
    'SeekBar',
    'Slider',
    'Spinner',
    'Switch',
    'Text',
    'Text Button',
    'Text-Input',
    'TextButton',
    'TextView',
    'Toggle-Checked',
    'Toggle-Unchecked',
    'Toolbar',
    'UpperTaskBar',
    'Video',
    'Visual Cue - Horizontal Scroll',
    'Visual Cue - Tap',
    'button',
    'field',
    'link',
  ];

  Interpreter? _interpreter;

  Future<UiDetectionResult> predictFromScreenshotFile(
    String screenshotPath,
  ) async {
    final screenshotBytes = await File(screenshotPath).readAsBytes();
    return predictFromScreenshot(screenshotBytes);
  }

  Future<UiDetectionResult> predictFromScreenshot(Uint8List screenshotBytes) async {
    final interpreter = await _loadInterpreter();
    final decodedImage = img.decodeImage(screenshotBytes);
    if (decodedImage == null) {
      throw ArgumentError('Unsupported screenshot format.');
    }

    final inputTensor = interpreter.getInputTensor(0);
    final inputShape = inputTensor.shape;
    debugPrint(
      'TFLite input tensor shape: $inputShape, type: ${inputTensor.type}',
    );

    final preprocessedInput = _preprocessImage(
      image: decodedImage,
      inputShape: inputShape,
    );

    final outputTensor = interpreter.getOutputTensor(0);
    final outputShape = outputTensor.shape;
    debugPrint(
      'TFLite output tensor shape: $outputShape, type: ${outputTensor.type}',
    );

    final outputBuffer = Float32List(_elementCount(outputShape));
    final outputBytes = Uint8List.view(outputBuffer.buffer);

    interpreter.run(preprocessedInput.buffer, outputBytes.buffer);

    final detections = _parseDetections(
      outputBuffer: outputBuffer,
      outputShape: outputShape,
      imageWidth: decodedImage.width.toDouble(),
      imageHeight: decodedImage.height.toDouble(),
    );

    return UiDetectionResult(
      inputShape: inputShape,
      outputShape: outputShape,
      imageWidth: decodedImage.width,
      imageHeight: decodedImage.height,
      detections: detections,
    );
  }

  Future<void> dispose() async {
    _interpreter?.close();
    _interpreter = null;
  }

  Future<Interpreter> _loadInterpreter() async {
    final cachedInterpreter = _interpreter;
    if (cachedInterpreter != null) {
      return cachedInterpreter;
    }

    final options = InterpreterOptions()..threads = 2;
    final interpreter = await Interpreter.fromAsset(
      _modelAssetPath,
      options: options,
    );
    _interpreter = interpreter;
    return interpreter;
  }

  Float32List _preprocessImage({
    required img.Image image,
    required List<int> inputShape,
  }) {
    if (inputShape.length != 4 || inputShape[0] != 1) {
      throw StateError('Unexpected input tensor shape: $inputShape');
    }

    final isChannelFirst =
        inputShape[1] == 3 && inputShape[2] > 0 && inputShape[3] > 0;
    final isChannelLast =
        inputShape[3] == 3 && inputShape[1] > 0 && inputShape[2] > 0;

    if (!isChannelFirst && !isChannelLast) {
      throw StateError('Unsupported input tensor layout: $inputShape');
    }

    final inputChannels = 3;
    final inputHeight = isChannelFirst ? inputShape[2] : inputShape[1];
    final inputWidth = isChannelFirst ? inputShape[3] : inputShape[2];

    final resized = img.copyResize(
      image,
      width: inputWidth,
      height: inputHeight,
      interpolation: img.Interpolation.linear,
    );

    final inputBuffer = Float32List(inputWidth * inputHeight * inputChannels);

    for (var y = 0; y < inputHeight; y++) {
      for (var x = 0; x < inputWidth; x++) {
        final pixel = resized.getPixel(x, y);
        final pixelIndex = y * inputWidth + x;

        if (isChannelFirst) {
          inputBuffer[pixelIndex] = pixel.r / 255.0;
          inputBuffer[inputWidth * inputHeight + pixelIndex] =
              pixel.g / 255.0;
          inputBuffer[2 * inputWidth * inputHeight + pixelIndex] =
              pixel.b / 255.0;
        } else {
          final offset = pixelIndex * inputChannels;
          inputBuffer[offset] = pixel.r / 255.0;
          inputBuffer[offset + 1] = pixel.g / 255.0;
          inputBuffer[offset + 2] = pixel.b / 255.0;
        }
      }
    }

    return inputBuffer;
  }

  List<UiDetection> _parseDetections({
    required Float32List outputBuffer,
    required List<int> outputShape,
    required double imageWidth,
    required double imageHeight,
  }) {
    if (outputShape.length != 3 || outputShape[0] != 1) {
      throw StateError('Unexpected output tensor shape: $outputShape');
    }

    final dimensionA = outputShape[1];
    final dimensionB = outputShape[2];
    final isChannelFirstLayout = dimensionA == _labels.length + 4;
    final candidateCount = isChannelFirstLayout ? dimensionB : dimensionA;
    final valuesPerCandidate = isChannelFirstLayout ? dimensionA : dimensionB;

    if (valuesPerCandidate < _labels.length + 4) {
      throw StateError(
        'Model output does not contain enough values for ${_labels.length} classes.',
      );
    }

    final detections = <UiDetection>[];
    for (var candidateIndex = 0; candidateIndex < candidateCount; candidateIndex++) {
      final values = _readCandidateValues(
        outputBuffer: outputBuffer,
        isChannelFirstLayout: isChannelFirstLayout,
        candidateIndex: candidateIndex,
        valuesPerCandidate: valuesPerCandidate,
        candidateCount: candidateCount,
      );

      final maxClass = _findMaxClass(values, startIndex: 4);
      if (maxClass.score < _confidenceThreshold) {
        continue;
      }

      final rect = _toRect(
        centerX: values[0],
        centerY: values[1],
        width: values[2],
        height: values[3],
        imageWidth: imageWidth,
        imageHeight: imageHeight,
      );

      if (rect.width <= 0 || rect.height <= 0) {
        continue;
      }

      detections.add(
        UiDetection(
          label: _labels[maxClass.index],
          confidence: maxClass.score,
          left: rect.left,
          top: rect.top,
          right: rect.right,
          bottom: rect.bottom,
        ),
      );
    }

    return _applyNonMaximumSuppression(detections);
  }

  Float32List _readCandidateValues({
    required Float32List outputBuffer,
    required bool isChannelFirstLayout,
    required int candidateIndex,
    required int valuesPerCandidate,
    required int candidateCount,
  }) {
    final values = Float32List(valuesPerCandidate);
    for (var valueIndex = 0; valueIndex < valuesPerCandidate; valueIndex++) {
      final flatIndex = isChannelFirstLayout
          ? valueIndex * candidateCount + candidateIndex
          : candidateIndex * valuesPerCandidate + valueIndex;
      values[valueIndex] = outputBuffer[flatIndex];
    }
    return values;
  }

  _ClassScore _findMaxClass(Float32List values, {required int startIndex}) {
    var bestClassIndex = 0;
    var bestScore = values[startIndex];

    for (var valueIndex = startIndex + 1; valueIndex < values.length; valueIndex++) {
      if (values[valueIndex] > bestScore) {
        bestScore = values[valueIndex];
        bestClassIndex = valueIndex - startIndex;
      }
    }

    return _ClassScore(index: bestClassIndex, score: bestScore);
  }

  _Rect _toRect({
    required double centerX,
    required double centerY,
    required double width,
    required double height,
    required double imageWidth,
    required double imageHeight,
  }) {
    const inputWidth = 640.0;
    const inputHeight = 640.0;
    final scaleX = imageWidth / inputWidth;
    final scaleY = imageHeight / inputHeight;
    final left = (centerX - width / 2) * scaleX;
    final top = (centerY - height / 2) * scaleY;
    final right = (centerX + width / 2) * scaleX;
    final bottom = (centerY + height / 2) * scaleY;

    return _Rect(
      left: left.clamp(0.0, imageWidth).toDouble(),
      top: top.clamp(0.0, imageHeight).toDouble(),
      right: right.clamp(0.0, imageWidth).toDouble(),
      bottom: bottom.clamp(0.0, imageHeight).toDouble(),
    );
  }

  List<UiDetection> _applyNonMaximumSuppression(List<UiDetection> detections) {
    final sortedDetections = detections.toList()
      ..sort((left, right) => right.confidence.compareTo(left.confidence));

    final keptDetections = <UiDetection>[];
    for (final detection in sortedDetections) {
      final overlapsExisting = keptDetections.any(
        (kept) =>
            kept.label == detection.label &&
            _intersectionOverUnion(kept.rect, detection.rect) > _nmsThreshold,
      );

      if (!overlapsExisting) {
        keptDetections.add(detection);
      }
    }

    return keptDetections;
  }

  double _intersectionOverUnion(_Rect first, _Rect second) {
    final overlapLeft = math.max(first.left, second.left);
    final overlapTop = math.max(first.top, second.top);
    final overlapRight = math.min(first.right, second.right);
    final overlapBottom = math.min(first.bottom, second.bottom);

    final overlapWidth = math.max(0.0, overlapRight - overlapLeft);
    final overlapHeight = math.max(0.0, overlapBottom - overlapTop);
    final intersectionArea = overlapWidth * overlapHeight;

    if (intersectionArea == 0) {
      return 0;
    }

    final unionArea = first.area + second.area - intersectionArea;
    if (unionArea <= 0) {
      return 0;
    }

    return intersectionArea / unionArea;
  }

  int _elementCount(List<int> shape) {
    return shape.fold(1, (result, value) => result * value);
  }
}

@immutable
final class UiDetectionResult {
  const UiDetectionResult({
    required this.inputShape,
    required this.outputShape,
    required this.imageWidth,
    required this.imageHeight,
    required this.detections,
  });

  final List<int> inputShape;
  final List<int> outputShape;
  final int imageWidth;
  final int imageHeight;
  final List<UiDetection> detections;

  bool get hasDetections => detections.isNotEmpty;

  String get summaryText {
    if (detections.isEmpty) {
      return 'No UI elements detected.';
    }

    final counts = <String, int>{};
    final topConfidence = <String, double>{};

    for (final detection in detections) {
      counts.update(detection.label, (value) => value + 1, ifAbsent: () => 1);
      topConfidence.update(
        detection.label,
        (value) => math.max(value, detection.confidence),
        ifAbsent: () => detection.confidence,
      );
    }

    final sortedEntries = counts.keys.toList()
      ..sort((left, right) {
        final rightConfidence = topConfidence[right] ?? 0;
        final leftConfidence = topConfidence[left] ?? 0;
        return rightConfidence.compareTo(leftConfidence);
      });

    return sortedEntries.map((label) {
      final count = counts[label] ?? 0;
      final confidence = ((topConfidence[label] ?? 0) * 100).toStringAsFixed(1);
      return '$label x$count ($confidence%)';
    }).join(', ');
  }

  String toLogString() {
    final buffer = StringBuffer()
      ..writeln(
        'UiDetectionResult(inputShape: $inputShape, outputShape: $outputShape, imageSize: ${imageWidth}x$imageHeight)',
      );

    if (detections.isEmpty) {
      buffer.write('No UI elements detected.');
      return buffer.toString();
    }

    for (var index = 0; index < detections.length; index++) {
      final detection = detections[index];
      buffer.writeln(
        '#$index ${detection.label} '
        'confidence=${(detection.confidence * 100).toStringAsFixed(2)}% '
        'bbox=(${detection.left.toStringAsFixed(1)}, ${detection.top.toStringAsFixed(1)}, '
        '${detection.right.toStringAsFixed(1)}, ${detection.bottom.toStringAsFixed(1)}) '
        'size=${detection.width.toStringAsFixed(1)}x${detection.height.toStringAsFixed(1)}',
      );
    }

    return buffer.toString().trimRight();
  }
}

@immutable
final class UiDetection {
  const UiDetection({
    required this.label,
    required this.confidence,
    required this.left,
    required this.top,
    required this.right,
    required this.bottom,
  });

  final String label;
  final double confidence;
  final double left;
  final double top;
  final double right;
  final double bottom;

  _Rect get rect => _Rect(
    left: left,
    top: top,
    right: right,
    bottom: bottom,
  );

  double get width => right - left;
  double get height => bottom - top;
}

@immutable
final class _Rect {
  const _Rect({
    required this.left,
    required this.top,
    required this.right,
    required this.bottom,
  });

  final double left;
  final double top;
  final double right;
  final double bottom;

  double get width => right - left;
  double get height => bottom - top;
  double get area => width * height;
}

@immutable
final class _ClassScore {
  const _ClassScore({required this.index, required this.score});

  final int index;
  final double score;
}
