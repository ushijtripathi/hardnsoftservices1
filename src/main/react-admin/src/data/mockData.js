export const dashboardMetrics = {
  totalSales: '₹12,45,000',
  activeInstallations: 84,
  lowInventoryAlerts: 12,
  recentInquiries: 28
};

export const products = [
  { id: 1, sku: 'CP-UNC-TA41L3', brand: 'CP Plus', category: 'CCTV Camera', price: '₹3,200', stock: 45, status: 'In Stock' },
  { id: 2, sku: 'GD-BIO-ACE100', brand: 'Godrej', category: 'Biometrics', price: '₹8,500', stock: 12, status: 'Low Stock' },
  { id: 3, sku: 'SE-DVR-8CH-PRO', brand: 'Secureye', category: 'DVR', price: '₹5,100', stock: 0, status: 'Out of Stock' },
  { id: 4, sku: 'CP-VNC-V21R3', brand: 'CP Plus', category: 'CCTV Camera', price: '₹2,800', stock: 120, status: 'In Stock' },
  { id: 5, sku: 'GD-SEC-CAM360', brand: 'Godrej', category: 'PTZ Camera', price: '₹12,000', stock: 5, status: 'Low Stock' },
];

export const leads = [
  { id: 101, customer: 'Sharma Enterprises', request: 'Installation quote for 4 CP Plus Dome Cameras', date: '2026-06-20', status: 'New' },
  { id: 102, customer: 'Verma Tech Solutions', request: 'Godrej Biometric System for 50 employees', date: '2026-06-19', status: 'Contacted' },
  { id: 103, customer: 'Rao Residents', request: 'Secureye 8CH DVR repair/replacement', date: '2026-06-18', status: 'Closed' },
  { id: 104, customer: 'Blue Bell School', request: 'Campus-wide CCTV surveillance upgrade', date: '2026-06-21', status: 'New' },
  { id: 105, customer: 'Apex Mall', request: 'Annual Maintenance Contract Inquiry', date: '2026-06-15', status: 'Contacted' },
];

export const staffRoster = [
  { id: 1, name: 'Rahul Kumar', role: 'Senior Technician', assignedJob: 'Sharma Enterprises - 4 Cameras', status: 'On Site' },
  { id: 2, name: 'Vikash Singh', role: 'Installer', assignedJob: 'None', status: 'Available' },
  { id: 3, name: 'Amit Patel', role: 'Technician', assignedJob: 'Rao Residents - DVR Repair', status: 'Completed' },
  { id: 4, name: 'Sanjay Gupta', role: 'System Architect', assignedJob: 'Blue Bell School Survey', status: 'Scheduled' },
];

export const revenueData = [
  { month: 'Jan', revenue: 650000 },
  { month: 'Feb', revenue: 720000 },
  { month: 'Mar', revenue: 850000 },
  { month: 'Apr', revenue: 810000 },
  { month: 'May', revenue: 950000 },
  { month: 'Jun', revenue: 1245000 },
];
