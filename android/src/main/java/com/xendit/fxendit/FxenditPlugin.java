package com.xendit.fxendit;

import android.app.Activity;

import androidx.annotation.NonNull;

import com.xendit.AuthenticationCallback;
import com.xendit.Models.Address;
import com.xendit.Models.AuthenticatedToken;
import com.xendit.Models.Authentication;
import com.xendit.Models.BillingDetails;
import com.xendit.Models.Card;
import com.xendit.Models.CardInfo;
import com.xendit.Models.Customer;
import com.xendit.Models.Token;
import com.xendit.Models.XenditError;
import com.xendit.TokenCallback;
import com.xendit.Xendit;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import io.flutter.embedding.engine.plugins.FlutterPlugin;
import io.flutter.embedding.engine.plugins.activity.ActivityAware;
import io.flutter.embedding.engine.plugins.activity.ActivityPluginBinding;
import io.flutter.plugin.common.MethodCall;
import io.flutter.plugin.common.MethodChannel;
import io.flutter.plugin.common.MethodChannel.MethodCallHandler;
import io.flutter.plugin.common.MethodChannel.Result;

public class FxenditPlugin implements FlutterPlugin, MethodCallHandler, ActivityAware {

    private Xendit xendit;
    private Activity activity;
    private MethodChannel channel;

    @Override
    public void onAttachedToEngine(@NonNull FlutterPluginBinding flutterPluginBinding) {
        channel = new MethodChannel(flutterPluginBinding.getBinaryMessenger(), "fxendit");
        channel.setMethodCallHandler(this);
    }

    @Override
    public void onMethodCall(@NonNull MethodCall call, @NonNull Result result) {
        switch (call.method) {
            case "createSingleToken":
                createSingleToken(call, result);
                break;
            case "createMultiToken":
                createMultiToken(call, result);
                break;
            case "createAuthentication":
                createAuthentication(call, result);
                break;
            default:
                result.notImplemented();
                break;
        }
    }

    private void init(String publishedKey) {
        if (xendit == null && activity != null) {
            xendit = new Xendit(activity.getApplication().getApplicationContext(),
                publishedKey, activity);
        }
    }

    private void createSingleToken(@NonNull MethodCall call, @NonNull final Result result) {
        if (call.hasArgument("publishedKey")) {
            init(call.<String>argument("publishedKey"));
        }

        Integer _amount = call.argument("amount");
        Boolean _shouldAuthenticate = call.argument("shouldAuthenticate");

        Card card = cardFrom(call);
        int amount = _amount != null ? _amount : 0;
        boolean shouldAuthenticate = _shouldAuthenticate != null ? _shouldAuthenticate : true;
        String onBehalfOf = call.argument("onBehalfOf");
        BillingDetails billingDetails = billingFrom(call);
        Customer customer = customerFrom(call);
        String currency = call.hasArgument("currency")
            ? call.<String>argument("currency")
            : null;

        if (card != null) {
            xendit.createSingleUseToken(card, amount, shouldAuthenticate, onBehalfOf,
                billingDetails, customer, currency, new TokenCallback() {
                    @Override
                    public void onSuccess(Token token) {
                        result.success(tokenToMap(token));
                    }

                    @Override
                    public void onError(XenditError error) {
                        result.error(error.getErrorCode(), error.getErrorMessage(), error);
                    }
                });
        }
    }

    private void createMultiToken(@NonNull MethodCall call, @NonNull final Result result) {
        if (call.hasArgument("publishedKey")) {
            init(call.<String>argument("publishedKey"));
        }

        Card card = cardFrom(call);
        String onBehalfOf = call.argument("onBehalfOf");
        BillingDetails billingDetails = billingFrom(call);
        Customer customer = customerFrom(call);

        if (card != null) {
            xendit.createMultipleUseToken(card, onBehalfOf, billingDetails, customer, new TokenCallback() {
                @Override
                public void onSuccess(Token token) {
                    result.success(tokenToMap(token));
                }

                @Override
                public void onError(XenditError error) {
                    result.error(error.getErrorCode(), error.getErrorMessage(), error);
                }
            });
        }
    }

