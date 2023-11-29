//
//  TrackerTests.swift
//  TrackerTests
//
//  Created by Dolnik Nikolay on 03.10.2023.
//

import XCTest
import SnapshotTesting
@testable import Tracker

final class TrackerTests: XCTestCase {

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }
    func testViewController(){
        let vc = TrackersViewController()
        
        assertSnapshots(of: vc, as: [.image], record: false)
        
    }

    

}
