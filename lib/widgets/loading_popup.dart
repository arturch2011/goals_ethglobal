import 'package:flutter/material.dart';
import 'package:goals_ethglobal/screens/wallet_screen.dart';

class LoadingDialog extends StatelessWidget {
  const LoadingDialog({super.key});

  @override
  Widget build(BuildContext context) {
    return const AlertDialog(
      title: Text('Carregando...'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          LinearProgressIndicator(),
        ],
      ),
    );
  }
}

class AlertDialogCheck extends StatelessWidget {
  final String text;
  const AlertDialogCheck({super.key, required this.text});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Center(child: Text(text)),
      content: const Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            Icons.check_circle_outline,
            color: Colors.green,
            size: 64,
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          child: const Text('Fechar'),
        ),
      ],
    );
  }
}

class ErrorDialog extends StatelessWidget {
  final String text;
  const ErrorDialog({super.key, required this.text});

  @override
  Widget build(BuildContext context) {
    String error = text;
    if (text.contains('insufficient funds') ||
        text.contains('required exceeds')) {
      error = 'Saldo insuficiente !';
    } else if (text.contains('greater than minimum')) {
      error = 'O valor é menor que a aposta mínima !';
    } else if (text.contains('payment flow')) {
      error = 'Operaçao cancelada !';
    }
    return AlertDialog(
      title: Center(child: Text(error)),
      content: const Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            Icons.error,
            color: Colors.red,
            size: 64,
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          child: const Text('Fechar'),
        ),
        error.contains('insuficiente')
            ? TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) {
                        return const Wallet();
                      },
                    ),
                  );
                },
                style: ButtonStyle(
                  shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                    RoundedRectangleBorder(
                      borderRadius:
                          BorderRadius.circular(16.0), // Raio dos cantos
                    ),
                  ),
                  backgroundColor: MaterialStateProperty.all(
                    Theme.of(context).primaryColor,
                  ),
                  padding: MaterialStateProperty.all(
                    const EdgeInsets.all(5),
                  ),
                ),
                child: const Text('Recarregar',
                    style: TextStyle(color: Colors.white)),
              )
            : const SizedBox(),
      ],
    );
  }
}

void showLoadingDialog(BuildContext context) {
  showDialog(
    context: context,
    barrierDismissible: false,
    builder: (context) => const LoadingDialog(),
  );
}

void hideLoadingDialog(BuildContext context) {
  Navigator.pop(context);
}

void showCheckDialog(BuildContext context, info) {
  showDialog(
    context: context,
    barrierDismissible: false,
    builder: (context) => AlertDialogCheck(text: info),
  );
}

void showErrorDialog(BuildContext context, info) {
  showDialog(
    context: context,
    barrierDismissible: false,
    builder: (context) => ErrorDialog(text: info),
  );
}
