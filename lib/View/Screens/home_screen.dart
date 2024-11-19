import 'package:exam2_advflutter/View/Screens/sign_in.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../Modal/contact_modal.dart';
import '../../Provider/contact_provider.dart';
import '../../Service/auth_service.dart';
import '../Component/text_field.dart';
import 'fire_data.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    var providerTrue = Provider.of<ContactProvider>(context);
    var providerFalse = Provider.of<ContactProvider>(context, listen: false);
    var height = MediaQuery.of(context).size.height;
    return Scaffold(
      backgroundColor: Colors.white,
      drawer: Drawer(
        child: Column(
          children: [
            SizedBox(
              height: height * 0.15,
              child: const DrawerHeader(
                child: Text('Settings'),
              ),
            ),
            ListTile(
              onTap: () {
                Navigator.pop(context);
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const FirestoreData(),
                  ),
                );
              },
              leading: const Icon(Icons.cloud),
              title: const Text('See Data in cloud'),
            ),
            SizedBox(height: 10,),
            ListTile(
              onTap: () async {
                await AuthService.authService.signOutUser();

                User? user = AuthService.authService.getUser();
                if (user == null) {
                  Navigator.of(context).push(MaterialPageRoute(builder: (context) => SignIn(),));
                }
              },
              title: Text("Log Out"),
              trailing: Icon(
                Icons.logout,
                color: Colors.black,
              ),
            ),
          ],
        ),
      ),
      appBar: AppBar(
        backgroundColor: Colors.black,
        leading: Icon(Icons.menu,color: Colors.white,),

        title: const Text('   Contact Dairy',style: TextStyle(color: Colors.white,fontSize: 18),),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 15),
            child: TextButton(
              onPressed: () {
                List<ContactModal> data = providerTrue.contactList
                    .map(
                      (e) => ContactModal.fromMap(e),
                )
                    .toList();
                for (int i = 0; i < data.length; i++) {
                  providerFalse.addNoteFireStore(data[i]);
                }
                showDialog(
                  context: context,
                  builder: (context) => AlertDialog(
                    title: const Text('Backup complete'),
                    content:
                    const Text('All the data successfully stores to cloud'),
                    actions: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          TextButton(
                            onPressed: () {
                              Navigator.pop(context);
                            },
                            child: const Text(
                              "OK",
                              style: TextStyle(color: Colors.black),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                );
              },
              child: const Text(
                'Backup',
                style: TextStyle(color: Colors.white),
              ),
            ),
          ),
        ],
      ),
      body: FutureBuilder(
        future: providerFalse.readDataFromDatabase(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Center(
              child: Text(
                snapshot.error.toString(),
              ),
            );
          }
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          List<ContactModal> contactModal = providerTrue.contactList
              .map(
                (e) => ContactModal.fromMap(e),
          )
              .toList();

          return ListView.builder(
            itemCount: contactModal.length,
            itemBuilder: (context, index) => ListTile(
              onTap: () {
                showModalBottomSheet(
                  context: context,
                  builder: (context) => SizedBox(
                    width: double.infinity,
                    height: 180,
                    child: Center(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            contactModal[index].name,
                            style: const TextStyle(
                              fontSize: 20,
                            ),
                          ),
                          SizedBox(
                            height: height * 0.01,
                          ),
                          Text(
                            contactModal[index].phone,
                            style: const TextStyle(
                              fontSize: 19,
                            ),
                          ),
                          SizedBox(
                            height: height * 0.01,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              Text(
                                contactModal[index].email,
                                style: const TextStyle(
                                  fontSize: 17,
                                ),
                              ),
                            ],
                          ),
                          SizedBox(
                            height: height * 0.03,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              IconButton(
                                onPressed: () {
                                  Navigator.pop(context);
                                  providerTrue.txtname.text =
                                      contactModal[index].name;
                                  providerTrue.txtphone.text =
                                      contactModal[index].phone;
                                  providerTrue.txtemail.text =
                                      contactModal[index].email;
                                  showDialog(
                                    context: context,
                                    builder: (context) => AlertDialog(
                                      title: const Text('Update Conctact'),
                                      actions: [
                                        MyTextField(
                                          label: 'Name',
                                          controller: providerTrue.txtname,
                                        ),
                                        SizedBox(height: 10,),
                                        MyTextField(
                                          label: 'Phone',
                                          controller: providerTrue.txtphone,
                                        ),
                                        SizedBox(height: 10,),
                                        MyTextField(
                                          label: 'Email',
                                          controller: providerTrue.txtemail,
                                        ),
                                        SizedBox(height: 10,),
                                        Row(
                                          mainAxisAlignment:
                                          MainAxisAlignment.end,
                                          children: [
                                            TextButton(
                                              onPressed: () {
                                                Navigator.pop(context);
                                              },
                                              child: const Text(
                                                'Cancel',
                                                style: TextStyle(
                                                  color: Colors.black,
                                                ),
                                              ),
                                            ),
                                            TextButton(
                                              onPressed: () {
                                                providerFalse
                                                    .updateNoteInDatabase(
                                                  contactModal[index].id!,
                                                  providerTrue.txtname.text,
                                                  providerTrue.txtphone.text,
                                                  providerTrue.txtemail.text,
                                                );
                                                Navigator.pop(context);
                                              },
                                              child: const Text(
                                                'OK',
                                                style: TextStyle(
                                                  color: Colors.black,
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  );
                                },
                                icon: const Icon(Icons.edit),
                              ),
                              IconButton(
                                onPressed: () {
                                  providerFalse.deleteNoteInDatabase(
                                      contactModal[index].id!);
                                  Navigator.pop(context);
                                },
                                icon: const Icon(Icons.delete),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
              leading: Text('${index + 1}'),
              title: Text(contactModal[index].name),
              subtitle: Text(contactModal[index].phone),
              trailing: Text(contactModal[index].email),
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.black,
        onPressed: () {
          showDialog(
            context: context,
            builder: (context) => AlertDialog(
              title: const Text('Add Notes'),
              actions: [
                MyTextField(
                  label: 'Name',
                  controller: providerTrue.txtname,
                ),
                SizedBox(height: 10,),
                MyTextField(
                  label: 'Phone',
                  controller: providerTrue.txtphone,
                ),
                SizedBox(height: 10,),
                MyTextField(
                  label: 'Email',
                  controller: providerTrue.txtemail,
                ),
                SizedBox(height: 10,),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    TextButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      child: const Text('Cancel'),
                    ),
                    TextButton(
                      onPressed: () {
                        providerFalse.addNotesDatabase(
                          providerTrue.txtname.text,
                          providerTrue.txtphone.text,
                          providerTrue.txtemail.text,
                        );
                        Navigator.pop(context);
                      },
                      child: const Text('OK'),
                    ),
                  ],
                ),
              ],
            ),
          );
        },
        child: const Icon(Icons.add,color: Colors.white,),
      ),
    );
  }
}
