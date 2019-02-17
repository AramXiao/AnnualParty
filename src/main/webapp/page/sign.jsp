<%@ page contentType="text/html" pageEncoding="utf-8" %>
<%@ page import="com.service.Lottery" %>
<html>
<head>
    <meta charset="UTF-8">
    <meta name="viewport"
          content="width=device-width, user-scalable=no, initial-scale=1.0, maximum-scale=1.0, minimum-scale=1.0">
    <meta http-equiv="X-UA-Compatible" content="ie=edge">
    <title>Welcome to ITID Annual Party</title>
    <script>
        function confirmMsg(){
            var inputId = document.getElementById('staffId').value;
            if(confirm('Do you confirm to sign with ' + inputId+"?")){
                document.forms["signForm"].submit();
            }

        }

    </script>
</head>

<style>
    body{
        max-width: 500px;
        margin: 20px auto ;
    }

</style>



<%
    Lottery lottery = new Lottery();
    Integer lotteryNumber = 0;



    if(request.getParameter("LotteryNumber")!=null){
        lotteryNumber = Integer.parseInt(request.getParameter("LotteryNumber"));
    }

    if(lottery.hasSign(lotteryNumber)){
        response.sendRedirect("winPrizeList.jsp?LotteryNumber="+lotteryNumber);
    }


%>
<body>
    <h2>Welcome to ITID Annual party</h2>
    <form action="sign_submit.jsp" method="post" name="signForm">
        <input type="hidden" id="LotteryNumber" name="LotteryNumber" value="<%=lotteryNumber%>"  />
        Please input last 5 number of your staff id to sign in: <input id="staffId" name="staffId" value="" length="5" />
        <input type="button" name="submitForm" value="Submit" onclick="confirmMsg();"/>
    </form>

</body>
</html>