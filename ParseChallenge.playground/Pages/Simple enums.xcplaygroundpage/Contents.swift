//: [Previous](@previous)
//: # Simple enum parsing

import Foundation

enum Rank: String {
  case apprentice, veteran, jedi
}

struct Person {
  let name: String
  let goldCoins: Int
  let rank: Rank
}

let json: [String : AnyObject] = [
  "name" : "Bob",
  "goldCoins" : 9,
  "rank": "veteran"
]

//: Hint: use the `rawValue` init of the enum

extension Person {
  init?(json: AnyObject) {
    guard let
      name = json["name"] as? String,
      gold = json["goldCoins"] as? Int,
      rankString = json["rank"] as? String,
      rank = Rank(rawValue: rankString)
      else { return nil }
    
    self.name = name
    self.goldCoins = gold
    self.rank = rank
  }
}

let person = Person(json: json)
print(person)


//: * * *

import Argo
import Curry

extension Rank: Decodable {}

extension Person: Decodable {
  static func decode(j: JSON) -> Decoded<Person> {
    return curry(Person.init(name: goldCoins: rank:))
      <^> j <| "name"
      <*> j <| "goldCoins"
      <*> j <| "rank"
  }
}

let decodedPerson: Decoded<Person> = decode(json)
print(decodedPerson)


//: * * *

import Unbox

extension Rank: UnboxableEnum {
  static func unboxFallbackValue() -> Rank {
    return .apprentice
  }
}

extension Person: Unboxable {
  init(unboxer: Unboxer) {
    name = unboxer.unbox("name")
    goldCoins = unboxer.unbox("goldCoins")
    rank = unboxer.unbox("rank")
  }
}

do {
  let unboxedPerson: Person = try Unbox(json)
  print(unboxedPerson)
}
catch let err {
  print(err)
}


//: [Next](@next)
