import 'package:supabase_flutter/supabase_flutter.dart';

class SupabaseService {
  static SupabaseService? _instance;
  static SupabaseService get instance => _instance ??= SupabaseService._();
  SupabaseService._();

  bool _isInitialized = false;
  bool get isInitialized => _isInitialized;

  SupabaseClient? get client {
    if (!_isInitialized) return null;
    return Supabase.instance.client;
  }

  Future<void> initialize({String? supabaseUrl, String? supabaseAnonKey}) async {
    // Read from provided credentials or fallback safely
    final url = supabaseUrl ?? const String.fromEnvironment('SUPABASE_URL', defaultValue: '');
    final anonKey = supabaseAnonKey ?? const String.fromEnvironment('SUPABASE_ANON_KEY', defaultValue: '');

    if (url.isNotEmpty && anonKey.isNotEmpty && url.startsWith('http')) {
      try {
        await Supabase.initialize(
          url: url,
          anonKey: anonKey,
        );
        _isInitialized = true;
      } catch (e) {
        _isInitialized = false;
      }
    } else {
      // Credentials not yet provided by user
      _isInitialized = false;
    }
  }

  // Sync operations
  Future<List<Map<String, dynamic>>?> fetchTable(String tableName) async {
    if (!_isInitialized || client == null) return null;
    try {
      final response = await client!.from(tableName).select();
      return List<Map<String, dynamic>>.from(response);
    } catch (_) {
      return null;
    }
  }

  Future<bool> insertRecord(String tableName, Map<String, dynamic> data) async {
    if (!_isInitialized || client == null) return false;
    try {
      await client!.from(tableName).insert(data);
      return true;
    } catch (_) {
      return false;
    }
  }

  Future<bool> updateRecord(String tableName, String idField, dynamic idValue, Map<String, dynamic> data) async {
    if (!_isInitialized || client == null) return false;
    try {
      await client!.from(tableName).update(data).eq(idField, idValue);
      return true;
    } catch (_) {
      return false;
    }
  }
}
