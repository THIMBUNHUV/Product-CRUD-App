const express = require('express');
const router = express.Router();
const controller = require('../controllers/productController');

router.get('/products', controller.getAllProducts);
router.get('/products', controller.getProductById);
router.post('/products', controller.createProduct);
router.put('/products', controller.updateProduct);
router.delete('/products', controller.deleteProduct);

module.exports = router;
