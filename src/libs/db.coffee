Datastore = require('nedb')

config = require './../config/config'

db = {}
db.path = config.dbFilePath
db.users = new Datastore({ filename: db.path + 'users.db', autoload: true });
db.shops = new Datastore({ filename: db.path + 'shop.db', autoload: true });

module.exports = db