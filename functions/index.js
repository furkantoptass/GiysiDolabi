const functions = require('firebase-functions');
const admin = require('firebase-admin');
admin.initializeApp();
//TAKIP EDİLDİKTEN SONRA AKIŞA GÖNDERİLERİN AKTARILMASI
exports.takipGerceklesti = functions.firestore.document('takipciler/{takipEdilenId}/kullanicininTakipcileri/{takipEdenKullaniciId}').onCreate(async (snapshot, context) => {
    const takipEdilenId = context.params.takipEdilenId;
    const takipEdenId = context.params.takipEdenKullaniciId;

   const gonderilerSnapshot = await admin.firestore().collection("gonderiler").doc(takipEdilenId).collection("kullanicigonderileri").get();
   const kombinlerSnapshot = await admin.firestore().collection("kombinler").doc(takipEdilenId).collection("kullaniciKombinleri").get();

   gonderilerSnapshot.forEach((doc)=>{
        if(doc.exists){
           // console.log("test");
            const gonderiId = doc.id;
            const gonderiData = doc.data();

            admin.firestore().collection("akislar").doc(takipEdenId).collection("kullaniciAkisGonderileri").doc(gonderiId).set(gonderiData);
        }
   });
   kombinlerSnapshot.forEach((doc)=>{
    if(doc.exists){
       // console.log("test");
        const kombinId = doc.id;
        const kombinData = doc.data();

        admin.firestore().collection("kombinakislari").doc(takipEdenId).collection("kullaniciAkisKombinleri").doc(kombinId).set(kombinData);
    }
});
});


exports.takipdenCikildi = functions.firestore.document('takipciler/{takipEdilenId}/kullanicininTakipcileri/{takipEdenKullaniciId}').onDelete(async (snapshot, context) => {
    const takipEdilenId = context.params.takipEdilenId;
    const takipEdenId = context.params.takipEdenKullaniciId;

   const gonderilerSnapshot = await admin.firestore().collection("akislar").doc(takipEdenId).collection("kullaniciAkisGonderileri").where("yayinlayanId","==",takipEdilenId).get();
   const kombinlerSnapshot = await admin.firestore().collection("kombinakislari").doc(takipEdenId).collection("kullaniciAkisKombinleri").where("yayinlayanId","==",takipEdilenId).get();
   gonderilerSnapshot.forEach((doc)=>{
        if(doc.exists){
        doc.ref.delete();
          
        }
   });
   kombinlerSnapshot.forEach((doc)=>{
    if(doc.exists){
    doc.ref.delete();
      
    }
});
});

exports.yeniGonderiEklendi =functions.firestore.document('gonderiler/{takipEdilenKullaniciId}/kullanicigonderileri/{gonderiId}').onCreate(async(snapshot,context)=>{
    const takipEdilenId = context.params.takipEdilenKullaniciId;
    const gonderiId= context.params.gonderiId;
    const yeniGonderiData=snapshot.data();

  const takipcilerSnapShot = await admin.firestore().collection("takipciler").doc(takipEdilenId).collection("kullanicininTakipcileri").get();

  takipcilerSnapShot.forEach(doc=>{
    const takipciId=doc.id;
    admin.firestore().collection("akislar").doc(takipciId).collection("kullaniciAkisGonderileri").doc(gonderiId).set(yeniGonderiData);
  });
});

exports.yeniKombinEklendi =functions.firestore.document('kombinler/{takipEdilenKullaniciId}/kullaniciKombinleri/{gonderiId}').onCreate(async(snapshot,context)=>{
    const takipEdilenId = context.params.takipEdilenKullaniciId;
    const kombinId= context.params.gonderiId;
    const yeniKombinData=snapshot.data();

  const takipcilerSnapShot = await admin.firestore().collection("takipciler").doc(takipEdilenId).collection("kullanicininTakipcileri").get();
  
  takipcilerSnapShot.forEach(doc=>{
    const takipciId=doc.id;
    admin.firestore().collection("kombinakislari").doc(takipciId).collection("kullaniciAkisKombinleri").doc(kombinId).set(yeniKombinData);
  });
});

exports.gonderiGuncellendi =functions.firestore.document('gonderiler/{takipEdilenKullaniciId}/kullanicigonderileri/{gonderiId}').onUpdate(async(snapshot,context)=>{
    const takipEdilenId = context.params.takipEdilenKullaniciId;
    const gonderiId= context.params.gonderiId;
    const guncellenenGonderiData=snapshot.after.data();

  const takipcilerSnapShot = await admin.firestore().collection("takipciler").doc(takipEdilenId).collection("kullanicininTakipcileri").get();
  takipcilerSnapShot.forEach(doc=>{
    const takipciId=doc.id;
    admin.firestore().collection("akislar").doc(takipciId).collection("kullaniciAkisGonderileri").doc(gonderiId).update(guncellenenGonderiData);
  });
});

exports.gonderiSilindi =functions.firestore.document('gonderiler/{takipEdilenKullaniciId}/kullanicigonderileri/{gonderiId}').onDelete(async(snapshot,context)=>{
    const takipEdilenId = context.params.takipEdilenKullaniciId;
    const gonderiId= context.params.gonderiId;

  const takipcilerSnapShot = await admin.firestore().collection("takipciler").doc(takipEdilenId).collection("kullanicininTakipcileri").get();
  takipcilerSnapShot.forEach(doc=>{
    const takipciId=doc.id;
    admin.firestore().collection("akislar").doc(takipciId).collection("kullaniciAkisGonderileri").doc(gonderiId).delete();
  });
});


