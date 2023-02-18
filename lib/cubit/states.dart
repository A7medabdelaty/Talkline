abstract class AppStates {}

class AppInitialState extends AppStates {}

class AppGetUserDataLoadingState extends AppStates {}

class AppGetUserDataSuccessState extends AppStates {}

class AppGetUserDataErrorState extends AppStates {}

class AppGetPostsLoadingState extends AppStates {}

class AppGetPostsSuccessState extends AppStates {}

class AppGetPostsErrorState extends AppStates {}

class AppEmailVerifiedSuccessState extends AppStates {}

class AppChangeVerificationState extends AppStates {}

class ChangeBottomNavBarState extends AppStates {}

class AddPostState extends AppStates {}

class GetCoverImageSuccessState extends AppStates {}

class GetCoverImageErrorState extends AppStates {}

class GetProfileImageSuccessState extends AppStates {}

class GetProfileImageErrorState extends AppStates {}

class UploadProfileImageSuccessState extends AppStates {}

class UploadProfileImageErrorState extends AppStates {}

class UploadProfileImageLoadingState extends AppStates {}

class UploadCoverImageSuccessState extends AppStates {}

class UploadCoverImageErrorState extends AppStates {}

class UploadCoverImageLoadingState extends AppStates {}

class UpdateUserDataErrorState extends AppStates {}

class UpdateUserDataLoadingState extends AppStates {}

// post

class GetPostImageSuccessState extends AppStates {}

class GetPostImageErrorState extends AppStates {}

class CreatePostLoadingState extends AppStates {}

class CreatePostSuccessState extends AppStates {}

class CreatePostErrorState extends AppStates {}

class UploadPostImageSuccessState extends AppStates {}

class UploadPostImageErrorState extends AppStates {}

class UploadPostImageLoadingState extends AppStates {}

class RemovePostImageSuccessState extends AppStates {}

class LikePostSuccessState extends AppStates {}

class LikePostErrorState extends AppStates {}

class ChangeLikeIconState extends AppStates {}

class GetLikesState extends AppStates {}

class AppGetAllUsersSuccessState extends AppStates {}

class AppGetAllUsersErrorState extends AppStates {}
//comment

class GetCommentsSuccessState extends AppStates {}

class GetCommentsErrorState extends AppStates {}

class UpdateSuccess extends AppStates {}

class UpdateSuccessFalse extends AppStates {}

class UpdateError extends AppStates {}

class SendMessageSuccessState extends AppStates {}

class SendMessageErrorState extends AppStates {}

class GetMessageSuccessState extends AppStates {}
