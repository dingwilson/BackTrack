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
    
/** A dialog conversation response. */
public struct ConversationResponse: JSONDecodable {
    
    /// The response from the dialog application.
    public let response: [String]
    
    /// The input string that prompted the dialog application to respond.
    public let input: String
    
    /// The conversation identifier.
    public let conversationID: Int
    
    /// The confidence associated with the conversation response.
    public let confidence: Double
    
    /// The client identifier.
    public let clientID: Int

    /// Used internally to initialize a `ConversationResponse` model from JSON.
    public init(json: JSON) throws {
        response = try json.arrayOf("response")
        input = try json.string("input")
        conversationID = try json.int("conversation_id")
        confidence = try json.double("confidence")
        clientID = try json.int("client_id")
    }
}
