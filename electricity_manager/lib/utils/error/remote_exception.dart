class RemoteException implements Exception {
  final String msg;

  RemoteException(this.msg);

  @override
  String toString() {
    return msg;
  }
}
