import 'package:flutter/material.dart';

class TextVertical extends StatelessWidget {
  const TextVertical({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Text('蜜源ABCabc123',
        style: TextStyle(
          fontSize: 15,
          height: 2.0,
          leadingDistribution: TextLeadingDistribution.even, // 设置leading策略
        ));
  }
}
