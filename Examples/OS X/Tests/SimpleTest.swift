import XCTest

public enum BuilderError: ErrorType {
	case CountMismatchError(String)
}

class TestDataRow {
	let input: [Float]
	let answer: [Float]
	var actualAnswer: [Float]?
	
	init(input: [Float], answer: [Float]) {
		self.input = input
		self.answer = answer
	}
}

class Builder {
	var name = "Noname"
	var rows = [TestDataRow]()
	
	func append(input: [Float], _ answer: [Float]) {
		rows.append(TestDataRow(input: input, answer: answer))
	}
	
	var inputs: [[Float]] {
		return rows.map { $0.input }
	}

	var answers: [[Float]] {
		return rows.map { $0.answer }
	}

	var actualAnswers: [[Float]] {
		return rows.map { $0.actualAnswer ?? [] }
	}
	
	func computeErrors() throws -> [Float] {
		var errors = [Float]()
		for row: TestDataRow in rows {
			let n0 = row.answer.count
			let n1 = row.actualAnswer?.count ?? 0
			guard n0 == n1 else {
				print("Mismatch error: Number of actual values are different than expected.")
				throw BuilderError.CountMismatchError("Invalid number of outputs given: \(n1). Expected: \(n0)")
			}
			for i in 0..<n0 {
				let v0: Float = row.answer[i]
				let v1: Float = row.actualAnswer![i]
				errors.append(v0 - v1)
			}
		}
		return errors
	}
	
	var absoluteError: Float {
		do {
			let errors: [Float] = try computeErrors()
			return errors.reduce(0) { $0 + abs($1) }
		} catch {
			return Float.NaN
		}
	}
	
	func prettyPrint() {
		var s = [String]()
		s.append("=========== \(name) ===========")
		for row in rows {
			if let actualAnswer = row.actualAnswer {
				s.append("\(row.input) -> \(row.answer) vs. \(actualAnswer)")
			} else {
				s.append("\(row.input) -> \(row.answer)")
			}
		}
		s.append("absolute error: \(absoluteError)")
		print(s.joinWithSeparator("\n"))
	}
}

extension Builder {
	func xor2way() {
		name = "XOR gate with 2 inputs"
		append([0, 0], [0])
		append([0, 1], [1])
		append([1, 0], [1])
		append([1, 1], [0])
	}

	func xor3way() {
		name = "XOR gate with 3 inputs"
		append([0, 0, 0], [0])
		append([0, 0, 1], [0])
		append([0, 1, 0], [1])
		append([0, 1, 1], [1])
		append([1, 0, 0], [0])
		append([1, 0, 1], [1])
		append([1, 1, 0], [0])
		append([1, 1, 1], [1])
	}
	
	func sinus() {
		name = "Mimic the Sinus function"
		let n = 19
		for i in 0...n {
			let input: Float = Float(i) / Float(n)
			let rad: Float = Float(M_PI * 2) * input
			let output: Float = (sin(rad) + 1) / 2
			append([input], [output])
		}
	}
}

class SimpleTest: XCTestCase {
    
    func testXor2way() {
		let network = FFNN<Float>(inputs: 2, hidden: 2, outputs: 1, learningRate: 0.1, momentum: 0.1, weights: nil)
		
		let b = Builder()
		b.xor2way()

		try! network.train(inputs: b.inputs, answers: b.answers,
			testInputs: b.inputs, testAnswers: b.answers,
			errorThreshold: 0.001)

		for row in b.rows {
			row.actualAnswer = try! network.update(inputs: row.input)
		}
		b.prettyPrint()

		XCTAssertLessThan(b.absoluteError, 0.1)
    }
	
	func testXor3way() {
		let network = FFNN<Float>(inputs: 3, hidden: 3, outputs: 1, learningRate: 0.1, momentum: 0.1, weights: nil)
		
		let b = Builder()
		b.xor3way()
		
		try! network.train(inputs: b.inputs, answers: b.answers,
			testInputs: b.inputs, testAnswers: b.answers,
			errorThreshold: 0.001)
		
		for row in b.rows {
			row.actualAnswer = try! network.update(inputs: row.input)
		}
		b.prettyPrint()
		
		XCTAssertLessThan(b.absoluteError, 0.1)
	}
	
	func testSinus() {
		let network = FFNN<Float>(inputs: 1, hidden: 10, outputs: 1, learningRate: 0.2, momentum: 0.1, weights: nil)
		
		let b = Builder()
		b.sinus()
		
		try! network.train(inputs: b.inputs, answers: b.answers,
			testInputs: b.inputs, testAnswers: b.answers,
			errorThreshold: 0.1)
		
		for row in b.rows {
			row.actualAnswer = try! network.update(inputs: row.input)
		}
		b.prettyPrint()
		
		XCTAssertLessThan(b.absoluteError, 0.9)
	}
	
}
