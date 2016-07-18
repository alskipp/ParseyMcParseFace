//: [Previous](@previous)
//: # Intro - parsing a basic struct

import Foundation

struct Person {
  let name: String
  let goldCoins: Int
}

let json: [String : AnyObject] = [
  "name" : "Bob",
  "goldCoins": 23
]

//: * * *
//: ### JSON parsing without using a library

extension Person {
  init?(json: AnyObject) {
    guard let
      name = json["name"] as? String,
      coins = json["goldCoins"] as? Int
      else { return nil }
    
    self.name = name
    self.goldCoins = coins
  }
}

let person = Person(json: json)
print(person)


//: * * *
//: ### JSON parsing using a selection of libraries
//: * * *

//: https://github.com/thoughtbot/Argo
import Argo
import Curry

extension Person: Decodable {
  static func decode(j: JSON) -> Decoded<Person> {
    return curry(Person.init(name: goldCoins:))
      <^> j <| "name"
      <*> j <| "goldCoins"
  }
}

let decodedPerson: Decoded<Person> = decode(json)
print(decodedPerson)


//: * * *

//: https://github.com/JohnSundell/Unbox
import Unbox

extension Person: Unboxable {
  init(unboxer: Unboxer) {
    self.name = unboxer.unbox("name")
    self.goldCoins = unboxer.unbox("goldCoins")
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

//:https://github.com/lyft/mapper
import Mapper

extension Person: Mappable {
  init(map: Mapper) throws {
    try self.name = map.from("name")
    try self.goldCoins = map.from("goldCoins")
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
