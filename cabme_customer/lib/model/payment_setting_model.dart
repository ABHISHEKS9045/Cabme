class PaymentSettingModel {
  String? success;
  String? error;
  String? message;
  Strip? strip;
  Cash? cash;
  PayFast? payFast;
  Cash? myWallet;
  PayStack? payStack;
  FlutterWave? flutterWave;
  RazorPay? razorPay;
  Paytm? paytm;
  PayPal? payPal;
  Mercadopago? mercadopago;
  Tax? tax;

  PaymentSettingModel(
      {this.success,
      this.error,
      this.message,
      this.strip,
      this.cash,
      this.payFast,
      this.myWallet,
      this.payStack,
      this.flutterWave,
      this.razorPay,
      this.paytm,
      this.payPal,
      this.mercadopago,
      this.tax});

  PaymentSettingModel.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    error = json['error'];
    message = json['message'];
    strip = json['Strip'] != null ? Strip.fromJson(json['Strip']) : null;
    cash = json['Cash'] != null ? Cash.fromJson(json['Cash']) : null;
    payFast =
        json['PayFast'] != null ? PayFast.fromJson(json['PayFast']) : null;
    myWallet =
        json['My Wallet'] != null ? Cash.fromJson(json['My Wallet']) : null;
    payStack =
        json['PayStack'] != null ? PayStack.fromJson(json['PayStack']) : null;
    flutterWave = json['FlutterWave'] != null
        ? FlutterWave.fromJson(json['FlutterWave'])
        : null;
    razorPay =
        json['Razorpay'] != null ? RazorPay.fromJson(json['Razorpay']) : null;
    mercadopago = json['Mercadopago'] != null
        ? Mercadopago.fromJson(json['Mercadopago'])
        : null;
    paytm = json['Paytm'] != null ? Paytm.fromJson(json['Paytm']) : null;
    payPal = json['PayPal'] != null ? PayPal.fromJson(json['PayPal']) : null;
    tax = json['tax'] != null ? Tax.fromJson(json['tax']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['success'] = success;
    data['error'] = error;
    data['message'] = message;
    if (strip != null) {
      data['Strip'] = strip!.toJson();
    }
    if (cash != null) {
      data['Cash'] = cash!.toJson();
    }
    if (payFast != null) {
      data['PayFast'] = payFast!.toJson();
    }
    if (myWallet != null) {
      data['My Wallet'] = myWallet!.toJson();
    }
    if (payStack != null) {
      data['PayStack'] = payStack!.toJson();
    }
    if (flutterWave != null) {
      data['FlutterWave'] = flutterWave!.toJson();
    }
    if (razorPay != null) {
      data['RezorPay'] = razorPay!.toJson();
    }
    if (mercadopago != null) {
      data['Mercadopago'] = mercadopago!.toJson();
    }
    if (paytm != null) {
      data['Paytm'] = paytm!.toJson();
    }
    if (payPal != null) {
      data['PayPal'] = payPal!.toJson();
    }
    if (tax != null) {
      data['tax'] = tax!.toJson();
    }
    return data;
  }
}

class Strip {
  int? id;
  String? key;
  String? clientpublishableKey;
  String? secretKey;
  String? isEnabled;
  String? isSandboxEnabled;
  int? idPaymentMethod;
  String? libelle;

  Strip(
      {this.id,
      this.key,
      this.clientpublishableKey,
      this.secretKey,
      this.isEnabled,
      this.isSandboxEnabled,
      this.idPaymentMethod,
      this.libelle});

  Strip.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    key = json['key'];
    clientpublishableKey = json['clientpublishableKey'];
    secretKey = json['secret_key'];
    isEnabled = json['isEnabled'];
    isSandboxEnabled = json['isSandboxEnabled'];
    idPaymentMethod = json['id_payment_method'];
    libelle = json['libelle'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['key'] = key;
    data['clientpublishableKey'] = clientpublishableKey;
    data['secret_key'] = secretKey;
    data['isEnabled'] = isEnabled;
    data['isSandboxEnabled'] = isSandboxEnabled;
    data['id_payment_method'] = idPaymentMethod;
    data['libelle'] = libelle;
    return data;
  }
}

class Cash {
  int? id;
  String? isEnabled;
  String? libelle;
  int? idPaymentMethod;

  Cash({this.id, this.isEnabled, this.idPaymentMethod, this.libelle});

