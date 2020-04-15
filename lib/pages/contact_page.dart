import 'package:flutter/material.dart';
import 'package:grouped_buttons/grouped_buttons.dart';

class ContactPage extends StatefulWidget {
  ContactPage({Key key}) : super(key: key);

  @override
  _ContactPageState createState() => _ContactPageState();
}

class _ContactPageState extends State<ContactPage> {

  final _formKey = GlobalKey<FormState>();
  String selectedFavorite = "";

  //input field controllers
  ScrollController _pageScrollControl = ScrollController();
  TextEditingController feedbackInputController = TextEditingController();
  TextEditingController top40InputController = TextEditingController();
  TextEditingController suggestionInputController = TextEditingController();
  TextEditingController nameInputController = TextEditingController();
  TextEditingController ageInputController = TextEditingController();

  sendFeedback()
  {
    //Perform content checks
    String error = "";
    if(feedbackInputController.text == "")
    {
      error = "Пожалуйста, введите отзыв.";
    }
    else if(selectedFavorite == "")
    {
      error = "Пожалуйста, выберете что вы бы хотели слушать больше.";
    }

    if(error != "")
    {
      final snackBar = SnackBar(content: Text(error), backgroundColor: Colors.redAccent, duration: Duration(seconds: 3),);
      Scaffold.of(context).showSnackBar(snackBar);
    } 
    else
    {
      //Send out the form content to google form
      

      //Reset fields
      setState(() {
        selectedFavorite = "";
      });
      feedbackInputController.clear();
      top40InputController.clear();
      suggestionInputController.clear();
      nameInputController.clear();
      ageInputController.clear();
      FocusScope.of(context).requestFocus(new FocusNode());

      final snackBar = SnackBar(content: Text("Спасибо за поддержку!"), backgroundColor: Colors.green, duration: Duration(seconds: 3),);
      Scaffold.of(context).showSnackBar(snackBar);
    }
  }

  void onChangeRadioSelection(String newValue)
  {
    setState(() {
      selectedFavorite = newValue;
    });
  }

  @override
  void dispose() {
    feedbackInputController.dispose();
    top40InputController.dispose();
    suggestionInputController.dispose();
    nameInputController.dispose();
    ageInputController.dispose();
    _pageScrollControl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        decoration: BoxDecoration(
          gradient: RadialGradient(
            radius: 2,
            colors: [Color.fromARGB(255, 240, 240, 240), Color.fromARGB(255, 183, 187, 210)],
          ),
        ),
        child: SingleChildScrollView(
          controller: _pageScrollControl,
          child: Padding(
              padding: EdgeInsets.all(20),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Center(
                      child: Text('Опрос слушателей радио\n"Голос Пилигрима"',
                        style: Theme.of(context).textTheme.headline5,
                        textAlign: TextAlign.center,
                      ),
                    ),
                    SizedBox(height:10),
                    Center(
                        child: Text("Нам важно ваше мнение, пожалуйста оставьте короткий отзыв что вы думаете об радио.",
                        textAlign: TextAlign.center,
                      ),
                    ),
                    SizedBox(height:30),
                    Text("Отзыв:",
                      textAlign: TextAlign.left,
                      style: TextStyle(fontWeight: FontWeight.w700)
                    ),
                    SizedBox(height:5),
                    TextFormField(
                      maxLines: 5,
                      controller: feedbackInputController,
                      decoration: InputDecoration(
                        filled: true,
                        fillColor: Colors.white60,
                      ),
                    ),
                    SizedBox(height:20),
                    Text("Что вы хотели бы слушать больше на радио 'Голос Пилигрима'?",
                      textAlign: TextAlign.left,
                      style: TextStyle(fontWeight: FontWeight.w700)
                    ),
                    RadioButtonGroup(
                      picked: selectedFavorite,
                      labels: <String>[
                        "Песни",
                        "Стихи",
                        "Проповеди",
                        "Мини проповеди",
                        "Передачи с участием ведущих",
                        "Беседы со служителями и пастырями",
                      ],
                      onSelected: onChangeRadioSelection
                    ),
                    SizedBox(height:20),
                    Text("Top 40 | Напишите любимого исполнителя и название песни ниже:",
                      textAlign: TextAlign.left,
                      style: TextStyle(fontWeight: FontWeight.w700)
                    ),
                    SizedBox(height:5),
                    TextFormField(
                      controller: top40InputController,
                      decoration: InputDecoration(
                        filled: true,
                        fillColor: Colors.white60,
                      ),
                    ),
                    SizedBox(height:20),
                    Text("Предложения для улучшения радио:",
                      textAlign: TextAlign.left,
                      style: TextStyle(fontWeight: FontWeight.w700)
                    ),
                    SizedBox(height:5),
                    TextFormField(
                      controller: suggestionInputController,
                      decoration: InputDecoration(
                        filled: true,
                        fillColor: Colors.white60,
                      ),
                    ),
                    SizedBox(height:20),
                    Text("Имя:",
                      textAlign: TextAlign.left,
                      style: TextStyle(fontWeight: FontWeight.w700)
                    ),
                    SizedBox(height:5),
                    TextFormField(
                      controller: nameInputController,
                      decoration: InputDecoration(
                        filled: true,
                        fillColor: Colors.white60,
                      ),
                    ),
                    SizedBox(height:20),
                    Text("Возраст:",
                      textAlign: TextAlign.left,
                      style: TextStyle(fontWeight: FontWeight.w700)
                    ),
                    SizedBox(height:5),
                    TextFormField(
                      decoration: InputDecoration(
                        filled: true,
                        fillColor: Colors.white60,
                      ),
                    ),
                    SizedBox(height:10),
                    Container(
                      width: double.infinity,
                      child: RaisedButton(
                        child: Text("Отослать Отзыв"),
                        onPressed: sendFeedback,
                        color: Color.fromARGB(220, 59, 61, 126),
                        textColor: Colors.white,
                      ),
                    ),
                    SizedBox(height:10),
                  ],
                )
              ),
            ),
          )
      ),
    );
  }
}