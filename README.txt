PEYMAN3D Flutter starter
========================

Files:
- main.dart: complete Persian RTL app UI and calculation/history logic.
- pubspec.yaml: Flutter dependencies; local history uses shared_preferences.

Important:
1. If your GitHub Actions workflow copies root main.dart into app/lib/main.dart,
   keep this main.dart at repository root as main.dart.
2. Make sure pubspec.yaml is copied to app/pubspec.yaml by the workflow.
3. In app/pubspec.yaml run `flutter pub get` then `flutter build apk --release`.
4. This is local-only storage. Orders are saved on the phone and are not synced.
5. Electricity power and Ender 3 depreciation are editable estimates.
6. The report is shown as selectable text; user can select/copy it. Native share/PDF export can be added later.
