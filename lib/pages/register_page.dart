import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:tomorrow_app/components/my_button.dart';
import 'package:tomorrow_app/components/my_textfield.dart';
import 'package:tomorrow_app/components/square_tile.dart';
import 'package:email_validator/email_validator.dart';

class RegisterPage extends StatefulWidget {
  final Function()? onTap;
  const RegisterPage({super.key, required this.onTap});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();

  void signUserUp() async {
    showDialog(
      context: context,
      builder: (context) {
        return const Center(
          child: CircularProgressIndicator(),
        );
      },
    );

    try {
      //проверка на одинаковые поля вы палоре
      if (passwordController.text == confirmPasswordController.text &&
          passwordController.text.length >= 8) {
        // Если пароли совпадают и длина >= 8, выполняем регистрацию
        await FirebaseAuth.instance.createUserWithEmailAndPassword(
            email: emailController.text, password: passwordController.text);
      }
      if (passwordController.text != confirmPasswordController.text) {
        // Если пароли НЕ совпадают
        Navigator.pop(context);
        passwordDontMatch();
        return;
      }
      if (!EmailValidator.validate(emailController.text)) {
        // Проверка корректности email
        Navigator.pop(context);
        invalidEmailMessage(); // Вызываем функцию для отображения ошибки
        return;
      }
      if (passwordController.text.length > 8) {
        if (mounted) {
          // Проверяем примонтирован ли виджет
          Navigator.pop(context);
        }
        passwordTooShort();
        return;
      }
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
                child: Text("Некоторые поля пустые, заполните их"),
              ),
            ));
      },
    );
  }

  void invalidEmailMessage() {
    // функция для отображения ошибки
    showDialog(
      context: context,
      builder: (context) {
        return const AlertDialog(
          title: Text('Неверный формат почты'),
          content:
              Text('Пожалуйста, введите корректный адрес электронной почты.'),
        );
      },
    );
  }

  void passwordTooShort() {
    // функция для отображения ошибки
    showDialog(
      context: context,
      builder: (context) {
        return const AlertDialog(
          title: Text('Пароль слишком короткий'),
          content: Text('Пароль должен содержать не менее 8 символов.'),
        );
      },
    );
  }

  void passwordDontMatch() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
            title: Text('Пароли не совпадают'),
            content: IntrinsicHeight(
              child: SingleChildScrollView(
                child: Text("Некоторые поля пароля не совпадают"),
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

                // лого
                Image.asset(
                  'lib/images/tmrrw_logo.png',
                  height: 100,
                  fit: BoxFit.cover,
                ),

                const SizedBox(height: 50),

                // имя
                MyTextField(
                  controller: emailController,
                  hintText: 'Почта',
                  obscureText: false,
                ),

                const SizedBox(height: 10),

                // пароль1
                MyTextField(
                  controller: passwordController,
                  hintText: 'Пароль',
                  obscureText: true,
                ),

                const SizedBox(height: 10),

                // подтверждиение паролдя
                MyTextField(
                  controller: confirmPasswordController,
                  hintText: 'Подтверждение пароля',
                  obscureText: true,
                ),

                const SizedBox(height: 10),
                // предложение войти

                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Уже зарегистрированы?',
                      style: TextStyle(color: Colors.grey[700]),
                    ),
                    const SizedBox(width: 4),
                    GestureDetector(
                      onTap: widget.onTap,
                      child: const Text(
                        'Войти',
                        style: TextStyle(
                          color: Colors.pink,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 40),

                // sign in button
                MyButton(
                  text: "Зарегистрироваться",
                  onTap: signUserUp,
                ),

                const SizedBox(height: 100),

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
