import 'package:flutter/material.dart';
import 'package:untitled10/database_controller.dart';
import 'package:untitled10/shared_preferences.dart';
import 'info_model.dart';

class HomeScreen extends StatefulWidget {



  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {

  List<InfoModel> data = [];

  final TextEditingController nameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();

  int? get id => null;





  Future<List<InfoModel>> getData() async{
    data = await DatabaseController.instance.readAllInfo();
    print('DATA:${data.length}');
    return data;

  }
 Future<void> editInfo(id, name, email, phone) async{
    InfoModel infoModel = InfoModel();
    final data = await DatabaseController.instance.editInfo(infoModel);
    return data;

 }

  void deleteInfo(int id) async{
    InfoModel infoModel = InfoModel();
    final data = await DatabaseController.instance.deleteInfo(id);
    return data;

  }

  @override
  void initState()  {
    super.initState();
    getData();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if(PreferencesHelper.instance.getIsOpened()== false){
        welcomeAlert();
      }

    });
  }
  @override
  void dispose() {
    phoneController.dispose();
    nameController.dispose();
    emailController.dispose();
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(


      body: Column(
          children: [
            topBar(),
            const SizedBox(height: 15,),
            FutureBuilder(
              future: getData(),
                builder:(context,snapshot)=> snapshot.hasData
                ? dataList(data)
                : snapshot.hasError
                    ? const Text('Sorry Something Went Worng')
                    :const CircularProgressIndicator(),
            )
          ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: (){
          showAlert();
    },
        backgroundColor: Colors.deepPurpleAccent,
    child: const Icon(Icons.add),
      ),
    );

  }
  Widget topBar()=>  Container(
    decoration:const BoxDecoration(
      color: Colors.indigo,
      borderRadius: BorderRadius.only(
        bottomRight:Radius.circular(40),
        bottomLeft: Radius.circular(40)
      )
    ),

    width: double.infinity,
    height: 200,
    child:
        SafeArea
          (child:  Column(
            children:const [
                SizedBox(height: 15,),
              Text('Welcome in Note app', style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),),
              SizedBox(height: 15,),
              Text('You can Store Any Note',style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
            ],
          )
        ),
  );
  Widget dataList(List<InfoModel>noteList)=>
      noteList.isEmpty
      ?const Text('NO Data Found')
      :ListView.builder(
      itemCount: noteList.length, shrinkWrap: true,

    padding: EdgeInsets.zero,
    itemBuilder: (context,index )=> ListTile(
      title: Text(
          'Name: ${noteList[index].name}',
        style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
      ) ,

      subtitle: Text(
          'Email: ${noteList[index].email}',
        style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
      ) ,
      leading: CircleAvatar(
        radius: 40,
        backgroundColor: Colors.indigo,
        child: Text(
            (noteList[index].name??'')!=''
               ? noteList[index].name!.substring(0,2).toUpperCase()
               :'',
          style: const TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),

        trailing: Wrap(children:[
          IconButton(onPressed: (){
           DatabaseController.instance.editInfo(InfoModel(
             name: nameController.text,
             email: emailController.text,
             phone: phoneController.text,
           )
           ).then((value) {
             getData();
             setState(() {

             });

           }
           ).whenComplete((){
             Navigator.pop(context);

           }
           );
          },
              icon: const Icon(Icons.edit)),
          IconButton(onPressed: (){
           DatabaseController.instance.deleteInfo(id!);
          },
              icon: const Icon(Icons.delete, color: Colors.red,)),

        ]),





    )
  );
 void showAlert(){

   showDialog(
       context: context,
      // barrierDismissible: false,
       builder: (context)=> AlertDialog(
                title:const Text('Add User',
                   style: TextStyle(
                     fontWeight: FontWeight.bold,
                     fontSize: 16,
                     color: Colors.deepPurpleAccent
                   ),
                 ),
         content: Wrap(
             children: [
               Column(
                 children: [
                   TextFormField(
                     controller: nameController,
                     decoration: fieldDecoration('Name',),),
               const SizedBox(height: 10,),
               TextFormField(
                 controller: emailController,
                 decoration: fieldDecoration('Email'),),
               const SizedBox(height: 10,),
               TextFormField(
                 controller: phoneController,
                 decoration: fieldDecoration('Phone'),),
                 ],
               ),
             ],
           ),
         actions: [
           ElevatedButton(
               onPressed: (){
                 DatabaseController.instance.insertInfo(
                   InfoModel(
                     name: nameController.text,
                     email: emailController.text,
                     phone: phoneController.text,
                 ),
                 )
                 .then((value) {
                   getData();
                   setState(() {

                   });

                 })
                     .whenComplete(() {
                   Navigator.pop(context);
                   nameController.clear();
                   phoneController.clear();
                   emailController.clear();
                 }, );
               },
             style: ElevatedButton.styleFrom(
               primary: Colors.deepPurpleAccent,
             ),
               child: const Text('Save'),
           )
         ],
         ),
       );

 }
 void welcomeAlert(){

   showDialog(
       context: context,
       barrierDismissible: false,
       builder: (context)=> AlertDialog(
                title:const Text('Welcome in NoteApp',
                   style: TextStyle(
                     fontWeight: FontWeight.bold,
                     fontSize: 16,
                     color: Colors.deepPurpleAccent
                   ),
                 ),

         actions: [
           ElevatedButton(
               onPressed: (){
                PreferencesHelper.instance.setIsOpened(true);
                Navigator.pop(context);
               },
             style: ElevatedButton.styleFrom(
               primary: Colors.deepPurpleAccent,
             ),
               child: const Text('Confirm'),
           )
         ],
         ),
       );

 }
 InputDecoration fieldDecoration(String hint) => InputDecoration(
   hintText: hint,
   border:const OutlineInputBorder(),

 );


}
