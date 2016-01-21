Datastore = require('nedb')

config = require './../config/config'

db = {}
db.path = config.dbFilePath
db.users = new Datastore({ filename: db.path + 'users.db', autoload: true });
db.windows = new Datastore({ filename: db.path + 'windows.db', autoload: true });
db.foods = new Datastore({ filename: db.path + 'foods.db', autoload: true });

module.exports = db