<%@ page language="java" contentType="text/html;charset=euc-kr"%>
<%@ page import="java.util.*, acar.util.*, acar.call.*"%>

<%@ include file="/acar/cookies.jsp" %>
<%
	String auth_rw = request.getParameter("auth_rw")==null?"":request.getParameter("auth_rw");
	String user_id = request.getParameter("user_id")==null?"":request.getParameter("user_id");//로그인-ID
	String br_id = request.getParameter("br_id")==null?"":request.getParameter("br_id");//로그인-영업소
	String auth = request.getParameter("auth")==null?"":request.getParameter("auth");	
	String gubun1 = request.getParameter("gubun1")==null?"000071":request.getParameter("gubun1");
	String st_year = request.getParameter("st_year")==null?"":request.getParameter("st_year");
	String st_mon = request.getParameter("st_mon")==null?"":request.getParameter("st_mon");
	
	long cnt0 = 0;
	long cnt1 = 0;
	long cnt2 = 0;
	long cnt3 = 0;
	
	long t_cnt0 = 0;
	long t_cnt1 = 0;
	long t_cnt2 = 0;
	long t_cnt3 = 0;	
			
	PollDatabase p_db = PollDatabase.getInstance();
		
	Vector fines = new Vector();

	fines = p_db.CallCnt(gubun1, st_year, st_mon);

	int fine_size = fines.size();
//	out.println(fine_size);
	
	int reg_dt = 0;
	
 	float per1 = 0;
 	float per2 = 0;
 	
 	float t_per1 = 0;
 	float t_per2 = 0;

%>
<html>
<head><title>FMS</title>
<script language='JavaScript' src='/include/common.js'></script>
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
	
	//과태료리스트보기
	function view_list(reg_dt, gov_id, gubun1){
		var auth_rw = document.form1.auth_rw.value;
		window.open("t_forfeit_list.jsp?auth_rw="+auth_rw+"&gov_id="+gov_id+"&gubun1="+gubun1+"&dt="+reg_dt, "FINE_LIST", "left=100, top=100, width=1000, height=700 scrollbars=yes");
	}	
	
//-->
</script>
<meta http-equiv="content-type" content="text/html; charset=euc-kr">
<link rel=stylesheet type="text/css" href="/include/table_t.css">
</head>
<body onLoad="javascript:">

<form name='form1' action='' method='post'>
<input type='hidden' name='auth_rw' value='<%=auth_rw%>'>
<input type='hidden' name='user_id' value='<%=user_id%>'>
<input type='hidden' name='br_id' value='<%=br_id%>'>

<table border="0" cellspacing="0" cellpadding="0" width=100%>
    <tr> 
        <td class=h></td>
    </tr>
    <tr>
	    <td class='line'>			
            <table border="0" cellspacing="1" cellpadding="0" width=100%>
				<tr>
					<td class='title' rowspan=2 width=13%>부서</td>
					<td class='title' rowspan=2 width=13%>이름</td>
					<td class='title' colspan=3>영업</td>
					<td class='title' colspan=3>정비&사고</td>
															
				</tr>
				<tr>
					<td class='title' >총통화건수</td>
					<td class='title' >통화요청건수</td>
					<td class='title' >요청비율</td>
					<td class='title' >총통화건수</td>
					<td class='title' >통화요청건수</td>			
					<td class='title' >요청비율</td>
												
				</tr>
				
				
					<%for(int i=0; i<fine_size; i++){
																	
						Hashtable fine = (Hashtable)fines.elementAt(i); 		
							
						cnt0 =  AddUtil.parseLong(String.valueOf(fine.get("CNT0")));
						cnt1 =  AddUtil.parseLong(String.valueOf(fine.get("CNT1")));
						cnt2 =  AddUtil.parseLong(String.valueOf(fine.get("CNT2")));
						cnt3 =  AddUtil.parseLong(String.valueOf(fine.get("CNT3")));
										
					         t_cnt0 +=  AddUtil.parseLong(String.valueOf(fine.get("CNT0")));		
					         t_cnt1 +=  AddUtil.parseLong(String.valueOf(fine.get("CNT1")));		
					         t_cnt2 +=  AddUtil.parseLong(String.valueOf(fine.get("CNT2")));	
					         t_cnt3 +=  AddUtil.parseLong(String.valueOf(fine.get("CNT3")));	
					
						if ( cnt0 == 0 ) {		 	per1 = 0;
						 } else {         per1 = (float) 	cnt1/cnt0*100; }
						 
						 if ( cnt2 == 0 ) {		 	per2 = 0;
						 } else {         per2 = (float) 	cnt3/cnt2*100; }
						 						
						 t_per1 = (float) 	t_cnt1/t_cnt0*100; 				 
						 t_per2 = (float) 	t_cnt3/t_cnt2*100;							
											
					
				%>
				<tr>
					<td align="center"><%=fine.get("DEPT_NM")%></td>
					<td align="center"><%=fine.get("USER_NM")%></td>
					<td align="center"><%=AddUtil.parseDecimal(cnt0)%>&nbsp;</td>
					<td align="center"><%=AddUtil.parseDecimal(cnt1)%>&nbsp;</td>
					<td align="center"><% if ( cnt0 == 0 ) {%>0					
					<% } else {%><%=AddUtil.parseFloatCipher(per1,1)%><% } %>%&nbsp;</td>		
					<td align="center"><%=AddUtil.parseDecimal(cnt2)%>&nbsp;</td>
					<td align="center"><%=AddUtil.parseDecimal(cnt3)%>&nbsp;</td>
					<td align="center"><% if ( cnt2 == 0 ) {%>0					
					<% } else {%><%=AddUtil.parseFloatCipher(per2, 1 )%><% } %>%&nbsp;</td>	
				</tr>
				<%}%>
			
					<tr>
					<td class='title'  colspan=2 >합계</td>
					<td align="center"><%=AddUtil.parseDecimal(t_cnt0)%>&nbsp;</td>				
					<td align="center"><%=AddUtil.parseDecimal(t_cnt1)%>&nbsp;</td>		
					<td align="center"><%=AddUtil.parseFloatCipher(t_per1,1)%>%&nbsp;</td>				
					<td align="center"><%=AddUtil.parseDecimal(t_cnt2)%>&nbsp;</td>					
					<td align="center"><%=AddUtil.parseDecimal(t_cnt3)%>&nbsp;</td>		
					<td align="center"><%=AddUtil.parseFloatCipher(t_per2,1)%>%&nbsp;</td>			
				
				</tr> 
			
			</table>
		</td>
	</tr>
</table>
</form>
</body>
</html>
