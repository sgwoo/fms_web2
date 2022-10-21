<%@ page language="java" contentType="text/html; charset=euc-kr" %>
<%@ page import="java.util.*, acar.util.*, acar.car_service.*, acar.cus_reg.*"%>
<jsp:useBean id="ci_bean" class="acar.cus_reg.CarInfoBean" scope="page"/>
<jsp:useBean id="spdchk" scope="page" class="acar.cus_reg.SpdchkBean"/>
<%@ include file="/acar/cookies.jsp" %>
<%
	String car_mng_id = request.getParameter("car_mng_id")==null?"":request.getParameter("car_mng_id");
	String serv_id = request.getParameter("serv_id")==null?"":request.getParameter("serv_id");

	CusReg_Database cr_db = CusReg_Database.getInstance();
	SpdchkBean[] spdchks = cr_db.getSpdchk();
	ci_bean = cr_db.getCarInfo(car_mng_id);
	
	ServInfoBean siBn = cr_db.getServInfo(car_mng_id, serv_id);	
//System.out.println("spdchk="+siBn.getSpd_chk());	
	String[] seq = null;
	if(!siBn.getSpd_chk().equals("")){			
		Vector vt = new Vector();
		StringTokenizer st = new StringTokenizer(siBn.getSpd_chk(),"/");
		int k = 0;
		seq = new String[st.countTokens()];
		while(st.hasMoreTokens()){
			seq[k] = st.nextToken();
			k++;		
		}
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
function regSpdchk(){
	var fm = document.form1;
	if(!confirm("점검사항을 등록하시겠습니까?")){	return; }
	fm.action = "spdchk_ins.jsp";
	fm.target = "i_no";
	fm.submit();
}

var checkflag = "false";
function AllSelect(){
	if(checkflag == "false"){
		<% for(int i=0;i<spdchks.length; i++){ %>
		document.form1.radiobutton<%= i %>[0].click();
		<% } %>
		checkflag = "true";
		return;
	}else{
		<% for(int i=0;i<spdchks.length; i++){ %>
		document.form1.radiobutton<%= i %>[0].checked = false;
		<% } %>	
		checkflag = "false";
		return;
	}
	
}
-->
</script>
</head>

<body leftmargin="15">
<form name="form1" action="" method="post">
<input type="hidden" name="car_mng_id" value="<%= car_mng_id %>">
<input type="hidden" name="serv_id" value="<%= serv_id %>">
  <table width="800" border="0" cellspacing="1" cellpadding="0">
    <tr> 
      <td align="center"><b><font size="+2">자동차 점검 목록</font></b></td>
    </tr>
    <tr> 
      <td>&nbsp;</td>
    </tr>
    <tr> 
      <td class=line> 
        <table border="0" cellspacing="1" cellpadding='0' width=800>
          <tr bgcolor="#FFFFFF"> 
            <td class='title' width="80">차량번호</td>
            <td class='left' width="100" align="left">&nbsp;&nbsp;<%= ci_bean.getCar_no() %></td>
            <td class='title' width="80">차명</td>
            <td class='left' width="360" align="left">&nbsp;&nbsp;<%= ci_bean.getCar_jnm() %> <%= ci_bean.getCar_nm() %></td>
            <td class='title' width="80">최초등록일</td>
            <td class='left' width="100" align="center"><%= AddUtil.ChangeDate2(ci_bean.getInit_reg_dt()) %></td>
          </tr>
        </table>
      </td>
    </tr>
    <tr> 
      <td>&nbsp;</td>
    </tr>
    <tr> 
      <td> 
        <table width="800" cellspacing="0" cellpadding="0" bordercolordark="#FFFFFF" bordercolorlight="#000000" border="1">
          <tr> 
            <td width="30" align="center" bgcolor="#CCE2FB">No.</td>
            <td width="200" align="center" bgcolor="#CCE2FB">점검항목</td>
            <td width="390" height="40" align="center" bgcolor="#FFFFFF">점검내용</td>
            <td width="60" align="center" bgcolor="#FFFFFF"> 
              <input type="checkbox" name="checkbox" value="checkbox" onClick="javascript:AllSelect()">
              양호</td>
            <td width="60" align="center" bgcolor="#FFFFFF"> 보통</td>
            <td width="60" align="center" bgcolor="#FFFFFF"> 불량</td>
          </tr>
		<% for(int i=0; i<spdchks.length; i++){ 
			spdchk = spdchks[i];%>		  
          <tr> 
            <input type="hidden" name="chk_id<%= i %>" value="<%= spdchk.getChk_id() %>">
            <td align="center" bgcolor="#CCE2FB"><%= i+1 %></td>
            <td align="left" bgcolor="#CCE2FB">&nbsp;&nbsp;<%= spdchk.getChk_nm() %></td>
            <td height="40" align="left" bgcolor="#FFFFFF">&nbsp;&nbsp;<%= spdchk.getChk_cont() %></td>
            <td align="center" bgcolor="#FFFFFF"><input type="radio" name="radiobutton<%= i %>" value="1" 
				  	<%if(!siBn.getSpd_chk().equals("")){				
						for(int j=0; j<spdchks.length; j++){
							if(!seq[j].equals("")){
								if(seq[j].substring(13).equals(String.valueOf(i))&&seq[j].substring(0,1).equals("1")){%> checked <%}
							}	
						  }
					 }%>
				  	></td>
            <td align="center" bgcolor="#FFFFFF"><input type="radio" name="radiobutton<%= i %>" value="2" 
				  	<%if(!siBn.getSpd_chk().equals("")){
						for(int j=0; j<spdchks.length; j++){
							if(seq[j].substring(13).equals(String.valueOf(i))&&seq[j].substring(0,1).equals("2")){%> checked <%}
					    }
					}%>
					></td>
            <td align="center" bgcolor="#FFFFFF"><input type="radio" name="radiobutton<%= i %>" value="3" 
				  	<%if(!siBn.getSpd_chk().equals("")){
						for(int j=0; j<spdchks.length; j++){
							if(seq[j].substring(13).equals(String.valueOf(i))&&seq[j].substring(0,1).equals("3")){%> checked <%}
						  }
					 }%>
					></td>
          </tr>
		  <% } %>
        </table>
      </td>
    </tr>
    <tr> 
      <td align="right">                <% if(serv_id.equals("")){ %>
					<a href="javascript:regRound('i')">순회점검등록</a> 
				<% }else{ %>        
        <a href="javascript:regSpdchk()"><img src="/images/reg.gif" width="50" height="18" aligh="absmiddle" border="0"> </a> 
        <% } %>
        <a href="javascript:window.close();"><img src="/images/close.gif" width="50" height="18" aligh="absmiddle" border="0"></a></td>
    </tr>
  </table>
</form>
<iframe src="about:blank" name="i_no" width="0" height="0" frameborder="0" noresize></iframe>
</body>
</html>