import Foundation
import SwiftyStoreKit


@objc(SwiftyIAP)
class SwiftyIAP: CDVPlugin {
    var commandCallback: String?
    var initialized = false
    
    @objc(completeTransactions:)
    func completeTransactions(_ command: CDVInvokedUrlCommand) {
        self.commandCallback = command.callbackId as String
        if !initialized {
            SwiftyStoreKit.completeTransactions(atomically: true) { _ in }
            self.initialized = true
            self.sendResult(.init(status: CDVCommandStatus_OK,
                            messageAs: "Ready"))
        }
    }
    
    @objc(retriveProductsInfo:)
    func retriveProductsInfo(_ command: CDVInvokedUrlCommand) {
        self.commandCallback = command.callbackId as String
        guard let productIds = command.arguments[0] as? [String] else {
            return self.sendResult(.init(status: CDVCommandStatus_ERROR, messageAs: "productId  not found"))
        }
        
        SwiftyStoreKit.retrieveProductsInfo(Set(productIds)) { result in
            if result.retrievedProducts.count > 0 {
                var products: [[AnyHashable: Any]] = []

                result.retrievedProducts.forEach { product in
                    
                    let productDetail: [AnyHashable: Any] =
                        [
                         "productId": product.productIdentifier,
                         "price": product.price.stringValue,
                         "localizedPrice": product.localizedPrice ?? ""
                        ]
                    products.append(productDetail)
                }
                self.sendResult(.init(status: CDVCommandStatus_OK, messageAs: products))
            }
            else if let invalidProductId = result.invalidProductIDs.first {
                return self.sendResult(.init(status: CDVCommandStatus_ERROR, messageAs: "Invalid product identifier: \(invalidProductId)"))

            }
            else {
                print("Error: \(String(describing: result.error))")
                return self.sendResult(.init(status: CDVCommandStatus_ERROR, messageAs: String(describing: result.error)))
            }
        }
    }
    
    @objc(purchaseProduct:)
    func purchaseProduct(_ command: CDVInvokedUrlCommand) {
        self.commandCallback = command.callbackId as String

        guard initialized == true else {
            self.sendResult(.init(status: CDVCommandStatus_ERROR, messageAs: "Please call completeTransaction first"))
            return
        }
        guard let productId = command.arguments[0] as? String else {
            return self.sendResult(.init(status: CDVCommandStatus_ERROR, messageAs: "productId  not found"))
        }
        
        SwiftyStoreKit.purchaseProduct(productId, quantity: 1, atomically: false) { result in
            switch result {
            case .success(let purchase):
                
                self.sendResult(.init(status: CDVCommandStatus_OK,
                                      messageAs: ["transactionIdentifier": purchase.transaction.transactionIdentifier ?? ""]))
            case .error(let error):
                var errorString = ""
                switch error.code {
                    case .unknown:
                        errorString = "unknown"
                    case .clientInvalid:
                        errorString = "clientInvalid"
                    case .paymentCancelled:
                        errorString = "paymentCancelled"
                    case .paymentInvalid:
                        errorString = "paymentInvalid"
                    case .paymentNotAllowed:
                        errorString = "paymentNotAllowed"
                    case .storeProductNotAvailable:
                        errorString = "storeProductNotAvailable"
                    case .cloudServicePermissionDenied:
                        errorString = "cloudServicePermissionDenied"
                    case .cloudServiceNetworkConnectionFailed:
                        errorString = "cloudServiceNetworkConnectionFailed"
                    case .cloudServiceRevoked:
                        errorString = "cloudServiceRevoked"
                    default:
                        errorString = (error as NSError).localizedDescription
                }
                
                self.sendResult(.init(status: CDVCommandStatus_ERROR, messageAs: errorString))

            }
        }
    }
    
    @objc(fetchReceipt:)
    func fetchReceipt(_ command: CDVInvokedUrlCommand) {
        let forceRefresh = command.arguments[0] as? Bool ?? false

        self.commandCallback = command.callbackId as String
        SwiftyStoreKit.fetchReceipt(forceRefresh: forceRefresh) { result in
            switch result {
            case .success(let data):
                let encryptedReceipt = data.base64EncodedString(options: [])
                self.sendResult(.init(status: CDVCommandStatus_OK, messageAs: encryptedReceipt))
            case .error(let error):
                self.sendResult(.init(status: CDVCommandStatus_ERROR, messageAs: error.localizedDescription))
            }
        }
    }
    
    @objc(restorePurchases:)
    func restorePurchases(_ command: CDVInvokedUrlCommand) {
        self.commandCallback = command.callbackId as String
        guard initialized == true else {
            self.sendResult(.init(status: CDVCommandStatus_ERROR,
                                  messageAs: "Please call `completeTransaction` first"))
            return
        }
        SwiftyStoreKit.restorePurchases(atomically: true) { results in
            if results.restoreFailedPurchases.count > 0 {
                var failedProducts: [[AnyHashable: Any]] = []
                results.restoreFailedPurchases.forEach { error, productId in
                    failedProducts.append(["error": error,"productId": productId ?? ""])
                }
                self.sendResult(.init(status: CDVCommandStatus_ERROR, messageAs: failedProducts))
            }
            else if results.restoredPurchases.count > 0 {
                var purchaseProductIds = Set<String>()
                results.restoredPurchases.forEach { product in
                    purchaseProductIds.insert(product.productId)
                }
                self.sendResult(.init(status: CDVCommandStatus_OK, messageAs: Array(purchaseProductIds)))
            }
        }
    }
}

private extension SwiftyIAP {
    func sendResult(_ result: CDVPluginResult) {
        self.commandDelegate.send(
            result,
            callbackId: commandCallback
        )
    }
}
