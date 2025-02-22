import 'package:doormer/src/features/home/candidate/domain/entity/candidate_home_data_entity.dart';
import 'package:doormer/src/features/home/candidate/domain/entity/candidate_home_profile_entity.dart';
import 'package:doormer/src/features/home/candidate/domain/entity/company_match_entity.dart';
import 'package:doormer/src/features/home/candidate/domain/entity/news_entity.dart';
import 'package:doormer/src/features/home/candidate/domain/entity/profile_instruction_entity.dart';
import 'package:uuid/uuid.dart';

class HomeDataDTO {
  final CandidateHomeProfileDTO candidateProfile;
  final List<CompanyMatchDTO> companyMatches;
  final List<InstructionDTO> instructions;
  final List<NewsDTO> news;

  HomeDataDTO({
    required this.candidateProfile,
    required this.companyMatches,
    required this.instructions,
    required this.news,
  });

  factory HomeDataDTO.fromJson(Map<String, dynamic> json) {
    return HomeDataDTO(
      candidateProfile:
          CandidateHomeProfileDTO.fromJson(json['candidateProfile']),
      companyMatches: (json['companyMatches'] as List)
          .map((e) => CompanyMatchDTO.fromJson(e))
          .toList(),
      instructions: (json['instructions'] as List)
          .map((e) => InstructionDTO.fromJson(e))
          .toList(),
      news: (json['news'] as List).map((e) => NewsDTO.fromJson(e)).toList(),
    );
  }

  // Convert DTO to Entity.
  CandidateHomeDataEntity toEntity() {
    return CandidateHomeDataEntity(
      candidateProfile: candidateProfile.toEntity(),
      companyMatches: companyMatches.map((dto) => dto.toEntity()).toList(),
      instructions: instructions.map((dto) => dto.toEntity()).toList(),
      news: news.map((dto) => dto.toEntity()).toList(),
    );
  }
}

class CandidateHomeProfileDTO {
  final String firstName;
  final String lastName;
  final String profileAvatarUrl;

  CandidateHomeProfileDTO({
    required this.firstName,
    required this.lastName,
    required this.profileAvatarUrl,
  });

  factory CandidateHomeProfileDTO.fromJson(Map<String, dynamic> json) {
    return CandidateHomeProfileDTO(
      firstName: json['firstName'],
      lastName: json['lastName'],
      profileAvatarUrl: json['profileAvatarUrl'],
    );
  }

  // Convert DTO to Entity.
  CandidateHomeProfile toEntity() {
    return CandidateHomeProfile(
      firstName: firstName,
      lastName: lastName,
      profileAvatarUrl: profileAvatarUrl,
    );
  }
}

class CompanyMatchDTO {
  final UuidValue id;
  final String companyName;
  final String companyLogoUrl;

  CompanyMatchDTO({
    required this.id,
    required this.companyName,
    required this.companyLogoUrl,
  });

  factory CompanyMatchDTO.fromJson(Map<String, dynamic> json) {
    return CompanyMatchDTO(
      id: UuidValue(json['id']),
      companyName: json['companyName'],
      companyLogoUrl: json['companyLogoUrl'],
    );
  }

  // Convert DTO to Entity.
  CompanyMatchEntity toEntity() {
    return CompanyMatchEntity(
      id: id,
      companyName: companyName,
      companyLogoUrl: companyLogoUrl,
    );
  }
}

class InstructionDTO {
  final int totalFields;
  final int completedFields;
  final String nextFieldTip;

  InstructionDTO({
    required this.totalFields,
    required this.completedFields,
    required this.nextFieldTip,
  });

  factory InstructionDTO.fromJson(Map<String, dynamic> json) {
    return InstructionDTO(
      totalFields: json['totalFields'],
      completedFields: json['completedFields'],
      nextFieldTip: json['nextFieldTip'],
    );
  }

  // Convert DTO to Entity.
  InstructionEntity toEntity() {
    return InstructionEntity(
      totalFields: totalFields,
      completedFields: completedFields,
      nextFieldTip: nextFieldTip,
    );
  }
}

class NewsDTO {
  final UuidValue id;
  final String title;
  final String content;
  final DateTime publishedAt;

  NewsDTO({
    required this.id,
    required this.title,
    required this.content,
    required this.publishedAt,
  });

  factory NewsDTO.fromJson(Map<String, dynamic> json) {
    return NewsDTO(
      id: UuidValue(json['id']),
      title: json['title'],
      content: json['content'],
      publishedAt: DateTime.parse(json['publishedAt']),
    );
  }

  // Convert DTO to Entity.
  NewsEntity toEntity() {
    return NewsEntity(
      id: id,
      title: title,
      content: content,
      publishedAt: publishedAt,
    );
  }
}
