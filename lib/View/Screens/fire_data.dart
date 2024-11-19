
import 'package:exam2_advflutter/Modal/contact_modal.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../Provider/contact_provider.dart';
import '../Component/text_field.dart';


class FirestoreData extends StatelessWidget {
  const FirestoreData({super.key});

  @override
  Widget build(BuildContext context) {
    var providerTrue = Provider.of<ContactProvider>(context);
    var providerFalse = Provider.of<ContactProvider>(context, listen: false);
    var height = MediaQuery.of(context).size.height;
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text('Cloud data'),
        actions: [
          TextButton(
            onPressed: () async {
              await providerFalse.syncCloudToLocal();
            },
            child: const Text(
              'Save to local',
              style: TextStyle(
                color: Colors.black,
              ),
            ),
          ),
        ],
      ),
      body: StreamBuilder(
        stream: providerFalse.readDataFromFireStore(),
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

          var data = snapshot.data!.docs;
          List<ContactModal> contactList = [];

          for (var i in data) {
            contactList.add(
              ContactModal.fromMap(
                i.data(),
              ),
            );
            providerTrue.contactCloudList.add(
              ContactModal.fromMap(
                i.data(),
              ),
            );
          }

          return ListView.builder(
            itemCount: contactList.length,
            itemBuilder: (context, index) => ListTile(
              onLongPress: () {
                showModalBottomSheet(
                  context: context,
                  builder: (context) => SizedBox(
                    width: double.infinity,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          contactList[index].name,
                          style: const TextStyle(
                            fontSize: 20,
                          ),
                        ),
                        SizedBox(
                          height: height * 0.01,
                        ),
                        Text(
                          contactList[index].phone,
                          style: const TextStyle(
                            fontSize: 19,
                          ),
                        ),
                        SizedBox(
                          height: height * 0.01,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            Text(
                              contactList[index].email,
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
                                    contactList[index].name;
                                providerTrue.txtphone.text =
                                    contactList[index].phone;
                                providerTrue.txtemail.text =
                                    contactList[index].email;
                                showDialog(
                                  context: context,
                                  builder: (context) => AlertDialog(
                                    title: const Text('Update Notes'),
                                    actions: [
                                      MyTextField(
                                        label: 'Title',
                                        controller: providerTrue.txtname,
                                      ),
                                      MyTextField(
                                        label: 'Content',
                                        controller: providerTrue.txtphone,
                                      ),
                                      MyTextField(
                                        label: 'Category',
                                        controller: providerTrue.txtemail,
                                      ),
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

                                              ContactModal data = ContactModal(
                                                id: contactList[index].id,
                                                name: providerTrue.txtname.text,
                                                phone: providerTrue.txtphone.text,
                                                email: providerTrue.txtemail.text,
                                              );
                                              providerFalse
                                                  .updateDataFromFirestore(
                                                  data);
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
                                providerFalse.deleteDataFromFireStore(
                                    contactList[index].id!);
                                Navigator.pop(context);
                              },
                              icon: const Icon(Icons.delete),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                );
              },
              leading: Text('${index + 1}'),
              title: Text(contactList[index].name),
              subtitle: Text(contactList[index].phone),
              trailing: Text(contactList[index].email),
            ),
          );
        },
      ),
    );
  }
}
