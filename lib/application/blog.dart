/// SPDX-License-Identifier: AGPL-3.0-or-later
import 'package:ghost/ghost.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'blog.g.dart';

@riverpod
BlogRepository _blogRepository(_BlogRepositoryRef ref) => BlogRepository();

@riverpod
Future<List<GhostPost>> _fetchArticles(_FetchArticlesRef ref) async {
  return ref.watch(_blogRepositoryProvider).getArticles();
}

class BlogRepository {
  Future<List<GhostPost>> getArticles() async {
    /// API KEY Hard coded
    /// From official doc: https://ghost.org/docs/content-api/
    /// "Content API keys are provided via a query parameter in the URL.
    /// These keys are safe for use in browsers and other insecure environments,
    /// as they only ever provide access to public data.
    /// Sites in private mode should consider
    /// where they share any keys they create."
    final api = GhostContentAPI(
      url: 'https://blog.archethic.net',
      key: 'aeec92562cfcb3f27993205631',
      version: 'v3',
    );

    return api.posts.browse(
      limit: 5,
      include: <String>['tags', 'authors'],
    );
  }
}

abstract class BlogProviders {
  static final fetchArticles = _fetchArticlesProvider;
}
