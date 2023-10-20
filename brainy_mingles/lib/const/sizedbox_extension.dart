import 'package:flutter/material.dart';

extension SizedBoxHeight on num {
  SizedBox get sbh => SizedBox(
        height: toDouble(),
      );
  SizedBox get sbw => SizedBox(
        width: toDouble(),
      );
}
