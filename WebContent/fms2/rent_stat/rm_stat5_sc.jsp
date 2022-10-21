<%@ page language="java" contentType="text/html;charset=euc-kr" %>
<%@ page import="java.util.*, acar.res_search.*, acar.util.*"%>
<jsp:useBean id="rs_db" scope="page" class="acar.res_search.ResSearchDatabase"/>
<%@ include file="/acar/cookies.jsp" %>

<%
	String auth_rw 	= request.getParameter("auth_rw")==null?"":request.getParameter("auth_rw");
	String br_id 	= request.getParameter("br_id")==null?"":request.getParameter("br_id");
	String user_id 	= request.getParameter("user_id")==null?"":request.getParameter("user_id");
	
	String s_yy 	= request.getParameter("s_yy")==null?"":request.getParameter("s_yy");
	String s_mm 	= request.getParameter("s_mm")==null?"":request.getParameter("s_mm");
	String s_br 	= request.getParameter("s_br")==null?"":request.getParameter("s_br");
	
	String mode = "days";
	
	Vector vt = rs_db.getRmRentStat5MagamList(AddUtil.getDate(5));
	int vt_size = vt.size();	
	
	
	Vector vt1 = rs_db.getRealRmRentStat5MagamList();  //당일 (실시간)
	int vt1_size = vt1.size();	
	
%>

<html>
<head>
<meta http-equiv="content-type" content="text/html; charset=euc-kr">
<title>FMS</title>
<link rel="stylesheet" type="text/css" href="/include/table_t.css"></link>
<script language="JavaScript">
<!--
	//세부리스트
	function view_stat5(st, st_nm, s_dt){
		window.open('rm_stat5_list.jsp?mode=<%=mode%>&s_br=<%=s_br%>&st='+st+'&st_nm='+st_nm+'&s_dt='+s_dt, "STAT5_LIST", "left=0, top=0, width=1000, height=768, scrollbars=yes, status=yes, resize");
	}
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
  <input type='hidden' name='s_br' 		value='<%=s_br%>'>
