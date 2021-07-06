//
//  URLSession+Cookie.swift
//  MessageRacer
//
//  Created by Vincent on 7/6/21.
//

import Foundation

func readCookie(for url: URL) -> [HTTPCookie] {
    let store = HTTPCookieStorage.shared
    let cookies = store.cookies(for: url) ?? []
    return cookies
}

func deleteCookies(for url: URL) {
    let store = HTTPCookieStorage.shared
    readCookie(for: url).forEach {
        store.deleteCookie($0)
    }
}

func storeCookies(for url: URL, cookies: [HTTPCookie]) {
    let store = HTTPCookieStorage.shared
    store.setCookies(cookies, for: url, mainDocumentURL: nil)
}


extension URLSessionConfiguration {
    public static var cookie: URLSessionConfiguration {
        HTTPCookieStorage.shared.cookieAcceptPolicy = .always
        let config = URLSessionConfiguration.default
        return config
    }
}
