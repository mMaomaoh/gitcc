package com.authine.cloudpivot.ext.util;

import java.io.Serializable;

import com.authine.cloudpivot.engine.enums.ErrCode;
import com.authine.cloudpivot.web.api.view.ResponseResult;

/**
 * 通用返回值封装
 * 
 * @author quyw
 * @date 2022/03/29
 */
public class ResponseResultUtils<T> implements Serializable {

    private static final long serialVersionUID = 1L;

    public static <T> ResponseResult<T> getOkResponseResult(T t, String errMsg) {
        return getErrResponseResult(t, ErrCode.OK.getErrCode(), errMsg);
    }

    public static <T> ResponseResult<T> getErrResponseResult(T t, Long errCode, String errMsg) {
        return ResponseResult.<T>builder().data(t).errcode(errCode).errmsg(errMsg).build();
    }

}