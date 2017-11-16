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

/** Information about an error that occurred. */
public struct ErrorInfo: JSONDecodable {
    
    /// A codified error string (e.g. "input_error").
    public let errorID: String
    
    /// A human-readable error string (e.g. "Ignoring image with no valid data").
    public let description: String
    
    /// Used internally to initialize an `ErrorInfo` model from JSON.
    public init(json: JSON) throws {
        errorID = try json.string("error_id")
        description = try json.string("description")
    }
}
