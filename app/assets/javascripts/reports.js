//= require angular

var reportsApp = angular.module('reportsApp', []);

reportsApp.controller('ReportsController', function ($scope, $http) {
  $scope.availableReports = [
    {url: '/top_urls', name: 'Top URLs'},
    {url: '/top_referrers', name: 'Top referrers'}
  ]

  $scope.reportData = {};

  $scope.retrieveReport = function(reportUrl) {
    if(reportUrl.length > 0) {
      $http.get(reportUrl).success(function(data) {
        $scope.reportData = data;
      });
    }
  }

});
