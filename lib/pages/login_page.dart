import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:tomorrow_app/components/my_button.dart';
import 'package:tomorrow_app/components/my_textfield.dart';
import 'package:tomorrow_app/components/square_tile.dart';

class LoginPage extends StatefulWidget {
  final Function()? onTap;
  const LoginPage({super.key, required this.onTap});

  Future<void> checkAndAddUser() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      final userDoc = await FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .get();

      if (!userDoc.exists) {
        // Add the user to Firestore with groupId set to null
        await FirebaseFirestore.instance
            .collection('users')
            .doc(user.uid)
            .set({'groupId': null});
      } else {
        // User already exists, check and update groupId if needed
        if (userDoc.data()?['groupId'] == null) {
          await FirebaseFirestore.instance
              .collection('users')
              .doc(user.uid)
              .set({'groupId': null}, SetOptions(merge: true));
        }
      }
    }
  }

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  // text editing controllers
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  // sign user in method
  void signUserIn() async {
    //кружочек крутить
    showDialog(
      context: context,
      builder: (context) {
        return const Center(
          child: CircularProgressIndicator(),
        );
      },
    );

    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(
          email: emailController.text, password: passwordController.text);
      Navigator.pop(context);
    } on FirebaseAuthException catch (e) {
      Navigator.pop(context);

      if (emailController.text.isEmpty || passwordController.text.isEmpty) {
        emptyEmailPassMessage();
        return;
      }
      if (e.code == 'user-not-found') {
        wrongEmailPassMessage();
      }
      if (e.code == 'wrong-password') {
        wrongEmailPassMessage();
      } else {
        blyaderror(e.message as String, e.code as String);
      }
    }
  }

  void wrongEmailPassMessage() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
            title: Text('Введенные данные не верны'),
            content: IntrinsicHeight(
              child: SingleChildScrollView(
                child: Text("Попробуйте еще раз"),
              ),
            ));
      },
    );
  }

  void emptyEmailPassMessage() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
            title: Text('Пустовато как-то'),
            content: IntrinsicHeight(
              child: SingleChildScrollView(
                child: Text("Одно или два поля пустые, заполните их"),
              ),
            ));
      },
    );
  }

  void blyaderror(String ass, String dick) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(
              "Упс! что-то определенно пошло не так, как запланировано :( \n" +
                  "Код ошибки: " +
                  dick),
          content: IntrinsicHeight(
            child: SingleChildScrollView(
              child: Text(ass),
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[300],
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const SizedBox(height: 30),

                // logo
                Image.asset(
                  'lib/images/tmrrw_logo.png',
                  height: 100,
                  fit: BoxFit.cover,
                ),

                const SizedBox(height: 50),

                // username textfield
                MyTextField(
                  controller: emailController,
                  hintText: 'Почта',
                  obscureText: false,
                ),

                const SizedBox(height: 10),

                // password textfield
                MyTextField(
                  controller: passwordController,
                  hintText: 'Пароль',
                  obscureText: true,
                ),

                const SizedBox(height: 10),
                // not a member? register now

                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Нет учетной записи?',
                      style: TextStyle(color: Colors.grey[700]),
                    ),
                    const SizedBox(width: 4),
                    GestureDetector(
                      onTap: widget.onTap,
                      child: const Text(
                        'Зарегистрироватся',
                        style: TextStyle(
                          color: Colors.pink,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 40),

                // войти кнопка
                MyButton(
                  text: "Войти",
                  onTap: signUserIn,
                ),

                const SizedBox(height: 10),

                // пока не делали обячзательно сделаем
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 25.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'Забыли пароль?',
                        style: TextStyle(color: Colors.grey[600]),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 140),

                // or continue with
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 25.0),
                  child: Row(
                    children: [
                      Expanded(
                        child: Divider(
                          thickness: 0.5,
                          color: Colors.grey[400],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 10.0),
                        child: Text(
                          'Войти с помощью:',
                          style: TextStyle(color: Colors.grey[700]),
                        ),
                      ),
                      Expanded(
                        child: Divider(
                          thickness: 0.5,
                          color: Colors.grey[400],
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 20),

                // вход с помощью доп учеток
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: const [
                    // хз пока мудл(НАХУЙ)
                    //SquareTile(imagePath: 'lib/images/moodle.png'),

                    //SizedBox(width: 25),

                    // да хз пусть будет пока дискорд
                    SquareTile(imagePath: 'lib/images/discord.png'),

                    SizedBox(width: 25),

                    SquareTile(imagePath: 'lib/images/google.png'),
                    // с яблоком нам тоже не по пути
                    //SizedBox(width: 25),

                    //SquareTile(imagePath: 'lib/images/apple.png')
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
