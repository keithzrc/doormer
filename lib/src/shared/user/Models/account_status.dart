enum AccountStatus { active, pending, inactive }

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
      default:
        throw Exception('Unknown account status $accountStatus');
    }
  }
}
