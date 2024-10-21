import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_application_1/imagem.dart';
import 'package:http/http.dart' as http;

Future<Imagem> buscaImagem(int numero) async {
  final resposta =
      await http.get(Uri.parse('https://jsonplaceholder.typicode.com/photos/$numero'));

  if (resposta.statusCode == 200) {
    return Imagem.fromJson(jsonDecode(resposta.body) as Map<String, dynamic>);
  } else {
    throw Exception('Falha ao carregar imagem');
  }
}

class NovaTela extends StatefulWidget {
  const NovaTela({super.key});

  @override
  State<NovaTela> createState() => _NovaTelaState();
}

class _NovaTelaState extends State<NovaTela> {
  late Future<Imagem> imagem;
int contador = 1;
  void novaImagem(){
    setState(() {
      contador++;
      imagem = buscaImagem(contador);
    });
  }

  @override
  void initState() {
    super.initState();
    imagem = buscaImagem(1);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text("Mostrando Imagem"),
        ),
        body: Column(
          children: [
            Center(
              child: FutureBuilder<Imagem>(
                future: imagem,
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    return Column(
                      children: [
                        Text('Id: ${snapshot.data!.id}'),
                        Text('Title: ${snapshot.data!.title}'),
                        Image.network(snapshot.data!.url!),
                      ],
                    );

                  } else if (snapshot.hasError) {
                    return Text('${snapshot.error}');
                  }
            
                  return const CircularProgressIndicator();
                },
              ),
            ),
            ElevatedButton(onPressed: novaImagem, child:Text('Nova Imagem'))
          ],
        ));
  }
}
