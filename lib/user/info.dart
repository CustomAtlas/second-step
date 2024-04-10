import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:second_step/user/model.dart';

class InfoWidget extends StatelessWidget {
  const InfoWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final model = ModelProvider.read(context)?.model;
    if (model == null) return const SizedBox.shrink();
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.fromLTRB(15, 40, 15, 15),
        child: Align(
          alignment: Alignment.topCenter,
          child: Column(
            children: [
              Column(
                children: [
                  _TextFieldWidget(
                    _TextFieldConfiguration(
                      controller: model.controllerName,
                      hintText: 'Username',
                      inputFormatters: null,
                      keyboardType: null,
                    ),
                  ),
                  const SizedBox(height: 15),
                  _TextFieldWidget(
                    _TextFieldConfiguration(
                      controller: model.controllerSec,
                      hintText: 'Фамилия',
                      inputFormatters: null,
                      keyboardType: null,
                    ),
                  ),
                  const SizedBox(height: 15),
                  _TextFieldWidget(
                    _TextFieldConfiguration(
                      controller: model.controllerFirst,
                      hintText: 'Имя',
                      inputFormatters: null,
                      keyboardType: null,
                    ),
                  ),
                  const SizedBox(height: 15),
                  _TextFieldWidget(
                    _TextFieldConfiguration(
                      controller: model.controllerNum,
                      hintText: 'Номер телефона',
                      keyboardType: const TextInputType.numberWithOptions(),
                      inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                    ),
                  ),
                  const _ErrorMessageWidget(),
                ],
              ),
              const Expanded(child: _ButtonsWidget()),
            ],
          ),
        ),
      ),
    );
  }
}

class _TextFieldConfiguration {
  final TextEditingController controller;
  final String hintText;
  final List<TextInputFormatter>? inputFormatters;
  final TextInputType? keyboardType;

  _TextFieldConfiguration({
    required this.controller,
    required this.hintText,
    required this.inputFormatters,
    required this.keyboardType,
  });
}

class _TextFieldWidget extends StatelessWidget {
  final _TextFieldConfiguration configuration;
  const _TextFieldWidget(this.configuration);

  @override
  Widget build(BuildContext context) {
    const padding = EdgeInsets.fromLTRB(25, 5, 25, 5);
    final boxDecoration = BoxDecoration(
        borderRadius: const BorderRadius.all(Radius.circular(24)),
        border: Border.all(width: 2.5, color: Colors.black54));
    const textStyle = TextStyle(fontSize: 18);
    return DecoratedBox(
      decoration: boxDecoration,
      child: SizedBox(
        height: 60,
        child: Padding(
          padding: padding,
          child: TextField(
            controller: configuration.controller,
            keyboardType: configuration.keyboardType,
            inputFormatters: configuration.inputFormatters,
            style: textStyle,
            decoration: InputDecoration(
                border: InputBorder.none, hintText: configuration.hintText),
          ),
        ),
      ),
    );
  }
}

class _ErrorMessageWidget extends StatelessWidget {
  const _ErrorMessageWidget();

  @override
  Widget build(BuildContext context) {
    final errorMessage = ModelProvider.watch(context)?.model.errorMessage;
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Text(
        errorMessage ?? '',
        style: const TextStyle(color: Colors.red, fontSize: 16),
      ),
    );
  }
}

class _ButtonsWidget extends StatelessWidget {
  const _ButtonsWidget();

  @override
  Widget build(BuildContext context) {
    final model = ModelProvider.read(context)?.model;
    if (model == null) return const SizedBox.shrink();
    return Row(
      crossAxisAlignment: CrossAxisAlignment.end,
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        TextButton(
          onPressed: () => model.saveUser(context),
          child: const Text('Save', style: TextStyle(fontSize: 20)),
        ),
        TextButton(
          onPressed: () => model.cancel(context),
          child: const Text('Cancel', style: TextStyle(fontSize: 20)),
        )
      ],
    );
  }
}
