import 'package:flutter/material.dart';  // widgets lib
import 'package:flutter_masked_text/flutter_masked_text.dart';  // mask lib
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:flutter_test_app/SendForm.dart';
import 'package:flutter_test_app/ServerResponse.dart';

///           REGISTRATION FORM
///
///
class RegistrationForm extends StatefulWidget {
    @override
    State<StatefulWidget> createState() => RegistrationFormState();
}

class RegistrationFormState extends State {
    final _formKey = GlobalKey<FormState>();
    final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

    TextEditingController _firstName = new TextEditingController();
    TextEditingController _lastName = new TextEditingController();
    TextEditingController _email = new TextEditingController();
    MaskedTextController _phone = new MaskedTextController(mask: "+7 (000) 000-00-00");

    Widget build(BuildContext context) {
        return new Scaffold(
            key: _scaffoldKey,
            appBar: new AppBar(
                title: new Text("Ввод данных"),
                backgroundColor: Color(0xffed8f00),
            ),
            body: Container(
                padding: EdgeInsets.all(10.0),
                child: new Form(
                    key: _formKey,
                    child: new Column(children: <Widget>[
                        new SizedBox(height: 20.0),

                        ///           USER NAME
                        ///
                        /// ignore: missing_return
                        new TextFormField(
                            validator: (value){
                                if (value.isEmpty)
                                    return "Необходимо ввести имя";
                                return null;
                            },
                            controller: _firstName,
                            decoration: InputDecoration(hintText: "Имя")
                        ),

                        ///
                        ///
                        ///

                        new SizedBox(height: 20.0),

                        ///           USER LAST NAME
                        ///
                        /// ignore: missing_return
                        new TextFormField(
                            validator: (value){
                                if (value.isEmpty)
                                    return "Необходимо ввести фамилию";
                                return null;
                            },
                            controller: _lastName,
                            decoration: InputDecoration(hintText: "Фамилия")
                        ),
                        ///
                        ///
                        ///

                        new SizedBox(height: 20.0),

                        ///           PHONE
                        ///
                        ///
                        new TextFormField(
                            validator: (value){
                                if (value.isEmpty)
                                    return "Необходимо ввести телефон";
                                return null;
                            },
                            controller: _phone,
                            keyboardType: TextInputType.number,
                            decoration: InputDecoration(hintText: "Телефон")
                        ),
                        ///
                        ///
                        ///

                        new SizedBox(height: 20.0),

                        ///           E-MAIL
                        ///
                        /// ignore: missing_return
                        new TextFormField(
                            validator: (value){
                                if (value.isEmpty)
                                    return "Необходимо ввести E-mail";

                                RegExp regExp = new RegExp("[a-zA-Z0-9+.\_\%-+]{1,256}@[a-zA-Z0-9][a-zA-Z0-9-]{0,64}(.[a-zA-Z0-9][a-zA-Z0-9-]{0,25})+");

                                if (regExp.hasMatch(value))
                                    return null;

                                return "Вы ввели не E-mail";
                            },
                            controller: _email,
                            decoration: InputDecoration(hintText: "E-mail")
                        ),
                        ///
                        ///
                        ///

                        new SizedBox(height: 20.0),

                        ///         BUTTON
                        ///
                        ///
                        new Expanded(
                            child: Align(
                                alignment: Alignment.bottomCenter,
                                child: RaisedButton(
                                    onPressed: () async {
                                        if(_formKey.currentState.validate()) {
                                            final ServerResponse token = await getToken(_firstName.text, _lastName.text, _phone.text, _email.text);

                                            if(token != null)
                                                Navigator.of(context).push(new MaterialPageRoute(
                                                    builder: (context) => SendForm(firstName : _firstName.text, lastName: _lastName.text, phone: _phone.text, email: _email.text, token: token.data)
                                                ));
                                            else
                                                _scaffoldKey.currentState.showSnackBar(SnackBar(content: Text("Внутренняя ошибка работы приложения!"), backgroundColor: Colors.red));
                                        }
                                    },
                                    child: Text("получить ключ".toUpperCase()),
                                    color: Color(0xffed8f00),
                                    textColor: Colors.white,
                                ),
                            ),
                        )
                        ///
                        ///
                        ///
                    ],)
                )
            )
        );
    }
}
///
///
///


///           GET TOKEN THROUGH API
///
///
Future<ServerResponse> getToken(String firstName, String lastName, String phone, String email) async {
    final String apiURL = "https://vacancy.dns-shop.ru/api/candidate/token";
    var body = jsonEncode( {
        "firstName": "$firstName",
        "lastName": "$lastName",
        "phone": "$phone",
        "email": "$email"
    });

    final http.Response response = await http.post(
        apiURL,
        headers: {
            "Accept": "application/json",
            "content-type":"application/json"
        },
        body : body
    );

    if(response.statusCode == 200) {
        final String responseStr = response.body;
        /// print("RESPONSE INFO");
        /// print(response.body);
        /// print(response.statusCode);
        return serverResponseFromJson(responseStr);
    }

    else{
        return null;
    }
}
///
///
///

