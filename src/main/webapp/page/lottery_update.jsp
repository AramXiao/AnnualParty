<%@ page import="com.service.*" %>


<%

    Integer prizeSeq = 0;

    if(request.getParameter("prizeSeq")!=null){
        prizeSeq = Integer.parseInt(request.getParameter("prizeSeq"));
    }

    System.out.println("prizeSeq-->"+prizeSeq);
    Lottery lottery = new Lottery();
    lottery.updateLotteryStatus(prizeSeq);
    response.getWriter().print("{success:1}");
%>