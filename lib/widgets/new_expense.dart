import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:p3/models/expense.dart';

final formatter = DateFormat.yMd();

class NewExpense extends StatefulWidget {
  const NewExpense(this.onAddExpense, {super.key});
  final void Function(Expense expense) onAddExpense;

  @override
  State<StatefulWidget> createState() {
    return _NewExpense();
  }
}

class _NewExpense extends State<NewExpense> {
  //controllers manage the entered text,It allows the widget to access and manipulate the input in the title text field
  final _titelControler = TextEditingController();
  final _amountControler = TextEditingController();
  DateTime? _selectedDate;
  Category _selectedCategory = Category.work;

  void _submitExpenses() {
    //tryParse to convert the String input to double
    final enterdAmount = double.tryParse(_amountControler.text);
    final amountInvalid = enterdAmount == null || enterdAmount <= 0;

    if (_titelControler.text.trim().isEmpty ||
        amountInvalid ||
        _selectedDate == null) {
      showDialog(
        context: context,
        builder: (ctx) => AlertDialog(
          title: Text("Invalid Input"),
          content: Text('please check the validety of the input data'),
          actions: [
            TextButton(
                onPressed: () {
                  Navigator.pop(ctx);
                },
                child: Text("OK"))
          ],
        ),
      );
      return;
    }

    widget.onAddExpense(
      Expense(
          title: _titelControler.text,
          amount: enterdAmount,
          date: _selectedDate!,
          category: _selectedCategory),
    );
  }

//to clean up memory by releasing the resources of controllers when the NewExpense widget is closed.
  @override
  void dispose() {
    _titelControler.dispose();
    _amountControler.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final keyBoard = MediaQuery.of(context).viewInsets.bottom;
    return SizedBox(
      width: double.infinity,
      height: 400,
      child: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.fromLTRB(
            16,
            48,
            16,
            keyBoard + 16,
          ),
          child: Column(
            children: [
              TextField(
                controller: _titelControler,
                maxLength: 50,
                decoration: InputDecoration(
                  label: Text('Title'),
                ),
              ),
              Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _amountControler,
                      keyboardType: TextInputType.number,
                      decoration: InputDecoration(
                        prefixText: '\$ ',
                        label: Text('Amount'),
                      ),
                    ),
                  ),
                  SizedBox(
                    width: 16,
                    height: 20,
                  ),
                  Expanded(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text(
                          _selectedDate == null
                              ? 'No Select Date'
                              : formatter.format(
                                  _selectedDate!), //! is used to assert that date isnt null at this point of my code.
                        ),

                        // Using async with showDatePicker ensures sequential execution,
                        // with await making setState wait for user date selection.
                        IconButton(
                          onPressed: () async {
                            final now = DateTime.now();
                            final firstDate =
                                DateTime(now.year - 1, now.month, now.day);
                            final pickedDate = await showDatePicker(
                                context: context,
                                initialDate: now,
                                firstDate: firstDate,
                                lastDate: now);
                            setState(() {
                              _selectedDate = pickedDate;
                            });
                          },
                          icon: Icon(
                            Icons.calendar_month,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              SizedBox(
                height: 20,
              ),
              Row(
                children: [
                  DropdownButton(
                    value: _selectedCategory,
                    items: Category.values
                        .map(
                          (category) => DropdownMenuItem(
                            value: category,
                            child: Text(
                              category.name.toUpperCase(),
                            ),
                          ),
                        )
                        .toList(),
                    onChanged: (value) {
                      if (value == null) {
                        return;
                      }
                      setState(
                        () {
                          _selectedCategory = value;
                        },
                      );
                    },
                  ),
                  Spacer(),
                  TextButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: Text('Cancel'),
                  ),
                  ElevatedButton(
                    onPressed: _submitExpenses,
                    child: Text('Save Titel'),
                  ),
                  SizedBox(
                    height: 20,
                  )
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
