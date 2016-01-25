component extends="testbox.system.BaseSpec" {

	// All suites go in here
	function run( testResults, testBox ){
		// Make all tests pass
		describe("My Tests", function() {

			// executes before all suites
			beforeEach(function(){
				solution = new @solutionFile@();
			});


			// it("Test for something", function() {
			// 	expect(solution.someMethod()).toBe("something");
			// });

		});
	};

}