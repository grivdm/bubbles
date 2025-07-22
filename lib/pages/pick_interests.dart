import 'package:bubbles/models/interest.dart';
import 'package:bubbles/theme/app_colors.dart';
import 'package:bubbles/utils/get_interests_from_assests.dart';
import 'package:flutter/material.dart';
import 'package:flame/game.dart';

import 'package:bubbles/models/picked_interest.dart';
import 'package:bubbles/widgets/interest_bubbles.dart';

class PickInterests extends StatefulWidget {
  const PickInterests({super.key});

  @override
  State<PickInterests> createState() => _PickInterestsState();
}

class _PickInterestsState extends State<PickInterests> {
  late InterestBubbles game;
  List<Interest>? interestsList;
  final List<PickedInterest> pickedInterests = [];

  final ScrollController _scrollController = ScrollController(
    initialScrollOffset: 350,
  );

  @override
  void initState() {
    super.initState();
    loadGameData();
  }

  Future<void> loadGameData() async {
    try {
      final List<Interest> _interestsList = await getInterestsFromAssets();
      if (mounted) {
        setState(() {
          interestsList = _interestsList;
          game = InterestBubbles(interestsList!, pickedInterests, () {
            if (mounted) setState(() {});
          });
        });
      }
    } catch (e) {
      debugPrint('Error loading game data: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Pick your interests'),
      ),
      body: Container(
        alignment: Alignment.center,
        child: SingleChildScrollView(
          controller: _scrollController,
          scrollDirection: Axis.horizontal,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: 1500,
                alignment: Alignment.center,
                child: interestsList == null
                    ? const CircularProgressIndicator()
                    : GameWidget(
                        game: game,
                      ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
