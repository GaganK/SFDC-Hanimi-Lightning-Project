({
    doInit: function(cmp) { 
       setTimeout(() => { 
var num=0;
var imgArray = [];
for(var i=1;i<=47;++i){
          var imgurl = $A.get('$Resource.moringProgramppt') + '/pptpreview/Slide'+i+'-min.PNG';          
           imgArray.push([imgurl]);   
}
                  console.log(imgArray);
var totalpage=imgArray.length;
document.getElementById('totalpage').innerHTML=totalpage;
function slideshow(slide_num) {
   // document.getElementById('slidepic').src='';
    document.getElementById('slidepic').src=imgArray[slide_num][0];
  }

  document.getElementById('slideshowUp').onclick = slideshowUp;
  document.getElementById('slideshowBack').onclick = slideshowBack;

  function slideshowUp() {
    num++;
    num = num % imgArray.length;
    slideshow(num);
    document.getElementById('currentpage').innerHTML=num+1;
    
  }

  function slideshowBack() {
    num--;
    if (num < 0) {num=imgArray.length-1;}
    num = num % imgArray.length;
    document.getElementById('currentpage').innerHTML=num+1;
    slideshow(num); 
  }
  function slideshowHome() {
    num = 0;
    slideshow(num);
}
}, 1000);
    }
})