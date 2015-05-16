
module MessagesHelper
  
	class RSA

		E = 65537

		class << self

			def encrypt( m, n, bits )
				encrypt_array = Array.new
				message_array = sep_str_msg(m, bits, true)
				message_array.each do |sub_message|
					sub_message = s_to_n( sub_message )  
					encrypt_array.push(mod_pow( sub_message, E, n ).to_s(16))
				end
				encrypt_array.join
			end

			def decrypt( c, n, d, bits )
				decrypt_array = Array.new
				message_array = sep_str_msg(c, bits, false) 
				message_array.each do |sub_message|
					sub_message = mod_pow(sub_message.to_i(16), d, n )
					decrypt_array.push(n_to_s( sub_message ))
				end	
				decrypt_array.join
			end

			 def generate_keys( bits )
				n, e, d = 0
				p = random_prime( bits )
				q = random_prime( bits )
				n = p * q
				d = get_d( p, q, E )
				[n, E, d]
			end

			private

			def prime? n
				n = n.abs
				return true if n == 2
				return false if n == 1 || n & 1 == 0
				return false if n > 3 && n % 6 != 1 && n % 6 != 5

				d = n-1
				d >>= 1 while d & 1 == 0
				20.times do
				 a = rand(n-2) + 1
				 t = d
				 y = mod_pow( a, t, n )
				 while t != n-1 && y != 1 && y != n-1
					 y = (y * y) % n
					 t <<= 1
				 end
				 return false if y != n-1 && t & 1 == 0
				end
				return true
			end


			def mod_pow( base, power, mod )
			 res = 1
			 while power > 0
				 res = (res * base) % mod if power & 1 == 1
				 base = base ** 2 % mod
				 power >>= 1
			 end
			 res
			end

			def sep_str_msg(str,bits,str_factor)
        str_array = Array.new
        max_bytesize = str_factor ? (bits/4) : (bits/2)
				while(str.size > max_bytesize)  
					sub_str = str.slice(0..max_bytesize-1)
					str_array.push(sub_str)
					str.slice!(0..sub_str.size-1)
				end
				return str_array.push(str)
			end

      def extended_gcd( e, n )
				return [0,1] if e % n == 0
				x, y = extended_gcd( n, e % n )
				[y, x - y * (e / n)]
			end

			def e_func(p,q)
				(p-1)*(q-1)
			end 

			def get_d(p, q, e)
				n = e_func( p, q )
				x, y = extended_gcd( e, n )
				x += n if x < 0
				x
			end

			def random_prime( bits )
				begin
					n = random_number( bits )
					return n if prime?(n)
				end while true
			end

			def n_to_s( n )
				s = ""
				while( n > 0 )
					s = ( n & 0xFF ).chr + s
					n >>= 8
				end
				s
			end

			def s_to_n( s )
				n = 0
				s.each_byte do |b|
					n = n * 256 + b
				end
				n
			end

			def random_number( bits )
				m = (1..bits-2).map{ rand() > 0.5 ? '1' : '0' }.join
				s = "1" + m + "1"
				s.to_i( 2 )
			end

		end  
	end    
end 



