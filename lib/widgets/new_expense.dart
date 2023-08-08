import 'dart:io';

import 'package:flutter/material.dart';

import 'package:flutter/cupertino.dart';

import '../models/expense.dart';

class NewExpense extends StatefulWidget {
  const NewExpense({super.key, required this.addExpense});

  final void Function(Expense expense) addExpense;

  @override
  State<NewExpense> createState() => _NewExpenseState();
}

class _NewExpenseState extends State<NewExpense> {
  final _titleController = TextEditingController();
  final _amountController = TextEditingController();
  DateTime? _selectedDate;
  Category _selectedCategory = Category.leisure;

  void _presentDatePicker() async {
    final now = DateTime.now();
    final firstDate = DateTime(now.year - 1, now.month, now.day);
    final pickedDate = await showDatePicker(
      context: context,
      initialDate: now,
      firstDate: firstDate,
      lastDate: now,
    );
    setState(() {
      _selectedDate = pickedDate;
    });
  }

  @override
  void dispose() {
    // TODO: implement dispose
    _titleController.dispose();
    _amountController.dispose();
    super.dispose();
  }

  void _showDialog() {
    if (Platform.isAndroid) {
      showCupertinoDialog(
        context: context,
        builder: (ctx) => CupertinoAlertDialog(
          title: const Text('Invalid input'),
          content: const Text(
              'Please make sure a valid title, amount, date and category was entered.'),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(ctx).pop(),
              child: const Text('Okay'),
            ),
          ],
        ),
      );
    } else {
      showDialog(
        context: context,
        builder: (ctx) => AlertDialog(
          title: const Text('Invalid input'),
          content: const Text(
              'Please make sure a valid title, amount, date and category was entered.'),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(ctx).pop(),
              child: const Text('Okay'),
            ),
          ],
        ),
      );
    }
  }

  void _submitExpenseData() {
    final enteredAmount = double.tryParse(_amountController.text);
    final amountIsInvalid = enteredAmount == null || enteredAmount <= 0;
    if (_titleController.text.trim().isEmpty ||
        amountIsInvalid ||
        _selectedDate == null) {
      _showDialog();
      return;
    } else {
      widget.addExpense(
        Expense(
            category: _selectedCategory,
            title: _titleController.text,
            amount: enteredAmount,
            date: _selectedDate!),
      );
      Navigator.of(context).pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    final keyboardSpace = MediaQuery.of(context).viewInsets.bottom;
    return LayoutBuilder(
      builder: (ctx, constraint) {
        final width = constraint.maxWidth;
        return SizedBox(
          height: double.infinity,
          child: SingleChildScrollView(
            child: Padding(
              padding: EdgeInsets.fromLTRB(16, 48, 16, 16 + keyboardSpace),
              child: Column(
                children: [
                  if (width > 600)
                    Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                            child: TextField(
                              controller: _titleController,
                              maxLength: 50,
                              decoration:
                                  const InputDecoration(labelText: 'Title'),
                            ),
                          ),
                          const SizedBox(
                            width: 8,
                          ),
                          Expanded(
                            child: TextField(
                              controller: _amountController,
                              maxLength: 10,
                              keyboardType: TextInputType.number,
                              decoration: const InputDecoration(
                                  labelText: 'Amount', prefix: Text('đ')),
                            ),
                          ),
                        ])
                  else
                    TextField(
                      controller: _titleController,
                      maxLength: 50,
                      decoration: const InputDecoration(labelText: 'Title'),
                    ),
                  Row(
                    children: [
                      if (width < 600)
                        Expanded(
                          child: TextField(
                            controller: _amountController,
                            maxLength: 10,
                            keyboardType: TextInputType.number,
                            decoration: const InputDecoration(
                                labelText: 'Amount', prefix: Text('đ')),
                          ),
                        )
                      else
                        DropdownButton(
                          value: _selectedCategory,
                          items: Category.values
                              .map(
                                (category) => DropdownMenuItem(
                                  value: category,
                                  child: Text(
                                    category.name.toString(),
                                  ),
                                ),
                              )
                              .toList(),
                          onChanged: (value) {
                            if (value == null) {
                              return;
                            }
                            setState(() {
                              _selectedCategory = value;
                            });
                          },
                        ),
                      Expanded(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            TextButton(
                              onPressed: _presentDatePicker,
                              child: Text(
                                _selectedDate == null
                                    ? 'No date selected'
                                    : formatter.format(_selectedDate!),
                              ),
                            ),
                            Flexible(
                              child: IconButton(
                                icon: const Icon(Icons.calendar_month),
                                onPressed: _presentDatePicker,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 16,
                  ),
                  Row(
                    children: [
                      if (width < 600)
                        DropdownButton(
                          value: _selectedCategory,
                          items: Category.values
                              .map(
                                (category) => DropdownMenuItem(
                                  value: category,
                                  child: Text(
                                    category.name.toString(),
                                  ),
                                ),
                              )
                              .toList(),
                          onChanged: (value) {
                            if (value == null) {
                              return;
                            }
                            setState(() {
                              _selectedCategory = value;
                            });
                          },
                        ),
                      const Spacer(),
                      TextButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        child: const Text('Cancel'),
                      ),
                      ElevatedButton(
                        onPressed: _submitExpenseData,
                        child: const Text('Add Expense'),
                      ),
                    ],
                  )
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
