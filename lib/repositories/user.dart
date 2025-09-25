
import 'package:mtqmnuns/data/remote/user.dart';
import 'package:mtqmnuns/dto/user.dart';

class UserRepository {
  final  UserRemoteDataSource remoteDataSource;

  UserRepository(this.remoteDataSource);

  Future<UserDto> getMeFromApi(String accessToken) {
    return remoteDataSource.fetchMe(accessToken);
  }

  Future getMeFromCache() async {}

  Future updateFullName() async {

  }

  Future updatePhoto() async {

  }
}