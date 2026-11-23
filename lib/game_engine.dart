import 'package:flutter/material.dart';
import 'models.dart';

class GameEngine extends ChangeNotifier {
  static const int gridSize = 6;
  int levelNum = 1;
  int moves = 0;
  List<Block> blocks = [];
  List<Collector> collectors = [];
  bool isLevelComplete = false;

  GameEngine() {
    loadLevel(1);
  }

  void loadLevel(int lvl) {
    levelNum = lvl;
    moves = 0;
    isLevelComplete = false;
    
    final data = _getLevelData(lvl);
    blocks = data.blocks;
    collectors = data.collectors;
    notifyListeners();
  }

  LevelData _getLevelData(int lvl) {
    final levels = {
      1: LevelData(
        collectors: [
          Collector(color: Colors.red, side: Side.top, pos: 2),
          Collector(color: Colors.blue, side: Side.bottom, pos: 4),
          Collector(color: Colors.green, side: Side.left, pos: 3),
        ],
        blocks: [
          Block(id: 1, color: Colors.red, x: 2, y: 3),
          Block(id: 2, color: Colors.blue, x: 4, y: 1),
          Block(id: 3, color: Colors.green, x: 0, y: 3),
        ],
      ),
      2: LevelData(
        collectors: [
          Collector(color: Colors.orange, side: Side.right, pos: 1),
          Collector(color: Colors.purple, side: Side.left, pos: 4),
          Collector(color: Colors.red, side: Side.top, pos: 0),
        ],
        blocks: [
          Block(id: 1, color: Colors.orange, x: 1, y: 1),
          Block(id: 2, color: Colors.purple, x: 5, y: 4),
          Block(id: 3, color: Colors.red, x: 0, y: 5),
          Block(id: 4, color: Colors.orange, x: 3, y: 2),
        ],
      ),
      3: LevelData(
        collectors: [
          Collector(color: Colors.blueAccent, side: Side.bottom, pos: 1),
          Collector(color: Colors.greenAccent, side: Side.bottom, pos: 3),
          Collector(color: Colors.redAccent, side: Side.bottom, pos: 5),
          Collector(color: Colors.purpleAccent, side: Side.top, pos: 2),
        ],
        blocks: [
          Block(id: 1, color: Colors.blueAccent, x: 1, y: 0),
          Block(id: 2, color: Colors.greenAccent, x: 3, y: 0),
          Block(id: 3, color: Colors.redAccent, x: 5, y: 0),
          Block(id: 4, color: Colors.purpleAccent, x: 2, y: 5),
        ],
      ),
    };
    return levels[lvl] ?? levels[1]!;
  }

  void moveBlock(Block block, String direction) {
    if (isLevelComplete || block.isMoving) return;

    int newX = block.x;
    int newY = block.y;
    bool moved = false;

    while (true) {
      int nextX = newX;
      int nextY = newY;

      if (direction == 'left') nextX--;
      else if (direction == 'right') nextX++;
      else if (direction == 'top') nextY--;
      else if (direction == 'bottom') nextY++;

      if (nextX < 0 || nextX >= gridSize || nextY < 0 || nextY >= gridSize) {
        if (_checkCollector(block, direction, nextX, nextY)) {
          block.x = nextX; // logical exit
          block.y = nextY;
          block.isMoving = true;
          _collectBlock(block);
          moves++;
          notifyListeners();
          return;
        }
        break;
      }

      if (blocks.any((b) => b.id != block.id && b.x == nextX && b.y == nextY)) {
        break;
      }

      newX = nextX;
      newY = nextY;
      moved = true;
    }

    if (moved) {
      block.x = newX;
      block.y = newY;
      moves++;
      _checkWin();
      notifyListeners();
    }
  }

  void _collectBlock(Block block) async {
    await Future.delayed(const Duration(milliseconds: 250));
    blocks.removeWhere((b) => b.id == block.id);
    _checkWin();
    notifyListeners();
  }

  void _checkWin() {
    if (blocks.isEmpty) {
      isLevelComplete = true;
    }
  }

  bool _checkCollector(Block block, String direction, int x, int y) {
    return collectors.any((c) {
      final isMatch = c.color.value == block.color.value;
      if (!isMatch) return false;

      if (direction == 'top' && c.side == Side.top && block.x == c.pos && block.y == 0) return true;
      if (direction == 'bottom' && c.side == Side.bottom && block.x == c.pos && block.y == gridSize - 1) return true;
      if (direction == 'left' && c.side == Side.left && block.y == c.pos && block.x == 0) return true;
      if (direction == 'right' && c.side == Side.right && block.y == c.pos && block.x == gridSize - 1) return true;
      
      return false;
    });
  }

  void nextLevel() {
    loadLevel(levelNum + 1);
  }
}
