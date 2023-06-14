use SQL_Cleaning_Project;

--Viewing top 1000 rows in each column
SELECT TOP 1000 *
FROM NationalHousing;

--viewing data data column
SELECT SaleDate
FROM NationalHousing;

--Standarizing the Date format
SELECT SaleDate, convert(Date, SaleDate)
FROM NationalHousing;

ALTER TABLE NationalHousing
ADD SaleDateClean DATE;

UPDATE NationalHousing
SET SaleDateClean = convert(Date, SaleDate);


SELECT SaleDateClean
FROM NationalHousing;

--Droping the original SaleDate column which is unconverted
ALTER TABLE NationalHousing
DROP COLUMN SaleDate;

-- Renaming the new SaleDate column
EXEC sp_rename 'NationalHousing.SaleDateClean', 'SaleDate', 'COLUMN';

--Populating property Address data
Select PropertyAddress
from NationalHousing
where PropertyAddress is null;

select a.PropertyAddress, a.ParcelID, b.ParcelID, b.PropertyAddress, ISNULL(a.PropertyAddress, b.PropertyAddress)
from NationalHousing a
join NationalHousing b
ON  a.ParcelID = b.ParcelID
AND a.[UniqueID ] <> b.[UniqueID ]
where a.PropertyAddress is null;


update a 
set PropertyAddress = ISNULL(a.PropertyAddress, b.PropertyAddress)
from NationalHousing a
join NationalHousing b
ON  a.ParcelID = b.ParcelID
AND a.[UniqueID ] <> b.[UniqueID ]
where a.PropertyAddress is null;


-- Breaking Property Address into indiviual columns of (Address, City, State)
select 
substring(PropertyAddress, 1, CHARINDEX(',', PropertyAddress)-1) AS Address
 ,substring(PropertyAddress, CHARINDEX(',', PropertyAddress)+1, LEN(PropertyAddress)) AS CITY
from NationalHousing;


ALTER TABLE NationalHousing
ADD AddressProperty Nvarchar(255);

update NationalHousing
SET AddressProperty = substring(PropertyAddress, 1, CHARINDEX(',', PropertyAddress)-1);

ALTER TABLE NationalHousing
ADD PropertyCity Nvarchar(255);

update NationalHousing
SET PropertyCity = substring(PropertyAddress, CHARINDEX(',', PropertyAddress)+1, LEN(PropertyAddress));



-- Splitting OwnerAddress Method 1
Select OwnerAddress
from NationalHousing;

select OwnerAddress,
substring(OwnerAddress, 1, CHARINDEX(',', OwnerAddress)-1) AS Address
 ,substring(PropertyAddress, CHARINDEX(',', PropertyAddress)+1, LEN(PropertyAddress)) AS CITY
 from NationalHousing;

 -- Splitting OwnerAddress Method 2
 select
 PARSENAME(replace(OwnerAddress, ',','.'),1) As State
  ,PARSENAME(replace(OwnerAddress, ',','.'),2) As City
   ,PARSENAME(replace(OwnerAddress, ',','.'),3) As Address
 from NationalHousing;

 
 ALTER TABLE NationalHousing
ADD OwnerCity Nvarchar(255);

 ALTER TABLE NationalHousing
ADD OwnerState Nvarchar(255);

 ALTER TABLE NationalHousing
ADD AddressOwner Nvarchar(255);

--AddressOwner
update NationalHousing
SET AddressOwner = PARSENAME(replace(OwnerAddress, ',','.'),3);

--OwnerState
update NationalHousing
SET OwnerState = PARSENAME(replace(OwnerAddress, ',','.'),1);

--OwnerCity
update NationalHousing
SET OwnerCity = PARSENAME(replace(OwnerAddress, ',','.'),2);


--VIEWING DISTINCT VALUES IN SOLDASVACANT COLUMN
select distinct(SoldAsVacant), COUNT(SoldAsVacant)
from NationalHousing
group by SoldAsVacant
order by 2;

--CHANGING 'Y' AND 'N' TO 'YES' AND 'NO' IN "SOLIDASVACANT" COLUMN
select SoldAsVacant
 , case when SoldAsVacant = 'Y' then 'Yes'
        when SoldAsVacant = 'N' then 'No'
		else SoldAsVacant
		end
from NationalHousing;


update NationalHousing
set SoldAsVacant = case when SoldAsVacant = 'Y' then 'Yes'
        when SoldAsVacant = 'N' then 'No'
		else SoldAsVacant
		end;


--Showing duplicates
WITH RowNumCTE AS(
select *,
    ROW_NUMBER() OVER (
	PARTITION BY PARCELID,
				 PropertyAddress,
				 SalePrice,
				 SaleDate,
				 LegalReference
				 ORDER BY
				   UniqueID
				   ) row_num

From NationalHousing
)

Select *
from  RowNumCTE
where row_num > 1
order by PropertyAddress;


--delecting the duplicates
WITH RowNumCTE AS(
select *,
    ROW_NUMBER() OVER (
	PARTITION BY PARCELID,
				 PropertyAddress,
				 SalePrice,
				 SaleDate,
				 LegalReference
				 ORDER BY
				   UniqueID
				   ) row_num

From NationalHousing
)

delete
from  RowNumCTE
where row_num > 1


