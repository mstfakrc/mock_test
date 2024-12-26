import '../models/user_model.dart';

// API çağrısı için bir abstract sınıf oluşturuyoruz
abstract class ApiService {
  Future<List<UserModel>> fetchUsers(); // Kullanıcıları getir
}
