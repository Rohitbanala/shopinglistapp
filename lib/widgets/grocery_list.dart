import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shoping_list_app/data/categories.dart';
import 'package:shoping_list_app/models/grocery_item.dart';
import 'package:shoping_list_app/widgets/new_item.dart';

class GroceryList extends StatefulWidget {
  const GroceryList({super.key});

  @override
  State<GroceryList> createState() => _GroceryListState();
}

class _GroceryListState extends State<GroceryList> {
  List<GroceryItem> _groceryItems = [];
  var _isLoading = true;
  String? error;
  @override
  void initState() {
    _loadItems();
    super.initState();
  }

  void _loadItems() async {
    final url = Uri.https('shopinglistapp-91a0e-default-rtdb.firebaseio.com',
        'shopping-list.json');
    try {
      final response = await http.get(url);
      if (response.statusCode >= 400) {
        setState(() {
          error =
              'You have something problem while loading data. try after sometime';
        });
      }
      if (response.body == 'null') {
        setState(() {
          _isLoading = false;
        });
        return;
      }
      final Map<String, dynamic> listdata = json.decode(response.body);
      List<GroceryItem> loadItems = [];
      for (final item in listdata.entries) {
        final categoryName = categories.entries.firstWhere(
            (catItem) => catItem.value.title == item.value['category']);
        loadItems.add(GroceryItem(
            id: item.key,
            name: item.value['name'],
            quantity: item.value['quantity'],
            category: categoryName.value));
      }
      setState(
        () {
          _groceryItems = loadItems;
          _isLoading = false;
        },
      );
    } catch (err) {
      setState(() {
        error = 'something went wrong. try after sometime';
      });
    }
  }

  void _addItem() async {
    final addedItem = await Navigator.of(context).push<GroceryItem>(
      MaterialPageRoute(
        builder: (context) => const NewItem(),
      ),
    );
    if (addedItem == null) {
      return;
    }
    setState(() {
      _groceryItems.add(addedItem);
    });
  }

  void _removeItem(GroceryItem item) async {
    var index = _groceryItems.indexOf(item);
    setState(() {
      _groceryItems.remove(item);
    });
    final url = Uri.https('shopinglistapp-91a0e-default-rtdb.firebaseio.com',
        'shopping-list/${item.id}.json');
    final response = await http.delete(url);
    if (response.statusCode >= 400) {
      setState(() {
        _groceryItems.insert(index, item);
      });
    }
  }

  Widget build(BuildContext context) {
    Widget content = ListView.builder(
      itemCount: _groceryItems.length,
      itemBuilder: (context, index) => Dismissible(
        key: ValueKey(_groceryItems[index].id),
        onDismissed: (direction) {
          _removeItem(_groceryItems[index]);
        },
        background: Container(
          color: ThemeData().copyWith().colorScheme.error,
        ),
        child: ListTile(
          title: Text(_groceryItems[index].name),
          leading: Container(
            height: 20,
            width: 20,
            decoration: BoxDecoration(
              shape: BoxShape.rectangle,
              color: _groceryItems[index].category.color,
            ),
          ),
          trailing: Text(
            _groceryItems[index].quantity.toString(),
            style: const TextStyle(fontSize: 15),
          ),
        ),
      ),
    );
    if (_groceryItems.isEmpty) {
      content = const Center(
        child: Text(
          "You got no items yet...",
          style: TextStyle(color: Colors.white),
        ),
      );
    }
    if (_isLoading) {
      content = const Center(
        child: CircularProgressIndicator(),
      );
    }
    if (error != null) {
      content = Center(
        child: Text(
          error!,
          textAlign: TextAlign.center,
        ),
      );
    }
    return Scaffold(
      appBar: AppBar(
        title: const Text("Your Groceries"),
        actions: [
          IconButton(
            onPressed: _addItem,
            icon: const Icon(Icons.add),
          )
        ],
      ),
      body: content,
    );
  }
}
