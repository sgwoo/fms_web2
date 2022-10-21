<%@ page language="java" contentType="text/html;charset=euc-kr" %>
<%@ page import="java.util.*, acar.util.*, acar.user_mng.*, acar.parking.*, java.*"%>
<jsp:useBean id="pk_db" scope="page" class="acar.parking.ParkIODatabase"/>
<%@ include file="/acar/cookies.jsp" %>
<%
	String auth_rw 	= request.getParameter("auth_rw")==null?"":request.getParameter("auth_rw");
	String user_id 	= request.getParameter("user_id")==null?"":request.getParameter("user_id");
	String br_id 	= request.getParameter("br_id")==null?"":request.getParameter("br_id");
	
	String s_kd 	= request.getParameter("s_kd")==null?"":request.getParameter("s_kd");
	String t_wd 	= request.getParameter("t_wd")==null?"" :request.getParameter("t_wd");
	String brid 	= request.getParameter("brid")==null?"":request.getParameter("brid");
	String gubun1 = request.getParameter("gubun1")==null?"1":request.getParameter("gubun1");
	String start_dt 	= request.getParameter("start_dt")==null?"":request.getParameter("start_dt");
	String end_dt 	= request.getParameter("end_dt")==null?"":request.getParameter("end_dt");
	String sort_gubun = request.getParameter("sort_gubun")==null?"5":request.getParameter("sort_gubun");
	String asc = request.getParameter("asc")==null?"":request.getParameter("asc");
	String s_cc = request.getParameter("s_cc")==null?"":request.getParameter("s_cc");
	
	int s_year = request.getParameter("s_year")==null?0:Util.parseDigit(request.getParameter("s_year"));
	
	String park_id = request.getParameter("park_id")==null?"":request.getParameter("park_id");
	//int park_id = request.getParameter("park_id")==null?1:Util.parseInt(request.getParameter("park_id"));
	int seq = request.getParameter("seq")==null?1:Util.parseInt(request.getParameter("seq"));
	String car_no = request.getParameter("car_no")==null?"":request.getParameter("car_no");
	String car_nm = request.getParameter("car_nm")==null?"":request.getParameter("car_nm");
	String car_mng_id	= request.getParameter("car_mng_id")==null?"":request.getParameter("car_mng_id");
	String init_reg_dt	= request.getParameter("init_reg_dt")==null?"":request.getParameter("init_reg_dt");
	String dpm	= request.getParameter("dpm")==null?"":request.getParameter("dpm");
	String fuel_kd	= request.getParameter("fuel_kd")==null?"":request.getParameter("fuel_kd");
	String colo	= request.getParameter("colo")==null?"":request.getParameter("colo");
	
	int count =0;
	

	
	String save_dt	= request.getParameter("save_dt")==null?"":request.getParameter("save_dt");
	
	Vector vt = new Vector();	
	
	vt = pk_db.Park_li_Magam(save_dt, t_wd, brid);

	int vt_size = vt.size();	
	
%>

<html>
<head>
<title>FMS</title>
<meta http-equiv="Content-Type" content="text/html; charset=euc-kr">
<link rel=stylesheet type="text/css" href="/include/table_t.css">
<script language='JavaScript' src='/include/common.js'></script>
<script language='javascript'>
<!--
	// Title 고정 
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
	function init() 
	{
		
		setupEvents();
	}
	
	//팝업윈도우 열기
	function parking_car(car_mng_id, io_gubun, park_id)
	
	{
		window.open("parking_check_frame.jsp?car_mng_id="+car_mng_id+"&io_gubun="+io_gubun+"&park_id="+park_id, "PARKING_CAR", "left=100, top=20, width=1000, height=900, scrollbars=auto");
	}
	
	function parking_del(c_id){
		var fm = document.form1;
		if(!confirm('매각출고차량 삭제 하시겠습니까?')){	return;	}
		fm.cmd.value = "md";	
	//	fm.car_mng_id.value = c_id;
		fm.target="i_no";
		fm.action="parking_check_a.jsp?car_mng_id="+c_id;	
		fm.submit();
}
	
	
//-->
</script>

<style>

