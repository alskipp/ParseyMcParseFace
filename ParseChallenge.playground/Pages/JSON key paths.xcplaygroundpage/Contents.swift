//: [Previous](@previous)
//: # JSON key paths
//: 

import Foundation

struct Person {
  let name: String
  let goldCoins: Int
}

//: We're only interested in parsing the `name` and `goldCoins` from the following JSON

let json: [String : AnyObject] = [
  "name" : "Gordon",
  "bag" : [
    "keys" : 2,
    "purse": [
      "stamps" : 5,
      "goldCoins" : 100
    ]
  ]
]

//: * * *

extension Person {
  init?(json: AnyObject) {
    guard let
      name = json["name"] as? String,
      bag = json["bag"] as? [String : AnyObject],
      purse = bag["purse"] as? [String : AnyObject],
      coins = purse["goldCoins"] as? Int
      else { return nil }

    self.name = name
    self.goldCoins = coins
  }
}

let person = Person(json: json)
print(person)



//: * * *

import Argo
import Curry

extension Person: Decodable {
  static func decode(j: JSON) -> Decoded<Person> {
    return curry(Person.init(name: goldCoins:))
      <^> j <| "name"
      <*> j <| ["bag", "purse", "goldCoins"] <|> pure(0)
  }
}

let decodedPerson: Decoded<Person> = decode(json)
print(decodedPerson)



//: * * *

import Unbox

extension Person: Unboxable {
  init(unboxer: Unboxer) {
    name = unboxer.unbox("name")
    goldCoins = unboxer.unbox("bag.purse.goldCoins")
  }
}

do {
  let unboxedPerson: Person = try Unbox(json)
  print(unboxedPerson)
}
catch let err {
  print(err)
}



//: * * *

import Mapper

extension Person: Mappable {
  init(map: Mapper) throws {
    try name = map.from("name")
    try goldCoins = map.from("bag.purse.goldCoins")
  }
}

do {
  let mappedPerson = try Person(map: Mapper(JSON: json))
  print(mappedPerson)
}
catch let err {
  print(err)
}

//: [Next](@next)
