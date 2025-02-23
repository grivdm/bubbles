import 'dart:convert';

import 'package:bubbles/models/interest.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:flame/game.dart';
import 'package:flutter/services.dart';

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
      final List<Interest> jsonData = await getInterestsFromAssets();
      if (mounted) {
        setState(() {
          interestsList = jsonData;
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
        color: Colors.white,
        alignment: Alignment.center,
        child: SingleChildScrollView(
          controller: _scrollController,
          scrollDirection: Axis.horizontal,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: 1000,
                color: Colors.green,
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

Future<List<Interest>> getInterestsFromAssets() async {
  String jsonString = await rootBundle.loadString('assets/interests.json');
  List<dynamic> jsonData = jsonDecode(jsonString);
  return jsonData.map((e) => Interest.fromJson(e)).toList();
}
