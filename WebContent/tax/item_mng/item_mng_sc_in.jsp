<%@ page language="java" contentType="text/html;charset=euc-kr" %>
<%@ page import="java.util.*, acar.util.*, tax.*"%>
<jsp:useBean id="ScdMngDb" scope="page" class="tax.ScdMngDatabase"/>
<%@ include file="/tax/cookies_base.jsp" %>

<%
	//  ����ڹ�ȣ,�ֹι�ȣ�� '-' ����
	if(s_kd.equals("4")) t_wd = AddUtil.replace(t_wd, "-", "");

	Vector vts = ScdMngDb.getItemMngList(s_br, chk1, chk2, chk3, chk4, gubun1, gubun2, gubun3, gubun4, st_dt, end_dt, s_kd, t_wd1, t_wd2, sort, asc);
	int vt_size = vts.size();
%>

<html>
<head><title>FMS</title>
<script language='JavaScript' src='/include/common.js'></script>
<script language='javascript'>
<!--
	/* Title ���� */
	function setupEvents()
	{
			window.onscroll = moveTitle ;
			window.onresize = moveTitle ; 
	}
	
	function moveTitle()
	{
	    var X ;
	    document.all.tr_title.style.pixelTop = document.body.scrollTop ;
	    document.all.td_title.style.pixelLeft = document.body.scrollLeft ; 
	    document.all.td_con.style.pixelLeft	= document.body.scrollLeft ;   	    
	    
	}
	function init() {
		
		setupEvents();
	}
	
	//�˾������� ����
	function MM_openBrWindow(theURL,winName,features) { //v2.0
		window.open(theURL,winName,features);
	}		
//-->
</script>
<meta http-equiv="content-type" content="text/html; charset=euc-kr">
<link rel=stylesheet type="text/css" href="/include/table_t.css">
</head>
<body onLoad="javascript:init()">
<form name='form1' action='' method='post' target='d_content'>
<%@ include file="/include/search_hidden.jsp" %>
<input type='hidden' name='vt_size' value='<%=vt_size%>'>
  <table border="0" cellspacing="0" cellpadding="0" width='1220'>
  	<tr><td class=line2 colspan=2></td></tr>
    <tr id='tr_title' style='position:relative;z-index:1'>
	    <td class='line' width='400' id='td_title' style='position:relative;'> 
	      <table border="0" cellspacing="1" cellpadding="0" width='100%'>
          <tr> 
          <td width='40' class='title'>����</td>
          <td width='100' class='title'>�Ϸù�ȣ</td>
          <td width='150' class='title'>��ȣ</td>
          <td width='110' class='title'>����ڹ�ȣ</td>
          </tr>
        </table>
      </td>
	    <td class='line' width='820'>
	      <table border="0" cellspacing="1" cellpadding="0" width='100%'>
          <tr> 
            <td width='80' class='title'>�ŷ�����</td>
            <td width='80' class='title'>������ȣ</td>
            <td width='150' class='title'>����</td>
            <td width='200' class='title'>�ŷ�����</td>
            <td width='80' class='title'>���ް�</td>
            <td width='70' class='title'>�ΰ���</td>
            <td width='80' class='title'>�հ�</td>
            <td width='80' class='title'>�ۼ�����</td>
          </tr>
        </table>
	    </td>
    </tr>
