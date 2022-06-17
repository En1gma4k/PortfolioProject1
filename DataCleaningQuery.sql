SELECT *
FROM PortfolioProject.dbo.NashvilleHousing

--changing sales date format

SELECT SalesDateFixed
FROM PortfolioProject.dbo.NashvilleHousing

ALTER TABLE PortfolioProject.dbo.NashvilleHousing
ADD SalesDateFixed DATE;

UPDATE PortfolioProject.dbo.NashvilleHousing
SET SalesDateFixed = CONVERT(date,SaleDate)

--Populating property address data

SELECT *
FROM PortfolioProject.dbo.NashvilleHousing
WHERE PropertyAddress IS NULL


SELECT *
FROM PortfolioProject.dbo.NashvilleHousing x
JOIN PortfolioProject.dbo.NashvilleHousing y
     ON x.ParcelID = y.ParcelID
	 AND x.[UniqueID ] != y.[UniqueID ]
--WHERE x.PropertyAddress IS NULL 

UPDATE x
SET PropertyAddress = ISNULL(x.PropertyAddress,y.PropertyAddress)
FROM PortfolioProject.dbo.NashvilleHousing x
JOIN PortfolioProject.dbo.NashvilleHousing y
     ON x.ParcelID = y.ParcelID
	 AND x.[UniqueID ] != y.[UniqueID ]
WHERE x.PropertyAddress IS NULL 


--Breaking Address into Individual columns(Address,City,State)

SELECT PropertyAddress
FROM PortfolioProject.dbo.NashvilleHousing

SELECT 
SUBSTRING(PropertyAddress, 1, CHARINDEX(',' , PropertyAddress) -1) as Address,
SUBSTRING(PropertyAddress, CHARINDEX(',' , PropertyAddress) +1, LEN(PropertyAddress)) as City
FROM PortfolioProject.dbo.NashvilleHousing

ALTER TABLE PortfolioProject.dbo.NashvilleHousing
ADD PropertySplitAddress nvarchar(255);

UPDATE PortfolioProject.dbo.NashvilleHousing
SET PropertySplitAddress = SUBSTRING(PropertyAddress, 1, CHARINDEX(',' , PropertyAddress) -1)

ALTER TABLE PortfolioProject.dbo.NashvilleHousing
ADD PropertyCity nvarchar(255);

UPDATE PortfolioProject.dbo.NashvilleHousing
SET PropertyCity = SUBSTRING(PropertyAddress, CHARINDEX(',' , PropertyAddress) +1, LEN(PropertyAddress))

SELECT * 
FROM PortfolioProject.dbo.NashvilleHousing

SELECT
PARSENAME(REPLACE(OwnerAddress, ',', '.'),3),
PARSENAME(REPLACE(OwnerAddress, ',', '.'),2),
PARSENAME(REPLACE(OwnerAddress, ',', '.'),1)
FROM PortfolioProject.dbo.NashvilleHousing

ALTER TABLE PortfolioProject.dbo.NashvilleHousing
ADD OwnerSplitAddress nvarchar(255);

UPDATE PortfolioProject.dbo.NashvilleHousing
SET OwnerSplitAddress = PARSENAME(REPLACE(OwnerAddress, ',', '.'),3)

ALTER TABLE PortfolioProject.dbo.NashvilleHousing
ADD OwnerCity nvarchar(255);

UPDATE PortfolioProject.dbo.NashvilleHousing
SET OwnerCity = PARSENAME(REPLACE(OwnerAddress, ',', '.'),2)

ALTER TABLE PortfolioProject.dbo.NashvilleHousing
ADD OwnerState nvarchar(255);

UPDATE PortfolioProject.dbo.NashvilleHousing
SET OwnerState = PARSENAME(REPLACE(OwnerAddress, ',', '.'),1)


--Change Y & N to Yes & No in "Sold as Vacant" Column

SELECT DISTINCT(SoldAsVacant), Count(SoldAsVacant)
FROM PortfolioProject.dbo.NashvilleHousing
GROUP BY SoldAsVacant
ORDER BY 2

SELECT SoldAsVacant,
CASE WHEN SoldAsVacant = 'Y' THEN 'Yes'
     WHEN SoldAsVacant = 'N' THEN 'No'
	 ELSE SoldAsVacant
	 END
FROM PortfolioProject.dbo.NashvilleHousing

UPDATE PortfolioProject.dbo.NashvilleHousing
SET SoldAsVacant = CASE 
                        WHEN SoldAsVacant = 'Y' THEN 'Yes'
                        WHEN SoldAsVacant = 'N' THEN 'No'
	                    ELSE SoldAsVacant
	                    END

-- Deleting redundant columns

SELECT * 
FROM PortfolioProject.dbo.NashvilleHousing

ALTER TABLE PortfolioProject.dbo.NashvilleHousing
DROP COLUMN PropertyAddress, SaleDate, OwnerAddress

