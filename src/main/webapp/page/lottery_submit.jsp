<%@ page import="com.service.*" %>
<%@ page import="java.util.List" %>


<%
    String prizeKey = request.getParameter("prizeKey");
    Integer joinNumber = 0;
    Integer winPrize = 0;
    Integer prizeSeq = 0;
//    Map<Integer, List<Integer>> winMembersMap = null;

    if(request.getParameter("joinNumber")!=null){
        joinNumber = Integer.parseInt(request.getParameter("joinNumber"));
    }
    if(request.getParameter("winPrize")!=null){
        winPrize = Integer.parseInt(request.getParameter("winPrize"));
    }
    if(request.getParameter("prizeSeq")!=null){
        prizeSeq = Integer.parseInt(request.getParameter("prizeSeq"));
    }
    /*if(session.getAttribute("winMembersMap")!=null){
         winMembersMap = (Map<Integer, List<Integer>>)session.getAttribute("winMembersMap");
    }else{
        winMembersMap = new TreeMap<Integer, List<Integer>>();

    }*/

    //System.out.println("privateKey-->"+prizeKey);
    Lottery lottery = new Lottery();
    List<Integer> resultList = lottery.luckyDraw(prizeSeq, winPrize);
    StringBuffer result = new StringBuffer();
    if(resultList.size()>0){
        for(int i=0; i<resultList.size(); i++){
            result.append(resultList.get(i)).append(",");
        }
        result.deleteCharAt(result.lastIndexOf(","));
    }
    //store in session
//    winMembersMap.put(prizeSeq, resultList);
//    session.setAttribute("winMembersMap",winMembersMap);

    System.out.println(result);
    response.getWriter().print(result);
%>