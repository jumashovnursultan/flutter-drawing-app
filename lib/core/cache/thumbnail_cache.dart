import 'dart:typed_data';
import 'dart:convert';

class ThumbnailCache {
  static final ThumbnailCache _instance = ThumbnailCache._internal();
  factory ThumbnailCache() => _instance;
  ThumbnailCache._internal();

  final Map<String, Uint8List> _cache = {};

  Uint8List? getThumbnail(String id) {
    return _cache[id];
  }

  void cacheThumbnail(String id, String base64Thumbnail) {
    try {
      _cache[id] = base64Decode(base64Thumbnail);
    } catch (e) {
      print('❌ Error caching thumbnail for $id: $e');
    }
  }

  void clearCache() {
    _cache.clear();
  }

  void removeThumbnail(String id) {
    _cache.remove(id);
  }

  int get cacheSize => _cache.length;
}
