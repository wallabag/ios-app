var ExtensionClass = function() {};

ExtensionClass.prototype = {
    run: function(arguments) {
        arguments.completionFunction({
            "href": document.location.href
        });
    }
};

var ExtensionPreprocessingJS = new ExtensionClass;
