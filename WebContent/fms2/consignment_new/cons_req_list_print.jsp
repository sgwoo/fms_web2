<%@ page language="java" contentType="text/html;charset=euc-kr" %>
<%@ page import="java.util.*"%>
<%@ page import="acar.util.*, acar.consignment.*, acar.user_mng.*"%>
<jsp:useBean id="cs_db" scope="page" class="acar.consignment.ConsignmentDatabase"/>
<%@ include file="/acar/cookies.jsp" %> 

<%
	String auth_rw 	= request.getParameter("auth_rw")==null?"":request.getParameter("auth_rw");
	String user_id 	= request.getParameter("user_id")==null?"":request.getParameter("user_id");
	String br_id 	= request.getParameter("br_id")==null?"":request.getParameter("br_id");
	
	String s_kd 	= request.getParameter("s_kd")==null?"":request.getParameter("s_kd");
	String t_wd 	= request.getParameter("t_wd")==null?"":request.getParameter("t_wd");
	String andor 	= request.getParameter("andor")==null?"":request.getParameter("andor");
	String gubun1 	= request.getParameter("gubun1")==null?"":request.getParameter("gubun1");
	String gubun2 	= request.getParameter("gubun2")==null?"":request.getParameter("gubun2");
	String gubun3 	= request.getParameter("gubun3")==null?"":request.getParameter("gubun3");
	String st_dt 	= request.getParameter("st_dt")==null?"":request.getParameter("st_dt");
	String end_dt 	= request.getParameter("end_dt")==null?"":request.getParameter("end_dt");
	String sort 	= request.getParameter("sort")==null?"":request.getParameter("sort");
	
	int sh_height = request.getParameter("sh_height")==null?0:Util.parseInt(request.getParameter("sh_height"));//상단길이
	
	int count =0;
	
	Vector vt = cs_db.getConsignmentReqList2(s_kd, t_wd, gubun1, st_dt, end_dt, gubun2, gubun3, "p");
	int vt_size = vt.size();
	
	long total_amt1	= 0;
	long total_amt2 = 0;
	long total_amt3	= 0;
	long total_amt4 = 0;
	long total_amt5 = 0;
	long total_amt6 = 0;
	long total_amt7 = 0;
	long total_amt8 = 0;	//세차수수료(20190517)
	long total_amt9 = 0;   //법인카드 - 세차비
	long total_amt11	= 0;
	long total_amt12	= 0;
	long total_amt13	= 0;
%>

<html>
<head><title>FMS</title>
<script language='javascript'>
<!--
	/* Title 고정 */
	function setupEvents()
	{
			window.onscroll = moveTitle ;
			window.onresize = moveTitle ; 
	}
	
	function moveTitle()
	{
	    var X ;
	    document.all.tr_title.style.pixelTop = document.body.scrollTop ;
	    document.all.td_title.style.pixelLeft = document.body.scrollLeft ; 
	    document.all.td_con.style.pixelLeft	= document.body.scrollLeft ;   	    
	    
	}
	function init() {
		
		setupEvents();
	}
		
