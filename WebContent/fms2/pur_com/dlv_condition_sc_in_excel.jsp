<%//@ page language="java" contentType="text/html;charset=euc-kr"%>
<%@ page language="java" contentType="application/vnd.ms-excel; charset=euc-kr" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%
response.setHeader("Content-Type", "application/vnd.ms-xls");
response.setHeader("Content-Disposition", "inline; filename=dlv_condition_sc_in_excel.xls");
%>

<%@ page import="java.util.*"%>
<%@ page import="acar.util.*, acar.user_mng.*, acar.common.*"%>
<jsp:useBean id="a_db" scope="page" class="acar.cont.AddContDatabase"/>
<%@ include file="/acar/cookies.jsp" %>

<%
	String auth_rw 		= request.getParameter("auth_rw")==null?"":request.getParameter("auth_rw");
	String car_off_id	= request.getParameter("car_off_id")==null?"":request.getParameter("car_off_id");
	String s_kd 		= request.getParameter("s_kd")==null?"0":request.getParameter("s_kd");
	String t_wd 		= request.getParameter("t_wd")==null?"":request.getParameter("t_wd");
	String dt 		= request.getParameter("dt")==null?"0":request.getParameter("dt");
	String t_st_dt 		= request.getParameter("t_st_dt")==null?"":request.getParameter("t_st_dt");
	String t_end_dt 	= request.getParameter("t_end_dt")==null?"":request.getParameter("t_end_dt");
	
	
	CommonDataBase c_db = CommonDataBase.getInstance();
	MaMenuDatabase nm_db = MaMenuDatabase.getInstance();
	UserMngDatabase umd = UserMngDatabase.getInstance();

	if(car_off_id.equals("") && nm_db.getWorkAuthUser("외부_자동차사",ck_acar_id)){
		UsersBean user_bean 	= umd.getUsersBean(ck_acar_id);
		car_off_id	= user_bean.getSa_code();		
	}	
	
	
	Vector stats = a_db.getDlvStats(s_kd, t_wd, dt, t_st_dt, t_end_dt, car_off_id);	
	int stat_size = stats.size();
	
	long total_amt1	= 0;
	long total_amt2 = 0;
%>
<html>
<head>
<title>FMS</title>
<meta http-equiv="Content-Type" content="text/html; charset=euc-kr">
<link rel=stylesheet type="text/css" href="/include/table_t.css">
<script language='javascript'>
<!--

//-->
</script>
</head>
<body>
<% int col_cnt = 13;%>
<table border="0" cellspacing="0" cellpadding="0" width='1280'>
    <tr>
	  <td colspan='<%=col_cnt%>' align='center' style="font-size : 20pt;" height="50">(주)아마존카 출고현황 (<%=AddUtil.getDate()%>)</td>
	</tr>
    <tr>
	  <%for(int i=0;i < col_cnt;i++){%>
	  <td height="20"></td>
	  <%}%>
	</tr>
    <tr>
	  <td colspan='<%=col_cnt%>' style="font-size : 15pt;" height="30">
	  출고일자 : 
	  					<%if(dt.equals("1")){%>당일<%}%>
            			                <%if(dt.equals("2")){%>당월<%}%>						
						<%if(dt.equals("3")){%>
						<%=t_st_dt%>~<%=t_end_dt%>
						<%}%>
	  </td>
	</tr>
</table>	
<table border="1" cellspacing="0" cellpadding="0" width='1280'>
                <tr> 
			<td class='title' width='30'>연번</td>
			<td class='title' width='100'>계출번호</td>
			<td class='title' width='80'>계약일</td>	
			<td class='title' width='200'>차명</td>				
            		<td class='title' width='80'>차량번호</td>
            		<td class='title' width='150'>차대번호</td>					
            		<td class='title' width='80'>출고일</td>
            		<td class='title' width='80'>등록일</td>
			<td class='title' width='80'>제조사</td>					
            		<td class='title' width='100'>출고지점</td>            		
            		<td class='title' width='100'>구입가격</td>
            		<td class='title' width='100'>계약자</td>
            		<td class='title' width='100'>사업자번호</td>
        	</tr>
            <%	for(int i = 0 ; i < stat_size ; i++){
    			Hashtable stat = (Hashtable)stats.elementAt(i);
    			
    			total_amt1 	= total_amt1 + AddUtil.parseLong(String.valueOf(stat.get("CAR_F_AMT")));			%>
                <tr> 
           	    <td align='center' width='30'><%=i+1%></td>
           	    <td align='CENTER' width='100'><%=stat.get("RPT_NO")%></td>
           	    <td align='CENTER' width='80'><%=stat.get("RENT_DT")%></td>
        	    <td align='center' width='200'><%=stat.get("CAR_NAME")%></td>
                    <td align='center' width='80'><%=stat.get("CAR_NO")%></td>
                    <td align='center' width='150'><%=stat.get("CAR_NUM")%></td>		              		
                    <td align='center' width='80'><%=stat.get("DLV_DT")%></td>            		                    
                    <td align='center' width='80'><%=stat.get("INIT_REG_DT")%></td>            		                    
		    <td align='center' width='80'><%=stat.get("NM2")%></td>	
		    <td align='center' width='100'><%=stat.get("DLV_OFF")%></td>				                    
            	    <td align='right' width='100'><%=Util.parseDecimal(String.valueOf(stat.get("CAR_F_AMT")))%></td>					            	    
            	    <td align='center' width='100'><%=stat.get("PUR_COM_FIRM")%></td>	
            	    <td align='center' width='100'><%=AddUtil.ChangeEnt_no(String.valueOf(stat.get("PUR_COM_ENP_NO")))%><%if(String.valueOf(stat.get("PUR_COM_ENP_NO")).equals("") && !String.valueOf(stat.get("PUR_COM_FIRM")).equals("")){%><%=AddUtil.ChangeEnt_no(c_db.getNameById(String.valueOf(stat.get("PUR_COM_FIRM")),"ENP_NO"))%><%}%></td>	
                </tr>
<%		}	%>
                <tr> 
			<td class='title' colspan='10'>합계</td>
			<td class="title" style='text-align:right'><%=Util.parseDecimal(total_amt1)%></td>
			<td class='title' colspan='2'>&nbsp;</td>
        	</tr>
</table>
<script language='javascript'>
<!--
//-->
</script>
</body>
</html>