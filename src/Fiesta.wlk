
class Fiesta {
	
	var lugar = ""
	var fecha = 0
	var invitados = []
	
	constructor(_lugar,_fecha){
		lugar = _lugar
		fecha = _fecha
		
	}
	
	method fecha() = fecha
	
	method lugar()= lugar
	
	method invitados() = invitados
	
	method laFiestaEsUnBodrio(){
		return invitados.all({i => i.estaSatisfechoConSuDisfraz().negate()})
	}
	
	method elMejorDisfrazDeLfiestaLoTiene(){
		return invitados.max({i => i.puntuacionPorSuDisfraz()})
	}
	
	method elMejorDisfrazEs(){
		return self.elMejorDisfrazDeLfiestaLoTiene().disfraz()
	}
	
	method sePuedeAgregarUnInvitadoSi(unInvitado){
		return unInvitado.tieneDisfraz() && unInvitado.estaCargado().negate()
	}
	
	method agregarInvitado(unInvitado){
		if(self.sePuedeAgregarUnInvitadoSi(unInvitado).negate()){
			error.throwWithMessage("No se puede invitar a esta persona")
		}
		unInvitado.fiesta(self)
		invitados.add(unInvitado)
		
	}
	
	method laFiestaEsInolvidable(){
		return self.losInvitadosSonTodosSexies() && self.losInvitadosEstanConformeConSuDisfraz()
	}
	
	method losInvitadosSonTodosSexies(){
		return invitados.all({i => i.esSexi()})
	}
	
	method losInvitadosEstanConformeConSuDisfraz(){
		return invitados.all({i =>i.estaSatisfechoConSuDisfraz()})
	}
	
	// punto 4
	
	method dosInvitadosPuedenCanbiarDisfraz(unInvitado,otroInvitado){
		return self.ambosEstanEnLaMismaFiesta(unInvitado,otroInvitado) && self.algunoEstaDisconforme(unInvitado,otroInvitado)
	}
	
	method ambosEstanEnLaMismaFiesta(unInvitado,otroInvitado){
		return unInvitado.fiesta().lugar() == otroInvitado.fiesta().lugar()
	}
	
	method algunoEstaDisconforme(unInvitado,otroInvitado){
		return unInvitado.estaSatisfechoConSuDisfraz().negate() || otroInvitado.estaSatisfechoConSuDisfraz().negate()
	}


}

class Invitado{
	var disfraz
	var edad = 0
	var fiesta
	var personalidad
	var formaDeSatisfaccion
	var estaCargado = false
	
	constructor( _edad,_pers,forma){
		edad = _edad
		personalidad = _pers
		formaDeSatisfaccion = forma
	}
	
	method agregarDisfraz(unDisfraz){
		disfraz=unDisfraz
	}
	
	method fiesta(unaFiesta){
		fiesta = unaFiesta
	}
	
	method disfraz() = disfraz
	
	method fiesta() = fiesta
	
	method edad() = edad
	
	method personalidad() = personalidad
	
	method estaCargado(cargado){
		estaCargado = cargado
	}
	
	method estaCargado() = estaCargado
	
	method puntuacionPorSuDisfraz(){
		return disfraz.puntosSegunSuCaracteristicas(self)
	}
	
	method esSexi(){
		return self.personalidad().esSexiSegunSuPersonalidad(self)
	}
	
	method puntosMayorA(nro){
		return self.puntuacionPorSuDisfraz() > nro
	}
	
	method estaSatisfechoConSuDisfraz(){
		return self.puntosMayorA(10) && formaDeSatisfaccion.elDisfrazCumpleLoQueSeQuiere(self)
	}
	
	method tieneDisfraz(){
		return self.disfraz() != null
	}
}

class Disfraz{
	var nombre = ""
	var fechaDeConfeccion= 0
	//
	
	constructor(nom,fecha){
		nombre= nom
		fechaDeConfeccion  = fecha
	}
	
/* */
	
