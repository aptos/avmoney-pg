var avmoneyDirectives = angular.module('avmoneyDirectives');

avmoneyDirectives.directive('projects', function(){
  return {
    restrict:'A',
    templateUrl:'assets/reports/projects.html'
  };
});

avmoneyDirectives.directive('accountsReceivable', function(){
  return {
    restrict:'A',
    templateUrl:'assets/reports/accounts_receivable.html'
  };
});

avmoneyDirectives.directive('payments', function(){
  return {
    restrict:'A',
    templateUrl:'assets/reports/payments.html'
  };
});

avmoneyDirectives.directive('cashflow', function(){
  return {
    restrict:'A',
    templateUrl:'assets/reports/cashflow.html'
  };
});

avmoneyDirectives.directive('clientEdit', function(){
  return {
    restrict:'A',
    templateUrl:'assets/clients/edit.html'
  };
});

avmoneyDirectives.directive('clientShow', function(){
  return {
    restrict:'A',
    templateUrl:'assets/clients/show.html'
  };
});

avmoneyDirectives.directive('draggable', function() {
  return {
    restrict: 'A',
    link: function(scope, elm, attrs) {
      var options = scope.$eval(attrs.avDraggable); //allow options to be passed in
      elm.draggable(options);
    }
  };
});

avmoneyDirectives.directive('myDatepicker', function () {
  return {
    restrict:'A',
    require:'ngModel',
    link:function (scope, element, attrs, ngModel) {
      var minDateObject = new Date();
      if (attrs.minDate) {
        var day = moment(attrs.minDate, "YYYY-MM-DD");
        minDateObject = day.toDate();
      }
      element.datepicker({
        showOn:"both",
        buttonText:"<i class='fa fa-calendar'></i>",
        changeYear:true,
        changeMonth:true,
        dateFormat:'yy-mm-dd',
        minDate:minDateObject,
        onSelect:function (dateText, inst) {
          ngModel.$setViewValue(dateText);
          scope.edit_date = false;
          scope.$apply();
        }
      });
      if (attrs.maxDate) {
        var day = moment(attrs.maxDate, "YYYY-MM-DD");
        element.datepicker("option", "maxDate", day.toDate());
      }
      attrs.$observe('minDate', function (value) {
        if (!value) {
          return;
        }
        minDateObject = moment(value, "YYYY-MM-DD").toDate();
        element.datepicker("option", "minDate", minDateObject);
      });
    }
  };
});

avmoneyDirectives.directive('contenteditable', function () {
  return {
  restrict: 'A', // only activate on element attribute
  require: '?ngModel', // get a hold of NgModelController
  link: function (scope, element, attrs, ngModel) {
      if (!ngModel) return; // do nothing if no ng-model
      var placeholder = (attrs.placeholder) ? attrs.placeholder : '';
      ngModel.$render = function () {
        element.html(ngModel.$viewValue || placeholder);
      };

      element.on('blur keyup change', function () {
        scope.$apply(readViewText);
      });

      element.on('mouseleave mouseout', function () {
        if (element.html() === '') {
          html = placeholder;
          element.html(html);
        }
      });

      function readViewText() {
        var html = element.html();
        if (attrs.stripBr && html == '<br>') {
          html = '';
        }

        ngModel.$setViewValue(html);
      }
    }
  };
});

var FLOAT_REGEXP = /^\-?\d+((\.)\d+)?$/;
avmoneyDirectives.directive('smartFloat', function() {
  return {
    require: 'ngModel',
    link: function(scope, elm, attrs, ctrl) {
      ctrl.$parsers.unshift(function(viewValue) {
        if (!angular.isDefined(viewValue) || viewValue.length === 0) {
          ctrl.$setValidity('float', true);
          return viewValue;
        } else if (FLOAT_REGEXP.test(viewValue)) {
          ctrl.$setValidity('float', true);
          return viewValue;
        } else {
          ctrl.$setValidity('float', false);
          return undefined;
        }
      });
    }
  };
});

// test unique property name against compare-group attribute, where the group *includes* the model being updated
// uses unique rather than searching for indexOf because the array has already been updated with the model value
avmoneyDirectives.directive('uniqueName', function() {
  return {
    restrict: 'A',
    require: 'ngModel',
    link: function (scope, element, attrs, ngModel) {

      function validate(value) {
        var compareGroup = scope.$eval(attrs.compareGroup);
        if (compareGroup && _.unique(compareGroup).length == compareGroup.length) {
          ngModel.$setValidity('unique', true);
        } else {
          ngModel.$setValidity('unique', false);
        }
      }

      scope.$watch( function() {
        return ngModel.$viewValue;
      }, validate);
    }
  };
});
