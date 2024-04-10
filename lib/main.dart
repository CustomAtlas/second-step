import 'package:flutter/material.dart';
import 'package:second_step/user/list.dart';
import 'package:second_step/user/model.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ModelProvider(
      model: Model(),
      child: const MaterialApp(
        debugShowCheckedModeBanner: false,
        home: ListWidget(),
      ),
    );
  }
}
