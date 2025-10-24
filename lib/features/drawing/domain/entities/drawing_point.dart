import 'package:flutter/material.dart';
import 'package:equatable/equatable.dart';

class DrawingPoint extends Equatable {
  final Offset offset;
  final Paint paint;

  const DrawingPoint({required this.offset, required this.paint});

  @override
  List<Object?> get props => [offset, paint];
}
