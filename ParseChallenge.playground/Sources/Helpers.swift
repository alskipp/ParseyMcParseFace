import Foundation

/*:
 **Helper functions** – load JSON from a file
 */
class JSONLoader {} // a dummy class for use with NSBundle(forClass:). Needed to load files from the test bundle

public func JSONFromFile(file: String) -> AnyObject? {
  return dataFromFile(file)
    .flatMap(JSONObjectWithData)
}

public func dataFromFile(file: String) -> NSData? {
  return NSBundle(forClass: JSONLoader.self).pathForResource(file, ofType: "json")
    .flatMap { NSData(contentsOfFile: $0) }
}

func JSONObjectWithData(data: NSData) -> AnyObject? {
  do { return try NSJSONSerialization.JSONObjectWithData(data, options: []) }
  catch { return .None }
}
