# Union Shop — Flutter Coursework

A complete implementation of the Union Shop coursework project for the University of Portsmouth modules "Programming Applications and Programming Languages (M30235)" and "User Experience Design and Implementation (M32605)".

This Flutter app reproduces the core functionality of a student union shop: collections, product listings, product details, in-memory cart, and a personalisation workflow. The repository includes implemented Basic and Intermediate coursework features and notes on limitations and next steps.

---

**Key features**

- Responsive homepage with hero and featured products
- Collections listing and per-collection product detail pages (dynamic via in-repo services)
- Product pages with images, price, discount display, quantity selector and add-to-cart
- In-memory shopping cart with add/update/remove, totals and a non-monetary checkout flow
- Print Shack / Personalisation flow with dynamic options, validation and add-to-cart
- Responsive header/navbar and footer present across pages
- Sign In / Sign Up UI (non-functional placeholders as required by coursework)

---

## Quick start — Installation & Run

Prerequisites

- Flutter SDK (recommended 3.x or newer)
- Dart (bundled with Flutter)
- Platform tooling to run on your target (Android SDK, Xcode for iOS, desktop support or Chrome for web)

Clone the repository

```bash
git clone https://github.com/deanfoster720/union_shop.git
cd union_shop
```

Install dependencies and run

```bash
flutter pub get

# Run on Chrome (recommended for mobile-sized preview)
flutter run -d chrome

# Or run on available device/emulator
flutter run
```

Run tests

```bash
flutter test
```

Notes for Windows (bash): ensure `flutter` is on your PATH. Run `flutter doctor` if you encounter environment issues.

---

## Usage — main user flows

The app is designed for quick evaluation during a coursework demo. Typical flows:

- Browse collections: open **Collections** from the navbar to view curated collection tiles.
- Open a collection: tap a collection to view products in that collection.
- View a product: tap a product card to see details, images, price and quantity controls.
- Add to cart: select a quantity and use **Add to cart**. The app enforces a per-item maximum (configurable in `CartService`).
- Cart: open the Cart from the header icon to update quantities, remove items, or place a non-monetary order.
- Personalisation: open **Personalisation** (Print Shack) from the navbar to configure text/logo options; pricing updates dynamically and you can add personalised items to the cart.
- Authentication UI: open **Sign In** from the header to view Sign In / Sign Up forms (UI-only; non-functional as per coursework requirements).

Routes (declared in `lib/main.dart`)

- `/` — HomeScreen
- `/about` — AboutPage
- `/print_shack` — PrintShackPage
- `/personalisation` — PersonalisationPage
- `/shop` — ShopPage
- `/sign_in` — SignInPage
- `/collections` — CollectionsScreen
- `/sale` — SalesScreen

Screenshots

The original coursework README included screenshots demonstrating Chrome DevTools mobile view. The project contains assets used for site imagery under `Assets/` and example screenshot references in the original materials.

---

## Project structure

Top-level layout (key files/directories):

- `lib/main.dart` — App entrypoint and route table.
- `lib/core/widgets/` — Shared UI building blocks: `header.dart`, `footer.dart`, `base_scaffold.dart`.
- `lib/features/home/` — Home screen and `HomeService` for featured products.
- `lib/features/about/` — About pages including Print Shack info.
- `lib/features/collections/` — Collections pages, `CollectionService` and `CollectionRepository` with sample collections.
- `lib/features/products/` — Product models, `ProductRepository` (hardcoded sample data), product views and widgets.
- `lib/features/cart/` — `CartService`, `CheckoutService` and `CartPage` implementing in-memory cart logic and checkout flow.
- `lib/features/personalisation/` — Personalisation UI and `PersonalisationService` which generates unique personalisation product items and integrates with cart.
- `lib/features/auth/` — Sign In / Sign Up UI (non-functional placeholders).
- `Assets/` — Collection and product imagery (local assets referenced by products and collections).
- `test/` — Widget and service tests.

If you are exploring the codebase, `lib/main.dart` is a good starting point to see the route mapping and app theme.

---

## Technologies & dependencies

- Flutter and Dart — primary frameworks and language.
- All business logic and data are contained locally in the repo (no external backend required for the coursework features).
- Optional libraries you may add when extending the project: `shared_preferences` or `hive` (for local persistence), `firebase_auth` (for full auth), HTTP clients or databases if adding a backend.

Check `pubspec.yaml` for the exact dependency versions used by this project.

---

## Known issues and limitations

- Authentication: `SignInPage` provides UI only; there is no user account persistence or server authentication implemented.
- Cart persistence: `CartService` stores items in-memory only; cart contents are lost on app restart. Use `shared_preferences` or `hive` to add persistence.
- Product images: product entries reference local `Assets/` paths, but some image widgets use `Image.network` as a fallback; you may want to standardise on `Image.asset` for local images and ensure `pubspec.yaml` lists the asset paths.
- Search: header/footer show a search icon but no full search index/service is implemented. A quick client-side search could be wired to `ProductRepository.fetchAll()`.
- Tests: the repository includes basic tests; coverage is not comprehensive. Add unit and widget tests for cart and personalisation flows to strengthen the submission.

If you'd like, I can implement any of these improvements — tell me which one to prioritise.

---

## Development & contribution

Contributions are welcome following these basic guidelines:

1. Fork the repository and create a feature branch: `git checkout -b feat/my-change`.
2. Make small, focused commits with clear messages.
3. Add or update tests for new behaviors.
4. Submit a PR with a clear summary of changes.

Coding style: prefer clear, small functions, avoid duplicated logic and keep services (data access) separated from UI code.

---

## Contact & attribution

- Repository owner: `deanfoster720` (GitHub) — https://github.com/deanfoster720
- Original coursework materials provided by the module author (see original README text in the repo for links and images).

---

## Next steps (suggested enhancements)

- Add cart persistence (`shared_preferences` or `hive`).
- Convert image widgets to use `Image.asset` consistently and confirm `pubspec.yaml` asset entries.
- Implement client-side search and wire the header/footer search UI to it.
- Add optional Firebase authentication and a user dashboard for Advanced marks.
- Expand test coverage for cart, checkout and personalisation logic.