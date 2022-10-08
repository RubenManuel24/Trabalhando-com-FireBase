import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutterlast/home_imagem.dart';
void main() async {
  
WidgetsFlutterBinding.ensureInitialized();
await Firebase.initializeApp();

WidgetsFlutterBinding.ensureInitialized();
await Firebase.initializeApp();

FirebaseFirestore db = FirebaseFirestore.instance;

var pesquisa = "G"; //pertence ao código Pesquisa de Texto

//Salvando os dados com identificador

db.collection("usuarios")
.doc("002")
.set({
       "nome":"Anabela Mbanino",
       "idade":"20"
  });


//Salvando os dados com os identificdor automático
  
  db.collection("noticias")
  .add({
    "descricao": "Sobre o RUben",
    "titulo": "Ruben é um menino muito lindo e sábio!!!"
  });

//Recuperar o identificador automatico
  
  DocumentReference ref = await db.collection("noticias")
  .add({
    "descricao": "Sobre o RUben",
    "titulo": "Ruben é um menino muito lindo e sábio!!!"
  });

  print("Identificdor automático:" +ref.id.toString());

//atualizar os dados com identificador automático

  db.collection("noticias")
  .doc("ciJ9897baiF1vgASpDGn")
  .set({
    "descricao": "Sobre a Vany",
    "titulo": "Vany é uma menina muito linda e sábia!!!"
  });


//Removendo item no BD do Firebase

  db.collection("usuarios").doc("003").delete();
  

//Recuperar dados no BD, somente um item.
  
  DocumentSnapshot snapshot = await db.collection("usuarios")
  .doc("002 ")
  .get();

  var dados = snapshot;
  print("nome: "+dados["nome"] +" - "+ "idade: "+dados["idade"]);

 
//Recuperar dados no BD em forma de lista

 QuerySnapshot querySnapshot = await db
 .collection("usuarios")
 .get();

 print("Dados usuarios: "+querySnapshot.docs.toString());

 
 for(var item in querySnapshot.docs){
  var dados = item;
   print("dados usuarios: "+dados["nome"] +" - "+ dados["idade"].toString());
 }


//Recuperar dados no BD em forma de lista com requisicoes

 db.collection("animal").snapshots().listen(
    (snapshot){
      
      for(var dados in snapshot.docs){
         print("Nome: "+dados["Nome"] + "\nSexo: "+dados["Sexo"] + "\nIdade: " + dados["Idade"].toString());
         print("--------------------");
      }
    }
  );
 
//Aplicando filtros básicos

QuerySnapshot querysnapshot = await db.collection("usuarios")
//.where("Nome", isEqualTo: "Marlene Agusto")
//.where("Idade", isEqualTo: 34)
//.where("Idade", isEqualTo: "34")
.where("Idade", isGreaterThan: 10)//< menor, > maior, >= maior ou igual, <= menor ou igual
//.where("Idade", isLessThan: 50)
.orderBy("Idade" , descending: true)
//.orderBy("Nome", descending: false)
.limit(2)
.get();

 for(var item in querysnapshot.docs){ 
    var dados = item;
    print("____________________");
    print("Nome: "+dados["Nome"] +"\nIdade: "+dados["Idade"].toString());
    print("____________________");
 }

QuerySnapshot querysnapshot2 = await db.collection("usuarios")
//.where("Nome", isEqualTo: "Ana Maria")
//.where("Idade", isEqualTo: 12)
//.where("Idade", isNotEqualTo: 90)
//.where("Idade", isLessThan: 40)
.where("Idade", isGreaterThan: 10)
.orderBy("Idade", descending: true) 
.limit(4)
.get();

for(var item in querysnapshot.docs){
  var dados = item;
  print("__________________");
  print("Nome: "+dados["Nome"] + "\nIdade: "+dados["Idade"].toString());
  print("__________________");
}

//Pesquisa de texto


QuerySnapshot querySnapshot2 = await db.collection("usuarios")
.where("Nome", isGreaterThanOrEqualTo: pesquisa )
.where("Nome", isLessThanOrEqualTo: pesquisa + "\uf8ff" )
.get();

//Note podemos criar uma variavel que será as inicias da pesquisa e add nas condicoes.

for(var item in querySnapshot.docs){
    var dados = item;
    print("____________________");
    print("Nome: "+dados["Nome"] +"\nIdade: "+dados["Idade"].toString());
    print("____________________");
 }

//Cadastro  e verificacao de usuario logado

//Fazendo autenticacao do usuario
FirebaseAuth auth = FirebaseAuth.instance;

 //Criando usuario com e-mail e senha
String  email = "any@gmail.com"; 
String senha = "192837465";

auth.createUserWithEmailAndPassword(
   email: email, 
   password: senha  ).then((firebaseUser){
    print("Novo usuario: sucesso!! e-mail: "+email.toString());
   }).catchError((erro){
    print("Novo usuario: erro!! e-mail: "+erro.toString());
   });

// Verificar se o usuario já existe.
  
  var usuarioAtual = await auth.currentUser;
    if(usuarioAtual != null){
      print("Usuario atual logado email: "+usuarioAtual.email.toString());
    }
    else{
     print("Usuario atual não logado!! ");
    }

//Logar e delogar usuario

//String  email = "any@gmail.com"; 
//String senha = "192837465";
//192837465

FirebaseAuth auth2 = await FirebaseAuth.instance;
auth.signOut(); //serve para deslogar usuário

//Logando usuário
auth.signInWithEmailAndPassword(
   email: email, 
   password: senha)
   .then((firebaseUser){
     print("Logar ususario: sucesso!!! \nEmail: "+email.toString());
   })
   .catchError((erro){
    print("Logar usuario: erro!!! \nTipo de Erro: "+erro.toString());
   });

  runApp(MaterialApp(
    home: HomeImagem()
  ));
}

