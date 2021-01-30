declare var SwiftyIAP: PluginSwiftyIAP.SwiftyIAP

declare namespace PluginSwiftyIAP {

    type successHandler<T = any> = (result?: T) => any | (() => any)
    type errorHandler<K = any> = (error?: K) => any | (() => any)
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

        retriveProductsInfo(productIds: string[], success: successHandler<Product[]>, error: errorHandler): void

        purchaseProduct(productId: string, success: successHandler<{transactionIdentifier: string}>, error: errorHandler<PurchaseErrorResponse>): void

        fetchReceipt(forcedRefresh: boolean, success: successHandler<Receipt>, error: errorHandler): void

        restorePurchases(success: successHandler<RestoredProductIds>, error: errorHandler<FailedProductIds>): void
    }

}