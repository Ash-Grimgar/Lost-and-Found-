import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:lost_and_found/core/domain/usecases/get_address_from_position_usecase.dart';
import 'package:lost_and_found/core/domain/usecases/get_position_from_address_usecase.dart';

import 'client/position_client.dart';
import 'models/address_dto.dart';
import 'models/position_dto.dart';

abstract class PositionDataSource {
  Future<AddressDto> getAddressFromPosition(GetAddressFromPositionParams params);
  Future<PositionDto> getPositionFromAddress(GetPositionFromAddressParams params);
}

class PositionDataSourceImpl implements PositionDataSource {
  final PositionClient _client;

  PositionDataSourceImpl(this._client);

  @override
  Future<AddressDto> getAddressFromPosition(GetAddressFromPositionParams params) async {
    try {
      final uri = Uri.parse(
          'https://nominatim.openstreetmap.org/reverse?format=json&lat=${params.lat}&lon=${params.lon}&zoom=18&addressdetails=1');
      final res = await http.get(uri, headers: {
        'User-Agent': 'LostAndFoundApp/1.0',
      }).timeout(const Duration(seconds: 4));

      if (res.statusCode == 200) {
        final data = jsonDecode(res.body) as Map<String, dynamic>;
        final displayName = (data['display_name'] as String?) ?? '';
        if (displayName.isNotEmpty) {
          // Format cleaner address: street, suburb/city
          final address = data['address'] as Map<String, dynamic>?;
          if (address != null) {
            final road = address['road'] ?? address['pedestrian'] ?? address['path'] ?? '';
            final city = address['city'] ?? address['town'] ?? address['village'] ?? address['county'] ?? '';
            if (road.toString().isNotEmpty && city.toString().isNotEmpty) {
              return AddressDto(address: '$road, $city');
            }
          }
          return AddressDto(address: displayName);
        }
      }
    } catch (_) {}

    return AddressDto(
        address: '${params.lat.toStringAsFixed(4)}, ${params.lon.toStringAsFixed(4)}');
  }

  @override
  Future<PositionDto> getPositionFromAddress(GetPositionFromAddressParams params) async {
    try {
      final uri = Uri.parse(
          'https://nominatim.openstreetmap.org/search?format=json&q=${Uri.encodeComponent(params.address)}&limit=1');
      final res = await http.get(uri, headers: {
        'User-Agent': 'LostAndFoundApp/1.0',
      }).timeout(const Duration(seconds: 4));

      if (res.statusCode == 200) {
        final list = jsonDecode(res.body) as List<dynamic>;
        if (list.isNotEmpty) {
          final first = list.first as Map<String, dynamic>;
          final lat = double.tryParse(first['lat'].toString());
          final lon = double.tryParse(first['lon'].toString());
          if (lat != null && lon != null) {
            return PositionDto(lat: lat, lon: lon);
          }
        }
      }
    } catch (_) {}

    // University campus default fallback
    return const PositionDto(lat: 45.4064, lon: 11.8768);
  }
}
