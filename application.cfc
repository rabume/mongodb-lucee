component displayname="Application" output="false" {
    
    public boolean function onApplicationStart() {

        application.mongoUsername = "root";
        application.mongoPassword = "defaultpass";
        application.mongoHost = "mongo";
        application.mongoPort = 27017;

        application.mongodb = MongoDBConnect("demo", "mongodb://#application.mongoUsername#:#application.mongoPassword#@#application.mongoHost#:#application.mongoPort#/demo?authSource=admin");
    
        return true;
    }
}
