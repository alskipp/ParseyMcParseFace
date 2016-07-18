//: [Previous](@previous)

import Foundation

enum Rank: String {
  case apprentice, veteran, jedi
}

enum Weapon: String {
  case pointyStick, sword, halitosis
}

enum Food: String {
  case cabbage, bread, fish
}

struct Person {
  let name: String
  let goldCoins: Int
  let rank: Rank
  let weapon: Weapon?
  let food: [Food]
}

//: * * *

let json: [String : AnyObject] = [
  "name" : "Bob",
  "goldCoins" : 2,
  "rank": "jedi",
  "weapon" : "pointyStick",
  "food" : ["cabbage", "cabbage", "fish"]
]

//: * * *

extension Person {
  init?(json: AnyObject) {
    guard let
      name = json["name"] as? String,
      gold = json["goldCoins"] as? Int,
      rankString = json["rank"] as? String,
      rank = Rank(rawValue: rankString),
      weaponString = json["weapon"] as? String,
      foodStrings = json["food"] as? [String]
      else { return nil }
    
    self.name = name
    self.goldCoins = gold
    self.rank = rank
    self.weapon = Weapon(rawValue: weaponString)
    self.food = foodStrings.flatMap(Food.init(rawValue:))
  }
}

let person = Person(json: json)
print(person)


//: * * *

import Argo
import Curry

extension Rank: Decodable {}
extension Weapon: Decodable {}
extension Food: Decodable {}

extension Person: Decodable {
  static func decode(j: JSON) -> Decoded<Person> {
    return curry(Person.init(name: goldCoins: rank: weapon: food:))
      <^> j <| "name"
      <*> j <| "goldCoins"
      <*> j <| "rank"
      <*> j <|? "weapon"
      <*> j <|| "food"
  }
}

let decodedPerson: Decoded<Person> = decode(json)
print(decodedPerson)

//: [Next](@next)
