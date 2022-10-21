<%@ page language="java" contentType="text/html; charset=euc-kr" %>
<%@ page import="java.util.*, acar.util.*, acar.common.*, acar.car_office.*" %>
<%@ include file="/acar/cookies.jsp" %>

<%
	String auth_rw 		= request.getParameter("auth_rw")==null?"":request.getParameter("auth_rw");
	String br_id 		= request.getParameter("br_id")==null?"":request.getParameter("br_id");
	String user_id 		= request.getParameter("user_id")==null?"":request.getParameter("user_id");
	String com_con_no 	= request.getParameter("com_con_no")==null?"":request.getParameter("com_con_no");
	String seq 		= request.getParameter("seq")==null?"":request.getParameter("seq");
	String ret_dt 		= request.getParameter("ret_dt")==null?"":request.getParameter("ret_dt");
	String from_page 	= request.getParameter("from_page")==null?"":request.getParameter("from_page");
	String reg_dt = AddUtil.getDate();
	
	ret_dt = AddUtil.ChangeString(ret_dt);
	reg_dt = AddUtil.ChangeString(reg_dt);
	
	CommonDataBase c_db = CommonDataBase.getInstance();
	CarOfficeDatabase cod = CarOfficeDatabase.getInstance();
	
	//담당자 리스트
	Vector mngs = c_db.getUserList("", "", "EMP");
	int user_size = mngs.size();
	
	LoginBean login = LoginBean.getInstance();
	if(user_id.equals("")) user_id = login.getCookieValue(request, "acar_id");
	
	Vector sr = cod.getSucResList(com_con_no);
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
<script src="https://ajax.googleapis.com/ajax/libs/jquery/2.1.4/jquery.min.js"></script>
<script>
$(document).ready(function(){
	var carName = $(opener.document).find("#car_name").val();
	var regCode = $(opener.document).find("#reg_code").val();
	
	$('#car_name').val(carName);
	$('#reg_code').val(regCode);
})
</script>
<script language="JavaScript">
<!--
function regReserveCar(gubun){
	fm = document.form1;
	fm.gubun.value = gubun;
	
	<%for(int i = 0 ; i < sr_size ; i++){
		Hashtable sr_ht = (Hashtable)sr.elementAt(i);%>
		if('<%=sr_ht.get("REG_ID")%>' == fm.damdang_id.value) { alert('기등록자는 입력할 수 없습니다.'); return;}
	<%}%>	
	
	if(fm.cust_nm.value=='' || fm.cust_tel.value=='') { alert('고객명 및 연락처를 입력하십시오.'); return; }
	if(fm.cust_tel.value.replace(/-/gi,'').length < 9){	alert('고객연락처를 다시 입력하십시오.(숫자9자리이상)');	return;	}
	  
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
<input type="hidden" name="com_con_no" value="<%=com_con_no%>">
<input type="hidden" name="ret_dt" value="<%=ret_dt%>">
<input type="hidden" name="reg_dt" value="<%= AddUtil.getDate() %>">
<input type="hidden" name="gubun" value="">
<input type="hidden" name="sr_size" value="<%=sr_size%>">
<input type="hidden" name="from_page" value="<%=from_page%>">
<input type="hidden" name="prevEstId" id="prevEstId" value=""/>
<input type="hidden" name="car_name" id="car_name" value=""/>
<input type="hidden" name="reg_code" id="reg_code" value=""/>

<table width="100%" border="0" cellspacing="0" cellpadding="0">
    <tr> 
        <td >
            <table width=100% border=0 cellpadding=0 cellspacing=0>
                <tr>
                    <td width=7><img src=../images/center/menu_bar_1.gif width=7 height=33></td>
                    <td class=bar>&nbsp;&nbsp;&nbsp;<img src=../images/center/menu_bar_dot.gif width=4 height=5 align=absmiddle>&nbsp;<span class=style1><span class=style5>차량예약 입력사항</span></span></td>
                    <td width=7><img src=../images/center/menu_bar_2.gif width=7 height=33></td>
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
                    <td>&nbsp;<select name='damdang_id'>
                            <option value="">==선택==</option>
                            <%	if(user_size > 0){
        										    	for(int i = 0 ; i < user_size ; i++){
        												    Hashtable user = (Hashtable)mngs.elementAt(i); 
        										%>
        								    <option value='<%=user.get("USER_ID")%>' <% if(user_id.equals(user.get("USER_ID"))) out.println("selected");%>><%=user.get("USER_NM")%></option>	
        			    			    <%		}
         										    }
        								    %>										
                        </select>
        			      </td>
                </tr>
                <tr> 
                    <td width="20%" class=title>진행상황</td>
                    <td width="80%" colspan="4">&nbsp;<select name='situation'>
                            <option value="0">상담중</option>  
			                      <%if(sh_res_reg_chk==0){%>
                            <option value="2">계약확정</option>
			                      <%}%>
                        </select>
        			      </td>
                </tr>
                <tr> 
                    <td class=title>고객명</td>
                    <td>
                    	&nbsp;<input type="text" name="cust_nm" value="" size="30" id="cust_nm" class=text style='IME-MODE: active'>
                    </a>
                    </td>
                </tr>
                <tr> 
                    <td class=title>고객연락처</td>
                    <td >&nbsp;<input type="text" name="cust_tel" id="cust_tel" value="" size="15" maxlength='20' class=text style='IME-MODE: active'></td>
                </tr>
                <tr> 
                    <td class=title>메모</td>
                    <td >&nbsp;<textarea name="memo" cols="53" rows="6" style="IME-MODE:ACTIVE"><%if(from_page.equals("/acar/secondhand/sh_mon_rent_sc.jsp")){%>[월렌트]<%}%></textarea></td>
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
        <td align="right">        	
		        <a href="javascript:regReserveCar('i');"><img src=/acar/images/center/button_reg.gif align=absmiddle border=0></a>
		        &nbsp;&nbsp;
		        <a href="javascript:this.close();"><img src=/acar/images/center/button_close.gif align=absmiddle border=0></a>
	    </td>	
    </tr>                    
</table>
</form>
</body>
</html>
<iframe src="about:blank" name="i_no" width="100" height="100" cellpadding="0" cellspacing="0" border="1" frameborder="0" noresize></iframe>
