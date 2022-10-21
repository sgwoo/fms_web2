<%@ page language="java" contentType="text/html; charset=euc-kr" %>
<%@ page import="java.util.*, acar.util.*, acar.estimate_mng.*" %>
<jsp:useBean id="bean" class="acar.estimate_mng.EstimateBean" scope="page"/>
<%@ include file="/agent/cookies.jsp" %>

<%
	String auth_rw = request.getParameter("auth_rw")==null?"":request.getParameter("auth_rw");
	String br_id = request.getParameter("br_id")==null?"":request.getParameter("br_id");
	String user_id = request.getParameter("user_id")==null?"":request.getParameter("user_id");
	String gubun1 = request.getParameter("gubun1")==null?"":request.getParameter("gubun1");
	String gubun2 = request.getParameter("gubun2")==null?"":request.getParameter("gubun2");
	String gubun3 = request.getParameter("gubun3")==null?"1":request.getParameter("gubun3");
	String gubun4 = request.getParameter("gubun4")==null?"1":request.getParameter("gubun4");
	String gubun5 = request.getParameter("gubun5")==null?"":request.getParameter("gubun5");
	String gubun6 = request.getParameter("gubun6")==null?"":request.getParameter("gubun6");
	String s_dt = request.getParameter("s_dt")==null?"":request.getParameter("s_dt");
	String e_dt = request.getParameter("e_dt")==null?"":request.getParameter("e_dt");
	String s_kd = request.getParameter("s_kd")==null?"":request.getParameter("s_kd");
	String t_wd = request.getParameter("t_wd")==null?"":request.getParameter("t_wd");
	
	String set_code = request.getParameter("set_code")==null?"":request.getParameter("set_code");
	String est_id 	= request.getParameter("est_id")==null?"":request.getParameter("est_id");
	String from_page = request.getParameter("from_page")==null?"":request.getParameter("from_page");

	String cng_est_id 	= request.getParameter("cng_est_id")	==null?"":request.getParameter("cng_est_id");
	
	EstiDatabase e_db = EstiDatabase.getInstance();
	
	EstimateBean e_bean = e_db.getEstimateCase(cng_est_id);

%>

<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<html>
<head>
<title>FMS</title>
<meta http-equiv="Content-Type" content="text/html; charset=euc-kr">
<link rel="stylesheet" type="text/css" href="../../include/table_t.css">
<script language='JavaScript' src='/include/common.js'></script>
<script language="JavaScript">
<!--
	//등록/수정: 공급가, 부가세, 합계 입력시 자동계산
	function set_amt(obj)
	{
		var fm = document.form1;	
		
		if(obj==fm.ctr_s_amt){ 		//조정대여료 공급가
			obj.value = parseDecimal(obj.value);
			fm.ctr_v_amt.value 	= parseDecimal(toInt(parseDigit(fm.ctr_s_amt.value)) * 0.1 );
			fm.ctr_amt.value	= parseDecimal(toInt(parseDigit(fm.ctr_s_amt.value)) + toInt(parseDigit(fm.ctr_v_amt.value)));			
		}else if(obj==fm.ctr_v_amt){ 	//조정대여료 부가세
			obj.value = parseDecimal(obj.value);
			fm.ctr_amt.value	= parseDecimal(toInt(parseDigit(fm.ctr_s_amt.value)) + toInt(parseDigit(fm.ctr_v_amt.value)));						
		}else if(obj==fm.ctr_amt){ 	//조정대여료 합계
			obj.value = parseDecimal(obj.value);
			fm.ctr_s_amt.value 	= parseDecimal(sup_amt(toInt(parseDigit(fm.ctr_amt.value))));
			fm.ctr_v_amt.value 	= parseDecimal(toInt(parseDigit(fm.ctr_amt.value)) - toInt(parseDigit(fm.ctr_s_amt.value)));			
		}
	}
	
	//등록하기
	function save(){
		fm = document.form1;	
		var ctr_amt = toInt(parseDigit(fm.ctr_amt.value));	
		if(ctr_amt == 0)	{ 	alert('조정대여료를 입력하십시오.');	fm.ctr_amt.focus();	return;	}
		if(!confirm("조정하시겠습니까?"))		return;		
		fm.target = "i_no";
		fm.action='upd_esti_amt_a.jsp';
		fm.submit();
	}		
