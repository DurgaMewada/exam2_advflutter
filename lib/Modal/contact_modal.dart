class ContactModal {
  int? id;
  late String name,phone,email;

  ContactModal({
    this.id,
    required this.name,
    required this.phone,
    required this.email,
  });

  factory ContactModal.fromMap(Map m1) {
    return ContactModal(
      id: m1['id'],
     name: m1['name'],
      phone: m1['phone'],
      email: m1['email'],
    );
  }
}

Map toMap(ContactModal contact) {
  return {
    'name':contact.name,
    'phone':contact.phone,
    'email':contact.email,
    'id':contact.id,
  };
}