	method fechaDeConfeccion() = fechaDeConfeccion
	
	method nombre() = nombre
	
	
}

class Graciosa inherits Disfraz{
	var nivelDeGracia = 0
	
	constructor(nom,fech,valor) = super(nom,fech){
		nivelDeGracia = valor
	}
	
	method nivelDeGracia(valor){
		nivelDeGracia = valor.min(10)
	}
	
	method puntosSegunSuCaracteristicas(invitado){
		if(invitado.edad() > 50){
			return nivelDeGracia * 3
		}
		return nivelDeGracia
	}
}

class Tobara inherits Disfraz{
	method cantidadDeDiasQueFueCompradoElDisfraz(invitado){
		return invitado.fiesta().fecha() - invitado.disfraz().fechaDeConfeccion()
	}
	method puntosSegunSuCaracteristicas(invitado){
		 if(self.cantidadDeDiasQueFueCompradoElDisfraz(invitado) >= 2){
		 	return 5
		 }
		 return 3
	}
	
}

class Careta inherits Disfraz{
	var estiloAnimado = true
	
	method estiloAnimado(valor){
		estiloAnimado = valor
	}
	
	method esAnimado() = estiloAnimado
	
	method puntosSegunSuCaracteristicas(invitado){
		if(self.esAnimado()){
			return 8
		}
		return 6
	}
	
}

class Sexies inherits Disfraz{
	method puntosSegunSuCaracteristicas(invitado){
		if(invitado.esSexi()){
			return 15
		}
		return 2
	}
	
}

class ConbinacionDeCaracteristicas inherits Disfraz{
	var caracteristicas = #{}
	
	method caracteristicas(unaCaracteristica){
		caracteristicas.add(unaCaracteristica)
	}
	method puntosSegunSuCaracteristicas(invitado){
		caracteristicas.sum({c =>c.puntosSegunSuCaracteristicas(invitado)})
	}
}

// Personalidades

object alegre{
	
	method esSexiSegunSuPersonalidad(persona){
		return false
	}
}

object taciturna{
	method esSexiSegunSuPersonalidad(persona){
		return persona.edad() < 30
	}
	
}

class Cambiante{
	var personalidadDeAhora
	
	constructor(personalidad){
		personalidadDeAhora = personalidad
	}
	
	method personalidadDeAhora() = personalidadDeAhora
	
	method cambiarPersonalidad(personalidad){
		personalidadDeAhora = personalidad
	}
	
	method esSexiSegunSuPersonalidad(persona){
		return self.personalidadDeAhora().esSexiSegunSuPersonalidad(persona)
	}
}

// Sastisfecho o le devolvemos su traje

object caprichosas{
	
	method obtenerElNombreDelDisfraz(invitado){
		return invitado.disfraz().nombre()
	}
	
	method elDisfrazCumpleLoQueSeQuiere(invitado){
		return self.obtenerElNombreDelDisfraz(invitado).size().even()		
	}		
}


object pretencioso{
	
	method obtenerPeriodoDelDisfraz(invitado){
		return invitado.fiesta().fecha() - invitado.disfraz().fechaDeConfeccion()
	}
	
	method elDisfrazCumpleLoQueSeQuiere(invitado){
		return self.obtenerPeriodoDelDisfraz(invitado) >= 30	
	}	
}

class Numerologo{
	var puntoDeterminado =0
	
	constructor(punto){
		puntoDeterminado = punto
	}
	
	method puntoDeterminado(pto){
		puntoDeterminado= pto
	}
	
	method obtenerPuntoDelDisfraz(invitado){
		return invitado.disfraz().obtenerPuntoDelDisfraz(invitado)
	}
	method elDisfrazCumpleLoQueSeQuiere(invitado){
		return (self.obtenerPuntoDelDisfraz(invitado) == puntoDeterminado)	&& (invitado.puntuacionPorSuDisfraz()>10)
	}
}




