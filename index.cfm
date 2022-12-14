<cfscript>

    // Insert a valid data in to collection
    application.mongodb["logs"].insert( 
        { 
            "severity": 1,
            "operation": "Registration",
            "data": {"message": "yeet", "test": 1, "yeet": "dgsg"}
        } 
    )

    // Example of not valid data for collection
    /*  
    application.mongodb["logs"].insert( 
        { 
            "severity": "invalid",
            "operation": "invalid",
            "data": "invalid"
        } 
    ) 
    */
    
    // Get full collection
    fullCollection = application.mongodb.getCollection("logs")
    dump(fullCollection);  
    
</cfscript>