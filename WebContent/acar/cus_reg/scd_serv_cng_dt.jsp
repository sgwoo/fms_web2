<%@ page language="java" contentType="text/html;charset=euc-kr" %>
<%@ page import="java.util.*, acar.util.*, acar.cus_reg.*"%>
<%@ include file="/acar/cookies.jsp" %>
<%
	String auth_rw = request.getParameter("auth_rw")==null?"":request.getParameter("auth_rw");
	String car_mng_id = request.getParameter("car_mng_id")==null?"":request.getParameter("car_mng_id");	

	CusReg_Database cr_db = CusReg_Database.getInstance();
	Vector serv_ids = cr_db.getScdServ_id(car_mng_id);
	int serv_id_size = serv_ids.size();
%>

<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<html>
<head>
<title>FMS</title>
<meta http-equiv="Content-Type" content="text/html; charset=euc-kr">
</head>

<script language='JavaScript' src='/include/common.js'></script>
<script language='javascript'>
<!--
	function save()
	{
		var fm = document.form1;
		if((fm.next_serv_dt.value == '')|| !isDate(fm.next_serv_dt.value))	{	alert('다음정비예정일을 확인하십시오');		return;	}
		if((fm.serv_cng_cau.value == '')){		alert('변경사유를 확인하십시오');		return;	}		
		if(fm.c_all.checked == true)
			fm.h_all.value = 'Y';
		else
			fm.h_all.value = 'N';

		fm.target = 'i_no';
		//fm.target = 'about:blank';
		fm.submit();
	}

-->
</script>
<link rel=stylesheet type="text/css" href="/include/table_t.css">
</head>
<body>
<form name='form1' action='scd_serv_cng_dt_iu.jsp' method='post'>
<input type='hidden' name='auth_rw' value='<%=auth_rw%>'>
<input type='hidden' name='car_mng_id' value='<%=car_mng_id%>'>
<input type="hidden" name="h_all" value="">

<table border="0" cellspacing="0" cellpadding="0" width=100%>
	<tr>
    	<td>
    	    <table width=100% border=0 cellpadding=0 cellspacing=0>
                <tr>
                    <td width=7><img src=/acar/images/center/menu_bar_1.gif width=7 height=33></td>
                    <td class=bar>&nbsp;&nbsp;&nbsp;<img src=/acar/images/center/menu_bar_dot.gif width=4 height=5 align=absmiddle>&nbsp;<span class=style1><span class=style5>다음예정일변경</span></span></td>
                    <td width=7><img src=/acar/images/center/menu_bar_2.gif width=7 height=33></td>
                </tr>
            </table>
    	</td>
    </tr>
    <tr>
        <td class=h></td>
    </tr>
    <tr>
        <td class=line2></td>
    </tr>
	<tr>
		<td class='line'>
			 <table border="0" cellspacing="1" cellpadding="0" width=100%>
				<tr>
					<td class='title' width=30%>변경회차 </td>
					<td width=70%>&nbsp;
					<%	if(serv_id_size > 0){%>
						<select name='serv_id'>
					<%		for(int i = 0 ; i < serv_id_size ; i++){
								Hashtable serv_id = (Hashtable)serv_ids.elementAt(i);%>
							<option value='<%=serv_id.get("SERV_ID")%>'><%=serv_id.get("SERV_ID")%></option>
					<%		}%>
						</select> 회	&nbsp;<input type='checkbox' name='c_all'>선택회차 이후 모두 변경
					<%	}else{%>
						선택가능한 회차가 없습니다.
					<%	}%>		
					</td>
				</tr>
				<tr>
					<td class='title'>변경일자 </td>
					<td>&nbsp;<input type='text' name='next_serv_dt' size='12' maxlength='12' class='text' onBlur='javascript:this.value = ChangeDate(this.value);'></td>
				</tr>
				<tr>
					<td class='title'>변경사유 </td>
					<td>&nbsp;<textarea name='serv_cng_cau' cols='33' maxlength='255'></textarea> </td>
				</tr>
			</table>
		</td>
	</tr>
	<tr>
		<td align='right'><a href='javascript:save()'><img src="/acar/images/center/button_modify.gif" align="absmiddle" border="0"></a>
		&nbsp;&nbsp;<a href='javascript:window.close()'><img src="/acar/images/center/button_close.gif" align="absmiddle" border="0"></a></td>
	</tr>	
</table>
</form>
</body>
</html>
<iframe src="about:blank" name="i_no" width="0" height="0" frameborder="0" noresize>
</iframe>