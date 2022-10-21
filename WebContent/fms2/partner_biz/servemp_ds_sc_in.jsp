<%@ page contentType="text/html; charset=euc-kr" %>
<%@ page language="java" %> 
<%@ page import="java.util.*, acar.util.*" %>
<%@ page import="acar.partner.*" %>
<%@ include file="/acar/cookies.jsp" %>
<%
	String auth_rw = request.getParameter("auth_rw")==null?"":request.getParameter("auth_rw");
	String s_kd = request.getParameter("s_kd")==null?"":request.getParameter("s_kd");
	String t_wd = request.getParameter("t_wd")==null?"":request.getParameter("t_wd");
	String sort_gubun = request.getParameter("sort_gubun")==null?"":request.getParameter("sort_gubun");
	String sort = request.getParameter("sort")==null?"":request.getParameter("sort");
	String off_id = request.getParameter("off_id")==null?"":request.getParameter("off_id");
	String use_yn = request.getParameter("use_yn")==null?"all":request.getParameter("use_yn");
	
	String cpt_cd = request.getParameter("cpt_cd")==null?"":request.getParameter("cpt_cd");	
	String mon_amt = request.getParameter("mon_amt")==null?"":request.getParameter("mon_amt");	
	String save_dt  = request.getParameter("save_dt")==null?"":request.getParameter("save_dt");	
	
	String gubun1 = request.getParameter("gubun1")==null?"":request.getParameter("gubun1");	
		
	
	Serv_EmpDatabase se_dt = Serv_EmpDatabase.getInstance();
	Hashtable ht_serv_off = se_dt.getServOff(off_id);
	if(String.valueOf(ht_serv_off.get("GUBUN_B")).equals("1")){		sort_gubun = "1";			}
	else{																							sort_gubun = "";			}
	
	Vector vt = se_dt.getServ_empList(s_kd, t_wd, sort_gubun, sort, off_id, use_yn);
	int vt_size = vt.size();	
	
	long sum_amt = 0;	
%>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<html>
<head>
<title>FMS</title>
<meta http-equiv="Content-Type" content="text/html; charset=euc-kr">
<link rel="stylesheet" type="text/css" href="/include/table_t.css"></link>

<script language="JavaScript">
<!--
	function sms_send(emp_nm, mtel){
	var SUBWIN="/acar/sms_gate/sms_mini_gate.jsp?auth_rw=<%= auth_rw %>&destname="+emp_nm+"&destphone="+mtel;
	window.open(SUBWIN, "sms_send", "left=100, top=120, width=500, height=400, scrollbars=no");
}

function serv_emp_upd(emp_nm, seq){
	var SUBWIN="serv_emp_u.jsp?auth_rw=<%= auth_rw %>&off_id=<%=off_id%>&emp_nm="+emp_nm+"&seq="+seq;
	window.open(SUBWIN, "ServEmpUpd", "left=100, top=120, width=1000, height=300, scrollbars=no");
}


function update_email_yn(off_id, seq, yn){
	
		var fm = document.form1;
		
		if(confirm('변환처리 하시겠습니까?')){	
		fm.action="emp_email_yn_a.jsp?off_id="+off_id+"&seq="+seq+"&yn="+yn;
	//	fm.target='i_no';
		fm.submit();
		}
	}
	
//-->
</script>
</head>

<body>
<form name='form1' method='post'>
<input type='hidden' name='auth_rw' value='<%=auth_rw%>'>
<input type='hidden' name='off_id' value='<%=off_id%>'>
<input type='hidden' name='cpt_cd' value='<%=cpt_cd%>'>
<input type='hidden' name='mon_amt' value='<%=mon_amt%>'>
<input type='hidden' name='save_dt' value='<%=save_dt%>'>
<input type='hidden' name='gubun1' value='<%=gubun1%>'>
<table width="100%" border=0 cellpadding=0 cellspacing=0>
    <tr>
        <td class=line2></td>
    </tr>
    <tr>
        <td class=line>
            <table border="0" cellspacing="1" width=100%>
			<% for(int i=0; i< vt_size; i++){
				Hashtable ht = (Hashtable)vt.elementAt(i);
			%>
			
				<tr>
					<td class="title" width="10%">성명</td>
					<td class="title" width="15%">부서</td>
					<td class="title" width="10%">직책</td>
					<td class="title" width="10%">대표전화</td>
					<td class="title" width="10%">직통전화</td>
					<td class="title" width="10%">팩스</td>
					<td class="title" width="10%">휴대폰</td>
				</tr>
				<tr>
					<td rowspan="4" colspan="1" align="center"><a href="javascript:serv_emp_upd('<%=ht.get("EMP_NM")%>','<%=ht.get("SEQ")%>')"><%=ht.get("EMP_NM")%>
					<%if(!String.valueOf(ht.get("EMP_LEVEL")).equals("")&&!String.valueOf(ht.get("POS")).equals("")){%><%=ht.get("POS")%><%}else{%><%=ht.get("POS")%><%=ht.get("EMP_LEVEL")%><%}%>
					</a></td>
					<td align="center"><%=ht.get("DEPT_NM")%></td>
					<td align="center"><%=ht.get("POS")%></td>
					<td align="center"><%=ht.get("EMP_TEL")%></td>
					<td align="center"><%=ht.get("EMP_HTEL")%></td>
					<td align="center"><%=ht.get("EMP_FAX")%></td>
					<td align="center"><a href="javascript:sms_send('<%=ht.get("EMP_NM")%>','<%=ht.get("EMP_MTEL")%>')"><%=ht.get("EMP_MTEL")%></a></td>
				</tr>
				<tr>
					<td rowspan="1" class="title">E-mail</td>
					<td class="title" width="10%">일괄발송구분</td>
					<td class="title" width="10%">최초등록</td>
					<td class="title" width="10%">변경등록</td>
					<td class="title" width="10%">담당업무</td>
					<td class="title" width="10%">유효구분</td>
				</tr>
				<tr>
					<td rowspan="1" align="center"><%=ht.get("EMP_EMAIL")%></td>
					<td align="center" ><a href="javascript:update_email_yn('<%=ht.get("OFF_ID")%>','<%=ht.get("SEQ")%>','<%=ht.get("EMP_EMAIL_YN")%>')"><%if(ht.get("EMP_EMAIL_YN").equals("N")){%>비대상<%}else{%>대상<%}%></a></td>
					<td align="center"><%=AddUtil.ChangeDate2(String.valueOf(ht.get("REG_DT")))%></td>
					<td align="center"><%=AddUtil.ChangeDate2(String.valueOf(ht.get("UPT_DT")))%></td>
					<td align="center" ><%=ht.get("EMP_ROLE")%></td>
					<td align="center"><%if(ht.get("EMP_VALID").equals("1")){%>유효
					<%}else if(ht.get("EMP_VALID").equals("2")){%>부서변경
					<%}else if(ht.get("EMP_VALID").equals("3")){%>퇴직
					<%}else if(ht.get("EMP_VALID").equals("4")){%>무효
					<%}%>
					</td>
					
				</tr>
				<tr>
					<td class="title">주소</td>
					<td rowspan="1" colspan="6">&nbsp;&nbsp;(<%=ht.get("EMP_POST")%>)&nbsp;&nbsp;<%=ht.get("EMP_ADDR")%></td>
				</tr>
				<%}%>
			</table>
        </td>
    </tr>
</table>
</form>
</body>
</html>
