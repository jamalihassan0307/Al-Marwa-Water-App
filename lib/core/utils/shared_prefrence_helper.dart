



// class SharedPrefHelper {
//   static late SharedPreferences prefs;
//   static getInitialValue() async {
//     prefs = await SharedPreferences.getInstance();
//     StaticData.isFirstTime = await getBool(isFirstTimeText) ?? true;
//     StaticData.isParent = await getBool(isJobSeekerText) ?? true;
//     StaticData.isAdmin = await getBool(isAdminText) ?? false;
//     StaticData.isLoggedIn = await getBool(isLoggedInText) ?? false;
//   }

//   // Save a string value
//   static saveString(String key, String value) async {
//     await prefs.setString(key, value);
//   }

//   // Retrieve a string value
//   static getString(String key) async {
//     return prefs.getString(key);
//   }

//   // Save a boolean value
//   static saveBool(String key, bool value) async {
//     await prefs.setBool(key, value);
//   }

//   // Retrieve a boolean value
//   static getBool(String key) async {
//     return prefs.getBool(key);
//   }

//   // Save an integer value
//   static saveInt(String key, int value) async {
//     await prefs.setInt(key, value);
//   }

//   // Retrieve an integer value
//   static getInt(String key) async {
//     return prefs.getInt(key);
//   }

//   // Save a double value
//   static saveDouble(String key, double value) async {
//     await prefs.setDouble(key, value);
//   }

//   // Retrieve a double value
//   static getDouble(String key) async {
//     return prefs.getDouble(key);
//   }

//   // Remove a value
//   static remove(String key) async {
//     await prefs.remove(key);
//   }

//   // Clear all values
//   static clearAll() async {
//     await prefs.clear();
//   }
// }


