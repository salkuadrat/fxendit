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
        createSingleToken(call, result: result)
          break;
      default:
          result(FlutterMethodNotImplemented);
          break;
      }
    }
    
    private func initXendit(publishedKey: String) {
        Xendit.publishableKey = publishedKey;
    }
    
    private func createSingleToken(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
        if let myArgs = call.arguments as? [String: Any],
           let publishableKey = myArgs["publishedKey"] as? String,
           let currency = myArgs["currency"] as? String,
           let amount = myArgs["amount"] as? Int,
           let onBehalfOf = myArgs["onBehalfOf"] as? String,
           let flutterAppDelegate = UIApplication.shared.delegate as? FlutterAppDelegate {
           initXendit(publishedKey: publishableKey)
           let creditCard = cardForm(call)
           let tokenizationRequest = XenditTokenizationRequest.init(cardData: creditCard!, isSingleUse: true, shouldAuthenticate: true, amount: NSNumber.init(value: amount), currency: currency)

            
            var json: [String: Any] = [:]
            Xendit.createToken(fromViewController: flutterAppDelegate.window.rootViewController!, tokenizationRequest: tokenizationRequest, onBehalfOf: onBehalfOf) { (token, error) in
                if let token = token {
                    json = self.tokenToMap(token: token)
                    print(json)
                    result(json)
                } else {
                    result(FlutterError(code: "-1", message: "Failed get token", details: error!.message))
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
        json["dum"] = "DUMMM"
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
    
    
    
    private func cardInfoToMap(cardInfo : XenditCardMetadata) -> [String: Any] {
        var json: [String: Any] = [:]
        if cardInfo.bank != nil { json["bank"] = cardInfo.bank }
        if cardInfo.country != nil { json["country"] = cardInfo.country }
        if cardInfo.type != nil { json["type"] = cardInfo.type }
        if cardInfo.brand != nil { json["brand"] = cardInfo.brand }
        if cardInfo.cardArtUrl != nil { json["cardArtUrl"] = cardInfo.cardArtUrl }
        if cardInfo.fingerprint != nil { json["fingerprint"] = cardInfo.fingerprint }
        return json
    }
}
