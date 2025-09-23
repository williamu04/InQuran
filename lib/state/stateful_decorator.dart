import 'package:flutter/material.dart';

abstract class StatefulViewModel<S> extends ChangeNotifier {
  S get state;
}