//-->
</script>
</head>
<body>
<form action="" name="form1" method="POST" >
    <input type="hidden" name="auth_rw" value="<%=auth_rw%>">
    <input type="hidden" name="br_id" value="<%=br_id%>">
    <input type="hidden" name="user_id" value="<%=user_id%>">
    <input type="hidden" name="gubun1" value="<%=gubun1%>">
    <input type="hidden" name="gubun2" value="<%=gubun2%>">
    <input type="hidden" name="gubun3" value="<%=gubun3%>">
    <input type="hidden" name="gubun4" value="<%=gubun4%>">
    <input type="hidden" name="gubun5" value="<%=gubun5%>">
    <input type="hidden" name="gubun6" value="<%=gubun6%>">  
    <input type="hidden" name="s_dt" value="<%=s_dt%>">
    <input type="hidden" name="e_dt" value="<%=e_dt%>">
    <input type="hidden" name="s_kd" value="<%=s_kd%>">
    <input type="hidden" name="t_wd" value="<%=t_wd%>">
    <input type="hidden" name="est_id" value="<%=est_id%>">
    <input type="hidden" name="set_code" value="<%=set_code%>">
    <input type="hidden" name="from_page" value="<%=from_page%>">
    <input type="hidden" name="cng_est_id" value="<%=cng_est_id%>">
<table border=0 cellspacing=0 cellpadding=0 width=100%>
	<tr>
        <td><img src=/acar/images/center/icon_arrow.gif align=absmiddle> <span class=style2>대여료 조정</span></td>
    </tr>
    <tr>
        <td class=line2></td>
    </tr>
    <tr>
        <td class=line>
            <table border="0" cellspacing="1" width=100%>
                <tr>
                    <td width="20%" class=title>구분</td>
                    <td width="40%" class=title>조정전</td>
                    <td width="40%" class=title>조정후</td>
                </tr>
                <tr>
        	    <td align="center">공급가</td>                    
                    <td align="center"><input type="text" name="fee_s_amt" value="<%=AddUtil.parseDecimal(e_bean.getFee_s_amt())%>" size="12" class=whitenum>원</td>
                    <td align="center"><input type="text" name="ctr_s_amt" value="" size="12" class=num onBlur="javascript:set_amt(this)">원</td>          
                </tr>
                <tr>
        	    <td align="center">부가세</td>                    
                    <td align="center"><input type="text" name="fee_v_amt" value="<%=AddUtil.parseDecimal(e_bean.getFee_v_amt())%>" size="12" class=whitenum>원</td>
                    <td align="center"><input type="text" name="ctr_v_amt" value="" size="12" class=num onBlur="javascript:set_amt(this)">원</td>          
                </tr>
                <tr>
        	    <td align="center">합계</td>                    
                    <td align="center"><input type="text" name="fee_amt" value="<%=AddUtil.parseDecimal(e_bean.getFee_s_amt()+e_bean.getFee_v_amt())%>" size="12" class=whitenum>원</td>
                    <td align="center"><input type="text" name="ctr_amt" value="" size="12" class=num onBlur="javascript:set_amt(this)">원</td>          
                </tr>
            </table>
        </td>
    </tr>
    <tr>
        <td></td>
    </tr>    
    <tr> 
        <td align="right"> 
         		<a href="javascript:save();"><img src=/acar/images/center/button_reg.gif align=absmiddle border=0></a>&nbsp;&nbsp;
			<a href="javascript:self.close();"><img src=/acar/images/center/button_close.gif align=absmiddle border=0></a>
        </td>
    </tr>  
</table>	
</form>	
<script>
<!--	
//-->
</script>	
</body>
</html>
<iframe src="about:blank" name="i_no" width="0" height="0" frameborder="0" noresize></iframe>