import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_application_1/posts.dart';
import 'package:http/http.dart' as http;

Future<Posts> buscaPost(int numero) async {
  final resposta =
      await http.get(Uri.parse('https://jsonplaceholder.typicode.com/posts/$numero'));

  if (resposta.statusCode == 200) {
    return Posts.fromJson(jsonDecode(resposta.body) as Map<String, dynamic>);
  } else {
    throw Exception('Falha ao carregar post');
  }
}

class NovaTela extends StatefulWidget {
  const NovaTela({super.key});

  @override
  State<NovaTela> createState() => _NovaTelaState();
}

class _NovaTelaState extends State<NovaTela> {
  late Future<Posts> post;
int contador = 1;
  void novoPost(){
    setState(() {
      contador++;
      post = buscaPost(contador);
    });
  }

  @override
  void initState() {
    super.initState();
    post = buscaPost(4);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text("Mostrando Posts"),
        ),
        body: Column(
          children: [
            Center(
              child: FutureBuilder<Posts>(
                future: post,
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    return Text(snapshot.data!.title!);
                  } else if (snapshot.hasError) {
                    return Text('${snapshot.error}');
                  }
            
                  return const CircularProgressIndicator();
                },
              ),
            ),
            ElevatedButton(onPressed: novoPost, child:Text('Novo Post'))
          ],
        ));
  }
}
