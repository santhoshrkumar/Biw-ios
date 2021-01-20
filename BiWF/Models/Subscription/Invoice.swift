//
//  Invoice.swift
//  BiWF
//
//  Created by Aditi.A.Gandhi on 12/05/20.
//  Copyright © 2020 Digital Products. All rights reserved.
//

struct Invoice: Codable {
    let id: String
    let paymentName: String?
    let planName: String?
    let planPrice: String?
    let salesTaxAmount: Float?
    let totalCost: Float?
    let processedDate: String?
    var billingAddress: String?
    var email: String?
    let promoCode: String?
    let promoCodeValue: Double?
    let promoCodeDescription: String?
    
    enum CodingKeys: String, CodingKey {
        case id = "Id"
        case paymentName = "Zuora__PaymentMethod__c"
        case planName = "Product_Plan_Name__c"
        case planPrice = "ZAmountWithoutTax__c"
        case salesTaxAmount = "Sales_Tax__c"
        case totalCost = "Zuora__Amount__c"
        case processedDate = "CreatedDate"
        case billingAddress = "Billing_Address"
        case email = "Email"
        case promoCode = "Promo_Code__c"
        case promoCodeValue = "Promo_Discount_Amount__c"
        case promoCodeDescription = "Promo_Description__c"
    }

    func getProcessedDate() -> String {
        guard let dateString = processedDate,
            let formatedDate = dateString.formattedDateFromString(dateString: dateString, withFormat: Constants.DateFormat.MMddyyyy)  else { return "" }
        return formatedDate
    }
}
