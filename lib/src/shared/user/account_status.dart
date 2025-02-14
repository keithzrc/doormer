enum AccountStatus { active, pending, inactive, partial }

extension AccountStatusExtension on AccountStatus {
  // Convert `AccountStatus` to API string
  String toApiString() {
    switch (this) {
      case AccountStatus.active:
        return 'active';
      case AccountStatus.pending:
        return 'pending';
      case AccountStatus.inactive:
        return 'inactive';
      case AccountStatus.partial:
        return 'partial';
    }
  }

  // Convert API string to `AccountStatus`
  static AccountStatus fromApiString(String accountStatus) {
    switch (accountStatus) {
      case 'active':
        return AccountStatus.active;
      case 'pending':
        return AccountStatus.pending;
      case 'inactive':
        return AccountStatus.inactive;
      case 'partial':
        return AccountStatus.partial;
      default:
        throw Exception('Unknown account status $accountStatus');
    }
  }
}
