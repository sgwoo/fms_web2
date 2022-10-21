<%@ page language="java" contentType="text/html;charset=euc-kr" %>
<%@ page import="java.util.*, acar.util.*, acar.condition.*,  acar.user_mng.*"%>

<%@ include file="/acar/cookies.jsp" %>
<%@ include file="/acar/access_log.jsp" %>


<%
	String auth_rw = request.getParameter("auth_rw")==null?"":request.getParameter("auth_rw"); //권한
	String user_id = request.getParameter("user_id")==null?"":request.getParameter("user_id");//로그인-ID
	String br_id = request.getParameter("br_id")==null?"":request.getParameter("br_id");//로그인-영업소
	
	ConditionDatabase cdb = ConditionDatabase.getInstance();
		
	//로그인ID&영업소ID
	LoginBean login = LoginBean.getInstance();
	if(user_id.equals("")) 	user_id = login.getCookieValue(request, "acar_id");
	if(br_id.equals(""))	br_id = login.getCookieValue(request, "acar_br");

	Vector vt = cdb.getFeeEndEstList();
	int vt_size = vt.size();
	
	long tot_cnt =0;
	
%>

<html>
<head>
<title>FMS</title>
<meta http-equiv="Content-Type" content="text/html; charset=euc-kr">
<%@ include file="/acar/getNaviCookies.jsp" %>
<link rel=stylesheet type="text/css" href="/include/table_t.css">
<script language='JavaScript' src='/include/common.js'></script>
<script language="JavaScript">
<!--
		
	//팝업윈도우 열기
	function MM_openBrWindow(theURL,winName,features) { //v2.0
		window.open(theURL,winName,features);
	}		

	
//-->
</script>
<link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/4.7.0/css/font-awesome.min.css">

</head>

<body>

<form name='form1' method='post'>
<input type='hidden' name='auth_rw' value='<%=auth_rw%>'>
<input type='hidden' name='user_id' value='<%=user_id%>'>
<input type='hidden' name='br_id' value='<%=br_id%>'>


<div class="navigation" style="margin-bottom:0px !important">
	<span class="style1"></span>
</div>

<table width="1200" border="0" cellspacing="0" cellpadding="0">

   
    <tr>
        <td class=h></td>
    </tr>
    
    <tr>
        <td class=h></td>
    </tr>
    
    <tr>
        <td class=line2></td>
    </tr>
    <tr> 
        <td class="line"> 
            <table width="100%" border="0" cellspacing="1" cellpadding="0">
                <tr> 
                    <td width=8%  class="title">년도</td>
                     <td width=8%  class="title">계</td>  
                     <%for(int j = 1 ; j <= 12 ; j++){%>
           			 <td width=7% class=title><%=j%>월</td>
					  <%}%>
					  
                </tr>
      <%	for (int i = 0 ; i < vt_size ; i++){
                   tot_cnt = 0;
						Hashtable ht = (Hashtable)vt.elementAt(i); 				
							
		             for(int j = 1 ; j <= 12 ; j++){ 
		             
		            tot_cnt +=AddUtil.parseLong(String.valueOf(ht.get("CNT"+(j))));
		             
		             }%>				              
                <tr>
                  <td width=8% align="center"><%=ht.get("YY")%></td>
                  <td width=8% align="right"><%=AddUtil.parseDecimalLong(tot_cnt)%></td>
                 <%for(int j = 1 ; j <= 12 ; j++){ %>
                  <td width=7% align="right" ><%=AddUtil.parseDecimalLong(String.valueOf(ht.get("CNT"+(j))))%></td>
               <%   } %>                
                </tr>
                 
       <% } %>         
               </table>
            </td>               
       </tr>  	
   
</table>
</form>

</body>
</html>

