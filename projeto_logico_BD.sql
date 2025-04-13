-- ecommerce
-- drop database ecommerce;  
CREATE DATABASE IF NOT EXISTS ecommerce;
USE ecommerce;

-- tabela cliente(clients):
create table clients (
     idClient int auto_increment primary key,
     Fname varchar(100),
     Minit char(3),
     Lname varchar(200),
     CNPJ char(14)null,
     CPF char(11)null,
     Address varchar(300),
     constraint unique_cpf_client unique (CPF),
     constraint unique_cnpj_client unique (CNPJ)
);
alter table clients auto_increment = 1;
desc Clients;

-- tabela produto:(product)   * Size = dimenção do pedido
create table Product (
     idProduct int auto_increment primary key,
     Pname varchar(100) not null,
     Classification_kids bool default false,
     Category enum('Eletrônico', 'Vestimenta', 'Brinquedos', 'Alimentos', 'móveis') not null,
     Avaliação float default 0,
     Size varchar(100)
);
desc Product;

-- tabela pedidos (Orders) e de pagamentos(payments)...BUT;
-- Para ser continuado o desafio, termine de implementar a tabela e crie a conexão com as tabelasnecessarias
-- Além disso reflita essa modificação no diagrama de esquema relacional
-- criar contraints relacionada ao pagamento

-- payments -> NÃO CRISR, PQ VAI DA RUIM, DEVO DESENVLVER PRIMEIRO NO DESAFIO, AQUI TA SÓ A DICA
create table payments(
     IdClient int,
     idPayment int,
     typePayment enum('Boleto','Cartão','Dois Cartões'),
     limitAvailable float,
     primary key(idClient, idPayment)
);

-- orders
create table orders(
     idOrder int auto_increment primary key,
     idOrderClient int,
     orderStatus enum('Cancelado','Confirmado','Processando') default 'Processando',
     orderDescription varchar(255),
     sendValue float default 10,
	 paymentCash bool default false,     -- SIGNIFICA PG NO BOLETO. CASO PG SEJA OUTRO MEIO JÁ ESTA COM DEFAULT FALSE.
     constraint fk_orders_client foreign key (idOrderClient) references clients(idClient)
               on update cascade
);
desc orders;



-- TABLE ESTOQUE
create table productStorage(
     idproductStorage int auto_increment primary key,
     idOrderClient int,
     storageLocation varchar(255),
     quantity int default 0
);
desc productStorage;

-- TABLE FORNECEDOR (supplier)
create table supplier(
     idSupplier int auto_increment primary key,
     SocialName varchar(255) not null,
     CNPJ char(15) not null,
     contact char(11) not null,
     constraint unique_supplier unique (CNPJ)
);
desc supplier;
SELECT * FROM supplier WHERE idSupplier IN (1, 2, 3);

-- TABLE VENDEDOR (SELLER)
create table seller(
     idSeller int auto_increment primary key,
     SocialName varchar(255) not null,
     AbstName varchar(255),
     CNPJ char(14),
     CPF char(11),
     location varchar(255),
     contact char(11) not null,
     constraint unique_cnpj_seller unique (CNPJ),
	 constraint unique_cpf_seller unique (CPF)
);
desc seller;

-- table produtos/vendedor (product/seller)
create table productSeller(
     idPseller int,
     idPproduct int,
     prodQuantity int default 1,
     primary key (idPseller, idPproduct),
     constraint fk_Pseller foreign key (idPseller) references seller(idSeller),
	 constraint fk_Pproduct foreign key (idPproduct) references product(idProduct)
);
desc productSeller;

create table productOrder(
     idPOproduct int,
     idPOorder int,
     poQuantity int default 1,
     poStatus enum('Disponível','Sem Estoque') default 'Disponível',
     primary key (idPOproduct, idPOorder),
     constraint fk_product_seller foreign key (idPOproduct) references product(idProduct),
	 constraint fk_product_product foreign key (idPOorder) references orders(idOrder)
);
desc productOrder;

create table storageLocation(
     idLproduct int,
     idLstorage int,
     location varchar(255) not null,
     primary key (idLproduct, idLstorage),
     constraint fk_storage_location_product foreign key (idLproduct) references product(idProduct),
	 constraint fk__storage_location_storage foreign key (idLstorage) references productStorage(idproductStorage)
);
desc storageLocation;

create table productSupplier(
     idPsSupplier int,
     idPsProduct int,
     quantity int not null,
     primary key (idPsSupplier, idPsProduct),
     constraint fk_product_supplier_supplier foreign key (idPsSupplier) references supplier(idSupplier),
	 constraint fk_product_supplier_product_ foreign key (idPsProduct) references product(idProduct)
);

desc productSupplier;
show tables;

show databases;
use information_schema;
show tables;
desc referential_constraints;

select * from referential_constraints where constraint_schema = 'ecommerce';


-- QUERIES

-- QUERIES AND INSERT
use ecommerce;
show tables;

