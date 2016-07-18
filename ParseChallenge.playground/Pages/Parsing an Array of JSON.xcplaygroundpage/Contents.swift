//: [Previous](@previous)
//:# Parse an Array of values

import Foundation

enum Suit: String, CustomStringConvertible {
  case hearts, diamonds, clubs, spades

  var description: String {
    switch self {
    case .hearts: return "♡"
    case .diamonds: return "♢"
    case .clubs: return "♧"
    case .spades: return "♤"
    }
  }
}

enum CardValue: Int {
  case one = 1, two, three, four, five, six, seven, eight, nine, ten, jack, queen, king, ace
}

struct Card: CustomStringConvertible {
  let suit: Suit
  let value: CardValue

  var description: String {
    return "\(value) of \(suit)"
  }
}

let cardsJson: [[String : AnyObject]] = [
  ["suit" : "hearts", "value" : 5],
  ["suit" : "diamonds", "value" : 12],
  ["suit" : "clubs", "value" : 14],
  ["suit" : "diamonds", "value" : 7]
]

//: * * *

protocol JSONDecodable {
  init?(json: AnyObject)
}

extension Card: JSONDecodable {
  init?(json: AnyObject) {
    guard let
      suit = (json["suit"] as? String).flatMap(Suit.init(rawValue:)),
      value = (json["value"] as? Int).flatMap(CardValue.init(rawValue:))
      else { return nil }

    self.suit = suit
    self.value = value
  }
}

let card = Card(json: ["suit" : "spades", "value" : 14])
print(card)

//: * * *

func decodeArray<T: JSONDecodable>(json: AnyObject) -> [T] {
  let array = json as? [AnyObject] ?? []
  return array.flatMap(T.init(json:))
}

//: * * *

let cards: [Card] = decodeArray(cardsJson)
print(cards)


//: * * *

import Argo
import Curry

extension Suit: Decodable {}
extension CardValue: Decodable {}

extension Card: Decodable {
  static func decode(j: JSON) -> Decoded<Card> {
    return curry(Card.init(suit: value:))
      <^> j <| "suit"
      <*> j <| "value"
  }
}

let decodedCards: Decoded<[Card]> = decode(cardsJson)
print(decodedCards)


//: * * *

import Unbox

extension Suit: UnboxableEnum {
  static func unboxFallbackValue() -> Suit {
    return .hearts
  }
}

extension CardValue: UnboxableEnum {
  static func unboxFallbackValue() -> CardValue {
    return .one
  }
}

extension Card: Unboxable {
  init(unboxer: Unboxer) {
    suit = unboxer.unbox("suit")
    value = unboxer.unbox("value")
  }
}

do {
  let unboxedCards: [Card] = try Unbox(cardsJson)
  print(unboxedCards)
}
catch let err {
  print(err)
}

//: * * *

import Mapper

extension Card: Mappable {
  init(map: Mapper) throws {
    try suit = map.from("suit")
    try value = map.from("value")
  }
}

//: No idea how to perform this parse and maintain error info???!
//: The code below returns an Optional and throws away errors
let mappedCards = Card.from(cardsJson)
print(mappedCards)



//: [Next](@next)
