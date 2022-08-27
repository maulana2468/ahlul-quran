import 'package:dartz/dartz.dart';

import '../../../../core/error/exceptions.dart';
import '../../../../core/error/failures.dart';
import '../../domain/entities/verse_data.dart';
import '../../domain/repositories/verse_data_repository.dart';
import '../datasources/verse_data_remote_data_source.dart';

class VerseDataRepositoryImpl implements VerseDataRepository {
  final VerseDataRemoteDataSource verseDataRemoteDataSource;

  VerseDataRepositoryImpl({
    required this.verseDataRemoteDataSource,
  });
  @override
  Future<Either<Failure, List<VerseData>>> getVerseData(String number) async {
    try {
      final data = await verseDataRemoteDataSource.getVerseData(number);
      return Right(data);
    } on ServerException {
      return Left(ServerFailure());
    }
  }
}
