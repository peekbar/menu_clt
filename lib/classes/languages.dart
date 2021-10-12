class Languages {
  Map<String, Map> _l = {
    'EN': {
      'opening_hours': 'Opening Hours',
      'imprint': {
        'title': 'Imprint',
        'name': 'Name',
        'address': 'Address',
        'phone': 'Phone',
        'mail': 'Mail',
        'tax': 'Tax ID'
      },
      'min_order': 'Minimum Order',
      'additives': 'Additives',
      'about': 'About this Page',
      'peekbar':
          'This website was generated with a tool by PEEKBAR. Please contact PEEKBAR, if you encounter any problems or if you have any feature requests. Please contact the business directly for issues with the content of this website.'
    },
    'DE': {
      'opening_hours': 'Öffnungszeiten',
      'imprint': {
        'title': 'Impressum',
        'name': 'Name',
        'address': 'Adresse',
        'phone': 'Telefon',
        'mail': 'Mail',
        'tax': 'Umsatzsteuer-ID'
      },
      'min_order': 'Mindestbestellwert',
      'additives': 'Zusatzstoffe',
      'about': 'Über diese Seite',
      'peekbar':
          'Diese Seite wurde mit einem Tool von PEEKBAR erstellt. Falls Sie Fragen, Probleme oder Verbesserungsvorschläge haben, können Sie sich gerne an PEEKBAR direkt wenden wenden. Wenden Sie sich für inhaltliche Probleme bitte an das Unternehmen.'
    }
  };

  // returns a list of the supported language codes
  List<String> getSupportedLanguages() {
    List<String> supported = [];

    _l.forEach((k, v) => supported.add(k));

    return supported;
  }

  Map? getSystemTitles(String? langCode) {
    return _l[langCode!];
  }
}
