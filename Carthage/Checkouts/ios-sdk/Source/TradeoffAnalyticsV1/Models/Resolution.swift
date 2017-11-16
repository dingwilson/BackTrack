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

/// A resolution to a decision problem.
public struct Resolution: JSONDecodable {
    
    /// The two-dimensional position of the option on the map polygon displayed by the
    /// Tradeoff Analytics visualization.
    public let map: Map?
    
    /// Analytical data per option.
    public let solutions: [Solution]
    
    /// Used internally to initialize a `Resolution` model from JSON.
    public init(json: JSON) throws {
        map = try? json.decode("map")
        solutions = try json.arrayOf("solutions", type: Solution.self)
    }
}

/// The two-dimensional position of an option on the map
/// polygon displayed by the Tradeoff Analytics visualization.
public struct Map: JSONDecodable {
    
    /// A representation of the vertices for the objectives and their positions on the map
    /// visualization.
    public let anchors: [Anchor]
    
    /// A cell on the map visualization. Each cell in the array includes coordinates that
    /// describe the position on the map of the glyphs for one or more listed options, which
    /// are identified by their keys.
    public let nodes: [MapNode]
    
    /// Used internally to initialize a `Map` model from JSON.
    public init(json: JSON) throws {
        anchors = try json.arrayOf("anchors", type: Anchor.self)
        nodes = try json.arrayOf("nodes", type: MapNode.self)
    }
}

/// A representation of the vertices for an objective and its positions on the map visualization.
public struct Anchor: JSONDecodable {
    
    /// Anchor point name.
    public let name: String
    
    /// Anchor point position.
    public let position: MapNodeCoordinates
    
    /// Used internally to initialize an `Anchor` model from JSON.
    public init(json: JSON) throws {
        name = try json.string("name")
        position = try json.decode("position")
    }
}

/// A cell on the map visualization.
public struct MapNode: JSONDecodable {
    
    /// The position of the cell on the map visualization.
    public let coordinates: MapNodeCoordinates
    
    /// References to solutions (the keys for options) positioned on this cell.
    public let solutionRefs: [String]
    
    /// Used internally to initialize a `MapNode` model from JSON.
    public init(json: JSON) throws {
        coordinates = try json.decode("coordinates")
        solutionRefs = try json.arrayOf("solution_refs", type: String.self)
    }
}

/// The position of a cell on the map visualization.
public struct MapNodeCoordinates: JSONDecodable {
    
    /// X-axis coordinate on the map visualization.
    public let x: Double
    
    /// Y-axis coordinate on the map visualization.
    public let y: Double
    
    /// Used internally to initialize a `MapNodeCoordinates` model from JSON.
    public init(json: JSON) throws {
        x = try json.double("x")
        y = try json.double("y")
    }
}

/// Analytical data for a particular option.
public struct Solution: JSONDecodable {
    
    /// A list of references to solutions that shadow this solution.
    public let shadowMe: [String]?
    
    /// A list of references to solutions that are shadowed by this solution.
    public let shadows: [String]?
    
    /// The key that uniquely identifies the option in the decision problem.
    public let solutionRef: String
    
    /// The status of the option (i.e. `Front`, `Excluded`, `Incomplete`,
    /// or `DoesNotMeetPreference`).
    public let status: SolutionStatus
    
    /// If the status is `Incomplete` or `DoesNotMeetPreference`, a description that provides
    /// more information about the cause of the status.
    public let statusCause: StatusCause?
    
    /// Used internally to initialize a `Solution` model from JSON.
    public init(json: JSON) throws {
        shadowMe = try? json.arrayOf("shadow_me", type: String.self)
        shadows = try? json.arrayOf("shadows", type: String.self)
        solutionRef = try json.string("solution_ref")
        statusCause = try? json.decode("status_cause")
        
        guard let status = SolutionStatus(rawValue: try json.decode("status")) else {
            throw JSON.Error.ValueNotConvertible(value: json, to: Solution.self)
        }
        self.status = status
    }
}

/// The status of an option.
public enum SolutionStatus: String {
    
    /// `Front` indicates that the option is included among the top options for the problem.
    case Front = "FRONT"
    
    /// `Excluded` indicates that another option is strictly better than the option.
    case Excluded = "EXCLUDED"
    
    /// `Incomplete` indicates that either the option's specification does not include a value
    /// for one of the columns or its value for one of the columns lies outside the range specified
    /// for the column. Only a column whose `isObjective` property is set to `true` can generate
    /// this status.
    case Incomplete = "INCOMPLETE"
    
    /// `DoesNotMeetPreference` indicates that the option specifies a value for a `Categorical`
    /// column that is not included in the column's preference.
    case DoesNotMeetPreference = "DOES_NOT_MEET_PREFERENCE"
}

/// Additional information about the cause of an option's status.
public struct StatusCause: JSONDecodable {
    
    /// An error code that specifies the cause of the option's status.
    public let errorCode: TradeoffAnalyticsError
    
    /// A description in English of the cause for the option's status.
    public let message: String
    
    /// An array of values used to describe the cause for the option's status. The strings
    /// appear in the message field.
    public let tokens: [String]
    
    /// Used internally to initialize a `StatusCause` model from JSON.
    public init(json: JSON) throws {
        guard let errorCode = TradeoffAnalyticsError(rawValue: try json.string("error_code")) else {
            throw JSON.Error.ValueNotConvertible(value: json, to: StatusCause.self)
        }
        self.errorCode = errorCode
        message = try json.string("message")
        tokens = try json.arrayOf("tokens", type: String.self)
    }
}

/// An error that specifies the cause of an option's status.
public enum TradeoffAnalyticsError: String {
    
    /// Indicates that a column for which the `isObjective` property is `true` is absent from
    /// the option's specification.
    case MissingObjectiveValue = "MISSING_OBJECTIVE_VALUE"
    
    /// Indicates that the option's specifications defines a value that is outside of the range
    /// specified for an objective.
    case RangeMismatch = "RANGE_MISMATCH"
    
    /// Indicates that a `Categorical` column value for the option is not in the preference
    /// for that column.
    case DoesNotMeetPreference = "DOES_NOT_MEET_PREFERENCE"
}
