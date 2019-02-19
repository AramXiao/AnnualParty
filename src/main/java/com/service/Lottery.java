package com.service;


import java.sql.*;
import java.util.*;
import java.util.Date;

public class Lottery {
    public static Map<String,Integer> prizeMap = new TreeMap<String, Integer>();
    static {
        prizeMap.put("1",1);
        prizeMap.put("2",2);
        prizeMap.put("3",10);
        prizeMap.put("4",50);

    }
    List<Integer> numList;

    public Map<String, Integer> getPrizeMap(){
        return this.prizeMap;
    }

    Connection conn = null;

    /**
     * This method use to check if the win number is in the win list
     * @param list win list
     * @param num win number
     * @return
     */
    public boolean inNumList(List<Integer> list, Integer num){
        if(list!=null && list.size()>0 && num!=null) {
            for (Integer value : list) {
                if (value.intValue() == num) {
                    return true;
                }
            }
        }
        return false;
    }

    public Connection getConnection(){
        String JDBC_DRIVER = "com.mysql.jdbc.Driver";
        String DB_URL = "jdbc:mysql://120.79.76.223:3306/mysql?serverTimezone=GMT%2B8&useUnicode=true&characterEncoding=utf8&useSSL=false";

        String USER = "root";
        String PASS = "it@2019";
        //String PASS = "root";

        try {
            if(conn==null) {
                synchronized (Lottery.class) {
                    if (conn == null) {
                        Class.forName(JDBC_DRIVER);
                        conn = DriverManager.getConnection(DB_URL, USER, PASS);
                    }
                }
            }
        } catch (ClassNotFoundException e) {
            e.printStackTrace();
        } catch (SQLException ex) {
            ex.printStackTrace();
        }
            return this.conn;
    }

    public String getPrizeNameBySeq(int prizeSeq, List<Map<String,Object>> prizeList){
        if(prizeList!=null){
            for(Map<String,Object> dataMap : prizeList){
                if(dataMap.get("seq").equals(prizeSeq)){
                    return String.valueOf(dataMap.get("prize_name"));
                }
            }
        }
        return "";
    }

    public String hasWinPrize(Integer lotteryNumber){
        String winPrizeName = "";
        Connection conn = this.getConnection();
        ResultSet rs = null;
        PreparedStatement ps = null;

        String sql = "select t1.lottery_number,t2.prize_name from itid_win_prize t1 left join itid_prize t2 on t1.win_prize_id=t2.id where lottery_number=?";
        try {
            ps = conn.prepareStatement(sql);
            ps.setInt(1, lotteryNumber);
            rs = ps.executeQuery();
            if (rs.next()){
                winPrizeName = rs.getString("prize_name");
            }
        } catch (SQLException e) {
            e.printStackTrace();
        } finally {
            try {
                if(rs!=null){
                    rs.close();
                }
            } catch (SQLException e) {
                e.printStackTrace();
            }

        }


        return winPrizeName;
    }



    public int getParams(String paramName){
        String sql = "select value from itid_params where param=?";
        int value = 0;
        Connection conn = this.getConnection();
        ResultSet rs = null;
        try {
            PreparedStatement ps = conn.prepareStatement(sql);
            ps.setString(1,paramName);
            rs = ps.executeQuery();
            while (rs.next()){
                value = rs.getInt("value");
            }
        } catch (SQLException e) {
            e.printStackTrace();
        } finally {
            try {
                if(rs!=null){
                    rs.close();
                }
            } catch (SQLException e) {
                e.printStackTrace();
            }

        }

        return value;
    }

    public void updateParam(String paramName, String value){
        String sql = "update itid_params set value=? where param=?";
        Connection conn = this.getConnection();
        ResultSet rs = null;
        PreparedStatement ps = null;
        try {
            ps = conn.prepareStatement(sql);
            ps.setString(1, value);
            ps.setString(2, paramName);
            ps.executeUpdate();

        } catch (SQLException e) {
            e.printStackTrace();
        } finally {
           rsClose(ps,rs,conn);
        }
    }


