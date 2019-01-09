require "modulos/version"

Node = Struct.new(:value, :next, :prev)

class Persona

    include Comparable
  
    attr_reader :nombre, :sexo
  
    def initialize(nombre, sexo)
      @nombre,@sexo = nombre,sexo
    end
  
    def <=> other
      raise TypeError, "Se esperaba un objeto Persona" unless other.is_a?Persona
      return 1 if other.is_a?PacienteM
      return @nombre <=> other.nombre
    end
  
    def to_s
      "#{@nombre} es un#{@sexo == 'mujer' ? 'a' : nil} #{@sexo}"
    end
  
  end
  
  class Paciente < Persona
  
    attr_reader :consulta
  
    def initialize(nombre,sexo,consulta)
      super(nombre,sexo)
      @consulta = consulta
    end
  
    def to_s
      super.to_s + " con consulta en #{@consulta}"
    end
  
  end
  
  class PacienteM < Paciente
  
    attr_reader :peso,:talla,:edad,:cintura,:cadera, :menu
  
    @@factorAct = {'ninguna' => 0, 'ligera' => 0.12, 'moderada' => 0.27, 'intensa' => 0.54}
  
    def initialize(nombre,sexo,consulta,peso,talla,edad,cintura,cadera,act = 'ninguna')
      super(nombre,sexo,consulta)
      @peso,@talla,@edad,@cintura,@cadera,@act = peso,talla,edad,cintura,cadera,act
    end
  
    def addMenu(menu)
      @menu = menu
    end
  
    def menuOk?
      ((total * 0.9)..(total * 1.1)).include? @menu.kcal
    end
  
    def pesoIdeal
      (talla * 100 - 150) * 0.75 + 50
    end
  
    def basal
      (10 * peso + 6.25 * talla * 100 - 5 * edad + (sexo == 'mujer'? -161 : 5)).round(2)
    end
  
    def termogeno
      (basal * 0.1).round(2)
    end
  
    def actividad
      (basal * @@factorAct[@act]).round(2)
    end
  
    def total
      basal + termogeno + actividad
    end
  
    def imc
      @peso/(@talla * @talla)
    end
  
    def to_s
      super.to_s + " y en tratamiento"
    end
  
    def <=> other
      raise TypeError, "Se esperaba un objeto Persona" unless other.is_a?Persona
      return self.imc <=> other.imc if other.is_a?PacienteM
      return -1
    end
  
  end
  
  class PacienteT < PacienteM
  
    def <=> other
      raise TypeError, "Se esperaba un objeto Persona" unless other.is_a?Persona
      return self.total <=> other.total if other.is_a?PacienteT
      return -1
    end
  end
  
class Menu

    include Comparable
  
    def initialize(day,&block)
      @day = day
      @almuerzo = []
      @cena = []
      @desayuno = []
      if block_given?
        instance_eval &block
      end
    end
  
    def titulo(str)
      @title = str
    end
  
    def ingesta(h = {})
      @min = h[:min] if h[:min]
      @max = h[:max] if h[:max]
    end
  
    def desayuno(h = {})
      @desayuno << Label.new(h[:descripcion],h[:gramos],h[:grasas],0,h[:carbohidratos],0,h[:proteinas],
      h[:sal])
    end
  
    def almuerzo(h = {})
      @almuerzo << Label.new(h[:descripcion],h[:gramos],h[:grasas],0,h[:carbohidratos],0,h[:proteinas],
      h[:sal])
    end
  
    def cena(h = {})
      @cena << Label.new(h[:descripcion],h[:gramos],h[:grasas],0,h[:carbohidratos],0,h[:proteinas],
      h[:sal])
    end
  
    def kcal
      (@desayuno.reduce(:+) + @cena.reduce(:+) + @almuerzo.reduce(:+)).round(2)
    end
  
    def <=> (other)
      self.kcal <=> other.kcal
    end
  
    def to_s
      table = Table.new
      table << @day
      table << '' << 'grasas' << 'carbohidratos' << 'proteinas' << 'sal' << 'valor energético'
      table << 'Desayuno'
      @desayuno.each do |label|
        table << label.nombre << label.grasas << label.hc << label.protei << label.sal << label.kcal
      end
      table << ''
      table << 'Almuerzo'
      @almuerzo.each do |label|
        table << label.nombre << label.grasas << label.hc << label.protei << label.sal << label.kcal
      end
      table << ''
      table << 'Cena'
      @cena.each do |label|
        table << label.nombre << label.grasas << label.hc << label.protei << label.sal << label.kcal
      end
      table << 'Valor energético total' << self.kcal
      table.to_s
    end
  
    def self.for_sort(menus)
      for i in (0..menus.size-2)
        for j in (i+1..menus.size-1)
          if(menus[i] > menus[j])
             aux = menus[i];
             menus[i] = menus[j];
             menus[j] = aux;
          end
        end
      end
      menus
    end
  
    def self.each_sort(menus)
      array = Array.new
      menus.each do |menu|
        sz = array.size
        array.each_with_index do |menu2,i|
          array.insert(i,menu) if menu2 > menu and sz == array.size
        end
        array << menu if sz == array.size
      end
      array
    end
