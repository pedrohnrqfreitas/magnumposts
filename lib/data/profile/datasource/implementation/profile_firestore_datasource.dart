import '../../../../core/constants/firebase_constants.dart';
import '../../../../core/services/firestore/firestore_service.dart';
import '../../dto/profile_dto.dart';
import '../../models/params/create_profile_params.dart';
import '../../models/params/update_profile_params.dart';
import '../i_profile_datasource.dart';

class ProfileFirestoreDatasource implements IProfileDatasource {
  final FirestoreService firestoreService;

  ProfileFirestoreDatasource({required this.firestoreService});

  @override
  Future<ProfileDTO?> getProfile(String userId) async {
    try {
      final data = await firestoreService.getDocument(
        FirebaseConstants.profilesCollection,
        userId,
      );

      if (data == null) return null;

      return ProfileDTO.fromMap(data);
    } catch (e) {
      throw Exception('Erro ao buscar perfil: $e');
    }
  }

  @override
  Future<void> createProfile(CreateProfileParams params) async {
    try {
      final now = DateTime.now();
      final profileData = {
        'userId': params.userId,
        'name': params.name,
        'imageUrl': params.imageUrl,
        'postsCount': 0,
        'age': params.age,
        'interests': params.interests,
        'createdAt': now.toIso8601String(),
        'updatedAt': now.toIso8601String(),
      };

      await firestoreService.setDocument(
        FirebaseConstants.profilesCollection,
        params.userId,
        profileData,
      );
    } catch (e) {
      throw Exception('Erro ao criar perfil: $e');
    }
  }

  @override
  Future<void> updateProfile(UpdateProfileParams params) async {
    try {
      final updateData = <String, dynamic>{
        'updatedAt': DateTime.now().toIso8601String(),
      };

      if (params.name != null) updateData['name'] = params.name;
      if (params.imageUrl != null) updateData['imageUrl'] = params.imageUrl;
      if (params.postsCount != null) updateData['postsCount'] = params.postsCount;
      if (params.age != null) updateData['age'] = params.age;
      if (params.interests != null) updateData['interests'] = params.interests;

      await firestoreService.updateDocument(
        FirebaseConstants.profilesCollection,
        params.userId,
        updateData,
      );
    } catch (e) {
      throw Exception('Erro ao atualizar perfil: $e');
    }
  }

  Future<void> deleteProfile(String userId) async {
    try {
      await firestoreService.deleteDocument(
        FirebaseConstants.profilesCollection,
        userId,
      );
    } catch (e) {
      throw Exception('Erro ao deletar perfil: $e');
    }
  }

  Stream<ProfileDTO?> watchProfile(String userId) {
    try {
      return firestoreService.streamDocument(
        FirebaseConstants.profilesCollection,
        userId,
      ).map((doc) {
        if (!doc.exists || doc.data() == null) return null;
        return ProfileDTO.fromMap(doc.data()!);
      });
    } catch (e) {
      throw Exception('Erro ao observar perfil: $e');
    }
  }
}