import 'package:flutter/material.dart';
import 'package:grouped_buttons/grouped_buttons.dart';
import 'package:http/http.dart';

class ContactPage extends StatefulWidget {
  ContactPage({Key key}) : super(key: key);

  @override
  _ContactPageState createState() => _ContactPageState();
}

class _ContactPageState extends State<ContactPage> {
  final _formKey = GlobalKey<FormState>();
  String selectedFavorite = "";
  int selectedFavoriteNum = -1;

  //input field controllers
  ScrollController _pageScrollControl = ScrollController();
  TextEditingController feedbackInputController = TextEditingController();
  TextEditingController top40InputController = TextEditingController();
  TextEditingController suggestionInputController = TextEditingController();
  TextEditingController nameInputController = TextEditingController();
  TextEditingController ageInputController = TextEditingController();

  String getFavoriteEntry(int index) {
    String result = "&entry.1591633300=";
    if (index == 0)
      result += "%D0%9F%D0%B5%D1%81%D0%BD%D0%B8";
    else if (index == 1)
      result += "%D0%A1%D1%82%D0%B8%D1%85%D0%B8";
    else if (index == 2)
      result += "%D0%9F%D1%80%D0%BE%D0%BF%D0%BE%D0%B2%D0%B5%D0%B4%D0%B8";
    else if (index == 3)
      result += "%D0%9C%D0%B8%D0%BD%D0%B8+%D0%BF%D1%80%D0%BE%D0%BF%D0%BE%D0%B2%D0%B5%D0%B4%D0%B8";
    else if (index == 4)
      result +=
          "%D0%9F%D0%B5%D1%80%D0%B5%D0%B4%D0%B0%D1%87%D0%B8+%D1%81+%D1%83%D1%87%D0%B0%D1%81%D1%82%D0%B8%D0%B5%D0%BC+%D0%B2%D0%B5%D0%B4%D1%83%D1%89%D0%B8%D1%85";
    else if (index == 5)
      result +=
          "%D0%91%D0%B5%D1%81%D0%B5%D0%B4%D1%8B+%D1%81%D0%BE+%D1%81%D0%BB%D1%83%D0%B6%D0%B8%D1%82%D0%B5%D0%BB%D1%8F%D0%BC%D0%B8+%D0%B8+%D0%BF%D0%B0%D1%81%D1%82%D1%8B%D1%80%D1%8F%D0%BC%D0%B8";
    else
      return "";

    return result;
  }

  void sendFeedback() async {
    //Perform content checks
    String error = "";
    if (feedbackInputController.text == "") {
      error = "Пожалуйста, введите отзыв.";
    } else if (selectedFavorite == "") {
      error = "Пожалуйста, выберете что вы бы хотели слушать больше.";
    }

    if (error != "") {
      final snackBar = SnackBar(
        content: Text(error),
        backgroundColor: Colors.redAccent,
        duration: Duration(seconds: 3),
      );
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
    } else {
      //Send out the form content to google form
      String feedbackText = feedbackInputController.text;
      String top40Text = top40InputController.text;
      String suggestionText = suggestionInputController.text;
      String nameText = nameInputController.text;
      String ageText = ageInputController.text;

      //Create the POST HTTP request
      String postURL = "https://docs.google.com/forms/d/e/1FAIpQLSdn2zfUa9v54Q2fX7FSozBKQL7JG8C51V5mrctP00ITicr-ug/formResponse?";
      // - top 40 responce
      postURL += "entry.2082284472=" + top40Text;
      // - favorite tracks
      postURL += getFavoriteEntry(selectedFavoriteNum);
      // - feedback
      postURL += "&entry.326955045=" + feedbackText;
      // - suggestion
      postURL += "&entry.1696159737=" + suggestionText;
      // - name
      postURL += "&entry.485428648=" + nameText;
      // - age
      postURL += "&entry.879531967=" + ageText;

      //Submit Request
      Response responce = await post(postURL);
      print("Form Responce Status Code: " + responce.statusCode.toString());
      print("Form Responce Body: " + responce.body.toString());

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

      final snackBar = SnackBar(
        content: Text("Спасибо за поддержку!"),
        backgroundColor: Colors.green,
        duration: Duration(seconds: 3),
      );
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
    }
  }