    private void createAuthentication(@NonNull MethodCall call, @NonNull final Result result) {
        if (call.hasArgument("publishedKey")) {
            init(call.<String>argument("publishedKey"));
        }

        String tokenId = call.argument("tokenId");
        Integer _amount = call.argument("amount");
        int amount = _amount != null ? _amount : 0;
        String currency = null;

        if (call.hasArgument("currency")) {
            currency = call.argument("currency");
        }

        xendit.createAuthentication(tokenId, amount, currency, new AuthenticationCallback() {
            @Override
            public void onSuccess(Authentication authentication) {
                result.success(authenticationToMap(authentication));
            }

            @Override
            public void onError(XenditError error) {
                result.error(error.getErrorCode(), error.getErrorMessage(), error);
            }
        });
    }

    private Card cardFrom(@NonNull MethodCall call) {
        if (call.hasArgument("card")) {
            Map<String, Object> map = call.argument("card");

            if (map != null) {
                String creditCardNumber = (String) map.get("creditCardNumber");
                String creditCardCVN = (String) map.get("creditCardCVN");
                String expirationMonth = (String) map.get("expirationMonth");
                String expirationYear = (String) map.get("expirationYear");
                return new Card(creditCardNumber, expirationMonth, expirationYear, creditCardCVN);
            }
        }

        return null;
    }

    private BillingDetails billingFrom(@NonNull MethodCall call) {
        if (call.hasArgument("billingDetails")) {
            BillingDetails billingDetails = new BillingDetails();
            Map<String, Object> map = call.argument("billingDetails");

            if (map != null) {
                billingDetails.setGivenNames((String) map.get("givenNames"));
                billingDetails.setSurname((String) map.get("surname"));
                billingDetails.setEmail((String) map.get("email"));
                billingDetails.setMobileNumber((String) map.get("mobileNumber"));
                billingDetails.setPhoneNumber((String) map.get("phoneNumber"));

                Map aMap = (Map) map.get("address");

                if (aMap != null) {
                    Address address = new Address();
                    address.setCountry((String) aMap.get("country"));
                    address.setStreetLine1((String) aMap.get("streetLine1"));
                    address.setStreetLine2((String) aMap.get("streetLine2"));
                    address.setCity((String) aMap.get("city"));
                    address.setProvinceState((String) aMap.get("provinceState"));
                    address.setPostalCode((String) aMap.get("postalCode"));
                    address.setCategory((String) aMap.get("category"));
                    billingDetails.setAddress(address);
                }
            }
            return billingDetails;
        }
        return null;
    }

    @SuppressWarnings("unchecked")
    private Customer customerFrom(@NonNull MethodCall call) {
        if (call.hasArgument("customer")) {
            Customer customer = new Customer();
            Map<String, Object> map = call.argument("customer");

            if (map != null) {
                customer.setReferenceId((String) map.get("referenceId"));
                customer.setEmail((String) map.get("email"));
                customer.setGivenNames((String) map.get("givenNames"));
                customer.setSurname((String) map.get("surname"));
                customer.setDescription((String) map.get("description"));
                customer.setMobileNumber((String) map.get("mobileNumber"));
                customer.setPhoneNumber((String) map.get("phoneNumber"));
                customer.setNationality((String) map.get("nationality"));
                customer.setDateOfBirth((String) map.get("dateOfBirth"));
                customer.setCardInfo((Map<String, String>) map.get("cardInfo"));

                if (map.containsKey("addresses")) {
                    List aList = (List) map.get("addresses");

                    if (aList != null && aList.size() > 0) {
                        int count = aList.size();
                        Address[] addresses = new Address[count];
                        for (int i = 0; i < count; i++) {
                            Map aMap = (Map) aList.get(i);

                            if (aMap != null) {
                                Address address = new Address();
                                address.setCountry((String) aMap.get("country"));
                                address.setStreetLine1((String) aMap.get("streetLine1"));
                                address.setStreetLine2((String) aMap.get("streetLine2"));
                                address.setCity((String) aMap.get("city"));
                                address.setProvinceState((String) aMap.get("provinceState"));
                                address.setPostalCode((String) aMap.get("postalCode"));
                                address.setCategory((String) aMap.get("category"));
                                addresses[i] = address;
                            }
                        }
                        customer.setAddresses(addresses);
                    }
                }
            }
            return customer;
        }
        return null;
    }

