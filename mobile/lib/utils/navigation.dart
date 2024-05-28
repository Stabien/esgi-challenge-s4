import 'package:flutter/material.dart';

void redirectToPath(BuildContext context, String path) {
  Navigator.pushNamed(
    context,
    path,
  );
}
