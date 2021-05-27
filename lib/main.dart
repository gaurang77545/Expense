import 'package:expense/Widgets/chart.dart';
import 'package:expense/Widgets/new_transaction.dart';
import 'package:expense/Widgets/transactionlistwithListTile.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:expense/models/transaction.dart';
import 'package:flutter/services.dart';
import 'dart:io';

void main() {
  /*Code for setting one direction mode only*/
  /*
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown
  ]); //Tells Flutter to only allow portrait up and down .Basically app doesen't rotate*/

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Kharcha Paani',
      theme: ThemeData(
        primarySwatch: Colors.purple,
        accentColor: Colors.amber,
        errorColor: Colors.red,
        fontFamily: 'Quicksand',
        textTheme: ThemeData.light().textTheme.copyWith(
              title: TextStyle(
                fontFamily: 'OpenSans',
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
        appBarTheme: AppBarTheme(
          textTheme: ThemeData.light().textTheme.copyWith(
                title: TextStyle(
                  //Setted a theme for Title
                  fontFamily: 'OpenSans',
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
                button: TextStyle(
                    //Setted a theme for button
                    color: Colors.white),
              ),
        ),
      ),
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final List<Transaction> _userTransaction = [];

  List<Transaction> get _recentTransaction {
    return _userTransaction.where((tx) {
      //where runs on every item on the list which is tx here and adds it to the list recentTransaction only if it is true
      return tx.date.isAfter(DateTime.now().subtract(Duration(days: 7)));
      //We wanna get the last 7 day list here only .So we substract now from 7
    }).toList(); //WHere returns a iterable however we want a list
  }

  bool _showChart = false;
  void _addNewTransaction(String titlex, double amountx, DateTime chosenDate) {
    final newTx = Transaction(
      id: DateTime.now()
          .toString(), //id is unique because current time doesen't repeat
      title: titlex,
      amount: amountx,
      date: chosenDate,
    );
    setState(() {
      _userTransaction.add(newTx);
    });
  }

  void _startAddNewTransaction(BuildContext ctx) {
    showModalBottomSheet(
      context: ctx,
      builder: (_) {
        return GestureDetector(
          onTap: () {},/*Basically we make the wholemodal sheet a gesture detector and on tapping it we don't do anything so the only way
           the sheet gets closed is if we tap outside.Earlier the sheet was closing even if we click on the modal sheet*/
          child: NewTransaction(_addNewTransaction),
          behavior: HitTestBehavior.opaque,
        );
      },
    );
  }

  void _deleteTransaction(String id) {
    setState(() {
      _userTransaction.removeWhere((tx) {
        //Runs function on every element in the list
        return tx.id == id;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    final isLandscape = MediaQuery.of(context).orientation ==
        Orientation.landscape; //We write this variable here so that flutter rebuilds UI and we get to know the orientation
    final PreferredSizeWidget appBar = Platform
            .isIOS //Earlier we were having error in prefereed size attributes so we gave it a type to prevent em errors
        ? CupertinoNavigationBar(
            middle: Text('Kharcha Paani'),
            trailing: Row(
              mainAxisSize: MainAxisSize
                  .min //By default row takes the full size we are restricting it
              ,
              children: <Widget>[
                GestureDetector(
                  child: Icon(CupertinoIcons.add),
                  onTap: () => _startAddNewTransaction(context),
                )
              ],
            ),
          )
        : AppBar(
            title: Text(
              'Kharcha Paani',
            ),
            actions: <Widget>[
              IconButton(
                icon: Icon(Icons.add),
                onPressed: () => _startAddNewTransaction(context),
              )
            ],
          );
    final txListWidget = Container(
      height: (MediaQuery.of(context).size.height -//Size of screen
              appBar.preferredSize.height -//Size of appbar
              MediaQuery.of(context).padding.top) *0.7,//Some padding is reserved by default in android apps
      child: TransactionListwithtile(_userTransaction, _deleteTransaction,UniqueKey()),
    );
    final pageBody = SafeArea(
      //We use SafeARea here because in ios there is some reserved space as well.So we move the app down the reserve area and then use it
      child: SingleChildScrollView(
        //Made a variable so that we can use it again and again
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            if (isLandscape) //Another way of terenary operator.U cant use curly braces with this if however
              Row(
                //Toggle Button made
                children: <Widget>[
                  Text(
                    'Show Chart',
                    style: Theme.of(context).textTheme.title,
                  ),
                  Switch.adaptive(
                      //Changes the look for ioS
                      value: _showChart,
                      onChanged: (val) {
                        setState(() {
                          _showChart =
                              val; //val is true or false whatever we chose in the toggle button or switch
                        });
                      }), //Like a toggle button
                ],
              ),
            if (!isLandscape)
              Container(
                height: (MediaQuery.of(context) .size.height - //Remember in stateful widget context is available globally
                        appBar.preferredSize.height -
                        MediaQuery.of(context).padding.top) *0.3,
                child: Chart(_recentTransaction),
              ), //For LandScape mode we wanted the chart to be smaller in size
            if (!isLandscape) txListWidget, //If only works with certain stuff
            if (isLandscape)
              _showChart //if it is landscape and value of toggle button is true u show the chart
                  ? Container(
                      height: (MediaQuery.of(context)
                                  .size
                                  .height - //Remember in stateful widget context is available globally
                              appBar.preferredSize.height -
                              MediaQuery.of(context).padding.top) *
                          0.7, //Above the chart there was padding we removed that as well.There is no scrolling available afterthis besides the list which we want
                      /*It takes 30% of the height of the screen 
              deducting height of the appbar. Earlier we were doing something else but with the toglle button available we wanna make the chart occupy full space
               which is like 0.70 coz toggle button also takes space*/
                      child: Chart(_recentTransaction),
                    )
                  : txListWidget,
          ],
        ),
      ),
    );
    return Platform.isIOS
        ? CupertinoPageScaffold(
            child: pageBody,
            navigationBar: appBar,
          )
        : Scaffold(
            appBar:
                appBar, //We are assigning the appBar variable which we created earlier
            body: pageBody,
            floatingActionButtonLocation:
                FloatingActionButtonLocation.centerFloat,
            floatingActionButton: Platform.isIOS
                ? Container()
                : FloatingActionButton(
                    child: Icon(Icons.add),
                    onPressed: () => {_startAddNewTransaction(context)},
                  ),
          );
  }
}
