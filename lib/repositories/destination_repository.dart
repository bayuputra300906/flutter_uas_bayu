import '../models/destination.dart';
import '../services/destination_service.dart';

class DestinationRepository {
  DestinationRepository(this._service);

  final DestinationService _service;

  Future<List<Destination>> getDestinations() async {
    final rows = await _service.getAll();
    return rows.map(Destination.fromJson).toList();
  }

  Future<Destination> addDestination(Destination d) async {
    final created = await _service.create(d.toJson());
    return Destination.fromJson(created);
  }

  Future<Destination> updateDestination(Destination d) async {
    final updated = await _service.update(d.id!, d.toJson());
    return Destination.fromJson(updated);
  }

  Future<void> deleteDestination(int id) => _service.delete(id);
}
