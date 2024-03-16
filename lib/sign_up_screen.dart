import 'package:flutter/material.dart';

class SignUpScreen extends StatefulWidget {
  @override
  _SignUpScreenState createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final _formKey = GlobalKey<FormState>();
  String name='';
  String lastname='';
  String username = '';
  String email = '';
  int age=0;
  String gender='Belirtmek İstemiyorum';
  String password = '';

  void _submit() {
    final isValid = _formKey.currentState!.validate();
    if (!isValid) {
      return;
    }
    _formKey.currentState!.save();
    // Burada, kullanıcı bilgilerini backend'e gönderme işlemini gerçekleştirin.
    print('Username: $username, Email: $email, Password: $password');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Üye Ol'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: <Widget>[
              Row(
                children: [
                  Expanded(
                    child: TextFormField(
                      decoration: InputDecoration(labelText: 'Ad'),
                      onSaved: (value) {
                        name = value!;
                      },
                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'Lütfen adınızı girin';
                        }
                        return null;
                      },
                    ),
                  ),
                  SizedBox(width: 15,),
                  Expanded(
                    child: TextFormField(
                      decoration: InputDecoration(labelText: 'Soyad'),
                      onSaved: (value) {
                        lastname = value!;
                      },
                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'Lütfen soyadınızı girin';
                        }
                        return null;
                      },
                    ),
                  ),
                ],

              ),

              TextFormField(
                decoration: InputDecoration(labelText: 'Kullanıcı Adı'),
                onSaved: (value) {
                  username = value!;
                },
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Lütfen bir kullanıcı adı girin';
                  }
                  return null;
                },
              ),
              TextFormField(
                decoration: InputDecoration(labelText: 'E-posta'),
                onSaved: (value) {
                  email = value!;
                },
                validator: (value) {
                  if (value!.isEmpty || !value.contains('@')) {
                    return 'Geçerli bir e-posta adresi girin';
                  }
                  return null;
                },
              ),
              DropdownButtonFormField(
                value: gender,
                items: ['Erkek', 'Kadın', 'Belirtmek İstemiyorum']
                    .map<DropdownMenuItem<String>>((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value),
                  );
                }).toList(),
                onChanged: (String? newValue) {
                  setState(() {
                    gender = newValue!;
                  });
                },
                decoration: InputDecoration(labelText: 'Cinsiyet'),
              ),
              TextFormField(
                decoration: InputDecoration(labelText: 'Şifre'),
                obscureText: true,
                onSaved: (value) {
                  password = value!;
                },
                validator: (value) {
                  if (value!.isEmpty || value.length < 6) {
                    return 'Şifre en az 6 karakter olmalıdır';
                  }
                  return null;
                },
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: _submit,
                child: Text('Üye Ol'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
