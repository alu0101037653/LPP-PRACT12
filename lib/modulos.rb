require "modulos/version"

Node = Struct.new(:value, :next, :prev)

class Etiqueta
	include Comparable
	attr_reader :nom, :val, :gras, :gras_sa, :hc, :azu, :pro, :sal

	def initialize(nom, val, gras, gras_sa, hc, azu, pro, sal)
		@nom = nom
		@val = val
		@gras = gras
		@gras_sa = gras_sa
		@hc = hc
		@azu = azu
		@pro = pro
		@sal = sal
	end

	def valorEnergeticoKcal
		(@gras * 9) + (@hc * 4) + (@pro * 4)
	end

	def to_s()
		"#{self.class}: #{@nom},#{@val},#{@gras},#{@gras_sa},#{@hc},#{@azu},#{@pro},#{@sal}"
	end

	def <=>(other)
		return @nom <=> other.nom 
		return @val <=> other.val 
		return @gras <=> other.gras 
		return @gras_sa <=> other.gras_sa 
		return @hc <=> other.hc 
		return @azu <=> other.azu 
		return @pro <=> other.pro 
		return @sal <=> other.sal
	end


end

class Comida < Etiqueta
	attr_reader :lipido, :fibra

		def initialize(nom, val, gras, gras_sa, hc, azu, pro, sal, lip, fibra)
			super(nom, val, gras, gras_sa, hc, azu, pro, sal)
			@lip = lip
			@fibra = fibra
		end

		def to_s()
			"#{self.class}: #{@nom},#{@val},#{@gras},#{@gras_sa},#{@hc},#{@azu},#{@pro},#{@sal},#{@lip},#{@fibra}"
		end

		def valor_energetico
			return (9 * @gras) + (4* @hc) + (2.4 * @azu) + (4 * @lip) + (2 * @fibra) + (4 * @pro) + (6 * @sal)
		end
	end

class List
	include Enumerable
	attr_reader :Size, :Head, :Tail

	def initialize(value = nil)
		@Size = 0
		@Head = nil
		@Tail = nil
	end

	def push_start(value)
		nodo = Node.new(value,nil,nil)
		if(@Size == 0)
			@Tail = nodo
			@Tail.next = nil
		else
			@Head.prev = nodo
			nodo.next = @Head
		end

		@Head = nodo
		@Head.prev = nil
		@Size = @Size + 1
	end

	def push_end(value)
		nodo = Node.new(value,nil,nil)
		if(@Size == 0)
			@Head = nodo
			@Head.prev = nil
		else
			@Tail.next = nodo
			nodo.prev = @Tail
		end

		@Tail = nodo
		@Tail.next = nil
		@Size = @Size + 1
	end

	def pop_start()
		if(@Size == 0)
			puts "La lista esta vacia"
		elsif(@Size == 1)
			@Head = nil
			@Size = 0
		else
			@Head.next.prev = nil
			@Head = @Head.next
			@Size = @Size - 1
		end
	end

	def pop_end()
		if(@Size == 0)
		elsif(@Size == 1)
			@Tail = nil
			@Size = 0
		else
			@Tail.prev.next = nil
			@Tail = @Tail.next
			@Size = @Size - 1
		end
	end

	def get_size()
		@Size
	end

	def each
		return nil unless @Size > 0
		aux = @Head
		until aux.nil?
			yield aux.value
			aux = aux.next
		end
	end

	def sort_for
		sorted = [@Head.value]
		aux = @Head
		sz = @Size
		for i in (1...sz)
			aux = aux.next
			for j in (0..sorted.size)
				if (j == sorted.size)
					sorted.push(aux.value)
				elsif (aux.value < sorted[j])
					sorted.insert(j, aux.value)
					break
				end
			end
		end
		return sorted
	end

	def sort_each
		sorted = [@Head.value]
		self.each_with_index do |x, pos_x|
			if (pos_x != 0)
				sorted.each_with_index do |y, pos_y|
					if (pos_y == sorted.size - 1)
						if (x < y)
							sorted.insert(pos_y, x)
							break
						else
							sorted.push(x)
							break
						end
					elsif(x < y)
						sorted.insert(pos_y, x)
						break
					end
				end
			end
		end
		return sorted
	end

	def to_s()
		cadena = "{"
		aux = self.Head
		while aux != nil
			cadena = cadena + aux.value.to_s
			if(aux.next != nil)
				cadena = cadena + ", "
			end
			aux = aux.next
		end
		cadena = cadena + "}"
		cadena
	end
end

class Menu
	attr_reader :lista
	def initialize
		@lista = List.new()
	end

	def add_alimento(alimento)
		@lista.push_end(alimento)
	end

	def to_s
		@lista.to_s
	end

	def energia
		energy=0
		@lista.collect{|entry| energy = energy + entry.valor_energetico}
		return energy
	end
end

class Array
       	def kcal_for
	       	total = 0
		for i in (0...self.size)
			total += self[i].valorEnergeticoKcal
		end
		total
	end
	
	def sort_for
                sorted = [self[0]]
                for i in (1...self.size)
			actual = self[i]
                        for j in (0..sorted.size)
				if (j == sorted.size)
					sorted.push(actual)
                                elsif (actual.kcal_for < sorted[j].kcal_for)
					sorted.insert(j, actual)
                                        break
				end
			end
		end
		return sorted
	end

	def kcal_each
		self.collect{|comida| comida.valorEnergeticoKcal;}.reduce(:+).round(2)
	end

	def sort_each
		sorted = [self[0]]
		self.each_with_index do |x, pos_x|
			if (pos_x != 0)
				sorted.each_with_index do |y, pos_y|
					if (pos_y == sorted.size - 1)
						if (x.kcal_each < y.kcal_each)
							sorted.insert(pos_y, x)
							break
						else
							sorted.push(x)
							break
						end
					elsif (x.kcal_each < y.kcal_each)
						sorted.insert(pos_y, x)
						break
					end
				end
			end
		end
		return sorted
	end
