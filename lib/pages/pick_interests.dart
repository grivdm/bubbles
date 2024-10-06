import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:flame/game.dart';
import 'package:flutter/services.dart';

import 'package:bubbles/models.dart/picked_interest.dart';
import 'package:bubbles/widgets/interest_bubbles.dart';

class PickInterests extends StatefulWidget {
  const PickInterests({super.key});

  @override
  State<PickInterests> createState() => _PickInterestsState();
}

class _PickInterestsState extends State<PickInterests> {
  late InterestBubbles game;
  List<dynamic>? interestsJson;
  final List<PickedInterest> pickedInterests = [];

  @override
  void initState() {
    super.initState();
    loadGameData();
  }

  // Асинхронная загрузка данных
  Future<void> loadGameData() async {
    List<dynamic> jsonData = await loadJsonAsset();
    setState(() {
      interestsJson = jsonData;
      game = InterestBubbles(interestsJson!, pickedInterests, () {
        setState(() {});
      });
    });
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
          controller: ScrollController(
            initialScrollOffset: 350,
          ),
          scrollDirection: Axis.horizontal,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: 1000,
                color: Colors.green,
                alignment: Alignment.center,
                child: interestsJson == null
                    ? CircularProgressIndicator()
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

Future<List<dynamic>> loadJsonAsset() async {
  String jsonString = await rootBundle.loadString('assets/interests.json');
  List<dynamic> jsonData = json.decode(jsonString);
  return jsonData;
}
