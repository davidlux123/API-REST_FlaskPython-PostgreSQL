create table pais(
	idPais serial PRIMARY KEY,
	nombrePais varchar (100)
);
--drop table pais;

create table ciudad (
	idCiudad serial PRIMARY KEY,
	nombreCiudad varchar (100)
);
--drop table ciudad; 

create table direccion (
	idDireccion serial PRIMARY KEY,
	fk_idPais int,
	fk_idCiudad int, 
	Direccion varchar (100),
	CONSTRAINT fk_idpais FOREIGN KEY(fk_idPais) REFERENCES pais (idPais),
	CONSTRAINT fk_idciudad FOREIGN KEY(fk_idCiudad) REFERENCES ciudad (idCiudad)
);
--drop table direccion;

create table tienda( 
	idTienda serial PRIMARY KEY,
	fk_idDireccion int unique,
	nombreTienda varchar (50),
	codPostalTienda int null,
	CONSTRAINT fk_idireccion_T FOREIGN KEY(fk_idDireccion) REFERENCES direccion (idDireccion)
);
--drop table tienda;

create table cliente (
	idCliente serial PRIMARY KEY,
	fk_idDireccion int,
	fk_idTiendaFav int,
	nombreCliente varchar (50),
	apellidoCliente varchar (50),
	emailCliente varchar (50), 
	clienteActivo varchar (5), 
	fechaReg date, 
	codPostalCliente int,
	CONSTRAINT fk_idireccion_C FOREIGN KEY(fk_idDireccion) REFERENCES direccion (idDireccion), 
	CONSTRAINT fk_idTiendaFav_C FOREIGN KEY(fk_idTiendaFav) REFERENCES tienda (idTienda)
);
--drop table cliente;

create table empleado (
	idEmpleado serial PRIMARY KEY,
	fk_idDireccion int,
	fk_idTienda int,
	nombreEmpleado varchar (50),
	apellidoEmpleado varchar (50),
	emailEmpleado varchar (50),
	empleadoActivo varchar (5),
	usarioEmpleado varchar (50),
	contraEmpleado varchar (250),
	codPostalEmpleado int null,
	CONSTRAINT fk_idireccion_E FOREIGN KEY(fk_idDireccion) REFERENCES direccion (idDireccion), 
	CONSTRAINT fk_idTienda_E FOREIGN KEY(fk_idTienda) REFERENCES tienda (idTienda)
); 
--drop table empleado;

create table clasificacion (
	idClasificacion serial PRIMARY KEY,
	nombreClasificacion varchar (50)
);
--drop table clasificacion;

create table pelicula (
	idPeli serial PRIMARY KEY,
	fk_idClasificacion int,
	nombrePelicula varchar(50),
	descPelicula varchar(250),
	anioLanzamiento bigint,
	diasRenta bigint,
	costoRenta decimal,
	duracion int, 
	costoXDanio decimal,
	CONSTRAINT fk_idclasificacion FOREIGN KEY(fk_idClasificacion) REFERENCES clasificacion (idClasificacion)
);
--drop table pelicula;

create table lenguaje (
	idLenguaje serial PRIMARY KEY, 
	nombreLenguaje varchar (50)
);
--drop table lenguaje;

create table doblaje (
	fk_idLenguaje int,
	fk_idPeli int,
	PRIMARY KEY(fk_idLenguaje, fk_idPeli), 
	CONSTRAINT fk_idlenguaje FOREIGN KEY(fk_idLenguaje) REFERENCES lenguaje (idLenguaje),
	CONSTRAINT fk_idpeli_d FOREIGN KEY(fk_idPeli) REFERENCES pelicula (idPeli)
);
--drop table doblaje;

create table actor (
	idActor serial PRIMARY KEY, 
	nombreActor varchar (50),
	apellidoActor varchar (50)
);
--drop table actor;

create table actuacion (
	fk_idActor int, 
	fk_idPeli int,
	PRIMARY KEY(fk_idActor, fk_idPeli),
	CONSTRAINT fk_idactor FOREIGN KEY(fk_idActor) REFERENCES actor (idActor),
	CONSTRAINT fk_idpeli_a FOREIGN KEY(fk_idPeli) REFERENCES pelicula (idPeli)
);
--drop table actuacion;

create table categoria (
	idCategoria serial PRIMARY KEY, 
	nombreCategoria varchar (50)
);
--drop table categoria;

create table categoPeli (
	fk_idCategoria int,
	fk_idPeli int,
	PRIMARY KEY(fk_idCategoria, fk_idPeli),
	CONSTRAINT fk_idcategoria FOREIGN KEY(fk_idCategoria) REFERENCES categoria (idCategoria),
	CONSTRAINT fk_idpeli_c FOREIGN KEY(fk_idPeli) REFERENCES pelicula (idPeli)
);
--drop table categoPeli;

create table inventario (
	fk_idTienda int,
	fk_idPeli int,
	stock int null ,
	PRIMARY KEY(fk_idTienda, fk_idPeli),
	CONSTRAINT fk_idTienda_I FOREIGN KEY(fk_idTienda) REFERENCES tienda (idTienda),
	CONSTRAINT fk_idpeli_I FOREIGN KEY(fk_idPeli) REFERENCES pelicula (idPeli)
);
--drop table inventario;

create table renta (
	noRenta serial PRIMARY KEY,
	fk_idPeli int, 
	fk_idCliente int,
	fk_idEmpleado int,
	fechaRenta timestamp, 
	fechaRetorno varchar(50), 
	fechaPago timestamp, 
	montoPago decimal, 
	CONSTRAINT fk_idpeli_R FOREIGN KEY(fk_idPeli) REFERENCES pelicula (idPeli),
	CONSTRAINT fk_idcliente FOREIGN KEY(fk_idCliente) REFERENCES cliente (idCliente),
	CONSTRAINT fk_idempleado FOREIGN KEY(fk_idEmpleado) REFERENCES empleado (idEmpleado)
);
--drop table renta

