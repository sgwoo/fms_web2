<%@ page language="java" contentType="text/html;charset=euc-kr" %>
<%@ page import="java.util.*, acar.util.*, acar.accid.*, tax.*"%>
<jsp:useBean id="ClientMngDb" scope="page" class="tax.ClientMngDatabase"/>
<%@ include file="/tax/cookies_base.jsp" %>

<%
	String go_url = request.getParameter("go_url")==null?"":request.getParameter("go_url");
	
	Vector accids = ClientMngDb.getClientSiteSearch(s_kd, t_wd);
	int accid_size = accids.size();
%> 

<html>
<head>
<title>FMS</title>
<meta http-equiv="Content-Type" content="text/html; charset=euc-kr ">
<link rel=stylesheet type="text/css" href="/include/table.css">
<script language='JavaScript' src='/include/common.js'></script>
<script language='javascript'>
<!--
	//검색하기
	function search(){
		var fm = document.form1;	
		if(fm.t_wd.value == ''){ alert('검색어를 입력하십시오.'); fm.t_wd.focus(); return; }	
		fm.submit();
	}
	function enter() {
		var keyValue = event.keyCode;
		if (keyValue =='13') search();
	}
	
	//계약선택
	function Disp(firm_nm, client_id, site_id){
		var fm = document.form1;
		
		if(fm.go_url.value == 'fee_scd_u_mkscd'){
			opener.document.form1.rtn_firm_nm[<%=idx%>].value 	= firm_nm;
			opener.document.form1.rtn_client_id[<%=idx%>].value 	= client_id;
			opener.document.form1.rtn_site_id[<%=idx%>].value 	= site_id;
		}
		self.close();
	}
//-->
</script>
</head>

<body>
<form name='form1' method='post' action='s_client_site.jsp'>
  <input type='hidden' name="s_width" value="<%=s_width%>">   
  <input type='hidden' name="s_height" value="<%=s_height%>">     
  <input type='hidden' name="sh_height" value="<%=sh_height%>">   
  <input type='hidden' name='auth_rw' value='<%=auth_rw%>'>
  <input type='hidden' name='br_id' value='<%=br_id%>'>
  <input type='hidden' name='user_id' value='<%=user_id%>'>    
  <input type="hidden" name="idx" value="<%=idx%>">
 <input type='hidden' name='go_url' value='<%=go_url%>'> 
  <table width="800" border="0" cellspacing="0" cellpadding="0">
    <tr> 
      <td>검색조건: 
        <select name='s_kd'>
          <option value='1' <%if(s_kd.equals("1"))%>selected<%%>>상호</option>
        </select>
        <input type="text" name="t_wd" value="<%=t_wd%>" size="15" class=text onKeyDown="javasript:enter()">
		<input type="button" name="b_ms2" value="검색" onClick="javascript:search();" class="btn">
      </td>
    </tr>
    <tr> 
      <td>&nbsp;</td>
    </tr>
    <tr> 
      <td class=line> 
        <table border="0" cellspacing="1" width=800>
          <tr> 
            <td class=title width="30">연번</td>
            <td class=title width="40">구분</td>
            <td class=title width="100">상호</td>
            <td class=title width="100">대표자</td>
            <td class=title width="100">사업자/생년월일</td>
            <td class=title>주소</td>
            <td class=title width="60">담당자</td>
            <td class=title width="100">이메일</td>						
          </tr>
          <%for (int i = 0 ; i < accid_size ; i++){
				Hashtable accid = (Hashtable)accids.elementAt(i);%>
          <tr align="center"> 
            <td><%=i+1%></td>
            <td><%=accid.get("GUBUN")%></td>
            <td><a href="javascript:Disp('<%=accid.get("FIRM_NM")%>', '<%=accid.get("CLIENT_ID")%>', '<%=accid.get("SITE_ID")%>')" onMouseOver="window.status=''; return true"><%=accid.get("FIRM_NM")%></a></td>
            <td><%=accid.get("CLIENT_NM")%></td>
            <td><%=AddUtil.ChangeEnpH(String.valueOf(accid.get("ENP_NO")))%></td>
            <td><%=accid.get("O_ADDR")%></td>
            <td><%=accid.get("CON_AGNT_NM")%></td>
            <td><%=accid.get("CON_AGNT_EMAIL")%></td>			
          </tr>
          <%		}%>
        </table>
      </td>
    </tr>
    <tr> 
      <td>&nbsp;</td>
    </tr>	
    <tr> 
      <td align="center"><input type="button" name="b_ms2" value="닫기" onClick="javascript:window.close();" class="btn"></td>
    </tr>
  </table>
</form>
</body>
</html>