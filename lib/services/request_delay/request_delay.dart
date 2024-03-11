class RequestDelayServices{
  static DateTime time = DateTime.now();

  static start(){
      time = DateTime.now();
  }

  static end(String str){
    int diff = DateTime.now().millisecond - time.millisecond;
    print("$str $diff ms");
  }
}