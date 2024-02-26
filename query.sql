-- (5 pts) What are the last names and emails of all customer who made purchased in the store?

SELECT customers.LastName, customers.Email
FROM customers;

-- (5 pts) What are the names of each album and the artist who created it?

SELECT Title, Name
FROM albums as al
JOIN artists as ar
ON al.ArtistId = ar.ArtistId;

-- (10 pts) What are the total number of unique customers for each state, ordered alphabetically by state?
SELECT COUNT(DISTINCT customers.State)
FROM customers
WHERE customers.State IS NOT NULL
ORDER BY customers.State DESC;

-- (10 pts) Which states have more than 10 unique customers?

SELECT customers.State
FROM customers
WHERE customers.State IS NOT NULL
GROUP BY customers.State
HAVING COUNT(DISTINCT customers.CustomerId) > 10;

-- (10 pts) What are the names of the artists who made an album containing the substring "symphony" in the album title?

SELECT artists.Name
FROM artists
JOIN albums
ON artists.ArtistId = albums.ArtistId
WHERE albums.Title LIKE "%symphony%";

-- (15 pts) What are the names of all artists who performed MPEG (video or audio) tracks in either the "Brazilian Music" or the "Grunge" playlists?

SELECT artists.Name
FROM artists
JOIN playlist_track
ON artists.ArtistId = playlist_track.TrackId
JOIN playlists
ON playlist_track.PlaylistId = playlists.PlaylistId
JOIN media_types
ON playlists.PlaylistId = media_types.MediaTypeId
WHERE playlists.Name = 'Brazilian Music' OR playlists.Name = 'Grunge' 
AND media_types.MediaTypeId = 1 OR media_types.MediaTypeId = 5;

-- (20 pts) How many artists published at least 10 MPEG tracks?
SELECT COUNT(artists.Name)
FROM artists
JOIN playlist_track
ON artists.ArtistId = playlist_track.TrackId
JOIN playlists
ON playlist_track.PlaylistId = playlists.PlaylistId
JOIN media_types
ON playlists.PlaylistId = media_types.MediaTypeId
WHERE (media_types.MediaTypeId = 1) > 10;


-- (25 pts) What is the total length of each playlist in hours? List the playlist id and name of only those playlists that are longer than 2 hours, along with the length in hours rounded to two decimals.
SELECT playlists.PlaylistId, playlists.Name, ROUND(SUM(tracks.Milliseconds)/3600000.0, 2) as Length_Hours
FROM playlists
JOIN playlist_track ON playlists.PlaylistId = playlist_track.PlaylistId
JOIN tracks ON playlist_track.TrackId = tracks.TrackId
GROUP BY playlists.PlaylistId, playlists.Name
HAVING SUM(tracks.Milliseconds)/3600000.0 > 2;

-- (25 pts) Creative addition: Define a new meaningful query using at least three tables, and some window function. Explain clearly what your query achieves, and what the results mean

-- This query shows the top 3 customers by total purchase amount.
-- It returns the first name, last name and total purchase amount for each customer.
SELECT c.FirstName, c.LastName, SUM(ii.UnitPrice * ii.Quantity) AS TotalPurchaseAmount
FROM customers AS c
JOIN invoices AS i ON c.CustomerId = i.CustomerId
JOIN invoice_items AS ii ON i.InvoiceId = ii.InvoiceId
GROUP BY c.CustomerId, c.FirstName, c.LastName
ORDER BY TotalPurchaseAmount DESC
LIMIT 3;


