component extends="testbox.system.BaseSpec" {

	// executes before all suites
	function beforeAll(){
		
		solution = new @solutionFile@();

	}

	// executes after all suites
	function afterAll(){}

	// All suites go in here
	function run( testResults, testBox ){
		// Make all tests pass
		describe("My Tests", function() {

			// it(""Should do something"", function() {
			// 	expect(true).toBe(true);
			// });

		});
	}

}