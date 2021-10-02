--------------------------------------------------------Carga Temporal---------------------------------------------------------------------------------------------
copy temporal from '/home/david/Escritorio/BlockBusterData1.csv'USING delimiters ';' csv header encoding 'windows-1251'; 

-------------------------------------------------------Insetrtar Paises--------------------------------------------------------------------------------------------
insert into pais (nombrePais)
select distinct paisCliente from temporal 
where paisCliente <> '-'
union distinct 
select distinct paisEmpleado from temporal
where paisEmpleado <> '-'
union distinct
select distinct paisTienda from temporal
where paisTienda <> '-';

-------------------------------------------------------Insertar Ciudades------------------------------------------------------------------------------------------
insert into ciudad (nombreCiudad)
select distinct ciudadCliente from temporal 
where ciudadCliente <> '-'
union distinct 
select distinct ciudadEmpleado from temporal
where ciudadEmpleado <> '-'
union distinct
select distinct ciudadTienda from temporal
where ciudadTienda <> '-';

-----------------------------------------------------Insertar Direcciones-----------------------------------------------------------------------------------------
insert into direccion (Direccion, fk_idCiudad, fk_idPais)
select t.direccionCliente, c.idCiudad, p.idPais
from temporal as t 
inner join ciudad as c on t.ciudadCliente = c.nombreCiudad 
inner join pais as p on t.paisCliente = p.nombrePais
where  t.direccionCLiente <> '-'
group by t.direccioncliente, p.idPais, c.idCiudad
union distinct

select t.direccionEmpleado, c.idCiudad, p.idPais
from temporal as t 
inner join ciudad as c on t.ciudadEmpleado = c.nombreCiudad 
inner join pais as p on t.paisEmpleado = p.nombrePais
where  t.direccionEmpleado <> '-'
group by t.direccionEmpleado, p.idPais, c.idCiudad
union distinct

select t.direccionTienda, c.idCiudad, p.idPais
from temporal as t 
inner join ciudad as c on t.ciudadTienda = c.nombreCiudad 
inner join pais as p on t.paisTienda = p.nombrePais
where  t.direccionTienda <> '-'
group by t.direccionTienda, p.idPais, c.idCiudad;

---------------------------------------------------Insertar Tiendas----------------------------------------------------------------------------------------------
insert into tienda (fk_idDireccion, nombreTienda)
select d.idDireccion, t.nombreTienda 
from temporal as t
inner join direccion as d on t.direccionTienda = d.Direccion   
where t.nombreTienda <> '-'
group by d.idDireccion, t.nombreTienda;

---------------------------------------------------Insertar Clientes----------------------------------------------------------------------------------------------
insert into cliente (fk_idDireccion, fk_idTiendaFav, nombreCliente, apellidoCliente, emailCliente, clienteActivo, fechaReg, codPostalCliente)
select d.idDireccion, ti.idTienda, t.nombreCliente, t.apellidoCliente, t.emailCliente, t.clienteActivo, to_date(t.fechaReg, 'DD/MM/YYYY'), to_number(t.codPostalCliente, '99G999D9S') 
from temporal as t
inner join direccion as d on t.direccionCliente = d.Direccion
inner join tienda as ti on t.tiendaFav = ti.nombreTienda
where t.nombreCliente <>  '-'
group by d.idDireccion, ti.idTienda, t.nombreCliente, t.apellidoCliente, t.emailCliente, t.clienteActivo, t.fechaReg, t.codPostalCliente;

----------------------------------------------------Insert Empleados-------------------------------------------------------------------------------------------------
insert into empleado (fk_idDireccion, fk_idTienda, nombreEmpleado, apellidoEmpleado, emailEmpleado, empleadoActivo, usarioEmpleado, contraEmpleado)
select d.idDireccion, ti.idTienda, t.nombreEmpleado, t.apellidoEmpleado, t.emailEmpleado, t.empleadoActivo, t.usarioEmpleado, t.contraEmpleado
from temporal as t
inner join direccion as d on t.direccionEmpleado = d.Direccion
inner join tienda as ti on t.tiendaEmpleado = ti.nombreTienda
where t.nombreEmpleado <>  '-'
group by d.idDireccion, ti.idTienda, t.nombreEmpleado, t.apellidoEmpleado, t.emailEmpleado, t.empleadoActivo, t.usarioEmpleado, t.contraEmpleado;

