who is senior most employee by levels?

select title,last_name,first_name 
from employee
order by levels desc
limit 1

which countries have most invoices?

select count(*) as c, billing_country
from invoice
group by billing_country
order by c desc

what are top 3 values of total invoices?

select total,billing_country from invoice
order by total desc
limit 3

which country has the best customers?

select total,first_name,last_name,billing_country from invoice
join customer on customer.customer_id=invoice.customer_id
order by total desc
limit 3

which is the best selling artist?

with best_selling_artist as (
select artist.artist_id as artistid,artist.name as artist,sum (invoice_line.unit_price*invoice_line.quantity) as totalsales
	from invoice_line
	join track on track.track_id =invoice_line.track_id
	join album on album.album_id = track.album_id
	join artist on artist.artist_id = album.artist_id
	group by artistid,artist
	order by totalsales desc
	limit 3
)
select * from best_selling_artist

which city has the best customers?promotional party will be thrown fro city which made most money.
write query to to return city with highest sum of total invoices.city name and sum of all invoice total.

select billing_city ,sum(total) as totalinvoices
from invoice
group by billing_city
order by totalinvoices desc
limit 3


customer who has spent most money will be declared best customer,write query to return customer who has spent most.

select customer.first_name as firstname,customer.last_name as lastname,sum(total) as totalspent
from invoice
join customer on customer.customer_id = invoice.customer_id
group by firstname,lastname
order by totalspent desc
limit 3


write query to return email,last name ,first name of customer of all rock music listeners and order based on email id.//

select distinct first_name,last_name,email 
from customer
join invoice on customer.customer_id=invoice.customer_id
join invoice_line on invoice.invoice_id=invoice_line.invoice_id
where track_id IN (
      select track_id from track
      join genre on track.genre_id=genre.genre_id
      where genre.name like 'rock'
)
order by email;


SELECT DISTINCT email AS Email,first_name AS FirstName, last_name AS LastName, genre.name AS Name
FROM customer
JOIN invoice ON invoice.customer_id = customer.customer_id
JOIN invoice_line ON invoice_line.invoice_id = invoice.invoice_id
JOIN track ON track.track_id = invoice_line.track_id
JOIN genre ON genre.genre_id = track.genre_id
WHERE genre.name LIKE '%Rock'
ORDER BY email;

//write a query to return artist who have written most rock music ,artist name,total no of track and top 10 rock bands.//

SELECT artist.artist_id, artist.name,COUNT(artist.artist_id) AS number_of_songs
FROM track
JOIN album ON album.album_id = track.album_id
JOIN artist ON artist.artist_id = album.artist_id
JOIN genre ON genre.genre_id = track.genre_id
WHERE genre.name LIKE 'Rock'
GROUP BY artist.artist_id
ORDER BY number_of_songs DESC
LIMIT 10


//Return all the track names that have a song length longer than the average song length. 
Return the Name and Milliseconds for each track. Order by the song length with the longest songs listed first.//


select name,milliseconds from track
where milliseconds >(select avg(milliseconds) as avg_tracklength 
					 from track)
order by milliseconds

//Find how much amount is spent by each customer on  top artist? Write a query to return customer name, artist name and total spent on best selling artist//
	

WITH best_selling_artist  AS (
SELECT artist.artist_id as artistid,artist.name as artistname,sum(invoice_line.unit_price*invoice_line.quantity) as totalspent 
from invoice_line
JOIN track on track.track_id = invoice_line.track_id
JOIN album on album.album_id = track.album_id
JOIN artist on artist.artist_id =album.artist_id
GROUP BY artistid
ORDER BY totalspent desc
LIMIT 1
)
SELECT c.customer_id,c.first_name,c.last_name,bsa.artistname,sum(il.unit_price*il.quantity) as amountspent 
from invoice i
JOIN customer c on c.customer_id = i.customer_id
JOIN invoice_line il on il.invoice_id = i.invoice_id
JOIN track t on t.track_id = il.track_id
JOIN album alb on alb.album_id = t.album_id
JOIN best_selling_artist bsa  on bsa.artistid= alb.artist_id
GROUP BY c.customer_id,c.first_name,c.last_name, bsa.artistname
ORDER BY amountspent desc;

We want to find out the most popular music Genre for each country. We determine the most popular genre as the genre 
with the highest amount of purchases. Write a query that returns each country along with the top Genre. For countries where 
the maximum number of purchases is shared return all Genres.

with popular_genre as 
(select count(invoice_line.quantity)as totalpurchases,customer.country,genre.genre_id,genre.name,
row_number() over(partition by customer.country order by count(invoice_line.quantity)desc) as rowno
from invoice_line
join invoice on invoice.invoice_id = invoice_line.invoice_id 
join customer on customer.customer_id =invoice.customer_id 
join track on invoice_line.track_id =invoice_line.track_id 
join genre on genre.genre_id = track.genre_id 
group by 2,3,4
order by 2 asc, 1 desc 
)
select*from popular_genre where rowno<=1


write a query that returns how much is spent by customer on music for each country,returns country with top customer and how much they have spent on music.
for countries where top spent on music is shared return all.

we have to find most spent on music for each country and filters data based on customer then.



with country_topspent as 
(select customer.customer_id as custid,customer.first_name as fname,customer.last_name as lname,billing_country,sum(total)as totalspent, 
row_number() over(partition by billing_country order by sum(total)desc) as rowno
from invoice
join customer on customer.customer_id=invoice.customer_id
group by custid,fname,lname,billing_country
order by totalspent desc,billing_country desc
)
select * from country_topspent where rowno<=1

	
