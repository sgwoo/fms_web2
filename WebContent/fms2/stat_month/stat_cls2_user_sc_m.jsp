<%@ page contentType="text/html; charset=euc-kr" %>
<%@ page language="java" %> 
<%@ page import="java.util.*, acar.util.*, acar.stat_bus.*" %>
<jsp:useBean id="sb_db" scope="page" class="acar.stat_bus.StatBusDatabase"/>
<%@ include file="/acar/cookies.jsp" %>

<%
	String auth_rw 	= request.getParameter("auth_rw")==null?"":request.getParameter("auth_rw");
	String br_id 	= request.getParameter("br_id")==null?"":request.getParameter("br_id");
	String user_id 	= request.getParameter("user_id")==null?"":request.getParameter("user_id");
	
	String s_yy 	= request.getParameter("s_yy")==null?"":request.getParameter("s_yy");
	String s_mm 	= request.getParameter("s_mm")==null?"":request.getParameter("s_mm");
	String s_mode	= request.getParameter("s_mode")==null?"":request.getParameter("s_mode");
	
	int f_year 	= 2004;	
	int days 	= 0;
	int mons 	= 12;
	int years 	= AddUtil.getDate2(1)-f_year+1;
	
	days	= mons;
	
	Vector vt = sb_db.getStatCls2UserList(s_mode, s_yy, s_mm, days, f_year);
	int vt_size = vt.size();
	
	int rowspan1 = 0;
	int rowspan2 = 0;

	int f_row1 = 0;
	int f_row2 = 0;
	
	for(int i = 0 ; i < vt_size ; i++){
		Hashtable ht = (Hashtable)vt.elementAt(i);
    if(String.valueOf(ht.get("LOAN_ST")).equals("1")){
    	if(rowspan1==0) f_row1 = i;
      rowspan1++;
    }else if(String.valueOf(ht.get("LOAN_ST")).equals("2")){
    	if(rowspan2==0) f_row2 = i;	
    	rowspan2++;
    }
	}
	
%>
<html>
<head>
<meta http-equiv="content-type" content="text/html; charset=euc-kr">
<title>FMS</title>
<link rel="stylesheet" type="text/css" href="/include/table_t.css"></link>
<script language='javascript'>
<!--
	/* Title 고정 */
	function setupEvents(){
		window.onscroll = moveTitle ;
		window.onresize = moveTitle ; 
	}
	
	function moveTitle(){
	    var X ;
	    document.all.tr_title.style.pixelTop = document.body.scrollTop ;
	    document.all.td_title.style.pixelLeft = document.body.scrollLeft ; 
	    document.all.td_con.style.pixelLeft	= document.body.scrollLeft ;   	    	    
	}
	
	function init(){		
		setupEvents();
	}	
//-->
</script>
</head>
<body onLoad="javascript:init()">
<form name='form1' method='post'>
  <input type='hidden' name='auth_rw' 		value='<%=auth_rw%>'>
  <input type='hidden' name='br_id' 		value='<%=br_id%>'>
  <input type='hidden' name='user_id' 		value='<%=user_id%>'>
  <input type='hidden' name='s_yy' 		value='<%=s_yy%>'>
  <input type='hidden' name='s_mm' 		value='<%=s_mm%>'>
  <input type='hidden' name='s_mode' 		value='<%=s_mode%>'>
