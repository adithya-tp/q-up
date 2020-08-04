import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:y_wait/screens/home/business/get_more_business_details.dart';
import 'package:y_wait/shared/text_input_decoration.dart';

class GetBusinessDetails extends StatefulWidget {
  @override
  _GetBusinessDetailsState createState() => _GetBusinessDetailsState();
}

class _GetBusinessDetailsState extends State<GetBusinessDetails> {
  String businessType;
  String errorCategoryType = "";
  List<dynamic> result = [];
  List<String> types = ["Mall", "Restaurant", "Theatre", "Clothes", "General Store", "Pharmacy", "None of the above"];
  final _formKey = GlobalKey<FormState>();
  TextEditingController businessTypeTextEditingController = new TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xff1f1f1f),
      appBar: AppBar(
        backgroundColor: Color(0xff1f1f1f),
        centerTitle: true,
        title: Text(
          "Specify Category",
          style: GoogleFonts.robotoSlab(
            fontSize: 30.0,
            fontWeight: FontWeight.w500,
            color: Colors.white,
          ),
        ),
      ),
      body: Container(
        height: MediaQuery.of(context).size.height,
        decoration: BoxDecoration(
            gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  Color(0xffC6FFDD),
                  Color(0xffFBD786),
                  Color(0xfff7797d)
                ]
            )
        ),
        child: SingleChildScrollView(
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 2.0),
            child: Stack(
              children: <Widget>[
                Container(
                  margin: EdgeInsets.only(top: 20.0, left: 15.0, right: 15.0),
                  height: 660.0,
                  decoration: BoxDecoration(
                    boxShadow: [
                      BoxShadow(color: Colors.grey.withOpacity(0.8),
                          spreadRadius: 5.0,
                          blurRadius: 7.0,
                          offset: Offset(0, 3)),
                    ],
                    borderRadius: BorderRadius.circular(10.0),
                    color: Colors.white,
                  ),
                ),
                Column(
                  children: <Widget>[
                    Container(
                      margin: EdgeInsets.only(top: 40.0, left: 10.0, right: 10.0),
                      padding: EdgeInsets.symmetric(horizontal: 24.0),
                      child: Form(
                        key: _formKey,
                        child: Column(
                          children: <Widget>[
                            Column(
                              children: types.map((item) {
                                return Theme(
                                  data: Theme.of(context).copyWith(
                                    unselectedWidgetColor: Colors.black,
                                    disabledColor: Colors.blue,
                                  ),
                                  child: RadioListTile(
                                    value: item,
                                    groupValue: businessType,
                                    title: Text(
                                      item,
                                      style: GoogleFonts.robotoSlab(
                                        color: Colors.black,
                                        fontSize: 25.0,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                    activeColor: Colors.green,
                                    onChanged: (val) {
                                      setState(() {
                                        businessType = val;
                                      });
                                    },
                                  ),
                                );
                              }).toList(),
                            ),
                            SizedBox(height: 5.0,),
                            Text(
                              errorCategoryType,
                              style: TextStyle(
                                  color: Colors.red,
                                  fontSize: 14.0
                              ),
                            ),
                            SizedBox(height: 5.0,),
                            TextFormField(
                              validator: (val) {
                                if(val.length > 0) {
                                  if(businessType != "None of the above") {
                                    return "Please choose 'none of the above', otherwise clear this field";
                                  }
                                }
                                else {
                                  if(businessType == "None of the above") {
                                    return "Please specify the category of your business";
                                  }
                                }
                                return null;
                              },
                              controller: businessTypeTextEditingController,
                              cursorColor: Colors.black,
                              decoration: textInputDecoration.copyWith(hintText: 'Specify (for "None of the above")'),
                              style: TextStyle(
                                color: Colors.black,
                                fontSize: 20.0
                              ),
                            ),
                            SizedBox(height: 70.0,),
                            GestureDetector(
                              onTap: () async {
                                if(_formKey.currentState.validate()) {
                                  if(businessType == null) {
                                    setState(() {
                                      errorCategoryType = "Please choose a category";
                                    });
                                  }
                                  else {
                                    if(businessType == "None of the above")
                                      result.add(businessTypeTextEditingController.text);
                                    else
                                      result.add(businessType);
                                    print(result);
                                    List<dynamic> result2 = await Navigator.push(context, MaterialPageRoute(
                                      builder: (context) => GetMoreBusinessDetails(),
                                    ));
                                    result2.addAll(result);
                                    Navigator.pop(context, result2);
                                  }
                                }
                              },
                              child: Container(
                                height: 50.0,
                                alignment: Alignment.center,
                                decoration: BoxDecoration(
                                  color: Color(0xff302b63),
                                  borderRadius: BorderRadius.circular(10.0),
                                ),
                                child: Text(
                                  "Next",
                                  style: GoogleFonts.robotoSlab(
                                    fontSize: 25.0,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
