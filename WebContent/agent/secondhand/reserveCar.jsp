<%@ page language="java" contentType="text/html; charset=euc-kr" %>
<%@ page import="java.util.*, acar.util.*, acar.common.*, acar.secondhand.*" %>
<jsp:useBean id="shDb" class="acar.secondhand.SecondhandDatabase" scope="page"/>
<jsp:useBean id="shBn" class="acar.secondhand.SecondhandBean" scope="page"/>
<%@ include file="/agent/cookies.jsp" %>

<%
	String auth_rw 		= request.getParameter("auth_rw")==null?"":request.getParameter("auth_rw");
	String br_id 		= request.getParameter("br_id")==null?"":request.getParameter("br_id");
	String user_id 		= request.getParameter("user_id")==null?"":request.getParameter("user_id");
	String car_mng_id 	= request.getParameter("car_mng_id")==null?"":request.getParameter("car_mng_id");
	String seq 		= request.getParameter("seq")==null?"":request.getParameter("seq");
	String ret_dt 		= request.getParameter("ret_dt")==null?"":request.getParameter("ret_dt");
	String from_page 	= request.getParameter("from_page")==null?"":request.getParameter("from_page");
	
	String reg_dt = AddUtil.getDate();
	
	ret_dt = AddUtil.ChangeString(ret_dt);
	reg_dt = AddUtil.ChangeString(reg_dt);
	
	CommonDataBase c_db = CommonDataBase.getInstance();
	
	
	
	LoginBean login = LoginBean.getInstance();
	if(user_id.equals("")) user_id = login.getCookieValue(request, "acar_id");
	
	Vector sr = shDb.getShResList(car_mng_id);
	int sr_size = sr.size();
	
	int sh_res_reg_chk = 0;
	for(int i = 0 ; i < sr_size ; i++){
		Hashtable sr_ht = (Hashtable)sr.elementAt(i);
		if(String.valueOf(sr_ht.get("SITUATION")).equals("0")) sh_res_reg_chk++;
	}
%>

<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<html>
<head>
<title>FMS</title>
<meta http-equiv="Content-Type" content="text/html; charset=euc-kr">
<link rel="stylesheet" type="text/css" href="/include/table_t.css">
<script language='JavaScript' src='/include/common.js'></script>
<script language="JavaScript">
<!--
function regReserveCar(gubun){
	fm = document.form1;
	fm.gubun.value = gubun;
	
	<%for(int i = 0 ; i < sr_size ; i++){
		Hashtable sr_ht = (Hashtable)sr.elementAt(i);%>
		if('<%=sr_ht.get("DAMDANG_ID")%>' == fm.damdang_id.value) { alert('기등록자는 입력할 수 없습니다.'); return;}
	<%}%>	
	
	if(fm.memo.value=='') { alert('고객명 및 연락처를 입력하십시오.'); return; }
	
	if(gubun=="i"){
		if(!confirm("등록 하시겠습니까?"))	return;
	}else{
		if(!confirm("수정 하시겠습니까?"))	return;
	}
	fm.action = "reserveCar_iu.jsp";
	fm.target = "i_no";
	fm.submit();
}
//-->
</script>
</head>

<body>
<form name="form1" method="post">
<input type="hidden" name="car_mng_id" value="<%=car_mng_id%>">
<input type="hidden" name="ret_dt" value="<%=ret_dt%>">
<input type="hidden" name="reg_dt" value="<%= AddUtil.getDate() %>">
<input type="hidden" name="gubun" value="">
<input type="hidden" name="sr_size" value="<%=sr_size%>">

<table width="100%" border="0" cellspacing="0" cellpadding="0">
    <tr> 
        <td >
            <table width=100% border=0 cellpadding=0 cellspacing=0>
                <tr>
                    <td width=7><img src=/acar/images/center/menu_bar_1.gif width=7 height=33></td>
                    <td class=bar>&nbsp;&nbsp;&nbsp;<img src=/acar/images/center/menu_bar_dot.gif width=4 height=5 align=absmiddle>&nbsp;<span class=style1><span class=style5>차량예약 입력사항</span></span></td>
                    <td width=7><img src=/acar/images/center/menu_bar_2.gif width=7 height=33></td>
                </tr>
            </table>            
        </td>
    </tr>	
    <tr> 
        <td class=h></td>
    </tr>
    <tr> 
        <td class=line2 ></td>
    </tr>
    <tr> 
        <td class="line">
            <table border="0" cellspacing="1" cellpadding=0 width=100%>
                <tr> 
                    <td class=title>담당자</td>
                    <td >
        			  &nbsp;<%=c_db.getNameById(user_id, "USER")%>
        			  <input type="hidden" name="damdang_id" value="<%=user_id%>">
        			  
        			</td>
                </tr>
                <tr> 
                    <td width="20%" class=title>진행상황</td>
                    <td width="80%" colspan="4">
        			  &nbsp;<select name='situation'>
                        <option value="0">상담중</option>  
			<%if(sh_res_reg_chk==0){%>
                        <option value="2">계약확정</option>
			<%}%>
                      </select>
        			</td>
                </tr>
                <tr> 
                    <td class=title>메모</td>
                    <td >&nbsp;<textarea name="memo" cols="48" rows="4" style="IME-MODE:ACTIVE"><%if(from_page.equals("/acar/secondhand/sh_mon_rent_sc.jsp")){%>[월렌트]<%}%></textarea></td>
                </tr>
            </table>
        </td>
    </tr>
    <tr>  
        <td>* 현재 차량예약이 등록된 담당자는 중복 입력할수 없습니다.
	    </td>	
    </tr>	
    <tr>  
        <td>* 상담중인 예약이 있으면 계약확정을 등록할수 없습니다.
	    </td>	
    </tr>	
    <tr>  
        <td>* 메모에 고객명과 고객연락처를 꼭 입력하십시오.
	    </td>	
    </tr>	
    <tr>  
        <td align="right"><!--<a href="javascript:this.close();"><img src=/acar/images/center/button_close.gif align=absmiddle border=0></a>&nbsp;&nbsp;-->
	    <a href="javascript:regReserveCar('i');"><img src=/acar/images/center/button_reg.gif align=absmiddle border=0></a>
	    </td>	
    </tr>
</table>
</form>
</body>
</html>
<iframe src="about:blank" name="i_no" width="100" height="100" cellpadding="0" cellspacing="0" border="1" frameborder="0" noresize></iframe>
