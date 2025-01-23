import 'package:bookworms_app/theme/colors.dart';
import 'package:flutter/material.dart';

Widget editButtonWidget(Future<dynamic> dialog) {
  return RawMaterialButton(
    onPressed: () => dialog,
    fillColor: colorWhite,
    constraints: const BoxConstraints(minWidth: 0.0),
    padding: const EdgeInsets.all(5.0),
    shape: const CircleBorder(),
    child: const Icon(
      Icons.mode_edit_outline_sharp,
      size: 15,
    ),
  );
}