//-->
</script>
</head>
<meta http-equiv="content-type" content="text/html; charset=euc-kr">
<link rel=stylesheet type="text/css" href="/include/table_t.css">
<body onLoad="javascript:print()">
<form name='form1' method='post'>
  <input type='hidden' name='auth_rw' 	value='<%=auth_rw%>'>
  <input type='hidden' name='user_id' 	value='<%=user_id%>'>
  <input type='hidden' name='br_id' 	value='<%=br_id%>'>
  <input type='hidden' name='s_kd'  	value='<%=s_kd%>'>
  <input type='hidden' name='t_wd' 		value='<%=t_wd%>'>			
  <input type='hidden' name='andor'	 	value='<%=andor%>'>
  <input type='hidden' name='gubun1' 	value='<%=gubun1%>'>  
  <input type='hidden' name='gubun2' 	value='<%=gubun2%>'> 
  <input type='hidden' name='gubun3' 	value='<%=gubun3%>'>       
  <input type='hidden' name='st_dt' 	value='<%=st_dt%>'>  
  <input type='hidden' name='end_dt' 	value='<%=end_dt%>'>        
  <input type='hidden' name='sort' 		value='<%=sort%>'>
  <input type='hidden' name='sh_height' value='<%=sh_height%>'>
  <input type='hidden' name='from_page' value='/fms2/consignment_new/cons_req_frame.jsp'>
  <input type='hidden' name='cons_no' value=''>
  <input type='hidden' name='mode' value=''>    
  <input type='hidden' name='req_dt' value='<%=AddUtil.getDate()%>'>      
  <table border="0" cellspacing="0" cellpadding="0" width='1270'>
	<tr>
		<td class='line' width='100%'>
			<table border="0" cellspacing="1" cellpadding="0" width='100%'>
				<tr>
				  <td style="font-size:8pt" width='25' rowspan="3" align='center'>연번</td>
		          <td style="font-size:8pt" width='105' rowspan="3" align='center'>탁송번호</td>
		          <td style="font-size:8pt" width="25" rowspan="3" align='center'>탁송<br>구분</td>				  
		          <td style="font-size:8pt" width="83" rowspan="3" align='center'>차량번호</td>
		          <td style="font-size:8pt" width="90" rowspan="3" align='center'>차명</td>									
		          <td style="font-size:8pt" width="76" rowspan="3" align='center'>청구일자</td>
		          <td style="font-size:8pt" width="76" rowspan="3" align='center'>탁송일자</td>				  
				  <td style="font-size:8pt" width='90' rowspan="3" align='center'>출발장소</td>
				  <td style="font-size:8pt" width='90' rowspan="3" align='center'>도착장소</td>
				  <td style="font-size:8pt" colspan="2" align='center'>법인카드</td>
				  <td colspan="9" align='center'>청구금액</td>
				  <td style="font-size:8pt" width='40' rowspan="3" align='center'>운전자</td>
				  <td style="font-size:8pt" width='40' rowspan="3" align='center'>의뢰자</td>				  
				</tr>
				<tr>
				  <td style="font-size:8pt" width='60' align='center' rowspan="2">유류비</td>
			      <td style="font-size:8pt" width='50' align='center' rowspan="2">세차비</td>
			      <td style="font-size:8pt" width='70' align='center' rowspan="2">탁송료</td>			  
			      <td style="font-size:8pt" width='60' align='center' rowspan="2">유류비</td>
			      <td style="font-size:8pt" width='50' align='center' rowspan="2">세차비</td>
			      <td style="font-size:8pt" width='50' align='center' rowspan="2">세차<br>수수료</td>		
			      <td style="font-size:8pt" align='center' colspan=4 >기타</td>
			      <td style="font-size:8pt" width='65' align='center' rowspan="2">소계</td>
			  </tr>	
			  <tr>	
			      <td  style="font-size:8pt" width='50' align='center'>외부<br>탁송료</td>				  
			      <td  style="font-size:8pt" width='50' align='center'>주차비</td>
			      <td  style="font-size:8pt" width='50' align='center'>보증수리<br/>대행</td>
			      <td  style="font-size:8pt" width='50' align='center'>검사대행</td>					    
			  </tr>	 			
