# SwiftyIAP

This is an iOS cordova plugin based on [SwiftyStoreKit](https://github.com/bizz84/SwiftyStoreKit) to manage in-app purchases


⚠️ This is quite a new plugin and it can do only basic tasks, we have not included all functionalities that **SwiftyStoreKit** has yet.

**✅️ Pull Requests and any kind of feedback are very much appreciated.**



# Installation
You can add the plugin by running the following command in your Cordova folder.

    cordova plugin add cordova-swifty-iap-plugin

# Basic Usage

```javascript
// completeTransactions must be run once after the app is started
SwiftyIAP.completeTransactions()

// Retrieving the product details from App Store
SwiftyIAP.retrieveProductsInfo(['com.example.productId'],products => console.log(products), error => console.log(error))

// Making a purchase
SwiftyIAP.purchaseProduct('com.example.productId', result => console.log(result), error => console.log(error)))

// Getting a receipt
SwiftyIAP.fetchReceipt(forced, result => console.log(result), error => console.log(error)))

// Restoring purchases
SwiftyIAP.restorePurchases(result => console.log(result), error => console.log(error)))
```

# Typescript Support
The type definitions are available within this package.
You can use them by simply installing the package in your typescript project.

```
npm install cordova-swifty-iap-plugin
```

After installing the package, you can use the types by adding a reference to them in your project

```typescript
// foo.ts

/// <reference types="cordova-swifty-iap-plugin" />


let products: CordovaPlugin.SwiftyIAP.Product[]
```
