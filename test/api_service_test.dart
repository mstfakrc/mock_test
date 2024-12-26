import 'package:flutter_test/flutter_test.dart'; // Test kütüphanesi
import 'package:mockito/annotations.dart'; // Mock sınıfı oluşturmak için gerekli
import 'package:mockito/mockito.dart'; // Mock sınıf davranışlarını tanımlamak için gerekli
import 'package:mock_test_project/services/api_service.dart'; // Gerçek ApiService
import 'package:mock_test_project/models/user_model.dart'; // Kullanıcı modeli
import 'api_service_test.mocks.dart'; // Otomatik oluşturulacak mock dosyasını import ediyoruz

@GenerateMocks([ApiService]) // ApiService için mock sınıfı oluşturuyoruz
void main() {
  group('ApiService Tests', () {
    late MockApiService mockApiService; // MockApiService nesnesi

    setUp(() {
      // Testlerden önce her zaman mockApiService nesnesini başlatıyoruz
      mockApiService = MockApiService();
    });

    // 1. Test: fetchUsers() metodu kullanıcı listesini başarıyla döndürüyor mu?
    test('Fetch users returns a list of users', () async {
      final mockUsers = [
        UserModel(id: 1, name: 'Ahmet'),
        UserModel(id: 2, name: 'Mehmet'),
      ];
      when(mockApiService.fetchUsers()).thenAnswer((_) async => mockUsers);
      final result = await mockApiService.fetchUsers();
      expect(result, isA<List<UserModel>>()); // Dönen değer bir liste mi?
      expect(result.length, 2); // Listenin uzunluğu 2 mi?
      expect(result[0].name, 'Ahmet'); // İlk kullanıcının adı doğru mu?
    });

    // 2. Test: fetchUsers() metodu boş bir liste döndürüyor mu?
    test('Fetch users returns an empty list', () async {
      when(mockApiService.fetchUsers()).thenAnswer((_) async => []);
      final result = await mockApiService.fetchUsers();
      expect(result, isA<List<UserModel>>()); // Dönen değer bir liste mi?
      expect(result.isEmpty, true); // Liste boş mu?
    });

    // 3. Test: fetchUsers() metodu bir hata fırlattığında doğru şekilde yakalanıyor mu?
    test('Fetch users throws an exception', () async {
      when(mockApiService.fetchUsers()).thenThrow(Exception('API Error'));
      expect(
        () async => await mockApiService.fetchUsers(),
        throwsA(isA<Exception>()), // Bir hata fırlatılmasını bekliyoruz
      );
    });

    // 4. Test: fetchUsers tek bir kullanıcı döndürüyor mu?
    test('Fetch users returns a single user', () async {
      final singleUser = [UserModel(id: 1, name: 'Fatma')];
      when(mockApiService.fetchUsers()).thenAnswer((_) async => singleUser);
      final result = await mockApiService.fetchUsers();
      expect(result, isA<List<UserModel>>()); // Dönen değer bir liste mi?
      expect(result.length, 1); // Listenin uzunluğu 1 mi?
      expect(result[0].name, 'Fatma'); // İlk kullanıcının adı doğru mu?
    });

    // 5. Test: fetchUsers zaman aşımına uğruyor mu?
    test('Fetch users throws a timeout exception', () async {
      when(mockApiService.fetchUsers()).thenAnswer(
        (_) => Future.delayed(Duration(seconds: 5), () => throw Exception('Timeout')),
      );
      expect(
        () async => await mockApiService.fetchUsers(),
        throwsA(isA<Exception>()), // Zaman aşımı hatasını bekliyoruz
      );
    });

    // 6. Test: fetchUsers farklı bir kullanıcı adı döndürüyor mu?
    test('Fetch users returns a user with a different name', () async {
      final mockUsers = [
        UserModel(id: 1, name: 'Ali'),
      ];
      when(mockApiService.fetchUsers()).thenAnswer((_) async => mockUsers);
      final result = await mockApiService.fetchUsers();
      expect(result[0].name, 'Ali'); // Kullanıcı adı doğru mu?
    });

    // 7. Test: fetchUsers listesinde kullanıcı sayısının doğru olması
    test('Fetch users returns correct number of users', () async {
      final mockUsers = [
        UserModel(id: 1, name: 'Ahmet'),
        UserModel(id: 2, name: 'Mehmet'),
        UserModel(id: 3, name: 'Ali'),
      ];
      when(mockApiService.fetchUsers()).thenAnswer((_) async => mockUsers);
      final result = await mockApiService.fetchUsers();
      expect(result.length, 3); // Kullanıcı sayısının 3 olmasını bekliyoruz
    });

    // 8. Test: fetchUsers boş bir liste döndürdüğünde doğru şekilde boş mu?
    test('Fetch users returns an empty list correctly', () async {
      when(mockApiService.fetchUsers()).thenAnswer((_) async => []);
      final result = await mockApiService.fetchUsers();
      expect(result.isEmpty, true); // Liste boş olmalı
    });

    // 9. Test: fetchUsers beklenmedik bir kullanıcı verisi döndürüyor mu?
    test('Fetch users returns unexpected user data', () async {
      final mockUsers = [
        UserModel(id: 1, name: 'Ahmet'),
        UserModel(id: 2, name: 'John'),
      ];
      when(mockApiService.fetchUsers()).thenAnswer((_) async => mockUsers);
      final result = await mockApiService.fetchUsers();
      expect(result[1].name, 'John'); // İkinci kullanıcının adı 'John' olmalı
    });

    // 10. Test: fetchUsers kullanıcı verilerini doğru şekilde alabiliyor mu?
    test('Fetch users correctly retrieves user data', () async {
      final mockUsers = [
        UserModel(id: 1, name: 'Ahmet'),
        UserModel(id: 2, name: 'Mehmet'),
      ];
      when(mockApiService.fetchUsers()).thenAnswer((_) async => mockUsers);
      final result = await mockApiService.fetchUsers();
      expect(result[0].id, 1); // İlk kullanıcının ID'si doğru mu?
      expect(result[1].id, 2); // İkinci kullanıcının ID'si doğru mu?
    });
  });
}