    private Map<String, Object> authenticationToMap(Authentication authentication) {
        Map<String, Object> result = new HashMap<>();
        if(authentication.getId() != null)
            result.put("id", authentication.getId());
        if(authentication.getCreditCardTokenId() != null)
            result.put("creditCardTokenId", authentication.getCreditCardTokenId());
        if(authentication.getPayerAuthenticationUrl() != null)
            result.put("payerAuthenticationUrl", authentication.getPayerAuthenticationUrl());
        if(authentication.getStatus() != null)
            result.put("status", authentication.getStatus());
        if(authentication.getMaskedCardNumber() != null)
            result.put("maskedCardNumber", authentication.getMaskedCardNumber());
        if(authentication.getRequestPayload() != null)
            result.put("requestPayload", authentication.getRequestPayload());
        if(authentication.getAuthenticationTransactionId() != null)
            result.put("authenticationTransactionId", authentication.getAuthenticationTransactionId());
        if(authentication.getCardInfo() != null)
            result.put("cardInfo", cardInfoToMap(authentication.getCardInfo()));
        return result;
    }

    @SuppressWarnings("deprecation")
    private Map<String, Object> tokenToMap(Token token) {
        Map<String, Object> result = new HashMap<>();
        if(token.getId() != null)
            result.put("id", token.getId());
        if(token.getStatus() != null)
            result.put("status", token.getStatus());
        if(token.getAuthenticationId() != null)
            result.put("authenticationId", token.getAuthenticationId());
        if(token.getMaskedCardNumber() != null)
            result.put("maskedCardNumber", token.getMaskedCardNumber());
        if(token.getShould_3DS() != null)
            result.put("should3ds", token.getShould_3DS());
        if(token.getAuthentication() != null)
            result.put("authentication", authenticatedTokenToMap(token.getAuthentication()));
        if(token.getCardInfo() != null)
            result.put("cardInfo", cardInfoToMap(token.getCardInfo()));
        return result;
    }

    private Map<String, Object> authenticatedTokenToMap(AuthenticatedToken authenticatedToken) {
        Map<String, Object> result = new HashMap<>();
        if(authenticatedToken.getId() != null)
            result.put("id", authenticatedToken.getId());
        if(authenticatedToken.getStatus() != null)
            result.put("status", authenticatedToken.getStatus());
        if(authenticatedToken.getAuthenticationId() != null)
            result.put("authenticationId", authenticatedToken.getAuthenticationId());
        if(authenticatedToken.getPayerAuthenticationUrl() != null)
            result.put("payerAuthenticationUrl", authenticatedToken.getPayerAuthenticationUrl());
        if(authenticatedToken.getMaskedCardNumber() != null)
            result.put("maskedCardNumber", authenticatedToken.getMaskedCardNumber());
        if(authenticatedToken.getJwt() != null)
            result.put("jwt", authenticatedToken.getJwt());
        if(authenticatedToken.getThreedsVersion() != null)
            result.put("threedsVersion", authenticatedToken.getThreedsVersion());
        if(authenticatedToken.getEnvironment() != null)
            result.put("environment", authenticatedToken.getEnvironment());
        if(authenticatedToken.getCardInfo() != null)
            result.put("cardInfo", cardInfoToMap(authenticatedToken.getCardInfo()));
        return result;
    }

    private Map<String, Object> cardInfoToMap(CardInfo cardInfo) {
        Map<String, Object> result = new HashMap<>();
        if(cardInfo.getBank() != null)
            result.put("bank", cardInfo.getBank());
        if(cardInfo.getCountry() != null)
            result.put("country", cardInfo.getCountry());
        if(cardInfo.getType() != null)
            result.put("type", cardInfo.getType());
        if(cardInfo.getBrand() != null)
            result.put("brand", cardInfo.getBrand());
        if(cardInfo.getCardArtUrl() != null)
            result.put("cardArtUrl", cardInfo.getCardArtUrl());
        if(cardInfo.getFingerprint() != null)
            result.put("fingerprint", cardInfo.getFingerprint());
        return result;
    }

    @Override
    public void onDetachedFromEngine(@NonNull FlutterPluginBinding binding) {
        channel.setMethodCallHandler(null);
    }


    @Override
    public void onAttachedToActivity(@NonNull ActivityPluginBinding binding) {
        activity = binding.getActivity();
    }

    @Override
    public void onDetachedFromActivityForConfigChanges() {

    }

    @Override
    public void onReattachedToActivityForConfigChanges(@NonNull ActivityPluginBinding binding) {

    }

    @Override
    public void onDetachedFromActivity() {

    }
}
