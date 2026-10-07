# Implementation Summary

## Completed

| Area | Status |
|---|---|
| Splash, session restore | Done |
| Login, logout (with confirmation) | Done |
| Registration (all API fields, dynamic department dropdown, image upload) | Done |
| Forgot password: send OTP, verify OTP, reset password | Done |
| Employee list: search, department filter, pagination, pull-to-refresh | Done |
| Employee details with call / SMS / email actions | Done |
| Departments list and per-department employee list | Done |
| My Profile, Settings | Done (see limitations) |
| Loading, empty, validation, network and 401 handling | Done |

## Where the design and the API disagree (and what I decided)

| Design shows | API reality | Decision |
|---|---|---|
| Login by "Email / Employee ID" | Login accepts email only | Label and validation say "Email Address" |
| "Login with Google" button | No endpoint | Shown as in the design but not functional |
| Registration with 5 fields | API also requires department, designation, date of joining | Added the three fields in the same style; department list comes from `/master` |
| Online status, Reporting To, Office Location | Not in the API | Omitted |
| Employee counts on the Departments screen | `/master` returns no counts | Omitted rather than making one extra call per department |
| Edit Profile button, camera badge on profile | No update endpoint | Edit Profile is shown but tells the user it is unavailable; camera badge omitted |
| Separate Search screen | List endpoint supports `search` | Search is inline on the list screen |
| Favorites tab | No API, no design | Placeholder empty state |
| Change Password, Notifications, Theme, About, Privacy, Help | No API | Placeholder ("Coming soon") |

## Trade-offs

- **Layers:** screen -> provider -> repository -> Dio. I did not add a separate "service" layer because it would only forward calls here.
- **Providers instead of a heavier pattern:** Provider with a small status enum kept the state code uniform across features.
- **Employee details:** the screen reuses data from the list response, which already contains every displayed field. `view-employee` is available if live detail refresh is needed. [EDIT if you wired it up]
- **Offline at launch:** if the profile check fails because the device is offline, the stored token is kept (the user lands on login but is not signed out of the stored session). Only a 401 clears it.
- **Pagination:** implemented from the `page` / `totalPages` fields in the list response. [EDIT: confirm whether the server honors `page`; the test data had a single page]

## Known limitations / API notes

- **`reset-password` does not verify the OTP server-side.** It accepts only `email` and `new_password`, so anyone who knows an email could reset that account through the API directly. The app enforces OTP verification before showing the reset screen, but this is a backend gap.
- Registration returns no token, so the user must log in after registering.
- The collection lists register, login and the other POST endpoints as GET at the request level, while the saved examples use POST. I followed the saved examples, as instructed.
- Sample data contains malformed values (for example an email ending in `.com12`); models parse defensively.
- OTP input assumes a 6-digit code, based on the sample in the collection.
- Tested on Android only.
- [EDIT: add anything else you know is broken or missing]

## Not done

- Dark theme / theme switching
- Favorites (client-side persistence)
- Dedicated search screen
- Automated tests