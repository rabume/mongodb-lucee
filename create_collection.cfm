<cfscript>
    // This file is needed to create a collection with validation
    // With the options that the lucee extension gives you, I was not able to create
    // validation options. 
    // This is a work around, by directly calling the java libaries and calling the needed functions

    connectionString = "mongodb://#application.mongoUsername#:#application.mongoPassword#@#application.mongoHost#:#application.mongoPort#/demo?authSource=admin";

    mongoConnectionString = loadClass( "com.mongodb.ConnectionString" )
        .init( connectionString )
    ;

    mongoClient = loadClass( "com.mongodb.client.MongoClients" )
        .create( mongoConnectionString )
    ;
    
    mongoCreateCollectionOptions = loadClass( "com.mongodb.client.model.CreateCollectionOptions" );

    mongoValidator = loadClass( "com.mongodb.client.model.ValidationOptions" );

    db = mongoClient.getDatabase(mongoConnectionString.getDatabase());

    optionValidation = mongoValidator.validator(
        toBson(
            [
                "$jsonSchema": {
                    "bsonType": 'object',
                    "required": [ 'severity', 'operation', 'data' ],
                    "properties": {
                        "severity": {
                            "bsonType": 'double',
                            "description": 'Must be a double and is required!'
                        },
                        "operation": {
                            "bsonType": 'string',
                            "description": 'Must be a string and is required!'
                        },                        
                        "data": {
                            "bsonType": 'object',
                            "required": [ 'message' ],
                            "properties": {
                                "message": {
                                    "bsonType": 'string',
                                    "description": 'Must be a string and is required!'
                                }
                            }
                        }
                    }
                }
            ]
        )
    );

    // Output the validation rules
    dump(mongoValidator.getValidator());


    // Create the collections logs with the above defined validation options
    if(!application.mongodb.collectionExists("logs")) {
        db.createCollection("logs", mongoCreateCollectionOptions.validationOptions(optionValidation));
    }
    
    // Functions 
    // https://www.bennadel.com/blog/3905-getting-mongodb-database-and-collection-names-from-the-connection-string-in-lucee-cfml-5-3-6-61.htm
	public any function loadClass( required string className ) {
		return( createObject( "java", className ) );
	}

	public any function toBson( required struct orderedKeyValuePairs ) {
		return( loadClass( "org.bson.Document" ).init( orderedKeyValuePairs ) );
	}
	
	public struct function fromBson( required any bsonDocument ) {
		var unwrappedStruct = structNew( "linked" ).append( bsonDocument );
		loop
			index = "local.key"
			item = "local.value"
			struct = unwrappedStruct
			{
			if ( ! isNull( value ) && isStruct( value ) ) {
				unwrappedStruct[ key ] = fromBson( value );
			}
		}
		return( unwrappedStruct );
	}

</cfscript>