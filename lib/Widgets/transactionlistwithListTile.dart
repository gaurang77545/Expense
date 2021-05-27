import 'dart:math';

import 'package:expense/models/transaction.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class TransactionListwithtile extends StatefulWidget {
  final List<Transaction> _userTransaction;
  final Function deleteTx;
  Key key;
  TransactionListwithtile(
    this._userTransaction,
    this.deleteTx,
    this.key,
  ) : super(key: key); //Forwards key to parent class using the same attribute

  @override
  _TransactionListwithtileState createState() =>
      _TransactionListwithtileState();
}

class _TransactionListwithtileState extends State<TransactionListwithtile> {
  Color _bgcolor;
  @override
  void initState() {
    //Build runs after initState so u dont need to call setState here
    const availableColors = [
      Colors.red,
      Colors.black,
      Colors.blue,
      Colors.purple
    ];
    _bgcolor = availableColors[Random().nextInt(
        4)]; //generates a random number from 0 to 3 for random color generation
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: widget._userTransaction.isEmpty
          ? LayoutBuilder(builder: (ctx, constraints) {
              return Column(
                children: <Widget>[
                  Text(
                    'No transactions added yet',
                    style: Theme.of(context).textTheme.title,
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Container(
                    height: constraints.maxHeight * 0.60,
                    child: Image.asset(
                      'assets/fonts/images/waiting.png',
                      fit: BoxFit.cover,
                    ),
                  ),
                ],
              );
            })
          : ListView.builder(
              itemBuilder: (ctx, index) {
                return Card(
                  elevation: 5, //For that nice little fade in CArd
                  margin: EdgeInsets.symmetric(
                    vertical: 8,
                    horizontal: 5,
                  ),
                  child: ListTile(
                    leading: CircleAvatar(
                      //We are adding Circles using this basially it looks kinda nice that's all
                      //leading widget=widget positioned at beginning of list Tile
                      radius: 30,
                      backgroundColor: _bgcolor,
                      child: Padding(
                        padding: EdgeInsets.all(6),
                        child: FittedBox(
                          child: Text(
                              '\$${widget._userTransaction[index].amount}'),
                        ),
                      ),
                    ),
                    title: Text(
                      widget._userTransaction[index].title,
                      style: Theme.of(context).textTheme.title,
                    ),
                    subtitle: Text(
                      DateFormat.yMMMd() .format(widget._userTransaction[index].date),
                    ), //We are generating a string based date using this
                    trailing: MediaQuery.of(context).size.width >400 //Basically if we have more width avaialble with us we also print a text
                        ? FlatButton.icon(
                            onPressed: () {
                              widget
                                  .deleteTx(widget._userTransaction[index].id);
                            },
                            icon: Icon(Icons.delete),
                            label: Text('Delete'),
                            textColor: Theme.of(context).errorColor,
                          )
                        : IconButton(
                            icon: Icon(Icons.delete),
                            color: Theme.of(context).errorColor,
                            onPressed: () {
                              widget.deleteTx(widget._userTransaction[index].id);
                            },
                          ),
                  ),
                );
              },
              itemCount: widget._userTransaction.length,
            ),
    );
  }
}
