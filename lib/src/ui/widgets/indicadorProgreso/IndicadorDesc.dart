import 'package:flutter/material.dart';

class IndicadorDesc extends StatefulWidget {
  @override
  IndicadorState createState() => IndicadorState();
}

class IndicadorState extends State<IndicadorDesc> with TickerProviderStateMixin{

  AnimationController controller;

  @override
  void initState() {
    
    controller = AnimationController(
      vsync: this,
      duration: Duration(seconds: 20),
    );
    if (controller.isAnimating)
      controller.stop();
    else {
      controller.reverse(
          from: controller.value == 0.0 ? 1.0 : controller.value)
          .then((value){
            print(controller.value);
          });

    }


    super.initState();
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }


 @override
  Widget build(BuildContext context) {
    
    return AnimatedBuilder(
      animation: controller,
      builder: (context, child) {
        return LinearProgressIndicator(
          backgroundColor: Colors.white,
          valueColor: AlwaysStoppedAnimation<Color>(
            Colors.green[500],
          ),
          value: controller.value,
        );
      }
    );
  }
}
