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

/** Word alternatives produced by Speech to Text. */
public struct AlternativeResults: JSONDecodable {

    /// The time, in seconds, at which the word with alternative
    /// word hypotheses starts in the audio input.
    public let startTime: Double

    /// The time, in seconds, at which the word with alternative
    /// word hypotheses ends in the audio input.
    public let endTime: Double

    /// A list of alternative word hypotheses for a word in the audio input.
    public let alternatives: [AlternativeResult]

    /// Used internally to initialize an `AlternativeResults` model from JSON.
    public init(json: JSON) throws {
        startTime = try json.double("start_time")
        endTime = try json.double("end_time")
        alternatives = try json.arrayOf("alternatives", type: AlternativeResult.self)
    }
}
