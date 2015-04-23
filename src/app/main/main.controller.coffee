
angular.module('kyuMaruGram')
  .controller('MainCtrl', [
    '$scope'
    'api'
    'Items'
    'User'
    '$location'
    'Insta'
    ($scope, api, Items, User, $location, Insta) ->

      $scope.hasAccessTokenInUrl = () ->
        return $location.path().match(/\/access_token=/)

      $scope.init = ->

        if $scope.hasAccessTokenInUrl()
          accessToken = $location.path().split(/\/access_token=/)[1]
          User.setAccessToken(accessToken)
          
        if !User.getAccessToken()
          # 単体テスト対策
          if $location.absUrl() == 'http://server/'
            # 何もしない
          else if $location.absUrl() == 'http://localhost:3000/index.html?proctor=true#/'
            # 何もしない
          else
            location.href = "https://instagram.com/oauth/authorize/?client_id=#{Insta.clientId}&redirect_uri=#{Insta.redirectUrl}&response_type=token"
            return

        api.getSelfData().$promise.then((res) ->
          User.set(res.data)
          $scope.user = res.data
        )

        api.getKyumaruItems().$promise.then((res) ->
          Items.set(res.data)
          $scope.bricks = Items.get()
        )

      $scope.init()


  ])
