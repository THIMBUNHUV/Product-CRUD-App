const { sql, config } = require('../config/dbConfig');

const getAllProducts = async (req, res) => {
    try {
        const pool = await sql.connect(config);
        const result = await pool.request().query('SELECT * FROM PRODUCTS');
        res.status(200).json(result.recordset);
    } catch (error) {
        res.status(500).json({ message: 'DB Error', error });
    }
};

const getProductById = async (req, res) => {
    const { id } = req.query;
    try {
        const pool = await sql.connect(config);
        const result = await pool.request()
            .input('id', sql.Int, id)
            .query('SELECT * FROM PRODUCTS WHERE PRODUCTID = @id');

        if (result.recordset.length === 0) {
            return res.status(404).json({ message: 'Product not found' });
        }

        res.status(200).json(result.recordset[0]);
    } catch (error) {
        res.status(500).json({ message: 'DB Error', error });
    }
};

const createProduct = async (req, res) => {
    const { PRODUCTNAME, PRICE, STOCK } = req.body;
    if (!PRODUCTNAME || PRICE <= 0 || STOCK < 0) {
        return res.status(400).json({ message: 'Invalid Input' });
    }
    try {
        const pool = await sql.connect(config);
        await pool.request()
            .input('name', sql.NVarChar, PRODUCTNAME)
            .input('price', sql.Decimal(10, 2), PRICE)
            .input('stock', sql.Int, STOCK)
            .query('INSERT INTO PRODUCTS (PRODUCTNAME, PRICE, STOCK) VALUES (@name, @price, @stock)');
        res.status(201).json({ message: 'Product Created' });
    } catch (error) {
        res.status(500).json({ message: 'DB Error', error });
    }
};

const updateProduct = async (req, res) => {
    const { id } = req.query;
    const { PRODUCTNAME, PRICE, STOCK } = req.body;
    if (!PRODUCTNAME || PRICE <= 0 || STOCK < 0) {
        return res.status(400).json({ message: 'Invalid Input' });
    }
    try {
        const pool = await sql.connect(config);
        const result = await pool.request()
            .input('id', sql.Int, id)
            .input('name', sql.NVarChar, PRODUCTNAME)
            .input('price', sql.Decimal(10, 2), PRICE)
            .input('stock', sql.Int, STOCK)
            .query('UPDATE PRODUCTS SET PRODUCTNAME=@name, PRICE=@price, STOCK=@stock WHERE PRODUCTID=@id');

        if (result.rowsAffected[0] === 0) {
            return res.status(404).json({ message: 'Product not found' });
        }

        res.status(200).json({ message: 'Product Updated' });
    } catch (error) {
        res.status(500).json({ message: 'DB Error', error });
    }
};

const deleteProduct = async (req, res) => {
    const { id } = req.query;
    try {
        const pool = await sql.connect(config);
        const result = await pool.request()
            .input('id', sql.Int, id)
            .query('DELETE FROM PRODUCTS WHERE PRODUCTID = @id');

        if (result.rowsAffected[0] === 0) {
            return res.status(404).json({ message: 'Product not found' });
        }

        res.status(200).json({ message: 'Product Deleted' });
    } catch (error) {
        res.status(500).json({ message: 'DB Error', error });
    }
};

module.exports = {
    getAllProducts,
    getProductById,
    createProduct,
    updateProduct,
    deleteProduct
};
