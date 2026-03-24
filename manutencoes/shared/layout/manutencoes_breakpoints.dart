class ManutencoesBreakpoints {
  static const double mobile = 760;
  static const double desktop = 1024;

  static bool isMobile(double width) => width < mobile;

  static bool isTablet(double width) => width >= mobile && width < desktop;

  static bool isDesktop(double width) => width >= desktop;
}