  Cash.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    isEnabled = json['isEnabled'];
    libelle = json['libelle'];
    idPaymentMethod = json['id_payment_method'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['isEnabled'] = isEnabled;
    data['libelle'] = libelle;
    data['id_payment_method'] = idPaymentMethod;
    return data;
  }
}

class PayFast {
  int? id;
  String? merchantId;
  String? merchantKey;
  String? cancelUrl;
  String? notifyUrl;
  String? returnUrl;
  String? isEnabled;
  String? isSandboxEnabled;
  int? idPaymentMethod;
  String? libelle;

  PayFast(
      {this.id,
      this.merchantId,
      this.merchantKey,
      this.cancelUrl,
      this.notifyUrl,
      this.returnUrl,
      this.isEnabled,
      this.isSandboxEnabled,
      this.idPaymentMethod,
      this.libelle});

  PayFast.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    merchantId = json['merchant_Id'];
    merchantKey = json['merchant_key'];
    cancelUrl = json['cancel_url'];
    notifyUrl = json['notify_url'];
    returnUrl = json['return_url'];
    isEnabled = json['isEnabled'];
    isSandboxEnabled = json['isSandboxEnabled'];
    idPaymentMethod = json['id_payment_method'];
    libelle = json['libelle'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['merchant_Id'] = merchantId;
    data['merchant_key'] = merchantKey;
    data['cancel_url'] = cancelUrl;
    data['notify_url'] = notifyUrl;
    data['return_url'] = returnUrl;
    data['isEnabled'] = isEnabled;
    data['isSandboxEnabled'] = isSandboxEnabled;
    data['id_payment_method'] = idPaymentMethod;
    data['libelle'] = libelle;
    return data;
  }
}

class PayStack {
  int? id;
  String? secretKey;
  String? publicKey;
  String? callbackUrl;
  String? isEnabled;
  String? isSandboxEnabled;
  int? idPaymentMethod;
  String? libelle;

  PayStack(
      {this.id,
      this.secretKey,
      this.publicKey,
      this.callbackUrl,
      this.isEnabled,
      this.isSandboxEnabled,
      this.idPaymentMethod,
      this.libelle});

  PayStack.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    secretKey = json['secret_key'];
    publicKey = json['public_key'];
    callbackUrl = json['callback_url'];
    isEnabled = json['isEnabled'];
    isSandboxEnabled = json['isSandboxEnabled'];
    idPaymentMethod = json['id_payment_method'];
    libelle = json['libelle'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['secret_key'] = secretKey;
    data['public_key'] = publicKey;
    data['callback_url'] = callbackUrl;
    data['isEnabled'] = isEnabled;
    data['isSandboxEnabled'] = isSandboxEnabled;
    data['id_payment_method'] = idPaymentMethod;
    data['libelle'] = libelle;
    return data;
  }
}

class FlutterWave {
  int? id;
  String? secretKey;
  String? publicKey;
  String? encryptionKey;
  String? isEnabled;
  String? isSandboxEnabled;
  int? idPaymentMethod;
  String? libelle;

  FlutterWave(
      {this.id,
      this.secretKey,
      this.publicKey,
      this.encryptionKey,
      this.isEnabled,
      this.isSandboxEnabled,
      this.idPaymentMethod,
      this.libelle});

  FlutterWave.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    secretKey = json['secret_key'];
    publicKey = json['public_key'];
    encryptionKey = json['encryption_key'];
    isEnabled = json['isEnabled'];
    isSandboxEnabled = json['isSandboxEnabled'];
    idPaymentMethod = json['id_payment_method'];
    libelle = json['libelle'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['secret_key'] = secretKey;
    data['public_key'] = publicKey;
    data['encryption_key'] = encryptionKey;
    data['isEnabled'] = isEnabled;
    data['isSandboxEnabled'] = isSandboxEnabled;
    data['id_payment_method'] = idPaymentMethod;
    data['libelle'] = libelle;
    return data;
  }
}

class Mercadopago {
  int? id;
  String? publicKey;
  String? accesstoken;
  String? isEnabled;
  String? isSandboxEnabled;
  int? idPaymentMethod;
  String? libelle;

  Mercadopago(
      {this.id,
      this.publicKey,
      this.accesstoken,
      this.isEnabled,
      this.isSandboxEnabled,
      this.idPaymentMethod,
      this.libelle});

