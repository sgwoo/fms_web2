<%@ page language="java" contentType="text/html;charset=euc-kr" %>
<%@ page import="java.util.*, acar.util.*"%>
<%@ page import="acar.offls_cmplt.*"%>
<jsp:useBean id="olcD" class="acar.offls_cmplt.Offls_cmpltDatabase" scope="page"/>
<jsp:useBean id="olaD" class="acar.offls_actn.Offls_actnDatabase" scope="page"/>
<%@ include file="/acar/cookies.jsp" %>
<%
	String auth_rw = request.getParameter("auth_rw")==null?"":request.getParameter("auth_rw");
	String car_mng_id = request.getParameter("car_mng_id")==null?"":request.getParameter("car_mng_id");
	
	CmpltBean cmplt = olcD.getCmpltBean(car_mng_id);
%>
<html>
<head><title>FMS</title>
<script language='javascript' src='/include/common.js'></script>
<script language='javascript'>
<!--
function updCmplt(ioru){
	var fm = document.form1;
	if(fm.mm_amt.value=="")			{	alert('매매대금을 입력해주세요');	return;	}
	else if(fm.ip_dt.value=="")	{	alert('입금일을 입력해주세요');		return;	}
	else if(fm.conv_dt.value=="")	{	alert('명의이전일을 입력해주세요');	return;	}

	if(parent.document.reg_c.form1.h_c_id.value==""){
		alert("매각처정보를 먼저 입력해 주세요!");
		return;
	}else{
		fm.client_id.value = parent.document.reg_c.form1.h_c_id.value;
	}
	
	if(ioru=="i"){
		if(!confirm('등록 하시겠습니까?')){ return; }
	}else if(ioru=="u"){
		if(!confirm('수정 하시겠습니까?')){ return; }
	}
	fm.gubun.value = ioru;	
	//fm.target = "i_no";
	fm.action = "/acar/off_ls_cmplt/off_ls_cmplt_updCmplt.jsp";
	fm.submit();
}

function view_file(){
	var map_path = document.form1.s_lpgfile.value;
	var size = 'width=700, height=650, scrollbars=yes';
	window.open("https://fms3.amazoncar.co.kr/data/actn/"+map_path+".pdf", "SCAN", "left=50, top=30,"+size+", resizable=yes");
}

function drop_file(){
	document.form1.s_lpgfile_del.value = '1';
}
function ChangeAmt(){
		var theForm = document.form1;
		theForm.mm_amt.value = parseDecimal(parseDigit(theForm.nak_pr.value) 
						- (
							toInt(parseDigit(theForm.chul_su.value))
							+ toInt(parseDigit(theForm.nak_su.value))
							+ toInt(parseDigit(theForm.tak_su.value))
						  ));
}
-->
</script>
<link rel=stylesheet type="text/css" href="file:///C|/inetpub/wwwroot/include/table.css">
</head>
<body>
<form name='form1' action='' method='post' enctype='multipart/form-data'>
<input type='hidden' name='auth_rw' value='<%=auth_rw%>'>
<input type="hidden" name="car_mng_id" value="<%= car_mng_id %>">
<input type="hidden" name="gubun" value="">
<input type="hidden" name="client_id" value="<%= cmplt.getClient_id() %>">
<input type='hidden' name='s_lpgfile' value='<%=cmplt.getLpgfile()%>'>
<input type='hidden' name='s_lpgfile_del' value=''>
  <table border=0 cellspacing=0 cellpadding=0 width='800'>
    <tr> 
      <td align='left'><< 매매정보 >></td>
      <td align='right'><%if(auth_rw.equals("3") || auth_rw.equals("4") || auth_rw.equals("6")){%> 
	  <% if(cmplt.getClient_id().equals("")){ %> <a href="javascript:updCmplt('i')">
	  		<img src="/images/reg.gif" width="50" height="18" align="absmiddle" border="0" alt="등록"></a> 
        <% }else{ %> <a href="javascript:updCmplt('u')">
			<img src="/images/update.gif" width="50" height="18" align="absmiddle" border="0" alt="수정"></a> 
        <% } %> <% } %></td>
    </tr>
    <tr> 
      <td colspan="2" class='line'> <table border="0" cellspacing="1" cellpadding='0' width=800>
          <tr> 
            <td class='title'>낙찰금액</td>
            <td width="112">&nbsp; <input type='text' size='10' name='nak_pr' value="<%= AddUtil.parseDecimal(olaD.getPer_talk_nak_pr(car_mng_id)) %>" maxlength='10' class='num' onBlur='javascript:this.value=parseDecimal(this.value)'> 
            </td>
            <td width="100" class="title" >출품수수료</td>
            <td width="95">&nbsp; <input type='text' size='10' name='chul_su' value="<%= AddUtil.parseDecimal(cmplt.getChul_su()) %>" maxlength='10' class='num' onBlur='javascript:this.value=parseDecimal(this.value)' onChange="javascript:ChangeAmt()"></td>
            <td class='title' width="89"> 낙찰수수료</td>
            <td width="116"> &nbsp; <input type='text' size='10' name='nak_su' value="<%= AddUtil.parseDecimal(cmplt.getNak_su()) %>" maxlength='10' class='num' onBlur='javascript:this.value=parseDecimal(this.value)' onChange="javascript:ChangeAmt()"> 
            </td>
            <td class='title' width="95"> 탁송수수료</td>
            <td width="93">&nbsp; <input type='text' size='10' name='tak_su' value="<%= AddUtil.parseDecimal(cmplt.getTak_su()) %>" maxlength='10' class='num' onBlur='javascript:this.value=parseDecimal(this.value)' onChange="javascript:ChangeAmt()"> 
            </td>
          </tr>
          <tr> 
            <td class='title' width="91">매매대금</td>
            <td> &nbsp; <input type='text' size='10' name='mm_amt' value="<%= AddUtil.parseDecimal(cmplt.getMm_amt()) %>" maxlength='10' class='num' onBlur='javascript:this.value=parseDecimal(this.value)'> 
            </td>
            <td class='title' >입금일</td>
            <td colspan="5">&nbsp; <input type='text' size='12' name='ip_dt' value="<%= AddUtil.ChangeDate2(cmplt.getIp_dt()) %>" maxlength='12' class='text' onBlur='javascript:this.value=ChangeDate(this.value)'> 
            </td>
          </tr>
          <tr> 
            <td colspan="8"><< 명의이전 >></td>
          </tr>
          <tr> 
            <td class='title'>이전일자</td>
            <td>&nbsp; <input type='text' size='12' name='conv_dt' value="<%= AddUtil.ChangeDate2(cmplt.getConv_dt()) %>" maxlength='12' class='text' onBlur='javascript:this.value=ChangeDate(this.value)'></td>
            <td class='title'>LPG서류스캔</td>
            <td colspan="5">&nbsp;
              <input type="file" name="filename" value='S' size="25"> &nbsp; <%if(!cmplt.getLpgfile().equals("")){%> <input type="button" name="b_map2" value="보기" onClick="javascript:view_file();"> 
              &nbsp;&nbsp; <%if(auth_rw.equals("3") || auth_rw.equals("4") || auth_rw.equals("6"))%> <input type="button" name="b_map4" value="삭제" onClick="javascript:drop_file();"> 
              <%}%> </td>
          </tr>
        </table></td>
    </tr>
  </table>
</form>
<iframe src="about:blank" name="i_no" width="0" height="0" frameborder="0" noresize></iframe>
</body>
</html>
