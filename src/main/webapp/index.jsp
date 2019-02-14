<%@ page contentType="text/html" pageEncoding="utf-8" %>
<html>
<head>
    <meta charset="UTF-8">
    <meta name="viewport"
          content="width=device-width, user-scalable=no, initial-scale=1.0, maximum-scale=1.0, minimum-scale=1.0">
    <meta http-equiv="X-UA-Compatible" content="ie=edge">
    <title>Welcome to ITID Annual Party!</title>
    <%
        String contextPath = request.getContextPath();
    %>
</head>
<body>
    <h2>Welcome to ITID Annual Party!</h2>
    <p>Click below link to demo the function</p>
    <ul>
        <li><a href="<%=contextPath%>/page/sign.jsp?LotteryNumber=223">Sign in</a></li>
        <li><a href="<%=contextPath%>/page/lottery.jsp">lottery</a></li>
        <li><a href="<%=contextPath%>/page/winPrizeList.jsp">Show win prize list</a></li>
    </ul>

</body>
</html>