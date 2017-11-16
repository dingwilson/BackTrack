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

/** Signals the end of an audio transmission to Speech to Text. */
internal struct TranscriptionStop: JSONEncodable {

    /// The action to perform. Must be `stop` to end the request.
    private let action = "stop"

    /** Serialize a `TranscriptionStop` model to JSON. */
    internal func toJSON() -> JSON {
        return .Dictionary(["action": .String(action)])
    }
}
