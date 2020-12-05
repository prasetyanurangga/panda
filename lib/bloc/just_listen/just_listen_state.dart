import 'package:panda/models/just_listen_model.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

abstract class JustListenState extends Equatable {
  const JustListenState();

  @override
  List<Object> get props => [];
}

class JustListenInitial extends JustListenState {}

class JustListenLoading extends JustListenState {}

class JustListenSuccess extends JustListenState {
  final JustListen justListen;

  JustListenSuccess({@required this.justListen});

}

class JustListenFailure extends JustListenState {
  final String error;

  const JustListenFailure({@required this.error});

  @override
  List<Object> get props => [error];

  @override
  String toString() => 'JustListenFailure { error: $error }';
}
