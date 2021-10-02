select * from temporal;
select * from pais;
select * from ciudad;
select * from direccion;
select * from tienda;
select * from cliente;
select * from empleado;
select * from clasificacion;
select * from pelicula; 
select * from lenguaje;
select * from doblaje;
select * from Actor;
select * from actuacion;
select * from categoria;
select * from categoPeli;
select * from inventario;
select * from renta;

-----------------------------------------------------------Consulta 1----------------------------------------------------------------------------------------------
select count (p.nombrePelicula)
from inventario as i
inner join pelicula as p on p.idPeli = i.fk_idPeli
where p.nombrePelicula = 'SUGAR WONKA';

-----------------------------------------------------------Consulta 2----------------------------------------------------------------------------------------------
select c.nombreCliente, c.apellidoCliente
from renta as r
inner join cliente as c on c.idCliente = r.fk_idCliente
group by c.nombreCliente, c.apellidoCliente
having count (c.nombreCliente) >= 40;

-----------------------------------------------------------Consulta 3----------------------------------------------------------------------------------------------
select CONCAT_WS(' ', nombreActor, apellidoActor) as NombreCompleto from Actor
where apellidoActor like '%son%'
order by nombreActor asc;

-----------------------------------------------------------Consulta 4----------------------------------------------------------------------------------------------
select ac.nombreActor, ac.apellidoActor, p.anioLanzamiento
from actuacion as a
inner join Actor as ac on ac.idActor = a.fk_idActor
inner join pelicula as p on p.idPeli = a.fk_idPeli
where p.descPelicula like '%Shark%' and p.descPelicula like '%Crocodile%'
order by ac.apellidoActor asc

-----------------------------------------------------------Consulta 5----------------------------------------------------------------------------------------------
SELECT MAX(alias.nombreCliente), alias.nombrePais, MAX(RENTAS) as rentas, MAX(PORCENTAJE) as "%" 
FROM ( 
	select 
	c.nombreCliente, 
	p.nombrePais, 
	count(r.fk_idCliente) as RENTAS, 
	(count(r.fk_idCliente)*100)/(select count(re.fk_idCliente)
								 from renta as re
								 inner join cliente as cl on cl.idCliente = re.fk_idCliente
								 inner join direccion as di on di.idDireccion = cl.fk_idDireccion
							     inner join ciudad as ciu on ciu.idCiudad = di.fk_idCiudad
								 inner join pais as pa on pa.idPais = di.fk_idPais
								 where pa.nombrePais = p.nombrePais
		 						 group by pa.nombrePais) as PORCENTAJE
	from renta as r
	inner join cliente as c on c.idCLiente = r.fk_idCliente
	inner join direccion as d on d.idDireccion = c.fk_idDireccion
	inner join ciudad as ci on ci.idCiudad = d.fk_idCiudad
	inner join pais as p on p.idPais = d.fk_idPais
	group by c.nombreCliente, c.apellidoCliente, p.nombrePais
) as alias
GROUP BY alias.nombrePais;

-----------------------------------------------------------Consulta 6----------------------------------------------------------------------------------------------
select 
count(c.idCLiente),
(count(c.idCLiente)*100)/ (select count(ciu.idCiudad)
						   from direccion as di 
						   inner join ciudad as ciu on ciu.idCiudad = di.fk_idCiudad
						   inner join pais as pa on pa.idPais = di.fk_idPais
						   where pa.nombrepais = p.nombrePais
						   group by pa.idPais) as "%"
from cliente as c
inner join direccion as d on d.idDireccion = c.fk_idDireccion
inner join ciudad as ci on ci.idCiudad = d.fk_idCiudad
inner join pais as p on p.idPais = d.fk_idPais
group by ci.idCiudad, p.nombrePais;

-----------------------------------------------------------Consulta 7----------------------------------------------------------------------------------------------
select p.nombrePais, 
count(r.noRenta) / (select count (ciu.nombreCiudad)
					from direccion as di 
					inner join ciudad as ciu on ciu.idCiudad = di.fk_idCiudad
					inner join pais as pa on pa.idPais = di.fk_idPais
					where pa.nombrePais = p.nombrePais 
					group by pa.idPais) as "promedio"
from renta as r
inner join cliente as c on c.idCliente = r.fk_idCliente
inner join direccion as d on d.idDireccion = c.fk_idDireccion
inner join ciudad as ci on ci.idCiudad = d.fk_idCiudad
inner join pais as p on p.idPais = d.fk_idPais
group by p.nombrePais;

-----------------------------------------------------------Consulta 8----------------------------------------------------------------------------------------------
select 
p.nombrePais, 
count(r.fk_idCliente) as RENTAS, 
(count(r.fk_idCliente)*100)/(select count(re.fk_idCliente)
							 from renta as re
							 inner join cliente as cl on cl.idCliente = re.fk_idCliente
							 inner join direccion as di on di.idDireccion = cl.fk_idDireccion
							 inner join ciudad as ciu on ciu.idCiudad = di.fk_idCiudad
							 inner join pais as pa on pa.idPais = di.fk_idPais
							 where pa.nombrePais = p.nombrePais
							 group by pa.nombrePais) as PORCENTAJE
from renta as r
inner join cliente as c on c.idCLiente = r.fk_idCliente
inner join direccion as d on d.idDireccion = c.fk_idDireccion
inner join ciudad as ci on ci.idCiudad = d.fk_idCiudad
inner join pais as p on p.idPais = d.fk_idPais

inner join pelicula as peli on peli.idPeli = r.fk_idPeli
inner join categoPeli as catPel on catPel.fk_idPeli = peli.idPeli
inner join categoria as cate on cate.idCategoria = catPel.fk_idCategoria
where cate.nombreCategoria = 'Sports'
group by p.nombrePais;

-----------------------------------------------------------Consulta 9----------------------------------------------------------------------------------------------


-----------------------------------------------------------Consulta 10----------------------------------------------------------------------------------------------