<%	if(vt_size > 0)	{%>
<%		for(int i = 0 ; i < vt_size ; i++){
			Hashtable ht = (Hashtable)vt.elementAt(i);%>
				<tr>
					<td style="font-size:8pt" align='center'><%=i+1%></td>
					<td style="font-size:8pt" align='center'><%=ht.get("CONS_NO")%>-<%=ht.get("SEQ")%></td>					
					<td style="font-size:8pt" align='center'><%=ht.get("CONS_ST_NM")%></td>					
					<td style="font-size:8pt" align='center'><%=Util.subData(String.valueOf(ht.get("CAR_NO")), 8)%></td>
					<td style="font-size:8pt" align='center'><span title='<%=ht.get("CAR_NM")%>'><%=Util.subData(String.valueOf(ht.get("CAR_NM")), 7)%></span></td>																	
					<td style="font-size:8pt" align='center'><%=AddUtil.ChangeDate2(String.valueOf(ht.get("REQ_DT")))%></td>
					<td style="font-size:8pt" align='center'><%=AddUtil.ChangeDate2(String.valueOf(ht.get("FROM_DT")))%></td>					
					<td style="font-size:8pt" align='center'><span title='<%=ht.get("FROM_PLACE")%>'><%=Util.subData(String.valueOf(ht.get("FROM_PLACE")), 6)%></span></td>
					<td style="font-size:8pt" align='center'><span title='<%=ht.get("TO_PLACE")%>'><%=Util.subData(String.valueOf(ht.get("TO_PLACE")), 6)%></span></td>
					<td style="font-size:8pt" align='right'><%=AddUtil.parseDecimal(String.valueOf(ht.get("OIL_CARD_AMT")))%></td>
					<td style="font-size:8pt" align='right'><%=AddUtil.parseDecimal(String.valueOf(ht.get("WASH_CARD_AMT")))%></td>
					
					<td style="font-size:8pt" align='right'><%=AddUtil.parseDecimal(String.valueOf(ht.get("CONS_AMT")))%></td>			
									
					<td style="font-size:8pt" align='right'><%=AddUtil.parseDecimal(String.valueOf(ht.get("OIL_AMT")))%></td>
					<td style="font-size:8pt" align='right'><%=AddUtil.parseDecimal(String.valueOf(ht.get("WASH_AMT")))%></td>
					<td style="font-size:8pt" align='right'><%=AddUtil.parseDecimal(String.valueOf(ht.get("WASH_FEE")))%></td>	
					<td style="font-size:8pt" align='right'><%=AddUtil.parseDecimal(String.valueOf(ht.get("CONS_OTHER_AMT")))%></td>		
					<td style="font-size:8pt" align='right'><%=AddUtil.parseDecimal(String.valueOf(ht.get("OTHER_AMT")))%></td>
					<td style="font-size:8pt" align='right'><%=AddUtil.parseDecimal(String.valueOf(ht.get("ETC1_AMT")))%></td>
					<td style="font-size:8pt" align='right'><%=AddUtil.parseDecimal(String.valueOf(ht.get("ETC2_AMT")))%></td>
					<td style="font-size:8pt" align='right'><%=AddUtil.parseDecimal(String.valueOf(ht.get("TOT_AMT")))%></td>
					<td style="font-size:8pt" align='center'><%=ht.get("DRIVER_NM")%></td>
					<td style="font-size:8pt" align='center'><%=ht.get("USER_NM1")%></td>
				</tr>				
<%			total_amt1 	= total_amt1 + AddUtil.parseLong(String.valueOf(ht.get("CONS_AMT")));
			total_amt2 	= total_amt2 + AddUtil.parseLong(String.valueOf(ht.get("OIL_AMT")));
			total_amt3 	= total_amt3 + AddUtil.parseLong(String.valueOf(ht.get("WASH_AMT")));
			total_amt4 	= total_amt4 + AddUtil.parseLong(String.valueOf(ht.get("OTHER_AMT")));
			total_amt5 	= total_amt5 + AddUtil.parseLong(String.valueOf(ht.get("TOT_AMT")));
			total_amt6 	= total_amt6 + AddUtil.parseLong(String.valueOf(ht.get("OIL_CARD_AMT")));
			total_amt8 	= total_amt8 + AddUtil.parseLong(String.valueOf(ht.get("WASH_FEE")));
			total_amt9 	= total_amt9 + AddUtil.parseLong(String.valueOf(ht.get("WASH_CARD_AMT")));
			total_amt11 	= total_amt11 + AddUtil.parseLong(String.valueOf(ht.get("CONS_OTHER_AMT")));
			total_amt12 	= total_amt12 + AddUtil.parseLong(String.valueOf(ht.get("ETC1_AMT")));
			total_amt13 	= total_amt13 + AddUtil.parseLong(String.valueOf(ht.get("ETC2_AMT")));
		}%>
				<tr>
				  <td>&nbsp;</td>
				  <td>&nbsp;</td>
				  <td>&nbsp;</td>				  
				  <td>&nbsp;</td>				  				  
				  <td align='center'>합계</td>
				    <td>&nbsp;</td>
				    <td>&nbsp;</td>
				    <td>&nbsp;</td>
				    <td>&nbsp;</td>
					<td style="font-size:8pt"  align='right'><%=Util.parseDecimal(total_amt6)%></td>
					<td style="font-size:8pt"  align='right'><%=Util.parseDecimal(total_amt9)%></td>
					<td style="font-size:8pt"  align='right'><%=Util.parseDecimal(total_amt1)%></td>							
					<td style="font-size:8pt"  align='right'><%=Util.parseDecimal(total_amt2)%></td>
					<td style="font-size:8pt"  align='right'><%=Util.parseDecimal(total_amt3)%></td>
					<td style="font-size:8pt"  align='right'><%=Util.parseDecimal(total_amt8)%></td>	
					<td style="font-size:8pt"  align='right'><%=Util.parseDecimal(total_amt11)%></td>						 
					<td style="font-size:8pt"  align='right'><%=Util.parseDecimal(total_amt4)%></td>
					<td style="font-size:8pt"  align='right'><%=Util.parseDecimal(total_amt12)%></td>			
					<td style="font-size:8pt"  align='right'><%=Util.parseDecimal(total_amt13)%></td>			
					<td style="font-size:8pt"  align='right'><%=Util.parseDecimal(total_amt5)%></td>
				    <td>&nbsp;</td>
				    <td>&nbsp;</td>				  
				</tr>
			</table>
		</td>
	</tr>
<%	}%>
</table>
</form>
</body>
</html>
