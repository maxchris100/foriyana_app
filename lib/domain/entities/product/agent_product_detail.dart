import 'package:equatable/equatable.dart';

class AgentProductDetail extends Equatable {
  final String productId;
  final String promotionPlan;
  final DateTime promotionStart;
  final DateTime promotionEnd;

  const AgentProductDetail({
    required this.productId,
    required this.promotionPlan,
    required this.promotionStart,
    required this.promotionEnd,
  });

  @override
  List<Object?> get props => [
        productId,
        promotionPlan,
        promotionStart,
        promotionEnd,
      ];
}
