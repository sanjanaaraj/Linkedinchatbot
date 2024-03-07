
import 'package:flutter/material.dart';
import 'chat_bot.dart';
import 'package:http/http.dart' as http;

class YourLoginPage extends StatefulWidget {
  const YourLoginPage({super.key});

  @override
  _YourLoginPageState createState() => _YourLoginPageState();
}

class _YourLoginPageState extends State<YourLoginPage> {
  bool isconnected = false;
  TextEditingController tec1 = TextEditingController();
  TextEditingController tec2 = TextEditingController();
  TextEditingController tec3 = TextEditingController();

  Future<void> connectToBackend(
      String username, String password, String dbName) async {
    http.Response res;

    res = await http.get(Uri.parse(
        'http://10.0.2.2:8000/connecting?user=$username&password=$password&dbname=$dbName'));

    if (res.statusCode == 200) {
      setState(() {
        isconnected = true;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(250),
        child: AppBar(
          
          flexibleSpace: Container(decoration: BoxDecoration(image: DecorationImage(image: AssetImage('assets/login page.png'),fit: BoxFit.fill)),),
        ),
      ),
      body: SingleChildScrollView(scrollDirection: Axis.vertical,
        child: Container(
          color: Colors.black,
          padding: const EdgeInsets.only(top: 80, left: 40, right: 40, bottom: 20),
          width: 600,
          height: 800,
          child: Center(
            child: Column(
              children: [
                TextField(
                  controller: tec1,
                  decoration: InputDecoration(
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(20)
                    ),
                    
                    hintText: 'Username',
                    hintStyle:
                        const TextStyle(fontSize: 20, fontWeight: FontWeight.bold,color: Color.fromARGB(255, 92, 231, 215)),
                  ),
                ),
                const SizedBox(height: 30),
                TextField(
                  controller: tec2,
                  decoration: InputDecoration(
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                    
                    hintText: 'Password',
                    hintStyle:
                        const TextStyle(fontSize: 20, fontWeight: FontWeight.bold,color:Color.fromARGB(255, 92, 231, 215)),
                  ),
                ),
                const SizedBox(height: 30),
                TextField(
                  controller: tec3,
                  decoration: InputDecoration(
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                    
                    
                    hintText: 'Database name',
                    hintStyle:
                        const TextStyle(fontSize: 20, fontWeight: FontWeight.bold,color:Color.fromARGB(255, 92, 231, 215)),
                  ),
                ),SizedBox(height:30),
                IconButton(
                  onPressed: () async {
                    try {
                      await connectToBackend(tec1.text, tec2.text, tec3.text);
                    } catch (e) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('Failed to connect: $e')),
                      );
                    }
                    Navigator.push(context,
                        MaterialPageRoute(builder: ((context) => const chatbot())));
                  },
                  icon: const Icon(Icons.login,color:Color.fromARGB(255, 92, 231, 215),size: 30,),
                ),
                const SizedBox(
                  height: 30,
                ),
                isconnected ? const Text('connectedddd') : const Text('not connected')
              ],
            ),
          ),
        ),
      ),
    );
  }
}
