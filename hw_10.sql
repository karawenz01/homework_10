use sakila;

-- 1A
-- Display the first and last names of all actors
select first_name, last_name from actor;


-- 1B
-- Display the first and last name of each actor in a single column in upper case letters. 
-- Name the column Actor Name
select concat(first_name, " ",last_name) as Actor_Name from actor;


-- 2A
-- You need to find the ID number, first name, and last name of an actor,
--  of whom you know only the first name, "Joe." 
select first_name, last_name, actor_id 
from actor where first_name = "Joe";


-- 2B
-- Find all actors whose last name contain the letters GEN
select first_name, last_name 
from actor where last_name like "%gen%";


-- 2C
-- Find all actors whose last names contain the letters LI. 
-- This time, order the rows by last name and first name, in that order
select last_name, first_name
from actor where last_name like "%li%";


-- 2D
-- Using IN, display the country_id and country columns of the following countries:
-- Afghanistan, Bangladesh, and China
select country_id, country from country
where country in ("Afghanistan", "Bangladesh", "China");


-- 3A
-- Add a middle_name column to the table actor. Position it between first_name and last_name.
alter table actor
add middle_name varchar(50)
after first_name;
-- check (yay)
select * from actor;


-- 3B
-- Change the data type of the middle_name column to blobs
alter table actor
modify column middle_name blob;


-- 3c
-- Now delete the middle_name column
alter table actor
drop column middle_name;
-- check yayayayayyy
select * from actor;


-- 4A
--  List the last names of actors, as well as how many actors have that last name.
select last_name, count(*)
from actor
group by last_name;


-- 4B
-- List last names of actors and the number of actors who have that last name, 
-- but only for names that are shared by at least two actors 
select last_name, count(*)
from actor
group by last_name
having count(*) > 2;


-- 4C
-- The actor HARPO WILLIAMS was accidentally entered in the actor table as GROUCHO WILLIAMS, 
-- the name of Harpo's second cousin's husband's yoga teacher. Write a query to fix the record
update actor 
set first_name = "Harpo"
where first_name = "Groucho" and last_name = "Williams";
-- check 
select first_name, last_name from actor
where first_name = "Harpo";
-- yay


-- 4D
-- if the first name of the actor is currently HARPO, 
-- change it to GROUCHO. Otherwise, change the first name to MUCHO GROUCHO


-- 5A
-- You cannot locate the schema of the address table. Which query would you use to re-create it?
 SHOW CREATE TABLE address ;
 
 
-- 6A
-- Use JOIN to display the first and last names, as well as the address, of each staff member. 
-- Use the tables staff and address 
select s.first_name, s.last_name, a.address
from staff s
join address a
on (a.address_id = s.address_id);
-- look at staff to check.
select * from staff;
-- ok we gucci


-- 6B
-- Use JOIN to display the total amount rung up by each staff member in August of 2005. 
-- Use tables staff and payment

-- look at payment and rental
select * from rental;

select p.staff_id, sum(amount)
from payment p
join rental r
on (p.rental_id = r.rental_id)
where rental_date like "2005-08%"
group by staff_id;

-- 6C
--  List each film and the number of actors who are listed for that film.
-- Use tables film_actor and film. Use inner join.
select f.title, count(*) 
from film_actor a
join film f
on (f.film_id = a.film_id)
group by actor_id;


-- 6D
-- How many copies of the film Hunchback Impossible exist in the inventory system?
select f.title, count(*)
from film f 
join inventory i
on (f.film_id = i.film_id)
group by title
having title = "Hunchback Impossible";
-- yay, 6


-- 6E
-- Using the tables payment and customer and the JOIN command, list the total paid by each customer. 
-- List the customers alphabetically by last name:
select c.first_name, c.last_name, sum(amount), c.customer_id
from customer c
join payment p
on (c.customer_id = p.customer_id)
group by c.customer_id
order by c.last_name;
-- check 
select customer_id, sum(amount) from payment
where customer_id = 505;
-- it matches, yay


-- 7A
-- Use subqueries to display the titles of movies starting with the 
-- letters K and Q whose language is English.
select title 
from film
where language_id in
(
	select language_id
    from language
    where language_id = 1
    )
and title like "K%" 
or  title like "Q%";
-- look at languages to find which is English.
select * from language;


-- 7B
--  Use subqueries to display all actors who appear in the film Alone Trip
select actor.first_name, actor.last_name
from actor
where actor_id in
(	
	select actor_id
	from film_actor
    where film_id in
    (
		select film_id
        from film
        where title = "Alone Trip"
        )
);


-- 7C
-- You want to run an email marketing campaign in Canada, 
-- for which you will need the names and email addresses of all Canadian customers. 
-- Use joins to retrieve this information.

-- I couldn't think of a way to do it with joins....

select c.first_name, c.last_name, c.email
from customer c
where address_id in
(
	select address_id
    from address
    where city_id in
    (
		select city_id
        from city
        where country_id in
        (
			select country_id
            from country
            where country = "Canada"
)));

-- I figured how to do it with joins....(-:
select first_name, last_name, email
from customer cust
inner join address a
on cust.address_id = a.address_id
inner join city
on a.city_id = city.city_id
inner join country c
on city.country_id = c.country_id
where country = "Canada";


-- 7D
-- Sales have been lagging among young families, and you wish to target all family movies for a promotion. 
-- Identify all movies categorized as family films

-- look at categories
select * from category;

select title 
from film
where film_id in
(
	select film_id
    from film_category
    where category_id in
    (
		select category_id
        from category
        where name = "Family"
));


-- 7E
-- Display the most frequently rented movies in descending order
select title, count(*)
from film f
inner join inventory i
on f.film_id = i.film_id
inner join rental r
on i.inventory_id = r.inventory_id
group by title
order by count(*) desc;



-- 7F
-- Write a query to display how much business, in dollars, each store brought in
select store_id, sum(amount)
from payment p
inner join customer c
on p.customer_id = c.customer_id
group by store_id;

select * from store;


-- 7G
-- Write a query to display for each store its store ID, city, and country
select store_id, city, country
from store s
inner join address a 
on s.address_id = a.address_id 
inner join city 
on a.city_id = city.city_id
inner join country c
on city.country_id = c.country_id;
-- look at country 
select * from country;
select * from store;


-- 7H
-- List the top five genres in gross revenue in descending order
select name, sum(amount)
from category c
inner join film_category fc
on c.category_id = fc.category_id
inner join inventory i
on fc.film_id = i.film_id
inner join rental r
on i.inventory_id = r.inventory_id
inner join payment p
on r.rental_id = p.rental_id
group by name
order by sum(amount) desc
limit 5;


-- 8a
-- viewing the Top five genres by gross revenue. Use the solution from the problem above to create a view. 
-- If you haven't solved 7h, you can substitute another query to create a view.
create view top_5_grossing_genres as
select name, sum(amount)
from category c
inner join film_category fc
on c.category_id = fc.category_id
inner join inventory i
on fc.film_id = i.film_id
inner join rental r
on i.inventory_id = r.inventory_id
inner join payment p
on r.rental_id = p.rental_id
group by name
order by sum(amount) desc
limit 5;
-- check, ayayayayy
select * from  top_5_grossing_genres;


-- 8B
-- How would you display the view that you created in 8a?
select * from  top_5_grossing_genres;


-- 8C
-- You find that you no longer need the view top_five_genres. Write a query to delete it.
drop view top_5_grossing_genres;