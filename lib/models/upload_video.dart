class UploadVideo {
  String? uid;
  String? videoOwner;
  String? videoName;
  String? videoDes;
  String? videoUrl;

  UploadVideo(
      {this.uid,this.videoOwner,this.videoName,this.videoDes,this.videoUrl});

  //receiving data from server
  factory UploadVideo.fromMap(map){
    return UploadVideo(
      uid: map['uid'],
      videoOwner: map['videoOwner'],
      videoName: map['videoName'],
      videoDes: map['videoDes'],
      videoUrl: map['videoUrl']
    );
  }

  //sending data to server
  Map <String,dynamic> toMap(){
    return{
      'uid': uid,
      'videoOwner': videoOwner,
      'videoName': videoName,
      'videoDes': videoDes,
      'videoUrl': videoUrl,
    };
  }

}
