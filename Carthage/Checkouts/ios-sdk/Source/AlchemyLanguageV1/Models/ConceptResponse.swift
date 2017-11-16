/**
 * Copyright IBM Corporation 2015
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

/**
 
 **ConceptResponse**
 
 Response object for Concept related calls
 
 */

public struct ConceptResponse: JSONDecodable {
    
    /** extracted language */
    public let language: String?
    
    /** the URL information was requested for */
    public let url: String?
    
    /** number of transactions made by the call */
    public let totalTransactions: Int?
    
    /** see **Concept** */
    public let concepts: [Concept]?
    
    /// Used internally to initialize a ConceptResponse object
    public init(json: JSON) throws {
        language = try? json.string("language")
        url = try? json.string("url")
        if let totalTransactionsString = try? json.string("totalTransactions") {
            totalTransactions = Int(totalTransactionsString)
        } else {
            totalTransactions = 1
        }
        concepts = try? json.arrayOf("concepts", type: Concept.self)
    }
}


