class User {
  String name;
  String email;

  User({this.name,this.email});

  Map<String,String> asMap() => {
    'name':this.name,
    'email':this.email,
  };
}