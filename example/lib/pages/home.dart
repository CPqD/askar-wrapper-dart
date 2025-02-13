import 'dart:io';

import 'package:askar_flutter_sdk/askar_wrapper.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import '../../pages/execute_page.dart';
import '../global.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key, required this.title});

  final String title;

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<MenuItem> menuItems = [
    MenuItem('Criar Profile'),
    MenuItem('Ler Categoria inexistente'),
    MenuItem('Escrevendo e lendo da sessão'),
    MenuItem('Inserindo e lendo uma chave'),
    MenuItem('Lendo todas as chaves'),
    MenuItem('Assinar Mensagem e verificar Assinatura'),
    MenuItem('Inserindo, Lendo e removendo chave'),
    MenuItem('Lendo chave'),
  ];

  @override
  initState() {
    super.initState();
    setStorage();
  }

  onDispose() {
    super.dispose();
    store?.close();
  }

  setStorage() async {
    store = Store(
        specUri: (Platform.isIOS || Platform.isAndroid)
            ? 'sqlite:/${(await getApplicationDocumentsDirectory()).path}/storage.db'
            : 'sqlite://storage.db',
        method: method,
        passKey: passKey,
        profile: profile,
        recreate: recreate);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.primary,
        title: Text(
          widget.title,
          style: TextStyle(color: Theme.of(context).colorScheme.onPrimary),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Align(
              alignment: Alignment.center,
              child: Text(
                'Askar Version ${askarVersion()}',
                style: Theme.of(context).textTheme.titleMedium,
              ),
            ),
            Expanded(
                child: ListView.builder(
                    itemCount: menuItems.length,
                    itemBuilder: (context, index) {
                      return Card(
                        child: ListTile(
                          title: Text(menuItems[index].title),
                          onTap: () async {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => ExecutePage(
                                        title: menuItems[index].title,
                                        index: index,
                                      )),
                            );
                          },
                        ),
                      );
                    }))
          ],
        ),
      ),
      // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}

class MenuItem {
  final String title;

  MenuItem(this.title);
}
