import React from 'react';
import { Search, Bell, Menu } from 'lucide-react';
import './TopHeader.css';

const TopHeader = ({ toggleSidebar }) => {
  return (
    <header className="top-header">
      <div className="header-left">
        <button className="menu-btn" onClick={toggleSidebar}>
          <Menu size={24} />
        </button>
        <div className="search-bar">
          <Search className="search-icon" size={18} />
          <input type="text" placeholder="Search products, leads..." />
        </div>
      </div>
      
      <div className="header-right">
        <button className="icon-btn notification-btn">
          <Bell size={20} />
          <span className="badge">3</span>
        </button>
        <div className="profile">
          <div className="avatar">A</div>
          <div className="profile-info">
            <span className="name">Admin User</span>
            <span className="role">Super Admin</span>
          </div>
        </div>
      </div>
    </header>
  );
};

export default TopHeader;
