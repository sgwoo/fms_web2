<%@ page language="java" contentType="text/html;charset=euc-kr" %>
<%@ page import="java.util.*, acar.util.*, tax.*"%>
<jsp:useBean id="ScdMngDb" scope="page" class="tax.ScdMngDatabase"/>
<%@ include file="/tax/cookies_base.jsp" %>

<%
	
	
//  ����ڹ�ȣ,�ֹι�ȣ�� '-' ����
	if(s_kd.equals("4")) t_wd = AddUtil.replace(t_wd, "-", "");

	Vector vts = ScdMngDb.getTaxMngList(s_br, chk1, chk2, chk3, chk4, chk5, chk6, gubun1, gubun2, gubun3, gubun4, st_dt, end_dt, s_kd, t_wd1, t_wd2, sort, asc);
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
<body>
<form name='form1' action='' method='post' target='d_content'>
<%@ include file="/include/search_hidden.jsp" %>
<input type='hidden' name='vt_size' value='<%=vt_size%>'>
  <table border="0" cellspacing="0" cellpadding="0" width='100%'>
    <tr id='tr_title' style='position:relative;z-index:1'>
	    <td class='line' width='100%' id='td_title' style='position:relative;'> 
	      <table border="0" cellspacing="1" cellpadding="0" width='100%'>
	      	<tr><td class=line2></td></tr>
            <tr> 
            <td width='5%' class='title'>����</td>
            <td width='8%' class='title'>�Ϸù�ȣ</td>
            <td width='18%' class='title'>��ȣ</td>
            <td width='12%' class='title'>����ڹ�ȣ</td>
            <td width='8%' class='title'>��������</td>
            <td width='11%' class='title'>�׸�</td>
            <td width='8%' class='title'>���ް�</td>
            <td width='8%' class='title'>�ΰ���</td>
            <td width='8%' class='title'>�ۼ�����</td>
            <td width='8%' class='title'>�������</td>
            <td width='6%' class='title'>����</td>
          </tr>
        </table>
      </td>
    </tr>
    <tr>
	    <td class='line' width='100%' id='td_con' style='position:relative;'> 
	      <table border="0" cellspacing="1" cellpadding="0" width='100%'>		  
<%	if(vt_size > 0){%>		  
          <%for(int i = 0 ; i < vt_size ; i++){
				      Hashtable ht = (Hashtable)vts.elementAt(i);%>
          <tr> 
            <td <%if(String.valueOf(ht.get("TAX_ST")).equals("M"))out.println("class='is'");%> width='5%' align='center'><%=i+1%></td>
            <td <%if(String.valueOf(ht.get("TAX_ST")).equals("M"))out.println("class='is'");%> width='8%' align='center'><%=ht.get("TAX_NO")%></td>
            <td <%if(String.valueOf(ht.get("TAX_ST")).equals("M"))out.println("class='is'");%> width='18%' align='center'><span title='<%=ht.get("FIRM_NM")%>'><%=AddUtil.subData(String.valueOf(ht.get("FIRM_NM")), 10)%></span></td>			
            <td <%if(String.valueOf(ht.get("TAX_ST")).equals("M"))out.println("class='is'");%> width='12%' align='center'>
			      <%if(String.valueOf(ht.get("ENP_NO")).equals("")){%>
			      <%=AddUtil.ChangeSsn(AddUtil.ChangeSsn(String.valueOf(ht.get("SSN"))))%>
			      <%}else{%>
			      <%=AddUtil.ChangeSsn(AddUtil.ChangeEnp(String.valueOf(ht.get("ENP_NO"))))%>
			      <%}%>			
			      </td>
            <td <%if(String.valueOf(ht.get("TAX_ST")).equals("M"))out.println("class='is'");%> width='8%' align='center'><%=AddUtil.ChangeDate2(String.valueOf(ht.get("TAX_DT")))%></td>
            <td <%if(String.valueOf(ht.get("TAX_ST")).equals("M"))out.println("class='is'");%> width='11%' align="center"><span title='<%=ht.get("TAX_G")%>'><%=AddUtil.subData(String.valueOf(ht.get("TAX_G")), 6)%></span></td>
            <td <%if(String.valueOf(ht.get("TAX_ST")).equals("M"))out.println("class='is'");%> width='8%' align="right"><%=Util.parseDecimal(String.valueOf(ht.get("TAX_SUPPLY")))%>��</td>
            <td <%if(String.valueOf(ht.get("TAX_ST")).equals("M"))out.println("class='is'");%> width='8%' align="right"><%=Util.parseDecimal(String.valueOf(ht.get("TAX_VALUE")))%>��</td>
            <td <%if(String.valueOf(ht.get("TAX_ST")).equals("M"))out.println("class='is'");%> width='8%' align='center'><%=AddUtil.ChangeDate2(String.valueOf(ht.get("REG_DT")))%></td>
            <td <%if(String.valueOf(ht.get("TAX_ST")).equals("M"))out.println("class='is'");%> width='8%' align='center'><%=AddUtil.ChangeDate2(String.valueOf(ht.get("PRINT_DT")))%></td>
            <td <%if(String.valueOf(ht.get("TAX_ST")).equals("M"))out.println("class='is'");%> width='6%' align="center">
			      <%if(String.valueOf(ht.get("TAX_ST")).equals("M")){%>
			      �������
			      <%}else if(String.valueOf(ht.get("TAX_ST")).equals("C")){%>
			      <font color=red>�������</font>
			      <%}else{%>
            ����
			      <%}%>			            
            </td>												
          </tr>
          <%}%>		
<%	}else{%>                     
          <tr> 
            <td colspan="11" align='center'>��ϵ� ����Ÿ�� �����ϴ�</td>
          </tr>		  
<% 	}%>		    
        </table>
      </td>
    </tr>
  </table>
</form>
</body>
</html>
