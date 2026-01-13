# Product Dashboard - Flutter Web App

A responsive product management dashboard built with **Flutter**, using **Cubit** (from flutter_bloc) for state management.  
It fetches products from the [dummyjson.com](https://dummyjson.com) mock API, supports search/filter, add/edit/delete via modal, and navigation to details page.

## Features

- Responsive product list (DataTable on desktop, Grid/Card on mobile)
- Search by name + filter by category + "In Stock Only" toggle
- Add / Edit product via modal form with basic validation
- View product details page
- Delete product
- Uses real mock API[](https://dummyjson.com/products)
- Clean feature-based folder structure
- GoRouter for navigation

### Optional / Bonus Features Implemented

- Responsive layout using `LayoutBuilder`
- Sidebar + Drawer navigation (for larger/smaller screens)
- Loading & error states with proper UI feedback
- Basic form validation
- Automatic product fetch on page load
- Use pagination technique for better user experience

## Technologies & Libraries

| Package              | Purpose                              | Version (example) |
|----------------------|--------------------------------------|-------------------|
| flutter_bloc         | State management (Cubit)             | ^8.1.3            |
| go_router            | Declarative routing & deep linking   | ^12.0.0           |
| equatable            | Value equality for entities/states   | ^2.0.5            |
| http                 | API calls                            | ^1.1.0            |
| get_it               | Dependency injection                 | ^7.6.0            |

## Folder Structure

lib/
├── core/                      # App-wide utilities & setup
│   ├── constants/             # API urls, colors, strings, etc.
│   ├── dependencies/          # get_it setup (injection_container.dart)
│   └── initialize_app/        # main.dart or app initialization
│
├── feature/
│   └── product/               # Feature: Products (Clean Architecture style)
│       ├── data/              # Data layer
│       │   ├── data_sources/  # Remote & local data sources
│       │   └── repositories/  # Repository implementations
│       ├── domain/            # Business logic layer (pure Dart)
│       │   ├── entities/      # ProductEntity
│       │   └── repositories/  # Abstract ProductRepositories
│       └── presentation/      # UI layer
│           ├── blocs/         # Cubits + states
│           ├── pages/         # Screens (ProductListPage, ProductDetailsPage)
│           └── widgets/       # Reusable components (ProductForm, etc.)
│
└── main.dart                  # Entry point

**Reasoning**:
- Feature-based structure → easier to scale (add users, orders, etc. later)
- Separation of concerns (data/domain/presentation) → clean architecture principles
- All product-related code lives in one place → better maintainability

## How to Run the Project

### Prerequisites

- Flutter SDK (3.19+ recommended, 3.22+ preferred)
- Chrome browser (for web target)

### Steps

1. **Clone the repository**

   git clone https://github.com/Zayahan-Hasan-Shah/tap-tap---task.git
   cd product_task

2. **Install dependencies**

    flutter pub get

3. Run in debug mode

    flutter run -d <device_name>  # device name can be emulator,phyiscal mobile, windows, chrome

4. **Build for production**

    flutter build <platform> # platform can apk for android, ipa for iOS, web for website
