import 'package:flutter_web/material.dart';
import 'package:demo/utils.dart' as tools;
class PartitionBox extends StatelessWidget {
  int magedata = 0;
  int scaleRate = 1;
  Color defaultColor =  tools.getRandomColor();
  PartitionBox(this.magedata, this.scaleRate);
  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: Duration(seconds: 2),
      color: defaultColor,
      child: SizedBox(
        height: magedata.toDouble() * scaleRate,
        width: 150,
        child: Center(
          child: Text(
            "${magedata}M",
            style: TextStyle(color: Colors.white),
          ),
        ),
      ),
    );
  }
}
