import 'package:chat/chat.dart';
import 'package:equatable/equatable.dart';

sealed class HomeState extends Equatable {}

final class HomeInitial extends HomeState {
  @override
  List<Object?> get props => [];
}

final class HomeLoading extends HomeState {
  @override
  List<Object?> get props => [];
}

class HomeSuccess extends HomeState {
  final List<User> onlineUsers;
  HomeSuccess(this.onlineUsers);
  @override
  // TODO: implement props
  List<Object?> get props => [onlineUsers];
}
