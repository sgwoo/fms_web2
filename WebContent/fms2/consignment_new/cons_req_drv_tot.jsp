<%@ page language="java" contentType="text/html;charset=euc-kr" %>
<%@ page import="java.util.*"%>
<%@ page import="acar.util.*, acar.consignment.*, acar.user_mng.*"%>
<jsp:useBean id="cs_db" scope="page" class="acar.consignment.ConsignmentDatabase"/>
<%@ include file="/acar/cookies.jsp" %> 

<%
	String auth_rw 	= request.getParameter("auth_rw")==null?"":request.getParameter("auth_rw");
	String user_id 	= request.getParameter("user_id")==null?"":request.getParameter("user_id");
	String br_id 	= request.getParameter("br_id")==null?"":request.getParameter("br_id");
	
	String s_kd 	= request.getParameter("s_kd")==null?"2":request.getParameter("s_kd");
	String t_wd 	= request.getParameter("t_wd")==null?"":request.getParameter("t_wd");
	String andor 	= request.getParameter("andor")==null?"":request.getParameter("andor");
	String gubun1 	= request.getParameter("gubun1")==null?"":request.getParameter("gubun1");
	String gubun2 	= request.getParameter("gubun2")==null?"":request.getParameter("gubun2");
	String gubun3 	= request.getParameter("gubun3")==null?"":request.getParameter("gubun3");
	String st_dt 	= request.getParameter("st_dt")==null?"":request.getParameter("st_dt");
	String end_dt 	= request.getParameter("end_dt")==null?"":request.getParameter("end_dt");
	String sort 	= request.getParameter("sort")==null?"":request.getParameter("sort");
		
	int sh_height = request.getParameter("sh_height")==null?0:Util.parseInt(request.getParameter("sh_height"));//상단길이
	
	int cnt = 1; //sc 출력라인수
	int height = AddUtil.parseInt(s_height)-emp_top_height-sh_height-(cnt*sc_line_height)-100;//현황 라인수만큼 제한 아이프레임 사이즈
	int count =0;
	
	Vector vt = cs_db.getConsignmentReqListDrv("2", t_wd, gubun1, st_dt, end_dt, gubun2, gubun3, "p");
	int vt_size = vt.size();
	
	long total_amt1	= 0;
	long total_amt2 = 0;
	long total_amt3	= 0;
	long total_amt4 = 0;
	long total_amt5 = 0;
	long total_amt6 = 0;
	long total_amt7 = 0;
	long total_amt8 = 0;	//세차수수료(20190517)
	
	String valus = 	"?auth_rw="+auth_rw+"&user_id="+user_id+"&br_id="+br_id+
					"&s_kd="+s_kd+"&t_wd="+t_wd+"&andor="+andor+"&gubun1="+gubun1+"&gubun2="+gubun2+"&gubun3="+gubun3+"&st_dt="+st_dt+"&end_dt="+end_dt+"&sort="+sort+
				   	"&sh_height="+height+"";
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
	
}	

