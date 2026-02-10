create database Dairy_Procurement_system;
use Dairy_Procurement_system;
-- 1. Farmer
CREATE TABLE Farmer (
    FarmerID INT AUTO_INCREMENT PRIMARY KEY,
    Name VARCHAR(100) NOT NULL,
    ContactNo VARCHAR(15),
    Address VARCHAR(255),
    BankAccount VARCHAR(30),
    IFSCCode VARCHAR(15),
    Village VARCHAR(100),
    District VARCHAR(100),
    State VARCHAR(100)
);

-- 2. Animal
CREATE TABLE Animal (
    AnimalID INT AUTO_INCREMENT PRIMARY KEY,
    FarmerID INT,
    Type VARCHAR(50),
    Breed VARCHAR(50),
    Age INT,
    DailyMilkYield DECIMAL(5,2),
    FOREIGN KEY (FarmerID) REFERENCES Farmer(FarmerID)
);

-- 3. CollectionCenter
CREATE TABLE CollectionCenter (
    CenterID INT AUTO_INCREMENT PRIMARY KEY,
    Name VARCHAR(100) NOT NULL,
    Location VARCHAR(255),
    Capacity DECIMAL(10,2),
    ManagerName VARCHAR(100),
    ContactNo VARCHAR(15)
);

-- 4. MilkCollection
CREATE TABLE MilkCollection (
    CollectionID INT AUTO_INCREMENT PRIMARY KEY,
    FarmerID INT,
    CenterID INT,
    Date DATE,
    Quantity DECIMAL(8,2),
    FatPercentage DECIMAL(4,2),
    SNF DECIMAL(4,2),
    Shift ENUM('Morning','Evening'),
    FOREIGN KEY (FarmerID) REFERENCES Farmer(FarmerID),
    FOREIGN KEY (CenterID) REFERENCES CollectionCenter(CenterID)
);

-- 5. QualityTest
CREATE TABLE QualityTest (
    TestID INT AUTO_INCREMENT PRIMARY KEY,
    CollectionID INT,
    Fat DECIMAL(4,2),
    SNF DECIMAL(4,2),
    AdulterationCheck ENUM('Pass','Fail'),
    MicrobialCount INT,
    Result ENUM('Accept','Reject'),
    FOREIGN KEY (CollectionID) REFERENCES MilkCollection(CollectionID)
);

-- 6. Transporter
CREATE TABLE Transporter (
    TransporterID INT AUTO_INCREMENT PRIMARY KEY,
    Name VARCHAR(100),
    ContactNo VARCHAR(15),
    LicenseNo VARCHAR(50),
    Address VARCHAR(255)
);

-- 7. Vehicle
CREATE TABLE Vehicle (
    VehicleID INT AUTO_INCREMENT PRIMARY KEY,
    TransporterID INT,
    VehicleNumber VARCHAR(20) UNIQUE,
    Capacity DECIMAL(8,2),
    Type VARCHAR(50),
    Status ENUM('Active','Inactive'),
    FOREIGN KEY (TransporterID) REFERENCES Transporter(TransporterID)
);

-- 8. RoutePlan
CREATE TABLE RoutePlan (
    RouteID INT AUTO_INCREMENT PRIMARY KEY,
    VehicleID INT,
    StartPoint VARCHAR(100),
    EndPoint VARCHAR(100),
    Distance DECIMAL(8,2),
    Duration TIME,
    FOREIGN KEY (VehicleID) REFERENCES Vehicle(VehicleID)
);

-- 9. Shipment
CREATE TABLE Shipment (
    ShipmentID INT AUTO_INCREMENT PRIMARY KEY,
    RouteID INT,
    CollectionID INT,
    DepartureTime DATETIME,
    ArrivalTime DATETIME,
    Quantity DECIMAL(8,2),
    Status ENUM('Pending','In Transit','Delivered'),
    FOREIGN KEY (RouteID) REFERENCES RoutePlan(RouteID),
    FOREIGN KEY (CollectionID) REFERENCES MilkCollection(CollectionID)
);

