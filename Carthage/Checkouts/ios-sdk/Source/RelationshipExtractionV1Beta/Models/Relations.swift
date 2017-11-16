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

/** Describes the relationships that exist between entities in the text. */
public struct Relations: JSONDecodable {
    
    /// A list of relations.
    public let relations: [Relation]
    
    /// The version of the Knowledge from Language Understanding and Extraction (KLUE) specification.
    public let version: String
    
    /// Used internally to initialize a `Relations` model from JSON.
    public init(json: JSON) throws {
        relations = try json.arrayOf("relation", type: Relation.self)
        version = try json.string("version")
    }
}

/** Describes the relation between two entities. */
public struct Relation: JSONDecodable {
    
    /// The alphanumeric identifier of the relation.
    public let relationID: String
    
    /// The specific type of relation the two entities share.
    public let type: String
    
    /// The subtype of the relation.
    public let subtype: String
    
    /// A list of the arguments to the relation.
    public let relationEntityArgument: [RelationEntityArgument]
    
    /// A list of mentions that refer to the relation.
    public let relatedMentions: [RelatedMentions]
    
    /// Used internally to initialize a `Relation` model from JSON.
    public init(json: JSON) throws {
        relationID = try json.string("rid")
        type = try json.string("type")
        subtype = try json.string("subtype")
        relationEntityArgument = try json.arrayOf("rel_entity_arg", type: RelationEntityArgument.self)
        relatedMentions = try json.arrayOf("relmentions", "relmention", type: RelatedMentions.self)
    }
}

/** The arguments to the relation. */
public struct RelationEntityArgument: JSONDecodable {
    
    /// The alphanumeric identifier of an entity.
    public let entityID: String
    
    /// The position of the argument in the relation.
    public let argumentNumber: Int
    
    /// Used internally to initialize a `RelationEntityArgument` model from JSON.
    public init(json: JSON) throws {
        entityID = try json.string("eid")
        argumentNumber = try json.int("argnum")
    }
}

/** The mentions that refer to this specific relation. */
public struct RelatedMentions: JSONDecodable {
    
    /// The alphanumeric identifier of the relation mention.
    public let relatedMentionID: String
    
    /// A level of confidence of the accuracy of the relation mention annotation, on a scale from
    /// 0 to 1.
    public let score: Double
    
    /// The specificity of the relation mention.
    public let relatedMentionClass: RelatedMentionClass
    
    /// The nature of the related mention.
    public let modality: Modality
    
    /// The time for which the relation mention holds with respect to the publication time of the text.
    public let tense: Tense
    
    /// A list of mentions that refer to the arguments of the relation.
    public let relatedMentionArgument: [RelatedMentionArgument]
    
    /// Used internally to initialize a `RelatedMentions` model from JSON.
    public init(json: JSON) throws {
        relatedMentionID = try json.string("rmid")
        score = try json.double("score")
        relatedMentionArgument = try json.arrayOf("rel_mention_arg", type: RelatedMentionArgument.self)
        
        guard let rMClass = RelatedMentionClass(rawValue: try json.string("class")) else {
            throw JSON.Error.ValueNotConvertible(value: json, to: RelatedMentionClass.self)
        }
        relatedMentionClass = rMClass
        
        guard let tempModality = Modality(rawValue: try json.string("modality")) else {
            throw JSON.Error.ValueNotConvertible(value: json, to: Modality.self)
        }
        modality = tempModality
        
        guard let tempTense = Tense(rawValue: try json.string("tense")) else {
            throw JSON.Error.ValueNotConvertible(value: json, to: Tense.self)
        }
        tense = tempTense
    }
}

/** A mention that refers to the arguments of the relation. */
public struct RelatedMentionArgument: JSONDecodable {
    
    /// The alphanumeric identifier of the mention.
    public let mentionID: String
    
    /// The position of the argument in the relation.
    public let argumentNumber: Int
    
    /// The specific text of the mention.
    public let text: String
    
    /// Used internally to initialize a `RelatedMentionArgument` model from JSON.
    public init(json: JSON) throws {
        mentionID = try json.string("mid")
        argumentNumber = try json.int("argnum")
        text = try json.string("text")
    }
}

/** The specificity of the related mention. */
public enum RelatedMentionClass: String {
    
    /// A relation between two specific arguments.
    case Specific = "SPECIFIC"
    
    /// A negated relation.
    case Negated = "NEG"
    
    /// A relation in which at least one of the two arguments is not specific.
    case Other = "OTHER"
}

/** The nature of the related mention. */
public enum Modality: String {
    
    /// A relation that is asserted as fact and which can be interpreted as such in the world in 
    /// which the arguments exist.
    case Asserted = "ASSERTED"
    
    /// A relation that can be interpreted to hold only in a counterfactual world.
    case Other = "OTHER"
}

/** The time for which the relation mention holds. */
public enum Tense: String {
    
    /// The relation holds only for some span prior to the publication time.
    case Past = "PAST"
    
    /// A relation holds for a limited span that overlaps with the publication time.
    case Present = "PRESENT"
    
    /// A relation holds for some span of time after the publication time.
    case Future = "FUTURE"
    
    /// The relation is static, or the span of time cannot be determined with certainty.
    case Unspecified = "UNSPECIFIED"
}
