import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'models.dart';
import 'game_engine.dart';

void main() {
  runApp(
    ChangeNotifierProvider(
      create: (context) => GameEngine(),
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Color Block Jam',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.blue,
          brightness: Brightness.dark,
        ),
        useMaterial3: true,
        scaffoldBackgroundColor: const Color(0xFF0F172A),
      ),
      home: const GamePage(),
    );
  }
}

class GamePage extends StatelessWidget {
  const GamePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Color Block Jam', style: TextStyle(fontWeight: FontWeight.bold)),
        centerTitle: true,
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: Consumer<GameEngine>(
        builder: (context, engine, child) {
          if (engine.isLevelComplete) {
            WidgetsBinding.instance.addPostFrameCallback((_) {
              _showWinDialog(context, engine);
            });
          }

          return Column(
            children: [
              _buildStats(engine),
              const Spacer(),
              _buildGameBoard(context, engine),
              const Spacer(),
              _buildAdPlaceholder(),
              _buildControls(engine),
            ],
          );
        },
      ),
    );
  }

  Widget _buildStats(GameEngine engine) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: const Color(0xFF1E293B),
        borderRadius: BorderRadius.circular(15),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          Text('Seviye: ${engine.levelNum}', style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          Text('Hamle: ${engine.moves}', style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }

  Widget _buildGameBoard(BuildContext context, GameEngine engine) {
    final size = MediaQuery.of(context).size;
    final boardSize = size.width * 0.85;
    final cellSize = boardSize / GameEngine.gridSize;

    return Center(
      child: Container(
        width: boardSize + 40,
        height: boardSize + 40,
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: const Color(0xFF334155),
          borderRadius: BorderRadius.circular(20),
          boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.3), blurRadius: 20, offset: const Offset(0, 10))],
        ),
        child: Stack(
          clipBehavior: Clip.none,
          children: [
            // Collectors
            ...engine.collectors.map((c) => _buildCollector(c, cellSize)),
            
            // Grid Background
            Container(
              width: boardSize,
              height: boardSize,
              decoration: BoxDecoration(
                color: const Color(0xFF1E293B),
                borderRadius: BorderRadius.circular(10),
              ),
              child: GridView.builder(
                physics: const NeverScrollableScrollPhysics(),
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: GameEngine.gridSize,
                ),
                itemCount: GameEngine.gridSize * GameEngine.gridSize,
                itemBuilder: (context, index) => Container(
                  margin: const EdgeInsets.all(2),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.05),
                    borderRadius: BorderRadius.circular(4),
                  ),
                ),
              ),
            ),

            // Blocks
            ...engine.blocks.map((b) => _buildBlock(context, b, engine, cellSize)),
          ],
        ),
      ),
    );
  }

  Widget _buildCollector(Collector c, double cellSize) {
    double top = 0;
    double left = 0;
    double? bottom;
    double? right;

    switch (c.side) {
      case Side.top:
        top = -25;
        left = c.pos * cellSize + cellSize / 2 - 10;
        break;
      case Side.bottom:
        bottom = -25;
        left = c.pos * cellSize + cellSize / 2 - 10;
        top = double.nan; // invalid
        break;
      case Side.left:
        left = -25;
        top = c.pos * cellSize + cellSize / 2 - 10;
        break;
      case Side.right:
        right = -25;
        top = c.pos * cellSize + cellSize / 2 - 10;
        left = double.nan;
        break;
    }

    return Positioned(
      top: top.isNaN ? null : top,
      left: left.isNaN ? null : left,
      bottom: bottom,
      right: right,
      child: Container(
        width: 20,
        height: 20,
        decoration: BoxDecoration(
          color: c.color,
          shape: BoxShape.circle,
          border: Border.all(color: Colors.white.withOpacity(0.5), width: 3),
        ),
      ),
    );
  }

  Widget _buildBlock(BuildContext context, Block b, GameEngine engine, double cellSize) {
    return AnimatedPositioned(
      duration: const Duration(milliseconds: 200),
      curve: Curves.easeOutCubic,
      left: b.x * cellSize + 4,
      top: b.y * cellSize + 4,
      child: AnimatedScale(
        duration: const Duration(milliseconds: 200),
        scale: b.isMoving ? 0.0 : 1.0,
        child: GestureDetector(
          onPanUpdate: (details) {
            if (b.isMoving) return;
            if (details.delta.dx.abs() > details.delta.dy.abs()) {
              if (details.delta.dx.abs() > 5) {
                engine.moveBlock(b, details.delta.dx > 0 ? 'right' : 'left');
              }
            } else {
              if (details.delta.dy.abs() > 5) {
                engine.moveBlock(b, details.delta.dy > 0 ? 'bottom' : 'top');
              }
            }
          },
          child: Container(
            width: cellSize - 8,
            height: cellSize - 8,
            decoration: BoxDecoration(
              color: b.color,
              borderRadius: BorderRadius.circular(10),
              boxShadow: [
                BoxShadow(color: Colors.black.withOpacity(0.3), offset: const Offset(0, 4), blurRadius: 4),
                BoxShadow(color: Colors.white.withOpacity(0.2), offset: const Offset(0, -2), blurRadius: 0, spreadRadius: 0),
              ],
            ),
            child: const Center(
              child: Icon(Icons.drag_indicator, color: Colors.white54, size: 20),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildAdPlaceholder() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20),
      height: 60,
      width: double.infinity,
      decoration: BoxDecoration(
        color: const Color(0xFF1E293B),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.white24, style: BorderStyle.solid),
      ),
      child: const Center(child: Text('Reklam Alanı', style: TextStyle(color: Colors.white38))),
    );
  }

  Widget _buildControls(GameEngine engine) {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Row(
        children: [
          Expanded(
            child: ElevatedButton.icon(
              onPressed: () {},
              icon: const Icon(Icons.lightbulb),
              label: const Text('İpucu'),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF1E293B),
                padding: const EdgeInsets.symmetric(vertical: 15),
              ),
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: ElevatedButton.icon(
              onPressed: () => engine.loadLevel(engine.levelNum),
              icon: const Icon(Icons.refresh),
              label: const Text('Sıfırla'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.redAccent,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 15),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _showWinDialog(BuildContext context, GameEngine engine) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        title: const Text('Tebrikler!'),
        content: Text('Seviye ${engine.levelNum} tamamlandı.'),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              engine.nextLevel();
            },
            child: const Text('Sonraki Seviye'),
          ),
        ],
      ),
    );
  }
}
