import 'package:hive/hive.dart';

import 'package:path_provider/path_provider.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:flutter/material.dart';

import './model.dart'; 

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Hive.initFlutter();
  Hive.registerAdapter(ItemAdapter());
  await Hive.openBox('shoppingBox');

  // final appDocumentDirectory = await getApplicationDocumentsDirectory(); Profesor lo eliminó
  // Hive.init(appDocumentDirectory.path); Profesor lo eliminó
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Lista de Compras con Hive',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: ShoppingListPage(),
    );
  }
}
class ShoppingListPage extends StatefulWidget {
  @override
  _ShoppingListPageState createState() => _ShoppingListPageState();
}
class _ShoppingListPageState extends State<ShoppingListPage> {
  TextEditingController _controller = TextEditingController();
  final _shoppingBox = Hive.box('shoppingBox'); // Nombre para la caja (representacion de la tabla)

  @override
  void initState() {
    super.initState();
    // Abre la caja al iniciar el widget Profesor lo eliminó
    // _shoppingBox = Hive.box('shoppingBox'); Profesor lo eliminó
}
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Lista de Compras con Hive'),
      ),
      body: Column(
        children: <Widget>[
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: TextField(
            controller: _controller,
            decoration:
              InputDecoration(hintText: 'Introduce un producto'),
          ),
        ),
        Expanded(
          child: ValueListenableBuilder (
            valueListenable: _shoppingBox.listenable(),
            builder: (context,  itemsBox, _) {
              return ListView.builder(
                itemCount: itemsBox.length,
                itemBuilder: (context, index) {
                  final Item item = itemsBox.getAt(index) as Item;
                  return ListTile(
                    title: Text(item.name),
                    trailing: IconButton(
                      icon: Icon(Icons.delete),
                      onPressed: () {
                        itemsBox.deleteAt(index);
                      },
                    ),
                  );
                },
              );
            },
          ),
        ),
      ],
    ),
    floatingActionButton: FloatingActionButton(
      onPressed: () {
        if (_controller.text.isNotEmpty) {
          final newItem = Item(_controller.text);
          var nextItem = _shoppingBox.values.length + 1;
          _shoppingBox.put(nextItem, newItem);
          // print('Dato: ${_shoppingBox.get("Item")}'); Profesor lo eliminó
          _controller.clear();
        }
      },
      child: Icon(Icons.add),
    ),
  );
}

@override
void dispose() {
  // Cierra la caja específica cuando el widget ya no es necesario Profesor lo eliminó
  _shoppingBox.close();

  super.dispose();
  }
}