-- 10. ProcessingPlant
CREATE TABLE ProcessingPlant (
    PlantID INT AUTO_INCREMENT PRIMARY KEY,
    Name VARCHAR(100),
    Location VARCHAR(255),
    Capacity DECIMAL(10,2),
    ManagerName VARCHAR(100),
    ContactNo VARCHAR(15)
);

-- 11. Inventory
CREATE TABLE Inventory (
    InventoryID INT AUTO_INCREMENT PRIMARY KEY,
    PlantID INT,
    ProductID INT,
    Quantity DECIMAL(10,2),
    Unit VARCHAR(20),
    ExpiryDate DATE,
    FOREIGN KEY (PlantID) REFERENCES ProcessingPlant(PlantID)
);

-- 12. Product
CREATE TABLE Product (
    ProductID INT AUTO_INCREMENT PRIMARY KEY,
    Name VARCHAR(100),
    Type VARCHAR(50),
    UnitPrice DECIMAL(10,2),
    Description TEXT
);

-- 13. Distributor
CREATE TABLE Distributor (
    DistributorID INT AUTO_INCREMENT PRIMARY KEY,
    Name VARCHAR(100),
    ContactNo VARCHAR(15),
    Address VARCHAR(255),
    Region VARCHAR(100)
);

-- 14. Retailer
CREATE TABLE Retailer (
    RetailerID INT AUTO_INCREMENT PRIMARY KEY,
    DistributorID INT,
    Name VARCHAR(100),
    ContactNo VARCHAR(15),
    Address VARCHAR(255),
    FOREIGN KEY (DistributorID) REFERENCES Distributor(DistributorID)
);

-- 15. Customer
CREATE TABLE Customer (
    CustomerID INT AUTO_INCREMENT PRIMARY KEY,
    Name VARCHAR(100),
    ContactNo VARCHAR(15),
    Address VARCHAR(255),
    PaymentPreference ENUM('Cash','Online','Card')
);

-- 16. ProcurementOrder
CREATE TABLE ProcurementOrder (
    OrderID INT AUTO_INCREMENT PRIMARY KEY,
    FarmerID INT,
    Date DATE,
    Quantity DECIMAL(8,2),
    RatePerLitre DECIMAL(6,2),
    TotalAmount DECIMAL(10,2),
    FOREIGN KEY (FarmerID) REFERENCES Farmer(FarmerID)
);

-- 17. Payments
CREATE TABLE Payments (
    PaymentID INT AUTO_INCREMENT PRIMARY KEY,
    OrderID INT,
    FarmerID INT,
    AmountPaid DECIMAL(10,2),
    Date DATE,
    Mode ENUM('Cash','Online','BankTransfer'),
    TransactionRef VARCHAR(50),
    FOREIGN KEY (OrderID) REFERENCES ProcurementOrder(OrderID),
    FOREIGN KEY (FarmerID) REFERENCES Farmer(FarmerID)
);

-- 18. AdulterationLog
CREATE TABLE AdulterationLog (
    LogID INT AUTO_INCREMENT PRIMARY KEY,
    CollectionID INT,
    IssueType VARCHAR(100),
    Remarks TEXT,
    ActionTaken VARCHAR(255),
    Date DATE,
    FOREIGN KEY (CollectionID) REFERENCES MilkCollection(CollectionID)
);

INSERT INTO Farmer (FarmerID, Name, ContactNo, Address, BankAccount, IFSCCode, Village, District, State) VALUES
(1, 'Ramesh Kumar', '9876543210', 'Village A', '1234567890', 'SBI000123', 'Rampur', 'Kanpur', 'Uttar Pradesh'),
(2, 'Sita Devi', '9123456780', 'Village B', '2345678901', 'PNB000456', 'Lakshmipur', 'Varanasi', 'Uttar Pradesh'),
(3, 'Harish Patel', '9988776655', 'Village C', '3456789012', 'BOB000789', 'Bhavnagar', 'Ahmedabad', 'Gujarat'),
(4, 'Meena Sharma', '9876012345', 'Village D', '4567890123', 'HDFC000111', 'Sundarpur', 'Jaipur', 'Rajasthan'),
(5, 'Anil Singh', '9765432109', 'Village E', '5678901234', 'ICIC000222', 'Rajapur', 'Lucknow', 'Uttar Pradesh');

