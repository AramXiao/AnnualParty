package com.service;

import java.util.Arrays;
import java.util.List;

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
}
