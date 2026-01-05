import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/auth_provider.dart';


class DetailsScreen extends StatelessWidget {
  const DetailsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final h = MediaQuery.of(context).size.height;
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
              height: h,
              child: Consumer<AuthProvider>(
                builder: (context,authProvider,child) {
                  if(authProvider.loading== true){
                    return Center(child: CircularProgressIndicator());
                  }
                  if(authProvider.details.isEmpty){
                     return Center(child: Text("No User Found",style: TextStyle(
                      fontSize: 16,
                      color: Colors.grey,)));
                  }
                  return ListView.builder(
                    itemCount: authProvider.details.length,
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemBuilder: (context,index){
                      final detail = authProvider.details[index];
                      return Padding(
                        padding: const EdgeInsets.symmetric(vertical: 8),
                        child: Container(
                          decoration: BoxDecoration(
                            border: Border.all(color: Color(0x6908080B)),
                            borderRadius: BorderRadius.circular(16),
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
                            trailing: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                TextButton(
                                  onPressed: () {
                                    authProvider.setUserForUpdate(detail);
                                    Navigator.pushNamed(context, '/update');
                                  },
                                  style: TextButton.styleFrom(backgroundColor: Colors.green),
                                  child: const Text('Edit', style: TextStyle(color: Colors.white)),
                                ),
                                const SizedBox(width: 8),
                                TextButton(
                                  onPressed: () {
                                    showDialog(
                                      context: context,
                                      builder: (context) {
                                        return AlertDialog(
                                          title: const Text('Delete User'),
                                          content: const Text(
                                            'Are you sure you want to delete this user?',
                                          ),
                                          actions: [
                                            TextButton(
                                              onPressed: () {
                                                Navigator.pop(context);
                                              },
                                              child: const Text('Cancel'),
                                            ),
                                            TextButton(
                                              style: TextButton.styleFrom(backgroundColor: Colors.red),
                                              onPressed: () {
                                                authProvider.deleteUser(detail.id);
                                                Navigator.pop(context);
                                                // If notifyListeners() triggers a rebuild before Navigator.pop() finishes, Flutter throw:
                                                // setState() or markNeedsBuild() called during build  later if its break use listen:false
                                                // Provider.of<AuthProvider>(context, listen: false)
                                                //     .deleteUser(detail.id);
                                              },
                                              child: const Text('Delete',style: TextStyle(color: Colors.white),),
                                            ),
                                          ],
                                        );
                                      }
                                    );
                                  },
                                  style: TextButton.styleFrom(backgroundColor: Colors.red),
                                  child: const Text('Delete', style: TextStyle(color: Colors.white)),
                                ),
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




