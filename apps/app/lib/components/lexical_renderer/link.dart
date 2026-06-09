List<String> pagesList = ['post'];

String? getPageRoute(String? text) {
  if (text == null) return null;

  String? route = pagesList.firstWhere(
    (page) => text.toLowerCase().startsWith(page.toLowerCase()),
    orElse: () => '',
  );
  if (route.isNotEmpty) {
    return route;
  }

  return null;
}

bool isPageExist(String? text) {
  if (text == null) return false;

  return getPageRoute(text) != null;
}
