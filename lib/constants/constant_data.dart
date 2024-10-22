import 'package:flutter_screenutil/flutter_screenutil.dart';

class SharedPresKeys {
  static const fireToken = "fireToken";
  static const userToken = "userToken";
  static const isLogin = "isLogin";
  static const localProfileOptions = "localProfileOptions";
  static const searchFilterData = "searchFilter";
  static const sparkFilterData = "sparkFilter";
  static const latitude = "latitude";
  static const longitude = "longitude";
  static const selfEntity = "selfEntity";
  static const reportData = "reportData";
  static const cityData = "cityData";
  static const appleEmail = "appleEmail";
  static const downloadedLanguage = "downloadedLanguage";
  static const autoTranslate = "autoTranslate";
  static const primaryLanguage = "primaryLanguage";
  static const viewRecommendUserCount = "viewRecommendUserCount";
  static const isOpenToMain = "isOpenToMain";
}

class ConstantData {
  static final successResponseCode = [200, 201, 202, 203, 204, 205, 206];

  static const code = "code";
  static const message = "message";
  static const data = "data";

  static const int genderTypeMen = 2;
  static const int genderTypeWomen = 1;

  static const String keyAnyWhere = "Anywhere";

  static const sortDistance = "Distance";
  static const String sortLastLogin = "Last login";
  static const String sortNewest = "Newest";
  static const String sortSmart = "Smart";

  static const double maxMessageImageSize = 200;

  static const errorTokenInvalid = 2000110;
  static const errorRefreshToken = 2000116;
  static const errorAccountSuspended = 30001055;
  static const errorNeedRecaptcha = 30001051;
  static const errorUserHidden = 30001024;
  static const errorUserBlockMe = 30001033;
  static const errorUserUnavailable = 30001029;
  static const errorEmailExists = 30001018;
  static const errorUserInactive = 30001021;
  static const errorCodeInvalidEmailOrPassword = 30001013;

  //get route params
  static const paramsUserId = "userId";
  static const paramsEmail = "email";
  static const paramsPwd = "pwd";
  static const paramsUserName = "userName";
  static const paramsSignKey = "signKey";
  static const paramsIndex = "index";
  static const paramsIsLogin = "isLogin";
  static const paramsUrl = "url";
  static const paramsTitle = "title";
  static const appleToken = "appleToken";
  static const appleCode = "appleCode";

  static const int photoTypePublic = 1;
  static const int photoTypePrivate = 2;
  static const int photoTypeVerify = 3;

  static const double maxAssetImageWidth = 1920;
  static const double maxAssetImageHeight = 1080;

  static double defaultAvatarSize = 48.w;

  static const googleHelpCenter = "https://support.google.com/googleplay/answer/2476088?hl=en&ref_topic=1689236";
  static const googleRecaptcha = "assets/html/recaptcha.html";

  static const String serviceAgreementUrl = "";
  static const String privacyPolicyUrl = "";

  static const userStatusNotVerify = "0";
  static const userStatusVerified = "1";
  static const userStatusPending = "2";
  static const userStatusReject = "3";
  static const userStatusPendingCanUpload = "4";

  static const activityVideo = "11";
  static const activityAudio = "19";

  static const lastImageMsg = "[Image]";
  static const lastWinkMsg = "[Wink]";

  static const funQuestion = "funQuestion";
  static const userQuestion = "myQuestion";

  static final normalBtnWidth = 312.w;
  static final normalBtnHeight = 54.w;

  static const notificationComment = "11";
  static const notificationReply = "20";

  static const honeyOption = 'Honey';
  static const nearbyOption = 'Nearby';
  static const honeyPageContent = 'Honey Page Content';
  static const nearbyPageContent = 'Nearby Page Content';

