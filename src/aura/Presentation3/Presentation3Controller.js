({
    doInit: function(cmp) { 
       setTimeout(() => { 
var num=0;
var imgArray = [];
           for(var i=1;i<=6;++i){
          var imgurl = $A.get('$Resource.Presentation3') + '/pptpreview/'+i+'.png'; 
           
           imgArray.push([imgurl]);   
}
                 
var totalpage=imgArray.length;
document.getElementById('totalpage3').innerHTML=totalpage;
function slideshow(slide_num) {
    document.getElementById('slidepic3').src=imgArray[slide_num][0];
  }

  document.getElementById('slideshowUp3').onclick = slideshowUp;
  document.getElementById('slideshowBack3').onclick = slideshowBack;

  function slideshowUp() {
    num++;
    num = num % imgArray.length;
    slideshow(num);
    document.getElementById('currentpage3').innerHTML=num+1;
    
  }

  function slideshowBack() {
    num--;
    if (num < 0) {num=imgArray.length-1;}
    num = num % imgArray.length;
    document.getElementById('currentpage3').innerHTML=num+1;
    slideshow(num); 
  }
  function slideshowHome() {
    num = 0;
    slideshow(num);
}
}, 1000);
    }
})