var exec = require('cordova/exec');

exports.completeTransactions = function (success, error) {
    exec(success, error, 'SwiftyIAP', 'completeTransactions', []);
};

exports.retrieveProductsInfo = function (arg0, success, error) {
    exec(success, error, 'SwiftyIAP', 'retrieveProductsInfo', [arg0]);
};

exports.fetchReceipt = function (arg0, success, error) {
    exec(success, error, 'SwiftyIAP', 'fetchReceipt', [arg0]);
};

exports.purchaseProduct = function (arg0, success, error) {
    exec(success, error, 'SwiftyIAP', 'purchaseProduct', [arg0]);
};

exports.restorePurchases = function (success, error) {
    exec(success, error, 'SwiftyIAP', 'restorePurchases', []);
};

