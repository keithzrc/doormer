// lib/features/home/domain/entities/instruction_entity.dart
class InstructionEntity {
  final int totalFields;
  final int completedFields;
  final String nextFieldTip;

  InstructionEntity({
    required this.totalFields,
    required this.completedFields,
    required this.nextFieldTip,
  });

  bool get isComplete => completedFields >= totalFields;
}
