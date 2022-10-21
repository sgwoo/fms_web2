<%@ page language="java" contentType="application/vnd.ms-excel; charset=euc-kr" %>
<%@ page import="java.io.*, java.util.*, java.text.*, acar.util.*, java.text.*, java.util.*,jxl.*"%>
<%@ page import="acar.common.*" %>
<jsp:useBean id="olyD" class="acar.offls_pre.Offls_preDatabase" scope="page"/>
<jsp:useBean id="olaD" class="acar.offls_actn.Offls_actnDatabase" scope="page"/>
<%@ include file="/acar/cookies.jsp" %>
<%
	String auth_rw = request.getParameter("auth_rw")==null?"":request.getParameter("auth_rw");
	String[] pre = request.getParameterValues("pr");
	String c_id = "";
	
	CommonDataBase c_db = CommonDataBase.getInstance();
	
	Date d = new Date();
	
   	SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd");
   	//System.out.println("현재날짜 : "+ sdf.format(d));
   	String filename = sdf.format(d)+"_매각대상차량리스트.xls";
   	filename = java.net.URLEncoder.encode(filename, "UTF-8");
   	response.setContentType("application/octer-stream");
   	response.setHeader("Content-Transper-Encoding", "binary");
   	response.setHeader("Content-Disposition","attachment;filename=\"" + filename + "\"");
   	response.setHeader("Content-Description", "JSP Generated Data");
%>

<html>
<head><title>FMS</title>
<meta http-equiv="Content-Type" content="text/html; charset=euc-kr">
<script language='JavaScript' src='/include/common.js'></script>

</head>

<body leftmargin="15" topmargin="1"  face="바탕">

<table border="0" cellspacing="0" cellpadding="0" width='1000'>

    <tr> 
      <td width="100%" height="30" align="center" style="font-size : 12pt;"><font face="바탕"><b>경매 매각대상 리스트</b> </font></td>
    </tr>
    
     <tr>
     <td align='center'> 
	    <table width="100%" border="1" cellspacing="1" cellpadding="0">
		    <tr align="center">
		          <td   width="4%" height="25" style="font-size : 10pt;"><font face="바탕">NO</font></td>
		          <td   width="12%" height="25" style="font-size : 10pt;"><font face="바탕">차량번호</font></td>
			      <td   width="24%" height="25" style="font-size : 10pt;"><font face="바탕">차명</font></td>
			      <td   width="10%" height="25" style="font-size : 10pt;"><font face="바탕">관리번호</font></td>	
			      <td   width="10%" height="25" style="font-size : 10pt;"><font face="바탕">차대번호</font></td>	
			      <td   width="24%" height="25" style="font-size : 10pt;"><font face="바탕">경매장</font></td>			
			      <td   width="16%" height="25" style="font-size : 10pt;"><font face="바탕">본거지</font></td>	 
		   </tr>
        </table>
      </td>
    </tr>  
    
    <tr>
     <td  align='center'>
     	<table width="100%" border="1" cellspacing="1" cellpadding="0">       
        	<%
			for(int i=0; i<pre.length; i++){
				pre[i] = pre[i].substring(0,6);
				c_id = pre[i];
				
			Hashtable ht = olyD.getSearch_list(c_id);
			%>
			
          <tr  height="25"  align="center">
            <td  width="4%" height="30" bgcolor="#FFFFFF" style="font-size : 9pt;"><font face="바탕"><%=i+1%></font></td>
            <td  width="12%" style="font-size : 9pt;"><font face="바탕"</font><%=ht.get("CAR_NO")%></td>
            <td  width="24%" style="font-size : 9pt;" align=left><font face="바탕"></font><%=ht.get("CAR_NM")%>&nbsp;</td>    
            <td  width="10%" style="font-size : 9pt;"><font face="바탕"></font><%=ht.get("CAR_DOC_NO")%></td> 
            <td  width="10%" style="font-size : 9pt;" ><font face="바탕"</font><%=ht.get("CAR_NUM")%></td>
            <td  width="24%" style="font-size : 9pt;" align=left><font face="바탕"><%=olaD.getActn_nm(String.valueOf(ht.get("ACTN_ID") ) ) %></font></td>
            <td  width="16%" style="font-size : 9pt;" ><font face="바탕"><%=c_db.getNameByIdCode("0032", "", String.valueOf(ht.get("CAR_EXT")) )%></font></td> 
   		  </tr>
			<%}%>
		</table>
	 </td>
	</tr>
</table>

</body>

</html>

