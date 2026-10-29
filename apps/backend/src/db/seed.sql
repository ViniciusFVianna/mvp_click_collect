INSERT INTO lojas (nome, endereco, cep, latitude, longitude) VALUES
('MegaLoja Centro', 'Av. dos Andradas, 1000 - Centro, Porto Alegre - RS', '90020-000', -30.0301, -51.2287),
('MegaLoja Shopping Iguatemi', 'Av. João Wallig, 1800 - Passo d''Areia, Porto Alegre - RS', '91340-000', -30.0245, -51.1612),
('MegaLoja Canoas', 'Av. Getúlio Vargas, 5000 - Centro, Canoas - RS', '92010-000', -29.9189, -51.1781);

INSERT INTO estoque_loja (loja_id, produto_id, quantidade) VALUES
(1, 'TV-LED-50', 5),
(2, 'TV-LED-50', 1),
(3, 'TV-LED-50', 10);
