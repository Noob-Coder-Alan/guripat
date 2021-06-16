# Guripat
Grocery list app built with Flutter, Apollo-Express and GraphQL

## Setup
Inside frontend directory, run...
```
flutter pub get
```
then
```
flutter run
```

And that's it! backend setup is not necessary as it uses a server hosted at Heroku by default. Check it out [here](https://guripat.herokuapp.com/graphql)

If a local server is desired, simply ```npm start``` in backend directory and change the link in  ```main.dart``` in frontend directory.
```
// var link = 'http://localhost:5000/graphql';
var link =  'https://guripat.herokuapp.com/graphql';
```
## Tests
Run tests inside ```frontend```

Unit and widget tests: 
 ```flutter test```
 
Integration tests: 
```flutter drive --target=test_driver/app.dart```



## GPS Test Solution
My solution can be found in this directory```frontend/test/gps_test.dart```
