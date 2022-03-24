class Contact {
  String    name; 
  String    phonenumber;
  String?   lastname;
  String?   email;
  String?   imageUrl;
  String?   moreInfos;
  
  Contact(this.name, this.phonenumber, [this.lastname, this.email, this.imageUrl, this.moreInfos]);
}

List<Contact> dummyContactList = [
  Contact(
    'Micka',
    '0781635945',
    'Lokhate',
    'lokhatemickael@gmail.com'
  ),
  Contact(
    'John',
    '0111111111',
    'Doe',
    'johndoe@gmail.com'
  ),
  Contact(
    'Test',
    '022222222',
  ),
  Contact(
    'Hello',
    '0333333333',
  ),
  Contact(
    'World',
    '0444444444',
  ),
  Contact(
    'Here',
    '0555555555',
  ),
];