.listnum2 a:link {color:#ff0000; text-decoration:underline;} 
.listnum2 a:visited {color:#ff0000; text-decoration:underline;} 
.listnum2 a:hover {color:#ff0000; text-decoration:underline;} 

</style>

</head>
<body onLoad="javascript:init()">
<form name='form1' action='' method='post'>
<input type='hidden' name='t_wd' value='<%=t_wd%>'>			 
<input type='hidden' name='s_kd'  value='<%=s_kd%>'>
<input type='hidden' name='sort_gubun' value="<%=sort_gubun%>"> 
<input type='hidden' name='asc' value='<%=asc%>'>

<input type='hidden' name='cmd' value=''>

<table border="0" cellspacing="0" cellpadding="0" width='100%'>
	<tr><td class=line2 colspan="2"></td></tr>
	<tr id='tr_title' style='position:relative;z-index:1'>
		<td class='line' id='td_title' style='position:relative;'>
			<table border="0" cellspacing="1" cellpadding="0" width='100%' height="43">
				<tr> 
					<td class='title' width="5%" >연번</td>
					<td class='title' width="15%" >차종</td>
					<td class='title' width="10%" >차량번호</td>
					<td class='title' width="15%" >차키</td>
					<td class='title' width="10%" >위치</td>
					<td class='title' width="20%" >FMS</td>
					<td class='title' width="10%" >메모</td>
					<td class='title' width="10%" >비고</td>
				
				</tr>
			</table>
		</td>
	</tr>
	<tr>
		<td class='line' id='td_con' style='position:relative;'>
			<table border="0" cellspacing="1" cellpadding="0" width='100%'>
<% 
    if ( vt_size > 0) { 		
		for(int i = 0 ; i < vt_size ; i++){
			Hashtable ht = (Hashtable)vt.elementAt(i);
			
			Hashtable ht2 = pk_db.getRentParkIOSearch(String.valueOf(ht.get("CAR_MNG_ID")), brid );
			String	c_id = String.valueOf(ht2.get("CAR_MNG_ID"));

%>         
				<tr>
					<td align="center" width="5%"><%=i+1%></td>
					<td align="center" width="15%"><%=ht.get("CAR_NM")%></td>
					<td align="center" width="10%"><%=ht.get("CAR_NO")%></td>
					<td align="center" width="15%"><%if(ht.get("CAR_KEY").equals("X")){%>
							<%=ht.get("CAR_KEY_CAU")%>
						<%}else if(ht.get("CAR_KEY").equals("O")){%>
							O
						<%}%></td>
					<td align="center" width="10%"><%if(ht.get("PARK_ID").equals("3")){%>부산지점<%}else if(ht.get("PARK_ID").equals("7")){%>부산부경<%}else if(ht.get("PARK_ID").equals("8")){%>부산조양<%}%><%=ht.get("AREA")%></td>
					<td align="center" width="20%"><%if(!ht.get("FIRM_NM").equals("(주)아마존카")){%><%=ht.get("FIRM_NM")%><%}else if(ht.get("RENT_ST_NM").equals("매각확정")){%>매각확정<%}%></td>
					<td align="center" width="10%">
									<%if(!ht.get("FIRM_NM").equals("(주)아마존카") && !ht.get("CLS_ST").equals("")) {%>
										<%=ht.get("USER_NM")%>
									<%}else if(!ht.get("FIRM_NM").equals("(주)아마존카") && ht.get("CLS_ST").equals("")){%>
										<%=ht.get("USER_NM")%>
									<%}%>
					</td>
					<td align="center" width="10%"><%if(ht.get("CAR_ST").equals("4")){%>월렌트<%}else if(ht.get("CAR_ST").equals("9")){%>신차<%}else if(ht.get("RENT_START_DT").equals("") && ht.get("CAR_GU").equals("0")){%>재리스<%}%><%if(!ht.get("IN_DT").equals("") && ht.get("CLS_ST").equals("")){%>임시회수<%}%><%if(!ht.get("CLS_ST").equals("")){%><%}%></td>
					
				</tr>
  
 <%  }
  }  else{	%>                    
			<tr>		
				<td class='line'>
					<table border="0" cellspacing="1" cellpadding="0" width='100%'>
						<tr> 
							<td align='center'>등록된 데이타가 없습니다</td>
						</tr>
					</table>
				</td>
			</tr>
 <%	}	%>		
			</table>
		</td>
	</tr>		
</table>
</form>
</body>
</html>


