//: [Previous](@previous)
//:# Optional enum property

import Foundation

enum Rank: String {
  case apprentice, veteran, jedi
}

enum Weapon: String {
  case pointyStick, sword, halitosis
}

struct Person {
  let name: String
  let gold: Int
  let rank: Rank
  let weapon: Weapon?
}

//: * * *

let armedJson: [String : AnyObject] = [
  "name" : "Janice",
  "gold" : 9,
  "rank": "veteran",
  "weapon": "sword"
]

let unArmedJson: [String : AnyObject] = [
  "name" : "Fred",
  "gold" : 2,
  "rank": "apprentice",
]

//: * * *

extension Person {
  init?(json: AnyObject) {
    guard let
      name = json["name"] as? String,
      gold = json["gold"] as? Int,
      rankString = json["rank"] as? String,
      rank = Rank(rawValue: rankString)
      else { return nil }
    
    self.name = name
    self.gold = gold
    self.rank = rank
    self.weapon = (json["weapon"] as? String).flatMap { Weapon(rawValue: $0) }
  }
}

let armedPerson = Person(json: armedJson)
print(armedPerson)

let unArmedPerson = Person(json: unArmedJson)
print(unArmedPerson)


//: * * *

import Argo
import Curry

extension Rank: Decodable {}
extension Weapon: Decodable {}

extension Person: Decodable {
  static func decode(j: JSON) -> Decoded<Person> {
    return curry(Person.init(name: gold: rank: weapon:))
      <^> j <| "name"
      <*> j <| "gold"
      <*> j <| "rank"
      <*> j <|? "weapon"
  }
}

let decodedArmed: Decoded<Person> = decode(armedJson)
print(decodedArmed)

let decodedUnArmed: Decoded<Person> = decode(unArmedJson)
print(decodedUnArmed)

//: [Next](@next)
