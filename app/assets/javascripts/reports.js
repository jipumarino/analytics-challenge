//= require angular

var reportsApp = angular.module('reportsApp', []);

reportsApp.controller('ReportsController', function ($scope) {
  $scope.availableReports = [
    {url: '/top_urls', name: 'Top URLs'},
    {url: '/top_referrers', name: 'Top referrers'}
  ]

});
