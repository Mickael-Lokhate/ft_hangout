# ft_hangout - ![mlokhate's 42 ft_hangouts Score](https://badge42.vercel.app/api/v2/cl1mdvtu6009009mod72g373r/project/2548155)

For this project, you will have to design an mobile application that will allow to create a
contact and send texts.

## Goal
You will have to fulfill various tasks that will help you understand how a mobile app
works. The goal is to make an app allowing to create a contact (containing at least 5
details), edit it and delete it. Once the contact is recorded, you will have to be able to
communicate with him through text messages.

Contacts are recorded persistently (SQLite database, don’t use the shared contact
table. You must create your own). A sumary for each contact will appear as a list on the
app’s homepage. You should be able to click on each contact to show their details.

Your app will have to propose two different languages, one being the default language
(change the system language for a test). When you’re on the homepage and set the app
in the background, the date will be saved and will show in a toast when you return to
the front. You will have to create a menu that will allow you to change the app’s header
color. Finally, the app icon will have to be the 42 logo.

## Subject definition

- Language : Flutter
- Requirements :
    - Create a contact
    - Edit a contact
    - Delete a contact
    - Homepage with summary for each contact
    - Receive text messages from contacts
    - Send text messages to contacts
    - Menu that allow to change header color
    - 2 differents languages
    - Show the time the app set in background when returning to app in a toast (snackbar)
    - Work in landscape and portrait
    - Icon : 42 Logo
- Bonus :
    - Picture for each contact
    - When receiving a message, automatically create contact with number as name
    - Can call
    
## Versionning

### v0

- Homepage with all contact ✅
- Can create a contact ✅
- Edit a contact ✅
- Delete a contact ✅
- 42 Logo ✅

### v1

- Send messages ✅
- Receive messages ✅
- Menu to change header color ✅
- Show the time when background ✅
- Data persistence ✅
- 2 differents languages ✅

### v2

- Pictures for contacts ✅
- Call ✅
- Automatically create contact ✅

## Documentation

Dart Doc : [https://dart.dev/guides](https://dart.dev/guides)

Flutter Doc : [https://docs.flutter.dev/](https://docs.flutter.dev/)
