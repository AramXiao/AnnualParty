<%@ page contentType="text/html" pageEncoding="utf-8" %>
<%@ page import="com.service.Lottery" %>
<html>
<head>
    <meta charset="UTF-8">
    <meta name="viewport"
          content="width=device-width, user-scalable=no, initial-scale=1.0, maximum-scale=1.0, minimum-scale=1.0">
    <meta http-equiv="X-UA-Compatible" content="ie=edge">
    <title>Welcome to ITID Annual Party</title>
</head>

<style>
    body{
        max-width: 500px;
        margin: 20px auto ;
    }

</style>
<%

    Integer lotteryNumber = 0;
    String staffId = "";
    if(request.getParameter("LotteryNumber")!=null){
        lotteryNumber = Integer.parseInt(request.getParameter("LotteryNumber"));
    }
    if(request.getParameter("staffId")!=null){
        staffId = request.getParameter("staffId");
    }

    Lottery lottery = new Lottery();
    int result = lottery.sign(lotteryNumber, staffId);
    response.setHeader("refresh", "5;URL=winPrizeList.jsp");
%>



<% if(result==-1){%>
<h2>No lottery number found</h2>
<%}else if(result==0){%>
<h2>Signed fail, please rescan the qrcode to sign again</h2>
<%}else if(result==1){%>
<h2>You have signed before, no need to sign again</h2>
<% }else if(result==2){%>
<h2>Sign successfully!</h2>
<% }%>
<h2>The page will redirect to Prize Page after 5 seconds, if the page hasn't redirected, please click <a href="winPrizeList.jsp?LotteryNumber=<%=lotteryNumber%>">here</a></h2>

</html>