import 'package:doormer/src/features/home/candidate/domain/entity/company_match_entity.dart';
import 'package:doormer/src/features/home/candidate/presentation/widgets/company_card.dart';
import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';

class CompanyGrid extends StatelessWidget {
  final List<CompanyMatchEntity> companies;
  final Function(UuidValue companyId) onCompanyTap; // Passes ID to parent

  const CompanyGrid(
      {required this.companies, required this.onCompanyTap, super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(12.0),
      child: GridView.builder(
        itemCount: companies.length,
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          crossAxisSpacing: 8,
          mainAxisSpacing: 8,
          childAspectRatio: 1,
        ),
        itemBuilder: (context, index) {
          final company = companies[index];
          return CompanyCard(
            company: company,
            onTap: () => onCompanyTap(company.id), // Call parent function
          );
        },
      ),
    );
  }
}
