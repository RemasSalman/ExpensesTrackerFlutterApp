import 'package:flutter/material.dart';
import 'package:p3/models/expense.dart';
import 'package:p3/widgets/lists/expenses_item.dart';

class ExpensesList extends StatelessWidget {
  const ExpensesList(this.onRemove, this.expenses, {super.key});
  final void Function(Expense expense) onRemove;
  final List<Expense> expenses;

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: expenses.length,
      itemBuilder: (ctx, index) => Dismissible(
        background: Container(
          color: Theme.of(context).colorScheme.error.withOpacity(0.3),
          margin: EdgeInsets.fromLTRB(16, 20, 16, 20),
        ),
        //when the item is dismissed in a particular direction, it calls the onRemove function
        onDismissed: (direction) {
          onRemove(expenses[index]);
        },
        //the key  is like a unique tag it helps keep track of each Dismissible item uniquely.
        //So ValueKey is used to create a unique identifier for the specific expense item, to manage the Dismissible widget when its swiped
        key: ValueKey(
          ExpensesItem(expenses[index]),
        ),
        child: ExpensesItem(expenses[index]),
      ),
    );
  }
}