----------------------------------------------------Insert Clasificacion-------------------------------------------------------------------------------------------------
insert into clasificacion (nombreClasificacion)
select clasificacion 
from temporal
where clasificacion <>  '-'
group by clasificacion;

----------------------------------------------------Insert Pelicula-------------------------------------------------------------------------------------------------
insert into pelicula (fk_idClasificacion, nombrePelicula, descPelicula, anioLanzamiento, diasRenta, costoRenta, duracion, costoXDanio)
select c.idClasificacion, t.nombrePelicula, t.descPelicula, to_number(t.anioLanzamiento, '99G999D9S'), to_number(t.diasRenta, '99G999D9S'),  to_number(t.costoRenta, '99G999D9S'), to_number(t.duracion, '99G999D9S'), to_number(t.costoXDanio, '99G999D9S')
from temporal as t
inner join clasificacion as c on c.nombreClasificacion = t.clasificacion
where t.nombrePelicula <> '-'
group by c.idClasificacion, t.nombrePelicula, t.descPelicula, t.anioLanzamiento, t.diasRenta, t.costoRenta, t.duracion, t.costoXDanio;

----------------------------------------------------Insert lenguaje-------------------------------------------------------------------------------------------------
insert into lenguaje (nombreLenguaje) 
select distinct lenguaje 
from temporal
where lenguaje <> '-';

----------------------------------------------------Insert doblaje------------------------------------------------------------------------------------------------
insert into doblaje (fk_idLenguaje, fk_idPeli)
select l.idLenguaje, p.idPeli
from temporal as t
inner join lenguaje as l on l.nombreLenguaje = t.lenguaje
inner join pelicula as p on p.nombrePelicula = t.nombrePelicula
where t.nombrePelicula <> '-'
group by l.idLenguaje, p.idPeli;

----------------------------------------------------Insert Actor------------------------------------------------------------------------------------------------
insert into Actor (nombreActor, apellidoActor) 
select nombreActor, actorApellido 
from temporal
where nombreActor <> '-' and actorApellido <> '-'
group by nombreActor, actorApellido;

----------------------------------------------------Insert Actuacion------------------------------------------------------------------------------------------------
insert into actuacion (fk_idActor, fk_idPeli)
select a.idActor, p.idPeli
from temporal as t
inner join Actor as a on a.nombreActor = t.nombreActor and a.apellidoActor = t.actorApellido
inner join pelicula as p on p.nombrePelicula = t.nombrePelicula
where t.nombrePelicula <> '-'
group by a.idActor, p.idPeli;

----------------------------------------------------Insert categoria------------------------------------------------------------------------------------------------
insert into categoria (nombreCategoria)
select categoria
from temporal
where categoria <> '-'
group by categoria;

----------------------------------------------------Insert categoPeli------------------------------------------------------------------------------------------------
insert into categoPeli (fk_idCategoria, fk_idPeli)
select c.idCategoria, p.idPeli
from temporal as t
inner join categoria as c on c.nombreCategoria = t.categoria   
inner join pelicula as p on p.nombrePelicula = t.nombrePelicula
where t.nombrePelicula <> '-'
group by c.idCategoria, p.idPeli; 

----------------------------------------------------Insert Inventario------------------------------------------------------------------------------------------------
insert into inventario (fk_idTienda, fk_idPeli) 
select ti.idTienda, p.idPeli
from temporal as t
inner join tienda as ti on ti.nombreTienda = t.tiendaPelicula
inner join pelicula as p on p.nombrePelicula = t.nombrePelicula
where t.nombrePelicula <> '-'
group by ti.idTienda, p.idPeli; 

----------------------------------------------------Insert Renta------------------------------------------------------------------------------------------------
insert into renta (fk_idPeli, fk_idCliente, fk_idEmpleado, fechaRenta, fechaRetorno, fechaPago, montoPago)
select  p.idPeli, c.idCliente, e.idEmpleado, to_timestamp(t.fechaRenta, 'DD/MM/YYYY HH24:MI'), t.fechaRetorno, to_timestamp(t.fechaPago, 'DD/MM/YYYY HH24:MI'), to_number(t.montoPagar, '99G999D9S')
from temporal as t 
inner join pelicula as p on p.nombrePelicula = t.nombrePelicula
inner join cliente as c on c.emailCliente = t.emailCliente
inner join empleado as e on e.emailEmpleado = t.emailEmpleado
where t.nombrePelicula <> '-'
group by p.idPeli, c.idCliente, e.idEmpleado, t.fechaRenta, t.fechaRetorno, t.fechaPago, t.montoPagar;



















