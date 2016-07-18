//: [Previous](@previous)
//: # Dealing with missing fields in JSON

import Foundation

struct Person {
  let name: String
  let goldCoins: Int
}

let bankruptBobJSON: [String : AnyObject] = ["name" : "Bob"]
let wealthyWendyJSON: [String : AnyObject] = ["name" : "Wendy", "goldCoins": 100]

//: The `goldCoins` field is not always present, 
//: but we can give it a default value of 0 if missing.
//: Hint: the `??` operator will come in handy

//: * * *

extension Person {
  init?(json: AnyObject) {
    guard let
      name = json["name"] as? String
      else { return nil }
    
    self.name = name
    self.goldCoins = json["goldCoins"] as? Int ?? 0
  }
}

let bankruptBob = Person(json: bankruptBobJSON)
print(bankruptBob)

let wealthyWendy = Person(json: wealthyWendyJSON)
print(wealthyWendy)



//: * * *

import Argo
import Curry

extension Person: Decodable {
  static func decode(j: JSON) -> Decoded<Person> {
    return curry(Person.init(name: goldCoins:))
      <^> j <| "name"
      <*> j <| "goldCoins" <|> pure(0)
  }
}

let bancrupt: Decoded<Person> = decode(bankruptBobJSON)
print(bancrupt)

let wealthy: Decoded<Person> = decode(wealthyWendyJSON)
print(wealthy)



//: * * *

import Unbox

extension Person: Unboxable {
  init(unboxer: Unboxer) {
    name = unboxer.unbox("name")
    goldCoins = unboxer.unbox("goldCoins") ?? 0
  }
}

do {
  let unboxedBob: Person = try Unbox(bankruptBobJSON)
  let unboxedWendy: Person = try Unbox(wealthyWendyJSON)
  print(unboxedBob)
  print(unboxedWendy)
}
catch let err {
  print(err)
}



//: * * *

import Mapper

extension Person: Mappable {
  init(map: Mapper) throws {
    try name = map.from("name")
    goldCoins = map.optionalFrom("goldCoins") ?? 0
  }
}

do {
  let mappedBob = try Person(map: Mapper(JSON: bankruptBobJSON))
  let mappedWendy = try Person(map: Mapper(JSON: wealthyWendyJSON))
  print(mappedBob)
  print(mappedWendy)
}
catch let err {
  print(err)
}

//: [Next](@next)
