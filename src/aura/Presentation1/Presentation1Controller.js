({
    doInit: function(cmp) { 
       setTimeout(() => { 
var num=0;
var imgArray = [];
           for(var i=1;i<=7;++i){
          var imgurl = $A.get('$Resource.Presentation1') + '/pptpreview/'+i+'.png'; 
           
           imgArray.push([imgurl]);   
}
                  
var totalpage=imgArray.length;
document.getElementById('totalpage1').innerHTML=totalpage;
function slideshow(slide_num) {
    document.getElementById('slidepic1').src=imgArray[slide_num][0];
  }

  document.getElementById('slideshowUp1').onclick = slideshowUp;
  document.getElementById('slideshowBack1').onclick = slideshowBack;

  function slideshowUp() {
    num++;
    num = num % imgArray.length;
    slideshow(num);
    document.getElementById('currentpage1').innerHTML=num+1;
    
  }

  function slideshowBack() {
    num--;
    if (num < 0) {num=imgArray.length-1;}
    num = num % imgArray.length;
    document.getElementById('currentpage1').innerHTML=num+1;
    slideshow(num); 
  }
  function slideshowHome() {
    num = 0;
    slideshow(num);
}
}, 1000);
    }
})