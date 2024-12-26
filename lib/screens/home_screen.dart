import 'package:flutter/material.dart';
import '../services/api_service.dart';
import '../models/user_model.dart';

// Mock API servisi sınıfı
// Gerçek API'yi taklit eden sahte bir servis oluşturuluyor.
class MockApiService implements ApiService {
  // Kullanıcıları döndüren mock metot
  @override
  Future<List<UserModel>> fetchUsers() async {
    return Future.value([
      UserModel(id: 1, name: 'Ahmet'),
      UserModel(id: 2, name: 'Mehmet'),
      UserModel(id: 3, name: 'Zeynep'),
      UserModel(id: 4, name: 'Ali'),
      UserModel(id: 5, name: 'Ayşe'),
    ]);
  }

  // Boş liste döndüren mock metot
  Future<List<UserModel>> fetchEmptyList() async {
    return Future.value([]);  // Boş liste döndürüyor
  }

  // Hata fırlatan mock metot
  Future<List<UserModel>> fetchWithError() async {
    throw Exception('API Error');  // Hata fırlatıyor
  }

  // Gecikmeli liste döndüren mock metot
  Future<List<UserModel>> fetchWithDelay() async {
    await Future.delayed(const Duration(seconds: 2));  // 2 saniye gecikme
    return Future.value([
      UserModel(id: 1, name: 'Ali'),
      UserModel(id: 2, name: 'Ayşe'),
      UserModel(id: 3, name: 'Emre'),
      UserModel(id: 4, name: 'Zeynep'),
      UserModel(id: 5, name: 'Mehmet'),
    ]);
  }

  // Kullanıcıları filtreleyen mock metot
  Future<List<UserModel>> fetchFilteredUsers(String filter) async {
    final users = await fetchUsers();  // Kullanıcıları al
    return users.where((user) => user.name.contains(filter)).toList();  // Filtreye göre döndürüyor
  }
}

// HomeScreen widget'ı, API'den gelen veriyi kullanıcıya gösteriyor
class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

// HomeScreen state sınıfı
class _HomeScreenState extends State<HomeScreen> {
  final MockApiService apiService = MockApiService();  // MockApiService nesnesi
  List<UserModel> users = [];  // Kullanıcıları tutan liste
  String errorMessage = '';  // Hata mesajını tutar
  bool isLoading = false;  // Yükleniyor durumunu tutar

  // Kullanıcıları getiren fonksiyon
  void fetchUsers(Function apiMethod) async {
    setState(() {
      isLoading = true;  // Yükleniyor olarak işaretle
      errorMessage = '';  // Hata mesajını sıfırla
    });
    try {
      final result = await apiMethod();  // API metodunu çağır
      setState(() {
        users = result;  // Sonuçları kullanıcılar listesine aktar
      });
    } catch (e) {
      setState(() {
        errorMessage = e.toString();  // Hata oluşursa hata mesajını göster
      });
    } finally {
      setState(() {
        isLoading = false;  // Yükleme tamamlandı
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Mock API Test'),  // Başlık
      ),
      body: Column(
        children: [
          Expanded(
            child: isLoading
                ? const Center(child: CircularProgressIndicator())  // Yükleniyor simgesi
                : errorMessage.isNotEmpty
                    ? Center(child: Text('Error: $errorMessage'))  // Hata mesajı
                    : ListView.builder(
                        itemCount: users.length,  // Kullanıcı sayısı kadar liste oluştur
                        itemBuilder: (context, index) {
                          final user = users[index];  // Kullanıcıyı al
                          return ListTile(
                            title: Text(user.name),  // Kullanıcı adı
                            subtitle: Text('ID: ${user.id}'),  // Kullanıcı ID'si
                          );
                        },
                      ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),  // Padding ekleniyor
            child: Column(
              children: [
                // Kullanıcıları listeleyen buton
                ElevatedButton(
                  onPressed: () => fetchUsers(apiService.fetchUsers),
                  child: const Text('Kullanıcıları Listele'),
                ),
                // Boş listeyi gösteren buton
                ElevatedButton(
                  onPressed: () => fetchUsers(apiService.fetchEmptyList),
                  child: const Text('Boş Listeyi Göster'),
                ),
                // API hatası simüle eden buton
                ElevatedButton(
                  onPressed: () => fetchUsers(apiService.fetchWithError),
                  child: const Text('API Hatası Simüle Et'),
                ),
                // Gecikmeli listeyi döndüren buton
                ElevatedButton(
                  onPressed: () => fetchUsers(apiService.fetchWithDelay),
                  child: const Text('Gecikmeli Liste'),
                ),
                // 'A' harfiyle filtrelenmiş kullanıcıları listeleyen buton
                ElevatedButton(
                  onPressed: () => fetchUsers(() => apiService.fetchFilteredUsers('A')),
                  child: const Text('Filtrelenmiş Kullanıcılar'),
                ),
                // Yükleme simülasyonu yapan buton
                ElevatedButton(
                  onPressed: () {
                    fetchUsers(() async {
                      await Future.delayed(const Duration(seconds: 3));
                      return [
                        UserModel(id: 1, name: 'Test1'),
                        UserModel(id: 2, name: 'Test2'),
                      ];
                    });
                  },
                  child: const Text('Yükleme Simülasyonu'),
                ),
                // Simüle edilmiş hata butonu
                ElevatedButton(
                  onPressed: () {
                    fetchUsers(() async {
                      throw Exception('Simüle Edilen Hata');
                    });
                  },
                  child: const Text('Simüle Edilen Hata'),
                ),
                // Boş listeyi simüle eden buton
                ElevatedButton(
                  onPressed: () {
                    fetchUsers(() async => []);
                  },
                  child: const Text('Boş Listeyi Simüle Et'),
                ),
                // Gecikmeli veri alma butonu
                ElevatedButton(
                  onPressed: () => fetchUsers(apiService.fetchWithDelay),
                  child: const Text('Gecikmeli Veri Al'),
                ),
                // 'W' harfiyle filtrelenmiş ve boş liste döndüren buton
                ElevatedButton(
                  onPressed: () =>
                      fetchUsers(() => apiService.fetchFilteredUsers('W')),
                  child: const Text('Boş Filtre Sonucu'),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
