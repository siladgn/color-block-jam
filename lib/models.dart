import 'package:flutter/material.dart';

enum Side { top, bottom, left, right }

class Block {
  final int id;
  final Color color;
  int x;
  int y;
  bool isMoving;

  Block({
    required this.id,
    required this.color,
    required this.x,
    required this.y,
    this.isMoving = false,
  });

  Block copyWith({int? x, int? y, bool? isMoving}) {
    return Block(
      id: id,
      color: color,
      x: x ?? this.x,
      y: y ?? this.y,
      isMoving: isMoving ?? this.isMoving,
    );
  }
}

class Collector {
  final Color color;
  final Side side;
  final int pos;

  Collector({
    required this.color,
    required this.side,
    required this.pos,
  });
}

class LevelData {
  final List<Block> blocks;
  final List<Collector> collectors;

  LevelData({required this.blocks, required this.collectors});
}
