abstract class GroupServices {
  Future<dynamic> addMember(
      {required List<String> members,
      required String groupId,
      required String gName});
  Future<dynamic> removeMember(
      {required String groupId, required String selectedId});
  Future<dynamic> makeAdmin(
      {required String groupId, required String selectedId});
  Future<dynamic> removeAdmin(
      {required String groupId, required String selectedId});

  Future<dynamic> adminOnlyMssage(
      {required String groupId, required bool currentState});
  Future<dynamic> exitGroup(
      {required String groupId, required String currentUserId});
  Future<dynamic> dismissGroup({required String groupId});
}
