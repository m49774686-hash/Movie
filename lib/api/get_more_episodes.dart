import 'package:moviezone/models/movie_model.dart';
import 'package:shared_code/models/ott.dart';

Future<List<Episode>> getMoreEpisodes({required String s, required String series, required OTT ott, int? page}) async {
  // MovieZone /api/media/:id returns the complete TMDB season/episode metadata.
  return <Episode>[];
}