function cons_doc_tot(driver_nm){

		var width 	= 1024;		
		var height 	= screen.height;		
		window.open("cons_req_drv_list_tot.jsp<%=valus%>&driver_nm="+driver_nm, "Print", "left=0, top=0, width="+width+", height="+height+", scrollbars=yes, status=yes, resizable=yes");				
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
  <table border="0" cellspacing="0" cellpadding="0" width='100%'>
	<tr>
		<td align="center"><h3>탁송기사별 현황 ( <%if(gubun1.equals("1")){%>당월조회<%}else if(gubun1.equals("2")){%>기간조회<%}else if(gubun1.equals("3")){%>당일조회<%}else if(gubun1.equals("4")){%>출발조회<%}%> : <%=AddUtil.ChangeDate2(st_dt)%> ~ <%=AddUtil.ChangeDate2(end_dt)%> )</h3></td>
	</tr>
	<tr>
		<td class='line' width='100%'>
			<table border="0" cellspacing="1" cellpadding="0" width='100%'>
				<tr><td class=line2></td></tr>
				  <tr valign="middle" align="center"> 
					<td style="font-size:8pt" width='10%' rowspan="2" align='center'>연번</td>
					<td style="font-size:8pt" width="10%" rowspan="2" align='center'>운전자</td>
					<td style="font-size:8pt" colspan="7" align='center'>청구금액</td>
				  </tr>
				  <tr valign="middle" align="center">
					<td style="font-size:8pt" width='12%' align='center'>탁송료</td>
					<td style="font-size:8pt" width='12%' align='center'>청구금액<br>(현금/개인카드)</td>
					<td style="font-size:8pt" width='12%' align='center'>세차비</td>
					<td style="font-size:8pt" width='12%' align='center'>세차수수료</td>
					<td style="font-size:8pt" width='12%' align='center'>기타금액</td>
					<td style="font-size:8pt" width='20%' align='center'>소계</td>
				  </tr>
					<%		for(int i = 0 ; i < vt_size ; i++){
									Hashtable ht = (Hashtable)vt.elementAt(i);
									%>
				  <tr> 
					<td style="font-size:8pt" align='center'><%=i+1%></td>
					<td style="font-size:8pt" align='center'><!--<a href="javascript:cons_doc_tot('<%//=ht.get("DRIVER_NM")%>');"></a>--><%=ht.get("DRIVER_NM")%></td>						
					<td style="font-size:8pt" align='right'><%=AddUtil.parseDecimal(String.valueOf(ht.get("CONS_AMT")))%></td>
					<td style="font-size:8pt" align='right'><%=AddUtil.parseDecimal(String.valueOf(ht.get("OIL_AMT")))%></td>			
					<td style="font-size:8pt" align='right'><%=AddUtil.parseDecimal(String.valueOf(ht.get("WASH_AMT")))%></td>
					<td style="font-size:8pt" align='right'><%=AddUtil.parseDecimal(String.valueOf(ht.get("WASH_FEE")))%></td>
					<td style="font-size:8pt" align='right'><%=AddUtil.parseDecimal(String.valueOf(ht.get("OTHER_AMT")))%></td>
					<td style="font-size:8pt" align='right'><%=AddUtil.parseDecimal(String.valueOf(ht.get("TOT_AMT")))%></td>
					
					
					</td>			
				  </tr>
			  <%		total_amt1 	= total_amt1 + AddUtil.parseLong(String.valueOf(ht.get("CONS_AMT")));
						total_amt2 	= total_amt2 + AddUtil.parseLong(String.valueOf(ht.get("OIL_AMT")));
						total_amt3 	= total_amt3 + AddUtil.parseLong(String.valueOf(ht.get("WASH_AMT")));
						total_amt4 	= total_amt4 + AddUtil.parseLong(String.valueOf(ht.get("OTHER_AMT")));
						total_amt5 	= total_amt5 + AddUtil.parseLong(String.valueOf(ht.get("TOT_AMT")));
						total_amt8 	= total_amt8 + AddUtil.parseLong(String.valueOf(ht.get("WASH_FEE")));
						
					  }%>
				<tr>
					<td colspan="2" align='center'>합계</td>
					<td style="font-size:8pt" align='right'><%=Util.parseDecimal(total_amt1)%></td>
					<td style="font-size:8pt" align='right'><%=Util.parseDecimal(total_amt2)%></td>					
					<td style="font-size:8pt" align='right'><%=Util.parseDecimal(total_amt3)%></td>
					<td style="font-size:8pt" align='right'><%=Util.parseDecimal(total_amt8)%></td>																
				    <td style="font-size:8pt" align='right'><%=Util.parseDecimal(total_amt4)%></td>
				    <td style="font-size:8pt" align='right'><%=Util.parseDecimal(total_amt5)%></td>
				</tr>		  
			</table>
		</td>
	</tr>
</table>
</form>
</body>
</html>
