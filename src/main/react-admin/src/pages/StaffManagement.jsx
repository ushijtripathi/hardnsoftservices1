import React from 'react';
import { staffRoster } from '../data/mockData';

const StaffManagement = () => {
  return (
    <div className="product-management fade-in">
      <div className="page-header">
        <div>
          <h1>Staff Roster</h1>
          <p className="subtitle">Track technician assignments and availability</p>
        </div>
      </div>

      <div className="card">
        <div className="table-container">
          <table>
            <thead>
              <tr>
                <th>Name</th>
                <th>Role</th>
                <th>Assigned Job</th>
                <th>Status</th>
              </tr>
            </thead>
            <tbody>
              {staffRoster.map((staff) => (
                <tr key={staff.id}>
                  <td className="font-medium">{staff.name}</td>
                  <td>{staff.role}</td>
                  <td>{staff.assignedJob}</td>
                  <td>
                    <span className={`status-tag ${
                      staff.status === 'Available' ? 'green' : 
                      staff.status === 'On Site' ? 'blue' : 
                      staff.status === 'Completed' ? 'neutral' : 'orange'
                    }`}>
                      {staff.status}
                    </span>
                  </td>
                </tr>
              ))}
            </tbody>
          </table>
        </div>
      </div>
    </div>
  );
};

export default StaffManagement;
