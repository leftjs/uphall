var commonBiz, express, router, userBiz;

express = require('express');

router = express.Router();

userBiz = require('./../bizs/userBiz');

commonBiz = require('./../bizs/commonBiz');

router.post('/register', userBiz.validateUserExist, userBiz.register);

router.post('/login', userBiz.login);

router.post('/autologin', userBiz.autoLogin);

router.get('/list');

router.put('/:id', userBiz.update);

router.get('/:id', commonBiz.authAndSetUserInfo, userBiz.getUser);

module.exports = router;
