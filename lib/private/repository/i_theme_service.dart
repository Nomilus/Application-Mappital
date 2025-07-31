abstract class IThemeService {
  void toggleTheme(bool value);
  Future<void> saveTheme(bool isDarkMode);
  Future<bool> getTheme();
}
