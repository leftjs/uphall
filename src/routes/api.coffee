express = require 'express'
router = express.Router()
db = require './../libs/db'

router.get '/faq', (req,res,next) ->
  db.users.insert({test:'1'}, (err,doc)->
    return next(err) if err
    res.json(doc)
  )


module.exports = router