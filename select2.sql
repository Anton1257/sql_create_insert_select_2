/*количество исполнителей в каждом жанре*/
SELECT g.title AS genre, count(a.id) AS num_artists
FROM Genre g
JOIN artistgenre ag ON g.id = ag.genre_id 
JOIN artist a ON ag.artist_id = a.id 
GROUP BY g.title;
/*количество треков, вошедших в альбомы 2019-2020 годов*/
SELECT a.title AS album_title, COUNT(t.id) AS num_tracks
FROM Album a 
INNER JOIN Track t ON a.id = t.album_id 
WHERE a.year BETWEEN 2019 AND 2020
GROUP BY a.title;
/*средняя продолжительность треков по каждому альбому*/
SELECT a.title AS album_title, AVG(t.duration) AS avg_duration
FROM Album a
INNER JOIN Track t ON a.id = t.album_id
GROUP BY a.title
/*все исполнители, которые не выпустили альбомы в 2020 году*/
SELECT DISTINCT ar.name
FROM Artist ar
LEFT JOIN ArtistAlbum aa ON aa.artist_id = ar.id
LEFT JOIN Album al ON al.id = aa.album_id
LEFT JOIN Track t ON t.album_id = al.id
WHERE al.year != 2020 OR al.id IS NULL
/*названия сборников, в которых присутствует конкретный исполнитель (выберите сами) например - artist_5*/
SELECT DISTINCT c.title
FROM Collection c
JOIN TrackCollection tc ON tc.collection_id = c.id
JOIN Track t ON t.id = tc.track_id
JOIN ArtistAlbum aa ON aa.album_id = t.album_id
JOIN Artist ar ON ar.id = aa.artist_id
WHERE ar.name = 'artist_5'
/*название альбомов, в которых присутствуют исполнители более 1 жанра*/
SELECT DISTINCT al.title
FROM Album al
JOIN ArtistAlbum aa1 ON aa1.album_id = al.id
JOIN Artist ar1 ON ar1.id = aa1.artist_id
JOIN ArtistAlbum aa2 ON aa2.album_id = al.id AND aa2.artist_id <> aa1.artist_id
JOIN Artist ar2 ON ar2.id = aa2.artist_id
JOIN ArtistGenre ag1 ON ag1.artist_id = ar1.id
JOIN ArtistGenre ag2 ON ag2.artist_id = ar2.id AND ag2.genre_id <> ag1.genre_id
WHERE ar1.id < ar2.id;
/*наименование треков, которые не входят в сборники*/
SELECT title
FROM Track LEFT JOIN TrackCollection ON Track.id = TrackCollection.track_id
WHERE collection_id IS NULL
/*исполнителя(-ей), написавшего самый короткий по продолжительности трек (теоретически таких треков может быть несколько)*/
SELECT Artist.name
FROM Artist
INNER JOIN ArtistAlbum ON Artist.id = ArtistAlbum.artist_id
INNER JOIN Album ON ArtistAlbum.album_id = Album.id
INNER JOIN Track ON Album.id = Track.album_id
WHERE Track.duration = (SELECT MIN(duration) FROM Track);
/*название альбомов, содержащих наименьшее количество треков*/
SELECT Album.title
FROM Album
WHERE Album.id IN (
  SELECT album_id
  FROM Track
  GROUP BY album_id
  HAVING COUNT(*) = (
    SELECT MIN(track_count)
    FROM (
      SELECT album_id, COUNT(*) as track_count
      FROM Track
      GROUP BY album_id
    ) AS track_counts
  )
);
