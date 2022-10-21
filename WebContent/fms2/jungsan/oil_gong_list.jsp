<%@ page language="java" contentType="text/html;charset=euc-kr"%>
<%@ page import="java.util.*, acar.util.*, acar.common.*"%>
<jsp:useBean id="JsDb" scope="page" class="card.JungSanDatabase"/>
<%@ include file="/acar/cookies.jsp" %>

<%

	String o_year = request.getParameter("o_year")==null?"":request.getParameter("o_year");
	String o_mon = request.getParameter("o_mon")==null?"":request.getParameter("o_mon");
	String bus_id = request.getParameter("bus_id")==null?"":request.getParameter("bus_id");
			
	Vector vt = JsDb.getOilGongList(o_year, o_mon, bus_id);
	int vt_size = vt.size();

	CommonDataBase c_db = CommonDataBase.getInstance();
%>

<html>
<head>
	<title>Untitled</title>
<meta http-equiv="Content-Type" content="text/html; charset=euc-kr">	
<link rel=stylesheet type="text/css" href="/include/table_t.css">	
<script language='JavaScript' src='/include/common.js'></script>
<script language='javascript'>
<!--

//-->	
</script>		
</head>

<body>

<form name='form1' method='post'>
<input type='hidden' name='auth_rw' value=''>
<input type='hidden' name='br_id' value=''>
<input type='hidden' name='user_id' value=''>
<input type='hidden' name='size' value='8'>

<table border="0" cellspacing="0" cellpadding="0" width=100%>
    <tr>
    	<td>
    	    <table width=100% border=0 cellpadding=0 cellspacing=0>
                <tr>
                    <td width=7><img src=/acar/images/center/menu_bar_1.gif width=7 height=33></td>
                    <td class=bar>&nbsp;&nbsp;&nbsp;<img src=/acar/images/center/menu_bar_dot.gif width=4 height=5 align=absmiddle>&nbsp;<span class=style1><%=c_db.getNameById(bus_id,"USER")%> 공제현황</span></td>
                    <td width=7><img src=/acar/images/center/menu_bar_2.gif width=7 height=33></td>
                </tr>
            </table>
    	</td>
    </tr>
     <tr>
        <td class=h></td>
    </tr>
 
    <tr>
        <td class=line2></td>
    </tr> 
    <tr> 
        <td  class='line'> 
            <table border="0" cellspacing="1" cellpadding="0" width=100%>
                <tr> 
                    <td width=5% class='title'>연번</td>
                    <td width=13% class='title'>년도</td>
                    <td width=13% class='title'>기수</td>               
                    <td width=25% class='title'>항목</td>               
                    <td width=10% class='title'>공제금액</td>
				
                </tr>			
<%				for (int i = 0 ; i < vt_size ; i++){
					Hashtable ht = (Hashtable)vt.elementAt(i);%>
                <tr> 
                    <td align="center"><%=i+1%></td>
                    <td align="center"><%=ht.get("C_YY")%></td>
                    <td align="center"><%=ht.get("C_MM")%></td>
                    <td align="center">
                    <% if ( String.valueOf(ht.get("GUBUN")).equals("5")) {%>
                    비용캠페인(1군-정비)
                    <%} else if ( String.valueOf(ht.get("GUBUN")).equals("2")) {%>       
                    영업캠페인
                      <%} else if ( String.valueOf(ht.get("GUBUN")).equals("1")) {%>       
                    채권캠페인
                       <%} else if ( String.valueOf(ht.get("GUBUN")).equals("29")) {%>       
                     비용캠페인(2군)
                         <%} else if ( String.valueOf(ht.get("GUBUN")).equals("28")) {%>       
                     비용캠페인(1군-사고) 
                       <%} else if ( String.valueOf(ht.get("GUBUN")).equals("6")) {%>       
                     제안캠페인
                    <%} %>                  
                    </td>                  		
                    <td align="right" ><%=Util.parseDecimal(String.valueOf(ht.get("AMT")))%>                        
                    </td>
              
                </tr>			
<%				}%>					
            </table>
        </td>
    </tr>		
			
</table>
</form>
</body>
</html>