    public void updateLotteryStatus(int prizeSeq){
        String sql = "update itid_params set value=? where param=?";

        Connection conn = this.getConnection();
        ResultSet rs = null;
        try {
            PreparedStatement ps = conn.prepareStatement(sql);
            ps.setInt(1, prizeSeq);
            ps.setString(2, "lottery_status");
            ps.executeUpdate();


            if(prizeSeq>0){
                ps = conn.prepareStatement(sql);
                ps.setInt(1, prizeSeq);
                ps.setString(2, "last_lottery_prize");
                ps.executeUpdate();
            }

        } catch (SQLException e) {
            e.printStackTrace();
        } finally {
            try {
                if(rs!=null){
                    rs.close();
                }
            } catch (SQLException e) {
                e.printStackTrace();
            }

        }
    }


    public void saveWinResult(Integer prizeId, List<Integer> winList){
        if(prizeId==null || winList==null){
            return;
        }
        PreparedStatement ps = null;
        Connection conn = this.getConnection();
        try {
            String sql = "DELETE FROM itid_win_prize WHERE win_prize_id=?";


            ps = conn.prepareStatement(sql);
            ps.setInt(1, prizeId);

            ps.executeUpdate();
            ps.close();

            for (int i=0; i<winList.size(); i++){
                Integer winNumber = winList.get(i);
                sql = "INSERT INTO itid_win_prize(lottery_number,win_prize_id,win_date) values(?,?,?)";
                ps = null;
                ps = conn.prepareStatement(sql);
                ps.setInt(1,winNumber);
                ps.setInt(2, prizeId);
                ps.setTimestamp(3, new Timestamp(new Date().getTime()));

                ps.executeUpdate();
                ps.close();
            }

        } catch (SQLException e) {
            e.printStackTrace();
        }finally {
            rsClose(ps,null,conn);
        }


    }

