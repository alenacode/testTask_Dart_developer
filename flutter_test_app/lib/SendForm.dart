import 'package:flutter/material.dart';  // widgets lib
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'ServerResponseTotal.dart';

///           SEND DATA
///
///
class SendForm extends StatefulWidget {
    final String firstName;
    final String lastName;
    final String phone;
    final String email;
    final String token;
    SendForm({this.firstName, this.lastName, this.phone, this.email, this.token});

    @override
    State<StatefulWidget> createState() => SendFormState(this.firstName, this.lastName, this.phone, this.email, this.token);
}

class SendFormState extends State<SendForm> {
    final _formKey = GlobalKey<FormState>();
    final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
    TextEditingController _githubProfileUrl = new TextEditingController();
    TextEditingController _summary = new TextEditingController();

    SendFormState(String firstName, String lastName, String phone, String email, String token);

    Widget build(BuildContext context) {
        return new Scaffold(
            key: _scaffoldKey,
            appBar: new AppBar(
                title: new Text("Отправка данных"),
                backgroundColor: Color(0xffed8f00),
            ),
            body: Container(
                padding: EdgeInsets.all(10.0),
                child: new Form(
                    key: _formKey,
                    child: new Column(
                        children: <Widget>[
                            new SizedBox(height: 20.0),

                            ///           GITHUB PROFILE
                            ///
                            /// ignore: missing_return
                            new TextFormField(
                                validator: (value){
                                    if (value.isEmpty)
                                        return "Необходимо вставить ссылку на GitHub";
                                    return null;
                                },
                                controller: _githubProfileUrl,
                                decoration: InputDecoration(hintText: "Ссылка на GitHub")
                            ),

                            ///
                            ///
                            ///

                            new SizedBox(height: 20.0),

                            ///           SUMMARY
                            ///
                            /// ignore: missing_return
                            new TextFormField(
                                validator: (value){
                                    if (value.isEmpty)
                                        return "Необходимо вставить ссылку на резюме";
                                    return null;
                                },
                                controller: _summary,
                                decoration: InputDecoration(hintText: "Ссылка на резюме")
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
                                                final ServerResponseTotal response = await register(widget.firstName, widget.lastName, widget.phone, widget.email, _githubProfileUrl.text, _summary.text, widget.token);

                                                String text;
                                                Color color;
                                                if(response != null){
                                                    text = "Спасибо за регистрацию!";
                                                    color = Colors.green;
                                                }
                                                else {
                                                    text = "Внутренняя ошибка работы приложения!";
                                                    color = Colors.red;
                                                }

                                                _scaffoldKey.currentState.showSnackBar(SnackBar(content: Text(text), backgroundColor: color));
                                            }
                                        },
                                        child: Text("зарегистрироваться".toUpperCase()),
                                        color: Color(0xffed8f00),
                                        textColor: Colors.white,
                                    ),
                                ),
                            )
                            ///
                            ///
                            ///
                        ],
                    )
                )
            )
        );
    }
}
///
///
///


///           SEND DATA FOR CONSIDERATION OF THE APPLICATION
///
///
Future<ServerResponseTotal> register(String firstName, String lastName, String phone, String email, String githubProfileUrl, String summary, String token) async {
    /// final String apiURL = "https://vacancy.dns-shop.ru/api/candidate/summary";   /// use it for consideration of the application
    final String apiURL = "https://vacancy.dns-shop.ru/api/candidate/test/summary";     /// use it for TEST consideration of the application
    var body = jsonEncode( {
        "firstName": "$firstName",
        "lastName": "$lastName",
        "phone": "$phone",
        "email": "$email",
        "githubProfileUrl" : "$githubProfileUrl",
        "summary": "$summary"
    });

    final http.Response response = await http.post(
        apiURL,
        headers: {
            "Accept" : "application/json",
            "content-type" : "application/json",
            "authorization" : "Bearer $token"
        },
        body : body
    );

    if(response.statusCode == 200) {
        final String responseStr = response.body;
        /// print("RESPONSE INFO");
        /// print(response.body);
        /// print(response.statusCode);
        return serverResponseTotalFromJson(responseStr);
    }

    else {
        return null;
    }
}
///
///
///
