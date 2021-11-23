class RoleConstants {
  static const ADMIN = 'ADMIN';
  static const EMPLOYEE = 'EMPLOYEE';

  static String mapRoleToString(String? role) {
    switch (role) {
      case ADMIN:
        return ADMIN;
      case EMPLOYEE:
        return 'Nhân viên';
      default:
        return 'Nhân viên';
    }
  }
}
