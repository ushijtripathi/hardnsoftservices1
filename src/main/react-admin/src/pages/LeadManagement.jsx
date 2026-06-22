import React, { useState } from 'react';
import { Search, ExternalLink } from 'lucide-react';
import { leads } from '../data/mockData';

const LeadManagement = () => {
  const [searchTerm, setSearchTerm] = useState('');

  const filteredLeads = leads.filter(lead => 
    lead.customer.toLowerCase().includes(searchTerm.toLowerCase()) ||
    lead.request.toLowerCase().includes(searchTerm.toLowerCase())
  );

  return (
    <div className="product-management fade-in">
      <div className="page-header">
        <div>
          <h1>Lead & Inquiry Management</h1>
          <p className="subtitle">Track customer inquiries and project quotes</p>
        </div>
      </div>

      <div className="card">
        <div className="table-controls">
          <div className="search-bar">
            <Search className="search-icon" size={18} />
            <input 
              type="text" 
              placeholder="Search by customer or request..." 
              value={searchTerm}
              onChange={(e) => setSearchTerm(e.target.value)}
            />
          </div>
        </div>

        <div className="table-container">
          <table>
            <thead>
              <tr>
                <th>ID</th>
                <th>Customer Name</th>
                <th>Request Details</th>
                <th>Date</th>
                <th>Status</th>
                <th>Actions</th>
              </tr>
            </thead>
            <tbody>
              {filteredLeads.map((lead) => (
                <tr key={lead.id}>
                  <td className="font-medium">#{lead.id}</td>
                  <td>{lead.customer}</td>
                  <td>{lead.request}</td>
                  <td>{lead.date}</td>
                  <td>
                    <span className={`status-tag ${
                      lead.status === 'New' ? 'blue' : 
                      lead.status === 'Contacted' ? 'orange' : 'green'
                    }`}>
                      {lead.status}
                    </span>
                  </td>
                  <td>
                    <button className="action-btn edit" title="View Details">
                      <ExternalLink size={16} />
                    </button>
                  </td>
                </tr>
              ))}
              {filteredLeads.length === 0 && (
                <tr>
                  <td colSpan="6" className="empty-state">No leads found matching your search.</td>
                </tr>
              )}
            </tbody>
          </table>
        </div>
      </div>
    </div>
  );
};

export default LeadManagement;