INSERT INTO Animal (AnimalID, FarmerID, Type, Breed, Age, DailyMilkYield) VALUES
(1, 1, 'Cow', 'Gir', 5, 12.5),
(2, 1, 'Buffalo', 'Murrah', 6, 10.0),
(3, 2, 'Cow', 'Sahiwal', 4, 14.0),
(4, 2, 'Buffalo', 'Nili Ravi', 5, 9.5),
(5, 3, 'Cow', 'Jersey', 3, 15.0),
(6, 4, 'Cow', 'Holstein Friesian', 7, 18.0),
(7, 5, 'Buffalo', 'Murrah', 6, 11.0);

INSERT INTO CollectionCenter (CenterID, Name, Location, Capacity, ManagerName, ContactNo) VALUES
(1, 'Center A', 'Rampur', 500, 'Rajesh Gupta', '9811122233'),
(2, 'Center B', 'Lakshmipur', 700, 'Sunita Verma', '9822233344'),
(3, 'Center C', 'Bhavnagar', 600, 'Prakash Yadav', '9833344455');

INSERT INTO MilkCollection (CollectionID, FarmerID, CenterID, Date, Quantity, FatPercentage, SNF, Shift) VALUES
(1, 1, 1, '2025-08-01', 20.0, 4.2, 8.5, 'Morning'),
(2, 1, 1, '2025-08-01', 15.0, 4.0, 8.3, 'Evening'),
(3, 2, 2, '2025-08-01', 25.0, 4.5, 8.7, 'Morning'),
(4, 3, 3, '2025-08-01', 18.0, 4.1, 8.6, 'Morning'),
(5, 4, 2, '2025-08-02', 22.0, 4.4, 8.8, 'Evening'),
(6, 5, 1, '2025-08-02', 17.0, 4.3, 8.5, 'Morning'),
(7, 3, 3, '2025-08-03', 19.0, 4.0, 8.4, 'Morning'),
(8, 2, 2, '2025-08-03', 20.0, 4.6, 8.7, 'Evening');

INSERT INTO QualityTest (TestID, CollectionID, Fat, SNF, AdulterationCheck, MicrobialCount, Result) VALUES
(1, 1, 4.2, 8.5, 'Pass', 15000, 'Accept'),
(2, 2, 4.0, 8.3, 'Pass', 18000, 'Accept'),
(3, 3, 4.5, 8.7, 'Pass', 12000, 'Accept'),
(4, 4, 4.1, 8.6, 'Fail', 30000, 'Reject'),
(5, 5, 4.4, 8.8, 'Pass', 16000, 'Accept'),
(6, 6, 4.3, 8.5, 'Pass', 14000, 'Accept'),
(7, 7, 4.0, 8.4, 'Fail', 32000, 'Reject'),
(8, 8, 4.6, 8.7, 'Pass', 15000, 'Accept');

INSERT INTO Transporter (TransporterID, Name, ContactNo, LicenseNo, Address) VALUES
(1, 'Sharma Logistics', '9877001122', 'LIC1234UP', 'Kanpur, UP'),
(2, 'Patel Transport', '9877001133', 'LIC5678GJ', 'Ahmedabad, Gujarat'),
(3, 'Verma Carriers', '9877001144', 'LIC9876RJ', 'Jaipur, Rajasthan');

INSERT INTO Vehicle (VehicleID, TransporterID, VehicleNumber, Type, Capacity, DriverName, DriverContact) VALUES
(1, 1, 'UP32AB1234', 'Tanker', 500, 'Mukesh Yadav', '9810011122'),
(2, 1, 'UP32CD5678', 'Tanker', 700, 'Ravi Kumar', '9810011133'),
(3, 2, 'GJ01XY1234', 'Insulated Truck', 800, 'Jignesh Patel', '9810011144'),
(4, 3, 'RJ14PQ9876', 'Tanker', 600, 'Mahesh Sharma', '9810011155');