end

module Valoracion
	class Nutricion
		include Comparable
		attr_reader :peso, :al, :edad, :cin, :ca, :so

		def initialize(peso, al, edad, cin, ca, so)
			@peso = peso
			@al = al
			@edad = edad
			@cin = cin
			@ca = ca
			@so = so
		end

		def to_s()
			"#{self.class}: #{@peso},#{@al},#{@edad},#{@cin},#{@ca},#{@so}"
		end

		def <=>(other)
			return @peso <=> other.peso
			return @al <=> other.al
			return @edad <=> other.edad
			return @cin <=> other.cin 
			return @ca <=> other.ca
		end

		def masacorporal
			imc = (@peso/(@al*@al))
		end

		def resultados_imc
			imc = masacorporal
			imc.round(2)
			if imc < 18.50
				"IMC = #{imc}; Bajo peso"
			elsif imc < 25.00
				"IMC = #{imc}; Adecuado"
			elsif imc < 30.00
				"IMC = #{imc}; Sobrepeso"
			elsif imc < 35.00
				"IMC = #{imc}; Obesidad grado 1"
			elsif imc < 40.00 
				"IMC = #{imc}; Obesidad grado 2"
			else
				"IMC = #{imc}; Obesidad grado 3"
			end
		end

		def grasaabdominal
			rcc = @cin/@ca
		end

		def resultados_rcc
			rcc = grasaabdominal
			rcc.round(2)

			if @so == 0
				if ((rcc >= 0.72) && (rcc <= 0.75))
					"RCC = #{rcc}; Bajo"
				elsif ((rcc >= 0.78) && (rcc <= 0.82))
					"RCC = #{rcc}; Moderado"
				elsif rcc > 0.82
					"RCC = #{rcc}; Alto"
				end
			elsif @so == 1
				if ((rcc >= 0.83) && (rcc <= 0.88))
					"RCC = #{rcc}; Bajo"
				elsif ((rcc >= 0.88) && (rcc <= 0.95))
					"RCC = #{rcc}; Moderado"
				elsif ((rcc >= 0.95) && (rcc <= 1.01))
					"RCC = #{rcc}; Alto"
				elsif rcc > 1.01
					"RCC = #{rcc}; Muy alto"
				end
			end
		end

	end

	class Sujeto < Nutricion
		attr_reader :paciente, :tratamiento

		def initialize(paciente, peso, al, edad, cin, ca, so)
			super(peso,al,edad,cin,ca,so)
			@paciente = paciente
			imc = masacorporal
			imc.round(2)

			if imc < 35.00
				@tratamiento = 0
			else
				@tratamiento = 1
			end
		end

		def to_s
			if @paciente < 1
				pacient = "No es paciente de una consulta"
			else
				pacient = "Es paciente de una consulta"
			end

			if @tratamiento < 1
				tratamient = "No esta en tratamiento para la obesidad"
			else
				tratamient = "Esta en tratamiento para la obesidad"
			end

			"(#{@peso},#{@al},#{@edad},#{@cin},#{@ca},#{@so},#{pacient},#{tratamient})"
		end
	end




	class Individuo < Nutricion
		attr_reader :factor_a_f, :peso_t_i, :gasto_e_b, :efecto_t, :gasto_a_f, :gasto_e_t

 		def initialize(factor_a_f, peso, al, edad, cin, ca, so)
                        super(peso, al, edad, cin, ca, so)
			@factor_a_f = factor_a_f
			if @factor_a_f == "Reposo"
				factor_a_f = 0.0
			elsif @factor_a_f == "Actividad ligera"
				factor_a_f = 0.12
			elsif @factor_a_f == "Actividad moderada"
				factor_a_f = 0.27
			elsif @factor_a_f == "Actividad intensa"
				factor_a_f = 0.54
			else
				factor_a_f =0
			end

			@peso_t_i = (al - 150) * 0.75 + 50
			if @so == 0
				@gasto_e_b = (10 * peso) + (6.25 * al) - (5 * edad) - 161
			else
				@gasto_e_b = (10 * peso) + (6.25 * al) - (5 * edad) +5
			end

			@efecto_t = @gasto_e_b * 0.1
			@gasto_a_f = @gasto_e_b * factor_a_f
			@gasto_e_t = @gasto_e_b + @efecto_t + @gasto_a_f

		end

		def to_s
                        "(#{@factor_a_f},#{@peso},#{@al},#{@edad},#{@cin},#{@ca},#{@so})"
                end

		def exigencia_c(cal_menu)
                        if cal_menu < (@gasto_e_t - (@gasto_e_t * 0.1))
                                "La cantidad de la alimentación no es suficiente para cubrir las exigencias calóricas del organismo"
                        elsif cal_menu > (@gasto_e_t + (@gasto_e_t * 0.1))
				"La cantidad de la alimentación es suficiente para cubrir las exigencias calóricas del organismo y mantiene el equilibrio de su balance"
                        end
                end

	end
end
