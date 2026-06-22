import React from 'react';
import { BrowserRouter, Routes, Route, Navigate } from 'react-router-dom';
import AdminLayout from './components/layout/AdminLayout';
import DashboardOverview from './pages/DashboardOverview';
import ProductManagement from './pages/ProductManagement';
import LeadManagement from './pages/LeadManagement';
import StaffManagement from './pages/StaffManagement';

function App() {
  return (
    <BrowserRouter>
      <Routes>
        <Route path="/" element={<Navigate to="/admin/dashboard" replace />} />
        <Route path="/admin" element={<AdminLayout />}>
          <Route index element={<Navigate to="dashboard" replace />} />
          <Route path="dashboard" element={<DashboardOverview />} />
          <Route path="products" element={<ProductManagement />} />
          <Route path="leads" element={<LeadManagement />} />
          <Route path="staff" element={<StaffManagement />} />
        </Route>
      </Routes>
    </BrowserRouter>
  );
}

export default App;
