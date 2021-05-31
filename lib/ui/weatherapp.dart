import 'dart:convert';
import 'package:klimatic/util/utility.dart'as util;

import 'package:flutter/material.dart';
import 'package:http/http.dart'as http;
 class Weather extends StatefulWidget {
   @override
   _WeatherState createState() => _WeatherState();
 }

 class _WeatherState extends State<Weather> {
   String currentCity;
   Future goToNextPage(BuildContext context)async{
     Map result=await Navigator.of(context).push(
         MaterialPageRoute(builder:(BuildContext context){
           return  ChangeCity ();

         })
     );

     if(result!=null && result.containsKey("city")){
       setState(() {
         currentCity=result["city"];
       });

     }
     else{
       debugPrint("nothing to show");
     }
   }
   @override
   Widget build(BuildContext context) {
     return Scaffold(

       appBar: AppBar(
         backgroundColor: Colors.redAccent,
         title: Text("Weather app"),
         centerTitle: true,
         actions: [
           new IconButton(icon: new Icon(Icons.menu), onPressed:(){
             goToNextPage(context);
           }),
         ],
       ),
       body: ListView(
         children: [
           new Stack(
             children: [
               Center(child: Image.asset("images/umbrella.png",height: 1200,width: 500,fit: BoxFit.fill,)),
               new Container(
                 margin: const EdgeInsets.fromLTRB(0.0, 11.0, 20.9, 0.0),
                 alignment: Alignment.topRight,
                 child: Text("${currentCity==null?util.defaultCity:currentCity}",style: TextStyle(fontSize: 30,fontWeight: FontWeight.bold,fontStyle: FontStyle.italic,color: Colors.white),),
               ),
               new Container(
                 child:Center(child: Image.asset("images/light_rain.png")),
                 margin: const EdgeInsets.fromLTRB(0.0, 300.8, 50.9, 0.0),
               ),
               Container(
                   alignment: Alignment.centerLeft,

                   margin: const EdgeInsets.fromLTRB(40.9, 420.9, 0.0, 0.0),
                   child: updateWidget(currentCity)

               )
             ],

           ),
         ],
       )

     );

   }
 }
 Future<Map>getWeather(String appId,String city)async{
   var url=Uri.parse("https://api.openweathermap.org/data/2.5/weather?q=$city&appid=$appId&units=metric");
   http.Response response= await http.get(url);
   return json.decode(response.body);
 }
 Widget updateWidget(String city){
    return FutureBuilder(
      future: getWeather(util.appId,city==null?util.defaultCity:city),
      builder: (BuildContext context, AsyncSnapshot<Map> snapshot){
        if(snapshot.hasData){
          Map data= snapshot.data;
          return Container(
            child: Column(
              children: [
                ListTile(
                  title: Text( "Temp: ${data["main"]["temp"].toString()}C ",style: TextStyle(fontSize: 30,fontWeight: FontWeight.bold,color: Colors.white),),
                  subtitle: Text( "Max: ${data["main"]["temp_max"].toString()}C \nMin: ${data["main"]["temp_min"].toString()}C",style: TextStyle(fontSize:20,color: Colors.white),),

                )
              ],
            ),
          );

        }
        else {
          return Container();
        }

      }
    );
}
class ChangeCity extends StatefulWidget {
  @override
  _ChangeCityState createState() => _ChangeCityState();
}

class _ChangeCityState extends State<ChangeCity> {
   final TextEditingController cityName= TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Change City"),
        centerTitle: true,
        backgroundColor: Colors.red,
      ),
      body: Stack(
        children: [
          Center(child: Image.asset("images/white_snow.png",height:1200,width:490,fit: BoxFit.fill,)),
          ListView(
            children: [
              ListTile(
                title: TextField(
                  controller:cityName ,
                  keyboardType: TextInputType.text,
                  decoration: InputDecoration(
                    hintText: "Enter city"
                  ),
                ),
              ),
              ListTile(
                title: FlatButton(
                  child: Text("Get Weather",),
                  textColor: Colors.white,
                  color: Colors.red,
                  onPressed: (){
                    Navigator.pop(context,{
                      "city": cityName.text
                    });
                  },
                ),
              )
            ],
          )
        ],
      ),
    );
  }
}


