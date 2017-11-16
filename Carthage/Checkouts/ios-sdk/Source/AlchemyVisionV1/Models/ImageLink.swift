/**
 * Copyright IBM Corporation 2016
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 * http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 **/

import Foundation
import Freddy

/** The primary image link detected on a webpage by the Alchemy Vision service. */
public struct ImageLink: JSONDecodable {

    /// The status of the request.
    public let status: String

    /// The URL of the requested source.
    public let url: String

    /// The URL of the primary image.
    public let image: String

    /// Used internally to initialize an `ImageLink` model from JSON.
    public init(json: JSON) throws {
        status = try json.string("status")
        url = try json.string("url")
        image = try json.string("image")
    }
}
