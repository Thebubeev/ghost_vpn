class YokassaPayment {
  String? id;
  String? status;
  bool? paid;
  Amount? amount;
  Confirmation? confirmation;
  String? createdAt;
  String? description;
  Metadata? metadata;
  PaymentMethodData? paymentMethod;
  Recipient? recipient;
  bool? refundable;
  bool? test;

  YokassaPayment(
      {this.id,
      this.status,
      this.paid,
      this.amount,
      this.confirmation,
      this.createdAt,
      this.description,
      this.metadata,
      this.paymentMethod,
      this.recipient,
      this.refundable,
      this.test});

  YokassaPayment.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    status = json['status'];
    paid = json['paid'];
    amount =
        json['amount'] != null ? new Amount.fromJson(json['amount']) : null;
    confirmation = json['confirmation'] != null
        ? new Confirmation.fromJson(json['confirmation'])
        : null;
    createdAt = json['created_at'];
    description = json['description'];
    metadata = json['metadata'] != null
        ? new Metadata.fromJson(json['metadata'])
        : null;
    paymentMethod = json['payment_method'] != null
        ? new PaymentMethodData.fromJson(json['payment_method'])
        : null;
    recipient = json['recipient'] != null
        ? new Recipient.fromJson(json['recipient'])
        : null;
    refundable = json['refundable'];
    test = json['test'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['status'] = this.status;
    data['paid'] = this.paid;
    if (this.amount != null) {
      data['amount'] = this.amount!.toJson();
    }
    if (this.confirmation != null) {
      data['confirmation'] = this.confirmation!.toJson();
    }
    data['created_at'] = this.createdAt;
    data['description'] = this.description;
    if (this.metadata != null) {
      data['metadata'] = this.metadata!.toJson();
    }
    if (this.paymentMethod != null) {
      data['payment_method'] = this.paymentMethod!.toJson();
    }
    if (this.recipient != null) {
      data['recipient'] = this.recipient!.toJson();
    }
    data['refundable'] = this.refundable;
    data['test'] = this.test;
    return data;
  }
}

class Amount {
  String? value;
  String? currency;

  Amount({this.value, this.currency});

  Amount.fromJson(Map<String, dynamic> json) {
    value = json['value'];
    currency = json['currency'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['value'] = this.value;
    data['currency'] = this.currency;
    return data;
  }
}

class Confirmation {
  String? type;
  String? returnUrl;
  String? confirmationUrl;

  Confirmation({this.type, this.returnUrl, this.confirmationUrl});

  Confirmation.fromJson(Map<String, dynamic> json) {
    type = json['type'];
    returnUrl = json['return_url'];
    confirmationUrl = json['confirmation_url'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['type'] = this.type;
    data['return_url'] = this.returnUrl;
    data['confirmation_url'] = this.confirmationUrl;
    return data;
  }
}

class Metadata {
  Metadata();

  Metadata.fromJson(Map<String, dynamic> json) {}

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    return data;
  }
}

class PaymentMethodData {
  String? type;
  String? id;
  bool? saved;

  PaymentMethodData({this.type, this.id, this.saved});

  PaymentMethodData.fromJson(Map<String, dynamic> json) {
    type = json['type'];
    id = json['id'];
    saved = json['saved'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['type'] = this.type;
    data['id'] = this.id;
    data['saved'] = this.saved;
    return data;
  }
}

class Recipient {
  String? accountId;
  String? gatewayId;

  Recipient({this.accountId, this.gatewayId});

  Recipient.fromJson(Map<String, dynamic> json) {
    accountId = json['account_id'];
    gatewayId = json['gateway_id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['account_id'] = this.accountId;
    data['gateway_id'] = this.gatewayId;
    return data;
  }
}
