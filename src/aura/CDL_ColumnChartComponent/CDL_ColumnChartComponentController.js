({
	scriptsLoaded : function(component, event, helper) {

        var labelset = component.get("v.labelset");
        var dataset = component.get("v.dataset");
        var uniqueName = component.get("v.uniqueName");
        var mentorId = component.get("v.mentorId");
        var mode = component.get("v.mode");
        var chartTitle = component.get("v.chartTitle");
        var xaxeslabel = component.get("v.xaxeslabel");
        var yaxeslabel = component.get("v.yaxeslabel");
        var stepSizeNum = component.get("v.stepSize");
        
        //console.log('stepSizeNum>>>>',stepSizeNum);
        //console.log('stepSizeNum>>>>',Math.max.apply(null, dataset));
        
        if(dataset){
            
            var maxVal = Math.max.apply(null, dataset);
            if(maxVal > 6){
                
                stepSizeNum = Math.floor(maxVal/2);
            }
            
            /*console.log('## labelset : ',labelset);
            console.log('## dataset : ',dataset);
            console.log('## uniqueName : ',uniqueName);
            */
            var isShowPrefTitle = (mode === 'grid') ? false : true;
            
            new Chart(document.getElementById(mentorId + uniqueName + mode + 'Chart'), {
                type: 'bar',
                data: {
                    labels: labelset,
                    datasets: [{
                        label: uniqueName,
                        backgroundColor: "rgb(232, 32, 118)",
                        // backgroundColor: ["#3e95cd", "#8e5ea2","#3cba9f","#e8c3b9","#c45850","#f38b4a","#56d798","#ff8397","#6970d5","#3e95cd","#008000","#0000ff","#ffff00","#ffa500","#000000","#800080","#cccccc","#ff0000"],
                        // hoverBackgroundColor:  ["#3e95cd", "#8e5ea2","#3cba9f","#e8c3b9","#c45850","#f38b4a","#56d798","#ff8397","#6970d5","#3e95cd","#008000","#0000ff","#ffff00","#ffa500","#000000","#800080","#cccccc","#ff0000"],
                        data: dataset,
                        borderWidth: 1
                    }]
                },
                options: {
                    title: {
                        display: isShowPrefTitle,
                        text: chartTitle,
                        position: 'top'
                    },
                    legend: {
                        display: false
                    },
                    tooltips: {
                        callbacks: {
                           label: function(tooltipItem) {
                                  return tooltipItem.yLabel;
                           }
                        }
                    },
                    scales: {
                        yAxes: [{
                            scaleLabel: {
                                display: true,
                                labelString: yaxeslabel
                            },
                            ticks: {
                                beginAtZero:true,
                                display: true,
                                stepSize: stepSizeNum
                            },
                            gridLines: {
                                display: false
                            }/*,
                            afterFit: function(scale) {
                                scale.width = 800 
                            }*/
                        }],
                        xAxes : [{
                            barPercentage: 0.4,
                            scaleLabel: {
                                display: true,
                                labelString: xaxeslabel
                            },
                            ticks: {
                                display: false,
                                minRotation: 0, 
                                maxRotation:90
                            },
                            gridLines: {
                                display: false
                            }
                        }]
                    }
                }
            }); 
        }
    }
})