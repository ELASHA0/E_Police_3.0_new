import 'package:supabase_flutter/supabase_flutter.dart';

class AuthService {
  final SupabaseClient _supabase = Supabase.instance.client;

  // Sign in with email + password
  Future<AuthResponse?> signInWithEmailAndPassword(
    String email,
    String password,
  ) async {
    try {
      final response = await _supabase.auth.signInWithPassword(
        email: email,
        password: password,
      );
      return response;
    } on AuthException catch (e) {
      print("Auth Error: ${e.message}");
      return null;
    } catch (e) {
      print("Unexpected Error: $e");
      return null;
    }
  }

  // Register with email + password + name
  Future<AuthResponse?> registerWithEmailAndPassword(
    String email,
    String password,
    String name,
  ) async {
    try {
      final response = await _supabase.auth.signUp(
        email: email,
        password: password,
        data: {
          'name': name, // store extra user metadata
        },
      );
      return response;
    } on AuthException catch (e) {
      print("Auth Error: ${e.message}");
      return null;
    } catch (e) {
      print("Unexpected Error: $e");
      return null;
    }
  }

  // Sign out
  Future<void> signOut() async {
    try {
      await _supabase.auth.signOut();
    } catch (e) {
      print("Error signing out: $e");
    }
  }

  // Stream of user changes
  Stream<AuthState> get userChanges => _supabase.auth.onAuthStateChange;
}
