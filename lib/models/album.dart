class Album {
  final String uid;
  final String title;
  final String artist;
  final int year;


  bool isFav = false;

  Album({required this.uid,
    required this.title,
    required this.artist,
    required this.year,
  });
}
