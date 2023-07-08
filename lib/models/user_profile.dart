import 'package:intl/intl.dart';

class ModelUser{
  final String email;
  final String username;
  final String password;
  final ModelUserProfile profile;

  ModelUser({
    required this.email,
    required this.username,
    required this.password,
    required this.profile,
  });
}

class ModelUserProfile {
  final String image;
  final String displayName;
  final String gender;
  final String birthday;
  final String horoscope;
  final String zodiac;
  final String height;
  final String weight;
  final List<String> interest;

  ModelUserProfile({
    required this.image,
    required this.displayName,
    required this.gender,
    required this.birthday,
    required this.horoscope,
    required this.zodiac,
    required this.height,
    required this.weight,
    required this.interest,
  });

  String getAge() {
    if(birthday.isEmpty){
      return '';
    }
    final currentDate = DateTime.now();
    final birthdayDate = DateFormat('dd MM yyyy').parse(birthday);
    final age = currentDate.year - birthdayDate.year;
    if (currentDate.month < birthdayDate.month ||
        (currentDate.month == birthdayDate.month && currentDate.day < birthdayDate.day)) {
      return (age - 1).toString();
    }
    return age.toString();
  }
}


class UserProfileDatabase{
  final List<ModelUser> _users = usersAPI;
  final ModelUser _userNull = userX;

  Future<ModelUser> getUser(String username) async{
    await Future.delayed(const Duration(seconds: 1));
    return _users.firstWhere((user) => user.username == username, orElse: () => _userNull);
  }

  List<ModelUser> getUsers(){
    return _users;
  }

  Future<void> deleteUser(String username) async{
    await Future.delayed(const Duration(seconds: 1));
    _users.removeWhere((user) => user.username == username);
  }

  Future<void> addUser(ModelUser user) async{
    await Future.delayed(const Duration(seconds: 1));
    _users.add(user);
  }

  Future<void> updateUser(ModelUser user) async{
    await Future.delayed(const Duration(seconds: 1));
    ModelUser temp = user;
    deleteUser(user.username);
    addUser(temp);
  }

}


// =========== user simulation ===========
ModelUser userX = ModelUser(
    email: '',
    username: '',
    password: '',
    profile: ModelUserProfile(
      // image: 'https://www.pockettactics.com/wp-content/sites/pockettactics/2023/05/honkai-star-rail-silver-wolf.jpeg',
        image : '',
        displayName: '',
        gender: '',
        birthday: '',
        horoscope: '',
        zodiac: '',
        height: '',
        weight: '',
        interest: []
    )
);
// =========== /////////////// ===========

ModelUser user1 = ModelUser(
  email: 'user1@gmail.com',
  username: 'user1',
  password: 'user1',
  profile: ModelUserProfile(
    // image: 'https://www.pockettactics.com/wp-content/sites/pockettactics/2023/05/honkai-star-rail-silver-wolf.jpeg',
      image : '',
      displayName: 'hello',
      gender: '',
      birthday: '',
      horoscope: '',
      zodiac: '',
      height: '',
      weight: '',
      interest: []
  )
);

List<ModelUser> usersAPI = [user1];