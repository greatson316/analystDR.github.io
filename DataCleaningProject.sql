/* filtering for null values in property address column*/
SELECT * FROM nashville_housing
SELECT propertyaddress from nashville_housing
WHERE  propertyaddress is NULL;

/*populating and filtering for null values in  address using self join*/

SELECT nashvilleA.parcelid, nashvilleA.propertyaddress, nashvilleB.parcelid, nashvilleB.propertyaddress 
FROM nashville_housing AS nashvilleA
JOIN nashville_housing AS nashvilleB
ON nashvilleA.parcelid = nashvilleB.parcelid
AND nashvilleA.uniqueid != nashvilleB.uniqueid
WHERE nashvilleA.propertyaddress is NULL;



/*populating null values. NOTE;(COALESCE is used in case of ISNULL fucntion in postgre */

SELECT nashvilleA.parcelid, nashvilleA.propertyaddress, nashvilleB.parcelid, nashvilleB.propertyaddress,
COALESCE(nashvilleA.propertyaddress, nashvilleB.propertyaddress)
FROM nashville_housing AS nashvilleA
JOIN nashville_housing AS nashvilleB
ON nashvilleA.parcelid = nashvilleB.parcelid
AND nashvilleA.uniqueid != nashvilleB.uniqueid
WHERE nashvilleA.propertyaddress is NULL;


UPDATE nashville_housing
SET propertyaddress = COALESCE(nashvilleA.propertyaddress, nashvilleB.propertyaddress)
FROM nashville_housing AS nashvilleA
JOIN nashville_housing AS nashvilleB
ON nashvilleA.parcelid = nashvilleB.parcelid
AND nashvilleA.uniqueid != nashvilleB.uniqueid
WHERE nashvilleA.propertyaddress is NULL;

/*splitting propertyaddress into different columns,SPLIT_PART is used in place of SUBSTRING or  parsename func in postgre */
--SELECT *from nashville_housing

SELECT 
SPLIT_PART (propertyaddress :: TEXT, ',',1) AS address_number,
SPLIT_PART (propertyaddress :: TEXT, ',', 2) AS address_city from nashville_housing;

/* adding splited columns to the nashville housing table*/

ALTER TABLE nashville_housing
ADD property_split_address text

UPDATE nashville_housing 
SET property_split_address = SPLIT_PART (propertyaddress :: TEXT, ',',1); 

ALTER TABLE nashville_housing
ADD property_split_city text

UPDATE nashville_housing 
SET property_split_city = SPLIT_PART (propertyaddress :: TEXT, ',', 2);

/*spliting the owner address using SPLIT_PART function*/

SELECT * FROM nashville_housing

SELECT 
SPLIT_PART (owneraddress :: TEXT, ',',1) AS ownersplit_address,
SPLIT_PART (owneraddress :: TEXT, ',', 2) AS ownersplit_city,
SPLIT_PART (owneraddress :: TEXT, ',', 3)AS ownersplit_state from nashville_housing;

/* altering the table and adding the splited columns*/

ALTER TABLE nashville_housing
ADD ownersplit_address text

UPDATE nashville_housing 
SET ownersplit_address = SPLIT_PART (owneraddress :: TEXT, ',',1);

ALTER TABLE nashville_housing
ADD ownersplit_city text

UPDATE nashville_housing 
SET ownersplit_city = SPLIT_PART (owneraddress :: TEXT, ',', 2);

ALTER TABLE nashville_housing
ADD ownersplit_state text

UPDATE nashville_housing 
SET ownersplit_state = SPLIT_PART (owneraddress :: TEXT, ',', 3);

/*changing OR replacing Y & N to YES  and NO in soldasvacant column using CASE func*/

SELECT soldasvacant,
CASE WHEN soldasvacant ='Y' THEN  'Yes'
     WHEN soldasvacant  ='N'THEN  'No'
     ELSE soldasvacant
     END
     FROM nashville_housing;

UPDATE nashville_housing 
SET soldasvacant = CASE WHEN soldasvacant ='Y' THEN  'Yes'
     WHEN soldasvacant  ='N'THEN  'No'
     ELSE soldasvacant
     END;
  
 /* Deleting unused columns using DROP func*/
 SELECT * FROM nashville_housing
 ALTER TABLE nashville_housing
 DROP COLUMN propertyaddress, owneraddress, taxdistrict
