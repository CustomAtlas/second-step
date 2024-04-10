import 'package:flutter/material.dart';
import 'package:second_step/user/info.dart';
import 'package:second_step/user/list.dart';
import 'package:shared_preferences/shared_preferences.dart';

class User {
  final String userName;
  final String secName;
  final String firstName;
  final String number;
  const User({
    required this.userName,
    required this.secName,
    required this.firstName,
    required this.number,
  });
}

class Model extends ChangeNotifier {
  final controllerName = TextEditingController();
  final controllerSec = TextEditingController();
  final controllerFirst = TextEditingController();
  final controllerNum = TextEditingController();

  var userName = '';
  var secName = '';
  var firstName = '';
  var number = '';

  var keys = <String>[];
  var users = <User>[];

  var canEdit = false;

  String? _errorMessage;
  String? get errorMessage => _errorMessage;

  Model() {
    setup();
  }

  Future<void> saveUsersInList() async {
    final prefs = await SharedPreferences.getInstance();
    users.clear();
    for (var i = 0; i < keys.length; i++) {
      final field = prefs.getStringList(keys[i]);
      users.add(
        User(
          userName: field![0],
          secName: field[1],
          firstName: field[2],
          number: field[3],
        ),
      );
    }
  }

  Future<void> setup() async {
    final prefs = await SharedPreferences.getInstance();
    keys.clear();
    keys.addAll(prefs.getKeys().toList());
    saveUsersInList();
    notifyListeners();
  }

  Future<void> saveUser(BuildContext context) async {
    final u = controllerName.text;
    final s = controllerSec.text;
    final f = controllerFirst.text;
    final n = controllerNum.text;

    userName = u;
    secName = s;
    firstName = f;
    number = n;

    if (u.trim().isEmpty ||
        s.trim().isEmpty ||
        f.trim().isEmpty ||
        n.trim().isEmpty) {
      _errorMessage = 'Все поля должны быть заполнены';
      notifyListeners();
      return;
    }
    if (!canEdit && keys.contains(controllerName.text)) {
      _errorMessage = 'Пользователь с таким именем уже существует';
      notifyListeners();
      return;
    }

    if (canEdit && !keys.contains(controllerName.text)) {
      _errorMessage =
          'Ошибка: попытка создать нового пользователя при изменении данных текущего';
      notifyListeners();
      return;
    }
    _errorMessage = null;
    canEdit = false;
    if (context.mounted) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (BuildContext context) => const ListWidget(),
        ),
      );
    }

    final prefs = await SharedPreferences.getInstance();
    prefs.setStringList(
      userName,
      [
        userName,
        secName,
        firstName,
        number,
      ],
    );
    users.add(
      User(
        userName: userName,
        secName: secName,
        firstName: firstName,
        number: number,
      ),
    );
    setup();
  }

  Future<void> deleteLastUser() async {
    final prefs = await SharedPreferences.getInstance();
    if (keys.isEmpty || users.isEmpty) return;
    users.removeLast();
    prefs.remove(keys.removeLast());
    notifyListeners();
  }

  Future<void> deleteUserOfIndex(BuildContext context, int index) async {
    final prefs = await SharedPreferences.getInstance();
    if (keys.isEmpty || users.isEmpty) return;
    users.removeAt(index);
    prefs.remove(keys.removeAt(index));
    if (context.mounted) Navigator.of(context).pop();
    notifyListeners();
  }

  void toInfoWidget(BuildContext context) {
    controllerName.clear();
    controllerSec.clear();
    controllerFirst.clear();
    controllerNum.clear();
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (BuildContext context) => const InfoWidget(),
      ),
    );
  }

  void toEditInfo(BuildContext context, int index) {
    controllerName.text = users[index].userName;
    controllerSec.text = users[index].secName;
    controllerFirst.text = users[index].firstName;
    controllerNum.text = users[index].number;
    canEdit = true;
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (BuildContext context) => const InfoWidget(),
      ),
    );
  }

  void cancel(BuildContext context) {
    _errorMessage = null;
    notifyListeners();
    Navigator.of(context).pop();
  }

  @override
  void dispose() {
    controllerName.dispose();
    controllerSec.dispose();
    controllerFirst.dispose();
    controllerNum.dispose();
    super.dispose();
  }
}

class ModelProvider extends InheritedNotifier {
  final Model model;
  const ModelProvider({
    super.key,
    required super.child,
    required this.model,
  }) : super(
          notifier: model,
        );

  static ModelProvider? watch(BuildContext context) {
    return context.dependOnInheritedWidgetOfExactType<ModelProvider>();
  }

  static ModelProvider? read(BuildContext context) {
    final widget = context
        .getElementForInheritedWidgetOfExactType<ModelProvider>()
        ?.widget;
    return widget is ModelProvider ? widget : null;
  }
}
