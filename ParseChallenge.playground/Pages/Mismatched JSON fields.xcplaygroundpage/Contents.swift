//: [Previous](@previous)
//: # Dealing with mismatched JSON fields
//: The format of the JSON data doesn't exactly mirror the struct

import Foundation

struct Person {
  let name: String
}

let json: [String : AnyObject] = [
  "firstName" : "Bob",
  "lastName": "Smith"
]

//: As our struct doesn't match the JSON 
//: we need to combine the firstName & lastName fields

//: * * *

extension Person {
  init?(json: AnyObject) {
    guard let
      first = json["firstName"] as? String,
      last = json["lastName"] as? String
      else { return nil }
    
    name = "\(first) \(last)"
  }
}

let person = Person(json: json)
print(person)


//: * * *

import Argo
import Curry

extension Person: Decodable {
  private init(firstName: String, lastName: String) {
    name = "\(firstName) \(lastName)"
  }

  static func decode(j: JSON) -> Decoded<Person> {
    return curry(Person.init(firstName: lastName:))
      <^> j <| "firstName"
      <*> j <| "lastName"
  }
}

let decodedPerson: Decoded<Person> = decode(json)
print(decodedPerson)


//: * * *

import Unbox

extension Person: Unboxable {
  init(unboxer: Unboxer) {
    let firstName: String = unboxer.unbox("firstName")
    let lastName: String = unboxer.unbox("lastName")
    name = "\(firstName) \(lastName)"
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
