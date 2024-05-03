import 'dart:async';

import 'package:flutter/material.dart';
import 'package:english_words/english_words.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        primaryColor: const Color(0xFF92D954), // Color primario consistente
        scaffoldBackgroundColor: const Color(0xFFC0E3CA), // Color de fondo que combina con el encabezado
        appBarTheme: const AppBarTheme(
          backgroundColor: Color(0xFF92D954), // Color del encabezado
        ),
      ),
      home: SplashScreen(), // Iniciar con el SplashScreen
    );
  }
}

class SplashScreen extends StatefulWidget {
  const SplashScreen();

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    // Simular un proceso de carga con un retraso de 1 segundos
    Timer(Duration(seconds: 1), () {
      // Navegar a la pantalla principal después del tiempo de espera
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (context) => WordsScreen()),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircularProgressIndicator(), // Indicador de progreso
            SizedBox(height: 30),
            Text('Loading...'), // Texto de carga
          ],
        ),
      ),
    );
  }
}

class WordsScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Welcome to Flutter'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CustomButton(
              text: 'Words',
              onPressed: () => _navigateToRandomWordsScreen(context, false),
            ),
            const SizedBox(height: 35),
            CustomButton(
              text: 'Nouns',
              onPressed: () => _navigateToRandomWordsScreen(context, true),
            ),
          ],
        ),
      ),
    );
  }

  void _navigateToRandomWordsScreen(BuildContext context, bool showNouns) {
    Navigator.push(
      context,
      PageRouteBuilder(
        transitionDuration: Duration(milliseconds: 300), // Duración de la animación
        pageBuilder: (context, animation, secondaryAnimation) {
          return FadeTransition(
            opacity: animation,
            child: RandomWordsScreen(showNouns: showNouns),
          );
        },
      ),
    );
  }
}

class CustomButton extends StatelessWidget {
  final String text;
  final VoidCallback onPressed;

  const CustomButton({required this.text, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onPressed,
      child: Text(text),
    );
  }
}

class RandomWordsScreen extends StatefulWidget {
  final bool showNouns;

  const RandomWordsScreen({Key? key, required this.showNouns}) : super(key: key);

  @override
  _RandomWordsScreenState createState() => _RandomWordsScreenState();
}

class _RandomWordsScreenState extends State<RandomWordsScreen> {
  late final _suggestions = <WordPair>[];
  final _biggerFont = const TextStyle(fontSize: 20.0);
  final _scrollController = ScrollController();
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _generateWordPairs();
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _generateWordPairs() {
    _suggestions.addAll(generateWordPairs().take(15));
  }

  void _loadMoreSuggestions() {
    setState(() {
      _isLoading = true;
    });

    // Simular una carga de datos con un retraso de 1 segundo
    Timer(Duration(seconds: 1), () {
      setState(() {
        _suggestions.addAll(generateWordPairs().take(15));
        _isLoading = false;
      });
    });
  }

  void _onScroll() {
    if (!_isLoading && _scrollController.position.extentAfter < 500) {
      _loadMoreSuggestions();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.showNouns ? 'Nouns' : 'Words'),
      ),
      body: ListView.builder(
        controller: _scrollController,
        padding: const EdgeInsets.all(16.0),
        itemCount: _suggestions.length * 2, // Doble para incluir separadores
        itemBuilder: (context, i) {
          if (i.isOdd) return const Divider();
          final index = i ~/ 2;
          if (index >= _suggestions.length) {
            return _buildLoadingIndicator();
          }
          return _buildRow(_suggestions[index]);
        },
      ),
    );
  }

  Widget _buildRow(WordPair pair) {
    return ListTile(
      title: Text(
        widget.showNouns ? pair.second : pair.asPascalCase,
        style: _biggerFont,
      ),
    );
  }

  Widget _buildLoadingIndicator() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Center(
        child: CircularProgressIndicator(),
      ),
    );
  }
}
