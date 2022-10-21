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

	long cnt0 = 0;
	long cnt1 = 0;
	long cnt2 = 0;
	
	long t_cnt0 = 0;
	long t_cnt1 = 0;
	long t_cnt2 = 0;
	
	long cnt0_amt = 0;
	long cnt1_amt = 0;
	long cnt2_amt = 0;
	
	long t_cnt0_amt = 0;
	long t_cnt1_amt = 0;
	long t_cnt2_amt = 0;
			
	PollDatabase p_db = PollDatabase.getInstance();
		
	Vector fines = new Vector();

	fines = p_db.CallCnt(gubun1, st_year);

	int fine_size = fines.size();
	int reg_dt = 0;

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
					<td class='title' rowspan=3 width=8%>구분</td>
					<td class='title' colspan=6>영업</td>
					<td class='title' rowspan=2 colspan=2>정비&사고</td>
					<td class='title' rowspan=3 width=8%>합계</td>
					<td class='title' rowspan=3 width=18%>단가</td>									
				</tr>
				<tr>
					<td class='title' colspan=2>정상</td>
					<td class='title' colspan=2>거부</td>
					<td class='title' colspan=2>소계</td>	
												
				</tr>
				<tr>
					<td class='title' width=4%>건수</td>
					<td class='title' width=7%>금액</td>
					<td class='title' width=4%>건수</td>
					<td class='title' width=7%>금액</td>
					<td class='title' width=4%>건수</td>
					<td class='title' width=7%>금액</td>	
					<td class='title' width=4%>건수</td>
					<td class='title' width=7%>금액</td>	
													
				</tr>
				
					<%for(int i=0; i<12; i++){
																	
						Hashtable fine = (Hashtable)fines.elementAt(i); 		
							
						cnt0 =  AddUtil.parseLong(String.valueOf(fine.get("CNT0")));
						cnt1 =  AddUtil.parseLong(String.valueOf(fine.get("CNT1")));
						cnt2 =  AddUtil.parseLong(String.valueOf(fine.get("CNT2")));
										
					         t_cnt0 +=  AddUtil.parseLong(String.valueOf(fine.get("CNT0")));		
					         t_cnt1 +=  AddUtil.parseLong(String.valueOf(fine.get("CNT1")));		
					         t_cnt2 +=  AddUtil.parseLong(String.valueOf(fine.get("CNT2")));	
					
					       if  ( AddUtil.parseInt(st_year) > 2013  ) {
					         	          cnt0_amt =  cnt0 * 4000;
							 cnt1_amt =  cnt1 * 1000;
							 cnt2_amt =  cnt2 * 3000;
											
						          t_cnt0_amt +=  cnt0_amt ;	
						          t_cnt1_amt +=  cnt1_amt ;
						          t_cnt2_amt +=  cnt2_amt ;
					       
					       } else {     
						       if (  i > 2 ) {
						          cnt0_amt =  cnt0 * 4000;
							 cnt1_amt =  cnt1 * 1000;
							 cnt2_amt =  cnt2 * 3000;
											
						          t_cnt0_amt +=  cnt0_amt ;	
						          t_cnt1_amt +=  cnt1_amt ;
						          t_cnt2_amt +=  cnt2_amt ;
					 	     }     
					 }       						
											
				%>
				<tr>
					<td align="center"><%=i+1%>월</td>
					<td align="center"><%=AddUtil.parseDecimal(cnt0)%>&nbsp;</td>
					<td align="right"><%=AddUtil.parseDecimal(cnt0_amt)%>&nbsp;</td>
					<td align="center"><%=AddUtil.parseDecimal(cnt1)%>&nbsp;</td>
					<td align="right"><%=AddUtil.parseDecimal(cnt1_amt)%>&nbsp;</td>
					<td align="center"><%=AddUtil.parseDecimal(cnt0 + cnt1)%>&nbsp;</td>
					<td align="right"><%=AddUtil.parseDecimal(cnt0_amt + cnt1_amt)%>&nbsp;</td>
					<td align="center"><%=AddUtil.parseDecimal(cnt2)%>&nbsp;</td>
					<td align="right"><%=AddUtil.parseDecimal(cnt2_amt)%>&nbsp;</td>
					<td align="right"><%=AddUtil.parseDecimal(cnt0_amt + cnt1_amt + cnt2_amt)%>&nbsp;</td>
					<td align="left">
					<%  if  ( AddUtil.parseInt(st_year) > 2013 && i == 0  ) {%>
					※ 영업(정상:4000, 거부:1000), 정비&사고(3000) )
					<% } else { %>
					<% if ( AddUtil.parseInt(st_year) < 2014 &&  i == 3 ) {%>
					※ 영업(정상:4000, 거부:1000), 정비&사고(3000) )
					 <% } %>
					 <% } %>
					</td>
				</tr>
				<%}%>
				<tr>
					<td class='title' >합계</td>
					<td align="center"><%=AddUtil.parseDecimal(t_cnt0)%>&nbsp;</td>
					<td align="right"><%=AddUtil.parseDecimal(t_cnt0_amt)%>&nbsp;</td>
					<td align="center"><%=AddUtil.parseDecimal(t_cnt1)%>&nbsp;</td>
					<td align="right"><%=AddUtil.parseDecimal(t_cnt1_amt)%>&nbsp;</td>
					<td align="center"><%=AddUtil.parseDecimal(t_cnt0 + t_cnt1)%>&nbsp;</td>
					<td align="right"><%=AddUtil.parseDecimal(t_cnt0_amt + t_cnt1_amt)%>&nbsp;</td>
					<td align="center"><%=AddUtil.parseDecimal(t_cnt2)%>&nbsp;</td>
					<td align="right"><%=AddUtil.parseDecimal(t_cnt2_amt)%>&nbsp;</td>
					<td align="right"><%=AddUtil.parseDecimal(t_cnt0_amt + t_cnt1_amt+ t_cnt2_amt)%>&nbsp;</td>
					<td align="left"></td>
				</tr>
			</table>
		</td>
	</tr>
</table>
</form>
</body>
</html>
