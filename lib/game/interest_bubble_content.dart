import 'package:bubbles/enums.dart';
import 'package:flame/components.dart';
import 'package:flutter/material.dart';

class InterestBubbleContent extends PositionComponent {
  final String text;
  final String emoji;
  static const Color defaultTextColor = Color(0xff000000);
  static const Color selectedTextColor = Color(0xFFA34022);
  static const Color passiveTextColor = Color(0x66A1A1A1);

  late final TextComponent emojiComponent;
  late final TextComponent textComponent;

  InterestBubbleContent({
    required this.text,
    required this.emoji,
  }) {
    emojiComponent = TextComponent(
      text: emoji,
      textRenderer: TextPaint(
        style: const TextStyle(
          fontFamily: 'Inter',
          fontSize: 24,
        ),
      ),
      anchor: Anchor.center,
      position: Vector2(0, -12),
    );

    textComponent = TextComponent(
      text: text,
      textRenderer: TextPaint(
        style: const TextStyle(
            fontWeight: FontWeight.bold,
            fontFamily: 'Inter',
            fontSize: 12,
            color: defaultTextColor),
      ),
      anchor: Anchor.center,
      position: Vector2(0, 12),
    );
  }

  void _setTextColor(Color color) {
    textComponent.textRenderer = TextPaint(
      style: TextStyle(
        fontWeight: FontWeight.bold,
        fontFamily: 'Inter',
        color: color,
        fontSize: 12,
      ),
    );
  }

  void _iconVisibility(bool isVisible) {
    if (isVisible) {
      if (!children.contains(emojiComponent)) {
        add(emojiComponent);
      }
      textComponent.position = Vector2(0, 12);
    } else {
      if (children.contains(emojiComponent)) {
        remove(emojiComponent);
      }
      textComponent.position = Vector2(0, 0);
    }
  }

  void changeParametersByStatus(InterestStatus status) {
    switch (status) {
      case InterestStatus.like:
        _setTextColor(selectedTextColor);
        _iconVisibility(true);
        break;
      case InterestStatus.love:
        _setTextColor(selectedTextColor);
        _iconVisibility(true);
        break;
      case InterestStatus.none:
        _setTextColor(defaultTextColor);
        _iconVisibility(false);
        break;
      case InterestStatus.dislike:
        _setTextColor(passiveTextColor);
        _iconVisibility(false);
        break;
    }
  }

  @override
  Future<void> onLoad() async {
    add(emojiComponent);
    add(textComponent);
  }

  @override
  void render(Canvas canvas) {}

  @override
  void update(double dt) {
    super.update(dt);
  }
}
