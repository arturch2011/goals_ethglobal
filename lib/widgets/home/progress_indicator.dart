import 'package:flutter/material.dart';

class BuildProgressIndicator extends StatefulWidget {
  final double percentage;
  const BuildProgressIndicator({super.key, required this.percentage});

  @override
  State<BuildProgressIndicator> createState() => _BuildProgressIndicatorState();
}

class _BuildProgressIndicatorState extends State<BuildProgressIndicator> {
  @override
  Widget build(BuildContext context) {
    double percent = widget.percentage;
    int percentInt = (percent * 100).toInt();
    return Stack(alignment: Alignment.center, children: [
      SizedBox(
        width: 50,
        height: 50,
        child: CircularProgressIndicator(
          value: percent,
          backgroundColor: const Color.fromRGBO(240, 240, 240, 1),
          strokeWidth: 7,
          semanticsLabel: "$percentInt%",
          semanticsValue: percent.toStringAsFixed(2),
          valueColor: AlwaysStoppedAnimation<Color>(
            Theme.of(context).primaryColor,
          ),
        ),
      ),
      Text(
        '$percentInt%',
        textHeightBehavior: const TextHeightBehavior(
            applyHeightToFirstAscent: true,
            applyHeightToLastDescent:
                false), // Valor do progresso (substitua pelo valor real)
        style: const TextStyle(
          fontSize: 13,
          fontWeight: FontWeight.bold,
        ),
      ),
    ]);
  }
}
