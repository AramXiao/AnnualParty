<%@ page import="com.service.*" %>


<%

    String signFlag = "";

    if(request.getParameter("signFlag")!=null){
        signFlag = request.getParameter("signFlag");
    }

    Lottery lottery = new Lottery();
    lottery.updateParam("sign_flag",signFlag);
    response.getWriter().print("{success:1}");
%>