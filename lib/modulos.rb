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

	def to_s()
		"#{self.class}: #{@nom},#{@val},#{@gras},#{@gras_sa},#{@hc},#{@azu},#{@pro},#{@sal}"
	end

	def <=>(other)
		return @nom <=> other.nom #unless @nom && other.nom == @nom
		return @val <=> other.val #unless @val && other.val == @val
		return @gras <=> other.gras # unless @gras && other.gras = @gras
		return @gras_sa <=> other.gras_sa # unless @gras_sa && other.gras_sa == @gras_sa
		return @hc <=> other.hc #unless @hc && other.hc == @hc
		return @azu <=> other.azu #unless @azu && other.azu == @azu
		return @pro <=> other.pro #unless @pro == other.pro
		return @sal <=> other.sal
	end


end

class List
	include Enumerable
	attr_reader :Size, :Head, :Tail

	def initialize()
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

module Valoracion
	class Nutricion
		include Comparable
		attr_reader :peso, :al, :cin, :ca, :so

		def initialize(peso, al, cin, ca, so)
			@peso = peso
			@al = al
			@cin = cin
			@ca = ca
			@so = so
		end

		def to_s()
			"#{self.class}: #{@peso},#{@al},#{@cin},#{@ca},#{@so}"
		end

		def <=>(other)
			return @peso <=> other.peso
			return @al <=> other.al
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

			if @sexo == 0
				if ((rcc >= 0.72) && (rcc <= 0.75))
					"RCC = #{rcc}; Bajo"
				elsif ((rcc >= 0.78) && (rcc <= 0.82))
					"RCC = #{rcc}; Moderado"
				elsif rcc > 0.82
					"RCC = #{rcc}; Alto"
				end
			elsif @sexo == 1
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

		def initialize(paciente, peso, al, cin, ca, so)
			super(peso,al,cin,ca,so)
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

			"(#{@peso},#{@al},#{@cin},#{@ca},#{@so},#{pacient},#{tratamient})"
		end
	end
end
