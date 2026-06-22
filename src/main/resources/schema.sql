-- Schema for hardnsoft website database

CREATE DATABASE IF NOT EXISTS hardnsoft;
USE hardnsoft;

-- Users table
CREATE TABLE IF NOT EXISTS users (
    username VARCHAR(50) NOT NULL,
    password VARCHAR(50) NOT NULL,
    email VARCHAR(100) NOT NULL PRIMARY KEY
);

-- Items table for products and software catalog
CREATE TABLE IF NOT EXISTS items (
    id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    description TEXT,
    price DOUBLE NOT NULL,
    image_url VARCHAR(255),
    category VARCHAR(50),
    type VARCHAR(20) -- 'hardware' or 'software'
);

-- Clear existing items
TRUNCATE TABLE items;

-- Insert Seed hardware products (CP Plus, Godrej, Secureye, Prama)
INSERT INTO items (name, description, price, image_url, category, type) VALUES
('CP Plus Full HD Dome Camera', 'Model: CP-UNC-DA21L3 | 2MP resolution, 30m Smart IR Night Vision, IP67 Waterproof, PoE support, ideal for indoor surveillance.', 2499.00, 'pictures/cam.jpg', 'dome', 'hardware'),
('Prama HD Bullet Camera', 'Model: PT-HAC-B1A21 | 2MP Bullet, high performance CMOS, smart IR up to 20m, IP66 weather-proof casing for outdoor security.', 1899.00, 'https://images.unsplash.com/photo-1557597774-951872b3fc40?q=80&w=400', 'bullet', 'hardware'),
('Secureye 4MP PTZ Speed Dome', 'Model: S-PTZ4M | Pan-Tilt-Zoom intelligent speed dome camera, 10x Optical Zoom, Auto Human Tracking, 360-degree rotation.', 12499.00, 'https://images.unsplash.com/photo-1557597774-951872b3fc40?q=80&w=400', 'ptz', 'hardware'),
('Godrej SecreSafe Biometric Access Control', 'Model: G-SECRESAFE | Dual authentication (Fingerprint + RFID card), stores 3000 templates, built-in attendance logging and software.', 8999.00, 'https://images.unsplash.com/photo-1558002038-1055907df827?q=80&w=400', 'biometrics', 'hardware'),
('Godrej Solus 7" Video Door Phone', 'Model: G-SOLUS7 | High resolution 7-inch color display indoor monitor with weatherproof outdoor camera module, hands-free audio.', 6499.00, 'https://images.unsplash.com/photo-1558002038-1055907df827?q=80&w=400', 'videodoor', 'hardware'),
('CP Plus 8-Channel NVR', 'Model: CP-UNR-108F1 | Network Video Recorder supporting up to 8 channels of 4K IP cameras, H.265+ encoding, up to 10TB storage.', 5499.00, 'pictures/hdd.jpg', 'nvr', 'hardware');

-- Insert Seed software licenses
INSERT INTO items (name, description, price, image_url, category, type) VALUES
('HNS Defend Pro (1 Year)', 'Advanced AI-driven malware, spyware, and complex ransomware prevention protocols optimized across localized corporate workstations.', 4500.00, 'endpoint', 'endpoint', 'software'),
('Sentinel Network OS v3.0', 'Next-generation perimeter firewall packing deep packet inspection, automated layer threats mitigation, and intuitive traffic shape engines.', 28000.00, 'firewall', 'firewall', 'software'),
('Vault Sync - 5TB Cloud', 'Automated real-time background daily server storage dumps encrypted under secure end-to-end private system network token locks.', 12000.00, 'cloud', 'cloud', 'software');

-- Dealer inquiries table
CREATE TABLE IF NOT EXISTS dealer_inquiries (
    id INT AUTO_INCREMENT PRIMARY KEY,
    full_name VARCHAR(100) NOT NULL,
    company_name VARCHAR(100) NOT NULL,
    email VARCHAR(100) NOT NULL,
    volume_range VARCHAR(50) NOT NULL,
    details TEXT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Contact messages table
CREATE TABLE IF NOT EXISTS contact_messages (
    id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    email VARCHAR(100) NOT NULL,
    inquiry_type VARCHAR(100) NOT NULL,
    message TEXT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Orders table
CREATE TABLE IF NOT EXISTS orders (
    id INT AUTO_INCREMENT PRIMARY KEY,
    user_email VARCHAR(100) NOT NULL,
    total_amount DOUBLE NOT NULL,
    status VARCHAR(50) DEFAULT 'Pending',
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Order Items table
CREATE TABLE IF NOT EXISTS order_items (
    id INT AUTO_INCREMENT PRIMARY KEY,
    order_id INT NOT NULL,
    item_name VARCHAR(100) NOT NULL,
    price DOUBLE NOT NULL,
    quantity INT NOT NULL,
    FOREIGN KEY (order_id) REFERENCES orders(id) ON DELETE CASCADE
);
