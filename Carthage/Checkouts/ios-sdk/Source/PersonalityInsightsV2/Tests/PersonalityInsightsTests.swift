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

import XCTest
import PersonalityInsightsV2

class PersonalityInsightsTests: XCTestCase {

    private var personalityInsights: PersonalityInsights!
    private var mobyDickIntro: String!
    private var kennedySpeech: String!
    private let timeout: NSTimeInterval = 5.0

    // MARK: - Test Configuration

    /** Set up for each test by loading text files and instantiating the service. */
    override func setUp() {
        super.setUp()
        continueAfterFailure = false
        instantiatePersonalityInsights()
        loadMobyDickIntro()
        loadKennedySpeech()
    }

    /** Load "MobyDickIntro.txt". */
    func loadMobyDickIntro() {
        let bundle = NSBundle(forClass: self.dynamicType)
        guard let file = bundle.pathForResource("MobyDickIntro", ofType: "txt") else {
            XCTFail("Unable to locate MobyDickIntro.txt file.")
            return
        }

        mobyDickIntro = try? String(contentsOfFile: file)
        guard mobyDickIntro != nil else {
            XCTFail("Unable to read MobyDickIntro.txt file.")
            return
        }
    }

    /** Load "KennedySpeech.txt." */
    func loadKennedySpeech() {
        let bundle = NSBundle(forClass: self.dynamicType)
        guard let file = bundle.pathForResource("KennedySpeech", ofType: "txt") else {
            XCTFail("Unable to locate KennedySpeech.txt file.")
            return
        }

        kennedySpeech = try? String(contentsOfFile: file)
        guard kennedySpeech != nil else {
            XCTFail("Unable to read KennedySpeech.txt file.")
            return
        }
    }

    /** Instantiate Personality Insights. */
    func instantiatePersonalityInsights() {
        let bundle = NSBundle(forClass: self.dynamicType)
        guard
            let file = bundle.pathForResource("Credentials", ofType: "plist"),
            let credentials = NSDictionary(contentsOfFile: file) as? [String: String],
            let username = credentials["PersonalityInsightsUsername"],
            let password = credentials["PersonalityInsightsPassword"]
        else {
            XCTFail("Unable to read credentials.")
            return
        }
        personalityInsights = PersonalityInsights(username: username, password: password)
    }

    /** Fail false negatives. */
    func failWithError(error: NSError) {
        XCTFail("Positive test failed with error: \(error)")
    }

    /** Fail false positives. */
    func failWithResult<T>(result: T) {
        XCTFail("Negative test returned a result.")
    }

    /** Wait for expectations. */
    func waitForExpectations() {
        waitForExpectationsWithTimeout(timeout) { error in
            XCTAssertNil(error, "Timeout")
        }
    }
    
    // MARK: - Positive Tests
    
    /** Analyze the text of Kennedy's speech. */
    func testProfile() {
        let description = "Analyze the text of Kennedy's speech."
        let expectation = expectationWithDescription(description)

        personalityInsights.getProfile(text: kennedySpeech, failure: failWithError) { profile in
            XCTAssertEqual("root", profile.tree.name, "Tree root should be named root")
            expectation.fulfill()
        }
        waitForExpectations()
    }
    
    /** Analyze content items. */
    func testContentItem() {
        let description = "Analyze content items."
        let expectation = expectationWithDescription(description)

        let contentItem = PersonalityInsightsV2.ContentItem(
            id: "245160944223793152",
            userID: "Bob",
            sourceID: "Twitter",
            created: 1427720427,
            updated: 1427720427,
            contentType: "text/plain",
            language: "en",
            content: kennedySpeech,
            parentID: "",
            reply: false,
            forward: false
        )

        let contentItems = [contentItem, contentItem]
        personalityInsights.getProfile(contentItems: contentItems, failure: failWithError) {
            profile in
            XCTAssertEqual("root", profile.tree.name, "Tree root should be named root")
            expectation.fulfill()
        }
        waitForExpectations()
    }

    // MARK: - Negative Tests
    
    /** Test getProfile() with text that is too short (less than 100 words). */
    func testProfileWithShortText() {
        let description = "Try to analyze text that is too short (less than 100 words)."
        let expectation = expectationWithDescription(description)

        let failure = { (error: NSError) in
            XCTAssertEqual(error.code, 400)
            expectation.fulfill()
        }

        personalityInsights.getProfile(
            text: mobyDickIntro,
            failure: failure,
            success: failWithResult
        )
        waitForExpectations()
    }
}
