/**
 Given string num representing a non-negative integer num, and an integer k, return the smallest possible integer after removing k digits from num
 **/

import XCTest

/*
 Initial Plan:
  - My first thought when solving this problem is to loop through combinations and compare
    -> Nested For Loops
  - Nest Number (k) is unknown, so must be run a programitic amount of times
    -> Not Nested For Loops
    -> Recursion
  
 Improvements to be made on this method:
  - Recursion is inefficient. Should move to a monatic stack
 */
class RecursiveSolve {
    var currentMin = Int.max
    func removeKdigits(_ num: String, _ k: Int) -> String {
        guard num.count > k else { return "0" }
        recursiveCall(num, k, 0)
        
        return "\(currentMin)"
        
    }

    /**
     The Recursive Call
     Need to pass index in to avoid double checking (i.e: Eliminating indecies 1, 2, 3 is the same as eliminating endecies 1, 3, 2)
     */
    func recursiveCall(_ num: String, _ k: Int, _ index: Int) {
        // The exit condition -> No further digits to remove
        guard k > 0 else {
            if let numAsInt = Int(num) {
                // Store the new min if it is smaller
                if numAsInt < currentMin {
                    currentMin = numAsInt
                }
            }
            return
        }
        
        var thisCycleMin = Int.max
        //We will loop through the remaining digits starting after any digits we have already checked
        for i in index ..< num.count {
            var newNum = num
            newNum.remove(at: newNum.getStringIndexForCharacter(i: i))
            if let newNumAsInt = Int(newNum) {
                // If we are already bigger than the min of the current level, we will always be bigger than the min at this level, there is no need to check further down the line
                // i.e: if we have a 9841
                // eliminating 9 -> 841
                // eliminating 8 -> 941
                // No matter what we eliminate after the 8, the 9XX will always be bigger than the 8XX
                if thisCycleMin < newNumAsInt {
                    continue
                } else {
                    thisCycleMin = newNumAsInt
                }
            }
            recursiveCall(newNum, k-1, i)
        }
    }
}

// Convenience function for String index because Swift
extension String {
    func getStringIndexForCharacter(i: Int) -> String.Index {
        return self.index(self.startIndex, offsetBy: i)
    }
}

class Tests: XCTestCase {
    var recSolve = RecursiveSolve()
    
    func testCase1() {
        XCTAssertEqual(recSolve.removeKdigits("1432219", 3), "1219")
    }
    
    func testCase2() {
        XCTAssertEqual(recSolve.removeKdigits("10200", 1), "200")
    }
    
    func testCase3() {
        XCTAssertEqual(recSolve.removeKdigits("10", 2), "0")
    }
}

Tests.defaultTestSuite.run()
