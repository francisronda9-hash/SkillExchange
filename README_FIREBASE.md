# SkillExchange — Firebase accounts and profiles

Open this project as a complete replacement working copy; keep your previous ZIP as a backup.
The approved ivory, navy and teal design and MVC folders are retained.

## 1. Finish Firebase setup

Use project `skillexchangeios-8f32d` at https://console.firebase.google.com/.

1. Authentication → Get started → Sign-in method → Email/Password: enable Email/Password and save. Email link sign-in is not used.
2. Firestore Database → Create database: choose Standard edition, the `(default)` database, your location, and Production mode.
3. Firestore Database → Rules: replace the rules with the complete contents of `firestore.rules` from this ZIP, then click Publish.
4. Do not manually create the users collection. The app creates `users/{Firebase UID}` on the first successful profile load.

Your supplied GoogleService-Info.plist is already included and matches bundle ID `MSEUF.SkillExchange`. No Android configuration is used. No changes were made to your live Firebase console by this delivery.

## 2. Open in Xcode

1. Extract the ZIP and open `SkillExchange.xcodeproj` inside the SkillExchange folder.
2. Wait for Swift Package Manager to resolve Firebase. FirebaseCore, FirebaseAuth and FirebaseFirestore are already attached to the target; do not add duplicate dependencies. The project allows Firebase 12.x starting at 12.0.0.
3. Select an installed iPhone simulator. The existing project deployment target is iOS 26.5; choose a compatible simulator/runtime. For a physical iPhone, select your development team under Signing & Capabilities.
4. Press Command-R. Use a full app run for Firebase testing rather than relying only on previews.
5. Tap Create account and use a real email address you control. Choose a password of at least six characters (Firebase console password policies may require more).
6. Open Profile → Settings → Edit profile to replace “New member” with your name and introduction. Add your own teaching and learning skills.

## Implemented in this phase

- Firebase email/password registration, login, persistent sign-in, logout and password reset.
- Separate cloud profile per Firebase UID; new accounts begin with empty skill lists. Old local demo data is not imported.
- Cloud load and save of name, introduction, availability, and add/edit/delete of both skill lists.
- Duplicate skill validation, limits of 50 skills per list, save progress, errors and retry for profile loading.
- Online transactions confirm saves before the UI reports success. Offline saves fail rather than silently becoming demo saves.
- A stale profile cannot overwrite a newer save from another device. The conflict message asks you to sign out and back in to refresh.
- Owner-only Firestore profile access. Other paths are denied for this phase. Passwords are handled by Firebase Auth and are never saved in Firestore or UserDefaults.

Profiles load from the server when you sign in or relaunch. This phase does not continuously listen for edits made on another device. Availability is a saved preference, not actual online presence.

## Still demonstrations

Home/Discover partners, exchange lists, session-only proposals, inbox previews and ratings are sample content. They do not connect real users yet. Matching, exchange lifecycle, chat, schedules and reviews follow in later phases. New screens and changed behavior should also be reflected in your Figma prototype.

## Manual acceptance checks on your Mac

1. Register account A. Verify it appears under Firebase Authentication → Users and its UID has a document in Firestore → users.
2. Edit name/about, add teaching and learning skills, change levels/icons, delete one, and toggle availability. Confirm corresponding fields change in Firestore.
3. Try blank/short names, duplicate skills and a mismatched password confirmation. No invalid save should occur. Cancel an edit and check the saved profile is unchanged.
4. Quit/relaunch and verify sign-in and saved profile return. Sign out and log back in; repeat.
5. Register account B and check it has a separate blank profile and empty skills. Sign in as A again and verify A's data remains intact.
6. Try an incorrect password and a duplicate registration email; check a visible error appears.
7. Sign out, request a password reset for your real account, follow the email link and log in with the changed password. Check spam if needed.
8. Disconnect the network, try a save and check that no success/dismiss occurs before confirmation. Reconnect and retry. Relaunch offline and check profile loading offers retry after an error.
9. On two devices signed into A, save an edit on device 1, then try saving stale data on device 2. Expect a conflict message; sign out/in on device 2 to refresh.
10. In the Firebase Rules Playground, verify: signed-out access denied; authenticated A can get/write users/A; A cannot get/write users/B; collection listing and unknown paths denied. Confirm extra fields and oversized name/about values are denied.

## Troubleshooting

- “Missing or insufficient permissions”: publish this ZIP's firestore.rules in the matching Firebase project.
- Sign-in provider disabled: enable Email/Password in Authentication.
- Profile will not load: confirm the `(default)` Firestore database exists, internet works, and rules are published. Tap Retry. Registration may already have succeeded; use Login rather than registering the same email again.
- Package download errors: check internet, then File → Packages → Resolve Package Versions.
- No such module FirebaseAuth/Firestore: wait for package resolution and ensure the project from this ZIP is the one open.

## Architecture and validation

Models contain data, Views render screens, Controllers coordinate actions/state, and ProfileService handles database operations. Combine's ObservableObject/Published are used to expose controller state to SwiftUI; this project retains MVC naming and responsibilities.

All 36 Swift files passed syntax parsing with tree-sitter; the Xcode project passed pbxproj parsing, and configuration JSON/plist files were checked. These checks do not type-check against Apple's SDK or Firebase.

Xcode, Apple's SDK and the iOS simulator are unavailable in the build workspace. A native build, live authentication, email delivery and live Firestore rules deployment have NOT been verified here. Complete the Mac checks above before submission. The old README_REDESIGN.md describes the previous local prototype; this README supersedes it for current behavior.

Official references:
- https://firebase.google.com/docs/ios/setup
- https://firebase.google.com/docs/auth/ios/password-auth
- https://firebase.google.com/docs/firestore/manage-data/transactions
- https://firebase.google.com/docs/firestore/security/get-started
