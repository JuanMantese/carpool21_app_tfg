import 'package:carpool_21_app/src/domain/utils/resource.dart';
import 'package:equatable/equatable.dart';

class PaymentMethodState extends Equatable {
  final Resource? paymentsRes;

  const PaymentMethodState({
    this.paymentsRes,
  });

  PaymentMethodState copyWith({
    Resource? paymentsRes,
  }) {
    return PaymentMethodState(
      paymentsRes: paymentsRes ?? this.paymentsRes,
    );
  }

  @override
  List<Object?> get props => [
    paymentsRes,
  ];
}