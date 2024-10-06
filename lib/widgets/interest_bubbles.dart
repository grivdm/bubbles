import 'package:flame_forge2d/flame_forge2d.dart';
import 'package:flutter/material.dart';

import 'package:bubbles/enums.dart';
import 'package:bubbles/game/Interest_bubble.dart';
import 'package:bubbles/game/walls.dart';
import 'package:bubbles/models.dart/interest.dart';
import 'package:bubbles/models.dart/picked_interest.dart';

class InterestBubbles extends Forge2DGame {
  final Function() updateCallback;
  final dynamic interests;
  final List<PickedInterest> pickedInterests;

  @override
  Color backgroundColor() => Colors.white;
  InterestBubbles(this.interests, this.pickedInterests, this.updateCallback)
      : super(gravity: Vector2(0, 10));

  @override
  Future<void>? onLoad() {
    final boundaries = createBoundaries(this);
    for (var element in boundaries) {
      add(element);
    }

    parseJson(interests).then((interestList) {
      const int numColumns = 8;
      const double spacingX = 105.0;
      const double spacingY = 105.0;

      final int numRows = (interestList.length / numColumns).ceil();

      final double offsetX = (size.x - (numColumns - 1) * spacingX) / 2;
      final double offsetY = (size.y - (numRows - 1) * spacingY) / 2;

      for (var i = 0; i < interestList.length; i++) {
        String? pickedInterestStatus = pickedInterests
            .where((e) => e.label == interestList[i].name)
            .firstOrNull
            ?.status;

        InterestStatus bubbleStatus = {
              'like': InterestStatus.like,
              'love': InterestStatus.love,
              'dislike': InterestStatus.dislike,
            }[pickedInterestStatus] ??
            InterestStatus.none;

        int row = i ~/ numColumns;
        int column = i % numColumns;

        double x = offsetX + column * spacingX;
        double y = offsetY + row * spacingY;

        final bubble = InterestBubble(
            Vector2(x, y), interestList[i].name, interestList[i].icon,
            bubbleStatus: bubbleStatus, updateCallback: updateCallback);
        add(bubble);
      }
    });
    return null;
  }
}

List<Wall> createBoundaries(Forge2DGame game) {
  final screenSize = game.size;
  final topLeft = Vector2.zero();
  final bottomRight = Vector2(screenSize.x, screenSize.y);
  final topRight = Vector2(bottomRight.x, topLeft.y);
  final bottomLeft = Vector2(topLeft.x, bottomRight.y);

  return [
    Wall(topLeft, topRight),
    Wall(topRight, bottomRight),
    Wall(bottomRight, bottomLeft),
    Wall(bottomLeft, topLeft),
  ];
}

Future<List<Interest>> parseJson(json) async {
  final List<dynamic> interestsList = json as List<dynamic>;

  List<Interest> interests = interestsList.map((interest) {
    return Interest.fromJson(interest as Map<String, dynamic>);
  }).toList();

  return interests;
}
