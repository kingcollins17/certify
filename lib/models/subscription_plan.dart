import 'package:certify/utils/utils.dart';
import 'package:json_annotation/json_annotation.dart';

part 'subscription_plan.g.dart';

@JsonSerializable()
class SubscriptionPlan {
  final String id;
  final String name;
  final double price;
  final int scanLimit;
  final int generationLimit;
  final List<String> perks;

  SubscriptionPlan({
    required this.id,
    required this.name,
    required this.price,
    required this.scanLimit,
    required this.generationLimit,
    required this.perks,
  });

  factory SubscriptionPlan.fromJson(json) {
    return _$SubscriptionPlanFromJson((json as Map).cast());
  }

  Map<String, dynamic> toJson() => _$SubscriptionPlanToJson(this);

  @override
  toString() => HelperUtility().formatJson(toJson());
}

final List<SubscriptionPlan> subscriptionPlans = [
  SubscriptionPlan(
    id: 'free',
    name: 'Free',
    price: 0.0,
    scanLimit: 3,
    generationLimit: 2,
    perks: ['Basic support'],
  ),
  SubscriptionPlan(
    id: 'starter',
    name: 'Starter',
    price: 2.0,
    scanLimit: 10,
    generationLimit: 10,
    perks: ['Email support'],
  ),
  SubscriptionPlan(
    id: 'pro',
    name: 'Pro',
    price: 5.0,
    scanLimit: 50,
    generationLimit: 30,
    perks: ['Priority support'],
  ),
  SubscriptionPlan(
    id: 'enterprise',
    name: 'Enterprise',
    price: 10.0,
    scanLimit: 200,
    generationLimit: 100,
    perks: ['Custom branding', 'API access'],
  ),
];
