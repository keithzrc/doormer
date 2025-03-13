import 'package:doormer/src/features/job_management/domain/repository/job_management_repository.dart';
import 'package:doormer/src/features/job_management/domain/usecase/auto_expire_jobs.dart';
import 'package:doormer/src/features/job_management/domain/usecase/create_job_posting.dart';
import 'package:doormer/src/features/job_management/domain/usecase/delete_job_posting.dart';
import 'package:doormer/src/features/job_management/domain/usecase/get_all_jobs.dart';
import 'package:doormer/src/features/job_management/domain/usecase/get_job_by_id.dart';
import 'package:doormer/src/features/job_management/domain/usecase/job_management_usecases.dart';
import 'package:doormer/src/features/job_management/domain/usecase/set_job_status.dart';
import 'package:doormer/src/features/job_management/domain/usecase/update_job_posting.dart';
import 'package:get_it/get_it.dart';

final GetIt sl = GetIt.instance;

void initJobManagementDependencies() {
  // Register Repository Implementation
  //sl.registerLazySingleton<JobManagementRepository>(() => JobManagementRepositoryImpl());

  // Register Use Cases and Inject the Repository
  sl.registerLazySingleton(
      () => CreateJobPosting(sl<JobManagementRepository>()));
  sl.registerLazySingleton(
      () => UpdateJobPosting(sl<JobManagementRepository>()));
  sl.registerLazySingleton(
      () => DeleteJobPosting(sl<JobManagementRepository>()));
  sl.registerLazySingleton(() => SetJobStatus(sl<JobManagementRepository>()));
  sl.registerLazySingleton(() => GetAllJobs(sl<JobManagementRepository>()));
  sl.registerLazySingleton(() => GetJobById(sl<JobManagementRepository>()));
  sl.registerLazySingleton(() => AutoExpireJobs(sl<JobManagementRepository>()));

  // Register Use Case Wrapper with Injected Use Cases
  sl.registerLazySingleton(() => JobManagementUseCases(
        createJobPosting: sl<CreateJobPosting>(),
        updateJobPosting: sl<UpdateJobPosting>(),
        deleteJobPosting: sl<DeleteJobPosting>(),
        setJobStatus: sl<SetJobStatus>(),
        getAllJobs: sl<GetAllJobs>(),
        getJobById: sl<GetJobById>(),
        autoExpireJobs: sl<AutoExpireJobs>(),
      ));
}
