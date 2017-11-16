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
    
/** The results of performing tone analysis on a document. */
public struct ToneAnalysis: JSONDecodable {
    
    /// Tone analysis results of the entire document's text. This includes three
    /// tone categories: social tone, emotional tone, and language tone.
    public let documentTone: [ToneCategory]
    
    /// Tone analysis results for each sentence contained in the document.
    public let sentencesTones: [SentenceAnalysis]?
    
    /// Used internally to initialize a `ToneAnalysis` model from JSON.
    public init(json: JSON) throws {
        documentTone = try json.arrayOf("document_tone", "tone_categories", type: ToneCategory.self)
        sentencesTones = try? json.arrayOf("sentences_tone", type: SentenceAnalysis.self)
        
    }
}
