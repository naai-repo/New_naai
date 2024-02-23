

class UrlConstants{

  static const baseUrl = "http://13.235.49.214:8800/";

  static const login =  '${baseUrl}customer/user/login';
  static const forgotPassword =  '${baseUrl}customer/user/forgotPassword';
  static const changePassword =  '${baseUrl}customer/otp/changePassword';
  static const verifyOtp =  '${baseUrl}customer/otp/verify';
  static const resendOtp =  '${baseUrl}customer/otp/resend';
  static const updateUser = '${baseUrl}customer/user/update';
  static const updateLocation = '${baseUrl}customer/user/location/set';
  static const topSalon = '${baseUrl}partner/salon/topSalons';
  static const topArtist = '${baseUrl}partner/artist/topArtists';

  static const discountAndRating = '${baseUrl}partner/salon/filter?&filter=discount';
  static const discountAndRatingForMen = '${baseUrl}partner/salon/filter?page=1&limit=20&filter=discount&min=';
  static const discountAndRatingForWomen = '${baseUrl}partner/salon/filter?page=1&limit=20&filter=discount&min=';
  static const salonsFilter = "${baseUrl}partner/salon/filter";
  static const artistFilter = '${baseUrl}partner/artist/filter';
  static const scheduling = '${baseUrl}appointments/schedule';
  static const makeAppointment = '${baseUrl}appointments/book';
  static const deleteBooking = '${baseUrl}appointments/delete';
  static const bookAgain = '${baseUrl}appointments/bookAgain';
  static const getSingleSalon = '${baseUrl}partner/salon/single';
  static const getSingleArtist = '${baseUrl}partner/artist/single';
  static const getSingleService = '${baseUrl}partner/service/single';
  static const getSalonsByCategory = '${baseUrl}partner/service/search/salon';
  static const getSalonReview = '${baseUrl}partner/review/salon';
  static const getArtistsByCategory = '${baseUrl}partner/service/search/artist';
  static const getUser = '${baseUrl}customer/user';
  static const addReview = '${baseUrl}partner/review/add';
  static const scheduleAppointment = '${baseUrl}appointments/schedule';
  static const bookingSingleArtistList = '${baseUrl}appointments/singleArtist/list';
  static const bookingMakeAppointment = '${baseUrl}appointments/book';
  static const bookingConfirm = '${baseUrl}appointments/confirm';
  static const addUserFav = '${baseUrl}customer/user/favourite/add';
  static const getUserLoaction = '${baseUrl}customer/user/location';
  static const getUserFav = '${baseUrl}customer/user/favourite/get';
  static const deleteUser = '${baseUrl}customer/user/delete';

  static const mapboxPlace = 'https://api.mapbox.com/geocoding/v5/mapbox.places/';

}
