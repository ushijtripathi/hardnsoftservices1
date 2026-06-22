import React, { useState } from 'react';
import { Plus, Edit2, Trash2, Search } from 'lucide-react';
import { products } from '../data/mockData';
import './ProductManagement.css';

const ProductManagement = () => {
  const [searchTerm, setSearchTerm] = useState('');

  const filteredProducts = products.filter(product => 
    product.sku.toLowerCase().includes(searchTerm.toLowerCase()) ||
    product.brand.toLowerCase().includes(searchTerm.toLowerCase()) ||
    product.category.toLowerCase().includes(searchTerm.toLowerCase())
  );

  return (
    <div className="product-management fade-in">
      <div className="page-header">
        <div>
          <h1>Product Management</h1>
          <p className="subtitle">Manage inventory for CCTVs, DVRs, and Biometrics</p>
        </div>
        <button className="btn-primary">
          <Plus size={18} />
          Add Product
        </button>
      </div>

      <div className="card">
        <div className="table-controls">
          <div className="search-bar">
            <Search className="search-icon" size={18} />
            <input 
              type="text" 
              placeholder="Search products by SKU, brand, or category..." 
              value={searchTerm}
              onChange={(e) => setSearchTerm(e.target.value)}
            />
          </div>
        </div>

        <div className="table-container">
          <table>
            <thead>
              <tr>
                <th>SKU</th>
                <th>Brand</th>
                <th>Category</th>
                <th>Price</th>
                <th>Stock</th>
                <th>Status</th>
                <th>Actions</th>
              </tr>
            </thead>
            <tbody>
              {filteredProducts.map((product) => (
                <tr key={product.id}>
                  <td className="font-medium">{product.sku}</td>
                  <td>{product.brand}</td>
                  <td>{product.category}</td>
                  <td>{product.price}</td>
                  <td>{product.stock}</td>
                  <td>
                    <span className={`status-tag ${
                      product.status === 'In Stock' ? 'green' : 
                      product.status === 'Low Stock' ? 'orange' : 'red'
                    }`}>
                      {product.status}
                    </span>
                  </td>
                  <td>
                    <div className="actions">
                      <button className="action-btn edit" title="Edit">
                        <Edit2 size={16} />
                      </button>
                      <button className="action-btn delete" title="Delete">
                        <Trash2 size={16} />
                      </button>
                    </div>
                  </td>
                </tr>
              ))}
              {filteredProducts.length === 0 && (
                <tr>
                  <td colSpan="7" className="empty-state">No products found matching your search.</td>
                </tr>
              )}
            </tbody>
          </table>
        </div>
      </div>
    </div>
  );
};

export default ProductManagement;
