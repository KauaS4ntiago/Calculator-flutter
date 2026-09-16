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
  // Estado
  double? firstValue;
  double? secondValue;

  String display = '0';
  String? operation;

  bool justCalculated = false;
  bool hasSecondValue = false;
  bool hasError = false;

  // Configuração
  final List<String> operations = [
    "+",
    "-",
    "x",
    "÷",
    "=",
    "%",
    ".",
    "C",
    "+/-",
    "⌫",
  ];

  final List<String> numbers = [
    "1",
    "2",
    "3",
    "4",
    "5",
    "6",
    "7",
    "8",
    "9",
    "0",
  ];

  void addOperation(String operation) {
    setState(() {
      if (hasError) {
        return;
      }

      // Se já existe um segundo valor,
      // calcula a operação atual antes de trocar.
      if (hasSecondValue) {
        calculate();
      }

      firstValue = double.parse(display);
      hasSecondValue = false;
      this.operation = operation;
      display = "0";
      justCalculated = false;
    });
  }

  void addNumber(String number) {
    setState(() {
      if (hasError) {
        return;
      }

      if (justCalculated) {
        display = number;
        justCalculated = false;
      } else if (display == '0') {
        display = number;
      } else {
        display = display + number;
      }

      if (operation != null) {
        hasSecondValue = true;
      }
    });
  }

  void addDecimal() {
    setState(() {
      if (hasError) {
        return;
      }

      if (justCalculated) {
        display = "0.";
        justCalculated = false;
        return;
      }

      if (!display.contains(".")) {
        display += ".";
      }
    });
  }

  String formatResult(double value) {
    if (value == value.toInt()) {
      return value.toInt().toString();
    }

    return value.toString();
  }

  void clearCalculator() {
    setState(() {
      firstValue = null;
      secondValue = null;
      display = "0";
      operation = null;
      justCalculated = false;
      hasSecondValue = false;
      hasError = false;
    });
  }

  void addPercent() {
    setState(() {
      if (hasError) {
        return;
      }

      double value = double.parse(display);
      value = value / 100;

      display = formatResult(value);

      if (operation != null) {
        hasSecondValue = true;
      }
    });
  }

  void toggleSign() {
    setState(() {
      if (hasError) {
        return;
      }

      double value = double.parse(display);
      value = value * -1;

      display = formatResult(value);

      if (operation != null) {
        hasSecondValue = true;
      }
    });
  }

  void deleteLastDigit() {
    setState(() {
      if (hasError) {
        return;
      }

      if (display.length > 1) {
        display = display.substring(0, display.length - 1);
      } else {
        display = "0";
      }

      if (operation != null && display == "0") {
        hasSecondValue = false;
      }
    });
  }

  void handleOperation(String operation) {
    switch (operation) {
      case "=":
        if (this.operation == null) {
          break;
        }

        calculate();
        break;

      case "C":
        clearCalculator();
        break;

      case ".":
        addDecimal();
        break;

      case "%":
        addPercent();
        break;

      case "+/-":
        toggleSign();
        break;

      case "⌫":
        deleteLastDigit();
        break;

      default:
        addOperation(operation);
        break;
    }
  }

  void calculate() {
    setState(() {
      if (!hasSecondValue) {
        return;
      }

      secondValue = double.parse(display);

      if (firstValue == null || secondValue == null) {
        return;
      }

      switch (operation) {
        case "+":
          firstValue = firstValue! + secondValue!;
          break;

        case "-":
          firstValue = firstValue! - secondValue!;
          break;

        case "x":
          firstValue = firstValue! * secondValue!;
          break;

        case "÷":
          if (secondValue == 0) {
            display = "indefinido";
            hasError = true;
            return;
          }

          firstValue = firstValue! / secondValue!;
          break;
      }

      display = formatResult(firstValue!);

      secondValue = null;
      hasSecondValue = false;
      justCalculated = true;
    });
  }

  Widget numberButton(String number) {
    return SizedBox(
      width: 80,
      height: 60,
      child: ElevatedButton(
        onPressed: () {
          addNumber(number);
        },
        child: Text(number),
      ),
    );
  }

  Widget operationButton(String operation) {
    return SizedBox(
      width: 80,
      height: 60,
      child: ElevatedButton(
        onPressed: () {
          handleOperation(operation);
        },
        child: Text(operation),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text("$firstValue $operation $secondValue"),
            Text(display),

            const SizedBox(height: 16),

            SizedBox(
              width: 256,
              child: Wrap(
                spacing: 8,
                runSpacing: 8,
                children: [
                  ...numbers.map((number) {
                    return numberButton(number);
                  }).toList(),

                  ...operations.map((operation) {
                    return operationButton(operation);
                  }).toList(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
