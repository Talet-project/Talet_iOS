//
//  NetworkLogger.swift
//  Talet
//
//  Created by 김승희 on 2/4/26.
//

import Alamofire
import Foundation


final class NetworkLogger: EventMonitor {

    let queue = DispatchQueue(label: "com.talet.networklogger")

    func requestDidFinish(_ request: Request) {
        let method = request.request?.httpMethod ?? "Unknown"
        let url = request.request?.url?.absoluteString ?? "Unknown"

        var body: String?
        if let data = request.request?.httpBody {
            body = String(data: data, encoding: .utf8)
        }

        print("""
        ============================================================
        [REQUEST [\(method)] \(url)]
        Body: \(body ?? "nil")
        """)
    }

    func request<Value>(
        _ request: DataRequest,
        didParseResponse response: DataResponse<Value, AFError>
    ) {
        let status = response.response?.statusCode ?? 0
        let url = request.request?.url?.absoluteString ?? "Unknown"
        let duration = response.metrics
            .map { String(format: "%.3fs", $0.taskInterval.duration) } ?? "?"

        var body: String?
        if let data = response.data {
            body = String(data: data, encoding: .utf8)
        }

        let icon = (200...299).contains(status) ? "✅" : "❌"

        print("""
        ============================================================
        [\(icon) RESPONSE [\(status)] (\(duration)) \(url)]
        Body: \(body ?? "nil")
        ============================================================
        """)
    }
}
