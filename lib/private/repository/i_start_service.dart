abstract class IStartService {
  void toggleStart(bool value);
  Future<void> saveStart(bool mode);
  Future<bool> getStart();
}
