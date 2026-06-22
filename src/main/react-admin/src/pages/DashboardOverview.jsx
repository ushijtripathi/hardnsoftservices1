import React from 'react';
import { IndianRupee, Activity, AlertTriangle, MessageSquare } from 'lucide-react';
import { dashboardMetrics, revenueData } from '../data/mockData';
import './DashboardOverview.css';

const DashboardOverview = () => {
  // A simple CSS-based bar chart for revenue
  const maxRevenue = Math.max(...revenueData.map(d => d.revenue));

  return (
    <div className="dashboard-overview fade-in">
      <div className="header-section">
        <h1>Dashboard Overview</h1>
        <p className="subtitle">Welcome back! Here's what's happening with your security business today.</p>
      </div>

      <div className="metrics-grid">
        <div className="metric-card">
          <div className="icon-wrapper blue">
            <IndianRupee size={24} />
          </div>
          <div className="metric-info">
            <h3>Total Sales</h3>
            <p className="value">{dashboardMetrics.totalSales}</p>
            <span className="trend positive">+12% from last month</span>
          </div>
        </div>

        <div className="metric-card">
          <div className="icon-wrapper green">
            <Activity size={24} />
          </div>
          <div className="metric-info">
            <h3>Active Installs</h3>
            <p className="value">{dashboardMetrics.activeInstallations}</p>
            <span className="trend positive">+5 new this week</span>
          </div>
        </div>

        <div className="metric-card">
          <div className="icon-wrapper red">
            <AlertTriangle size={24} />
          </div>
          <div className="metric-info">
            <h3>Low Inventory</h3>
            <p className="value">{dashboardMetrics.lowInventoryAlerts}</p>
            <span className="trend negative">Needs attention</span>
          </div>
        </div>

        <div className="metric-card">
          <div className="icon-wrapper orange">
            <MessageSquare size={24} />
          </div>
          <div className="metric-info">
            <h3>New Inquiries</h3>
            <p className="value">{dashboardMetrics.recentInquiries}</p>
            <span className="trend neutral">8 pending replies</span>
          </div>
        </div>
      </div>

      <div className="charts-section">
        <div className="card chart-card">
          <h3 className="card-title">Monthly Revenue</h3>
          <div className="bar-chart-container">
            <div className="bar-chart">
              {revenueData.map((data, index) => {
                const height = (data.revenue / maxRevenue) * 100;
                return (
                  <div key={index} className="bar-wrapper">
                    <div className="bar-tooltip">₹{(data.revenue / 100000).toFixed(1)}L</div>
                    <div className="bar" style={{ height: `${height}%` }}></div>
                    <span className="bar-label">{data.month}</span>
                  </div>
                );
              })}
            </div>
          </div>
        </div>
      </div>
    </div>
  );
};

export default DashboardOverview;
