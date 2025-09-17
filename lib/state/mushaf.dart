import 'package:mtqmnuns/dto/mushaf.dart';

sealed class MushafState {}

class MushafLoading extends MushafState {}

class MushafPageLoaded extends MushafState {
  final int pageNumber;
  final List<MushafPagesItem> pageItems;

  MushafPageLoaded(this.pageItems, this.pageNumber);

  MushafPageLoaded copyWith({
    List<MushafPagesItem>? pageItems,
    int? pageNumber,
  }) {
    return MushafPageLoaded(
      pageItems ?? this.pageItems,
      pageNumber ?? this.pageNumber,
    );
  }
}

class MushafInit extends MushafState {}

class MushafError extends MushafState {
  final String message;
  MushafError(this.message);
}
