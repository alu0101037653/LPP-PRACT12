require 'spec_helper'

RSpec.describe Modulos do

      before :each do
      		@etq1 = Etiqueta.new("Chocolatina tirma",2132,27,14,65,50,6.5,1.51)
  		@etq2 = Etiqueta.new("Chips ahoy",2108,24,13,64,31,5.8,1.04)
		@etq3 = Etiqueta.new("Papas Lays",2252,35.1,4.6,47.7,0.6,6.3,1.3)
		@etq4 = Etiqueta.new("Turron de yema",1879,23,3.2,50,50,9.1,0.05)
		@etq5 = Etiqueta.new("Oreo",2057,21,10,69,39,4.8,0.83)

		@nut1 = Valoracion::Sujeto.new(1,70.0,1.78,65.0,90.0,1)
		@nut2 = Valoracion::Sujeto.new(0,80.0,1.8,75.0,95.0,0)
		@nut3 = Valoracion::Sujeto.new(0,65.0,1.6,60.0,90.0,0)
		@nut4 = Valoracion::Sujeto.new(1,75.0,1.68,70.0,95.0,1)
		@nut5 = Valoracion::Sujeto.new(1,79.0,1.65,80.0,85.0,1)

		@l = List.new()
		@l2 = List.new()

      end

      describe Etiqueta do
	      describe "Inicializar" do
		      it "Se debe inicializar la lista" do
			      @l = List.new()
		      end

		      it "Se debe inicializar un nodo" do
			      @nodo = Node.new("etiqueta",nil,nil)
		      end
	      end

	      describe "Alimentos" do
		      it "Debe existir un metodo para obtener el nombre" do
			      @etq = Etiqueta.new("Nombre",2132,27,14,65,50,6.5,1.51)
			      expect(@etq.nom).to eq("Nombre")
		      end

		      it "Debe existir un metodo para obtener el valor energetico" do
			      @etq = Etiqueta.new("Nombre",2132,27,14,65,50,6.5,1.51)
			      expect(@etq.val).to eq(2132)
		      end

		      it "Debe existir un metodo para obtener la cantidad de grasas" do
			      @etq = Etiqueta.new("Nombre",2132,27,14,65,50,6.5,1.51)
			      expect(@etq.gras).to eq(27)
		      end

		      it "Debe existir un metodo para obtener la cantidad de grasas saturadas" do
			      @etq = Etiqueta.new("Nombre",2132,27,14,65,50,6.5,1.51)
			      expect(@etq.gras_sa).to eq(14)
		      end

		      it "Debe existir un metodo para obtener la cantidad de hidratos de carbono" do
			      @etq = Etiqueta.new("Nombre",2132,27,14,65,50,6.5,1.51)
			      expect(@etq.hc).to eq(65)
		      end

		      it "Debe existir un metodo para obtener la cantidad de azucares" do
			      @etq = Etiqueta.new("Nombre",2132,27,14,65,50,6.5,1.51)
			      expect(@etq.azu).to eq(50)
		      end

		      it "Debe existir un metodo para obtener la cantidad de proteinas" do
			      @etq = Etiqueta.new("Nombre",2132,27,14,65,50,6.5,1.51)
			      expect(@etq.pro).to eq(6.5)
		      end

		      it "Debe existir un metodo para obtener la cantidad de sal" do
			      @etq = Etiqueta.new("Nombre",2132,27,14,65,50,6.5,1.51)
			      expect(@etq.sal).to eq(1.51)
		      end
	      end

	      describe "Comparar la informacion nutricional entre dos etiquetas" do
		      it "Mayor" do
			      expect(@etq1 > @etq2).to eq(true)
		      end

		      it "Mayor o igual" do
			      expect(@etq1 >= @etq2).to eq(true)
		      end

		      it "Menor" do
			      expect(@etq2 < @etq1).to eq(true)
		      end

		      it "Menor o igual" do
			      expect(@etq2 <= @etq1).to eq(true)
		      end

		      it "Igual" do
			      expect(@etq1 == @etq1).to eq(true)
		      end

		      it "Diferente" do
			      expect(@etq1 != @etq2).to eq(true)
		      end
	      end
      end

      describe List do
	      it "Se puede insertar un elemento por el Head" do
		      @etq = Etiqueta.new("Nombre",2132,27,14,65,50,6.5,1.51)
		      @l = List.new()
		      @l.push_start(@etq)
	      end

	      it "Se puede insertar un elemento por el Tail" do
		      @l.push_end(@etq)
	      end

	      it "Se pueden insertar varios elementos" do
		      @l.push_start(@etq2)
		      @l.push_start(@etq1)
		      @l.push_end(@etq3)
		      @l.push_end(@etq4)
		      @l.push_end(@etq5)
		      expect(@l.get_size()).to eq(5)
	      end

	      it "Se puede extraer el primer elemento de la lista" do
		      @l.push_start(@etq1)
		      @l.push_end(@etq5)
		      @l.pop_start()
	      end

	      it "Se puede extraer el ultimo elemento de la lista" do
		      @l.push_start(@etq1)
		      @l.push_end(@etq5)
		      @l.pop_end()
	      end

	      it "Clasificacion de las etiquetas segun los gramos de sal" do
		      @l.push_start(@etq1)
		      @l.push_start(@etq2)
		      @l.push_start(@etq3)
		      @l.push_start(@etq4)
		      @l.push_start(@etq5)
		      expect(@l.Head.value.sal < 6).to eq(true)
		      expect(@l.Head.next.value.sal < 6).to eq(true)
		      expect(@l.Head.next.next.value.sal < 6).to eq(true)
		      expect(@l.Tail.prev.value.sal < 6).to eq(true)
		      expect(@l.Tail.value.sal < 6).to eq(true)
		      @l.push_end(@etq1)
		      @l.push_end(@etq2)
		      @l.push_end(@etq3)
		      @l.push_end(@etq4)
		      @l.push_end(@etq5)
	      end

	      describe "Enumerable - Etiqueta" do
		      it "Metodo max" do
			      @l2.push_start(@etq1)
			      @l2.push_start(@etq2)
			      expect(@l2.max).to eq(@etq1)
		      end

		      it "Metodo min" do
			      @l2.push_start(@etq1)
			      @l2.push_start(@etq2)
			      expect(@l2.min).to eq(@etq2)
		      end

		      it "Metodo sort" do
			      @l2.push_start(@etq1)
			      @l2.push_start(@etq2)
			      expect(@l2.sort).to eq([@etq2,@etq1])
		      end

		      it "Metodo collect" do
			      @l2.push_start(@etq1)
			      expect(@l2.map{|i| i}).to eq([@etq1])
			      expect(@l2.collect{|i| i}).to eq([@etq1])
		      end

		      it "Metodo select" do
			      @l2.push_start(@etq1)
			      expect(@l2.select{|i| i}).to eq([@etq1])
		      end
	      end

	      describe "Enumerable - Valoracion" do
		      it "Metodo max" do
			      @l2.push_start(@nut3)
			      @l2.push_start(@nut4)
			      expect(@l2.max).to eq(@nut4)
		      end

		      it "Metodo min" do
			      @l2.push_start(@nut3)
			      @l2.push_start(@nut4)
			      expect(@l2.min).to eq(@nut3)
		      end

		      it "Metodo sort" do
			      @l2.push_start(@nut3)
			      @l2.push_start(@nut4)
			      expect(@l2.sort).to eq([@nut3,@nut4])
		      end

		      it "Metodo collect" do
			      @l2.push_start(@nut3)
			      expect(@l2.map{|i| i}).to eq([@nut3])
			      expect(@l2.collect{|i| i}).to eq([@nut3])
		      end

		      it "Metodo select" do
			      @l2.push_start(@nut3)
			      expect(@l2.select{|i| i}).to eq([@nut3])
		      end
	      end


      end

      describe Valoracion::Sujeto do
	      it "Se debe crear individuos" do
		      @suj = Valoracion::Sujeto.new(1,70.0,1.78,65.0,90.0,1)
	      end

	      it "Se debe comprobar la clase" do
		      expect(@nut1.class).to eq(Valoracion::Sujeto)
		      expect(@nut1.instance_of? Valoracion::Sujeto).to eq(true)
		      expect(@nut1.is_a? Valoracion::Sujeto).to eq(true)
		      expect(@nut1.is_a? Object).to eq(true)
		      expect(@nut1.kind_of? Valoracion::Sujeto).to eq(true)
	      end

	      it "Se debe comprobar el tipo" do
		      expect(@nut1.respond_to?:paciente).to eq(true)
	      end

	      it "Se debe comprobar la jerarquia" do
		      expect(@nut1.class.superclass).to eq(Valoracion::Nutricion)
		      expect(@nut1.class.superclass.superclass).to eq(Object)
		      expect(@nut1.class.superclass.superclass.superclass).to eq(BasicObject)
		      expect(@nut1.class.superclass.superclass.superclass.superclass).to eq(nil)
	      end

	      it "Clasificacion de individuos segun su IMC" do
		      @l.push_end(@nut1)
		      @l.push_end(@nut2)
		      @l.push_end(@nut3)
		      @l.push_end(@nut4)
		      @l.push_end(@nut5)

		      aux = @l.Head
		      while aux.next != nil
			      aux2 = aux.next
			      while aux2 != nil
				      if(aux.value.masacorporal > aux2.value.masacorporal)
					      max = aux2.value
					      aux2.value = aux.value
					      aux.value = max
				      end
				      aux2 = aux2.next
			      end
			      aux = aux.next
		      end

		      aux = @l.Head
		      aux2 = @l.Head.next

		      while aux2 != nil
			      expect(aux.value.masacorporal < aux2.value.masacorporal).to eq(true)
			      aux2 = aux2.next
			      aux = aux.next
		      end
	      end
	      
	      describe "Comparar la valoracion nutricional entre dos individuos" do
		      it "Mayor" do
			      expect(@nut4 > @nut3).to eq(true)
		      end

		      it "Mayor o igual" do
			      expect(@nut4 >= @nut3).to eq(true)
		      end

		      it "Menor" do
			      expect(@nut3 < @nut4).to eq(true)
		      end

		      it "Menor o igual" do
			      expect(@nut3 <= @nut4).to eq(true)
		      end

		      it "Igual" do
			      expect(@nut3 == @nut3).to eq(true)
		      end

		      it "Diferente" do
			      expect(@nut3 != @nut4).to eq(true)
		      end
	      end
      end
end