-- idClient: Fname, Mint, Lname, CPF and Address
insert into clients(Fname, Minit, Lname,CNPJ, CPF, Address) 
     values('Maria','M','Silva',21222415000147,12312312301,'rua silva de prata 29, Carangola - Cidade das Flores'),
		   ('Matheus','O','Pimentel',null,9875432199,'rua alemeda 29, Centro - Cidade das Flores'),
           ('Ricardo','F','Silva',01223252000147,45791388,'rua alemeda vinha 1009, Centro - Cidade das Flores'),
           ('Julia','S','França',null,65478912374,'rua lareijras 81, Centro - Cidade das Flores'),
           ('Roberta','G','Assis',null,9874563166,'avenidade koller 19, Centro - Cidade das Flores'),
           ('Isabela','M','Cruz',3521477000157,null,'rua alemeda das flores 28, Centro - Cidade das Flores');
select * from clients;     
          
           
-- idProduc, Pname, classification_kids boleans, category('Eletrônico', 'Vestimenta', 'Brinquedos', 'Alimentos', 'móveis'), avaliação, size
           
insert into product(Pname, classification_kids, category, avaliação, size)
     values('Fone de ouvidos',false,'Eletrônico','4',null),
           ('Barbie Elsa',true,'Brinquedos','3',null),
           ('Budy Carters',true,'Vestimenta','5',null),
           ('Microfone Vedo - Youtuber',false,'Eletrônico','4',null),
           ('Sofá Retratil',false,'Móveis','3','3x57x80'),
           ('Farinha de Arroz',false,'Alimentos','2',null),
           ('Fire Stick Amazom',false,'Eletrônico','3',null);
select * from product; 

-- idOrder, idOrderClient, orderStatus, orderDescription, sendValue, paymentCash
insert into orders(idOrderClient, orderStatus, orderDescription, sendValue, paymentCash)
     values(1,'Confirmado','compra via aplicativo',40.52,1), 
           (2,default,'compra via aplicativo',null,0), 
           (3,'Confirmado',null,26.75,1),
           (4,default,'compra via web site',null,0);
	SELECT * FROM clients WHERE idClient IN (1, 2, 3, 4);
select * from orders; 
           
-- idPOproduct, idPOorder, poQuantity, poStatus
select * from productOrder;
insert into productOrder(idPOproduct, idPOorder, poQuantity, poStatus)
     values(1,1,2,null),           
		   (2,2,1,null),
           (3,3,1,null);
select * from productOrder;
     
-- storageLocation
insert into productStorage(storageLocation, quantity)
     values('Rio de Janeiro',1000),
           ('Rio de Janeiro',500),
           ('São Paulo',10),
           ('São Paulo',100),
           ('São Paulo',10),
           ('Brasília',60);
select * from productStorage;           
           
-- idLproduct, idLstorage, location 
insert into StorageLocation(idLproduct, idLstorage, location )
     values(1,2,'Rj'), 
           (2,6,'GO');
select * from StorageLocation;           
     
-- idSupplier, SocialName, CNPJ, contact  
 
insert into supplier(SocialName, CNPJ, contact)
     values('Almeida e filhos',123456789123454,'21985474999'),
           ('Eletrônicos Silva',854519491434579,'21985474997'),     
           ('Eletrônicos Velma',552545474521235,'21985474992');    
select * from supplier;
     
-- idPsSupplier, idPsProduct, quantity A  RESOLVER, ESTA COM ERRO NÃO ACEITA AUTORIZAÇÃO
insert into productSupplier(idPsSupplier, idPsProduct, quantity)
          values(1,1,500),
				(1,2,400),
                (2,4,633),
                (3,3,5),
                (2,5,10);
 select * from productSupplier;  
 
-- idSeller, SocialName, AbstName, CNPJ, CPF, location, contact 
insert into seller(SocialName, AbstName, CNPJ, CPF, location, contact)
     values('Tech eletronics',null, 12345678953217, null,'Rio de Janeiro', 21994627 ),
           ('Botique Durgas',null, 12345678953047, null,'Rio de Janeiro', 21994627 ),
           ('Kids Worl', null, 4578954111243, null, 'São Paulo', 01192254474);
 select * from seller;
  
  -- idPseller, idPproduct, prodQuantity
  insert into productSeller(idPseller, idPproduct, prodQuantity)
       values(1,6,80),
             (2,7,10);
  select * from productSeller;
  
  -- recuperações...
  
select count(*) from clients;  -- quantidade de clientes
select * from clients c, orders o where c.idClient = idOrderClient;  -- recuperando clientes e seus peddos. Com as chaves idOrder/idOrderClient 
select concat(Fname,' ', Lname) as clients, idOrder as Request, orderStatus as status from clients c, orders o where c.idClient = idOrderClient; -- cliente + pedido + status   
     
insert into orders(idOrderClient, orderStatus, orderDescription, sendValue, paymentCash)
     values(2,default,'compra via aplicativo', null,1);
     
select * from orders;

select * from clients;
select * from payments;
desc payments;
insert into payments(idClient,idPayment,typePayment,limitAvailable)
     values(1, 1,'Cartão', 5);
	
select * from payments where typePayment = 'Cartão';
     
select count(*) from clients c, orders o where c.idClient = idOrderClient;     

select c.idClient, Fname, count(*) as Number_of_orders from clients c 
     inner join orders o on c.idClient = idOrderClient
     group by idClient;   
     
select idOrder as orders, count(*) as n°_payments
from orders
where paymentCash = 1 and idOrder in(select idOrder from orders group by idOrder having count(*)=1)
group by idOrder;