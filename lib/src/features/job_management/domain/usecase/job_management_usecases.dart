import 'package:doormer/src/features/job_management/domain/usecase/auto_expire_jobs.dart';
import 'package:doormer/src/features/job_management/domain/usecase/create_job_posting.dart';
import 'package:doormer/src/features/job_management/domain/usecase/delete_job_posting.dart';
import 'package:doormer/src/features/job_management/domain/usecase/get_all_jobs.dart';
import 'package:doormer/src/features/job_management/domain/usecase/get_job_by_id.dart';
import 'package:doormer/src/features/job_management/domain/usecase/set_job_status.dart';
import 'package:doormer/src/features/job_management/domain/usecase/update_job_posting.dart';

/// A wrapper class that groups all job-related use cases.
class JobManagementUseCases {
  final CreateJobPosting createJobPosting;
  final UpdateJobPosting updateJobPosting;
  final DeleteJobPosting deleteJobPosting;
  final SetJobStatus setJobStatus;
  final GetAllJobs getAllJobs;
  final GetJobById getJobById;
  final AutoExpireJobs autoExpireJobs;

  JobManagementUseCases({
    required this.createJobPosting,
    required this.updateJobPosting,
    required this.deleteJobPosting,
    required this.setJobStatus,
    required this.getAllJobs,
    required this.getJobById,
    required this.autoExpireJobs,
  });
}
