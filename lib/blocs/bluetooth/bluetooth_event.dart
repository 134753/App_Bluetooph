import 'package:equatable/equatable.dart';

abstract class BluetoothEvent extends Equatable {
  const BluetoothEvent();

  @override
  List<Object?> get props => [];
}

class StartScan extends BluetoothEvent {}

class StopScan extends BluetoothEvent {}
