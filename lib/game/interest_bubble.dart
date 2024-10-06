import 'dart:ui';

import 'package:bubbles/game/interest_bubble_content.dart';
import 'package:flame/events.dart';
import 'package:flame_forge2d/flame_forge2d.dart';
import 'package:flutter/services.dart';

import 'bubble.dart';
import 'package:bubbles/enums.dart';

class InterestBubble extends Bubble with ContactCallbacks, TapCallbacks {
  final Function() updateCallback;
  InterestStatus bubbleStatus;
  final Vector2 position;
  static Paint defaultFillColor = Paint()
    ..color = const Color.fromARGB(255, 255, 255, 255);
  static Paint selectedFillColor = Paint()..color = const Color(0x66E8DED1);
  @override
  Paint get borderColor => Paint()
    ..color = const Color(0x66A1A1A1)
    ..style = PaintingStyle.stroke
    ..strokeWidth = 1.0;
  @override
  Paint get itemColor => _currentColor;
  static const double _defaultRadius = 46.0;
  double get currentRadius => _defaultRadius;
  static const double _scaleFactorPressedOnce = 1.1;
  static const double _scaleFactorPressedTwice = 1.6;
  final String text;
  final String emoji;
  late InterestBubbleContent interestBubbleContent;
  double _lastTapTime = 0.0;
  static const double _doubleTapThreshold = 0.3;
  Paint _currentColor = defaultFillColor;

  InterestBubble(this.position, this.text, this.emoji,
      {this.bubbleStatus = InterestStatus.none, required this.updateCallback})
      : super(position: position, bodyType: BodyType.dynamic) {
    interestBubbleContent = InterestBubbleContent(
      text: text,
      emoji: emoji,
    );
  }

  void _updateBubbleStatus(InterestStatus newStatus) {
    bubbleStatus == newStatus
        ? bubbleStatus = InterestStatus.none
        : bubbleStatus = newStatus;
    // _pickedInterestListUpdate(text, bubbleStatus);
    updateCallback();
  }

  // void _pickedInterestListUpdate(String label, InterestStatus status) {
  //   FFAppState()
  //       .pickedInterestsState
  //       .removeWhere((element) => element.label == label);
  //   if (status != InterestStatus.none) {
  //     FFAppState()
  //         .pickedInterestsState
  //         .add(PickedInterestStruct(label: label, status: status.name));
  //   }
  // }

  @override
  Future<void> onLoad() async {
    add(interestBubbleContent);
    interestBubbleContent.scale = Vector2.zero();
    await super.onLoad();
  }

  @override
  bool containsLocalPoint(Vector2 point) {
    return point.distanceTo(Vector2.zero()) <= currentRadius;
  }

  void _handleSingleTap() {
    _updateBubbleStatus(InterestStatus.like);
  }

  void _handleDoubleTap() {
    _updateBubbleStatus(InterestStatus.love);
  }

  @override
  void onTapDown(TapDownEvent event) {
    HapticFeedback.selectionClick();
  }

  @override
  void onTapUp(TapUpEvent event) {
    if (bubbleStatus != InterestStatus.dislike) {
      final currentTime = DateTime.now().millisecondsSinceEpoch / 1000.0;
      if (currentTime - _lastTapTime < _doubleTapThreshold) {
        _handleDoubleTap();

        _lastTapTime = 0.0;
      } else {
        _handleSingleTap();
        _lastTapTime = currentTime;
      }
    }
  }

  @override
  void onLongTapDown(TapDownEvent event) {
    _updateBubbleStatus(InterestStatus.dislike);
  }

  @override
  void update(double dt) {
    super.update(dt);

    interestBubbleContent.scale = Vector2.all(animationProgress);
    interestBubbleContent.angle = -body.angle;

    switch (bubbleStatus) {
      case InterestStatus.none:
        interestBubbleContent.changeParametersByStatus(InterestStatus.none);
        _currentColor = defaultFillColor;
        setRadius(_defaultRadius);
        break;
      case InterestStatus.like:
        interestBubbleContent.changeParametersByStatus(InterestStatus.like);
        _currentColor = selectedFillColor;
        setRadius(_defaultRadius * _scaleFactorPressedOnce);
        break;
      case InterestStatus.love:
        interestBubbleContent.changeParametersByStatus(InterestStatus.love);
        _currentColor = selectedFillColor;
        setRadius(_defaultRadius * _scaleFactorPressedTwice);

        break;
      case InterestStatus.dislike:
        interestBubbleContent.changeParametersByStatus(InterestStatus.dislike);
        setRadius(_defaultRadius);
        _currentColor = defaultFillColor;
        break;
      default:
    }
  }
}
