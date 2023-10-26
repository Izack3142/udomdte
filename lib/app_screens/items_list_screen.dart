import 'package:flutter/material.dart';
import 'package:udomdte/app_services/database_services.dart';


class ItemsListScreen extends StatefulWidget {
  const ItemsListScreen({super.key});

  @override
  State<ItemsListScreen> createState() => _ItemsListScreenState();
}

class _ItemsListScreenState extends State<ItemsListScreen> {
  final bool _isLoading=true;
  List _items=[];
  getItems()async{
    List res=await DatabaseApi().getSchoolItems();
     setState(() {
       _items=res;
     });
  }

 @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getItems();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Select an item"),),
    body: _items.isEmpty?const Center(child: CircularProgressIndicator()):ListView.builder(
        itemCount: _items.length,
        itemBuilder: (context,index){
          return ListTile(
            onTap: (){
              Navigator.pop(context,_items[index]);
            },
            contentPadding: const EdgeInsets.only(left: 5),
            visualDensity: const VisualDensity(horizontal: -3,vertical: -3),
            leading: const Icon(Icons.category,size: 40,),
            title: Text(_items[index]['name']),subtitle: const Text("All items that fall under this cartegory"),
           ); 
        }),
    );
  }
}