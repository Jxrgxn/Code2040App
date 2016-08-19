//
//  ViewController.swift
//  CODE2040Test
//
//  Created by BASEL FARAG on 8/19/16.
//  Copyright © 2016 BASEL FARAG. All rights reserved.
//

import UIKit


typealias JSONDictionary = [String: AnyObject]


enum HttpMethod<Body> {
    case get
    case post(Body)
}

extension HttpMethod {
    var method: String {
        switch self {
        case .get: return "GET"
        case .post: return "POST"
        }
    }
}


struct Resource<A> {
    var url = NSURL()
    let method: HttpMethod<NSData>
    let parse: (NSData) -> A?
    
}

let codeURL = NSURL(string: "http://challenge.code2040.org/api/register")!
let tokenDictionary: [String: String] = ["token": "7cf4e3a23e3782e877c37eb3d3f383caL"]
let gitDict: [String: NSURL] = ["github": NSURL(string: "https://github.com/Jxrgxn/Code2040App.git")!]
let testArray = [tokenDictionary, gitDict]


extension Resource {
    init(url: NSURL, method: HttpMethod<AnyObject> = .get, parseJSON: (AnyObject) -> A?) {
        self.url = url
        switch method {
        case .get:
            self.method = .get
        case .post(let json):
            let bodyData = try! NSJSONSerialization.dataWithJSONObject(json, options: [])
            self.method = .post(bodyData)
        }
        self.parse = { data in
            let json = try? NSJSONSerialization.JSONObjectWithData(data, options: NSJSONReadingOptions())
            return json.flatMap(parseJSON)
        }
    }
}


func pushNotification(token: String) -> Resource<Bool> {
    let url = NSURL(string: "")!
    let dictionary = ["token": token]
    return Resource(url: url, method: .post(dictionary), parseJSON: { _ in
        return true
    })
}


final class Webservice {
    func load<A>(resource: Resource<A>, completion: A? -> ()) {
        NSURLSession.sharedSession().dataTaskWithURL(resource.url) { data, _, _ in
            completion(data.flatMap(resource.parse))
            }.resume()
    }
}




Webservice().load(Resource.init(url: codeURL, method: HttpMethod.post(testArray), parseJSON: { _ in
    return true
}), completion: { result in
    print(result)
})