<%	if(vt_size > 0){%>
    <tr>
	    <td class='line' width='400' id='td_con' style='position:relative;'> 
	      <table border="0" cellspacing="1" cellpadding="0" width='100%'>
          <%for(int i = 0 ; i < vt_size ; i++){
				      Hashtable ht = (Hashtable)vts.elementAt(i);%>
          <tr> 
            <td <%if(String.valueOf(ht.get("TAX_ST")).equals("C") || String.valueOf(ht.get("USE_YN")).equals("N"))out.println("class='is'");%> width='40' align='center'><a name="<%=i+1%>"><%=i+1%></a></td>
            <td <%if(String.valueOf(ht.get("TAX_ST")).equals("C") || String.valueOf(ht.get("USE_YN")).equals("N"))out.println("class='is'");%> width='100' align='center'><a href="javascript:parent.view_tax('<%=ht.get("ITEM_ID")%>','<%=i+1%>')" onMouseOver="window.status=''; return true"><%=ht.get("ITEM_ID")%></a></td>
            <td <%if(String.valueOf(ht.get("TAX_ST")).equals("C") || String.valueOf(ht.get("USE_YN")).equals("N"))out.println("class='is'");%> width='150' align='center'><span title='<%=ht.get("RECCONAME")%>'><%=AddUtil.subData(String.valueOf(ht.get("RECCONAME")), 10)%></span></td>			
            <td <%if(String.valueOf(ht.get("TAX_ST")).equals("C") || String.valueOf(ht.get("USE_YN")).equals("N"))out.println("class='is'");%> width='110' align='center'><%=AddUtil.ChangeEnpH(String.valueOf(ht.get("RECCOREGNO")))%></td>
          </tr>
          <%}%>
        </table>
	    </td>
	    <td class='line' width='820'>
	      <table border="0" cellspacing="1" cellpadding="0" width='100%'>
          <%for(int i = 0 ; i < vt_size ; i++){
				      Hashtable ht = (Hashtable)vts.elementAt(i);%>
          <tr> 
            <td <%if(String.valueOf(ht.get("TAX_ST")).equals("C") || String.valueOf(ht.get("USE_YN")).equals("N"))out.println("class='is'");%> width='80' align='center'><%=AddUtil.ChangeDate2(String.valueOf(ht.get("ITEM_DT")))%></td>
            <td <%if(String.valueOf(ht.get("TAX_ST")).equals("C") || String.valueOf(ht.get("USE_YN")).equals("N"))out.println("class='is'");%> width='80' align="center"><%=ht.get("ITEM_CAR_NO")%></td>
            <td <%if(String.valueOf(ht.get("TAX_ST")).equals("C") || String.valueOf(ht.get("USE_YN")).equals("N"))out.println("class='is'");%> width='150' align="center"><span title='<%=ht.get("ITEM_CAR_NM")%>'><%=AddUtil.subData(String.valueOf(ht.get("ITEM_CAR_NM")), 10)%></span></td>
            <td <%if(String.valueOf(ht.get("TAX_ST")).equals("C") || String.valueOf(ht.get("USE_YN")).equals("N"))out.println("class='is'");%> width='200' align="center">
			  <%if(String.valueOf(ht.get("USE_YN")).equals("N"))out.println("<font color=red>[���]</font>");%>
			  <%if(!String.valueOf(ht.get("DOCTYPE")).equals(""))out.println("<font color=orange>[����]</font>");%>
			  <span title='<%=ht.get("ITEM_G")%>'><%=AddUtil.subData(String.valueOf(ht.get("ITEM_G")), 10)%></span>
			  <%if(AddUtil.parseInt(String.valueOf(ht.get("REG_DT2"))) >= 20100929 && String.valueOf(ht.get("GUBUN")).equals("1") && !String.valueOf(ht.get("TM")).equals("")){%>
			  (<%=ht.get("TM")%>ȸ��)
			  <%}%>			  			
			</td>            
            <td <%if(String.valueOf(ht.get("TAX_ST")).equals("C") || String.valueOf(ht.get("USE_YN")).equals("N"))out.println("class='is'");%> width='80' align="right"><%=Util.parseDecimal(String.valueOf(ht.get("ITEM_SUPPLY")))%>��</td>
            <td <%if(String.valueOf(ht.get("TAX_ST")).equals("C") || String.valueOf(ht.get("USE_YN")).equals("N"))out.println("class='is'");%> width='70' align="right"><%=Util.parseDecimal(String.valueOf(ht.get("ITEM_VALUE")))%>��</td>
            <td <%if(String.valueOf(ht.get("TAX_ST")).equals("C") || String.valueOf(ht.get("USE_YN")).equals("N"))out.println("class='is'");%> width='80' align="right"><%=Util.parseDecimal(String.valueOf(ht.get("ITEM_AMT")))%>��</td>
            <td <%if(String.valueOf(ht.get("TAX_ST")).equals("C") || String.valueOf(ht.get("USE_YN")).equals("N"))out.println("class='is'");%> width='80' align='center'><%=AddUtil.ChangeDate2(String.valueOf(ht.get("REG_DT")))%></td>
          </tr>
          <%}%>
        </table>
	    </td>
    </tr>
<%	}else{%>                     
    <tr>
	    <td class='line' width='400' id='td_con' style='position:relative;'> 
	      <table border="0" cellspacing="1" cellpadding="0" width='100%'>
          <tr> 
            <td align='center'>��ϵ� ����Ÿ�� �����ϴ�</td>
          </tr>
        </table>
      </td>
	    <td class='line' width='820'>
	      <table border="0" cellspacing="1" cellpadding="0" width='100%'>
          <tr>
		        <td>&nbsp;</td>
	        </tr>
	      </table>
	    </td>
    </tr>
<% 	}%>
  </table>
</form>
</body>
</html>
