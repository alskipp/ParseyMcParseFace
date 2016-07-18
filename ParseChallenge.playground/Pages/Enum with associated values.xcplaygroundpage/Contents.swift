//: [Previous](@previous)
//:# Enum with associated values

import Foundation

enum Dwelling {
  case treeHouse(rooms: Int, height: Int)
  case cave(rooms: Int, depth: Int)
  case shed(rooms: Int)
}

let treeHouseJson: [String : AnyObject]  = [
  "type" : "treeHouse",
  "rooms" : 2,
  "height" : 15
]

let caveJson: [String : AnyObject]  = [
  "type" : "cave",
  "rooms" : 4,
  "depth" : 20
]

let shedJson: [String : AnyObject]  = [
  "type" : "shed",
  "rooms" : 1,
]

//: * * *

extension Dwelling {
  init?(json: AnyObject) {
    guard let type = json["type"] as? String else { return nil }

    switch type {
    case "treeHouse":
      guard let
        rooms = json["rooms"] as? Int,
        height = json["height"] as? Int
      else { return nil }
      self = treeHouse(rooms: rooms, height: height)

    case "cave":
      guard let
        rooms = json["rooms"] as? Int,
        depth = json["depth"] as? Int
        else { return nil }
      self = cave(rooms: rooms, depth: depth)

    case "shed":
      guard let
        rooms = json["rooms"] as? Int else { return nil }
      self = shed(rooms: rooms)

    default: return nil
    }
  }
}

//: * * *

let treeHouse = Dwelling(json: treeHouseJson)
print(treeHouse)

let cave = Dwelling(json: caveJson)
print(cave)

let shed = Dwelling(json: shedJson)
print(shed)

//: * * *

//: ##Argo inspired

import Curry

infix operator <^> { associativity left precedence 130 }
infix operator <*> { associativity left precedence 130 }

func <^><T, U>(@noescape f: T -> U, x: T?) -> U? {
  return x.map(f)
}

func <*><T, U>(f: (T -> U)?, x: T?) -> U? {
  return f.flatMap { f in x.map { f($0) } }
}


extension Dwelling {
  static func decode(json: AnyObject) -> Dwelling? {
    switch json["type"] as? String {

    case "treeHouse"?:
      return curry(Dwelling.treeHouse)
        <^> (json["rooms"] as? Int)
        <*> (json["height"] as? Int)

    case "cave"?:
      return curry(Dwelling.cave)
        <^> (json["rooms"] as? Int)
        <*> (json["depth"] as? Int)

    case "shed"?:
      return Dwelling.shed <^> json["rooms"] as? Int

    default: return nil
    }
  }
}

let treeHouse2 = Dwelling.decode(treeHouseJson)
print(treeHouse2)

let cave2 = Dwelling.decode(caveJson)
print(cave2)

let shed2 = Dwelling.decode(shedJson)
print(shed2)



//: [Next](@next)
