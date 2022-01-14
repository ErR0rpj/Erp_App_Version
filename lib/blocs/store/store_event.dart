import 'package:meta/meta.dart';
import 'package:equatable/equatable.dart';

abstract class StoreEvent extends Equatable {
  @override
  List<Object> get props => [];
}

class GetStoreName extends StoreEvent {
  final String token;

  GetStoreName({required this.token});

  @override
  List<Object> get props => [token];
}

class GetStoreItems extends StoreEvent {
  GetStoreItems();

  @override
  List<Object> get props => [];
}
