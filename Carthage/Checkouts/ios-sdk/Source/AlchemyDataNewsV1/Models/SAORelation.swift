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
 
 **SAORelation**
 
 Extracted Subject, Action, and Object parts of a sentence
 
 */

public struct SAORelation: JSONDecodable {
    
    /// see Action
    public let action: Action?
    
    /// an extracted Sentence
    public let sentence: String?
    
    /// see Subject
    public let subject: Subject?
    
    /// see RelationObject
    public let object: RelationObject?
    
    /// Used internally to initialize a SAORelation object
    public init(json: JSON) throws {
        action = try? json.decode("action", type: Action.self)
        sentence = try? json.string("sentence")
        subject = try? json.decode("subject", type: Subject.self)
        object = try? json.decode("object", type: RelationObject.self)
    }
    
}

/**
 An action as defined by the AlchemyLanguage service
 */
public struct Action: JSONDecodable {
    
    /// text the action was extracted from
    public let text: String?
    
    /// the base or dictionary form of the word
    public let lemmatized: String?
    
    /// see Verb
    public let verb: Verb?
    
    /// Used internally to initialize an Action object
    public init(json: JSON) throws {
        text = try? json.string("text")
        lemmatized = try? json.string("lemmatized")
        verb = try? json.decode("verb", type: Verb.self)
    }
    
    /**
     A verb as defined by the AlchemyLanguage service
     */
    public struct Verb: JSONDecodable {
        
        /// text the verb was extracted from
        public let text: String?
        
        /// the tense of the verb
        public let tense: String?
        
        /// was the verb negated
        public let negated: Int?
        
        /// Used internally to initalize a Verb object
        public init(json: JSON) throws {
            text = try? json.string("text")
            tense = try? json.string("tense")
            if let negatedString = try? json.string("negated") {
                negated = Int(negatedString)
            } else {
                negated = 0
            }
        }
    }
}

/**
 A subjet extracted by the AlchemyLanguage service
 */
public struct Subject: JSONDecodable {
    
    /// text the subject was extracted from
    public let text: String?
    
    /// see **Sentiment**
    public let sentiment: Sentiment?
    
    /// see **Entity**
    public let entity: Entity?
    
    /// Used internally to initialize a Subject object
    public init(json: JSON) throws {
        text = try? json.string("text")
        sentiment = try? json.decode("sentiment", type: Sentiment.self)
        entity = try? json.decode("entity", type: Entity.self)
    }
}

/**
 **Sentiment** related to the Subject-Action-Object extraction
 */
public struct RelationObject: JSONDecodable {
    
    /// text the relation object was extracted from
    public let text: String?
    
    /// see **Sentiment**
    public let sentiment: Sentiment?
    
    /// see **Sentiment**
    public let sentimentFromSubject: Sentiment?
    
    /// see **Entity**
    public let entity: Entity?
    
    /// Used internally to initialize a RelationObject object
    public init(json: JSON) throws {
        text = try? json.string("text")
        sentiment = try? json.decode("sentiment", type: Sentiment.self)
        sentimentFromSubject = try? json.decode("sentimentFromSubject", type: Sentiment.self)
        entity = try? json.decode("entity", type: Entity.self)
    }
}


