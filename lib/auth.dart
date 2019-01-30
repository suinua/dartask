import 'package:dartask/model/user.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

User loginUser;

final _auth = FirebaseAuth.instance;

final _googleSignIn = GoogleSignIn();

Future<FirebaseUser> googleSignIn() async {
  GoogleSignInAccount googleUser = await _googleSignIn.signIn();
  GoogleSignInAuthentication googleAuth = await googleUser.authentication;
  FirebaseUser user = await _auth.signInWithGoogle(
    accessToken: googleAuth.accessToken,
    idToken: googleAuth.idToken,
  );
  return user;
}
Future<void> signOut() async {
  return _auth.signOut();
}