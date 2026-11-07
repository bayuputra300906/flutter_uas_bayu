import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart' as http;

import '../models/destination.dart';
import '../utils/secrets.dart';

class ApiException implements Exception {
  ApiException(this.message);
  final String message;

  @override
  String toString() => message;
}

class DestinationService {
  DestinationService({http.Client? client}) : _client = client ?? http.Client();

  final http.Client _client;
  static const Duration _timeout = Duration(seconds: 10);

  static final List<Destination> initialFallbackDestinations = [
    const Destination(
      id: 1,
      name: 'Kelingking Beach',
      location: 'Nusa Penida, Klungkung, Bali',
      category: 'Pantai',
      description:
          'Kelingking Beach adalah salah satu destinasi paling spektakuler di Bali dengan tebing ikonik berbentuk T-Rex, pasir putih lembut, dan air laut biru toska jernih. Tempat favorit wisatawan dunia untuk fotografi pemandangan dramatis.',
      imageUrl:
          'https://images.unsplash.com/photo-1537996194471-e657df975ab4?auto=format&fit=crop&w=1200&q=85',
      price: 25000,
      rating: 4.8,
      tags: ['24/7 Access', 'Scenic View', 'Island Friendly', 'Eco Friendly'],
    ),
    const Destination(
      id: 2,
      name: 'Tanah Lot Temple',
      location: 'Tabanan, Bali',
      category: 'Budaya',
      description:
          'Pura sakral yang bertengger gagah di atas bongkahan batu karang di tengah deburan ombak Samudra Hindia. Menyajikan panorama matahari terbenam (sunset) paling magis dan ikonik di Pulau Bali.',
      imageUrl:
          'https://images.unsplash.com/photo-1518548419970-58e3b4079ab2?auto=format&fit=crop&w=1200&q=85',
      price: 30000,
      rating: 4.7,
      tags: ['Budaya Sakral', 'Sunset View', 'Spot Foto', 'Parkir Luas'],
    ),
    const Destination(
      id: 3,
      name: 'Gunung Batur Kintamani',
      location: 'Kintamani, Bangli, Bali',
      category: 'Pegunungan',
      description:
          'Gunung berapi aktif dengan keindahan kaldera spektakuler dan Danau Batur. Jalur pendakian favorit untuk menikmati sunrise di atas awan, serta udara sejuk khas dataran tinggi Kintamani.',
      imageUrl:
          'https://images.unsplash.com/photo-1544644181-1484b3fdfc62?auto=format&fit=crop&w=1200&q=85',
      price: 100000,
      rating: 4.9,
      tags: ['Trekking', 'Sunrise Spot', 'Pemandangan Awan', 'Udara Sejuk'],
    ),
    const Destination(
      id: 4,
      name: 'Pura Ulun Danu Beratan',
      location: 'Bedugul, Tabanan, Bali',
      category: 'Wisata Alam',
      description:
          'Candi terapung legendaris di Danau Beratan dengan latar belakang perbukitan hijau berkabut. Terkenal sebagai salah satu pemandangan terindah di uang kertas pecahan Indonesia.',
      imageUrl:
          'https://images.unsplash.com/photo-1570789210967-2cac24afeb00?auto=format&fit=crop&w=1200&q=85',
      price: 50000,
      rating: 4.8,
      tags: ['Danau Asri', 'Perahu Wisata', 'Spot Ikonik', 'Taman Bunga'],
    ),
    const Destination(
      id: 5,
      name: 'Garuda Wisnu Kencana (GWK)',
      location: 'Jimbaran, Badung, Bali',
      category: 'Budaya',
      description:
          'Taman budaya seluas 60 hektar dengan mahakarya patung Garuda Wisnu Kencana setinggi 121 meter karya seniman Nyoman Nuarta, dilengkapi pertunjukan tari Kecak harian.',
      imageUrl:
          'https://images.unsplash.com/photo-1604999333679-b86d54738315?auto=format&fit=crop&w=1200&q=85',
      price: 125000,
      rating: 4.6,
      tags: ['Tari Tradisional', 'Mahakarya Seni', 'Plaza Luas', 'Food Court'],
    ),
    const Destination(
      id: 6,
      name: 'Ubud Monkey Forest Sanctuary',
      location: 'Ubud, Gianyar, Bali',
      category: 'Wisata Alam',
      description:
          'Cagar alam dan kompleks pura suci yang dinaungi hutan rindang dengan lebih dari 1000 ekor kera ekor panjang. Memberikan pengalaman harmoni antara alam, budaya, dan spiritualitas Bali.',
      imageUrl:
          'https://images.unsplash.com/photo-1539367628448-4bc5c9d171c8?auto=format&fit=crop&w=1200&q=85',
      price: 80000,
      rating: 4.7,
      tags: ['Hutan Lindung', 'Fauna Liar', 'Pohon Kuno', 'Akses Mudah'],
    ),
  ];

  Uri _uri([Map<String, String>? query]) {
    return Uri.parse('${Secrets.supabaseUrl}/rest/v1/destinations')
        .replace(queryParameters: query);
  }

  Map<String, String> get _headers => {
        'apikey': Secrets.supabaseAnonKey,
        'Authorization': 'Bearer ${Secrets.supabaseAnonKey}',
        'Content-Type': 'application/json',
      };

  Future<List<Map<String, dynamic>>> getAll() async {
    try {
      final res = await _send(
        () => _client.get(_uri({'select': '*', 'order': 'id.desc'}), headers: _headers),
      );
      final list = jsonDecode(res.body) as List;
      if (list.isEmpty) {
        return initialFallbackDestinations.map((d) => d.toJson()).toList();
      }
      return list.cast<Map<String, dynamic>>();
    } catch (_) {
      // Jika terjadi kendala koneksi, kembalikan data fallback lokal yang kaya
      return initialFallbackDestinations.map((d) => d.toJson()..['id'] = d.id).toList();
    }
  }

  Future<Map<String, dynamic>> create(Map<String, dynamic> data) async {
    final res = await _send(
      () => _client.post(
        _uri(),
        headers: {..._headers, 'Prefer': 'return=representation'},
        body: jsonEncode(data),
      ),
    );
    final list = jsonDecode(res.body) as List;
    if (list.isEmpty) return data;
    return (list.first as Map).cast<String, dynamic>();
  }

  Future<Map<String, dynamic>> update(int id, Map<String, dynamic> data) async {
    final res = await _send(
      () => _client.patch(
        _uri({'id': 'eq.$id'}),
        headers: {..._headers, 'Prefer': 'return=representation'},
        body: jsonEncode(data),
      ),
    );
    final list = jsonDecode(res.body) as List;
    if (list.isEmpty) return {...data, 'id': id};
    return (list.first as Map).cast<String, dynamic>();
  }

  Future<void> delete(int id) async {
    await _send(() => _client.delete(_uri({'id': 'eq.$id'}), headers: _headers));
  }

  Future<http.Response> _send(Future<http.Response> Function() request) async {
    try {
      final res = await request().timeout(_timeout);
      if (res.statusCode < 200 || res.statusCode >= 300) {
        throw ApiException('Server error (${res.statusCode}): ${res.body}');
      }
      return res;
    } on TimeoutException {
      throw ApiException('Koneksi timeout. Periksa jaringan Anda.');
    } on SocketException {
      throw ApiException('Tidak dapat terhubung ke server database.');
    } on http.ClientException catch (e) {
      throw ApiException('Client error: ${e.message}');
    }
  }
}
