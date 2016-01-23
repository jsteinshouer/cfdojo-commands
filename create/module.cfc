/**
* create a new training module for cfdojo
* .
* {code:bash}
* cfdojo create module myModule
* {code}  
*  
 **/
component extends='commandbox.system.BaseCommand' aliases='' {

		
	/**
	* @name Name of the module to create.
	* @author Whoever wrote this module
	* @authorURL The author's URL
	* @description The description for this module
	* @version The symantic version number: major.minior.patch
	* @cfmapping A CF app mapping to create that points to the root of this module
	* @modelNamespace The namespace to use when mapping the models in this module
	* @dependencies The list of dependencies for this module
	* @directory The base directory to create your model in and creates the directory if it does not exist. 
	**/
	function run( 	
		required name,
		title=arguments.name,
		author='',
		authorURL='',
		description="",
		version='1.0.0',
		cfmapping=arguments.name,
		modelNamespace=arguments.name,
		dependencies="",
		directory='modules'
	){						
		// This will make each directory canonical and absolute		
		arguments.directory = fileSystemUtil.resolvePath( arguments.directory );
		
		// Validate directory
		if( !directoryExists( arguments.directory ) ) {
			directoryCreate( arguments.directory );			
		}
		// This help readability so the success messages aren't up against the previous command line
		print.line();
		var basePath = GetDirectoryFromPath( GetCurrentTemplatePath() );

		var templateDir = basePath & "/../_templates";
		var zipFile     = templateDir & "/module.zip";

		/* Unpack template into modules directory */
		zip action="unzip" file="#zipFile#" destination="#arguments.directory#/#arguments.name#";

		
		// Read in Module Config
		var moduleConfig = fileRead( '#arguments.directory#/#arguments.name#/ModuleConfig.cfc' );
		
		// Start Generation Replacing
		moduleConfig = replaceNoCase( moduleConfig, '@title@', arguments.title, 'all');
		moduleConfig = replaceNoCase( moduleConfig, '@name@', arguments.name, 'all');
		moduleConfig = replaceNoCase( moduleConfig, '@author@', arguments.author, 'all');
		moduleConfig = replaceNoCase( moduleConfig, '@authorURL@', arguments.authorURL, 'all');
		moduleConfig = replaceNoCase( moduleConfig, '@description@', arguments.description, 'all');
		moduleConfig = replaceNoCase( moduleConfig, '@version@', arguments.version, 'all');
		moduleConfig = replaceNoCase( moduleConfig, '@cfmapping@', arguments.cfmapping, 'all');
		moduleConfig = replaceNoCase( moduleConfig, '@modelNamespace@', arguments.modelNamespace, 'all');
		moduleConfig = replaceNoCase( moduleConfig, '@dependencies@', serializeJSON( listToArray( arguments.dependencies ) ), 'all');
		

			
		// Write Out the New Config
		fileDelete( arguments.directory & '/#arguments.name#/ModuleConfig.cfc');
		fileWrite( arguments.directory & '/#arguments.name#/ModuleConfig.cfc', moduleConfig );
		
		var stuffAdded = directoryList( arguments.directory & '/#arguments.name#', true );
		print.greenLine( 'Created ' & arguments.directory & '/#arguments.name#' );
		for( var thing in stuffAdded ) {
			print.greenLine( 'Created ' & thing );			
		}
								
	}

}