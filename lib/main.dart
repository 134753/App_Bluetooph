import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'bloc/bluetooth/bluetooth_bloc.dart';
import 'bloc/wifi/wiFi_bloc.dart';
import 'screens/bluetooth_page.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Bluetooth & WiFi Scanner',
      home: MultiBlocProvider(
        providers: [
          BlocProvider(create: (_) => BluetoothBloc()),
          BlocProvider(create: (_) => WifiBloc()),
        ],
        child: const BluetoothPage(),
      ),
    );
  }
}
