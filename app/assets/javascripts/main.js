(function() {
  var app = angular.module('grioParser', []);

  app.controller('appController', ['$scope', '$http', function($scope, $http){

      $scope.title = "Grio Custom Parser";
      $scope.input = "";
      $scope.parsedInputs = [];

      $scope.updateInput = function(input) {
        $scope.input = input;
      };

      $scope.submitInput = function() {
        postInput($scope.input);
        $scope.input = "";
      };

      function setParsedTexts() {
        $http.get('./texts.json').success( function(data) {
          $scope.parsedInputs = data;
        });
      }

      function postInput(text) {
        $http.post('./texts.json', {"post": text}).success(function(data){
          console.log(data);
        });
        setParsedTexts();
      }

      setParsedTexts();

    }]);
})();