  //fontStyle
  static const fontPoppins = 'Poppins';
  static const fontOpenSans ='Open Sans';
  //background
  static const backText = 'Back';
  static const saveText = 'Save';
  static const searchText = 'Search';
  //bottom_options
  static const CancelText = 'Cancel';
  //custom_message_dialog
  static const cancelText = 'cancel';
  static const yesText='Yes';
  static const noText='No';
  static const okText = 'OK';
  static const andText = " and ";
  static const successText = 'success';
  static const sendSuccess ="sent successfully";
  static const failedText = 'failed';
  static const sorryText = 'sorry';
  static const sendFailed = "Failed to send ";
  static const confirmDel = 'Confirm Delete';
  static const userDataNotFound = 'User data not found. Please log in again.';
  static const deleteMomentContent = 'Are you sure you want to delete this moment?';
  static const signOutText = 'Are you sure you want to sign out?';
  static const momentUploadSuccess = 'Moment uploaded successfully!';
  static const setAvatarTitle = 'Set Avatar';
  static const setAvatarContent = "Are you sure you want to set this photo as your avatar?";
  static const noticeAboutLiked = "You haven't added any favorite users yet. We look forward to seeing your preferences soon!";
  static const filterNoResultTitle = 'No results found';
  static const filterNoResultContent = 'You may want to try adjusting your search criteria, it might yield more relevant results.';
  //snack
  static const userHasBlocked = 'User has been blocked';
  static const failedBlocked ='Failed to block user';
  static const failedUpdateProfile = 'Failed to update profile';
  static const successUpdateProfile = 'Profile updated successfully';
  static const invalidLocation =  'Invalid location selection';
  static const usernameCharacters = 'Username must be 16 characters or fewer';
  static const uploadSuccess = 'Upload successful!';
  static const uploadFailed = 'Upload failed, please try again later';
  static const deletePhotoSuccess = 'Photo deleted successfully!';
  static const failedDeletePhoto =  'Failed to delete photo';
  static const avatarSetSuccess = 'Avatar set successfully!';
  static const avatarSetFailed = 'Failed to set avatar';
  static const loadFailed = 'Failed to load';
  static const unlockSuccess = 'User unblocked successfully';
  static const unlockFailed ='Failed to unblock user';
  static const feedBackSuccess = 'Feedback submitted successfully';
  static const failedComment = 'Failed to add comment';
  static const verifyVideoSuccessTitle = 'Video verification request sent successfully';
  static const verifyVideoSuccessContent = 'Video verification request sent successfully,Video verification request sent successfully. Please wait patiently for manual review.';
  static const errorText = 'Error';
  static const noticeText = 'Notice';
  static const gotItText = 'Got it';
  static const registerFailed = 'Register failed';
  static const deleteConversationTitle = 'Delete Conversation';
  static const deleteConversationContent = 'Are you sure you want to delete this conversation?';
  //detail_bottom_bar
  static const likeText='like';
  //get_email_code
  static const  welcomeText = "Welcome";
  static const  enterEmailText = "Please enter your email";
  static const  emailLabelText = "Email";
  static const  nextButtonText = "Next";
  static const  ppsaContent = "By creating an account or logging in, you agree to our ";
  static const  serviceAgreement = "Service Agreement";
  static const  privacyPolicy = "Privacy Policy";
  //verify_email
  static const  verifyCodeTitle = "Verify Code";
  static const  verifyCodeSubtitle = "Enter the verify code sent to your email";
  static const  resendCode = "Resend Code";
  static const  timerText = "s resend code";
  static const  verifyButtonText = "Verify";
  //verify_success
  static const  emailVerificationSuccess = "Email verification successful!";
  static const  emailVerificationSuccessMessage = "Your email has been successfully verified.";
  //select_birthday
  static const  birthdayTitle = "Birthday";
  static const  continueButtonText = "Continue";
  //select_gender
  static const  genderTitle = "Gender";
  static const  maleOption = "Male";
  static const  femaleOption = "Female";
  static const  genderWarning = "Gender cannot be changed after selection";
  //select_height
  static const  heightTitle = "Height";
  static const  heightHeadTitle = "Height";
  //select_location
  static const  locationTitle = "Location";
  static const  selectedCountry = "Select Country";
  static const  selectedState = "Select State";
  static const  selectedCity = "Select City";
  static const  countryText = 'country';
  static const  stateText = 'state';
  static const  cityText = 'city';
  //sign_up
  static const  nicknameTitle = "Set a nickname";
  static const  passwordTitle = "Set a password";
  static const  submitButtonText = "Submit";
  static const  signUpText ="Sign Up";
  //sign_in
  static const  enterYourEmail = "Enter your email";
  static const  enterPasswordText = "Enter your password";
  static const  forgetPassword = "Forget Password?";
  static const  emailEmpty = "Email cannot be empty";
  static const  signInText ="Sign In";
  //profile_card
  static const  photosVerified = 'Photos verified';
  //feel_page
  static const  feelTitleText ='Feel';
  //profile_detail
  static const  headline = 'Headline';
  static const  moments = 'Moments';
  static const  aboutMe = 'About Me';
  static const  chatButton = 'Chat';
  static const  noMomentsData = "This user hasn't shared any moments yet.";
  static const  noMomentsText = 'No moments yet, come and publish your first one!';
  static const  winkTitle = 'tap to send a wink';
  //bottom_options
  static const reportButton = 'report';
  static const blockButton = 'block';
  static const unblockButton = 'unblock';
  //home_page
  static const  feelLabel = 'Feel';
  static const  getUpLabel = 'Get up';
  static const  gameLabel = 'Game';
  static const  gossipLabel = 'Gossip';
  static const  viewLabel = 'View';
  static const  filtersLabel = 'Filters';
  static const  verifiedMemberLabel = 'verify';
  //game_page
  static const  verifiedPageTitle ='verified member';
  //detail_bottom
  static const  winkButton = 'wink';
  static const  callButton = 'call';

