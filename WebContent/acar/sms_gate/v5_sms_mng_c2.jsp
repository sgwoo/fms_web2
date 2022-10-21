<%@ page language="java" contentType="text/html;charset=euc-kr" %>
<%@ page import="java.util.*, acar.util.*, acar.car_office.*, acar.common.*, acar.cont.*"%>
<jsp:useBean id="a_db" scope="page" class="acar.cont.AddContDatabase"/>
<%@ include file="/acar/cookies.jsp" %>

<%
	String auth_rw = request.getParameter("auth_rw")==null?"":request.getParameter("auth_rw");
	String br_id = request.getParameter("br_id")==null?"":request.getParameter("br_id");
	String user_id = request.getParameter("user_id")==null?"":request.getParameter("user_id");
	
	String gubun 	= request.getParameter("gubun")==null?"1":request.getParameter("gubun");
 	String gubun_nm = request.getParameter("gubun_nm")==null?"":request.getParameter("gubun_nm");
	String dest_gubun= request.getParameter("dest_gubun")==null?"":request.getParameter("dest_gubun");
	String send_dt 	= request.getParameter("send_dt")==null?"1":request.getParameter("send_dt");
	String s_bus 	= request.getParameter("s_bus")==null?"":request.getParameter("s_bus");
	String sort 	= request.getParameter("sort")==null?"":request.getParameter("sort");
	String sort_gubun= request.getParameter("sort_gubun")==null?"":request.getParameter("sort_gubun");
	String st_dt 	= request.getParameter("st_dt")==null?"":request.getParameter("st_dt");
	String end_dt 	= request.getParameter("end_dt")==null?"":request.getParameter("end_dt");
	String s_kd 	= request.getParameter("s_kd")==null?"":request.getParameter("s_kd");
	String t_wd 	= request.getParameter("t_wd")==null?"":request.getParameter("t_wd");
	
	String cmid		= request.getParameter("cmid")==null?"":request.getParameter("cmid");
	String cmst		= request.getParameter("cmst")==null?"":request.getParameter("cmst");
	
	CarOfficeDatabase umd = CarOfficeDatabase.getInstance();
	Hashtable ht = umd.getSmsV5No(cmid, cmst);
	
	CommonDataBase c_db = CommonDataBase.getInstance();
	
	//담당자 리스트
	Vector users = c_db.getUserList("", "", "EMP");
	int user_size = users.size();
	String user_nm = "";
	if(user_size > 0){
		for (int i = 0 ; i < user_size ; i++){
			Hashtable user = (Hashtable)users.elementAt(i);	

			if(ht.get("BUS_ID").equals(user.get("USER_ID"))) user_nm = String.valueOf(user.get("USER_NM"));
		}
	}	
	
%>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=euc-kr">
<title>FMS</title>
<link rel="stylesheet" type="text/css" href="/include/table_t.css"></link>
<%@ include file="/acar/getNaviCookies.jsp" %>
</head>
<script language='javascript'>
<!--

function UpDisp()
{
	var theForm = document.form;
	theForm.submit();
}
//-->
</script>
<body>
<form action="v5_sms_cre_u2.jsp" name="form" method="post">
	<input type="hidden" name="cmid" value="<%=ht.get("CMID")%>">
	<input type="hidden" name="auth_rw" value="<%=auth_rw%>">
    <input type='hidden' name="ck_acar_id" value="<%=ck_acar_id%>"> 
