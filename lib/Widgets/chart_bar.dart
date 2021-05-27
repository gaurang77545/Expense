import 'package:flutter/material.dart';

class ChartBar extends StatelessWidget {
  final String label;
  final double spendingAmount;
  final double spendingPctOfTotal; //WHat percentage of total amount is that bar
  ChartBar(this.label, this.spendingAmount, this.spendingPctOfTotal);
  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (ctx,
            constraint) /*Constraint tells how much space certain widget takes.Helps u to set constraints*/
        {
      return Column(
        children: <Widget>[
          Container(
            height: constraint.maxHeight *
                0.15, //Notice that everything adds up to be 1
            child: FittedBox(
              //Tells it to dont take more space.You shrink if more space is required
              child: Text('\$${spendingAmount.toStringAsFixed(0)}'),
            ),
          ), //We dont want decimals in our amt
          SizedBox(
            height: constraint.maxHeight * 0.05,
          ), //For Spacing
          Container(
              height: constraint.maxHeight * 0.60,
              width: 10,
              child: Stack(
                //Stack allows u to place items on top of each other but not like Column but in a overlapping fashion
                children: <Widget>[
                  Container(
                    decoration: BoxDecoration(
                      //This initial thing is for the background of each bar
                      border: Border.all(color: Colors.grey, width: 1.0),
                      color: Color.fromRGBO(220, 220, 220,
                          1), //We wanted a lighter color of grey so we used rgbo values we got from net.Each value is bw 0 and 255
                      borderRadius: BorderRadius.circular(10), //Enables curling
                    ),
                  ),
                  FractionallySizedBox(
                    //Since this a stack we place this container over the previous container in a overlapping fashion
                    heightFactor: spendingPctOfTotal,
                    child: Container(
                      decoration: BoxDecoration(
                        color: Theme.of(context).primaryColor,
                        borderRadius: BorderRadius.circular(
                            10), //We need to have same border radius as the above container so that they overlap smoothly
                      ),
                    ),
                  )
                ],
              )),
          SizedBox(
            height: constraint.maxHeight * 0.05,
          ),
          Container(
            height: constraint.maxHeight * 0.15,
            child: FittedBox(
              //The child is refitted if it exceeds and no overflowhappens
              child: Text(label),
            ),
          ),
        ],
      );
    });
  }
}
