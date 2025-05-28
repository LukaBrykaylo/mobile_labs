import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mobile_labs/cubit/qr/qr_cubit.dart';
import 'package:mobile_scanner/mobile_scanner.dart';

class QRScannerPage extends StatelessWidget {
  const QRScannerPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => QrCubit(),
      child: const QRScannerView(),
    );
  }
}

class QRScannerView extends StatelessWidget {
  const QRScannerView({super.key});

  void _onDetect(BuildContext context, BarcodeCapture capture) {
    final topic = capture.barcodes.first.rawValue;
    if (topic != null) {
      context.read<QrCubit>().scanTopic(topic);
    }
  }

  @override
  Widget build(BuildContext context) {
    final loginController = TextEditingController();
    final passwordController = TextEditingController();

    return BlocConsumer<QrCubit, QrState>(
      listener: (context, state) {
        if (state is QrAuthenticated) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Saved stream topic: ${state.streamTopic}')),
          );
          Navigator.pop(context);
        } else if (state is QrError) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(state.message)),
          );
        }
      },
      builder: (context, state) {
        if (state is QrInitial) {
          return Scaffold(
            body: MobileScanner(
                onDetect: (capture) => _onDetect(context, capture),),
          );
        } else if (state is QrScanSuccess || state is QrWaiting) {
          return Scaffold(
            appBar: AppBar(title: const Text('Login')),
            body: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  TextField(
                    controller: loginController,
                    decoration: const InputDecoration(labelText: 'Login'),
                  ),
                  TextField(
                    controller: passwordController,
                    decoration: const InputDecoration(labelText: 'Password'),
                  ),
                  const SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: () {
                      context.read<QrCubit>().sendAuth(
                            loginController.text,
                            passwordController.text,
                          );
                    },
                    child: state is QrWaiting
                        ? const CircularProgressIndicator()
                        : const Text('Send'),
                  ),
                ],
              ),
            ),
          );
        }
        return const SizedBox.shrink();
      },
    );
  }
}
