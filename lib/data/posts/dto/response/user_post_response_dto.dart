class UserPostResponseDTO {
  final int? id;
  final String? name;
  final String? username;
  final String? email;
  final AddressDTO? address;
  final String? phone;
  final String? website;
  final CompanyDTO? company;

  UserPostResponseDTO({
    this.id,
    this.name,
    this.username,
    this.email,
    this.address,
    this.phone,
    this.website,
    this.company,
  });

  factory UserPostResponseDTO.fromMap(Map<String, dynamic> map) {
    return UserPostResponseDTO(
      id: map['id'],
      name: map['name'],
      username: map['username'],
      email: map['email'],
      address: map['address'] != null ? AddressDTO.fromMap(map['address']) : null,
      phone: map['phone'],
      website: map['website'],
      company: map['company'] != null ? CompanyDTO.fromMap(map['company']) : null,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'username': username,
      'email': email,
      'address': address?.toMap(),
      'phone': phone,
      'website': website,
      'company': company?.toMap(),
    };
  }
}

class AddressDTO {
  final String? street;
  final String? suite;
  final String? city;
  final String? zipcode;
  final GeoDTO? geo;

  AddressDTO({
    this.street,
    this.suite,
    this.city,
    this.zipcode,
    this.geo,
  });

  factory AddressDTO.fromMap(Map<String, dynamic> map) {
    return AddressDTO(
      street: map['street'],
      suite: map['suite'],
      city: map['city'],
      zipcode: map['zipcode'],
      geo: map['geo'] != null ? GeoDTO.fromMap(map['geo']) : null,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'street': street,
      'suite': suite,
      'city': city,
      'zipcode': zipcode,
      'geo': geo?.toMap(),
    };
  }
}

class GeoDTO {
  final String? lat;
  final String? lng;

  GeoDTO({this.lat, this.lng});

  factory GeoDTO.fromMap(Map<String, dynamic> map) {
    return GeoDTO(lat: map['lat'], lng: map['lng']);
  }

  Map<String, dynamic> toMap() {
    return {'lat': lat, 'lng': lng};
  }
}

class CompanyDTO {
  final String? name;
  final String? catchPhrase;
  final String? bs;

  CompanyDTO({this.name, this.catchPhrase, this.bs});

  factory CompanyDTO.fromMap(Map<String, dynamic> map) {
    return CompanyDTO(
      name: map['name'],
      catchPhrase: map['catchPhrase'],
      bs: map['bs'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'catchPhrase': catchPhrase,
      'bs': bs,
    };
  }
}