package com.service;

import net.sf.json.JSONObject;

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

    public static String mapToJson(Map<String,String> dataMap){
        JSONObject jsonObject = JSONObject.fromObject(dataMap);
        return jsonObject.toString();
    }
}
