import 'package:inquran/data/aggregate/doa.dart';
import 'package:inquran/data/local/dao/doa_dao.dart';
import 'package:inquran/data/local/db/app_database.dart';

class DoaRepository {
  final DoaDao _doaDao;

  DoaRepository(this._doaDao);

  Future<List<DoaCategoryData>> getDoaCategories() =>
      _doaDao.getDoaCategories();

  Future<List<CompleteDoaData>> getDoasByCategory(int categoryId) =>
      _doaDao.getDoasByCategory(categoryId);
}