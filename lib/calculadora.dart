import 'package:expressions/expressions.dart';
import 'package:flutter/material.dart';

class Calculadora extends StatefulWidget {
  const Calculadora({super.key});

  @override
  State<Calculadora> createState() => _CalculadoraState();
}

class _CalculadoraState extends State<Calculadora> {
  final String _limpar = 'Limpar';
  String _expressao = '';
  String _resultado = '';

  void _pressionarBotao(String valor) {
    setState(() {
      if (valor == _limpar) {
        _expressao = '';
        _resultado = '';
      } else if (valor == '=') {
        _calcularResultado();
      } else {
        _expressao += valor;
      }
    });
  }

  void _calcularResultado() {
    try {
      _expressao = _expressao.replaceAll('x', '*').replaceAll('÷', '/');
      _expressao = _processarFatoriais(_expressao);
      ExpressionEvaluator avaliador = const ExpressionEvaluator();
      double resultado = avaliador.eval(Expression.parse(_expressao), {});
      setState(() {
        _resultado = resultado.toString();
      });
    } catch (e) {
      setState(() {
        _resultado = 'Não é possível calcular: $e';
      });
    }
  }

  String _processarFatoriais(String expressao) {
    final regExp = RegExp(r'(\d+)!');

    return expressao.replaceAllMapped(regExp, (match) {
      int num = int.parse(match.group(1)!);
      return _calcularFatorial(num).toString();
    });
  }

  int _calcularFatorial(int num) {
    if (num <= 1) return 1;
    return num * _calcularFatorial(num - 1);
  }

  Widget _botao(String valor) {
    return TextButton(
      child: Text(
        valor,
        style: const TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
      ),
      onPressed: () => _pressionarBotao(valor),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          child: Text(
            _expressao,
            style: const TextStyle(fontSize: 24),
          ),
        ),
        Expanded(
          child: Text(
            _resultado,
            style: const TextStyle(fontSize: 24),
          ),
        ),
        Expanded(
          flex: 3,
          child: GridView.count(
            crossAxisCount: 4,
            childAspectRatio: 2,
            children: [
              _botao('7'),
              _botao('8'),
              _botao('9'),
              _botao('÷'),
              _botao('4'),
              _botao('5'),
              _botao('6'),
              _botao('x'),
              _botao('1'),
              _botao('2'),
              _botao('3'),
              _botao('-'),
              _botao('0'),
              _botao(','),
              _botao('='),
              _botao('+'),
              _botao('.'),
              _botao('('),
              _botao(')'),
              _botao('!'),
            ],
          ),
        ),
        Expanded(
          child: _botao('Limpar'),
        )
      ],
    );
  }
}
