# TravelBuddy – Aplikasi Pencarian & Informasi Destinasi Wisata Bali

> **Ujian Tengah Semester (UTS) Pemrograman Mobile**  
> Program Studi Pendidikan Teknik Informatika (PTI) — Semester 4  
> Universitas Pendidikan Ganesha  

---

## 👤 Identitas Mahasiswa

| Informasi | Keterangan |
| :--- | :--- |
| **Nama Lengkap** | Gede Bayu Putra Darmawan |
| **NIM** | 2415051105 |
| **Kelas** | PTI 5A |
| **Mata Kuliah** | Pemrograman Mobile |
| **Dosen Pengampu** | Dr. Ir. I Ketut Resika Arthana, S.T., M.Kom |
| **Teaching Assistant** | Made Yuda Sadewa, S.Pd. |
| **Tema Project** | TravelBuddy – Aplikasi Pencarian dan Informasi Destinasi Wisata |
| **Repository GitHub** | [https://github.com/bayuputra300906/flutter_uas_bayu](https://github.com/bayuputra300906/flutter_uas_bayu) |

---

## 📱 Deskripsi Project

**TravelBuddy** adalah aplikasi mobile berbasis Flutter yang dirancang untuk mempermudah wisatawan mengeksplorasi destinasi wisata unggulan di Pulau Bali. Aplikasi ini menggabungkan integrasi **REST API publik (Open-Meteo)** untuk menampilkan kondisi cuaca live Pulau Bali, integrasi **Supabase PostgreSQL Database** untuk sinkronisasi katalog destinasi wisata dan personal itinerary/notes secara real-time, arsitektur bertingkat (**Clean/Layered Architecture**), serta desain responsif yang modern dan adaptif di berbagai ukuran layar (smartphone hingga tablet).

---

## ✨ Fitur Utama Aplikasi

1. **Onboarding & Welcome Flow**
   - Tampilan visual welcoming dengan foto hero Pulau Bali, tipografi modern, dan navigasi transisi sekali klik menuju Dashboard.
2. **Dashboard / Home Screen**
   - Header profil dinamis (*Greeting*, status lokasi Bali, foto profil avatar).
   - **Live Bali Weather Widget**: Informasi cuaca real-time langsung dari REST API (suhu, kondisi cuaca, emoji dinamis).
   - Quick Category Icons (Pantai, Wisata Alam, Budaya, Pegunungan, Kuliner).
   - **Nearby Destinations Carousel**: Kartu horizontal dengan foto beresolusi tinggi, rating badge, bookmark favorit, dan harga tiket.
   - **Popular Places Grid**: Rekomendasi destinasi teratas dengan layout responsif.
3. **Explore / Catalog Screen**
   - Fitur pencarian instan (nama, lokasi, deskripsi).
   - Filter kategori interaktif (*ChoiceChips*).
   - Pengurutan data (*Sorting* berdasarkan rating, harga terendah, harga tertinggi, dan abjad A-Z).
   - Tombol Floating Action Button (FAB) untuk menambah destinasi baru.
4. **Destination Detail Screen**
   - Header image berukuran besar dengan tombol navigasi melayang (*Back* & *Favorite*).
   - Chip fasilitas & keunggulan (*24/7 Access, Scenic View, Island Friendly, Eco Friendly*).
   - Deskripsi lengkap daya tarik wisata.
   - **Personal Travel Notes & Itinerary**: Catatan rencana perjalanan pribadi pengguna.
   - Action Bar di bagian bawah layar: Informasi harga tiket & tombol simpan ke Wishlist.
5. **Manajemen Data (CRUD Lengkap)**
   - **Create**: Form penambahan destinasi & catatan rencana dengan validasi form ketat.
   - **Read**: Pengambilan data dari Supabase PostgREST & REST API.
   - **Update**: Form edit data destinasi dan catatan perjalanan yang sudah ada.
   - **Delete**: Penghapusan data dengan **Confirmation Dialog** pengaman agar terhindar dari ketidaksengajaan.
6. **Favorites & Saved Wishlist**
   - Tab 1: Daftar destinasi favorit yang disimpan oleh pengguna (*Shared State*).
   - Tab 2: Catatan rencana perjalanan & status kunjungan (*Visited / Planned*).
7. **Profile / About Screen**
   - Identitas lengkap mahasiswa & mata kuliah.
   - Kartu statistik data (Total Destinasi, Favorit, dan Rencana).
   - Dialog "Tentang TravelBuddy".
8. **Responsive Layout**
   - **Compact Mode (< 750px)**: Bottom NavigationBar, Grid 2 kolom, detail screen vertikal.
   - **Wide / Tablet Mode (≥ 750px)**: Left NavigationRail, Grid 3–4 kolom, detail screen side-by-side.

---

## 🛠️ Tech Stack & Integrasi

- **Framework**: Flutter 3.13+ (Dart 3.13+)
- **State Management**: `Provider` + `ChangeNotifier`
- **Networking**: `http` package
- **REST API**:
  - **Open-Meteo Weather Forecast API** (`https://api.open-meteo.com/v1/forecast`) untuk data cuaca live Pulau Bali (Operasi GET, parsing JSON ke Dart Model `WeatherInfo`).
- **Backend & Database**:
  - **Supabase / PostgreSQL**: PostgREST API untuk tabel utama `destinations` dan personal travel notes.
  - Bebas credential sensitif (*hanya menggunakan anon/publishable key sesuai standar keamanan UTS*).

---

## 🏛️ Arsitektur Aplikasi

Aplikasi mengimplementasikan pemisahan tanggung jawab (*Separation of Concerns*) sesuai spesifikasi minimum:

```
lib/
├── models/                  # Representasi data & parsing JSON
│   ├── destination.dart
│   ├── travel_note.dart
│   └── weather_info.dart
├── services/                # Komunikasi jaringan & API/Database
│   ├── destination_service.dart
│   ├── travel_note_service.dart
│   └── weather_service.dart
├── repositories/            # Abstraksi data sumber & caching
│   ├── destination_repository.dart
│   ├── travel_note_repository.dart
│   └── weather_repository.dart
├── providers/               # State management (ChangeNotifier)
│   ├── destination_provider.dart
│   ├── favorites_provider.dart
│   ├── travel_note_provider.dart
│   └── weather_provider.dart
├── screens/                 # UI Layar Fungsional
│   ├── onboarding/
│   │   └── onboarding_screen.dart
│   ├── home/
│   │   └── home_screen.dart
│   ├── explore/
│   │   └── explore_screen.dart
│   ├── destination/
│   │   ├── destination_detail_screen.dart
│   │   ├── add_destination_screen.dart
│   │   └── edit_destination_screen.dart
│   ├── favorites/
│   │   └── favorites_screen.dart
│   └── profile/
│       └── profile_screen.dart
├── widgets/                 # Reusable & Custom UI Components
│   ├── destination_card.dart
│   ├── nearby_destination_card.dart
│   ├── feature_tag_chip.dart
│   ├── weather_banner.dart
│   ├── destination_form.dart
│   └── state_views.dart
├── utils/                   # Konstanta, tema & konfigurasi rahasia
│   ├── constants.dart
│   └── secrets.dart
└── main.dart                # Entry point & MultiProvider setup
```

**Alur Data:**  
`UI (Screen/Widget) ➔ State (Provider) ➔ Repository ➔ Service (Data Source) ➔ REST API / Supabase Database`

---

## ✅ Minimum Requirement Checklist

| Komponen Penilaian | Syarat UTS | Implementasi di TravelBuddy | Status |
| :--- | :---: | :--- | :---: |
| Screen fungsional | ≥ 6 | 8 Screen (Onboarding, Home, Explore, Detail, Add, Edit, Favorites, Profile) | ✅ Selesai |
| Dart Model | ≥ 2 | 3 Model (`Destination`, `TravelNote`, `WeatherInfo`) | ✅ Selesai |
| Reusable Widget | ≥ 3 | 6 Reusable Widgets (`DestinationCard`, `NearbyDestinationCard`, `FeatureTagChip`, `WeatherBanner`, `StateViews`, `DestinationForm`) | ✅ Selesai |
| Responsive Condition | ≥ 2 | Compact (<750px) & Wide (≥750px) via MediaQuery & LayoutBuilder | ✅ Selesai |
| REST API (GET) | Wajib | Open-Meteo Weather REST API & Supabase PostgREST | ✅ Selesai |
| Backend Database | ≥ 1 | Supabase PostgreSQL Table `destinations` | ✅ Selesai |
| Database Fields | ≥ 4 + ID | 8 Fields (`id`, `name`, `location`, `category`, `description`, `image_url`, `price`, `rating`) | ✅ Selesai |
| CRUD Database | 4 Operasi | Create, Read, Update, Delete | ✅ Selesai |
| Delete Confirmation | Wajib | `AlertDialog` konfirmasi sebelum menghapus data | ✅ Selesai |
| State Management | Provider | `MultiProvider` + `ChangeNotifier` (4 Providers) | ✅ Selesai |
| Shared State | Wajib | `FavoritesProvider` & `TravelNoteProvider` | ✅ Selesai |
| Multi-screen Nav | Wajib | `NavigationBar`, `NavigationRail`, `Navigator.push/pop` | ✅ Selesai |
| Passing Data | Wajib | Data ID & Model diteruskan antar list, detail, dan edit screen | ✅ Selesai |
| Form + Validation | Wajib | Form validasi nama, harga, lokasi, rating, deskripsi | ✅ Selesai |
| User Feedback | Wajib | `SnackBar` (success/error/undo), `AlertDialog` | ✅ Selesai |
| Loading/Error/Empty | Wajib | Handled di semua screen via `LoadingView`, `ErrorView`, `EmptyView` | ✅ Selesai |
| Meaningful Git Commits | ≥ 16 | 16 Commit bertahap sesuai milestone UTS | ✅ Selesai |

---

## 🚀 Cara Menjalankan Project

1. **Clone Repository:**
   ```bash
   git clone https://github.com/bayuputra300906/flutter_uas_bayu.git
   cd flutter_uas_bayu
   ```

2. **Install Dependensi:**
   ```bash
   flutter pub get
   ```

3. **Jalankan Pengujian Unit & Widget:**
   ```bash
   flutter test
   ```

4. **Jalankan Aplikasi:**
   ```bash
   flutter run
   ```
