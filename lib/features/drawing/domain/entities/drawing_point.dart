import 'package:flutter/material.dart';
import 'package:equatable/equatable.dart';

class DrawingPoint extends Equatable {
  final Offset offset; // один точка который где стоит
  final Paint paint; // это точка который какой толшине и какой цвете

  const DrawingPoint({required this.offset, required this.paint});

  @override
  List<Object?> get props => [offset, paint];
}
