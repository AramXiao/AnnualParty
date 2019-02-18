<%@ page import="com.service.*" %>


<%

    String partyStartFlag = "";

    if(request.getParameter("partyStartFlag")!=null){
        partyStartFlag = request.getParameter("partyStartFlag");
    }

    Lottery lottery = new Lottery();
    lottery.updateParam("party_start_flag",partyStartFlag);
    response.getWriter().print("{success:1}");
%>