end    
class List

    include Enumerable
    
      def initialize
        @sz = 0
      end
    
      def <<(val)
        node = Node.new(val)
        if(@head == nil)
          @head = node
          @tail = node
        else
          node.prev = @tail
          @tail.next = node
          @tail = node
        end
        @sz += 1
        self
      end
    
      def unshift(val)
        node = Node.new(val)
        if(@head == nil)
          @head == node
          @tail == node
        else
          node.next = @head
          @head.prev = node
          @head = node
        end
        @sz -= 1
      end
    
      def insert(pos, *arg)
        node = @head
        pos.times do
          if node != nil
            node = node.next
          end
        end
        if node == @head
          self.unshift arg[0]
          self.insert(1, *arg[1, arg.size - 1])
        else
          arg.each do |item|
            if node == nil
              self << item
            else
              newNode = Node.new(item)
              newNode.prev = node.prev
              node.prev.next = newNode
              newNode.next = node
              node.prev = newNode
            end
          end
        end
        @sz += 1
      end
    
      def pop(n = 1)
        n.times do
          if(@tail != nil)
            @tail = @tail.prev
            @tail.next = nil
          end
        end
        @head = nil if @tail == nil
        @sz -= 1
      end
    
      def shift(n = 1)
        n.times do
          if @head != nil
            @head = @head.next
            @head.prev = nil
          end
        end
        @tail = nil if @head == nil
        @sz -= 1
      end
    
      def empty?
        @head == nil
      end
    
      def each
        node = @head
        while(node != nil)
          yield node.value
          node = node.next
        end
      end
    
      def reverse_each
        node = @tail
        while(node != nil)
          yield node.value
          node = node.prev
        end
      end
    
      def for_sort
        array = self.to_a
        for i in (0..array.size-2)
          for j in (i+1..array.size-1)
            if(array[i] > array[j])
               aux = array[i]
               array[i] = array[j]
               array[j] = aux
            end
          end
        end
        array
      end
    
      def each_sort
        array = Array.new
        self.each do |person|
          sz = array.size
          array.each_with_index do |person2,i|
            array.insert(i,person) if person2 > person and sz == array.size
          end
          array << person if sz == array.size
        end
        array
      end
    
    end    

    class Row < Array

        @@cols = []
      
        def << parm
          arg = parm.to_s
          if(@@cols[size])
            @@cols[size] = arg.size if arg.size > @@cols[size]
          else
            @@cols[size] = arg.size
          end
          super arg
        end
      
        def to_s
          str = String.new
          self.each_with_index do |cell,i|
            str << cell + (' ' * (@@cols[i] - cell.size + 1))
          end
          str + "\n"
        end
      
      end
      
      class Table
      
        def initialize
          @rows = []
        end
      
        def << arg
          row = Row.new
          @rows << row
          row << arg
        end
      
        def to_s
          str = String.new
          @rows.each do |row|
            str << row.to_s
          end
          str
        end
      
      end
      
    
class Label

  include Comparable

  attr_reader :nombre, :porcion, :grasas, :grasass, :hc, :azucar, :protei, :sal

  @@ir = {:kj => 8400, :kcal => 2000, :grasas => 70, :grasass => 20,
     :hc => 260, :azucar => 90, :protei => 50, :sal => 6}

  def initialize(nombre, porcion, grasas, grasass, hc, azucar, protei, sal)
    @nombre, @porcion, @grasas, @grasass, @hc, @azucar, @protei, @sal =
    nombre, porcion, grasas, grasass, hc, azucar, protei, sal
  end

  def kj
    grasas * 37 + hc * 17 + protei * 17 + sal * 25
  end

  def kcal
    grasas * 9 + hc * 4 + protei * 4 + sal * 6
  end

  def + (label)
    self.kcal + label.kcal
  end

  def coerce(arg)
    [arg,self.kcal]
  end

  def toX(method, arg = nil)
    if arg == nil
      ((send(method)*@porcion)/100).round(2)
    else
      ((send(method, arg)*@porcion)/100).round(2)
    end
  end

  def ir(method)
    ((send(method)*100)/@@ir[method]).round(2)
  end

  def <=>(label)
    return -1 if self.sal < label.sal
    return 1 if self.sal > label.sal
    return self.nombre <=> label.nombre
  end

  def to_s
    str = String.new
    str << @nombre << "\n"
    str << "\t\t\t Por 100g\t IR (100g)\t Por #{@porcion}g\t IR(#{@porcion}g)\n"
    str << "Valor energético\t #{kj}kJ/#{kcal}kcal\t #{ir(:kcal)}%\t #{toX(:kj)}kJ/#{toX(:kcal)}kcal\t #{toX(:ir,:kcal)}%\n"
    str <<"Grasas\t\t\t #{@grasas}g\t\t #{ir(:grasas)}%\t\t  #{toX(:grasas)}g\t\t  #{toX(:ir,:grasas)}%\n"
    str <<"  saturadas:\t\t #{@grasass}g\t\t #{ir(:grasass)}%\t\t  #{toX(:grasass)}g\t\t  #{toX(:ir,:grasass)}%\n"
    str <<"Hidratos de carbono\t #{@hc}g\t\t #{ir(:hc)}%\t\t  #{toX(:hc)}g\t\t  #{toX(:ir,:hc)}%\n"
    str <<"  azúcares:\t\t #{@azucar}g\t\t #{ir(:azucar)}%\t\t  #{toX(:azucar)}g\t\t  #{toX(:ir,:azucar)}%\n"
    str <<"Proteínas\t\t #{@protei}g\t\t #{ir(:protei)}%\t\t  #{toX(:protei)}g\t\t  #{toX(:ir,:protei)}%\n"
    str <<"Sal\t\t\t #{@sal}g\t\t #{ir(:sal)}%\t\t  #{toX(:sal)}g\t\t  #{toX(:ir,:sal)}%\n"
  
    end
    end



