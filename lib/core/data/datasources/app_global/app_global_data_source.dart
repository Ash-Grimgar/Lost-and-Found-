import 'package:lost_and_found/core/data/datasources/app_global/clients/app_global_client.dart';
import 'package:lost_and_found/core/data/datasources/app_global/models/ip_details_dto.dart';
import 'package:lost_and_found/core/domain/usecases/usecase.dart';

abstract class AppGlobalDataSource {
  Future<IpDetailsDto> getCurrentCountry(NoParams params);
}

class AppGlobalDataSourceImpl implements AppGlobalDataSource {
  final AppGlobalClient _client;

  AppGlobalDataSourceImpl(this._client);

  @override
  Future<IpDetailsDto> getCurrentCountry(NoParams params) async {
    try {
      return await _client
          .getCurrentCountryInfo()
          .timeout(const Duration(seconds: 2));
    } catch (_) {
      return const IpDetailsDto(countryCode: "en");
    }
  }
}
