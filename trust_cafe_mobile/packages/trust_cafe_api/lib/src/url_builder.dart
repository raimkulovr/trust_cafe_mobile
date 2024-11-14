
typedef ApiChannelSupplier = bool Function();

class UrlBuilder {
  static const _alphaUrlPrefix = 'w1yygdhayc';
  static const _productionUrlPrefix = '32hho6rvg1';
  static const _alphaAuthUrlPrefix = 'oo0wks9pbi';
  static const _productionAuthUrlPrefix = 'e2we3nktl4';
  static const _alphaModerationUrlPrefix = 'sbb1xrqsf1';
  static const _productionModerationUrlPrefix = 'egfpoo3mw3';
  static const _alphaSpiderUrlPrefix = 'xuvz1oj1sk';
  static const _productionSpiderUrlPrefix = 'coi5kvgypc';
  static const _alphaInboxUrlPrefix = 'opdhjaktnl';
  static const _productionInboxUrlPrefix = 'yfnamdpnc8';
  static const _host = 'execute-api.us-east-1.amazonaws.com';
  static const _alphaClientId = '_O2HQxYsVoDsohU2fZr_2_JTmn9TF84b9jgWzhSEB-g31UXoFP-85ANqYgiqh0Ij2wIxOKA5WC9sJvqxdprDpQ';
  static const _productionClientId = 'TInzy28y88KBDApICQJXfb4FyxiiqwQYb-cON0OV8eWVH-ilnKoSKBlcMFdTRSlbB-eyJkHOjUgDH8R2SAgoPw';

  UrlBuilder(this.isProduction);

  final ApiChannelSupplier isProduction;

  bool get _isProduction => isProduction();

  String get _channel => _isProduction ? 'production' : 'alpha';

  String get clientId => _isProduction
      ? _productionClientId
      : _alphaClientId;

  String _buildUrlBase(String prefix, [String? channel]) => 'https://$prefix.$_host/${channel ?? _channel}';

  String get _regularPrefix => _isProduction ? _productionUrlPrefix : _alphaUrlPrefix;
  String get _authPrefix => _isProduction ? _productionAuthUrlPrefix : _alphaAuthUrlPrefix;
  String get _moderationPrefix => _isProduction ? _productionModerationUrlPrefix : _alphaModerationUrlPrefix;
  String get _spiderPrefix => _isProduction ? _productionSpiderUrlPrefix : _alphaSpiderUrlPrefix;
  String get _inboxPrefix => _isProduction ? _productionInboxUrlPrefix : _alphaInboxUrlPrefix;

  String get _urlBase => _buildUrlBase(_regularPrefix);
  String get _authUrlBase => _buildUrlBase(_authPrefix);
  String get _moderationUrlBase => _buildUrlBase(_moderationPrefix);
  String get _spiderUrlBase => _buildUrlBase(_spiderPrefix, _isProduction ? 'production' : 'dev');
  String get _inboxUrlBase => _buildUrlBase(_inboxPrefix);

  String? cachedGuestTokenUrl;
  String guestTokenUrl(){
    final url = '$_authUrlBase/token/guest';
    cachedGuestTokenUrl = url;
    return url;
  }

  ///Used for comparison.
  String? cachedRefreshTokenUrl;

  ///Builds the URL for refreshing the access token.
  String refreshTokenUrl(String refreshToken)
  {
    final url =
        '$_authUrlBase/token/refresh'
        '?grant_type=refresh_token'
        '&refresh_token=$refreshToken'
        '&client_id=$clientId';

    cachedRefreshTokenUrl = url;
    return url;
  }

  String postDetailsUrl(String postId)
  {
    return '$_urlBase/post/id/$postId';
  }

  String _offsetEncoder(String? offset) =>
      offset!=null
          ? '?${offset.replaceAll('#', '%23')}'
          : '';

  String postCommentsUrl(String postId, [String? offset]){
    return '$_urlBase/comment/ref-on/post/$postId${_offsetEncoder(offset)}';
  }

