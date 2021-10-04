create table temporal (
	nombreCliente varchar (50),
	apellidoCliente varchar (50),
	emailCliente varchar (50), 
	clienteActivo varchar (5), 
	fechaReg varchar(50), 
	tiendaFav varchar (100),
	direccionCliente varchar (100),
	codPostalCliente varchar (50),
	ciudadCliente char(50), 
	paisCliente varchar (50), 
	
	fechaRenta varchar (50), 
	fechaRetorno varchar (50), 
	montoPagar varchar (50), 
	fechaPago varchar (100), 
	
	nombreEmpleado varchar (50),
	apellidoEmpleado varchar (50),
	emailEmpleado varchar (50),
	empleadoActivo varchar (5),
	tiendaEmpleado varchar (50),
	usarioEmpleado varchar (50),
	contraEmpleado varchar (250),
	direccionEmpleado varchar (50),
	codPostalEmpleado varchar (50),
	ciudadEmpleado varchar (50),
	paisEmpleado varchar (50),
	
	nombreTienda varchar (50),
	nombreEncargadoTienda varchar (50),
	apellidoEncargadoTienda varchar (50),
	direccionTienda varchar (50),
	codPostalTienda varchar (50),
	ciudadTienda varchar (50),
	paisTienda varchar (50),
	
	tiendaPelicula varchar(50),
	nombrePelicula varchar(50),
	descPelicula varchar(250),
	anioLanzamiento varchar(50),
	diasRenta varchar(50),
	costoRenta varchar(50),
	duracion varchar(50), 
	costoXDanio varchar (50),
	clasificacion varchar (50),
	lenguaje varchar (50),
	categoria varchar (50),
	nombreActor varchar (50),
	actorApellido varchar (50)
);

--truncate table temporal;


