import 'dart:async';
import 'dart:collection';

import 'package:flutter_tts/flutter_tts.dart';

/// A Text-to-Speech service with an internal queue.
///
/// Phrases added via [speak] are played one after another,
/// ensuring no two utterances overlap. Call [stop] to clear
/// the queue and immediately silence the engine.
final class TtsService {
  TtsService() {
    _init();
  }

  final FlutterTts _tts = FlutterTts();
  final Queue<String> _queue = Queue<String>();

  bool _isSpeaking = false;
  bool _isInitialized = false;

  Future<void> _init() async {
    await _tts.setLanguage('en-US');
    await _tts.setSpeechRate(0.5);
    await _tts.setVolume(1.0);
    await _tts.setPitch(1.0);

    _tts.setCompletionHandler(_onUtteranceComplete);
    _tts.setErrorHandler((message) {
      _isSpeaking = false;
      _processQueue();
    });

    _isInitialized = true;
  }

  /// Adds [text] to the speech queue.
  ///
  /// If nothing is currently playing the text starts immediately.
  Future<void> speak(String text) async {
    if (text.trim().isEmpty) return;
    _queue.addLast(text.trim());
    if (!_isSpeaking) {
      _processQueue();
    }
  }

  /// Stops playback immediately and clears the entire queue.
  Future<void> stop() async {
    _queue.clear();
    _isSpeaking = false;
    await _tts.stop();
  }

  /// Changes the language of the TTS engine (e.g. `'uk-UA'`, `'en-US'`).
  Future<void> setLanguage(String languageCode) async {
    await _tts.setLanguage(languageCode);
  }

  /// Changes the speech rate (0.0 – 1.0, default 0.5).
  Future<void> setSpeechRate(double rate) async {
    await _tts.setSpeechRate(rate);
  }

  /// Disposes the TTS engine. Call this when the service is no longer needed.
  Future<void> dispose() async {
    await stop();
  }

  void _onUtteranceComplete() {
    _isSpeaking = false;
    _processQueue();
  }

  Future<void> _processQueue() async {
    if (_isSpeaking || _queue.isEmpty) return;
    if (!_isInitialized) {
      await Future<void>.delayed(const Duration(milliseconds: 100));
      _processQueue();
      return;
    }

    final next = _queue.removeFirst();
    _isSpeaking = true;
    await _tts.speak(next);
  }
}
