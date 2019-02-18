<%@ page contentType="text/html" pageEncoding="utf-8" %>
<html>
<head>
    <meta charset="UTF-8">
    <meta name="viewport"
          content="width=device-width, user-scalable=no, initial-scale=1.0, maximum-scale=1.0, minimum-scale=1.0">
    <meta http-equiv="X-UA-Compatible" content="ie=edge">
    <title>Welcome to 2018 ITID China Annual Party</title>
    <%
        String contextPath = request.getContextPath();
    %>
</head>

<script>
    function enableSignUp(partyStartFlag){
        $.ajax({
            url: "enableSignUp_submit.jsp",
            data: {
                signFlag: partyStartFlag,
            },
            dataType: "html",
            success: function(result){
                return ;
            }
        });
        if(partyStartFlag==1){
            $('#disableSignUpBtn').show();
            $('#enableSignUpBtn').hide();
        }else{
            $('#enableSignUpBtn').show();
            $('#disableSignUpBtn').hide();
        }
    }
    function cutDownSignUp(signFlag){
        $.ajax({
            url: "updateSign_submit.jsp",
            data: {
                signFlag: signFlag,
            },
            dataType: "html",
            success: function(result){
                return ;
            }
        });
        if(signFlag==1){
            $('#stopSignBtn').show();
            $('#signBtn').hide();
        }else{
            $('#stopSignBtn').hide();
            $('#signBtn').show();
        }
    }
</script>

<body>
    <h2>Welcome to ITID Annual Party!</h2>
    <p>Click below link to demo the function</p>
    <ul>
        <li><a href="<%=contextPath%>/page/sign.jsp?LotteryNumber=223">Sign in</a></li>
        <li><a href="<%=contextPath%>/page/lottery.jsp">lottery</a></li>
        <li><a href="<%=contextPath%>/page/winPrizeList.jsp">Show win prize list</a></li>
    </ul>
    <div>
        <button id="enableSignUpBtn" onclick="enableSignUp(1);" value="" style="width:100px;height:30px;">开启年会签到</button>
        <button id="disableSignUpBtn" onclick="enableSignUp(0);" value="" style="width:100px;height:30px;display:none;">关闭年会签到</button>
        <button id="signBtn" onclick="cutDownSignUp(1);" value="" style="width:100px;height:30px;display: none;">现场开启签到</button>
        <button id="stopSignBtn" onclick="cutDownSignUp(0);" value="" style="width:100px;height:30px">现场截止签到</button>
    </div>
</body>
</html>