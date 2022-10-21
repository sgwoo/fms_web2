<%@ page language="java" contentType="text/html;charset=euc-kr" %>
<%@ page import="java.util.*, acar.util.*, tax.*"%>
<jsp:useBean id="ScdMngDb" scope="page" class="tax.ScdMngDatabase"/>
<%@ include file="/tax/cookies_base.jsp" %>

<%
	String go_url = request.getParameter("go_url")==null?"":request.getParameter("go_url");
	
	Vector vt = ScdMngDb.getTaxCngList(s_br, s_kd, t_wd);
	int vt_size = vt.size();
%> 

<html>
<head>
<title>FMS</title>
<meta http-equiv="Content-Type" content="text/html; charset=euc-kr ">
<link rel=stylesheet type="text/css" href="../../include/table.css">
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
	function Disp(tax_no, rent_l_cd, client_id){
		var fm = document.form1;
		opener.parent.c_foot.location.href = "<%=go_url%>?tax_no="+tax_no+"&rent_l_cd="+rent_l_cd+"&client_id="+client_id;		
		self.close();
	}
//-->
</script>
</head>

<body>
<form name='form1' method='post' action='s_cont.jsp'>
  <input type='hidden' name="s_width" value="<%=s_width%>">   
  <input type='hidden' name="s_height" value="<%=s_height%>">     
  <input type='hidden' name="sh_height" value="<%=sh_height%>">   
  <input type='hidden' name='auth_rw' value='<%=auth_rw%>'>
  <input type='hidden' name='br_id' value='<%=br_id%>'>
  <input type='hidden' name='user_id' value='<%=user_id%>'>    
  <input type="hidden" name="idx" value="<%=idx%>">
 <input type='hidden' name='go_url' value='<%=go_url%>'> 
  <table width="750" border="0" cellspacing="0" cellpadding="0">
    <tr> 
      <td>검색조건: 
        <select name='s_kd'>
          <option value="1" <%if(s_kd.equals("1")){%> selected <%}%>>일련번호</option>
          <option value="2" <%if(s_kd.equals("2")){%> selected <%}%>>상호</option>
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
        <table border="0" cellspacing="1" width=750>
          <tr> 
            <td class=title width="30">연번</td>
            <td class=title width="70">일련번호</td>
            <td class=title width="90">계약번호</td>
            <td class=title width="100">상호</td>
            <td class=title width="60">발행구분</td>			
            <td class=title width="70">작성일자</td>
            <td class=title width="80">품목</td>			
            <td class=title width="70">합계</td>
            <td class=title width="180">비고</td>
          </tr>
          <%for (int i = 0 ; i < vt_size ; i++){
				Hashtable ht = (Hashtable)vt.elementAt(i);%>
          <tr> 
            <td align="center"><%=i+1%></td>
            <td align="center"><a href="javascript:Disp('<%=ht.get("TAX_NO")%>', '<%=ht.get("RENT_L_CD")%>', '<%=ht.get("CLIENT_ID")%>')" onMouseOver="window.status=''; return true"><%=ht.get("TAX_NO")%></a></td>
            <td align="center"><%=ht.get("RENT_L_CD")%></td>
            <td align="center"><span title='<%=ht.get("FIRM_NM")%>'><%=AddUtil.subData(String.valueOf(ht.get("FIRM_NM")), 6)%></span></td>
            <td align="center">
			<%if(String.valueOf(ht.get("UNITY_CHK")).equals("0")){%>개별발행
			<%}else{%>통합발행<%}%>
			</td>
            <td align="center"><%=AddUtil.ChangeDate2(String.valueOf(ht.get("TAX_DT")))%></td>
            <td align="center"><%=ht.get("TAX_G")%></td>
            <td align="right"><%=Util.parseDecimal(String.valueOf(ht.get("TAX_AMT")))%>원</td>
            <td>&nbsp;<span title='<%=ht.get("TAX_BIGO")%>'><%=AddUtil.subData(String.valueOf(ht.get("TAX_BIGO")), 15)%></span></td>															
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