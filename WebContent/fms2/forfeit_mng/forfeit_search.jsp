<%@ page language="java" contentType="text/html;charset=euc-kr" %>
<%@ page import="java.util.*, acar.util.*, acar.admin.*, acar.forfeit_mng.*" %>
<%@ include file="/acar/cookies.jsp" %>
<%@ include file="/acar/access_log.jsp" %>

<%
	String auth_rw 	= request.getParameter("auth_rw")==null?"":request.getParameter("auth_rw");
	String br_id 	= request.getParameter("br_id")==null?"":request.getParameter("br_id");
	String user_id 	= request.getParameter("user_id")==null?"":request.getParameter("user_id");
	
	String table 	= request.getParameter("table")==null?"":request.getParameter("table");
	
	String vio_dt 	= request.getParameter("vio_dt")==null?"":request.getParameter("vio_dt");
	String vio_pla1 = request.getParameter("vio_pla1")==null?"":request.getParameter("vio_pla1");
	String vio_pla2 = request.getParameter("vio_pla2")==null?"":request.getParameter("vio_pla2");
	String vio_pla3 = request.getParameter("vio_pla3")==null?"":request.getParameter("vio_pla3");
	String paid_amt = request.getParameter("paid_amt")==null?"":request.getParameter("paid_amt");
	
	String t_wd = vio_dt+""+vio_pla1+""+vio_pla2+""+vio_pla3+""+paid_amt;
	
	AddForfeitDatabase 	a_fdb 	= AddForfeitDatabase.getInstance();
%>

<html>
<head><title>FMS</title>
<script language='javascript'>
<!--
	function search()
	{
		var fm = document.form1;
		fm.action = 'forfeit_search.jsp';
		fm.target = 'd_content';
		fm.submit();
	}
	
	function enter() 
	{
		var keyValue = event.keyCode;
		if (keyValue =='13') search();
	}	
//-->
</script>
<meta http-equiv="content-type" content="text/html; charset=euc-kr">
<%@ include file="/acar/getNaviCookies.jsp" %>
<link rel=stylesheet type="text/css" href="/include/table_t.css">
</head>
<body>

<form name='form1' action='' method='post'>
  <input type='hidden' name='auth_rw' value='<%=auth_rw%>'>
  <input type='hidden' name='br_id' value='<%=br_id%>'>
  <input type='hidden' name='user_id' value='<%=user_id%>'>
  <table border="0" cellspacing="0" cellpadding="0" width=100%>
	<tr>
      <td colspan=2>
        <table width=100% border=0 cellpadding=0 cellspacing=0>
          <tr>
            <td width=7><img src=/acar/images/center/menu_bar_1.gif width=7 height=33></td>
            <td class=bar>&nbsp;&nbsp;&nbsp;<img src=/acar/images/center/menu_bar_dot.gif width=4 height=5 align=absmiddle>&nbsp;<span class=style1>과태료관리 > <span class=style5>과태료 조회</span></span></td>
            <td width=7><img src=/acar/images/center/menu_bar_2.gif width=7 height=33></td>
          </tr>
        </table>
      </td>
    </tr>
	<tr>
	  <td colspan="2" class=h></td>
	</tr>
	<tr>
	  <td colspan="2">&nbsp;</td>
	</tr>	
	<tr>
	  <td colspan="2"><img src=/acar/images/center/icon_arrow.gif align=absmiddle> <span class=style2>과태료 조회</span></td>
	</tr>	
	<tR>
	    <td colspan=2 class=line2></td>
	</tr>	
    <tr>
      <td colspan="2" class=line>
	    <table border="0" cellspacing="1" cellpadding='0' width=100%>
          <tr>
            <td class=title width=10%>위반일자</td>
            <td width=90%>&nbsp;
		      <input type="text" name="vio_dt" value="<%=vio_dt%>" size="11" class=text>
			  (-빼고)
		    </td>
          </tr>
          <tr>
            <td class=title width=10%>위반장소</td>
            <td width=90%>&nbsp;[키워드]
		      <input type="text" name="vio_pla1" value="<%=vio_pla1%>" size="10" class=text> +
			  <input type="text" name="vio_pla2" value="<%=vio_pla2%>" size="10" class=text> +
			  <input type="text" name="vio_pla3" value="<%=vio_pla3%>" size="10" class=text>
		    </td>
          </tr>
          <tr>
            <td class=title width=10%>금액</td>
            <td width=90%>&nbsp;
		      <input type="text" name="paid_amt" value="<%=paid_amt%>" size="11" class=text>원
			  (,빼고)
		    </td>
          </tr>		  
        </table>
	  </td>
    </tr>  
    <tr align="right">
      <td colspan="2"><a href="javascript:search()" onMouseOver="window.status=''; return true" onfocus="this.blur()"><img src=/acar/images/center/button_search.gif border=0 align=absmiddle></a></td>
    </tr>	
	<tr>
        <td></td>
    </tr>	
	<tr>
	  <td colspan="2" style='background-color:e2e2e2; height:1;'></td>
	</tr>			
	<tr>
	  <td colspan="2">&nbsp;</td>
	</tr>		
	<tR>
	    <td colspan=2 class=line2></td>
	</tr>
	<tr>
	  <td colspan="2" class='line'>
		<table border="0" cellspacing="1" cellpadding="0" width='100%'>
		  <tr>
			<td width="3%" class="title">연번</td>
			<td width="20%" class="title">상호</td>			
			<td width="10%" class="title">차량번호</td>
			<td width="14%" class="title">고지번호</td>
			<td width="13%" class="title">위반일시</td>			
			<td width="20%" class="title">위반장소</td>
			<td width="10%" class="title">위반내용</td>
			<td width="10%" class="title">금액</td>						
		  </tr>
	<%		if(!t_wd.equals("")){
				Vector vt = a_fdb.getForfeitSearchList(vio_dt, vio_pla1, vio_pla2, vio_pla3, paid_amt);
				int vt_size = vt.size();
				for (int i = 0 ; i < vt_size ; i++){
					Hashtable ht = (Hashtable)vt.elementAt(i);	%>		  
		  <tr>
			<td align="center"><%=i+1%></td>
			<td align="center"><%=ht.get("FIRM_NM")%>&nbsp;<b>(<%=ht.get("VEN_CODE")%>)</b></td>
			<td align="center"><%=ht.get("CAR_NO")%></td>			
			<td align="center"><%=ht.get("PAID_NO")%></td>
			<td align="center"><%=AddUtil.ChangeDate3(String.valueOf(ht.get("VIO_DT")))%></td>			
			<td align="center"><%=ht.get("VIO_PLA")%></td>
			<td align="center"><%=ht.get("VIO_CONT")%></td>
			<td align="right"><%=AddUtil.parseDecimal2(String.valueOf(ht.get("PAID_AMT")))%>원&nbsp;</td>						
		  </tr>
		  <%	}
		  	}%>
		  <tr>
			<td colspan='8' align="center">검색한 데이타가 없습니다.</td>
		  </tr>			
		</table>
	  </td>
	</tr>
  </table>
</form>
<script language='javascript'>
<!--
//-->
</script>
<iframe src="about:blank" name="i_no" width="0" height="0" frameborder="0" noresize></iframe>
</body>
</html>
