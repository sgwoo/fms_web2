<%@ page language="java" contentType="text/html;charset=euc-kr" %>
<%@ page import="java.util.*, acar.util.*, card.*"%>
<jsp:useBean id="CardDb" scope="page" class="card.CardDatabase"/>
<%@ include file="/acar/cookies.jsp" %> 

<%
	String s_kd 		= request.getParameter("s_kd")==null?"":request.getParameter("s_kd");
	String t_wd 		= request.getParameter("t_wd")==null?"":request.getParameter("t_wd");
	String go_url 		= request.getParameter("go_url")==null?"":request.getParameter("go_url");
	String st 			= request.getParameter("st")==null?"":request.getParameter("st");
	String value 		= request.getParameter("value")==null?"":request.getParameter("value");
	String idx 			= request.getParameter("idx")==null?"":request.getParameter("idx");
	
	if(t_wd.equals("") && !value.equals("")) t_wd = value;
	
	t_wd = AddUtil.replace(t_wd,"카드","");
	
	
	//fms등록카드
	Vector vt = CardDb.getPurCards("1", "Y", t_wd, "");
	int vt_size = vt.size();
%> 

<html>
<head>
<title>FMS</title>
<meta http-equiv="Content-Type" content="text/html; charset=euc-kr ">
<link rel=stylesheet type="text/css" href="/include/table_t.css">
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
	
	function Disp(cardno, card_name){
		var fm = document.form1;
		<%if(go_url.equals("/fms2/pay_mng/pay_list_reg.jsp")){%>
		opener.form1.cardno.value 	= cardno;		
		<%}else{%>
		opener.form1.cardno<%=idx%>.value 	= cardno;
		opener.form1.trf_cont<%=idx%>.value = card_name;	
		opener.form1.trf_cont<%=idx%>.focus();
		<%}%>
		self.close();
	}
//-->
</script>
</head>

<body>
<form name='form1' method='post' action='s_cardno.jsp'>
  <input type='hidden' name='st' value='<%=st%>'>    
  <input type='hidden' name='value' value='<%=value%>'>      
  <input type="hidden" name="idx" value="<%=idx%>">
 <input type='hidden' name='go_url' value='<%=go_url%>'> 
  <table width="100%" border="0" cellspacing="0" cellpadding="0">
    <tr> 
      <td>카드종류 : 
        <input type="text" name="t_wd" value="<%=t_wd%>" size="15" class=text onKeyDown="javasript:enter()" style='IME-MODE: active'>
		&nbsp;&nbsp;
		<input type="button" name="b_ms2" value="검색" onClick="javascript:search();" class="btn">
      </td>
    </tr>		
    <tr> 
      <td class=line>
	    <table border="0" cellspacing="1" width=100%>
        <tr>
          <td class=title width="10%">연번</td>
          <td class=title width="40%">카드번호</td>
          <td class=title width="50%">카드이름</td>
        </tr>
        <%for (int i = 0 ; i < vt_size ; i++){
				Hashtable ht = (Hashtable)vt.elementAt(i);%>
        <tr align="center">
          <td><%=i+1%></td>
          <td><a href="javascript:Disp('<%=ht.get("CARDNO")%>','<%=ht.get("CARD_NAME")%>')" onMouseOver="window.status=''; return true"><%=ht.get("CARDNO")%></a></td>
          <td><%=ht.get("CARD_NAME")%></td>
        </tr>
        <%		}%>
      </table>
	  </td>
    </tr>	
    <tr> 
      <td align="center"><input type="button" name="b_ms2" value="닫기" onClick="javascript:window.close();" class="btn"></td>
    </tr>
  </table>
</form>
</body>
</html>