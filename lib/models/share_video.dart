class ShareVideo {
  String? uid;
  String? videoName;
  String? videoDes;
  String? videoUrl;

  ShareVideo(
      {this.uid,this.videoName,this.videoDes,this.videoUrl});

  //receiving data from server
  factory ShareVideo.fromMap(map){
    return ShareVideo(
        uid: map['uid'],
        videoName: map['videoName'],
        videoDes: map['videoDes'],
        videoUrl: map['videoUrl']
    );
  }

  //sending data to server
  Map <String,dynamic> toMap(){
    return{
      'uid': uid,
      'videoName': videoName,
      'videoDes': videoDes,
      'videoUrl': videoUrl,
    };
  }

}
