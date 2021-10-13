declare var SwiftyIAP: CordovaPlugin.SwiftyIAP

declare namespace CordovaPlugin {

    type successHandler<T = any> = (result: T) => any | (() => any)
    type errorHandler<K = any> = (error?: K) => any
    type Receipt = string; // base64 encoded receipt

    type Product = {
        productId: string;
        price: string;
        localizedPrice: string;
    }


    type PurchaseErrorCodes = "unknown" |
                              "clientInvalid" |
                              "paymentCancelled" |
                              "paymentInvalid" |
                              "paymentNotAllowed" |
                              "storeProductNotAvailable" |
                              "cloudServicePermissionDenied" |
                              "cloudServiceNetworkConnectionFailed"

    type PurchaseErrorResponse = {
        errorCode: PurchaseErrorCodes | string
    } | string

    type RestoredProductIds = string[]
    type FailedProductIds = string[]

    interface SwiftyIAP {
        completeTransactions(successHandler: successHandler): void

        retrieveProductsInfo(productIds: string[], success: successHandler<Product[]>, error: errorHandler): void

        purchaseProduct(productId: string, success: successHandler<{transactionIdentifier: string, originalTransactionId: string}>, error: errorHandler<PurchaseErrorResponse>): void

        fetchReceipt(forcedRefresh: boolean, success: successHandler<Receipt>, error: errorHandler): void

        restorePurchases(success: successHandler<RestoredProductIds>, error: errorHandler<FailedProductIds>): void
    }

}