# SkillExchange — Campus Edition

This is the redesigned SwiftUI interface, not the completed functionality phase.

## Open and run

1. Extract this ZIP into its own folder so you retain your previous local copy.
2. Open SkillExchange.xcodeproj.
3. Select an installed iPhone simulator compatible with the project's unchanged iOS 26.5 deployment target.
4. Build and run. Enter any nonempty email and password.

The original bundle identifier, signing settings and deployment target are unchanged.
No Firebase package or configuration file is needed for this preview.

## New design

Ivory background, navy editorial panels, teal actions, mint, coral and lavender cards.
Rounded typography, portrait avatars, larger partner cards and a five-tab layout.
All eight existing screen views were redesigned: login, home, discover, partner
profile, propose exchange, exchanges, inbox and personal profile.
The request success state is also redesigned. Photos come from the original Android
project assets. Sample availability, ratings and user data are not live.

## MVC organization

Models contain the user, skill and exchange records.
Controllers manage the preview session, user search and in-memory proposals.
Views render screens and send user actions to controllers.
Components and Theme contain shared styling and reusable SwiftUI views.
Each screen remains in a separate Swift file.

## What to test in Xcode

- Empty login fields show an error; nonempty fields open Home.
- Password visibility toggles without changing the entered text.
- Home actions open Discover, Exchanges and Profile.
- All five tabs open and remain above the device safe area.
- Search matches names and skills; Available now filters sample online users.
- Empty search results show an empty state.
- Partner cards open a profile; back navigation returns to the list.
- Propose an exchange opens a sheet; Close cancels without creating a proposal.
- Send proposal opens a success state and adds one local Sent item.
- Selected teaching skill, duration and optional message appear in Sent.
- Logout asks for confirmation; cancelling keeps the session open.
- Scroll all screens on a small iPhone and with larger accessibility text.
- Test email and password entry with the keyboard visible.

## Still pending

Firebase login, registration, password reset, cloud profiles, persistent exchanges,
accept/decline/complete actions, notifications, and live messaging.
Registration and reset controls explicitly explain this instead of pretending to work.
No data is sent to real people. Proposals reset after logout or app restart.
Do not treat screen count as proof that 50% of all planned functionality is complete.
Update your Figma prototype to match this approved new direction before submission.

## Skills and Settings update

Open Home or Profile to find Skills I can teach and Skills I want to learn.
Each section has Add skill and Manage. The editor saves a name, icon and level;
learning skills use the level as the target to reach. Manage supports editing
and deleting, with confirmation before deleting. The two lists are independent.
Blank, too-short, too-long and duplicate names are rejected. Duplicate checks
ignore capitalization, accents and extra whitespace within the same list.

Profile now has a Settings gear. Settings includes:
- Edit profile: name and introduction.
- Manage my skills.
- Open to exchanges: changes the profile's local availability badge.
- About SkillExchange.
- Sign out with confirmation.

Home and Profile update immediately when skills or profile information change.
Exchange proposals use the saved teaching skills instead of a fixed menu.
If the teaching list is empty, sending is disabled and Manage remains available.

Skills, name, introduction and availability are saved with Codable and
UserDefaults under SkillExchange.localProfile.v1. They survive relaunch and logout
on this device. The build still has ONE demo profile; entering a different email
does not create an independent account. No passwords are stored by this feature.
Deleting the app can delete its local data. Proposals still reset with the session.

### Acceptance check on your Mac

1. Add Photography to Can teach; select an icon and Advanced. Verify Home and Profile.
2. Add Spanish to Want to learn; set the target to Intermediate.
3. Try adding PHOTOGRAPHY again to Can teach; it should show a duplicate error.
4. Edit Photography to Portrait Photography; verify the old entry is replaced.
5. Cancel an edit; check that the saved entry is unchanged.
6. Delete Spanish; cancel once, then confirm. Check both Home and Profile.
7. Force quit and reopen; log in again and check that the saved lists remain.
8. Open a partner, propose an exchange and select Portrait Photography.
9. Delete all teaching skills; confirm sending a proposal is disabled.
10. Add a teaching skill through the proposal's Manage link; return and send.
11. Open Settings, edit your name and introduction, and toggle availability.
12. Check the Home greeting and Profile badge, then relaunch to check persistence.
13. Sign out via Settings and log back in; the local profile and skills remain.

These are manual runtime checks to perform in Xcode, not claims of tests executed
in this environment. Xcode and the simulator are unavailable here.

Persistence reference: https://developer.apple.com/documentation/foundation/userdefaults

## Verification

Project-source and asset checks, unchanged project settings, and ZIP integrity were
checked in the available Linux environment. Xcode, SwiftUI compilation, simulator
execution and native screenshot verification were not available. The build and
visual acceptance checklist above must be completed on the Mac.

SwiftUI reference: https://developer.apple.com/documentation/swiftui
