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
  String expression = '';
  bool justCalculated = false;
  bool hasSecondValue = false;
  bool hasError = false;
  bool isDark = true;

  void toggleTheme() {
    setState(() {
      isDark = !isDark;
    });
  }

  // Faz a conta em si, sem chamar setState (quem chama decide o rebuild).
  void _performCalculation() {
    if (!hasSecondValue) {
      return;
    }

    secondValue = double.parse(display);

    if (firstValue == null || secondValue == null) {
      return;
    }

    // Guarda a operação que acabou de ser realizada
    expression =
        "${formatResult(firstValue!)} $operation ${formatResult(secondValue!)}";

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
  }

  void calculate() {
    setState(() {
      // Sem operação pendente, "=" não faz nada (evita firstValue!/operation nulos)
      if (hasError || operation == null) {
        return;
      }

      _performCalculation();
    });
  }

  void addOperation(String newOperation) {
    setState(() {
      if (hasError) {
        return;
      }

      if (hasSecondValue) {
        // Já tem um segundo valor digitado: calcula a operação pendente antes de trocar.
        _performCalculation();
        if (hasError) {
          return;
        }
      } else if (operation == null) {
        // Primeira operação desta conta: agora sim fixa o primeiro valor.
        firstValue = double.parse(display);
      }
      // Se operation != null e !hasSecondValue, o usuário só está trocando
      // de operador (ex: apertou "+" e mudou de ideia pra "x") — mantém
      // firstValue como está, sem reler o display (que já virou "0").

      hasSecondValue = false;
      operation = newOperation;
      display = "0";
      justCalculated = false;

      // Mostra a operação na parte de cima
      expression = "${formatResult(firstValue!)} $operation";
    });
  }

  void addNumber(String number) {
    setState(() {
      if (hasError) return;
      if (justCalculated) {
        display = number;
        justCalculated = false;
        operation = null;
        firstValue = null;
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
      expression = "";
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

        // Evita ficar só com o sinal "-" sem nenhum dígito (crasharia no double.parse)
        if (display == "-") {
          display = "0";
        }
      } else {
        display = "0";
      }

      if (operation != null && display == "0") {
        hasSecondValue = false;
      }
    });
  }

  Widget calculatorButton({
    required String value,
    required VoidCallback onPressed,
    bool isOperator = false,
    bool isSpecial = false,
  }) {
    final backgroundColor = isOperator
        ? const Color(0xFF4858FF)
        : isSpecial
        ? (isDark ? const Color(0xFF555966) : const Color(0xFFD2D6DB))
        : (isDark ? const Color(0xFF292A30) : Colors.white);

    final textColor = isOperator
        ? Colors.white
        : (isDark ? Colors.white : Colors.black);

    return Expanded(
      child: AspectRatio(
        aspectRatio: 1,
        child: ElevatedButton(
          onPressed: onPressed,
          style: ElevatedButton.styleFrom(
            backgroundColor: backgroundColor,
            foregroundColor: textColor,
            elevation: 0,
            padding: EdgeInsets.zero,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(17),
            ),
          ),
          child: Text(
            value,
            style: const TextStyle(fontSize: 24, fontWeight: FontWeight.w400),
          ),
        ),
      ),
    );
  }

  Widget deleteButton() {
    return Expanded(
      child: AspectRatio(
        aspectRatio: 1,
        child: ElevatedButton(
          onPressed: deleteLastDigit,
          style: ElevatedButton.styleFrom(
            backgroundColor: isDark ? const Color(0xFF292A30) : Colors.white,
            foregroundColor: isDark ? Colors.white : Colors.black,
            elevation: 0,
            padding: EdgeInsets.zero,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(17),
            ),
          ),
          child: const Icon(Icons.backspace_outlined, size: 22),
        ),
      ),
    );
  }

  Widget calculatorKeyboard() {
    return Column(
      children: [
        Row(
          children: [
            calculatorButton(
              value: "C",
              onPressed: clearCalculator,
              isSpecial: true,
            ),
            const SizedBox(width: 10),
            calculatorButton(
              value: "+/-",
              onPressed: toggleSign,
              isSpecial: true,
            ),
            const SizedBox(width: 10),
            calculatorButton(
              value: "%",
              onPressed: addPercent,
              isSpecial: true,
            ),
            const SizedBox(width: 10),
            calculatorButton(
              value: "÷",
              onPressed: () => addOperation("÷"),
              isOperator: true,
            ),
          ],
        ),

        const SizedBox(height: 10),

        Row(
          children: [
            calculatorButton(value: "7", onPressed: () => addNumber("7")),
            const SizedBox(width: 10),
            calculatorButton(value: "8", onPressed: () => addNumber("8")),
            const SizedBox(width: 10),
            calculatorButton(value: "9", onPressed: () => addNumber("9")),
            const SizedBox(width: 10),
            calculatorButton(
              value: "×",
              onPressed: () => addOperation("x"),
              isOperator: true,
            ),
          ],
        ),

        const SizedBox(height: 10),

        Row(
          children: [
            calculatorButton(value: "4", onPressed: () => addNumber("4")),
            const SizedBox(width: 10),
            calculatorButton(value: "5", onPressed: () => addNumber("5")),
            const SizedBox(width: 10),
            calculatorButton(value: "6", onPressed: () => addNumber("6")),
            const SizedBox(width: 10),
            calculatorButton(
              value: "-",
              onPressed: () => addOperation("-"),
              isOperator: true,
            ),
          ],
        ),

        const SizedBox(height: 10),

        Row(
          children: [
            calculatorButton(value: "1", onPressed: () => addNumber("1")),
            const SizedBox(width: 10),
            calculatorButton(value: "2", onPressed: () => addNumber("2")),
            const SizedBox(width: 10),
            calculatorButton(value: "3", onPressed: () => addNumber("3")),
            const SizedBox(width: 10),
            calculatorButton(
              value: "+",
              onPressed: () => addOperation("+"),
              isOperator: true,
            ),
          ],
        ),

        const SizedBox(height: 10),

        Row(
          children: [
            calculatorButton(value: ".", onPressed: addDecimal),
            const SizedBox(width: 10),
            calculatorButton(value: "0", onPressed: () => addNumber("0")),
            const SizedBox(width: 10),
            deleteButton(),
            const SizedBox(width: 10),
            calculatorButton(
              value: "=",
              onPressed: calculate,
              isOperator: true,
            ),
          ],
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final backgroundColor = isDark
        ? const Color(0xFF131217)
        : const Color(0xFFEFF4F5);

    final primaryTextColor = isDark ? Colors.white : Colors.black;

    final secondaryTextColor = isDark
        ? const Color(0xFF77777F)
        : const Color(0xFF96969A);

    return Scaffold(
      backgroundColor: backgroundColor,
      body: SafeArea(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
            child: Column(
              children: [
                // Botão Dark / Light
                Align(
                  alignment: Alignment.topCenter,
                  child: GestureDetector(
                    onTap: toggleTheme,
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 300),
                      curve: Curves.easeInOut,
                      width: 62,
                      height: 32,
                      padding: const EdgeInsets.all(4),
                      decoration: BoxDecoration(
                        color: isDark ? const Color(0xFF292A30) : Colors.white,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: AnimatedAlign(
                        duration: const Duration(milliseconds: 300),
                        curve: Curves.easeInOut,
                        alignment: isDark
                            ? Alignment.centerRight
                            : Alignment.centerLeft,
                        child: AnimatedContainer(
                          duration: const Duration(milliseconds: 300),
                          curve: Curves.easeInOut,
                          width: 24,
                          height: 24,
                          decoration: const BoxDecoration(
                            shape: BoxShape.circle,
                            color: Color(0xFFD0D4DA),
                          ),
                          child: AnimatedSwitcher(
                            duration: const Duration(milliseconds: 200),
                            transitionBuilder: (child, animation) {
                              return FadeTransition(
                                opacity: animation,
                                child: child,
                              );
                            },
                            child: Icon(
                              isDark
                                  ? Icons.nightlight_round
                                  : Icons.wb_sunny_outlined,
                              key: ValueKey(isDark),
                              size: 16,
                              color: isDark
                                  ? const Color(0xFF4858FF)
                                  : const Color(0xFF7180FF),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),

                const Spacer(),

                // Expressão
                Align(
                  alignment: Alignment.centerRight,
                  child: Text(
                    expression,
                    style: TextStyle(
                      fontSize: 24,
                      color: secondaryTextColor,
                      fontWeight: FontWeight.w300,
                    ),
                  ),
                ),

                const SizedBox(height: 8),

                // Resultado
                Align(
                  alignment: Alignment.centerRight,
                  child: FittedBox(
                    fit: BoxFit.scaleDown,
                    child: Text(
                      display,
                      style: TextStyle(
                        fontSize: 64,
                        color: primaryTextColor,
                        fontWeight: FontWeight.w300,
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 24),

                // Teclado
                calculatorKeyboard(),

                const Spacer(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
