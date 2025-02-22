import 'package:doormer/src/features/home/candidate/domain/entity/company_match_entity.dart';
import 'package:flutter/material.dart';

class CompanyCard extends StatelessWidget {
  final CompanyMatchEntity company;
  final VoidCallback onTap;

  const CompanyCard({required this.company, required this.onTap, super.key});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap, // Tap to open popup or navigate
      child: Card(
        elevation: 4.0,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Company Logo
              ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: Image.network(
                  company.companyLogoUrl,
                  height: 60,
                  width: 60,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) =>
                      const Icon(Icons.error, size: 60), // Handle image error
                ),
              ),
              const SizedBox(height: 8),

              // Company Name
              Text(
                company.companyName,
                style:
                    const TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
                textAlign: TextAlign.center,
                maxLines: 2,
                overflow: TextOverflow.ellipsis, // Prevent text overflow
              ),
            ],
          ),
        ),
      ),
    );
  }
}
