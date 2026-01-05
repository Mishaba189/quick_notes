import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/auth_provider.dart';


class DetailsScreen extends StatelessWidget {
  const DetailsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Future.microtask(() {
    //   context.read<AuthProvider>().fetchDetails();
    // });
    return Scaffold(
        appBar: AppBar(
        leading: IconButton(onPressed: (){
          Navigator.pushReplacementNamed(context, '/register');
        },
            icon:Icon(Icons.arrow_back,size: 25,),),
        title: Text('Users'),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Padding(padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(
              height: 900,
              child: Consumer<AuthProvider>(
                builder: (context,authProvider,child) {
                  return ListView.builder(
                    itemCount: authProvider.details.length,
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemBuilder: (context,index){
                      final detail = authProvider.details[index];
                    return Padding(
                      padding: EdgeInsets.symmetric(vertical: 8),
                      child: Container(
                          decoration: BoxDecoration(
                                      border: Border.all(color: Color(0x6908080B)),
                                      borderRadius: BorderRadius.circular(16)
                                    ),
                          child: ListTile(
                            title: Text(detail.id),
                            subtitle: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(detail.name),
                                Text(detail.email),
                              ],
                            ),
                          ),


                      ),
                    );
                  });
                }
              ),
            )
          ],
        ),
        ),
      ),
        floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.pushNamed(context, '/register');
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}




