import Flutter
import UIKit
import Xendit

public class SwiftFxenditPlugin: NSObject, FlutterPlugin {
  public static func register(with registrar: FlutterPluginRegistrar) {
    let channel = FlutterMethodChannel(name: "fxendit", binaryMessenger: registrar.messenger())
    let instance = SwiftFxenditPlugin()
    registrar.addMethodCallDelegate(instance, channel: channel)
  }

  public func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
    switch call.method {
      case "createSingleToken":
        createSingleOrMultiUseToken(call, result: result, isSingleUse: true)
        break;
      case "createMultiToken":
        createSingleOrMultiUseToken(call, result: result, isSingleUse: false)
      break;
      case "createAuthentication":
        createAuthentication(call, result: result)
        break;
      
      default:
          result(FlutterMethodNotImplemented);
          break;
      }
    }
    
    private func initXendit(publishedKey: String) {
        Xendit.publishableKey = publishedKey;
    }
    
    private func createSingleOrMultiUseToken(_ call: FlutterMethodCall, result: @escaping FlutterResult, isSingleUse : Bool) {
        if let myArgs = call.arguments as? [String: Any],
           let publishableKey = myArgs["publishedKey"] as? String,
           let currency = myArgs["currency"] as? String,
           let amount = myArgs["amount"] as? Int,
           let onBehalfOf = myArgs["onBehalfOf"] as? String,
           let shouldAuthenticate = myArgs["shouldAuthenticate"] as? Bool,
           let flutterAppDelegate = UIApplication.shared.delegate as? FlutterAppDelegate {
           initXendit(publishedKey: publishableKey)
            if  let creditCard = cardForm(call) {
                let tokenizationRequest = XenditTokenizationRequest.init(cardData: creditCard, isSingleUse: isSingleUse, shouldAuthenticate: shouldAuthenticate, amount: NSNumber.init(value: amount), currency: currency)
                 Xendit.createToken(fromViewController: flutterAppDelegate.window.rootViewController!, tokenizationRequest: tokenizationRequest, onBehalfOf: onBehalfOf) { (token, error) in
                     if let token = token {
                         result(self.tokenToMap(token: token))
                     } else {
                         result(FlutterError(code: "-1", message: "Failed get token", details: error!.message))
                    }
                 }
            } else {
                result(FlutterError(code: "-1", message: "Failed create credit card object", details: call.arguments))
            }
        } else {
            result(FlutterError(code: "-1", message: "Failed get arguments publishableKey", details: call.arguments))
        }
    }
    
    private func createAuthentication(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
        if let myArgs = call.arguments as? [String: Any],
           let publishableKey = myArgs["publishedKey"] as? String,
           let tokenId = myArgs["tokenId"] as? String,
           let amount = myArgs["amount"] as? Int,
           let currency = myArgs["currency"] as? String,
           let creditCardCVN = myArgs["creditCardCVN"] as? String,
           let flutterAppDelegate = UIApplication.shared.delegate as? FlutterAppDelegate {
           initXendit(publishedKey: publishableKey)
           let authenticationRequest = XenditAuthenticationRequest.init(tokenId: tokenId, amount: NSNumber.init(value: amount), currency: currency);
           if !creditCardCVN.isEmpty  {
                authenticationRequest.cardCvn = creditCardCVN
           }
            Xendit.createAuthentication(fromViewController: flutterAppDelegate.window.rootViewController!, authenticationRequest: authenticationRequest, onBehalfOf: nil) {(authentication, error) in
                if authentication != nil {
                    result(self.authenticationToMap(authentication: authentication!))
                } else {
                    result(FlutterError(code: "-1", message: "Failed create autheenticationr request ", details: error!.message))
                }
            }
        } else {
               result(FlutterError(code: "-1", message: "Failed get arguments publishableKey", details: call.arguments))
        }
    }
    
    private func cardForm(_ call: FlutterMethodCall) -> XenditCardData? {
        if let myArgs = call.arguments as? [String: Any],
           let creditCard = myArgs["card"] as? [String: Any],
           let creditCardCVN = creditCard["creditCardCVN"] as? String,
           let creditCardNumber = creditCard["creditCardNumber"] as? String,
           let expirationMonth = creditCard["expirationMonth"] as? String,
           let expirationYear = creditCard["expirationYear"] as? String {
           let cardData = XenditCardData.init(cardNumber: creditCardNumber, cardExpMonth: expirationMonth, cardExpYear: expirationYear)
            cardData.cardCvn = creditCardCVN
            return cardData
        } else {
            return nil
        }
    }
    
    private func tokenToMap(token : XenditCCToken) -> [String: Any] {
        var json: [String: Any] = [:]
        if token.id != nil { json["id"] = token.id }
        if token.status != nil { json["status"] = token.status }
        if token.authenticationId != nil { json["authenticationId"] = token.authenticationId }
        if token.authenticationURL != nil { json["authenticatedToken"] = token.authenticationURL }
        if token.maskedCardNumber != nil { json["maskedCardNumber"] = token.maskedCardNumber }
        if token.should3DS != nil { json["should3ds"] = token.should3DS }
        if token.cardInfo != nil { json["cardInfo"] = cardInfoToMap(cardInfo: token.cardInfo!)}
        if token.failureReason != nil { json["failureReason"] = token.failureReason }
        return json
    }
    
    
    
    private func cardInfoToMap(cardInfo : XenditCardMetadata) -> [String: Any]? {
       
        var json: [String: Any] = [:]
        if cardInfo.bank != nil { json["bank"] = cardInfo.bank }
        if cardInfo.country != nil { json["country"] = cardInfo.country }
        if cardInfo.type != nil { json["type"] = cardInfo.type }
        if cardInfo.brand != nil { json["brand"] = cardInfo.brand }
        if cardInfo.cardArtUrl != nil { json["cardArtUrl"] = cardInfo.cardArtUrl }
        if cardInfo.fingerprint != nil { json["fingerprint"] = cardInfo.fingerprint }
        if (json.isEmpty) {
            return nil
        } else {
            return json
        }
    }
    
    private func authenticationToMap(authentication : XenditAuthentication) -> [String : Any] {
        var json: [String: Any] = [:]
        if(authentication.id != nil) {json["id"] = authentication.id}
        if(authentication.tokenId != nil) {json["creditCardTokenId"] = authentication.tokenId}
        if(authentication.authenticationURL != nil) {json["payerAuthenticationUrl"] = authentication.authenticationURL}
        if(authentication.status != nil) {json["status"] = authentication.status}
        if(authentication.maskedCardNumber != nil) {json["maskedCardNumber"] = authentication.maskedCardNumber}
        if(authentication.cardInfo != nil) {json["cardInfo"] = cardInfoToMap(cardInfo: authentication.cardInfo!)}
        if(authentication.requestPayload != nil) {json["requestPayload"] = authentication.requestPayload}
        if(authentication.authenticationTransactionId != nil) {json["authenticationTransactionId"] = authentication.authenticationTransactionId}
        return json
    }
}
