defmodule Backend.SecretKey do
  def fetch do
    jwk = JOSE.JWK.from_pem_file("ec-secp521r1.pem")
    IO.inspect jwk
    jwk
  end
end
