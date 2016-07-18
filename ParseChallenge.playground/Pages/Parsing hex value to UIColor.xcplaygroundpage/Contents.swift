//: [Previous](@previous)
//: Parsing hex value to UIColor

import UIKit

//: * * *

struct ColorPalette {
  let name: String
  let colors: [UIColor]
}

//: * * *

let json: [String : AnyObject] = [
  "name" : "Random Colours",
  "colors" : ["00bbff", "4488ee", "8866dd", "bb44cc", "ff22bb"]
]

//: Hint: to convert hexString to Optional<Int>
let i = Int("00bbff", radix: 16)

//: * * *
//: convenience init to create UIColor from hex value

extension UIColor {
  convenience init(hex: Int) {
    let r = CGFloat((hex >> 16) & 0xff) / 255
    let g = CGFloat((hex >> 08) & 0xff) / 255
    let b = CGFloat((hex >> 00) & 0xff) / 255

    self.init(red: r, green: g, blue: b, alpha: 1)
  }
}

let exampleColor = UIColor(hex: 0xff0000)

//: * * *


extension ColorPalette {
  init?(json: AnyObject) {
    guard let
      name = json["name"] as? String,
      hexStrings = json["colors"] as? [String]
      else { return nil }

    self.name = name
    self.colors = hexStrings
      .flatMap { Int($0, radix: 16) }
      .map(UIColor.init(hex:))
  }
}

let colorPalette = ColorPalette(json: json)
print(colorPalette)


//: * * *

import Argo
import Curry

func toColor(s: String) -> Decoded<UIColor> {
  return .fromOptional(Int(s, radix: 16)
    .map(UIColor.init(hex:)))
}

extension ColorPalette: Decodable {
  static func decode(j: JSON) -> Decoded<ColorPalette> {
    return curry(ColorPalette.init(name: colors:))
      <^> j <| "name"
      <*> (j <|| "colors" >>- { sequence($0.map(toColor)) })
  }
}

let decodedPalette: Decoded<ColorPalette> = decode(json)
print(decodedPalette)


//: * * *

import Unbox

extension UIColor: UnboxableByTransform {
  public typealias UnboxRawValueType = String

  public static func transformUnboxedValue(hexString: String) -> Self? {
    guard let hex = Int(hexString, radix: 16) else { return nil }

    let r = CGFloat((hex >> 16) & 0xff) / 255
    let g = CGFloat((hex >> 08) & 0xff) / 255
    let b = CGFloat((hex >> 00) & 0xff) / 255

    return self.init(red: r, green: g, blue: b, alpha: 1)
  }

  public static func unboxFallbackValue() -> Self {
    return self.init()
  }
}

//: Not sure how to get this working using `Unbox` ???

//extension ColorPalette: Unboxable {
//  init(unboxer: Unboxer) {
//    self.name = unboxer.unbox("name")
//    self.colors = unboxer.unbox("colors")
//  }
//}
//
//let unboxedColor: ColorPalette = try Unbox(json)
//
//let unbox: UIColor = try Unbox(json)

//: [Next](@next)
