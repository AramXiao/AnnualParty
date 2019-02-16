package com.service;

import com.alibaba.fastjson.JSON;

import java.util.Arrays;
import java.util.List;
import java.util.Map;

public class Utils {

    public static String toHtml(Object val){
        if(val==null){
            return "";
        }
        String tmp = val.toString();
       return  tmp.trim();
    }

    public static String listToStr(List<Integer> list){
        if(list==null || list.size()==0){
            return "";
        }
        String result = "";
        result = Arrays.toString(list.toArray(new Integer[list.size()]));
        System.out.println("listToStr-->result: "+result);
        return result;
    }

    public static String last5Num(String s){
        if(s.length()<=5){
            return s;
        }
        return s.substring(s.length()-5);
    }

    public static Integer toInt(Object o){
        Integer i = 0;

        try {
            i = Integer.parseInt(String.valueOf(o));
        } catch (NumberFormatException e) {
            e.printStackTrace();
            i = 0;
        }
        return i;
    }


    public static String mapListToJson(List<Map<String,String>> resultList){
       return JSON.toJSONString(resultList);
    }
}
