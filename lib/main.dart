import 'package:flutter/material.dart';

void main() {
  runApp(const CalculatorApp());
}

class CalculatorApp extends StatelessWidget {
  const CalculatorApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: const CalculatorPage(),
    );
  }
}

class CalculatorPage extends StatefulWidget {
  const CalculatorPage({super.key});

  @override
  State<CalculatorPage> createState() {
    return _CalculatorPageState();
  }
}

class _CalculatorPageState extends State<CalculatorPage> {
  String display = '0';

  void addNumber(String number) {
    setState(() {
      if (display == '0') {
        display = number;
      } else {
        display = display + number;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(display),

            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton(
                  onPressed: () {
                    addNumber("1");
                  },
                  child: const Text("1"),
                ),
                ElevatedButton(
                  onPressed: () {
                    addNumber("2");
                  },
                  child: const Text("2"),
                ),
                ElevatedButton(
                  onPressed: () {
                    addNumber("3");
                  },
                  child: const Text("3"),
                ),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton(
                  onPressed: () {
                    addNumber("4");
                  },
                  child: const Text("4"),
                ),
                ElevatedButton(
                  onPressed: () {
                    addNumber("5");
                  },
                  child: const Text("5"),
                ),
                ElevatedButton(
                  onPressed: () {
                    addNumber("6");
                  },
                  child: const Text("6"),
                ),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton(
                  onPressed: () {
                    addNumber("7");
                  },
                  child: const Text("7"),
                ),
                ElevatedButton(
                  onPressed: () {
                    addNumber("8");
                  },
                  child: const Text("8"),
                ),
                ElevatedButton(
                  onPressed: () {
                    addNumber("9");
                  },
                  child: const Text("9"),
                ),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton(
                  onPressed: () {
                    addNumber("0");
                  },
                  child: const Text("0"),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
