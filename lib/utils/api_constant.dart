

class UrlConstants{

  static const baseUrl = "http://13.235.49.214:8800/";

  static const login =  '${baseUrl}customer/user/login';
  static const forgotPassword =  '${baseUrl}customer/user/forgotPassword';
  static const changePassword =  '${baseUrl}customer/otp/changePassword';
  static const verifyOtp =  '${baseUrl}customer/otp/verify';
  static const resendOtp =  '${baseUrl}customer/otp/resend';
  static const updateUser = '${baseUrl}customer/user/update';
  static const updateLocation = '${baseUrl}customer/user/location/set';
  static const topSalon = '${baseUrl}partner/salon/topSalons?page=1&limit=20';
  static const topArtist = '${baseUrl}partner/artist/topArtists';

  static const discountAndRating = '${baseUrl}partner/salon/filter?&filter=discount';
  static const discountAndRatingForMen = '${baseUrl}partner/salon/filter?page=1&limit=20&filter=discount&min=9';
  static const discountAndRatingForWomen = '${baseUrl}partner/salon/filter?page=1&limit=20&filter=discount&min=50';
  static const ratingFilter = '${baseUrl}partner/artist/filter?&filter=rating';
  static const scheduling = '${baseUrl}appointments/schedule';
  static const makeAppointment = '${baseUrl}appointments/book';
  static const deleteBooking = '${baseUrl}appointments/delete';
  static const BookAgain = '${baseUrl}appointments/bookAgain';

}
