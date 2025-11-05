class AppConstants {
  static const String appName = 'AccTally';
  static const String appVersion = '0.1.0';

  static const double defaultPadding = 16.0;
  static const double defaultRadius = 8.0;

  static const Duration defaultAnimationDuration = Duration(milliseconds: 300);
  static const Duration shortAnimationDuration = Duration(milliseconds: 150);
  static const Duration longAnimationDuration = Duration(milliseconds: 500);

  static const String dbName = 'acctally.db';

  static const String iconCost =
      '<svg xmlns="http://www.w3.org/2000/svg" width="24" height="24" viewBox="0 0 24 24"><g fill="none" stroke="currentColor" stroke-width="1.5"><path d="M17.414 10.414C18 9.828 18 8.886 18 7s0-2.828-.586-3.414m0 6.828C16.828 11 15.886 11 14 11h-4c-1.886 0-2.828 0-3.414-.586m10.828 0Zm0-6.828C16.828 3 15.886 3 14 3h-4c-1.886 0-2.828 0-3.414.586m10.828 0Zm-10.828 0C6 4.172 6 5.114 6 7s0 2.828.586 3.414m0-6.828Zm0 6.828ZM13 7a1 1 0 1 1-2 0a1 1 0 0 1 2 0Z"/><path stroke-linecap="round" d="M18 6a3 3 0 0 1-3-3m3 5a3 3 0 0 0-3 3M6 6a3 3 0 0 0 3-3M6 8a3 3 0 0 1 3 3M4 21.388h2.26c1.01 0 2.033.106 3.016.308a14.9 14.9 0 0 0 5.33.118m-.93-3.297q.18-.021.345-.047c.911-.145 1.676-.633 2.376-1.162l1.808-1.365a1.89 1.89 0 0 1 2.22 0c.573.433.749 1.146.386 1.728c-.423.678-1.019 1.545-1.591 2.075m-5.544-1.229l-.11.012m.11-.012a1 1 0 0 0 .427-.24a1.49 1.49 0 0 0 .126-2.134a1.9 1.9 0 0 0-.45-.367c-2.797-1.669-7.15-.398-9.779 1.467m9.676 1.274a.5.5 0 0 1-.11.012m0 0a9.3 9.3 0 0 1-1.814.004"/></g></svg>';

  static const String iconSales =
      '<svg xmlns="http://www.w3.org/2000/svg" width="48" height="48" viewBox="0 0 48 48"><rect width="48" height="48" fill="none"/><g fill="currentColor"><path fill-rule="evenodd" d="M12.098 8.711C14.533 7.491 18.648 6 23.165 6c4.433 0 8.448 1.437 10.872 2.643l.121.06c.653.33 1.184.641 1.568.897l-2.62 3.829l-1.48.768c-5.096 2.571-11.93 2.571-17.027 0l-1.303-.52l-2.77-4.077a14 14 0 0 1 .956-.567q.287-.156.616-.322m1.724 1.177c.924.29 1.904.544 2.9.728c2.159.398 4.333.457 6.193-.08c2.364-.684 4.845-1.239 7.17-1.567c-1.984-.653-4.383-1.169-6.92-1.169c-3.662 0-7.062 1.075-9.343 2.088" clip-rule="evenodd"/><path d="m32.437 15.804l.245-.124c2.507 2.678 4.854 6.117 6.252 9.62A9.95 9.95 0 0 0 34 24a10 10 0 0 0-8.561 4.83A4 4 0 0 0 23 28v-4c.87 0 1.611.555 1.887 1.333a1 1 0 1 0 1.885-.666A4 4 0 0 0 23 22v-1h-2v1a4 4 0 0 0 0 8v4c-.87 0-1.611-.555-1.887-1.333a1 1 0 1 0-1.885.666A4 4 0 0 0 21 36v1h2v-1q.61-.002 1.167-.173a10 10 0 0 0 3.534 5.94c-1.376.15-2.886.23-4.536.23c-24.461 0-18.031-17.07-9.61-26.31l.234.117c5.606 2.828 13.042 2.828 18.648 0"/><path d="M23 30c.623 0 1.18.285 1.546.732a10 10 0 0 0-.542 2.998c-.295.172-.638.27-1.004.27zm-4-4a2 2 0 0 1 2-2v4a2 2 0 0 1-2-2"/><path fill-rule="evenodd" d="M34 42a8 8 0 1 0 0-16a8 8 0 0 0 0 16m1-7.58l1.19-1.067l1.335 1.49L34 38.001l-3.525-3.16l1.335-1.489L33 34.42V30h2z" clip-rule="evenodd"/></g></svg>';
  static const String iconManagement =
      '<svg xmlns="http://www.w3.org/2000/svg" width="36" height="36" viewBox="0 0 36 36"><path fill="currentColor" d="M32 5H4a2 2 0 0 0-2 2v22a2 2 0 0 0 2 2h28a2 2 0 0 0 2-2V7a2 2 0 0 0-2-2m-9.44 20.94l-7.1-10.58l-6.34 9.28l-4.5-4L6 19.05l2.7 2.39l6.76-9.88l7.19 10.71l7-9.27l1.7 1.28Z" class="clr-i-solid clr-i-solid-path-1"/><path fill="none" d="M0 0h36v36H0z"/></svg>';
  static const String iconBEPAnalysis =
      '<svg xmlns="http://www.w3.org/2000/svg" width="24" height="24" viewBox="0 0 24 24"><rect width="24" height="24" fill="none"/><path fill="currentColor" d="M13 7.83c.85-.3 1.53-.98 1.83-1.83H18l-3 7c0 1.66 1.57 3 3.5 3s3.5-1.34 3.5-3l-3-7h2V4h-6.17c-.41-1.17-1.52-2-2.83-2s-2.42.83-2.83 2H3v2h2l-3 7c0 1.66 1.57 3 3.5 3S9 14.66 9 13L6 6h3.17c.3.85.98 1.53 1.83 1.83V19H2v2h20v-2h-9zM20.37 13h-3.74l1.87-4.36zm-13 0H3.63L5.5 8.64zM12 6c-.55 0-1-.45-1-1s.45-1 1-1s1 .45 1 1s-.45 1-1 1"/></svg>';
  static const String iconProduct =
      '<svg xmlns="http://www.w3.org/2000/svg" width="32" height="32" viewBox="0 0 32 32"><path fill="currentColor" d="M24 21v2h1.748A11.96 11.96 0 0 1 16 28C9.383 28 4 22.617 4 16H2c0 7.72 6.28 14 14 14c4.355 0 8.374-2.001 11-5.345V26h2v-5z"/><path fill="currentColor" d="m22.505 11.637l-5.989-3.5a1 1 0 0 0-1.008-.001l-6.011 3.5A1 1 0 0 0 9 12.5v7a1 1 0 0 0 .497.864l6.011 3.5A.96.96 0 0 0 16 24c.174 0 .36-.045.516-.137l5.989-3.5A1 1 0 0 0 23 19.5v-7a1 1 0 0 0-.495-.863m-6.494-1.48l4.007 2.343l-4.007 2.342l-4.023-2.342zM11 14.24l4 2.33v4.685l-4-2.33zm6 7.025v-4.683l4-2.338v4.683z"/><path fill="currentColor" d="M16 2A13.95 13.95 0 0 0 5 7.345V6H3v5h5V9H6.252A11.96 11.96 0 0 1 16 4c6.617 0 12 5.383 12 12h2c0-7.72-6.28-14-14-14"/></svg>';
  static const String iconPlus =
      '<svg xmlns="http://www.w3.org/2000/svg" width="24" height="24" viewBox="0 0 24 24"><path fill="currentColor" d="M18 10h-4V6a2 2 0 0 0-4 0l.071 4H6a2 2 0 0 0 0 4l4.071-.071L10 18a2 2 0 0 0 4 0v-4.071L18 14a2 2 0 0 0 0-4"/></svg>';
  static const String iconCategories =
      '<svg xmlns="http://www.w3.org/2000/svg" width="1024" height="1024" viewBox="0 0 1024 1024"><path fill="currentColor" d="M704 192h160v736H160V192h160v64h384zM288 512h448v-64H288zm0 256h448v-64H288zm96-576V96h256v96z"/></svg>';
}
