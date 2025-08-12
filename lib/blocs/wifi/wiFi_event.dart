import 'package:equatable/equatable.dart';

abstract class WifiEvent extends Equatable {
  const WifiEvent();

  @override
  List<Object?> get props => [];
}

class WifiStartScan extends WifiEvent {}

class WifiStopScan extends WifiEvent {}
