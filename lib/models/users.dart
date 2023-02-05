class Users {
  Users({
    required this.id,
    required this.username,
    required this.fullname,
  });
  String id;
  String username;
  String fullname;

  factory Users.fromJson(Map<String, dynamic> payload) {
    return Users(
        id: payload['id'],
        username: payload['username'],
        fullname: payload['fullname']);
  }
}
