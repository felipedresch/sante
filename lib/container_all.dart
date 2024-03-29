import 'package:flutter/material.dart';

class ContainerAll extends StatelessWidget {
  Widget child;
  ContainerAll({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => false,
      child: Container(
        decoration: const BoxDecoration(
          color: Color.fromRGBO(248, 240, 255, 1),
    
        ),
        child: child,
      ),
    );
  }
}
