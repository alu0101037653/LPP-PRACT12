require "spec_helper"

RSpec.describe Modulos do

  describe Menu do

    before :all do
      @menu = Menu.new("Lunes") do
        titulo "Bajo en calorı́as"
        ingesta :min => 30, :max => 35

        desayuno :descripcion => "Pan de trigo integral",
          :gramos => 100,
          :grasas => 3.3,
          :carbohidratos => 54.0,
          :proteinas => 11.0,
          :sal => 0.06

        desayuno :descripcion => "Actimel",
          :gramos => 100,
          :grasas => 3.4,
          :carbohidratos => 4.4,
          :proteinas => 3.6,
          :sal => 0.05

        almuerzo :descripcion => "Arroz",
          :gramos => 100,
          :grasas => 0.9,
          :carbohidratos => 81.6,
          :proteinas => 6.67,
          :sal => 0.04

        almuerzo :descripcion => "Lentejas",
          :gramos => 100,
          :grasas => 0.4,
          :carbohidratos => 20.0,
          :proteinas => 9.0,
          :sal => 8.0

        cena :descripcion => "Leche entera hacendado",
          :gramos => 100,
          :grasas => 3.6,
          :carbohidratos => 4.6,
          :proteinas => 3.1,
          :sal => 0.13
      end
    end

    it 'Metodo to_s' do
      table = Table.new
      table << 'Lunes'
      table << '' << 'grasas' << 'carbohidratos' << 'proteinas' << 'sal' << 'valor energético'
      table << 'Desayuno'
      table << 'Pan de trigo integral' << 3.3 << 54.0 << 11.0 << 0.06 << 290.06
      table << 'Actimel' << 3.4 << 4.4 << 3.6 << 0.05 << 62.9
      table << ''
      table << 'Almuerzo'
      table << 'Arroz' << 0.9 << 81.6 << 6.67 << 0.04 << 361.42
      table << 'Lentejas' << 0.4 << 20.0 << 9.0 << 8.0 << 167.6
      table << ''
      table << 'Cena'
      table << 'Leche entera hacendado' << 3.6 << 4.6 << 3.1 << 0.13 << 63.98
      table << 'Valor energético total' << 945.96
      expect(@menu.to_s).to eq(table.to_s)
    end

  end



  describe Enumerable do

    before :all do
      @persona1 = Persona.new('Miley','mujer')
      @persona2 = Paciente.new('Elsa','mujer','Hospital San Benito')
      @persona3 = PacienteM.new('Zac','hombre','Hospital Los Angeles',70.0,1.79,31,65.0,90.0)
      @persona4 = PacienteM.new('Sandra','mujer','Hospital Hollywood',65.0,1.60,18,60.0,90.0)
      @persona5 = PacienteM.new('Dylan','hombre','Hospital Central',70.0,1.67,23,78.0,85.0)
      @list1 = List.new << @persona1 << @persona2 << @persona3 << @persona4 << @persona5

      @label1 = Label.new('Chocolatina tirma',     32.0,     27.0,     14.0,  65.0,  50.0,    6.5,   1.51)
      @label2 = Label.new('Chips ahoy',    8.0,     24.0,     13.0,  64.0,  31.0,     5.8,   1.04)
      @label3 = Label.new('Papas Lays',  52.0,     35.1,     4.6, 47.7,  0.6,    6.3,   1.3)
      @label4 = Label.new('Turron de yema',    79.0,     23.0,     3.2,  50.0,  50.0,    9.1,   0.05)
      @label5 = Label.new('Oreo',    57.0,     21.0,     10.0,  69.0,  39.0,    4.8,   0.83)
      @list2 = List.new << @label1 << @label2 << @label3 << @label4 << @label5
    end

    it 'Método collect' do
      array_sal = @list2.collect {|label| label.sal}
      expect(array_sal).to eq([1.51, 1.04, 1.3, 0.05, 0.83])

      array_nombres = @list1.collect {|persona| persona.nombre}
      expect(array_nombres).to eq(['Miley', 'Elsa', 'Zac', 'Sandra', 'Dylan'])
    end

    it 'Método select' do
      array_pacientesM = @list1.select {|persona| persona.instance_of?PacienteM}
      expect(array_pacientesM).to eq([@persona3, @persona4, @persona5])

      array_sal = @list2.select {|label| label.sal > 1}
      expect(array_sal).to eq([@label1, @label2, @label3])
    end

    it 'Método max' do
      expect(@list1.max).to eq(@persona1)
      expect(@list2.max).to eq(@label1)
    end

    it 'Método min' do
      expect(@list1.min).to eq(@persona3)
      expect(@list2.min).to eq(@label4)
    end

    it "Método sort" do
      expect(@list1.sort).to eq([@persona3,@persona5,@persona4,@persona2,@persona1])
      expect(@list2.sort).to eq([@label4 ,@label5 ,@label2 ,@label3 ,@label1])
    end

  end

  describe Comparable do

    before :all do
      @persona1 = PacienteM.new('Sandra','mujer','Hospital Hollywood',65.0,1.60,18,60.0,90.0)
      @persona2 = PacienteM.new('Dylan','hombre','Hospital Central',70.0,1.67,23,78.0,85.0)

      @label1 = Label.new('Chocolatina tirma',     32.0,     27.0,     14.0,  65.0,  50.0,    6.5,   1.51)
      @label2 = Label.new('Chips ahoy',    8.0,     24.0,     13.0,  64.0,  31.0,     5.8,   1.04)


    end

    it 'Operador ==' do
      expect(@persona1 == @persona2).to eq(false)
      expect(@persona1 == @persona1).to eq(true)

      expect(@label1 == @label2).to eq(false)
      expect(@label1 == @label1).to eq(true)
    end

    it 'Operador !=' do
      expect(@persona1 != @persona2).to eq(true)
      expect(@persona2 != @persona2).to eq(false)

      expect(@label1 != @label2).to eq(true)
      expect(@label2 != @label2).to eq(false)
    end

    it 'Operador <' do
      expect(@persona1 < @persona2).to eq(false)
      expect(@persona2 < @persona1).to eq(true)
      expect(@persona1 < @persona1).to eq(false)

      expect(@label1 < @label2).to eq(false)
      expect(@label2 < @label1).to eq(true)
      expect(@label1 < @label1).to eq(false)
    end

    it 'Operador <=' do
      expect(@persona1 <= @persona1).to eq(true)
      expect(@persona1 <= @persona2).to eq(false)

      expect(@label1 <= @label1).to eq(true)
      expect(@label1 <= @label2).to eq(false)
    end

    it 'Operador >' do
      expect(@persona1 > @persona1).to eq(false)
      expect(@persona2 > @persona1).to eq(false)

      expect(@label1 > @label1).to eq(false)
      expect(@label2 > @label1).to eq(false)
    end

    it 'Operador >=' do
      expect(@persona1 >= @persona1).to eq(true)
      expect(@persona1 >= @persona2).to eq(true)

      expect(@label1 >= @label1).to eq(true)
      expect(@label1 >= @label2).to eq(true)
    end

  end

  describe PacienteM do

    before :all do
      @persona1 = Persona.new('Miley','mujer')
      @persona2 = Paciente.new('Elsa','mujer','Hospital San Benito')
      @persona3 = PacienteM.new('Zac','hombre','Hospital Los Angeles',70.0,1.79,31,65.0,90.0)
      @persona4 = PacienteM.new('Sandra','mujer','Hospital Hollywood',65.0,1.60,18,60.0,90.0)
      @persona5 = PacienteM.new('Dylan','hombre','Hospital Central',70.0,1.67,23,78.0,85.0)

      @list = List.new << @persona1 << @persona2 << @persona3 << @persona4 << @persona5
    end

    it 'Comprobando clases' do
      expect(@persona1.class).to eq(Persona)
      expect(@persona2.class).to eq(Paciente)
      expect(@persona3.class).to eq(PacienteM)
      expect(@persona4.class).to eq(PacienteM)
      expect(@persona5.class).to eq(PacienteM)
    end

    it 'Comprobando jerarquía' do
      @list.each do |persona|
        expect(persona.is_a?Persona).to eq(true)
      end
    end

    it 'Ordenando por masa corporal' do
      orderedArray = @list.sort
      expect(orderedArray).to eq([@persona3,@persona5,@persona4,@persona2,@persona1])
    end

    it 'Método to_s' do
      expect(@persona1.to_s).to eq('Miley es una mujer')
      expect(@persona2.to_s).to eq('Elsa es una mujer con consulta en Hospital San Benito')
      expect(@persona5.to_s).to eq('Dylan es un hombre con consulta en Hospital Central y en tratamiento')
    end

  end

  describe List do

    before :all do
      @label1 = Label.new('Chocolatina tirma',     32.0,     27.0,     14.0,  65.0,  50.0,    6.5,   1.51)
      @label2 = Label.new('Chips ahoy',    8.0,     24.0,     13.0,  64.0,  31.0,     5.8,   1.04)
      @label3 = Label.new('Papas Lays',  52.0,     35.1,     4.6, 47.7,  0.6,    6.3,   1.3)
      @label4 = Label.new('Turron de yema',    79.0,     23.0,     3.2,  50.0,  50.0,    9.1,   0.05)
      @label5 = Label.new('Oreo',    57.0,     21.0,     10.0,  69.0,  39.0,    4.8,   0.83)

    end

    before :each do
      @list = List.new
      @list << @label1 << @label2 << @label3 << @label4 << @label5
    end

    it "Operador <<" do
      expect(@list.to_a).to eq([@label1, @label2, @label3, @label4, @label5])
    end

    it "Método each" do
      array = []
      @list.each do |label|
        array << label
      end
      expect(array).to eq([@label1, @label2, @label3, @label4, @label5])
    end

    it "Método reverse_each" do
      array = []
      @list.reverse_each do |label|
        array << label
      end
      expect(array).to eq([@label5, @label4, @label3, @label2, @label1])
    end

    it "Método unshift" do
      @list.unshift @label5
      @list.unshift @label4
      expect(@list.to_a).to eq([@label4, @label5, @label1, @label2, @label3, @label4, @label5])
    end

    it "Método insert" do
      @list.insert(5,@label5)
      @list.insert(0,@label1,@label2)
      @list.insert(2,@label3)
      expect(@list.to_a).to eq([@label1,@label2,@label3,@label1, @label2, @label3, @label4, @label5, @label5])
    end

    it "Método pop" do
      @list.pop 2
      expect(@list.to_a).to eq([@label1, @label2, @label3])
    end

    it "Método shift" do
      @list.shift
      @list.shift 2
      expect(@list.to_a).to eq([@label4, @label5])
    end

    it "Método sort" do
      ordered_array = @list.sort
      expect(ordered_array).to eq([@label4 ,@label5 ,@label2 ,@label3 ,@label1])
    end

  end

  describe Label do

    before :all do
      @NOMBRE, @PORCION, @GRASAS, @GRASASS,@HC, @AZUCAR, @PROTEI, @SAL =
     'Chocolatina tirma',     32.0,     27.0,     14.0,  65.0,  50.0,    6.5,   1.51 
      @label = Label.new(@NOMBRE,@PORCION,@GRASAS,@GRASASS,@HC,@AZUCAR,@PROTEI,@SAL)
    end

    it "Almacenamiento de los datos" do
      expect(@label.nombre).to eq(@NOMBRE)
      expect(@label.porcion).to eq(@PORCION)
      expect(@label.grasas).to eq(@GRASAS)
      expect(@label.grasass).to eq(@GRASASS)
      expect(@label.hc).to eq(@HC)
      expect(@label.azucar).to eq(@AZUCAR)
      expect(@label.protei).to eq(@PROTEI)
      expect(@label.sal).to eq(@SAL)
    end

    it "Valor energético por 100g" do
      expect(@label.kj).to eq(2252.25)
      expect(@label.kcal).to eq(538.06)
    end

    it "Valores por porción" do
	    expect(@label.toX(:grasas)).to eq(8.64)
	    expect(@label.toX(:kj)).to eq(720.72)
    end

    it "Ingesta de referencia por 100 g" do
      expect(@label.ir(:kcal)).to eq(26.9)
      expect(@label.ir(:hc)).to eq(25.0)
    end

    it "Ingesta de referencia por porción" do
      expect(@label.toX(:ir,:kcal)).to eq(8.61)
      expect(@label.toX(:ir,:hc)).to eq(8.0)
    end

    it "Imprimiendo etiqueta" do
      expect(@label.to_s.class).to eq(String)
    end

  end

end
