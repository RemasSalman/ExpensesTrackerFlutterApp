import 'package:flutter/material.dart';
import 'package:p3/widgets/chart/chart.dart';
import 'package:p3/widgets/lists/expenses_list.dart';
import 'package:p3/models/expense.dart';
import 'package:p3/widgets/new_expense.dart';

class Expenses extends StatefulWidget {
  const Expenses({super.key});

  @override
  State<Expenses> createState() {
    return _ExpensesState();
  }
}

class _ExpensesState extends State<Expenses> {
  final List<Expense> _registeredExpenses = [
    Expense(
      title: 'flutter course',
      amount: 19.99,
      date: DateTime.now(),
      category: Category.work,
    ),
    Expense(
      title: 'Cinema',
      amount: 15.69,
      date: DateTime.now(),
      category: Category.leisuer,
    ),
    Expense(
      title: 'Tickets',
      amount: 99.99,
      date: DateTime.now(),
      category: Category.travel,
    ),
    Expense(
      title: 'Resturant',
      amount: 30.98,
      date: DateTime.now(),
      category: Category.food,
    ),
    Expense(
      title: 'Python course',
      amount: 29.99,
      date: DateTime.now(),
      category: Category.work,
    ),
  ];

  void _openAddExpense() {
    showModalBottomSheet(
      isScrollControlled: true,
      useSafeArea: true,
      context: context,
      builder: (ctx) => NewExpense(_addExpenses),
    );
  }

  void _addExpenses(Expense expense) {
    setState(() {
      _registeredExpenses.add(expense);
    });
  }

  void _removeExpense(Expense expense) {
    final expenseIndex = _registeredExpenses.indexOf(expense);
    setState(() {
      _registeredExpenses.remove(expense);
    });
    ScaffoldMessenger.of(context).clearSnackBars();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        duration: Duration(seconds: 3),
        content: Text('Expense deleted'),
        action: SnackBarAction(
            label: 'Undo',
            onPressed: () {
              setState(() {
                _registeredExpenses.insert(expenseIndex, expense);
              });
            }),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Flutter Expenses Tracker',
          style: TextStyle(
            color: Colors.white,
            fontSize: 18,
          ),
        ),
        actions: [
          IconButton(
            onPressed: _openAddExpense,
            icon: Icon(Icons.add),
            color: Colors.white,
          )
        ],
      ),
      body: width < 500
          ? Column(
              children: [
                Chart(expenses: _registeredExpenses),
                Expanded(
                  child: ExpensesList(_removeExpense, _registeredExpenses),
                ),
              ],
            )
          : Row(
              children: [
                Expanded(
                  child: Chart(expenses: _registeredExpenses),
                ),
                Expanded(
                  child: ExpensesList(_removeExpense, _registeredExpenses),
                ),
              ],
            ),
    );
  }
}