  void onChangeRadioSelection(String newValue) {
    setState(() {
      selectedFavorite = newValue;
    });
  }

  void onChangeRadioSelectionNum(String label, int index) {
    selectedFavoriteNum = index;
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
                        child: Text(
                          'Опрос слушателей радио\n"Голос Пилигрима"',
                          style: Theme.of(context).textTheme.headline5,
                          textAlign: TextAlign.center,
                        ),
                      ),
                      SizedBox(height: 10),
                      Center(
                        child: Text(
                          "Нам важно ваше мнение, пожалуйста оставьте короткий отзыв что вы думаете об радио.",
                          textAlign: TextAlign.center,
                        ),
                      ),
                      SizedBox(height: 30),
                      Text("Отзыв:", textAlign: TextAlign.left, style: TextStyle(fontWeight: FontWeight.w700)),
                      SizedBox(height: 5),
                      TextFormField(
                        maxLines: 5,
                        controller: feedbackInputController,
                        decoration: InputDecoration(
                          filled: true,
                          fillColor: Colors.white60,
                        ),
                      ),
                      SizedBox(height: 20),
                      Text("Что вы хотели бы слушать больше на радио 'Голос Пилигрима'?",
                          textAlign: TextAlign.left, style: TextStyle(fontWeight: FontWeight.w700)),
                      RadioButtonGroup(
                          onChange: onChangeRadioSelectionNum,
                          picked: selectedFavorite,
                          labels: <String>[
                            "Песни",
                            "Стихи",
                            "Проповеди",
                            "Мини проповеди",
                            "Передачи с участием ведущих",
                            "Беседы со служителями и пастырями",
                          ],
                          onSelected: onChangeRadioSelection),
                      SizedBox(height: 20),
                      Text("Top 40 | Напишите любимого исполнителя и название песни ниже:",
                          textAlign: TextAlign.left, style: TextStyle(fontWeight: FontWeight.w700)),
                      SizedBox(height: 5),
                      TextFormField(
                        controller: top40InputController,
                        decoration: InputDecoration(
                          filled: true,
                          fillColor: Colors.white60,
                        ),
                      ),
                      SizedBox(height: 20),
                      Text("Предложения для улучшения радио:", textAlign: TextAlign.left, style: TextStyle(fontWeight: FontWeight.w700)),
                      SizedBox(height: 5),
                      TextFormField(
                        controller: suggestionInputController,
                        decoration: InputDecoration(
                          filled: true,
                          fillColor: Colors.white60,
                        ),
                      ),
                      SizedBox(height: 20),
                      Text("Имя:", textAlign: TextAlign.left, style: TextStyle(fontWeight: FontWeight.w700)),
                      SizedBox(height: 5),
                      TextFormField(
                        controller: nameInputController,
                        decoration: InputDecoration(
                          filled: true,
                          fillColor: Colors.white60,
                        ),
                      ),
                      SizedBox(height: 20),
                      Text("Возраст:", textAlign: TextAlign.left, style: TextStyle(fontWeight: FontWeight.w700)),
                      SizedBox(height: 5),
                      TextFormField(
                        controller: ageInputController,
                        decoration: InputDecoration(
                          filled: true,
                          fillColor: Colors.white60,
                        ),
                      ),
                      SizedBox(height: 10),
                      Container(
                        width: double.infinity,
                        child: ElevatedButton(
                          child: Text(
                            "Отослать Отзыв",
                            style: TextStyle(color: Colors.white),
                          ),
                          onPressed: sendFeedback,
                          
                          style: ElevatedButton.styleFrom(
                            primary: Color.fromARGB(220, 59, 61, 126),
                            textStyle: TextStyle(
                              color: Colors.white,
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(32.0),
                            ),
                          ),
                        ),
                      ),
                      SizedBox(height: 10),
                    ],
                  )),
            ),
          )),
    );
  }
}
