<%@ page language="java" contentType="text/html;charset=euc-kr" %>
<%@ page import="java.util.*, acar.util.* "%>
<jsp:useBean id="CardDb" scope="page" class="card.CardDatabase"/>
<%@ include file="/acar/cookies.jsp" %>

<%
	
	String auth_rw = request.getParameter("auth_rw")==null?"":request.getParameter("auth_rw");
	String br_id = request.getParameter("br_id")==null?"":request.getParameter("br_id");
	String user_id = request.getParameter("user_id")==null?ck_acar_id:request.getParameter("user_id");
	String s_kd = request.getParameter("s_kd")==null?"1":request.getParameter("s_kd");
	String charge_dt = request.getParameter("charge_dt")==null?"":request.getParameter("charge_dt");
	String asc = request.getParameter("asc")==null?"0":request.getParameter("asc");
	
	int ip_size = 0;
	Vector ips = CardDb.getDemandList(charge_dt);

	ip_size = ips.size();	
%> 

<html>
<head>
<title>FMS</title>
<meta http-equiv="Content-Type" content="text/html; charset=euc-kr ">
<link rel=stylesheet type="text/css" href="/include/table_t.css">
<script language='JavaScript' src='/include/common.js'></script>
</head>

<body>
<form name='form1' method='post' >
<input type='hidden' name="s_width" value="<%=s_width%>">   
<input type='hidden' name="s_height" value="<%=s_height%>">     
<input type='hidden' name='auth_rw' value='<%=auth_rw%>'>
<input type='hidden' name='br_id' value='<%=br_id%>'>
<input type='hidden' name='user_id' value='<%=user_id%>'>    
<input type='hidden' name='ip_size' value='<%=ip_size%>'> 

<table width="100%" border="0" cellspacing="0" cellpadding="0">

	<tr>
		<td colspan=3  class=h></td>
	</tr>	
	    	
    <tr> 
        <td colspan=3 class=line2></td>
    </tr>
    <tr> 
        <td colspan=3 class=line> 
            <table border="0" cellspacing="1" width=100%>
                <tr>              
                    <td class=title width=5%>연번</td>                                
                    <td class=title width=15%>카드번호</td>
                    <td class=title width=12%>소유자</td>
                    <td class=title width=10%>승인일</td>   
                    <td class=title width=35%>사용처</td>   
                    <td class=title width=10%>금액</td>  
                    <td class=title width=10%></td>   
                                
                </tr>
          <%for (int i = 0 ; i < ip_size ; i++){
				Hashtable ht = (Hashtable)ips.elementAt(i);%>
                <tr style='height:25' >               
                    <td align="center"><%=i+1%></td>                    
                    <% if ( String.valueOf(ht.get("CARD_NAME")).equals("소계") || String.valueOf(ht.get("CARD_NAME")).equals("합계")  ) {%>    
                     <td align="center"><b><%=ht.get("CARDNO")%></b></td>
                      <td align="center"><b><%=ht.get("CARD_NAME")%></b></td>
                   <%} else  {%>
                      <td align="center"><%=ht.get("CARDNO")%></td>
                      <td align="center"><%=ht.get("CARD_NAME")%></td>
                    <% }  %>                   
                    <td align="center"><%=AddUtil.ChangeDate2(String.valueOf(ht.get("APPROVE_DATE")))%></td>
                    <td align="left"><%=ht.get("VENDOR_NAME")%></td>                    
                    <td align="right">
                    <% if ( String.valueOf(ht.get("CARD_NAME")).equals("소계") || String.valueOf(ht.get("CARD_NAME")).equals("합계")  ) {%>
                    <b><%=AddUtil.parseDecimalLong(String.valueOf(ht.get("AMT")))%></b>
                    <%} else  {%>
                    <%=AddUtil.parseDecimalLong(String.valueOf(ht.get("AMT")))%>
                    <% }  %></td>
                    <td align="center"></td>  
                </tr>
          <%	}%>
            </table>
        </td>
    </tr>
    <tr> 
        <td>&nbsp;</td>
    </tr>	
     <tr> 
        <td>&nbsp;</td>
    </tr>  
       
</table>
</form>
 	 	
<iframe src="about:blank" name="i_no" width="100" height="100"  frameborder="0" noresize> </iframe>
	 	 	  	
</body>
</html>