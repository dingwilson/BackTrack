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

/** A wrapper object that contains results from a Speech to Text recognition request. */
internal struct TranscriptionResultWrapper: JSONDecodable {

    /// Index indicating change point in the results array.
    /// (See description of `results` array for more information.)
    internal let resultIndex: Int

    /// The results array consists of 0 or more final results, followed by 0 or 1 interim
    /// result. The final results are guaranteed not to change, while the interim result may
    /// be replaced by 0 or more final results, followed by 0 or 1 interim result. The service
    /// periodically sends "updates" to the result list, with the `resultIndex` set to the
    /// lowest index in the array that has changed. `resultIndex` always points to the slot
    /// just after the most recent final result.
    internal let results: [TranscriptionResult]

    /// Used internally to initialize a `TranscriptionResultWrapper` model from JSON.
    internal init(json: JSON) throws {
        resultIndex = try json.int("result_index")
        results = try json.arrayOf("results", type: TranscriptionResult.self)
    }
}
