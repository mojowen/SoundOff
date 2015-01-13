var myApp = angular.module('myApp',[]);

myApp.directive('fallbackSrc', function () {
    var fallbackSrc = {
        link: function postLink(scope, iElement, iAttrs) {
            iElement.bind('error', function() {
                angular.element(this).attr("src", iAttrs.fallbackSrc);
                scope.item.log = iAttrs.fallbackSrc;
            });
        }
    }
    return fallbackSrc;
});
