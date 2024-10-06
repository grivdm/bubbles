import 'dart:ui';
import 'package:bubbles/game/walls.dart';
import 'package:flame_forge2d/flame_forge2d.dart';
import 'package:flutter/animation.dart';

abstract class Bubble extends BodyComponent {
  final Vector2 position;
  double _currentRadius = 0.0;

  /// The color of the bubble.
  Paint get itemColor;

  /// The color of the border of the bubble.
  Paint get borderColor;

  /// The progress of the bubble's appearance animation.
  double animationProgress = 0.0;
  double animationTime = 0.0;
  double animationDuration = 0.5;
  BodyType bodyType;

  Bubble({required this.position, required this.bodyType});

  @override
  Future<void> onLoad() async {
    _currentRadius = 0.0;
    await super.onLoad();
  }

  @override
  void render(Canvas canvas) {
    canvas.save();
    canvas.scale(animationProgress);
    canvas.drawCircle(Offset.zero, _currentRadius, borderColor);
    super.render(canvas);
    canvas.restore();
  }

  @override
  void update(double dt) {
    super.update(dt);
    paint = itemColor;
    animateAppearance(dt);
  }

  void animateAppearance(double dt) {
    if (animationProgress < 1.0) {
      animationTime += dt;
      double t = (animationTime / animationDuration).clamp(0.0, 1.0);
      animationProgress = Curves.easeOut.transform(t);
    }
  }

  void beginContact(Object other, Contact contact) {
    if (other is Wall) {
      body.applyForce(Vector2.random() * 1000000);
    }
    if (other is Bubble) {
      body.applyLinearImpulse(Vector2.random() * 5000);
    }
  }

  void setRadius(double radius) {
    body.destroyFixture(body.fixtures.first);
    final shape = CircleShape();
    shape.radius = radius;
    final fixtureDef = FixtureDef(
      shape,
      restitution: 0.8,
      density: 200.0,
      friction: 0.4,
    );
    body.createFixture(fixtureDef);
    _currentRadius = radius;
  }

  @override
  Body createBody() {
    return createBodyWithRadius(_currentRadius);
  }

  Body createBodyWithRadius(double radius) {
    final shape = CircleShape()..radius = radius;
    final fixtureDef = FixtureDef(
      shape,
      restitution: 0.8,
      density: 100.0,
      friction: 0.4,
    );
    final bodyDef = BodyDef(
      userData: this,
      position: position,
      type: bodyType,
    );
    return world.createBody(bodyDef)..createFixture(fixtureDef);
  }
}
