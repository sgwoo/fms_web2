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
	
	Vector vt = cs_db.getConsignmentReqList(s_kd, t_wd, gubun1, gubun2);
	int vt_size = vt.size();
	
	long total_amt1	= 0;
	long total_amt2 = 0;
	long total_amt3	= 0;
	long total_amt4 = 0;
	long total_amt5 = 0;
	long total_amt6 = 0;
	long total_amt7 = 0;
	long total_amt8 = 0;//세차수수료(20190517)
	long total_amt9 = 0;	//법입카드 세차(20220701)
	
	long total_amt11 = 0;	//외부탁송(202207)

%>

<html>
<head>
<title>FMS</title>
<script type="text/javascript" src="https://code.jquery.com/jquery-1.12.4.min.js"></script>
<script language='javascript'>
<!--
	/* Title 고정 */
	function setupEvents() {
		window.onscroll = moveTitle;
		window.onresize = moveTitle; 
	}
	
	function moveTitle() {
		var X;
	    document.all.tr_title.style.top = document.body.scrollTop;
	    document.all.td_title.style.left = document.body.scrollLeft;
	    document.all.td_con.style.left = document.body.scrollLeft;
	}
	
	function init() {
		setupEvents();
	}
	
	//전체선택
	function AllSelect() {		
        if ($(".ch_all").prop("checked")) {
            $("input[name=ch_cd]").prop("checked", true);
        } else {
            $("input[name=ch_cd]").prop("checked", false);
        }
	}
//-->
</script>
</head>
<meta http-equiv="content-type" content="text/html; charset=euc-kr">
<link rel=stylesheet type="text/css" href="/include/table_t.css">
<body onLoad="javascript:init()">
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
  <table border="0" cellspacing="0" cellpadding="0" width='2200'>
  	<tr><td class=line2 colspan="2"></td></tr>
	<tr id='tr_title' style='position:relative;z-index:1'>
		<td class='line' width='25%' id='td_title' style='position:relative;'>
			<table border="0" cellspacing="1" cellpadding="0" width='100%'>
				<tr>
				  <td width='8%' class='title' style='height:80'>연번</td>
				  <td width='8%' class='title'><input type="checkbox" class="ch_all" name="ch_all" value="Y" onclick="javascript:AllSelect();"></td>
		          <td width='20%' class='title'>탁송번호</td>
				  <td width='26%' class='title'>탁송업체</td>
		          <td width="10%" class='title'>구분</td>				  
		          <td width="28%" class='title'>차량번호</td>
				</tr>
			</table>
		</td>
		<td class='line' width='75%'>
			<table border="0" cellspacing="1" cellpadding="0" width='100%' height="100%">
				<tbody>
					<tr>
					  <td width="100" rowspan="3" class='title'>차명</td>
					  
					  <td colspan="2" class='title'>출발</td>
					  <td colspan="2" class='title'>도착</td>
					  
					  <td width='50' rowspan="2" class='title'>지불<br>구분</td>
					  <td width='60' rowspan="2" class='title'>비용<br>구분</td>
					  
					  <td width='70' rowspan="2" class='title'>고객탁송료</td>	
					  <td colspan="2" class='title'>법인카드</td>
					  <td colspan="7" class='title'>청구금액</td>
					  <td width='60' class='title' rowspan="2">운전자</td>
					  <td width='60' class='title' rowspan="2">의뢰자</td>
					</tr>
					<tr>
					  <td width='110' class='title' >장소</td>
					  <td width='130' class='title' >시간</td>
					  <td width='110' class='title' >장소</td>
					  <td width='130' class='title' >시간</td>
					  
					  <td width='60' class='title' >유류비</td>
					  <td width='60' class='title' >세차비</td>
					  <td width='70' class='title' >탁송료</td>
					  <td width='60' class='title' >외부탁송료</td>
					  <td width='60' class='title' >유류비</td>
					  <td width='60' class='title' >세차비</td>					
					  <td width='60' class='title' >세차수수료</td>
					  <td width='60' class='title' >주차비</td>
					  <td width='100' class='title'>합계<br/>(법인카드제외)</td>
				    </tr>
					
				</tbody>
			</table>
		</td>
	</tr>
