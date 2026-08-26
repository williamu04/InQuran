import 'package:inquran/repositories/doa.dart';
import 'package:inquran/state/doa.dart';
import 'package:inquran/state/stateful_viewmodel.dart';

class DoaListViewModel extends StatefulViewModel<DoaListState> {
  final DoaRepository _doaRepository;

  DoaListViewModel(this._doaRepository) : super(DoaListLoading()) {
    loadDoaCategories();
  }

  Future<void> loadDoaCategories() async {
    setState(DoaListLoading());
    try {
      final categories = await _doaRepository.getDoaCategories();
      setState(
        categories.isEmpty ? DoaListEmpty() : DoaListSuccess(categories),
      );
    } catch (e) {
      setState(DoaListError(e.toString()));
    }
  }
}

class DoaDetailViewModel extends StatefulViewModel<DoaDetailState> {
  final DoaRepository _doaRepository;

  DoaDetailViewModel(this._doaRepository) : super(DoaDetailLoading());

  Future<void> loadDoas(int categoryId) async {
    setState(DoaDetailLoading());
    try {
      final doas = await _doaRepository.getDoasByCategory(categoryId);
      setState(doas.isEmpty ? DoaDetailEmpty() : DoaDetailSuccess(doas));
    } catch (e) {
      setState(DoaDetailError(e.toString()));
    }
  }
}