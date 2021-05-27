import 'package:expense/Widgets/chart_bar.dart';
import 'package:expense/models/transaction.dart';
import 'package:intl/intl.dart';
import 'package:flutter/material.dart';

class Chart extends StatelessWidget {
  final List<Transaction>
      recentTransactions; //Only Transactions that happened in the last few days or 7 days to be precise
  Chart(this.recentTransactions);
  List<Map<String, Object>> get groupedTransactionValues {
    //This is a getter which will return a ist of 7 items for 7 recent weekdays
    return List.generate(7, (index) {
      //Executes the following lines for each element in the list
      //We are generating a list of 7 items
      final weekDay = DateTime.now().subtract(
        Duration( days:index), //We are substracting our current date with 1-7 to get the last 7 dates which we require
      );
      double totalSum = 0.0;
      for (var i = 0; i < recentTransactions.length; i++) {
        if (recentTransactions[i].date.day == weekDay.day &&
            recentTransactions[i].date.month == weekDay.month &&
            recentTransactions[i].date.year == weekDay.year) {
          //Here we need to compare all day month and year because weekDay is a DateTime Object and it returns both date +time so we cant directly compare dates so what we do instead is split up the date and then compare
          totalSum += recentTransactions[i].amount;
        }
      }
      print(DateFormat.E().format(weekDay)); //For debugging stuff
      print(totalSum); //for debugging stuff
      return {
        //We are returning the elements of a list for that specific weekday here
        'day': DateFormat.E()
            .format(weekDay)
            .substring(0, 1), //Using substring we get T for Tuesday
        'amount': totalSum
      }; //DateFormat.E gives M for Monday T for Tuesday it is inbuilt
    })
        .reversed
        .toList(); //Earlier Today was on the leftmost side of the chart but we wanted it on the rightmost side of the chart.So we reverse it.Reversed returns a iterable so we covert in to list
  } //end of getter

  double get totalSpending {
    //This is calculating the total Spending
    return groupedTransactionValues.fold(0.0, //starting value of sum is 0.0
        (sum, item) {
      return sum + item['amount']; //
    }); //fold is used when u wanna execute the same thing on a list of items
  }

  @override
  Widget build(BuildContext context) {
    print(groupedTransactionValues);
    return Container(
      child: Card(
        elevation: 6,
        margin: EdgeInsets.all(20),
        child: Padding(
          //Padding is the simpler version of container which can only add padding
          padding: EdgeInsets.all(10),
          child: Row(
            mainAxisAlignment: MainAxisAlignment
                .spaceAround, //We want the bars to be evenly spaced out
            children: groupedTransactionValues.map((data) {
              return Flexible(
                //Helps us to tell the chart bars that don't exceed the given space which is alloted to you.So for example it
                //doesent allow the label to take more space then required
                fit: FlexFit.tight,
                child: ChartBar(
                  data['day'],
                  data['amount'],
                  totalSpending ==
                          0.0 //We don't divide by totalspending if it is zero else an eroor would be shown
                      ? 0.0
                      : (data['amount'] as double) /
                          totalSpending, //Dart was having trouble taking data[amount] as double and was considering it as an object so we converted it basically
                ),
              );
            }).toList(),
          ),
        ),
      ),
    );
  }
}