<%	if(vt_size > 0)	{%>
	<tr>
		<td class='line' width='25%' id='td_con' style='position:relative;'>
			<table border="0" cellspacing="1" cellpadding="0" width='100%'>
<%		for(int i = 0 ; i < vt_size ; i++){
			Hashtable ht = (Hashtable)vt.elementAt(i);
			
			String prev_car_no = String.valueOf(ht.get("CAR_NO"));
			String seq = String.valueOf(ht.get("SEQ"));
			String car_no = "";
			if( prev_car_no.length() > 10 ) {
				car_no = cs_db.getCarNo(String.valueOf(ht.get("CONS_NO")), Integer.parseInt(seq));
			}
			car_no = car_no == "" ? prev_car_no : car_no;
			%>
				<tr>
					<td  width='8%' align='center'><%=i+1%></td>
					<%if(String.valueOf(ht.get("CONS_SU")).equals("1")){%>
					<td  width='8%' align='center'><input type="checkbox" name="ch_cd" value="<%=ht.get("CONS_NO")%>"></td>
					<%}else{%>
					<%	if(String.valueOf(ht.get("SEQ")).equals("1")){%>
					<td  width='8%' align='center' rowspan='<%=ht.get("CONS_SU")%>'><input type="checkbox" name="ch_cd" value="<%=ht.get("CONS_NO")%>"></td>
					<%	}%>
					<%}%>
					<td  width='20%' align='center'><a href="javascript:parent.view_cons('<%=ht.get("CONS_NO")%>')" onMouseOver="window.status=''; return true"><%=ht.get("CONS_NO")%>-<%=ht.get("SEQ")%></a></td>					
					<td  width='26%' align='center'><%=ht.get("OFF_NM")%></td>
					<td  width='10%' align='center'><%=ht.get("CONS_ST_NM")%></td>					
					<td  width='28%' align='center'><%=car_no%></td>
				</tr>
<%		}%>
				<tr>
				  <td class='title'>&nbsp;</td>
				  <td class='title'>&nbsp;</td>
				  <td class='title'>&nbsp;</td>
				  <td class='title'>&nbsp;</td>
				  <td class='title'>&nbsp;</td>				  
				  <td class='title'>&nbsp;</td>
				</tr>
			</table>
		</td>
		<td class='line' width='75%'>
			<table border="0" cellspacing="1" cellpadding="0" width='100%'>
<%		for(int i = 0 ; i < vt_size ; i++){
			Hashtable ht = (Hashtable)vt.elementAt(i);
			total_amt6 	= AddUtil.parseInt(String.valueOf(ht.get("OIL_CARD_AMT")))+AddUtil.parseInt(String.valueOf(ht.get("OIL_AMT")));
			%>
				<tr>			
					<td  width='100' align='center'><span title='<%=ht.get("CAR_NM")%>'><%=Util.subData(String.valueOf(ht.get("CAR_NM")), 7)%></span></td>																	
					<td  width='110' align='center'><span title='<%=ht.get("FROM_PLACE")%>'><%=Util.subData(String.valueOf(ht.get("FROM_PLACE")), 6)%></span></td>
					<td  width='130' align='center'><%=AddUtil.ChangeDate3(String.valueOf(ht.get("FROM_DT")))%></td>
					<td  width='110' align='center'><span title='<%=ht.get("TO_PLACE")%>'><%=Util.subData(String.valueOf(ht.get("TO_PLACE")), 6)%></span></td>
					<td  width='130' align='center'><%=AddUtil.ChangeDate3(String.valueOf(ht.get("TO_DT")))%></td>
					
					<td  width='50' align='center'><%=ht.get("PAY_ST_NM")%></td>
					<td  width='60' align='center'><%=ht.get("COST_ST_NM")%></td>		
					<td  width='70' align='right'><%=AddUtil.parseDecimal(String.valueOf(ht.get("CUST_AMT")))%></td>
					<td  width='60' align='right'><%=AddUtil.parseDecimal(String.valueOf(ht.get("OIL_CARD_AMT")))%></td>
					<td  width='60' align='right'><%=AddUtil.parseDecimal(String.valueOf(ht.get("WASH_CARD_AMT")))%></td>
					
					<td  width='70' align='right'><%=AddUtil.parseDecimal(String.valueOf(ht.get("CONS_AMT")))%></td>
					<td  width='60' align='right'><%=AddUtil.parseDecimal(String.valueOf(ht.get("CONS_OTHER_AMT")))%></td>				
					<td  width='60' align='right'><%=AddUtil.parseDecimal(String.valueOf(ht.get("OIL_AMT")))%></td>								
					<td  width='60' align='right'><%=AddUtil.parseDecimal(String.valueOf(ht.get("WASH_AMT")))%></td>
					<td  width='60' align='right'><%=AddUtil.parseDecimal(String.valueOf(ht.get("WASH_FEE")))%></td>
					<td  width='60' align='right'><%=AddUtil.parseDecimal(String.valueOf(ht.get("OTHER_AMT")))%></td>
					<td  width='100' align='right'><%=AddUtil.parseDecimal(String.valueOf(ht.get("TOT_AMT")))%></td>
					<td width='60' align='center'><span title='<%=ht.get("DRIVER_NM")%>'><%=Util.subData(String.valueOf(ht.get("DRIVER_NM")), 3)%></span></td>
					<td width='60' align='center'><%=ht.get("USER_NM1")%></td>
				</tr>
<%			total_amt1 	= total_amt1 + AddUtil.parseLong(String.valueOf(ht.get("CONS_AMT")));
			total_amt2 	= total_amt2 + AddUtil.parseLong(String.valueOf(ht.get("OIL_AMT")));
			total_amt3 	= total_amt3 + AddUtil.parseLong(String.valueOf(ht.get("WASH_AMT")));
			total_amt4 	= total_amt4 + AddUtil.parseLong(String.valueOf(ht.get("OTHER_AMT")));
			total_amt5 	= total_amt5 + AddUtil.parseLong(String.valueOf(ht.get("TOT_AMT")));
			total_amt7 	= total_amt7 + AddUtil.parseLong(String.valueOf(ht.get("OIL_CARD_AMT")));		
			total_amt8 	= total_amt8 + AddUtil.parseLong(String.valueOf(ht.get("WASH_FEE")));
			total_amt9 	= total_amt9 + AddUtil.parseLong(String.valueOf(ht.get("WASH_CARD_AMT")));
			
			total_amt11 	= total_amt11 + AddUtil.parseLong(String.valueOf(ht.get("CONS_OTHER_AMT")));
		}%>
				<tr>											
				    <td class='title'>&nbsp;</td>
				    <td class='title'>&nbsp;</td>					
				    <td class='title'>&nbsp;</td>
				    <td class='title'>&nbsp;</td>
				    <td class='title'>&nbsp;</td>
				    <td class='title'>&nbsp;</td>
					
				    <td class='title'>&nbsp;</td>
				    <td class='title'>&nbsp;</td>
						
					<td class=''align='right'><%=Util.parseDecimal(total_amt7)%></td>	
					<td class=''align='right'><%=Util.parseDecimal(total_amt9)%></td>		
					<td class='title_num'><%=Util.parseDecimal(total_amt1)%></td>		
					<td class='title_num'><%=Util.parseDecimal(total_amt11)%></td>			
					<td class='title_num'><%=Util.parseDecimal(total_amt2)%></td>
					<td class='title_num'><%=Util.parseDecimal(total_amt3)%></td>
					<td class='title_num'><%=Util.parseDecimal(total_amt8)%></td>			
					<td class='title_num'><%=Util.parseDecimal(total_amt4)%></td>
					<td class='title_num'><%=Util.parseDecimal(total_amt5)%></td>
				    <td class='title'>&nbsp;</td>
				    <td class='title'>&nbsp;</td>
				</tr>
			</table>
		</td>
<%	}else{%>
	<tr>
		<td class='line' width='25%' id='td_con' style='position:relative;'>
			<table border="0" cellspacing="1" cellpadding="0" width='100%'>
				<tr>
					<td align='center'>
					<%if(t_wd.equals("")){%>검색어를 입력하십시오.
					<%}else{%>등록된 데이타가 없습니다<%}%></td>
				</tr>
			</table>
		</td>
		<td class='line' width='75%'>
			<table border="0" cellspacing="1" cellpadding="0" width='100%'>
				<tr>
					<td>&nbsp;</td>
				</tr>
			</table>
		</td>
	</tr>
<%	}%>
</table>
</form>
<script language='javascript'>
<!--
	//parent.document.form1.size.value = '<%=vt_size%>';
//-->
</script>
</body>
</html>
