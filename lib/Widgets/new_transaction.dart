import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class NewTransaction extends StatefulWidget {
  final Function addnewtransaction;
  NewTransaction(this.addnewtransaction);

  @override
  _NewTransactionState createState() => _NewTransactionState();
}

class _NewTransactionState extends State<NewTransaction> {
  final titlecontroller = TextEditingController();

  final amountcontroller = TextEditingController();

  DateTime _selectDate;

  void submitData() {
    final inputText = titlecontroller.text;
    final inputamt = double.parse(amountcontroller.text);
    if (inputText.isEmpty || inputamt <= 0 || _selectDate == null) {
      return;
    }
    widget.addnewtransaction(
        titlecontroller.text,
        double.parse( amountcontroller.text,),//Convert text to double
         _selectDate);
    Navigator.of(context).pop(); //Closes the modal sheet
  }

  void _presentDatePicker() {
    showDatePicker(
            //Returns Future Data Type
            context: context, //In stateful widget the context is available universally so we can use it anywhere
            initialDate: DateTime.now(),
            firstDate: DateTime(2019),
            lastDate: DateTime.now())
        .then((pickedDate) {
      /*then is executed when a user picks a date.Gets triggered later on and not instantly.
        Statements however which are after this then get executed immediately and don't wait as such*/
      if (pickedDate == null) {
        return; //Don't do anything and just return directly
      }
      setState(() {
        _selectDate =
            pickedDate; //pickedDate is local we wanna output it also sowe use another variable
      });
    });
    //Future is class in Dart.Future are classes which will give values in the future
  }

  @override
  Widget build(BuildContext context) {
    //This context is same as universally accepted context
    return SingleChildScrollView(
      //Because modal sheet has a fixed size and wil overflow so to counter that fixed size we make it scrollable for it to be a little bit flexible
      child: Card(
        elevation: 5,
        child: Container(
          padding: EdgeInsets.only(
            top: 10,
            left: 10,
            right: 10,
            bottom: MediaQuery.of(context).viewInsets.bottom + 10, //view Insets gives value of anything which is overlappingthat is usually my keyboard
            //Once i get the value of the size of my keyboard i move it up by 10 to give space to my input text area
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: <Widget>[
              TextField(
                  decoration: InputDecoration(labelText: 'Title'),
                  controller: titlecontroller,
                  onSubmitted: (_) => submitData()
                  //onChanged: (val) {
                  //titleInput = val;}
                  ),
              TextField(
                decoration: InputDecoration(labelText: 'Amount'),
                keyboardType: TextInputType.number,
                onSubmitted: (_) => submitData(),
                controller: amountcontroller,
                //onChanged: (val) => amountInput = val,
              ),
              Container(
                height: 70,
                child: Row(
                  children: <Widget>[
                    Expanded(
                      child: Text(
                        _selectDate == null
                            ? 'No Date Chosen!'
                            : 'Picket Date : ${DateFormat.yMd().format(_selectDate)}',
                      ),
                    ),
                    FlatButton(
                      onPressed: () {
                        _presentDatePicker();
                      },
                      textColor: Theme.of(context).primaryColor,
                      child: Text(
                        'Choose Date',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                    )
                  ],
                ),
              ),
              RaisedButton(
                //You can use Cupertino Button if u want for ios
                onPressed: () {
                  //print(titleInput + ' ' + amountInput);
                  submitData();
                  // print(titlecontroller.text);
                },
                color: Theme.of(context)
                    .primaryColor, //Changes background to the primary color ie purple
                textColor: Theme.of(context).textTheme.button.color,
                child: Text('Add Transaction'),
              ),
              
            ],
          ),
        ),
      ),
    );
  }
}
