enum AppRoute {
  startup,
  welcome,
  businessSetup,
  home,
  reports,
  reportNew,
  reportDetail,
  reportEdit,
  reportPhotos,
  reportMaterials,
  reportSignatures,
  reportPdfPreview,
  customers,
  customerNew,
  customerDetail,
  customerEdit,
  settings,
  businessProfile,
  subscription,
  privacyPolicy,
  termsOfUse,
}

abstract final class RoutePaths {
  static const root = '/';
  static const startup = '/startup';
  static const welcome = '/onboarding';
  static const businessSetup = '/onboarding/business';
  static const home = '/home';
  static const reports = '/reports';
  static const reportNew = '/reports/new';
  static const reportDetail = '/reports/:reportId';
  static const reportEdit = '/reports/:reportId/edit';
  static const reportPhotos = '/reports/:reportId/photos';
  static const reportMaterials = '/reports/:reportId/materials';
  static const reportSignatures = '/reports/:reportId/signatures';
  static const reportPdfPreview = '/reports/:reportId/pdf';
  static const customers = '/customers';
  static const customerNew = '/customers/new';
  static const customerDetail = '/customers/:customerId';
  static const customerEdit = '/customers/:customerId/edit';
  static const settings = '/settings';
  static const businessProfile = '/settings/business';
  static const subscription = '/settings/subscription';
  static const privacyPolicy = '/settings/privacy-policy';
  static const termsOfUse = '/settings/terms-of-use';
}
