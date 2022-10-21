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
	
	int f_year 	= 2012; //월렌트시작일
	int days 	= 30;
	if(!s_mm.equals("")){
		days = AddUtil.getMonthDate(AddUtil.parseInt(s_yy), AddUtil.parseInt(s_mm));
	}	
	int mons 	= 12;
	int years 	= AddUtil.getDate2(1)-f_year+1;
	int f_idx	= days;
	int f_i		= 0;
	
	String mode = "days";
	
	if(s_mm.equals("")){
		mode 	= "months";
		f_idx	= mons;
		
		if(s_yy.equals("")){
			mode 	= "years";
			f_idx	= AddUtil.getDate2(1)+1;
			f_i	= f_year-1;
		}
	}
	
	Hashtable ht = new Hashtable();
	
	String s_dt = "";
%>

<html>
<head>
<meta http-equiv="content-type" content="text/html; charset=euc-kr">
<title>FMS</title>
<link rel="stylesheet" type="text/css" href="/include/table_t.css"></link>
<script language="JavaScript">
<!--
	//세부리스트
	function view_stat1(st, st_nm, s_dt){
		window.open('rent_stat1_list.jsp?mode=<%=mode%>&s_br=<%=s_br%>&st='+st+'&st_nm='+st_nm+'&s_dt='+s_dt, "STAT1_LIST", "left=0, top=0, width=900, height=768, scrollbars=yes, status=yes, resize");
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
    <tr> 
        <td class=line> 
            <table width=100% border="0" cellspacing="1" cellpadding="0">
                <tr> 
                    <td rowspan="3" width=16% class=title>구분</td>
                    <td rowspan="3" width=12% class=title>대여개시</td>
                    <td rowspan="3" width=12% class=title>연장계약</td>
                    <td colspan="5" class=title>대여종료</td>					
                </tr>
                <tr> 
                    <td rowspan="2" width=12% class=title>반차</td>
                    <td colspan="3" class=title>미반차</td>					
                    <td rowspan="2" width=12% class=title>합계</td>
                </tr>                
                <tr> 
                    <td width=12% class=title>신규</td>
                    <td width=12% class=title>진행</td>				
                    <td width=12% class=title>소계</td>
                </tr>    
                
                <%	
                		if(mode.equals("days")){
                			s_dt = AddUtil.getDate(4);
                		}else if(mode.equals("months")){
                			s_dt = AddUtil.getDate(5);
                		}else if(mode.equals("years")){
                			s_dt = AddUtil.getDate(1);                			
                		}	
                		
                		ht = rs_db.getRentStat1(mode, s_dt, s_br);
                                		
                		                		
                		if(String.valueOf(ht.get("DT")).equals("null")){
                			ht.put("DT",s_dt);
                			ht.put("T_ST0","0");
                			ht.put("T_ST1","0");
                			ht.put("T_ST2","0");
                			ht.put("T_ST3","0");
                			ht.put("T_ST4","0");
                			ht.put("T_ST5","0");
                			ht.put("T_ST6","0");
                			ht.put("T_ST7","0");                			
                		}
                		
                %>	            
                <tr> 
                    <td align='center'><%if(mode.equals("days")){%>당일<%}else if(mode.equals("months")){%>당월<%}else if(mode.equals("years")){%>당해<%}%></td>                    
                    <td align='center'><a href="javascript:view_stat1('1','신규','<%=ht.get("DT")%>')"><%=ht.get("T_ST1")%></a></td>
                    <td align='center'><a href="javascript:view_stat1('2','연장','<%=ht.get("DT")%>')"><%=ht.get("T_ST2")%></a></td>
                    <td align='center'><a href="javascript:view_stat1('3','반차','<%=ht.get("DT")%>')"><%=ht.get("T_ST3")%></a></td>
                    <td align='center'><a href="javascript:view_stat1('4','미반차(신규)','<%=ht.get("DT")%>')"><%=ht.get("T_ST4")%></a></td>
                    <td align='center'><a href="javascript:view_stat1('5','미반차(진행)','<%=ht.get("DT")%>')"><%=ht.get("T_ST5")%></a></td>
                    <td align='center'><%=ht.get("T_ST6")%></td>
                    <td align='center'><%=ht.get("T_ST7")%></td>
                </tr>    	
    		<tr>
        		<td class=h colspan='10'></td>
    		</tr>       
    		                
                <%	for(int i = f_i ; i < f_idx ; i++){%>
                <%		
                		
                		
                		if(mode.equals("days")){
                			s_dt = s_yy+""+s_mm+""+AddUtil.addZero2(i+1);
                		}else if(mode.equals("months")){
                			s_dt = s_yy+""+AddUtil.addZero2(i+1);
                		}else if(mode.equals("years")){
                			s_dt = String.valueOf(i+1);                			
                		}	
                		
                		ht = rs_db.getRentStat1(mode, s_dt, s_br);
                		
                		
                		
                		if(String.valueOf(ht.get("DT")).equals("null")){
                			ht.put("DT",s_dt);
                			ht.put("T_ST0","0");
                			ht.put("T_ST1","0");
                			ht.put("T_ST2","0");
                			ht.put("T_ST3","0");
                			ht.put("T_ST4","0");
                			ht.put("T_ST5","0");
                			ht.put("T_ST6","0");
                			ht.put("T_ST7","0");                			
                		}
                		
                %>	            
                <tr> 
                    <td align='center'><%=i+1%></td>                    
                    <td align='center'><a href="javascript:view_stat1('1','신규','<%=ht.get("DT")%>')"><%=ht.get("T_ST1")%></a></td>
                    <td align='center'><a href="javascript:view_stat1('2','연장','<%=ht.get("DT")%>')"><%=ht.get("T_ST2")%></a></td>
                    <td align='center'><a href="javascript:view_stat1('3','반차','<%=ht.get("DT")%>')"><%=ht.get("T_ST3")%></a></td>
                    <td align='center'><a href="javascript:view_stat1('4','미반차(신규)','<%=ht.get("DT")%>')"><%=ht.get("T_ST4")%></a></td>
                    <td align='center'><a href="javascript:view_stat1('5','미반차(진행)','<%=ht.get("DT")%>')"><%=ht.get("T_ST5")%></a></td>
                    <td align='center'><%=ht.get("T_ST6")%></td>
                    <td align='center'><%=ht.get("T_ST7")%></td>
                </tr>    				                                    				
		<%	}%>                																																	
            </table>
        </td>
    </tr>
</table>
</form>
</body>
</html>