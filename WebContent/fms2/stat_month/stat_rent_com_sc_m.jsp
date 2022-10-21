<%@ page contentType="text/html; charset=euc-kr" %>
<%@ page language="java" %> 
<%@ page import="java.util.*, acar.util.*, acar.stat_bus.*, acar.common.*" %>
<jsp:useBean id="sb_db" scope="page" class="acar.stat_bus.StatBusDatabase"/>
<%@ include file="/acar/cookies.jsp" %>

<%
	CommonDataBase c_db = CommonDataBase.getInstance();

	String auth_rw 	= request.getParameter("auth_rw")==null?"":request.getParameter("auth_rw");
	String br_id 	= request.getParameter("br_id")==null?"":request.getParameter("br_id");
	String user_id 	= request.getParameter("user_id")==null?"":request.getParameter("user_id");
	
	String s_yy 	= request.getParameter("s_yy")==null?"":request.getParameter("s_yy");
	String s_mm 	= request.getParameter("s_mm")==null?"":request.getParameter("s_mm");
	String gubun 	= request.getParameter("gubun")==null?"":request.getParameter("gubun");
	
	int mons = 12;
	
	int h_cnt[]	 		= new int[mons+1];
	
	String s_st[] = new String[5];
	s_st[0] = "0001";
	s_st[1] = "0002";
	s_st[2] = "0003";
	s_st[3] = "0004";
	s_st[4] = "0005";
	
	Vector vt = sb_db.getStatComList(gubun, s_yy);
	int vt_size = vt.size();
%>
<html>
<head>
<meta http-equiv="content-type" content="text/html; charset=euc-kr">
<title>FMS</title>
<link rel="stylesheet" type="text/css" href="/include/table_t.css"></link>
<script language="JavaScript">
<!--
//-->
</script>
</head>
<body leftmargin="15">
<form name='form1' method='post'>
  <input type='hidden' name='auth_rw' 		value='<%=auth_rw%>'>
  <input type='hidden' name='br_id' 		value='<%=br_id%>'>
  <input type='hidden' name='user_id' 		value='<%=user_id%>'>
  <input type='hidden' name='s_yy' 		value='<%=s_yy%>'>
  <input type='hidden' name='s_mm' 		value='<%=s_mm%>'>
<table border=0 cellspacing=0 cellpadding=0 width=<%=120+70+(70*mons)%>>
    <%for (int k = 0 ; k < 5 ; k++){ %>
    <tr>
        <td><%=k+1%>. <%=c_db.getNameById(s_st[k],"CAR_COM")%></td>
    </tr>    
    <tr> 
        <td class=line> 
            <table width=100% border="0" cellspacing="1" cellpadding="0">            
                <tr align="center"> 
                    <td width=120 class=title>구분</td>
                    <td width=70 class=title>합계</td>
		            <%for (int j = 0 ; j < mons ; j++){%>
                    <td width=70 class=title><%=j+1%>월</td>
		            <%}%>
		            <td width=70 class=title>점유율</td>
                </tr>  
                <%	//초기화
	               	for (int j = 0 ; j <= mons ; j++){
	               		h_cnt[j] = 0;
					}
                %>		
                <%	int b_cnt = 0;
                	int t_cnt = 0;
                	for(int i = 0 ; i < vt_size ; i++){
    					Hashtable ht = (Hashtable)vt.elementAt(i);
    					if(String.valueOf(ht.get("CAR_COMP_ID")).equals(s_st[k])){
    						t_cnt = t_cnt + AddUtil.parseInt((String)ht.get("CNT0"));
    					}
                	}	
    			%>                                   
                <%	for(int i = 0 ; i < vt_size ; i++){
    					Hashtable ht = (Hashtable)vt.elementAt(i);
    					if(String.valueOf(ht.get("CAR_COMP_ID")).equals(s_st[k])){
    						b_cnt = AddUtil.parseInt((String)ht.get("CNT0"));
    			%>
    			<tr> 
                    <td align="center"><%=ht.get("PUR_ST")%></td>
    				<%		for (int j = 0 ; j <= mons ; j++){
    							int cnt 	= AddUtil.parseInt((String)ht.get("CNT"+(j)));
    							h_cnt[j] 	= h_cnt[j] + cnt;
    				%>
    				<td align="right"><%=cnt%></td>
    				<%		}%>
    				<td align="center"><%=AddUtil.calcMath("ROUND",(float)b_cnt/(float)t_cnt*100+"",2)%>%</td>
                </tr>      				
    			<%
    					}
                	}	
    			%>    
    			<tr> 
                    <td class=title align="center">합계</td>
    				<%		for (int j = 0 ; j <= mons ; j++){
    				%>
    				<td align="right"><%=h_cnt[j]%></td>
    				<%		}%>
    				<td class=title align="center"></td>
                </tr>         			 
            </table>
        </td>
    </tr>
    <tr>
        <td class=h></td>
    </tr>    
    <%} %>            					
</table>
</form>
</body>
</html>