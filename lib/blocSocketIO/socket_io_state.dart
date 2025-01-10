import 'package:equatable/equatable.dart';
import 'package:socket_io_client/socket_io_client.dart';

class SocketIOState extends Equatable {
  
  final Socket? socket;

  const SocketIOState({
    this.socket
  });

  SocketIOState copyWith({
    Socket? socket
  }) {
    return SocketIOState(
      socket: socket ?? this.socket
    );
  }

  @override
  List<Object?> get props => [socket]; 
}