  String forYouFeedUrl(String? offset)
  {
    return '$_urlBase/post/foryou${_offsetEncoder(offset)}';
  }

  String yourFeedUrl(String? offset)
  {
    return '$_inboxUrlBase/inbox/feed${_offsetEncoder(offset)}';
  }

  String profileFeedUrl(String profileSlug, [String? offset])
  {
    return '$_urlBase/post/ref-userprofile/posts/$profileSlug${_offsetEncoder(offset)}';
  }

  String subwikiFeedUrl(String subwikiSlug, [String? offset])
  {
    return '$_urlBase/post/ref-subwiki/$subwikiSlug${_offsetEncoder(offset)}';
  }

  String allProfilesFeedUrl(String? offset)
  {
    return '$_urlBase/post/profile${_offsetEncoder(offset)}';
  }

  String removedFeedUrl(String? offset)
  {
    return '$_urlBase/post/removed${_offsetEncoder(offset)}';
  }

  String signOutUrl() {
    return '$_authUrlBase/token/destroy?client_id=$clientId';
  }

  String appUserVotesUrl(){
    return '$_urlBase/votesgetmine';
  }

  String castUserVote(){
    return '$_urlBase/votecast';
  }

  String archiveUserVote(){
    return '$_moderationUrlBase/archiveuservote';
  }

  String archiveComment(){
    return '$_moderationUrlBase/archivecomment';
  }

  String restoreComment(){
    return '$_moderationUrlBase/restorecomment';
  }

  String createComment(){
    return '$_urlBase/comment';
  }

  String updateComment(){
    return '${createComment()}/update';
  }

  String archivePost(){
    return '$_moderationUrlBase/archivepost';
  }

  String restorePost(){
    return '$_moderationUrlBase/restorepost';
  }

  String getReaction(String sk){
    return '$_urlBase/getreactionbysk/${Uri.encodeComponent(sk)}';
  }

  String castReaction(){
    return '$_urlBase/reacttosomething';
  }

  String getTrust(String userSlug) {
    return '$_urlBase/reltrust/get/userprofile/$userSlug';
  }

  String castTrust() {
    return '$_urlBase/reltrust';
  }

  String getSpiderUrl(String targetUrl) {
    return '$_spiderUrlBase/getfetchoembed/${Uri.encodeComponent(targetUrl)}';
  }

  String createPost() {
    return '$_urlBase/post';
  }

  String updatePost() {
    return '${createPost()}/update';
  }

  String uploadsSignedUrl(){
    return '$_urlBase/media/getsignedurl';
  }

  String uploadsContent(String s3key){
    return 'https://wts2-$_channel-post-uploads.s3.amazonaws.com/$s3key';
  }

  String getSubwikis(String? offset)
  {
    return '$_urlBase/subwiki${_offsetEncoder(offset)}';
  }

  String updatePostBranch() {
    return '$_moderationUrlBase/updatepostbranch';
  }

  String movePostToUserProfile() {
    return '$_moderationUrlBase/movetouserprofile';
  }

  String getNotifications(String? offset)
  {
    return '$_inboxUrlBase/inbox/notifications${_offsetEncoder(offset)}';
  }

  String getUserprofile(String slug)
  {
    return '$_urlBase/userprofile/$slug';
  }

  String checkIsFollowingUser(String slug)
  {
    return '$_urlBase/relfollow/get/userprofile/$slug';
  }

  String getBranch(String slug)
  {
    return '$_urlBase/subwiki/$slug';
  }

  String checkIsFollowingBranch(String slug)
  {
    return '$_urlBase/relfollow/get/subwiki/$slug';
  }

  String createSubscription(){
    return '$_urlBase/relfollow';
  }

  String deleteUserSubscription(String slug)
  {
    return '$_urlBase/relfollow/delete/userprofile/$slug';
  }

  String deleteBranchSubscription(String slug)
  {
    return '$_urlBase/relfollow/delete/subwiki/$slug';
  }

  String getChanges(String date){
    return '$_urlBase/change/bymonth/$date';
  }

}
