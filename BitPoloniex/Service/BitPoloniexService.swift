//
//  BitPoloniexService.swift
//  BitPoloniex
//
//  Created by Saleh on 1/25/19.
//  Copyright © 2019 Saleh. All rights reserved.
//

import Foundation
import Starscream
import RxSwift

//public protocol BitPoloniexService {
//func websocketDidConnect(socket: WebSocketClient)
//func websocketDidDisconnect(socket: WebSocketClient, error: Error?)
//func websocketDidReceiveMessage(socket: WebSocketClient, text: String)
//func websocketDidReceiveData(socket: WebSocketClient, data: Data)
//}


class BitPoloniexService {
    
    static let shared : BitPoloniexService = BitPoloniexService()
    
    let _source = PublishSubject<Ticker>()
    
    var socket: WebSocket!
    
    var didConnect: (() -> ())?
    var didDisconnect: ((Error?) -> ())?
    var didReceiveMessage: ((String?) -> ())?
    var didReceiveTickerUpdate: ((Ticker?) -> ())?
    var didReceiveData: ((Data?) -> ())?
    
    private init() {
        var request = URLRequest(url: URL(string: URLs.ServiceURL)!)
        request.timeoutInterval = 5
        socket = WebSocket(request: request)
        socket.delegate = self
    }
    
    
    // MARK: Methods
    
    func send(string: String) {
        socket.write(string: string)
    }
    
    func send(data: Data) {
        socket.write(data: data)
    }
    
    func connect() {
        if !socket.isConnected {
            socket.connect()
        }
    }
    
    func disconnect() {
        _source.dispose()
        if socket.isConnected {
            socket.disconnect()
        }
    }
    
    func getPairsData(completionHandler: @escaping ((Error?, [Ticker]?) -> ())) {
        // PairId and names from API Docs, not provided as API, so I converted to a local JSON.
        if let path = Bundle.main.path(forResource: Constants.PairsJSONFile, ofType: "json") {
            do {
                var arr : [Ticker] = []
                let data = try Data(contentsOf: URL(fileURLWithPath: path), options: .mappedIfSafe)
                let jsonResult = try JSONSerialization.jsonObject(with: data, options: .init(rawValue: 0))
                if let jsonArrayResult = jsonResult as? [[String:String]] {
                    for item in jsonArrayResult {
                        arr.append(Ticker(idAndName: item))
                    }
                    completionHandler(nil, arr.reversed()) //Just reversed to show famous currencies first
                }
            } catch {
                completionHandler(error, nil)
            }
        }
    }
    
    func startTicker() {
        let sub : [String:Any] = [
            "command": "subscribe",
            "channel": Constants.TickerChannel
        ]
        
        socket.write(data: try! JSONSerialization.data(withJSONObject: sub, options: .init(rawValue: 0)))
    }
    

}

extension BitPoloniexService {
    
    public func asObservable() -> Observable<Ticker>{
        return Observable.just(())
            .do(onNext: {
                self.socket.connect()
            })
            .flatMapLatest{self._source}
    }
    
}

extension BitPoloniexService: WebSocketDelegate {
    // MARK: Websocket Delegate Methods.
    
    internal func websocketDidConnect(socket: WebSocketClient) {
        if let handler = self.didConnect {
            handler()
        }
    }
    
    internal func websocketDidDisconnect(socket: WebSocketClient, error: Error?) {
        if let handler = self.didDisconnect {
            handler(error)
        }
    }
    
    internal func websocketDidReceiveMessage(socket: WebSocketClient, text: String) {
        if let values = parseMessageToArray(string: text) {
            let ticker : Ticker = Ticker(values: values)
            
            _source.onNext(ticker)
            
            if let handler =  self.didReceiveTickerUpdate {
                handler(ticker)
            }
        }
        if let handler =  self.didReceiveMessage {
            handler(text)
        }
    }
    
    internal func websocketDidReceiveData(socket: WebSocketClient, data: Data) {
        if let handler = self.didReceiveData {
            handler(data)
        }
    }
}

extension BitPoloniexService {
    // MARK: Helpers
    
    func parseMessageToArray(string: String?) -> [Any]? {
        if let message = string, let data: Data = message.data(using: String.Encoding.utf8)  {
                let arr: [AnyObject]
                do {
                    try arr = JSONSerialization.jsonObject(with: data, options: .init(rawValue: 0)) as! [AnyObject]
                } catch {
                    print("error \(error.localizedDescription)")
                    return nil
                }
            
            if arr.count == 3, let values : [Any] = arr[2] as? [Any] {
                print("values: \(values.description)")
                return values
            }
        }
        return nil
    }
    
}

