import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

abstract class JustListenEvent extends Equatable {
  const JustListenEvent();
  @override
  List<Object> get props => [];
}

class Fetch extends JustListenEvent {}