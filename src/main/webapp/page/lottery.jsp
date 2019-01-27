<%@ page import="com.service.Lottery" %>
<%@ page import="com.service.Utils" %>
<%@ page contentType="text/html" pageEncoding="utf-8" %>
<!DOCTYPE html>

<html lang="UTF-8">
<head>
    <%
        Lottery lottery = new Lottery();
    %>
    <meta charset="UTF-8">
    <title>幸运抽奖</title>
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
            console.log('loopCount-->'+loopCount);
            for(var i=0; i<loopCount; i++){
                if(i%10==0){
                    $('#testtime').append("<section>");
                }
                //$('#testtime').append("<span class='num'>"+Math.floor(Math.random()*lotteryCount)+"</span>&nbsp;&nbsp;&nbsp;");
                $('#testtime').append("<span class='num'>"+ prize.signList[Math.floor(Math.random()*(lotteryCount))] +"</span>&nbsp;&nbsp;&nbsp;");
                console.log("index-->"+ Math.floor(Math.random()*(lotteryCount+1)));
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
                clearInterval(timer);
                timer = null;
            }else{
                if(timer==null){
                    timer = setInterval(testTime,60);
                }
            }
            return timer;
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
                        $('#testtime').html('');
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
            this.prizeList = [
                {
                    prizeSeq: 1,
                    prizeName: '一等奖',
                    image: '../images/iphonex.jpg',
                    prizeCount: 1,

                },
                {
                    prizeSeq: 2,
                    prizeName: '二等奖',
                    image: '../images/timg.jpg',
                    prizeCount: 2,

                },
                {
                    prizeSeq: 3,
                    prizeName: '三等奖',
                    image: '../images/jbl.jpg',
                    prizeCount: 10,

                },
                {
                    prizeSeq: 4,
                    prizeName: '四等奖',
                    image: '../images/marketCard.jpg',
                    prizeCount: 20,

                },
            ];
            this.totalJoiner = 200;
            this.signList =  <%=Utils.listToStr(lottery.getSignNumberList())%>;
        }
        var prize = new Prize();
        var currentPrize = "";
        $(document).ready(function () {
            <%
            boolean showWinListFlag = lottery.getLotterStaus();
            if(showWinListFlag) {
                response.sendRedirect("winPrizeList.jsp");
            }

            %>
            currentPrize  = prize.prizeList.pop();
            $('#prizeText').html('<h2>'+currentPrize.prizeName+'</h2>');
            $('#prizeImg').attr("src",currentPrize.image);
        });



        function switchPrize(){
            if(prize.prizeList.length>0){
                currentPrize = prize.prizeList.pop();
            }else{
                alert('No prize in the pull');
            }
            $('#prizeText').html('<h2>'+currentPrize.prizeName+'</h2>');
            $('#prizeImg').attr("src",currentPrize.image);
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
<h1>汇丰ITID2018年会抽奖</h1>
<div style="margin-bottom: 20px;">
    <button onclick="switchPrize();" value="" style="width:100px;height:30px">切换奖品</button>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
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
        <p style="padding-top: 100px;"><b>恭喜以下中奖号码：</b></p>
        <div id="testtime" class="box3" style="font-size:30px;white-space: nowrap; text-align: left; display: table;padding-left: 50px;" ></div>
    </div>
</div>
</html>
