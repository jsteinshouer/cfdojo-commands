/**
* create a new training exercise for cfdojo
* .
* {code:bash}
* cfdojo create kata myKata myModule
* {code}  
*  
 **/
component extends='commandbox.system.BaseCommand' aliases='' {

		
	/**
	* @name Name of the kata to create.
	* @module Module name
	* @title Descriptive title
	* @solutionFile File name for the users solution
	* @testFile File name for tests the user starts with
	* @solutionTestFile File name for the kata tests
	**/
	function run( 	
		required name,
		required module,
		title=arguments.name,
		solutionFile="MySolution.cfc",
		testFile="MyTests.cfc",
		solutionTestFile="MyTests.cfc"
	){						
		// This will make each directory canonical and absolute		
		var directory = fileSystemUtil.resolvePath( "modules/#arguments.module#/kata" );
		
		// Validate directory
		if( !directoryExists( directory ) ) {
			directoryCreate( directory );			
		}
		// This help readability so the success messages aren't up against the previous command line
		print.line();
		var basePath = GetDirectoryFromPath( GetCurrentTemplatePath() );

		var templateDir = basePath & "/../_templates";
		var zipFile     = templateDir & "/kata.zip";

		/* Unpack template into modules directory */
		zip action="unzip" file="#zipFile#" destination="#directory#/#arguments.name#";

		
		// Read in kata Config
		var kataConfig = fileRead( '#directory#/#arguments.name#/kata.json' );
		
		// Start Generation Replacing
		kataConfig = replaceNoCase( kataConfig, '@id@', arguments.name, 'all');
		kataConfig = replaceNoCase( kataConfig, '@module@', arguments.module, 'all');
		kataConfig = replaceNoCase( kataConfig, '@title@', REReplace(arguments.title, "\b(\S)(\S*)\b", "\u\1\L\2", "all"), 'all');
		kataConfig = replaceNoCase( kataConfig, '@solutionFile@', arguments.solutionFile, 'all');
		kataConfig = replaceNoCase( kataConfig, '@testFile@', arguments.testFile, 'all');
		kataConfig = replaceNoCase( kataConfig, '@solutionTestFile@', arguments.solutionTestFile, 'all');	

		// Write Out the New Config
		fileDelete( directory & '/#arguments.name#/kata.json');
		fileWrite( directory & '/#arguments.name#/kata.json', kataConfig );

		// Read the test content
		var test = fileRead( '#directory#/#arguments.name#/MyTests.cfc' );	
		test = replaceNoCase( test, '@solutionFile@', replaceNoCase(arguments.solutionFile,".cfc",""), 'all');
			
		// Write Out the test content
		fileDelete( directory & '/#arguments.name#/MyTests.cfc');
		fileWrite( directory & '/#arguments.name#/MyTests.cfc', test );

		if (arguments.solutionFile != "MySolution.cfc") {
			fileMove( '#directory#/#arguments.name#/MySolution.cfc', '#directory#/#arguments.name#/#arguments.solutionFile#');
		}

		if (arguments.testFile != "MyTests.cfc") {
			fileMove( '#directory#/#arguments.name#/Mytest.cfc', '#directory#/#arguments.name#/#arguments.testFile#');
		}

		if (arguments.solutionTestFile != arguments.testFile) {
			fileCopy( '#directory#/#arguments.name#/#arguments.testFile#', '#directory#/#arguments.name#/#arguments.solutionTestFile#');
		}

		var viewDir = fileSystemUtil.resolvePath( "modules/#arguments.module#/views/kata" );

		// Validate directory
		if( !directoryExists( viewDir ) ) {
			directoryCreate( viewDir );			
		}
		
		var stuffAdded = directoryList( directory & '/#arguments.name#', true );
		print.greenLine( 'Created ' & directory & '/#arguments.name#' );
		for( var thing in stuffAdded ) {
			print.greenLine( 'Created ' & thing );			
		}

		if (!fileExists("#viewDir#/#lcase(arguments.name)#.cfm")) {
			fileWrite("#viewDir#/#lcase(arguments.name)#.cfm", "<p>Put instructions here</p>");
			print.greenLine( 'Created ' & " #viewDir#/#lcase(arguments.name)#.cfm");
		}
								
	}

}