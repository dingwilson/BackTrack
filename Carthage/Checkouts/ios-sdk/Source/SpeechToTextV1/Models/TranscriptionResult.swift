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
import RestKit

/** A result from a Speech to Text recognition request. */
public struct TranscriptionResult: JSONDecodable {

    /// If `true`, then the transcription result for this
    /// utterance is final and will not be updated further.
    public let final: Bool

    /// Alternative transcription results.
    public let alternatives: [Transcription]

    /// A dictionary of spotted keywords and their associated matches. A keyword will have
    /// no associated matches if it was not found within the audio input or the threshold
    /// was set too high.
    public let keywordResults: [String: [KeywordResult]]?

    /// A list of acoustically similar alternatives for words of the input audio.
    public let wordAlternatives: [AlternativeResults]?

    /// Used internally to initialize a `TranscriptionResult` model from JSON.
    public init(json: JSON) throws {
        final = try json.bool("final")
        alternatives = try json.arrayOf("alternatives", type: Transcription.self)
        keywordResults = try? json.dictionary("keywords_result").map {
            json in try json.arrayOf(type: KeywordResult.self)
        }
        wordAlternatives = try? json.arrayOf("word_alternatives", type: AlternativeResults.self)
    }
}
