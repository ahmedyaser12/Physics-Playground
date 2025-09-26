import 'package:flutter/material.dart';

class PhysicsPlayground extends StatelessWidget {
  const PhysicsPlayground({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Physics Playground'),
        centerTitle: true,
      ),
      body: const DragDropDemo(),
    );
  }
}

class DragDropDemo extends StatefulWidget {
  const DragDropDemo({super.key});

  @override
  State<DragDropDemo> createState() => _DragDropDemoState();
}

class _DragDropDemoState extends State<DragDropDemo> {
  final Map<Color, bool> _matched = {
    Colors.red: false,
    Colors.green: false,
    Colors.blue: false,
  };

  final Map<Color, bool> _hovering = {
    Colors.red: false,
    Colors.green: false,
    Colors.blue: false,
  };

  void _handleDrop(Color targetColor, Color ballColor) {
    setState(() {
      if (targetColor == ballColor) {
        _matched[targetColor] = true; // success state
      }
      _hovering[targetColor] = false; // reset hover
    });
  }

  Widget _buildBall(Color color) {
    return Draggable<Color>(
      data: color,
      feedback: CircleAvatar(radius: 30, backgroundColor: color),
      childWhenDragging: CircleAvatar(
        radius: 25,
        backgroundColor: color.withOpacity(0.5),
      ),
      child: CircleAvatar(radius: 25, backgroundColor: color),
    );
  }

  Widget _buildTarget(Color color) {
    final bool isMatched = _matched[color] ?? false;
    final bool isHovering = _hovering[color] ?? false;

    return DragTarget<Color>(
      onWillAcceptWithDetails: (ballColor) {
        setState(() => _hovering[color] = true);
        return true;
      },
      onLeave: (_) {
        setState(() => _hovering[color] = false);
      },
      onAcceptWithDetails: (ballColor) => _handleDrop(color, ballColor.data),
      builder: (context, candidateData, rejectedData) {
        return AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          width: 100,
          height: 100,
          decoration: BoxDecoration(
            color: isMatched ? color : color.withOpacity(0.5),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: color,
              width: 3,
            ), // border with target color
          ),
          child: Center(
            child: isMatched
                ? const Icon(Icons.check, size: 40, color: Colors.white)
                : isHovering
                ? const Icon(
                    Icons.arrow_downward,
                    size: 40,
                    color: Colors.black54,
                  )
                : null,
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        // Balls row
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            _buildBall(Colors.red),
            _buildBall(Colors.green),
            _buildBall(Colors.blue),
          ],
        ),
        // Targets row
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            _buildTarget(Colors.red),
            _buildTarget(Colors.green),
            _buildTarget(Colors.blue),
          ],
        ),
      ],
    );
  }
}