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

/** Information about a warning that occurred. */
public struct WarningInfo: JSONDecodable {
    
    /// A codified warning string (e.g. "limit_reached").
    public let warningID: String
    
    /// A human-readable warning string (e.g. "Max number of images (100) reached").
    public let description: String
    
    /// Used internally to initialize a `WarningInfo` model from JSON.
    public init(json: JSON) throws {
        warningID = try json.string("warning_id")
        description = try json.string("description")
    }
}
