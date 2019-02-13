<%@ page import="com.service.*" %>
<%@ page import="java.util.Map" %>
<%@ page import="java.util.HashMap" %>


<%

    Integer prizeSeq = 0;

    if(request.getParameter("prizeSeq")!=null){
        prizeSeq = Integer.parseInt(request.getParameter("prizeSeq"));
    }

    System.out.println("prizeSeq-->"+prizeSeq);
    Lottery lottery = new Lottery();
    lottery.updateLotteryStatus(prizeSeq);
    Map<String, String> dataMap = new HashMap<String,String>();
    dataMap.put("success","1");
    response.getWriter().print(Utils.mapToJson(dataMap));
%>