import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class chatbot extends StatefulWidget {
  const chatbot({super.key});

  @override
  State<chatbot> createState() => _chatbotState();
}

class _chatbotState extends State<chatbot> {
  TextEditingController tec = TextEditingController();
  bool isvalid = false;
  String x='';

  @override
  Future<void> backend(String query) async {
    http.Response res=
        await http.get(Uri.parse('http://10.0.2.2:8000/queries?query=$query'));
    if (res.statusCode == 200) {
      setState(() {
        isvalid = true;

        x = jsonDecode(res.body)['reply'];
        
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(appBar: PreferredSize(preferredSize: Size.fromHeight(250), child: AppBar(flexibleSpace: Container(decoration: BoxDecoration(image: DecorationImage(image: AssetImage('assets/chatbot.png'),fit: BoxFit.fill)),),
        ),),
        body: SingleChildScrollView(scrollDirection: Axis.vertical,
          child: Container(
            
                padding: const EdgeInsets.only(right: 40, top: 60),
                child: SafeArea(
            child: Column(
          children: [
            Center(
                child: TextField(
              controller: tec,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
              ),
              decoration: InputDecoration(
                  filled: true,
                  fillColor: Color.fromARGB(255, 80, 238, 198),
                  hintText: 'Type your query here',
                  suffixIcon: IconButton(
                    onPressed: () async {
                      try {
                        await backend(tec.text);
                      } catch (e) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text('error: $e')),
                        );
                      }
                    },
                    icon: const Icon(Icons.chat_bubble_outline),
                  ),
                  border: const OutlineInputBorder(
                      borderRadius: BorderRadius.only(
                          topRight: Radius.circular(50),
                          bottomRight: Radius.circular(50)),
                      borderSide: BorderSide(width: 3.0))),
            )),
            const SizedBox(height: 40),
            Padding(
                padding: EdgeInsets.only(right: 35.0,top:15),
                child: Container(
                  width: 300,
                  height: 800,
                  child: Card(elevation: 5,
                    color: Color.fromARGB(255, 66, 66, 69),
                    child: Padding(
                      padding: EdgeInsets.only(right:15.0,top:20),
                      child: Text(
                        isvalid ? x : '',
                        style: TextStyle(
                            fontStyle: FontStyle.italic,
                            fontWeight: FontWeight.bold,
                            color: Color.fromARGB(255, 98, 233, 204)),
                      ),
                    ),
                  ),
                ))
          ],
                )),
              ),
        ));
  }
}