<table width="700" border="0" cellspacing="0" cellpadding="0">
    <tr>
    	<td colspan=10>
    	    <table width=100% border=0 cellpadding=0 cellspacing=0>
                <tr>
                    <td width=7><img src=/acar/images/center/menu_bar_1.gif width=7 height=33></td>
                    <td class=bar>&nbsp;&nbsp;&nbsp;<img src=/acar/images/center/menu_bar_dot.gif width=4 height=5 align=absmiddle>&nbsp;<span class=style1><span class=style5>신용조회 문자 미발송 세부내역</span></span></td>
                    <td width=7><img src=/acar/images/center/menu_bar_2.gif width=7 height=33></td>
                </tr>
            </table>
    	</td>
    </tr>
    <tr>
        <td class=h></td>
    </tr> 	
    <tr><td class=line2></td></tr>
    <tr>
        <td class="line">
            <table width="700" border="0" cellspacing="1" cellpadding="0">
                <tr>
				    <td class="title" width=12%>발송대상</td>
                    <td colspan='3'>&nbsp;신용조회</td>
                </tr>
                <tr>
				    <td class="title" width=12%>수신자</td>
                    <td width=38%>&nbsp;<%= ht.get("DEST_NAME") %></td>
                    <td width=12% class="title">수신번호</td>
                    <td width=38%>&nbsp;<%= ht.get("DEST_PHONE") %></td>
                </tr>
				<tr>
				    <td class="title" width=12%>의뢰자</td>
                    <td width=38%>&nbsp;<%=user_nm%></td>
                    <td width=12% class="title">신용조회등급</td>
                    <td width=38%>&nbsp;NICE : <%= ht.get("SCORE") %>  &nbsp; KCB : <%= ht.get("SCORE2") %></td>
                </tr>
                <tr>
				    <td class="title" width=12%>발신자</td>
                    <td width=38%>&nbsp;<%= ht.get("SEND_NM") %></td>
                    <td width=12% class="title">회신번호</td>
                    <td width=38%>&nbsp;<%= ht.get("SEND_PHONE") %></td>
                </tr>				
                <tr>
                    <td class="title">메모내용 </td>
                    <td colspan="3">&nbsp;<textarea name="textarea" rows="5" cols="95"><%= ht.get("MSG_BODY") %></textarea></td>
                </tr>
                <tr>
                    <td class="title">등록일자 </td>
                    <td colspan="3">&nbsp;<%= AddUtil.ChangeDate3(String.valueOf(ht.get("REG_DT"))) %></td>
                </tr>
            </table>
        </td>
    </tr>	
    <%	if(!String.valueOf(ht.get("KEY_NO")).equals("")){
    		ContEvalBean eval_key = a_db.getContEvalKey(String.valueOf(ht.get("KEY_NO")));	
    		if(!eval_key.getKey_no().equals("")){
    %>
    <tr>
        <td class=h></td>
    </tr> 	    
    <tr>
	<td class=line2></td>		
    </tr>
    <tr>
	<td class="line">
	    <table border="0" cellspacing="1" cellpadding="0" width=100%>
                <tr>                    
                    <td width="30%" class='title'>성명</td>
                    <td width="16%" class='title'>생년월일</td>
                    <td width="18%" class='title'>휴대폰번호</td>
                    <td width="18%" class='title'>NICE</td>		  
                    <td width="18%" class='title'>KCB</td>                    
                </tr>
                <tr>                     
                    <td align='center'><%=eval_key.getKey_name()%></td>		  
                    <td align='center'><%=eval_key.getKey_birth_dt()%></td>
                    <td align='center'><%=eval_key.getKey_m_tel()%></td>
                    <td align='center'><%=eval_key.getKey_nice()%></td>
                    <td align='center'><%=eval_key.getKey_kcb()%></td>
                </tr>    				
            </table>
        </td>
	</tr>    
    <%		}
    	}%>

    <tr>
        <td class=h></td>
    </tr> 	
    <tr> 
        <td align="right">
		<%//if(auth_rw.equals("6")){%>
		<a href="javascript:UpDisp()" onMouseOver="window.status=''; return true"><img src="/acar/images/center/button_modify_s.gif" align=absmiddle border=0></a>
		<%//}%>
		&nbsp;<a href="javascript:window.close()"><img src="/acar/images/center/button_close.gif" align="absmiddle" border="0"></a></td>
    </tr>		
</table>
</form>
</body>
</html>