    public Integer getPrizeIdbySeq(Integer seq){
        Connection conn = getConnection();
        Statement stmt = null;
        ResultSet rs = null;
        int id = 0;
        try {
            stmt = conn.createStatement();
            String sql = "select id from itid_prize where seq="+seq;
            rs = stmt.executeQuery(sql);
            if (rs.next()){
                id = rs.getInt(1);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }finally {
            rsClose(stmt, rs, conn);
        }

        return id;
    }

    private Map<String, String> getResultMap(ResultSet rs)
            throws SQLException {
        Map<String, String> hm = new HashMap<String, String>();
        ResultSetMetaData rsmd = rs.getMetaData();
        int count = rsmd.getColumnCount();
        for (int i = 1; i <= count; i++) {
            String key = rsmd.getColumnLabel(i);
            String value = rs.getString(i);
            hm.put(key, value);
        }
        return hm;
    }

    public Boolean hasSign(Integer lotteryNumber){
        Connection conn = getConnection();
        PreparedStatement ps = null;
        ResultSet rs = null;
        String sql = "";
        int count = 0;

        try {
            sql = "select count(*) from itid_sign where lottery_number=?";
            ps = conn.prepareStatement(sql);
            ps.setInt(1,lotteryNumber);
            rs = ps.executeQuery();
            if(rs.next()){
                count = rs.getInt(1);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        } finally {
            rsClose(ps, rs, conn);
        }

        return count>0;
    }


    /**
     *
     * @param lotteryNumber
     * @return -1: no lottery number 0: update fail, 1: signed before, 2: update successfully,3: ID already sign by other people
     */
    public int sign(Integer lotteryNumber, String staffId){
        Connection conn = getConnection();
        PreparedStatement ps = null;
        ResultSet rs = null;
        int result = 0;
        String sql = "";
        Map<String, String> dataMap = new HashMap<String, String>();
        int sign_flag = 0;

        if(lotteryNumber<=0){
            return -1;
        }
        try {

            sql = "select * from itid_sign where lottery_number=? order by sign_date desc";
            ps = conn.prepareStatement(sql);
            ps.setInt(1,lotteryNumber);
            rs = ps.executeQuery();
            if(rs.next()){
                return 1;
            }

            sql = "select * from itid_sign where staff_id=? order by sign_date desc";
            ps = conn.prepareStatement(sql);
            ps.setString(1,staffId);
            rs = ps.executeQuery();
            if(rs.next()){
                return 3;
            }

            sql = "select value from itid_params where param=?";
            ps = conn.prepareStatement(sql);
            ps.setString(1, "sign_flag");
            rs = ps.executeQuery();
            if(rs.next()) {
                sign_flag = rs.getInt(1);
            }



            sql = "insert  into itid_sign(lottery_number,staff_id,dept,team,sign_date,enable_lottery)values(?,?,?,?,?,?);";
            ps = conn.prepareStatement(sql);
            ps.setInt(1,lotteryNumber);
            if(staffId!=null){
                ps.setString(2, staffId.trim());
            }else{
                ps.setNull(2,Types.NULL);
            }
            ps.setNull(3,Types.NULL);
            ps.setNull(4,Types.NULL);
            ps.setTimestamp(5,new Timestamp(new Date().getTime()));
            ps.setInt(6,sign_flag==1?1:0);
            ps.executeUpdate();
            result = 2;


        } catch (SQLException e) {
            e.printStackTrace();
        }finally {
            rsClose(ps, rs, conn);
        }

        return result;
    }

    public List<Integer> strToIntArrays(String input, String split){
        List<Integer> resultList = null;
        if(input==null || split==null){
            return null;
        }
        String[] splitArr = input.split(split);
        Integer[] numArr = new Integer[splitArr.length];
        for(int i=0; i<splitArr.length;i++){
            numArr[i] = Integer.parseInt(splitArr[i]);
        }
        resultList = Arrays.asList(numArr);


        return resultList;
    }

    /**
     * Key: win prize id
     * Value win lottery number list
     * @return
     */

    public Map<Integer, List<Integer>> getWinMemberMap(){
        Connection conn = getConnection();
        Statement stmt = null;
        ResultSet rs = null;
        int id = 0;
        String lotteryNumbers = "";
        Map<Integer, List<Integer>> allWinMemberMap = new TreeMap<Integer, List<Integer>>();


        try {
            stmt = conn.createStatement();
            String sql = "select group_concat(lottery_number) as c1, win_prize_id as c2 from itid_win_prize group by  win_prize_id";
            rs = stmt.executeQuery(sql);
            while (rs.next()){
                id = rs.getInt("c2");
                lotteryNumbers = rs.getString("c1");
                allWinMemberMap.put(id, this.strToIntArrays(lotteryNumbers, ","));
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }finally {
            rsClose(stmt, rs, conn);
        }

        return allWinMemberMap;
    }

    public String getPrizeListInJson(){
        String jsonData = "";
        Connection conn = getConnection();
        Statement stmt = null;
        ResultSet rs = null;
        List<Map<String, String>> resultList = new ArrayList<Map<String,String>>();
        Map<String, String> mapData = null;
        String sql = "select id,seq,prize_count,prize_name,prize_image,prize_desc from itid_prize order by seq";
        try {
            stmt = conn.createStatement();
            rs = stmt.executeQuery(sql);
            while(rs.next()){
                mapData = new HashMap<String,String>();
                mapData.put("id",rs.getString("id"));
                mapData.put("prizeSeq",rs.getString("seq"));
                mapData.put("prizeCount",rs.getString("prize_count"));
                mapData.put("prizeName",rs.getString("prize_name"));
                mapData.put("image",rs.getString("prize_image"));
                mapData.put("prizeDesc", rs.getString("prize_desc"));
                resultList.add(mapData);
            }
            jsonData = Utils.mapListToJson(resultList);
        } catch (SQLException e) {
            e.printStackTrace();
        } finally {
            rsClose(stmt, rs, conn);
        }


        return jsonData;
    }

    public List<Integer> getSignNumberList(){
        List<Integer> signList = new ArrayList<>();
        Connection conn = getConnection();
        Statement stmt = null;
        ResultSet rs = null;
        try {
            String sql = "select lottery_number from itid_sign where enable_lottery=1";
            stmt = conn.createStatement();
            rs = stmt.executeQuery(sql);
            while(rs.next()){
                signList.add(rs.getInt("lottery_number"));
            }

        } catch (SQLException e) {
            e.printStackTrace();
        }finally {
            rsClose(stmt, rs, conn);
        }
        return signList;
    }

    private void rsClose(Statement stmt, ResultSet rs, Connection con) {
        try {
            if(stmt!=null){
                stmt.close();
            }
            if(rs!=null){
                rs.close();
            }
//            if(con!=null){
//                con.close();
//            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
    }

    private void rsClose(PreparedStatement ps, ResultSet rs, Connection con) {
        try {
            if(ps!=null){
                ps.close();
            }
            if(rs!=null){
                rs.close();
            }
//            if(con!=null){
//                con.close();
//            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
    }



    public List<Integer> luckyDraw(Integer prizeSeq, Integer winPrize){
        //Integer joinMember = 200;
        List<Integer> winNumberList = new ArrayList<Integer>();
        Map<Integer, List<Integer>>winMembersMap = this.getWinMemberMap();

        System.out.println(winMembersMap);
        List<Integer> allWinMembersList = new ArrayList<>(); //contains all the win prize numbers
        Integer prizeId = this.getPrizeIdbySeq(prizeSeq);


        if(winMembersMap!=null){
            if(prizeSeq!=4){
                Iterator iter = winMembersMap.keySet().iterator();
                while (iter.hasNext()){
                    Integer key = (Integer)iter.next();
                    if(key.equals(prizeId)){ //skip the existing win members of this round
                        continue;
                    }
                    List<Integer> winList = winMembersMap.get(key);
                    if(winList!=null){
                        allWinMembersList.addAll(winList);
                    }
                }
            }else{
                Iterator iter = winMembersMap.keySet().iterator();
                while (iter.hasNext()) {
                    Integer key = (Integer)iter.next();
                    List<Integer> winList = winMembersMap.get(key);
                    allWinMembersList.addAll(winList);
                }
            }
        }

        List<Integer> signNumList = getSignNumberList();
        {
            numList = new ArrayList<Integer>();
            int innerNum = 0;
            if(prizeSeq!=4){ // lottery the player, no need to filter the winner
                for (int i=0; i<signNumList.size(); i++){
                    innerNum = signNumList.get(i);
                    if(allWinMembersList!=null){
                        if(inNumList(allWinMembersList, innerNum)){
                            //System.out.println("Number: "+innerNum +" has win the prize before, this round will skip it");
                            continue;
                        }
                    }
                    numList.add(innerNum);
                }
            }else{
                numList.addAll(signNumList);
            }
            //ramdom the list
            Collections.shuffle(numList);
        }


        Integer prizeCount;
        int index; //win prize index, must use int
        Random random = new Random();
        //prizeCount = prizeMap.get(prizeKey);
        prizeCount = winPrize;
        int lotteryCount = prizeCount;
        if(prizeCount!=null && prizeCount>0){
            if(prizeCount>numList.size()) {
                //System.out.println("The lottery number list is less than the prizeCount, only draw out the number list count");
                lotteryCount = numList.size();
            }
                for(int i=0; i<lotteryCount; i++){
                    index = random.nextInt(numList.size());
                    //System.out.println("Congratulation! " + numList.get(index) + " win the Prize: " + prizeKey);
                    winNumberList.add(new Integer(numList.get(index)));
                    numList.remove(index);
                }
        }
        Collections.sort(winNumberList);

        if(prizeSeq!=4){
            this.saveWinResult(prizeId, winNumberList);
        }

        return winNumberList;

    }

    public static void main(String args[]){
        String test = "152";
        System.out.println(test.split(",")[0]);


    }
}
