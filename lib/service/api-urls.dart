class ApiUrls{
  //static const baseUrl = "http://103.174.149.39:3004/api/app/users/mobile/login";
 // static const userProfileUrl = baseUrl + 'androidUpdateUserProfile.php';
  static const loginUrl = 'http://103.174.149.39:3004/api/app/users/mobile/login';
  static String changePasswordUrl= 'http://103.174.149.39:3004/api/app/users/mobile/changepassword';
  static String saveProductUrl="http://103.174.149.39:3004/api/app/savedproducts/mobile/savedproducts";

  static String profileImage = 'assets/logo.png';


  static bool isMobile = false;
  static String locQrCode = "";
  static String prodQrCode = "";

  static bool loaderOnBtn = false;

  static String profileToken="";

  static var userId="";




}