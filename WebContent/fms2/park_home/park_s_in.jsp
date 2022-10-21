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
	String gubun = request.getParameter("gubun")==null?"":request.getParameter("gubun");
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
	
	vt = pk_db.getParkRealList(br_id, gubun, gubun1, start_dt, end_dt,  s_cc,  s_year,  s_kd, brid, t_wd ,sort_gubun, asc);
		
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
		fm.target="i_no";
		fm.action="parking_check_a.jsp?car_mng_id="+c_id;	
		fm.submit();
	}
	
	function MM_openBrWindow(theURL,winName,features) { //v2.0
		window.open(theURL,winName,features);
	}

	function parking_car_key(c_id){
		var fm = document.form1;
		if(!confirm('매각출고차량 삭제 하시겠습니까?')){	return;	}
		fm.cmd.value = "md";		
		fm.target="i_no";
		fm.action="parking_check_a.jsp?car_mng_id="+c_id;	
		fm.submit();
	}
	
	function input_km(car_mng_id, park_id, user_id)
	{
	
		var SUBWIN="/acar/off_ls_jh/off_ls_km_i.jsp?car_mng_id="+car_mng_id+"&user_id="+user_id+"&park_id="+park_id;	
		window.open(SUBWIN, "input_km", "left=100, top=100, width=500, height=300, scrollbars=yes");
	}
	
	//계약정보 보기
	function view_client(m_id, l_cd, r_st)
	{
		window.open("/fms2/con_fee/con_fee_client_s.jsp?m_id="+m_id+"&l_cd="+l_cd+"&r_st="+r_st, "VIEW_CLIENT", "left=100, top=100, width=820, height=700, scrollbars=yes");
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
<input type="hidden" name="auth_rw" value="<%=auth_rw%>">
<input type='hidden' name='t_wd' value='<%=t_wd%>'>			 
<input type='hidden' name='s_kd'  value='<%=s_kd%>'>
<input type='hidden' name='sort_gubun' value="<%=sort_gubun%>"> 
<input type='hidden' name='asc' value='<%=asc%>'>
<input type='hidden' name='user_id' value='<%=user_id%>'>
<input type='hidden' name='cmd' value=''>

<table border="0" cellspacing="0" cellpadding="0" width='100%'>
	<tr><td class=line2 colspan="2"></td></tr>
	<tr id='tr_title' style='position:relative;z-index:1'>
		<td class='line' id='td_title' style='position:relative;'>
			<table border="0" cellspacing="1" cellpadding="0" width='100%' height="43">
				<tr> 
					<td class='title' width="5%" >선택</td>
					<td class='title' width="5%" >연번</td>
					<td class='title' width="10%" >차종</td>
					<td class='title' width="8%" >차량번호</td>
					<td class='title' width="10%" >사진[등록일자]</td>
					<td class='title' width="9%" >구분</td>
					<td class='title' width="8%" >입고일자</td>
					<td class='title' width="7%" >상태</td>
					<td class='title' width="10%" >현위치</td>
					<td class='title' width="5%" >차키</td>
					<td class='title' width="7%" >배기량</td>
					<td class='title' width="8%" >연료</td>
					<td class='title' width="8%" >칼라</td>
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
			
			Hashtable ht2 = pk_db.getRentParkIOSearch(String.valueOf(ht.get("CAR_MNG_ID")), brid );  // 입/출고된 차량
			String	c_id = String.valueOf(ht2.get("CAR_MNG_ID"));

%>         
				<tr>
					<td align="center" width="5%"><!-- !String.valueOf(ht.get("PREPARE")).equals("매각") -->
					<%if(!String.valueOf(ht.get("CAR_ST")).equals("2") && String.valueOf(ht.get("PREPARE")).equals("예비") || !String.valueOf(ht.get("RENT_ST_NM")).equals("매각확정") ){%>
        	            <input type="checkbox" name="pr" value="<%=ht.get("CAR_ST")%>^<%=ht.get("PARK_NM")%>^<%=ht.get("CAR_MNG_ID")%>^<%=ht.get("CAR_NO")%>^<%=ht.get("CAR_NM")%>^<%=ht.get("RENT_S_CD")%>^<%=ht.get("DELI_DT")%>^<%=ht.get("INIT_REG_DT")%>">
						<%}%>
					</td>
					<td align="center" width="5%">
						<% if(String.valueOf(ht.get("PREPARE")).equals("예비") && String.valueOf(ht.get("RENT_ST_NM")).equals("입고")){%>
							<font color="blue" ><b><%=i+1%></font>
						<%}else if( String.valueOf(ht.get("CAR_MNG_ID")).equals(String.valueOf(ht2.get("CAR_MNG_ID"))) ){ %>
							<font color="red" ><b><%=i+1%></font>
						<%}else{%>
							<%=i+1%>
						<%}%>
					</td>
					<td align="center" width=10%>
						<% if(String.valueOf(ht.get("PREPARE")).equals("예비") && String.valueOf(ht.get("RENT_ST_NM")).equals("입고")){%><font color="blue"><b><%=ht.get("CAR_NM")%></font>
						<%}else if( String.valueOf(ht.get("CAR_MNG_ID")).equals(String.valueOf(ht2.get("CAR_MNG_ID"))) ){ %>
							<font color="red" ><b><%=ht.get("CAR_NM")%></font>
						<%}else{%>
							<%=ht.get("CAR_NM")%>
						<%}%>
					</td>
					<td align="center" width=8%>
						<% if(String.valueOf(ht.get("PREPARE")).equals("예비") && String.valueOf(ht.get("RENT_ST_NM")).equals("입고")){%>
							<font color="blue"><b><a href="javascript:parking_car('<%=ht.get("CAR_MNG_ID")%>', '1', '<%=ht.get("PARK_ID")%>' )" onMouseOver="window.status=''; return true"><%=Util.subData(String.valueOf(ht.get("CAR_NO")), 10)%></a></font>
						<%}else if( String.valueOf(ht.get("CAR_MNG_ID")).equals(String.valueOf(ht2.get("CAR_MNG_ID"))) ){ %>
							<span class=listnum2><b><a href="javascript:parking_car('<%=ht.get("CAR_MNG_ID")%>', '2', '<%=ht.get("PARK_ID")%>' )" onMouseOver="window.status=''; return true" hover><%=Util.subData(String.valueOf(ht.get("CAR_NO")), 10)%></a></span>
						<%}else{%>
							<a href="javascript:parking_car('<%=ht.get("CAR_MNG_ID")%>', '3', '<%=ht.get("PARK_ID")%>' )" onMouseOver="window.status=''; return true" hover><%=Util.subData(String.valueOf(ht.get("CAR_NO")), 10)%></a>
						<%}%>
					</td>
					<td align="center" width="10%">
					<%//if(user_id.equals("000096")){%>
						<%if(String.valueOf(ht.get("PIC_CNT")).equals("0")){%>
            			<a href="javascript:MM_openBrWindow('/acar/res_search/car_img_add_all.jsp?c_id=<%=ht.get("CAR_MNG_ID")%>&car_no=<%=ht.get("CAR_NO")%>','ImgAdd','scrollbars=no,status=yes,resizable=yes,width=820,height=650,left=50, top=50');"><img src=/acar/images/center/button_in_regp.gif align=absmiddle border=0></a>
                        <%}else{%>            
                        <a class=index1 href="javascript:MM_openBrWindow('/acar/secondhand_hp/bigimg.jsp?c_id=<%=ht.get("CAR_MNG_ID")%>','popwin0','scrollbars=no,status=no,resizable=yes,width=800,height=650,left=50, top=50')" title="차량사진 크게 보기"><img src="http://fms1.amazoncar.co.kr/images/photo_s.gif" width="17" height="15" border="0"></a>
            			<a href="javascript:MM_openBrWindow('/acar/res_search/car_img_add_all.jsp?c_id=<%=ht.get("CAR_MNG_ID")%>&car_no=<%=ht.get("CAR_NO")%>','ImgAdd','scrollbars=no,status=yes,resizable=yes,width=820,height=650,left=50, top=50');" align="right"><span title='사진 최근 등록(수정)일자, 사진 이미지에 있는 것은 촬영날짜입니다.'>[<%=ht.get("PIC_REG_DT")%>]</span></a>
                        <%}%>						
					<%//}%>
					</td>
					<td align="center" width="9%">
						<%if(String.valueOf(ht.get("PREPARE")).equals("예비") && String.valueOf(ht.get("CAR_MNG_ID")).equals(String.valueOf(ht2.get("CAR_MNG_ID")))){%>
							<font color="red"><b><%=ht.get("PREPARE")%></b></font> 
						<%}else if(String.valueOf(ht.get("PREPARE")).equals("예비") && !String.valueOf(ht.get("CAR_ST")).equals("2")){%>
							<font color="blue"><b><a href="javascript:view_client('<%=ht.get("RENT_MNG_ID")%>', '<%=ht.get("RENT_L_CD")%>', '1')" onMouseOver="window.status=''; return true" title='계약약식내역'>고객차량</a></b> &nbsp;<%if(AddUtil.parseInt(String.valueOf(ht.get("BB"))) > 0 ){%><font color =red >체크</font><%}%></font> 
						<%}else if(String.valueOf(ht.get("PREPARE")).equals("예비") && String.valueOf(ht.get("CAR_ST")).equals("4")){%>
							<font color="blue"><b>월레트고객</b></font>	
						<%}else if(String.valueOf(ht.get("PREPARE")).equals("매각")){%>
							<font color="blue"><b>매각</b></font> 
						<!--<%//}else if(String.valueOf(ht.get("PREPARE")).equals("예비") && String.valueOf(ht.get("RENT_ST_NM")).equals("입고")){%> -->
						<!--	<font color="red"><b>임시</b><%//=ht.get("PREPARE")%></font> -->
						<%}else if(!String.valueOf(ht.get("PREPARE")).equals("예비")){%>
							<font color="red"><b>임시</b><%=ht.get("PREPARE")%></font> 
						<%}else{%>
							<font color="#999999"><%=ht.get("PREPARE")%> 
							<%if(String.valueOf(ht.get("SECONDHAND")).equals("1")){%>(재리스)<%}%>
							</font>
						<%}%>
						
				   	</td>	   
          <td align="center" width="8%">
						<% if(String.valueOf(ht.get("PREPARE")).equals("예비") && String.valueOf(ht.get("RENT_ST_NM")).equals("입고")){%><font color="blue"><b><%=AddUtil.ChangeDate2(String.valueOf(ht.get("IO_DT")))%></font>
						<%}else if( String.valueOf(ht.get("CAR_MNG_ID")).equals(String.valueOf(ht2.get("CAR_MNG_ID"))) ){ %>
							<font color="red" ><b><%=AddUtil.ChangeDate2(String.valueOf(ht.get("IO_DT")))%></font>
						<%}else{%><%=AddUtil.ChangeDate2(String.valueOf(ht.get("IO_DT")))%><%}%>
					</td>				   	
			  		<td align="center" width=7%>
						<% if(String.valueOf(ht.get("PREPARE")).equals("예비") && String.valueOf(ht.get("RENT_ST_NM")).equals("입고")){%><font color="blue"><b><%=ht.get("RENT_ST_NM")%></font>
						<%}else if( String.valueOf(ht.get("CAR_MNG_ID")).equals(String.valueOf(ht2.get("CAR_MNG_ID"))) ){ %>
							<font color="red" ><b>출고</font>
						<%}else{%>
						<%=ht.get("RENT_ST_NM")%><%}%>
						<%if(String.valueOf(ht.get("RENT_ST_NM")).equals("매각확정")){%>
						<a href="javascript:input_km('<%=ht.get("CAR_MNG_ID")%>','<%=ht.get("PARK_ID")%>','<%=user_id%>');" onMouseOver="window.status=''; return true" ><img src="/acar/images/center/button_in_delete.gif"  align="absmiddle" border="0"> </a>
						<%}%>
						
					</td>	
					<td align="center" width=10%>
						<% if(String.valueOf(ht.get("PREPARE")).equals("예비") && String.valueOf(ht.get("RENT_ST_NM")).equals("입고")){%>
							<font color="blue"><b>
								<%if(String.valueOf(ht.get("CAR_STAT")).equals("예약")){%>
									<font color="#999999"><%=ht.get("PARK_NM")%></font> 
								<%}else if(String.valueOf(ht.get("CAR_STAT")).equals("")){%>
									<%=ht.get("PARK_NM")%>
								<%}else{%>
									<font color="black"><%=ht.get("PARK_NM")%><%//=Util.subData(String.valueOf(ht.get("PARK_NM")), 5)%></font> 
								<%}%>		
							</font>
						<%}else if( String.valueOf(ht.get("CAR_MNG_ID")).equals(String.valueOf(ht2.get("CAR_MNG_ID"))) ){ %>
							<font color="red"><b>
								<%if(String.valueOf(ht.get("CAR_STAT")).equals("예약")){%>
									<%=ht.get("PARK_NM")%>
								<%}else if(String.valueOf(ht.get("CAR_STAT")).equals("")){%>
									<%=ht.get("PARK_NM")%>
								<%}else{%>
									<%=ht.get("PARK_NM")%>
								<%}%>		
							</font>
						<%}else{%>
							<%if(String.valueOf(ht.get("CAR_STAT")).equals("예약")){%>
								<font color="#999999"><%=ht.get("PARK_NM")%></font> 
							<%}else if(String.valueOf(ht.get("CAR_STAT")).equals("")){%>
							<%=ht.get("PARK_NM")%>
							<%}else{%>
								<font color="black"><%=ht.get("PARK_NM")%></font> 
							<%}%>		
						<%}%>
						<%-- <a href="javascript:MM_openBrWindow('park_area.jsp?auth_rw=<%=auth_rw%>&c_id=<%=ht.get("CAR_MNG_ID")%>&car_no=<%=ht.get("CAR_NO")%>','CarPark','scrollbars=no,status=yes,resizable=yes,width=520,height=150,left=50, top=50')"> --%>
						<a href="javascript:MM_openBrWindow('park_area.jsp?auth_rw=<%=auth_rw%>&c_id=<%=ht.get("CAR_MNG_ID")%>&car_no=<%=ht.get("CAR_NO")%>&park_nm=<%=ht.get("PARK_NM")%>','CarPark','scrollbars=no,status=yes,resizable=yes,width=520,height=150,left=50, top=50')">
						<%=ht.get("AREA")%>
						</a>
					</td>
					<td align="center" width="5%">
						<a  href="javascript:MM_openBrWindow('park_car_key.jsp?auth_rw=<%=auth_rw%>&c_id=<%=ht.get("CAR_MNG_ID")%>&car_no=<%=ht.get("CAR_NO")%>','CarPark','scrollbars=no,status=yes,resizable=yes,width=520,height=150,left=50, top=50')">
						<%=ht.get("CAR_KEY")%>
						</a>					
					
					</td>
					<td align="center" width="7%">
						<% if(String.valueOf(ht.get("PREPARE")).equals("예비") && String.valueOf(ht.get("RENT_ST_NM")).equals("입고")){%><font color="blue"><b><%=ht.get("DPM")%>cc</font>
						<%}else if( String.valueOf(ht.get("CAR_MNG_ID")).equals(String.valueOf(ht2.get("CAR_MNG_ID"))) ){ %>
							<font color="red" ><b><%=ht.get("DPM")%>cc</font>
						<%}else{%><%=ht.get("DPM")%>cc<%}%>
					</td>
					<td align="center" width="8%">
					<% if(String.valueOf(ht.get("PREPARE")).equals("예비") && String.valueOf(ht.get("RENT_ST_NM")).equals("입고")){%>
							<font color="blue"><b><%=ht.get("FUEL_KD")%></font>
						<%}else if( String.valueOf(ht.get("CAR_MNG_ID")).equals(String.valueOf(ht2.get("CAR_MNG_ID"))) ){ %>
							<font color="red" ><b><%=ht.get("FUEL_KD")%></font>
						<%}else{%><%=ht.get("FUEL_KD")%><%}%>
					</td>
					<td align="center" width="8%">
						<% if(String.valueOf(ht.get("PREPARE")).equals("예비") && String.valueOf(ht.get("RENT_ST_NM")).equals("입고")){%>
							<font color="blue"><b><span title='<%=ht.get("COLO")%>'><%=Util.subData(String.valueOf(ht.get("COLO")), 4)%></span></font>
						<%}else if( String.valueOf(ht.get("CAR_MNG_ID")).equals(String.valueOf(ht2.get("CAR_MNG_ID"))) ){ %>
							<font color="red" ><b><span title='<%=ht.get("COLO")%>'><%=Util.subData(String.valueOf(ht.get("COLO")), 4)%></span></font>
						<%}else{%><span title='<%=ht.get("COLO")%>'><%=Util.subData(String.valueOf(ht.get("COLO")), 4)%></span><%}%>
					</td>
					
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