<table border=0 cellspacing=0 cellpadding=0 width=<%=50+40+110+(60*(mons+1)*3)%>>
    <tr>
      <td colspan=2>1. 월별 현황 (대여종료대수 = 만기반납+만기매입옵션+중도반납+중도매입옵션 (폐차대여종료도 포함됨), 매입옵션=만기매입옵션+중도매입옵션)</td>
    </tr>
    <tr>
        <td class=line2 colspan=2></td>
    </tr>    
    <tr id='tr_title' style='position:relative;z-index:1'>		
        <td class='line' width='<%=50+40+110+(60*3)%>' id='td_title' style='position:relative;'> 
            <table width=100% border="0" cellspacing="1" cellpadding="0">
                <tr align="center"> 
                    <td rowspan="2" width=50 class=title>군</td>
                    <td rowspan="2" width=40 class=title>연번</td>
                    <td rowspan="2" width=110 class=title>성명</td>
                    <td colspan='3' class=title>합계</td>
                </tr>
                <tr align="center">                     
                    <td width=60 class=title>대여종료<br>대수</td>
                    <td width=60 class=title>실행건수</td>
                    <td width=60 class=title>실행비율</td>                    
                </tr>
            </table>
        </td>
        <td class='line' width='<%=60*mons*3%>'>
            <table border="0" cellspacing="1" cellpadding="0" width='100%'>
                <tr>                    
                    <%for (int j = 0 ; j < days ; j++){%>
                    <td colspan='3' class=title><%=j+1%>월</td>
                    <%}%>
                </tr>
                <tr align="center">                     
                	  <%for (int j = 0 ; j < days ; j++){%>
                    <td width=60 class=title>대여종료<br>대수</td>
                    <td width=60 class=title>실행건수</td>
                    <td width=60 class=title>실행비율</td>
                    <%}%>                    
                </tr>
        		</tr>
	        </table>
	    </td>
    </tr>
    <tr>		
        <td class='line' width='<%=50+40+110+(60*3)%>' id='td_con' style='position:relative;'> 
	        <table border="0" cellspacing="1" cellpadding="0" width='100%'>                    
                <%	int count1 = 0;
                		int count2 = 0;
                		for(int i = 0 ; i < vt_size ; i++){
                		Hashtable ht = (Hashtable)vt.elementAt(i);
                			if(String.valueOf(ht.get("LOAN_ST")).equals("1")){
                				count1++;
                %>
                <tr> 
                    <%if(f_row1==i){%><td width="50" align="center" rowspan=<%=rowspan1%>><%=ht.get("LOAN_ST")%>군</td><%}%>
                    <td <%if(String.valueOf(ht.get("USER_NM")).equals("소계")){%>class=title<%}%> width="40" align="center"><%if(!String.valueOf(ht.get("USER_NM")).equals("소계")){%><%=count1%><%}%></td>
                    <td <%if(String.valueOf(ht.get("USER_NM")).equals("소계")){%>class=title<%}%> width="110" align="center"><%=ht.get("USER_NM")%></td>
                    <%for (int j = 0 ; j < 1 ; j++){%>
                    <td <%if(String.valueOf(ht.get("USER_NM")).equals("소계")){%>class=title style='text-align:right'<%}%> width="60" align="right"><%=AddUtil.parseDecimal(String.valueOf(ht.get("A_CNT"+j)))%></td>
                    <td <%if(String.valueOf(ht.get("USER_NM")).equals("소계")){%>class=title style='text-align:right'<%}%> width="60" align="right"><%=AddUtil.parseDecimal(String.valueOf(ht.get("CNT"+j)))%></td>
                    <td <%if(String.valueOf(ht.get("USER_NM")).equals("소계")){%>class=title style='text-align:right'<%}%> width="60" align="right"><%=AddUtil.parseFloatCipher(String.valueOf(ht.get("PER"+j)),1)%>%</td>
		                <%}%>
                </tr>
                <%		}%>
                <%		if(String.valueOf(ht.get("LOAN_ST")).equals("2")){
                				count2++;
                %>
                <tr> 
                    <%if(f_row2==i){%><td width="50" align="center" rowspan=<%=rowspan2%>><%=ht.get("LOAN_ST")%>군</td><%}%>
                    <td <%if(String.valueOf(ht.get("USER_NM")).equals("소계")){%>class=title<%}%> width="40" align="center"><%if(!String.valueOf(ht.get("USER_NM")).equals("소계")){%><%=count2%><%}%></td>
                    <td <%if(String.valueOf(ht.get("USER_NM")).equals("소계")){%>class=title<%}%> width="110" align="center"><%=ht.get("USER_NM")%></td>
                    <%for (int j = 0 ; j < 1 ; j++){%>
                    <td <%if(String.valueOf(ht.get("USER_NM")).equals("소계")){%>class=title style='text-align:right'<%}%> width="60" align="right"><%=AddUtil.parseDecimal(String.valueOf(ht.get("A_CNT"+j)))%></td>
                    <td <%if(String.valueOf(ht.get("USER_NM")).equals("소계")){%>class=title style='text-align:right'<%}%> width="60" align="right"><%=AddUtil.parseDecimal(String.valueOf(ht.get("CNT"+j)))%></td>
                    <td <%if(String.valueOf(ht.get("USER_NM")).equals("소계")){%>class=title style='text-align:right'<%}%> width="60" align="right"><%=AddUtil.parseFloatCipher(String.valueOf(ht.get("PER"+j)),1)%>%</td>
		                <%}%>
                </tr>
                <%		}%>
                <%		if(String.valueOf(ht.get("LOAN_ST")).equals("")){%>
                <tr> 
                    <td colspan='3' class=title><%=ht.get("USER_NM")%></td>
                    <%for (int j = 0 ; j < 1 ; j++){%>
                    <td class=title style='text-align:right' width="60" ><%=AddUtil.parseDecimal(String.valueOf(ht.get("A_CNT"+j)))%></td>
                    <td class=title style='text-align:right' width="60" ><%=AddUtil.parseDecimal(String.valueOf(ht.get("CNT"+j)))%></td>
                    <td class=title style='text-align:right' width="60" ><%=AddUtil.parseFloatCipher(String.valueOf(ht.get("PER"+j)),1)%>%</td>
		                <%}%>
                </tr>
                <%		}%>
                <%	}%>
            </table>
        </td>
        <td class='line' width='<%=60*mons*3%>'> 
	        <table border="0" cellspacing="1" cellpadding="0" width='100%'>                    
                <%	for(int i = 0 ; i < vt_size ; i++){
                		Hashtable ht = (Hashtable)vt.elementAt(i);
                			if(String.valueOf(ht.get("LOAN_ST")).equals("1")){
                %>
                <tr> 
                    <%for (int j = 1 ; j < days+1 ; j++){%>
                    <td <%if(String.valueOf(ht.get("USER_NM")).equals("소계")){%>class=title style='text-align:right'<%}%> width="60" align="right"><%=AddUtil.parseDecimal(String.valueOf(ht.get("A_CNT"+j)))%></td>
                    <td <%if(String.valueOf(ht.get("USER_NM")).equals("소계")){%>class=title style='text-align:right'<%}%> width="60" align="right"><%=AddUtil.parseDecimal(String.valueOf(ht.get("CNT"+j)))%></td>
                    <td <%if(String.valueOf(ht.get("USER_NM")).equals("소계")){%>class=title style='text-align:right'<%}%> width="60" align="right"><%=AddUtil.parseFloatCipher(String.valueOf(ht.get("PER"+j)),1)%>%</td>
		                <%}%>
                </tr>
                <%		}%>
                <%		if(String.valueOf(ht.get("LOAN_ST")).equals("2")){
                %>
                <tr> 
                    <%for (int j = 1 ; j < days+1 ; j++){%>
                    <td <%if(String.valueOf(ht.get("USER_NM")).equals("소계")){%>class=title style='text-align:right'<%}%> width="60" align="right"><%=AddUtil.parseDecimal(String.valueOf(ht.get("A_CNT"+j)))%></td>
                    <td <%if(String.valueOf(ht.get("USER_NM")).equals("소계")){%>class=title style='text-align:right'<%}%> width="60" align="right"><%=AddUtil.parseDecimal(String.valueOf(ht.get("CNT"+j)))%></td>
                    <td <%if(String.valueOf(ht.get("USER_NM")).equals("소계")){%>class=title style='text-align:right'<%}%> width="60" align="right"><%=AddUtil.parseFloatCipher(String.valueOf(ht.get("PER"+j)),1)%>%</td>
		                <%}%>
                </tr>
                <%		}%>
                <%		if(String.valueOf(ht.get("LOAN_ST")).equals("")){%>
                <tr> 
                    <%for (int j = 1 ; j < days+1 ; j++){%>
                    <td class=title style='text-align:right' width="60"><%=AddUtil.parseDecimal(String.valueOf(ht.get("A_CNT"+j)))%></td>
                    <td class=title style='text-align:right' width="60"><%=AddUtil.parseDecimal(String.valueOf(ht.get("CNT"+j)))%></td>
                    <td class=title style='text-align:right' width="60"><%=AddUtil.parseFloatCipher(String.valueOf(ht.get("PER"+j)),1)%>%</td>
		                <%}%>
                </tr>
                <%		}%>
                <%	}%>
            </table>
        </td>        
    </tr>
</table>
</form>
</body>
</html>