  //profile_content
  static const  usernameTitle = 'Username';
  static const  ageTitle = 'Age';
  static const  headlineTitle = 'Headline';
  static const  ageHead='Age';
  //change_headline
  static const  headlineText='Headline';
  static const  enterCharactersText='Enter up to 50 characters';
  static const  updateHeadlineText='Update';
  //change_height
  static const changeHeightText="Change Height";
  //change_location
  static const  locationHeaderTitle='Location';
  //change_username
  static const  enterUsernameText='Enter up to 16 characters';
  //my_profile
  static const  myProfileTitle = 'My Profile';
  static const  profileOption = 'Profile';
  static const  momentsOption = 'Moments';
  static const  voiceIntroduction = 'Voice introduction';
  static const  introductionText = 'introduction';
  static const  noVoiceText = 'No voice introduction';
  static const  noDescription = 'No description available';
  static const  languageTitle = 'Language';
  static const  tagsTitle = 'Tags';
  //photo
  static const  mainPhotoText='main photo';
  static const  photoTitle='Photo';
  static const  takePhotoText='Take a Photo';
  static const  fromAlbumText='From Album';
  static const  changeMainPhotoText='Whether to change to mainPhoto？';
  static const  confirmText='confirm';
  //about_me
  static const  privacyAgreement = 'Privacy agreement';
  static const  version = 'V1.0';
  //block_members
  static const  blockMembersText = 'Block Members';
  static const  blockUserText = 'block user';
  static const  noBlockedMembersText = 'No blocked members';
  //feedback
  static const  feedbackTitleText='Feedback';
  static const yourIdText='Your idea';
  static const  feedbackHintText = 'Please inform us of our shortcomings and we will improve them as soon as possible.';
  //settings
  static const  settings = 'Settings';
  static const  purchaseRecord = 'Purchase record';
  static const  cleanUpMemory = 'Clean up memory';
  static const  signOut = 'Sign Out';
  //verify_id
  static const  verifyPhotoText = 'Verify Photo';
  static const  turnLeftText = 'Turn left';
  static const  turnRightText = 'Turn right';
  static const  nodText = "Please nod";
  static const  blinkText = "Please blink";
  static const  confirmIdText = "Say 'I confirm the video is real'";
  static const  startText = 'Start';
  static const  followPromptsText = 'Follow the prompts';
  //verify_photo
  static const  verifyVideoText = 'Verify Video';
  static const  verifyContentText = 'Please upload an ID and we will analyze your photo to see if it is you.';
  static const  uploadText = 'Upload';
  static const  verifyMiddleText =  'Verify';
  static const  verifyNotMatchTitle = 'Verify Photo does not match ';
  static const  verificationRejectedTitle = 'Verification Rejected';
  static const  verificationRejectedMessage = 'Your previous verification was rejected. Please try again.';
  static const  verificationPendingTitle = 'Verification Pending';
  static const  verificationPendingMessage = 'Currently under review, please wait for 1-2 business days.';
  static const  verificationApprovalTitle = 'Verification Approval';
  static const verificationApprovalMessage = "Congratulations! You have successfully passed the 'Verified Photo' review. Your profile is now verified.";
  //me_page
  static const  myProfileText = 'My Profile';
  static const  hostText = 'I am Host';
  //moments
  static const  recordMomentText = 'record the moment ...';
  static const  colorTopicsHintText = 'You can use #+ content to add your emotion.';
  static const  recordTheMomentText = 'record the moment ...';
  static const  momentUploadSuccessText = 'Moment uploaded successfully!';
  static const  noComments = 'No comments';
  static const  unknownText = 'Unknown';
  static const  timelineDescrText = 'No description available';
  static const  likesText = 'likes';
  static const  commentsText = 'Comments';
  static const  sendText = 'Send';
  static const  commentText = 'Comment';
  static const  commentWriteText = 'Write a comment...';
  static const  addMomentText = '+';
  static const  addMomentsText = 'Add Moments';
  static const  viewedMoments = 'Viewed Moments';
  static const  viewedText = 'Viewed';
  static const  localMoments = "Local Moments";
  static const  sameCityText = 'Same City';
  static const  messageText = "Message";
  static const  viewedMeText = "Viewed Me";
  static const  likedMeText = "Liked Me";
  //block_user
  static const  blockUserDialogText = 'Are you sure you want to block this user?';
  //report_user
  static const  reportTitle = 'Report';
  static const  pornographicOption  = 'Pornographic';
  static const  violentOption = 'Violent';
  static const  maliciousAttackOption = 'Malicious attack';
  static const  disgustingOption = 'Disgusting';
  static const  otherOption = 'Other';
  static const  describeProblem = 'Please describe your problem…';
  //user_card
  static const  superiorText = 'Superior';
  //user_detail_card
  static const unKnowText ='Unknown';
  static const oneHourText = '/H';
  //record
  static const  recordButtonText ='Record a new voice prologue';
  static const  recordTitle = 'Record';
  static const  starText = 'Star';
  static const  endText = 'End';
  //likedMe
  static const  noOneLikedMeText = 'The stage is set for your future connections.';
  static const  noTokenInLocal = 'Token not found in SharedPreferences';
  //viewed_me
  static const onOneViewedMeText = 'Your profile is waiting to be discovered.';
  //message_content
  static const noMessageText = 'The chat bubble is inflating - messages coming soon.';
  //notification
  static const notificationTitle = 'notification';
  //private_chat
  static const holdToTalkText = "Hold to Talk";
  static const sendMessageText = "Send a message…";
  static const releaseCancelText = "Release to cancel";
  static const slideUpText =  "Slide up to cancel";
  //host
  static const hostTitle = 'I am the Host';
  static const emotionalExpertText ='Emotional expert';
  static const wakeUpAlarmText = 'Wake up alarm';
  static const gameAccompanimentText = 'Game accompaniment';
  static const nightReliefText ='Night relief';
  static const lifeGossipText = 'Life gossip';
  static const becomePodcastText = 'Become a podcast';
  //filter
  static const lookingForText = 'Looking for';
  static const multipleChoicesText = 'You can select Multiple Choices';
  static const sortByTitle = 'Sort by';
  //delete_account
  static const  deleteAccountTitle = 'Delete Account';
  static const  disableAccountTitle = 'Disable Account';
  static const  permanentlyDeleteAccountTitle = 'Permanently Delete Account';
  static const  disableAccountDescription = 'Once you disable your account, others will not be able to contact you. However, you can reactivate it at any time.';
  static const  premiumMembershipInfo = 'If you are a PREMIUM MEMBER, your membership will expire when it\'s supposed to regardless of being disabled or not.';
  static const  disableAccountButtonText = 'Disable Account';
  static const  permanentlyDeleteAccountButtonText = 'Permanently Delete Account';
  static const  disableAccountConfirmation = 'Are you sure you want to disable your account? You can reactivate it at any time.';
  static const  permanentlyDeleteAccountConfirmation = 'Are you sure you want to permanently delete your account? This action cannot be undone.';
  static const  accountDisabledMessage = 'Your account has been disabled.';
  static const  accountDeletedMessage = 'Your account has been permanently deleted.';
  static const  failedToDisableAccount = 'Failed to disable account.';
  static const  failedToDeleteAccount = 'Failed to delete account.';
  //main
  static const voicesDatingTitle = 'VoicesDating';
  static const voicesDatingContent = 'Where Hearts Resonate \Through Sound';
}

