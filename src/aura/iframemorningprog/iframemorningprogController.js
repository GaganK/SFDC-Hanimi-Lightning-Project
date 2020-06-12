({
	doInit: function(component, event, helper) {
       window.addEventListener("onload", function (e) {
            var frame = document.getElementById("frame1");
           var msg = frame.contentDocument.getElementsByClassName("container");
           msg.innerHTML = "Hello World from Frame Page 1";
           component.set("v.msg",true);
        });
      
	}
})