<table border=0 cellspacing=0 cellpadding=0 width=100%>    
    <%if(vt_size>0){%>
    <tr> 
        <td class=line> 
            <table width=100% border="0" cellspacing="1" cellpadding="0">
                <tr> 
                    <td rowspan="2" width=40% class=title>이월연체대여료</td>
                    <td width=30% class=title>건수</td>
                    <td width=30% class=title>금액</td>
                </tr>
                <%	for(int i = 0 ; i < 1 ; i++){
					Hashtable ht = (Hashtable)vt.elementAt(i);
                %>
                <tr> 
                    <td align='right'><%=AddUtil.parseInt(String.valueOf(ht.get("CNT4")))%></td>
                    <td align='right'><%=AddUtil.parseDecimal(AddUtil.parseInt(String.valueOf(ht.get("AMT4"))))%></td>
                </tr>    
                <%	}%>            
            </table>
        </td>
    </tr>
    <tr>
        <td class=h></td>
    </tr>                    
    <tr> 
        <td class=line> 
            <table width=100% border="0" cellspacing="1" cellpadding="0">
                <tr> 
                    <td rowspan="3" width=10% class=title>일자</td>
                    <td colspan="2" class=title>수금예정</td>
                    <td colspan="2" class=title>수금대여료</td>
                    <td colspan="4" class=title>연체대여료</td>	
                    <td rowspan="3" width=10% class=title>연체율</td>				
                </tr>
                <tr> 
                    <td rowspan="2" width=10% class=title>건수</td>
                    <td rowspan="2" width=10% class=title>금액</td>					
                    <td rowspan="2" width=10% class=title>건수</td>
                    <td rowspan="2" width=10% class=title>금액</td>					
                    <td colspan="2" class=title>신규</td>					
                    <td colspan="2" class=title>누적</td>
                </tr>                
                <tr> 
                    <td width=10% class=title>건수</td>
                    <td width=10% class=title>금액</td>				
                    <td width=10% class=title>건수</td>
                    <td width=10% class=title>금액</td>
                </tr>   
		<%	for(int i = 0 ; i < vt1_size ; i++){
				Hashtable ht1 = (Hashtable)vt1.elementAt(i);
				
				if(String.valueOf(ht1.get("DT")).equals(AddUtil.getDate(4)))
			{
                %>                
                <tr> 
                    <td align='center'>당일(실시간)</td>                    
                    <td align='right'><a href="javascript:view_stat5('1','수금예정','<%=ht1.get("DT")%>')"><%=ht1.get("CNT1")%></a></td>
                    <td align='right'><%=AddUtil.parseDecimal(String.valueOf(ht1.get("AMT1")))%></td>
                    <td align='right'><a href="javascript:view_stat5('2','수금대여료','<%=ht1.get("DT")%>')"><%=ht1.get("CNT2")%></a></td>
                    <td align='right'><%=AddUtil.parseDecimal(String.valueOf(ht1.get("AMT2")))%></td>
                    <td align='right'><a href="javascript:view_stat5('3','연체대여료(신규)','<%=ht1.get("DT")%>')"><%=AddUtil.parseInt(String.valueOf(ht1.get("CNT3")))+AddUtil.parseInt(String.valueOf(ht1.get("CNT5")))%></a></td>
                    <td align='right'><%=AddUtil.parseDecimal(AddUtil.parseInt(String.valueOf(ht1.get("AMT3")))+AddUtil.parseInt(String.valueOf(ht1.get("AMT5"))))%></td>
                    <td align='right'><a href="javascript:view_stat5('4','연체대여료(누적)','<%=ht1.get("DT")%>')"><%=AddUtil.parseInt(String.valueOf(ht1.get("CNT4")))+AddUtil.parseInt(String.valueOf(ht1.get("CNT6")))%></a></td>
                    <td align='right'><%=AddUtil.parseDecimal(AddUtil.parseInt(String.valueOf(ht1.get("AMT4")))+AddUtil.parseInt(String.valueOf(ht1.get("AMT6"))))%></td>
                    <td align='right'><%=ht1.get("DLY_PER")%></td>
                </tr>    
                <%		}
                	}%>	
    		<tr>
        		<td class=h colspan='10'></td>
    		</tr>                         			                                    				

		<%	for(int i = 0 ; i < vt_size ; i++){
				Hashtable ht = (Hashtable)vt.elementAt(i);
                %>                
                <tr> 
                    <td align='center'><%=i+1%></td>                    
                    <td align='right'><a href="javascript:view_stat5('1','수금예정','<%=ht.get("DT")%>')"><%=ht.get("CNT1")%></a></td>
                    <td align='right'><%=AddUtil.parseDecimal(String.valueOf(ht.get("AMT1")))%></td>
                    <td align='right'><a href="javascript:view_stat5('2','수금대여료','<%=ht.get("DT")%>')"><%=ht.get("CNT2")%></a></td>
                    <td align='right'><%=AddUtil.parseDecimal(String.valueOf(ht.get("AMT2")))%></td>
                    <td align='right'><a href="javascript:view_stat5('3','연체대여료(신규)','<%=ht.get("DT")%>')"><%=AddUtil.parseInt(String.valueOf(ht.get("CNT3")))+AddUtil.parseInt(String.valueOf(ht.get("CNT5")))%></a></td>
                    <td align='right'><%=AddUtil.parseDecimal(AddUtil.parseInt(String.valueOf(ht.get("AMT3")))+AddUtil.parseInt(String.valueOf(ht.get("AMT5"))))%></td>
                    <td align='right'><a href="javascript:view_stat5('4','연체대여료(누적)','<%=ht.get("DT")%>')"><%=AddUtil.parseInt(String.valueOf(ht.get("CNT4")))+AddUtil.parseInt(String.valueOf(ht.get("CNT6")))%></a></td>
                    <td align='right'><%=AddUtil.parseDecimal(AddUtil.parseInt(String.valueOf(ht.get("AMT4")))+AddUtil.parseInt(String.valueOf(ht.get("AMT6"))))%></td>
                    <td align='right'><%=ht.get("DLY_PER")%></td>
                </tr>    				                                    				
		<%	}%>                																																	
            </table>
        </td>
    </tr>
    <tr>
        <td class=h></td>
    </tr>          
    <tr> 
        <td class=line> 
            <table width=100% border="0" cellspacing="1" cellpadding="0">
                <tr> 
                    <td rowspan="2" width=40% class=title>차월연체대여료</td>
                    <td width=30% class=title>건수</td>
                    <td width=30% class=title>금액</td>
                </tr>
		<%	for(int i = vt_size-1 ; i < vt_size ; i++){
				Hashtable ht = (Hashtable)vt.elementAt(i);
				
                %>                                
                <tr> 
                    <td align='right'><%=AddUtil.parseInt(String.valueOf(ht.get("CNT4")))%></td>
                    <td align='right'><%=AddUtil.parseDecimal(AddUtil.parseInt(String.valueOf(ht.get("AMT4"))))%></td>
                </tr>             
                <%	}%>   
            </table>
        </td>
    </tr>
    <%}else{%>
    <tr>
        <td> * 마감된 자료가 없습니다.</td>
    </tr>
    <%}%>
</table>
</form>
</body>
</html>