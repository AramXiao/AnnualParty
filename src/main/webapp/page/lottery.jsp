<%@ page import="com.service.Lottery" %>
<%@ page import="com.service.Utils" %>
<%@ page contentType="text/html" pageEncoding="utf-8" %>
<!DOCTYPE html>

<html lang="UTF-8">
<head>
    <%
        Lottery lottery = new Lottery();
        lottery.updateLotteryStatus(0);
    %>
    <meta charset="UTF-8">
    <title>Welcome to 2018 ITID China Annual Party</title>
    <script src="../js/jquery3.3.1.js"></script>
    <script type="text/javascript">
        function testTime(){
            var lotteryCount = prize.signList.length;
            var winPrizeCount = currentPrize.prizeCount;
            var loopCount =  winPrizeCount;
            if(lotteryCount<winPrizeCount){
                loopCount = lotteryCount;
            }
            $('#testtime').html('');
            for(var i=0; i<loopCount; i++){
                if(i%10==0){
                    $('#testtime').append("<section>");
                }
                //$('#testtime').append("<span class='num'>"+Math.floor(Math.random()*lotteryCount)+"</span>&nbsp;&nbsp;&nbsp;");
                $('#testtime').append("<span class='num'>"+ prize.signList[Math.floor(Math.random()*(lotteryCount))] +"</span>&nbsp;&nbsp;&nbsp;");
                if(i%10==0){
                    $('#testtime').append("</section>");
                }
            }
        }


        var timer=null;
        function setTime(mark){

            if(mark=='stop'){
                if(timer!=null){
                    goLottery();
                }
            }else{
                if(timer==null){
                    timer = setInterval(testTime,60);
                }
                updateLottery();
            }
            return timer;
        }

        function updateLottery(){
            $.ajax({
                url: "lottery_update.jsp",
                data: {
                    prizeSeq: currentPrize.prizeSeq,
                },
                dataType: "html",
                success: function(result){
                    return;
                }
            });

        }

        function goLottery(){
            $.ajax({
                url: "lottery_submit.jsp",
                data: {
                    prizeKey: currentPrize.prizeName,
                    prizeSeq: currentPrize.prizeSeq,
                    joinNumber: prize.totalJoiner,
                    winPrize: currentPrize.prizeCount,
                },
                dataType: "html",
                success: function(result){
                    //var result = JSON.stringify(result);
                    var resultstr = result.split(",");
                    if(resultstr.length>0){
                        clearInterval(timer);
                        timer=null;
                        $('#testtime').html('');
                        $('#congratulationTips').show();
                        for(var i=0; i<resultstr.length;i++){
                            if(i%10==0){
                                $('#testtime').append("<section>");
                            }
                            $('#testtime').append("<span class='num'>"+resultstr[i]+"</span>&nbsp;&nbsp;&nbsp;");
                            if(i%10==0){
                                $('#testtime').append("</section>");
                            }
                        }
                    }

                }
            });
        }

        function Prize(){
            this.checkPrizeList = <%=lottery.getPrizeListInJson()%>;
            this.prizeList = <%=lottery.getPrizeListInJson()%>;
            this.totalJoiner = 200;
            this.signList =  <%=Utils.listToStr(lottery.getSignNumberList())%>;
        }
        var prize = new Prize();
        var currentPrize = "";
        $(document).ready(function () {
            for(var i=0; i<prize.prizeList.length; i++){
                $('#switchPrizeDD').append("<option value='"+prize.prizeList[i].id+"'>"+prize.prizeList[i].prizeName + " - " + prize.prizeList[i].prizeDesc);
            }
            currentPrize  = prize.prizeList.pop();
            $('#prizeText').html('<h2>'+currentPrize.prizeDesc+'</h2>');
            $('#prizeImg').attr("src",currentPrize.image);

        });


        function switchPrize(prizeId){
            if(prizeId!=null){
                for(var i=0; i<prize.checkPrizeList.length; i++){
                    if(prize.checkPrizeList[i].id==prizeId){
                        currentPrize = prize.checkPrizeList[i];
                        console.log(1);
                        break;
                    }

                }
            }else{
                if(prize.prizeList.length>0){
                    currentPrize = prize.prizeList.pop();
                }else{
                    alert('No more prize');
                }
            }
            $('#prizeText').html('<h2>'+currentPrize.prizeDesc+'</h2>');
            if(currentPrize.image!='' && typeof (currentPrize.image)!='undefined'){
                $('#prizeImg').attr("src",currentPrize.image);
            }else{
                $('#prizeImg').attr("src",'../images/present.jpg');
            }
            $('#testtime').html("");
        }

        function clearTime(timer){ }
    </script>
    <style type="text/css">
        <!--
        body {font-family: Arial;color:rgb(91, 100, 230);margin: 0px;padding: 50px;background:rgb(245, 201, 209);text-align:center;}
        #happyness{font-size:186px;line-height:186px;margin-top:100px;}
        -->
        .num { text-align: left; width: 30px;display: table-cell}
        section {display: table-row}
        .box3 {
            position: absolute;
            width:100px;
            height: 50px;
            top:50%;
            left:10%;
            margin-left:-50px;
            margin-top:-25px;
            text-align: center;
        }
    </style>
</head>
<body>
</body>
<div style="position:absolute; left: 85%;">
    <img src="../images/hsbc.jpg" width="200px" />
</div>
<h1>2018 ITID China Annual Party Luck Draw</h1>
<div style="margin-bottom: 20px;">
    <button onclick="switchPrize();" value="" style="width:100px;height:30px">切换奖品</button>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
    <select id="switchPrizeDD" onchange="switchPrize(this.value)">
        <option value="">Please select</option>
    </select>
    <button onClick="setTime();" value="" style="width:100px;height:30px">开始</button>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;     
    <button onClick="setTime('stop');" value="Stop" style="width:100px;height:30px">停止</button>
</div>
<div style="width: auto; display: -webkit-box">
<div id="prizeShow" style="width: 400px;">
    <div id="prizeText"><h2>二等奖</h2></div>
    <div id="prize">
        <img id="prizeImg" src="../images/timg.jpg" width="400px" />
    </div>
</div>
    <div style="position:relative; width: 840px;">
        <p id="congratulationTips" style="padding-top: 100px; font-weight: bold; font-size: 30px;color:red; display: none;">恭喜以下中奖号码：</p>
        <div id="testtime" class="box3" style="font-size:30px;white-space: nowrap; text-align: left; display: table;padding-left: 50px; color:red;" ></div>
    </div>
</div>
</html>