  Mercadopago.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    publicKey = json['public_key'];
    accesstoken = json['accesstoken'];
    isEnabled = json['isEnabled'];
    isSandboxEnabled = json['isSandboxEnabled'];
    idPaymentMethod = json['id_payment_method'];
    libelle = json['libelle'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['public_key'] = publicKey;
    data['accesstoken'] = accesstoken;
    data['isEnabled'] = isEnabled;
    data['isSandboxEnabled'] = isSandboxEnabled;
    data['id_payment_method'] = idPaymentMethod;
    data['libelle'] = libelle;
    return data;
  }
}

class RazorPay {
  int? id;
  String? key;
  String? secretKey;
  String? isEnabled;
  String? isSandboxEnabled;
  int? idPaymentMethod;
  String? libelle;

  RazorPay(
      {this.id,
      this.key,
      this.secretKey,
      this.isEnabled,
      this.isSandboxEnabled,
      this.idPaymentMethod,
      this.libelle});

  RazorPay.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    key = json['key'];
    secretKey = json['secret_key'];
    isEnabled = json.containsKey("isEnabled") ? json['isEnabled'] : "false";
    isSandboxEnabled = json['isSandboxEnabled'];
    idPaymentMethod = json['id_payment_method'];
    libelle = json['libelle'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['key'] = key;
    data['secret_key'] = secretKey;
    data['isEnabled'] = isEnabled;
    data['isSandboxEnabled'] = isSandboxEnabled;
    data['id_payment_method'] = idPaymentMethod;
    data['libelle'] = libelle;
    return data;
  }
}

class Paytm {
  int? id;
  String? merchantId;
  String? merchantKey;
  String? isEnabled;
  String? isSandboxEnabled;
  int? idPaymentMethod;
  String? libelle;

  Paytm(
      {this.id,
      this.merchantId,
      this.merchantKey,
      this.isEnabled,
      this.isSandboxEnabled,
      this.idPaymentMethod,
      this.libelle});

  Paytm.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    merchantId = json['merchant_Id'];
    merchantKey = json['merchant_key'];
    isEnabled = json['isEnabled'];
    isSandboxEnabled = json['isSandboxEnabled'];
    idPaymentMethod = json['id_payment_method'];
    libelle = json['libelle'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['merchant_Id'] = merchantId;
    data['merchant_key'] = merchantKey;
    data['isEnabled'] = isEnabled;
    data['isSandboxEnabled'] = isSandboxEnabled;
    data['id_payment_method'] = idPaymentMethod;
    data['libelle'] = libelle;
    return data;
  }
}

class PayPal {
  int? id;
  String? appId;
  String? secretKey;
  String? merchantId;
  String? privateKey;
  String? publicKey;
  String? tokenizationKey;
  String? isEnabled;
  String? isLive;
  int? idPaymentMethod;
  String? username;
  String? password;
  String? libelle;

  PayPal(
      {this.id,
      this.appId,
      this.secretKey,
      this.merchantId,
      this.privateKey,
      this.publicKey,
      this.tokenizationKey,
      this.isEnabled,
      this.isLive,
      this.idPaymentMethod,
      this.username,
      this.password,
      this.libelle});

  PayPal.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    appId = json['app_id'];
    secretKey = json['secret_key'];
    merchantId = json['merchant_Id'];
    privateKey = json['private_key'];
    publicKey = json['public_key'];
    tokenizationKey = json['tokenization_key'];
    isEnabled = json['isEnabled'];
    isLive = json['isLive'];
    idPaymentMethod = json['id_payment_method'];
    username = json['username'];
    password = json['password'];
    libelle = json['libelle'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['app_id'] = appId;
    data['secret_key'] = secretKey;
    data['merchant_Id'] = merchantId;
    data['private_key'] = privateKey;
    data['public_key'] = publicKey;
    data['tokenization_key'] = tokenizationKey;
    data['isEnabled'] = isEnabled;
    data['isLive'] = isLive;
    data['id_payment_method'] = idPaymentMethod;
    data['username'] = username;
    data['password'] = password;
    data['libelle'] = libelle;
    return data;
  }
}

class Tax {
  int? id;
  String? name;
  String? taxType;
  String? taxAmount;

  Tax({this.id, this.taxType, this.taxAmount,this.name});

  Tax.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    id = json['id'];
    taxType = json['tax_type'];
    taxAmount = json['tax_amount'] ?? "0";
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['name'] = name;
    data['id'] = id;
    data['tax_type'] = taxType;
    data['tax_amount'] = taxAmount;
    return data;
  }
}
