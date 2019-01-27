<!doctype html>
<%@ page import="java.sql.*" %>
<%@ page import="java.util.Map" %>
<%@ page import="java.util.List" %>
<%@ page import="java.util.ArrayList" %>
<%@ page import="java.util.HashMap" %>
<%@ page import="com.service.Utils" %>
<%@ page contentType="text/html" pageEncoding="utf-8" %>
        <html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport"
          content="width=device-width, user-scalable=no, initial-scale=1.0, maximum-scale=1.0, minimum-scale=1.0">
    <meta http-equiv="X-UA-Compatible" content="ie=edge">
    <title>ITID Annual Party Prize List</title>
</head>

<style>
    ul {
        list-style-type: none;
    }

</style>

<%
    String sql = "";

    String JDBC_DRIVER = "com.mysql.jdbc.Driver";
    String DB_URL = "jdbc:mysql://localhost:3306/mysql?serverTimezone=GMT%2B8&useUnicode=true&characterEncoding=utf8&useSSL=false";

    String USER = "root";
    String PASS = "it@2019";
    List<Map<String, Object>> resultList = null;

    Connection conn = null;
    Statement stmt = null;
    PreparedStatement ps = null;
    ResultSet rs = null;
    try {
        Class.forName(JDBC_DRIVER);
        conn = DriverManager.getConnection(DB_URL, USER, PASS);
        sql = "select id,seq,prize_count,prize_name,prize_image from itid_prize order by seq asc";
        stmt = conn.prepareStatement(sql);

        rs = stmt.executeQuery(sql);
        resultList = new ArrayList<Map<String,Object>>();
        while(rs.next()){
            Map<String,Object> dataMap = new HashMap<String,Object>( );
            dataMap.put("id", rs.getInt("id"));
            dataMap.put("seq", rs.getInt("seq"));
            dataMap.put("prize_count", rs.getInt("prize_count"));
            dataMap.put("prize_name", rs.getString("prize_name"));
            dataMap.put("prize_image", rs.getString("prize_image"));
            resultList.add(dataMap);
        }

        System.out.println("resultList-->"+resultList.size());


    }catch(Exception e){
        e.printStackTrace();

    }finally {
        try{
            if (stmt!=null){
                stmt.close();
            }
            if(rs!=null){
                rs.close();
            }
        }catch (Exception ex){
            ex.printStackTrace();
        }
    }
%>

<body>
    <%
        try {
            for(int i=0; i<resultList.size(); i++){
                Map<String, Object> recordMap = resultList.get(i);
        %>
        <ul>
            <li>奖品: <%=recordMap.get("prize_name")%></li>
            <li>奖品数量: <%=recordMap.get("prize_count")%></li>
            <li><img src="<%=recordMap.get("prize_image")%>" width="400px"></li>
            <li>
                <table width="500px" border="1px">
                    <thead>
                        <th>中奖号码</th>
                        <th>员工编号</th>
                        <th>部门</th>
                        <th>团队</th>
                    </thead>
                    <%
                        sql = "SELECT t1.lottery_number,t1.win_prize_id,t1.win_date,t2.staff_id,t2.dept,t2.team,t2.sign_date from itid_win_prize t1 left join itid_sign t2 on t1.lottery_number=t2.lottery_number where win_prize_id=?";
                        ps = conn.prepareStatement(sql);
                        ps.setObject(1,recordMap.get("id"));
                        rs = ps.executeQuery();
                        while(rs.next()){
                    %>
                    <tr>
                        <td><%=Utils.toHtml(rs.getInt("lottery_number"))%></td>
                        <td><%=Utils.toHtml(rs.getString("staff_id"))%></td>
                        <td><%=Utils.toHtml(rs.getString("dept"))%></td>
                        <td><%=Utils.toHtml(rs.getString("team"))%></td>
                    </tr>
                    <%
                        }
                    %>
                </table>

            </li>
        </ul>
        <%
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
    %>

</body>
</html>