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

  // Data fallback yang 100% selaras dengan tabel Supabase
  static final List<Destination> initialFallbackDestinations = [
    const Destination(
      id: 1,
      name: 'Pantai Kuta',
      location: 'Badung, Bali',
      category: 'Pantai',
      description: 'Pantai populer di Bali dengan pemandangan matahari terbenam yang indah.',
      imageUrl: 'https://images.unsplash.com/photo-1507525428034-b723cf961d3e?auto=format&fit=crop&w=1200&q=85',
      price: 20000,
      rating: 4.5,
      tags: ['Pantai Populer', 'Sunset View', 'Surfing', 'Akses Mudah'],
    ),
    const Destination(
      id: 2,
      name: 'Tanah Lot',
      location: 'Tabanan, Bali',
      category: 'Wisata Alam',
      description: 'Pura yang berada di atas batu karang dengan panorama laut yang menawan.',
      imageUrl: 'https://images.unsplash.com/photo-1537996194471-e657df975ab4?auto=format&fit=crop&w=1200&q=85',
      price: 30000,
      rating: 4.8,
      tags: ['Pura Karang', 'Sunset View', 'Spot Ikonik', 'Budaya'],
    ),
    const Destination(
      id: 3,
      name: 'Danau Beratan',
      location: 'Bedugul, Bali',
      category: 'Wisata Alam',
      description: 'Danau yang terkenal dengan Pura Ulun Danu Beratan.',
      imageUrl: 'https://images.unsplash.com/photo-1518548419970-58e3b4079ab2?auto=format&fit=crop&w=1200&q=85',
      price: 50000,
      rating: 4.7,
      tags: ['Danau Sejuk', 'Candi Terapung', 'Taman Bunga', 'Spot Foto'],
    ),
    const Destination(
      id: 4,
      name: 'Garuda Wisnu Kencana',
      location: 'Badung, Bali',
      category: 'Budaya',
      description: 'Taman budaya dengan patung Garuda Wisnu Kencana yang megah.',
      imageUrl: 'https://images.unsplash.com/photo-1604999333679-b86d54738315?auto=format&fit=crop&w=1200&q=85',
      price: 85000,
      rating: 4.6,
      tags: ['Patung Megah', 'Tari Tradisional', 'Plaza Luas', 'Seni Budaya'],
    ),
    const Destination(
      id: 5,
      name: 'Ubud Monkey Forest',
      location: 'Ubud, Bali',
      category: 'Wisata Alam',
      description: 'Kawasan hutan yang menjadi habitat monyet dan memiliki suasana alami.',
      imageUrl: 'https://images.unsplash.com/photo-1539367628448-4bc5c9d171c8?auto=format&fit=crop&w=1200&q=85',
      price: 80000,
      rating: 4.4,
      tags: ['Hutan Alami', 'Habitat Monyet', 'Pura Kuno', 'Udara Sejuk'],
    ),
    const Destination(
      id: 7,
      name: 'Gunung Agung',
      location: 'Karangasem, Bali',
      category: 'Pegunungan',
      description: 'Gunung tertinggi dan tersakral di Bali dengan pemandangan sunrise spektakuler di atas awan.',
      imageUrl: 'https://images.unsplash.com/photo-1698529471890-fddb93a2954f?auto=format&fit=crop&w=1200&q=85',
      price: 200000,
      rating: 4.8,
      tags: ['Trekking', 'Sunrise Spot', 'Puncak Tertinggi', 'Sangat Cantik'],
    ),
    const Destination(
      id: 8,
      name: 'Babi Guling',
      location: 'Gianyar Bali',
      category: 'Kuliner',
      description: 'Kuliner tradisional khas Bali yang lezat dan otentik.',
      imageUrl: 'https://images.unsplash.com/photo-1570275239833-cf846839b0f8?auto=format&fit=crop&w=1200&q=85',
      price: 25000,
      rating: 4.8,
      tags: ['Kuliner Khas', 'Otentik', 'Gianyar', 'Enak'],
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
        return initialFallbackDestinations.map((d) => d.toJson()..['id'] = d.id).toList();
      }
      return list.cast<Map<String, dynamic>>();
    } catch (_) {
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
