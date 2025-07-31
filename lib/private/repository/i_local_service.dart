abstract class ILocalService {
  Future<void> saveToken(String token);
  Future<String?> getToken();
  Future<void> removeToken();
}
